

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud compute instances create blue --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=web-server,http-server --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


gcloud compute instances create green --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=web-server,http-server --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


gcloud compute firewall-rules create allow-http-web-server --project=$DEVSHELL_PROJECT_ID --direction=INGRESS --priority=1000 --network=default --action=ALLOW --target-tags=web-server --rules=tcp:80,icmp --source-ranges=0.0.0.0/0 && gcloud compute instances create test-vm --machine-type=f1-micro --subnet=default --zone=$ZONE

gcloud iam service-accounts create network-admin  --project=$DEVSHELL_PROJECT_ID --display-name="Network-admin" && gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=roles/compute.networkAdmin && gcloud iam service-accounts keys create credentials.json --iam-account=network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com


cat > blues.sh <<'EOF_CP'
sudo apt-get install nginx-light -y
sudo sed -i "14c\<h1>Welcome to the blue server!</h1>" /var/www/html/index.nginx-debian.html
EOF_CP

gcloud compute scp blues.sh blue:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh blue --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/blues.sh" --ssh-flag="-o ConnectTimeout=60"


cat > greens.sh <<'EOF_CP'
sudo apt-get install nginx-light -y
sudo sed -i "14c\<h1>Welcome to the green server!</h1>" /var/www/html/index.nginx-debian.html
EOF_CP

gcloud compute scp greens.sh green:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh green --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/greens.sh"


gcloud compute instances stop test-vm --zone $ZONE

sleep 30

gcloud compute instances set-service-account test-vm --project=$DEVSHELL_PROJECT_ID --service-account network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --zone $ZONE


gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.networkAdmin" && gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.securityAdmin"

