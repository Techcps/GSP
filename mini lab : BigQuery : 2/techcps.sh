

echo "Please set the below values correctly"
read -p "Enter the REGION: " REGION

export PROJECT_ID=$(gcloud config get-value project)

bq mk --connection --connection_type='CLOUD_SPANNER' --properties='{"database":"projects/'$PROJECT_ID'/instances/ecommerce-instance/databases/ecommerce"}' --project_id=$PROJECT_ID --location=$REGION my_connection_id

bq query --use_legacy_sql=false "SELECT * FROM EXTERNAL_QUERY('$PROJECT_ID.$REGION.my_connection_id', 'SELECT * FROM orders;');"

bq query --use_legacy_sql=false "CREATE VIEW ecommerce.order_history AS SELECT * FROM EXTERNAL_QUERY('$PROJECT_ID.$REGION.my_connection_id', 'SELECT * FROM orders;');"

