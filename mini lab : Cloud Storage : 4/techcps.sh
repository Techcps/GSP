
echo "Please set the below values correctly"
read -p "Enter the BUCKET_NAME: " BUCKET_NAME

gcloud storage objects update gs://$BUCKET_NAME/index.html --content-type=text/html

