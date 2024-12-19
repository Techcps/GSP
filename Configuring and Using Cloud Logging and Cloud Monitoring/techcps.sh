

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

# Export variables after collecting input
export ZONE


export DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

curl https://storage.googleapis.com/cloud-training/gcpsec/labs/stackdriver-lab.tgz | tar -zxf -

cd stackdriver-


curl -LO https://raw.githubusercontent.com/Techcps/GSP/master/Configuring%20and%20Using%20Cloud%20Logging%20and%20Cloud%20Monitoring/stackdriver-lab/linux_startup.sh

curl -LO https://raw.githubusercontent.com/Techcps/GSP/master/Configuring%20and%20Using%20Cloud%20Logging%20and%20Cloud%20Monitoring/stackdriver-lab/setup.sh

sed -i 's/us-west1-b/$ZONE/g' setup.sh

./setup.sh


bq mk --dataset project_logs

sleep 20

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

SERVICE_ACCOUNT="linux-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/bigquery.dataEditor"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:service-$PROJECT_NUMBER@gcp-sa-logging.iam.gserviceaccount.com" \
    --role="roles/bigquery.dataEditor"


gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID \
    --flatten="bindings[].members" \
    --format="table(bindings.role)" \
    --filter="bindings.members:service-$PROJECT_NUMBER@gcp-sa-logging.iam.gserviceaccount.com"


TABLE_ID=$(bq ls --project_id $DEVSHELL_PROJECT_ID --dataset_id project_logs --format=json | jq -r '.[0].tableReference.tableId')


bq query --use_legacy_sql=false \
"
SELECT
  logName, resource.type, resource.labels.zone, resource.labels.project_id,
FROM
  \`$DEVSHELL_PROJECT_ID.project_logs.$TABLE_ID\`
"

gcloud alpha logging sinks create vm_logs bigquery.googleapis.com/projects/$DEVSHELL_PROJECT_ID/datasets/project_logs --log-filter='resource.type="gce_instance"'

gcloud alpha logging sinks create load_bal_logs bigquery.googleapis.com/projects/$DEVSHELL_PROJECT_ID/datasets/project_logs --log-filter='resource.type="http_load_balancer"'

gcloud logging read "resource.type=gce_instance AND logName=projects/$DEVSHELL_PROJECT_ID/logs/syslog AND textPayload:SyncAddress" --limit 10 --format json

gcloud logging metrics create 403s \
    --project=$DEVSHELL_PROJECT_ID \
    --description="Subscribe to techcps" \
    --log-filter='resource.type="gce_instance" AND log_name="projects/'$DEVSHELL_PROJECT_ID'/logs/syslog"'


