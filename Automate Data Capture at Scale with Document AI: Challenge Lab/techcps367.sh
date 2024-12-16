

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION
read -p "${YELLOW}${BOLD}Enter the PROCESSOR: ${RESET}" PROCESSOR

# Export variables after collecting input
export REGION PROCESSOR


gcloud auth list

export PROJECT_ID=$(gcloud config get-value core/project)

gcloud services enable documentai.googleapis.com --project $DEVSHELL_PROJECT_ID

sleep 10


  mkdir ./document-ai-challenge
  gsutil -m cp -r gs://spls/gsp367/* \
    ~/document-ai-challenge/




ACCESS_CP=$(gcloud auth application-default print-access-token)

curl -X POST \
  -H "Authorization: Bearer $ACCESS_CP" \
  -H "Content-Type: application/json" \
  -d '{
    "display_name": "'"$PROCESSOR"'",
    "type": "FORM_PARSER_PROCESSOR"
  }' \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors"


gsutil mb -c standard -l $REGION -b on gs://$PROJECT_ID-input-invoices

gsutil mb -c standard -l $REGION -b on gs://$PROJECT_ID-output-invoices

gsutil mb -c standard -l $REGION -b on gs://$PROJECT_ID-archived-invoices




bq --location=US mk  -d \
 --description "Form Parser Results" \
 ${PROJECT_ID}:invoice_parser_results
 
cd ~/document-ai-challenge/scripts/table-schema
 
bq mk --table \
invoice_parser_results.doc_ai_extracted_entities \
doc_ai_extracted_entities.json



cd ~/document-ai-challenge/scripts

PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')

SERVICE_ACCOUNT=$(gcloud storage service-agent --project=$PROJECT_ID)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher


export CLOUD_FUNCTION_LOCATION=$REGION

echo $CLOUD_FUNCTION_LOCATION

sleep 30

#!/bin/bash

deploy_function() {
  gcloud functions deploy process-invoices \
  --gen2 \
  --region=${CLOUD_FUNCTION_LOCATION} \
  --entry-point=process_invoice \
  --runtime=python39 \
  --service-account=${PROJECT_ID}@appspot.gserviceaccount.com \
  --source=cloud-functions/process-invoices \
  --timeout=400 \
  --env-vars-file=cloud-functions/process-invoices/.env.yaml \
  --trigger-resource=gs://${PROJECT_ID}-input-invoices \
  --trigger-event=google.storage.object.finalize\
  --service-account $PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --allow-unauthenticated
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully..[https://www.youtube.com/@techcps]"
    deploy_success=true
  else
    echo "Deployment Retrying, please subscribe to techcps..[https://www.youtube.com/@techcps]"
    sleep 10
  fi
done




PROCESSOR_ID=$(curl -X GET \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json" \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors" | \
  grep '"name":' | \
  sed -E 's/.*"name": "projects\/[0-9]+\/locations\/us\/processors\/([^"]+)".*/\1/')


export PROCESSOR_ID
echo $PROCESSOR_ID

export CLOUD_FUNCTION_LOCATION=$REGION
echo $CLOUD_FUNCTION_LOCATION

export PROJECT_ID=$(gcloud config get-value core/project)
echo $PROJECT_ID

gcloud functions deploy process-invoices \
  --gen2 \
  --region=${CLOUD_FUNCTION_LOCATION} \
  --entry-point=process_invoice \
  --runtime=python39 \
  --service-account=${PROJECT_ID}@appspot.gserviceaccount.com \
  --source=cloud-functions/process-invoices \
  --timeout=400 \
  --trigger-resource=gs://${PROJECT_ID}-input-invoices \
  --trigger-event=google.storage.object.finalize \
  --update-env-vars=PROCESSOR_ID=${PROCESSOR_ID},PARSER_LOCATION=us,PROJECT_ID=${PROJECT_ID} \
  --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com


export PROJECT_ID=$(gcloud config get-value core/project)
gsutil -m cp -r gs://cloud-training/gsp367/* \
~/document-ai-challenge/invoices gs://${PROJECT_ID}-input-invoices/



