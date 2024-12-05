
echo "Please set the below values correctly"
read -p "Enter the BUCKET_NAME: " BUCKET_NAME

gcloud storage buckets update gs://$BUCKET_NAME --no-uniform-bucket-level-access

gcloud storage buckets update gs://$BUCKET_NAME --web-main-page-suffix=index.html --web-error-page=error.html

gcloud storage objects update gs://$BUCKET_NAME/index.html --add-acl-grant=entity=AllUsers,role=READER

gcloud storage objects update gs://$BUCKET_NAME/error.html --add-acl-grant=entity=AllUsers,role=READER

