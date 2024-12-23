



# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the PROJECT_MONITORING: ${RESET}" PROJECT_MONITORING
read -p "${YELLOW}${BOLD}Enter the PROJECT_WORKER1: ${RESET}" PROJECT_WORKER1
read -p "${YELLOW}${BOLD}Enter the PROJECT_WORKER2: ${RESET}" PROJECT_WORKER2
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

export PROJECT_MONITORING PROJECT_WORKER1 PROJECT_WORKER2 ZONE

gcloud auth list


gcloud config set project $PROJECT_WORKER1
gcloud compute instances create worker-1-server --project=$PROJECT_WORKER1 --zone=$ZONE --machine-type=e2-medium --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --tags=http-server

gcloud compute firewall-rules create allow-http --allow tcp:80 --project=$PROJECT_WORKER1 --target-tags=http-server --description="Allow HTTP traffic"


gcloud config set project $PROJECT_WORKER2
gcloud compute instances create worker-2-server --project=$PROJECT_WORKER2 --zone=$ZONE --machine-type=e2-medium --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --tags=http-server

gcloud compute firewall-rules create allow-http2 --allow tcp:80 --project=$PROJECT_WORKER2 --target-tags=http-server --description="Allow HTTP traffic"


gcloud config set project $PROJECT_WORKER1
cat > cp_disk.sh <<'EOF_CP'
sudo apt-get update
sudo apt-get install -y nginx
ps auwx | grep nginx
EOF_CP

gcloud compute scp cp_disk.sh worker-1-server:/tmp --project=$PROJECT_WORKER1 --zone=$ZONE --quiet

gcloud compute ssh worker-1-server --project=$PROJECT_WORKER1 --zone=$ZONE --quiet --command="bash /tmp/cp_disk.sh"


gcloud config set project $PROJECT_WORKER2
cat > cp_disk.sh <<'EOF_CP'
sudo apt-get update
sudo apt-get install -y nginx
ps auwx | grep nginx
EOF_CP

gcloud compute scp cp_disk.sh worker-2-server:/tmp --project=$PROJECT_WORKER2 --zone=$ZONE --quiet

gcloud compute ssh worker-2-server --project=$PROJECT_WORKER2 --zone=$ZONE --quiet --command="bash /tmp/cp_disk.sh"


gcloud config set project $PROJECT_WORKER1  
gcloud iam service-accounts create worker-1-server \
  --description="Service account for Worker 1 Server" \
  --display-name="worker-1-server"


gcloud config set project $PROJECT_WORKER2
gcloud iam service-accounts create worker-2-server \
  --description="Service account for  Worker 2 Server" \
   --display-name="worker-2-server"  


gcloud config set project $PROJECT_MONITORING
gcloud projects add-iam-policy-binding $PROJECT_WORKER1 \
  --member="serviceAccount:worker-1-server@$PROJECT_WORKER1.iam.gserviceaccount.com" \
  --role="roles/monitoring.viewer"

gcloud projects add-iam-policy-binding $PROJECT_WORKER2 \
  --member="serviceAccount:worker-2-server@$PROJECT_WORKER2.iam.gserviceaccount.com" \
  --role="roles/monitoring.viewer"



gcloud config set project $PROJECT_WORKER1  
gcloud compute instances add-labels worker-1-server --project=$PROJECT_WORKER1 --zone=$ZONE --labels=component=frontend,stage=dev

gcloud config set project $PROJECT_WORKER2
gcloud compute instances add-labels worker-2-server --project=$PROJECT_WORKER2 --zone=$ZONE --labels=component=frontend,stage=test


gcloud config set project $PROJECT_MONITORING
cat > email-channel.json <<EOF_CP
{
  "type": "email",
  "displayName": "techcps",
  "description": "Subscribe to techcps",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_CP

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

