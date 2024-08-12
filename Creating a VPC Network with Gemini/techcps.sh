

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"

export PROJECT_ID=$DEVSHELL_PROJECT_ID
gcloud config set project $DEVSHELL_PROJECT_ID

gcloud config set compute/region $REGION
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer


gcloud compute networks create privatenet --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --enable-ula-internal-ipv6 --bgp-routing-mode=regional --mtu=1460


gcloud compute networks subnets create privatenet-subnet-us --project=$DEVSHELL_PROJECT_ID --region=$REGION --stack-type=IPV4_IPV6 --ipv6-access-type=INTERNAL --network=privatenet --range=10.130.0.0/20


echo "Congratulations, you're all done with the lab"
echo "Please like share and subscribe to techcps(https://www.youtube.com/@techcps)..."

