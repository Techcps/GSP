
gcloud auth list

PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"

gcloud config set compute/region $REGION
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer


gcloud container clusters create-auto gemini-demo --region $REGION

kubectl create deployment hello-server --image=us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0

kubectl expose deployment hello-server --type=LoadBalancer --port=80 --target-port=8080

kubectl get service hello-server -o jsonpath='{.status.loadBalancer.ingress[*].ip}'

kubectl get service hello-server

sleep 120

kubectl get service hello-server

CP=$(kubectl get service hello-server -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://$CP"


