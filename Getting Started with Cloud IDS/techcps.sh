
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project | sed '2d')

gcloud services enable servicenetworking.googleapis.com \
    --project=$PROJECT_ID

gcloud services enable ids.googleapis.com \
    --project=$PROJECT_ID

gcloud services enable logging.googleapis.com \
    --project=$PROJECT_ID

gcloud compute networks create cloud-ids \
--subnet-mode=custom

gcloud compute networks subnets create cloud-ids-useast1 \
--range=192.168.10.0/24 \
--network=cloud-ids \
--region=us-east1

gcloud compute addresses create cloud-ids-ips \
--global \
--purpose=VPC_PEERING \
--addresses=10.10.10.0 \
--prefix-length=24 \
--description="Cloud IDS Range" \
--network=cloud-ids

gcloud services vpc-peerings connect \
--service=servicenetworking.googleapis.com \
--ranges=cloud-ids-ips \
--network=cloud-ids \
--project=$PROJECT_ID

gcloud services vpc-peerings connect \
--service=servicenetworking.googleapis.com \
--ranges=cloud-ids-ips \
--network=cloud-ids \
--project=$PROJECT_ID


gcloud ids endpoints create cloud-ids-east1 \
--network=cloud-ids \
--zone=us-east1-b \
--severity=INFORMATIONAL \
--async

gcloud ids endpoints list --project=$PROJECT_ID

gcloud compute firewall-rules create allow-http-icmp \
--direction=INGRESS \
--priority=1000 \
--network=cloud-ids \
--action=ALLOW \
--rules=tcp:80,icmp \
--source-ranges=0.0.0.0/0 \
--target-tags=server

gcloud compute firewall-rules create allow-iap-proxy \
--direction=INGRESS \
--priority=1000 \
--network=cloud-ids \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=35.235.240.0/20

gcloud compute routers create cr-cloud-ids-useast1 \
--region=us-east1 \
--network=cloud-ids

gcloud compute routers nats create nat-cloud-ids-useast1 \
--router=cr-cloud-ids-useast1 \
--router-region=us-east1 \
--auto-allocate-nat-external-ips \
--nat-all-subnet-ip-ranges

gcloud compute instances create server \
--zone=us-east1-b \
--machine-type=e2-medium \
--subnet=cloud-ids-useast1 \
--no-address \
--private-network-ip=192.168.10.20 \
--metadata=startup-script=\#\!\ /bin/bash$'\n'sudo\ apt-get\ update$'\n'sudo\ apt-get\ -qq\ -y\ install\ nginx \
--tags=server \
--image=debian-11-bullseye-v20240709 \
--image-project=debian-cloud \
--boot-disk-size=10GB

gcloud compute instances create attacker \
--zone=us-east1-b \
--machine-type=e2-medium \
--subnet=cloud-ids-useast1 \
--no-address \
--private-network-ip=192.168.10.10 \
--image=debian-11-bullseye-v20240709 \
--image-project=debian-cloud \
--boot-disk-size=10GB


cat > cp_disk.sh <<'EOF_CP'

sudo systemctl status nginx

cd /var/www/html/

sudo touch eicar.file

echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' | sudo tee eicar.file

EOF_CP


gcloud compute scp cp_disk.sh server:/tmp --project=$DEVSHELL_PROJECT_ID --zone=us-east1-b --quiet

gcloud compute ssh server --project=$DEVSHELL_PROJECT_ID --zone=us-east1-b --quiet --command="bash /tmp/cp_disk.sh"

echo "Click this link to open.[https://console.cloud.google.com/net-security/ids/list?referrer=search&cloudshell=true&project=$DEVSHELL_PROJECT_ID]"
