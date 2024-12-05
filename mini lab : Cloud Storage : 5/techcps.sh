
echo "Please set the below values correctly"
read -p "Enter the BUCKET_NAME: " BUCKET_NAME

gsutil iam ch -d allUsers gs://$BUCKET_NAME

