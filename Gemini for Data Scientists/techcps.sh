

gcloud auth list

PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}


gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/aiplatform.notebookRuntimeUser
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/dataform.codeEditor


CLOUD_BUILD_SERVICE_ACCOUNT="${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$CLOUD_BUILD_SERVICE_ACCOUNT \
  --role roles/aiplatform.notebookRuntimeUser
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$CLOUD_BUILD_SERVICE_ACCOUNT \
  --role roles/dataform.codeEditor
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$CLOUD_BUILD_SERVICE_ACCOUNT \
  --role roles/compute.admin


bq mk --dataset --location=US ecommerce


