

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud compute networks create vpc-net --project=$DEVSHELL_PROJECT_ID --description="Subscribe to Techcps" --subnet-mode=custom && gcloud compute networks subnets create vpc-subnet --project=$DEVSHELL_PROJECT_ID --network=vpc-net --region=$REGION --range=10.1.3.0/24 --enable-flow-logs


sleep 30


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create allow-http-ssh --direction=INGRESS --priority=1000 --network=vpc-net --action=ALLOW --rules=tcp:80,tcp:22 --source-ranges=0.0.0.0/0 --target-tags=http-server


gcloud compute instances create web-server --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-subnet --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=web-server,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240515,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --no-shielded-vtpm --no-shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

sleep 100

cat > cp.sh <<'EOF_CP'

sudo apt-get update

sudo apt-get install apache2 -y

echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html
EOF_CP

gcloud compute scp cp.sh web-server:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh web-server --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp.sh" --ssh-flag="-o ConnectTimeout=60"


bq mk bq_vpcflows


CP_IP=$(gcloud compute instances describe web-server --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

export MY_SERVER=$CP_IP

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done


echo "Open Firewall link"
echo "https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/allow-http-ssh?project=$DEVSHELL_PROJECT_ID"

echo "Open Sink link"
echo "https://console.cloud.google.com/logs/query;query=resource.type%3D%22gce_subnetwork%22%0Alog_name%3D%22projects%2F$DEVSHELL_PROJECT_ID%2Flogs%2Fcompute.googleapis.com%252Fvpc_flows%22;cursorTimestamp=2024-06-03T07:20:00.734122029Z;duration=PT1H?project=$DEVSHELL_PROJECT_ID"

