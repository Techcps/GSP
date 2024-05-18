

export AR_REPO='chef-repo'

export SERVICE_NAME='chef-streamlit-app'

gcloud artifacts repositories create $AR_REPO --repository-format=docker --location=$REGION


gcloud builds submit --tag="$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$AR_REPO/$SERVICE_NAME"


gcloud run deploy "$SERVICE_NAME" --image="$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$AR_REPO/$SERVICE_NAME" --port=8080 --platform=managed --region=$REGION --project=$DEVSHELL_PROJECT_ID --set-env-vars=PROJECT=$DEVSHELL_PROJECT_ID,REGION=$REGION --allow-unauthenticated


gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$DEVSHELL_PROJECT_ID \
  --set-env-vars=GCP_PROJECT=$DEVSHELL_PROJECT_ID,GCP_REGION=$REGION

