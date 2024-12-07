

echo "Please set the below values correctly"
read -p "Enter the BUCKET: " BUCKET
read -p "Enter the REGION: " REGION
read -p "Enter the BUCKET_NAME: " BUCKET_NAME


gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION

gcloud storage cp --recursive gs://$BUCKET/* gs://$BUCKET_NAME

gcloud storage buckets update gs://$BUCKET_NAME --no-uniform-bucket-level-access

gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME --member=allUsers --role=roles/storage.admin

gcloud storage buckets update gs://$BUCKET_NAME --web-main-page-suffix=index.html --web-error-page=error.html

gcloud compute addresses create example-ip --network-tier=PREMIUM --ip-version=IPV4 --global

gcloud compute addresses describe example-ip --format="get(address)" --global

gcloud compute backend-buckets create cp-backend-bucket --gcs-bucket-name=$BUCKET_NAME

gcloud compute url-maps create cp-load-balancer --default-backend-bucket=cp-backend-bucket

gcloud compute target-http-proxies create cp-tp --url-map=cp-load-balancer

gcloud compute forwarding-rules create cp-ff --load-balancing-scheme=EXTERNAL --network-tier=PREMIUM --target-http-proxy=cp-tp --ports=80 --address=example-ip --global

sleep 30

IP_ADDRESS=$(gcloud compute addresses describe example-ip --format="get(address)" --global)

echo "This is IP address: $IP_ADDRESS"

curl http://$IP_ADDRESS

