
echo "Please set the below values correctly"
read -p "Enter the BUCKET_NAME: " BUCKET_NAME

curl -LO raw.githubusercontent.com/Techcps/GSP/master/mini%20lab%20%3A%20Cloud%20Storage%20%3A%206/cors-config.json

gcloud storage buckets update gs://$BUCKET_NAME --cors-file=cors-config.json
