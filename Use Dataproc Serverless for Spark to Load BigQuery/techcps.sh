

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud compute networks subnets update default --region=$REGION --enable-private-ip-google-access

gsutil mb -p  $PROJECT_ID gs://$PROJECT_ID

gsutil mb -p  $PROJECT_ID gs://$PROJECT_ID-bqtemp

bq mk -d  loadavro

echo "export REGION=$REGION" > techcps1.sh
echo "export PROJECT_ID=$DEVSHELL_PROJECT_ID" >> techcps1.sh

source techcps1.sh

cat > cp.sh <<'EOF_CP'
source /tmp/techcps1.sh

wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro

gcloud storage cp campaigns.avro gs://$PROJECT_ID

wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/dataproc-templates.zip

unzip dataproc-templates.zip

cd dataproc-templates/python

export GCP_PROJECT=$PROJECT_ID
export REGION=$REGION
export GCS_STAGING_LOCATION=gs://$PROJECT_ID
export JARS=gs://cloud-training/dataengineering/lab_assets/idegc/spark-bigquery_2.12-20221021-2134.jar

sleep 45

./bin/start.sh \
-- --template=GCSTOBIGQUERY \
    --gcs.bigquery.input.format="avro" \
    --gcs.bigquery.input.location="gs://$PROJECT_ID" \
    --gcs.bigquery.input.inferschema="true" \
    --gcs.bigquery.output.dataset="loadavro" \
    --gcs.bigquery.output.table="campaigns" \
    --gcs.bigquery.output.mode=overwrite\
    --gcs.bigquery.temp.bucket.name="$PROJECT_ID-bqtemp"

bq query \
 --use_legacy_sql=false \
 'SELECT * FROM `loadavro.campaigns`;'

EOF_CP

ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

gcloud compute scp techcps1.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute scp cp.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp.sh"

