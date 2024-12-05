
echo "Please set the below values correctly"
read -p "Enter the BUCKET_NAME: " BUCKET_NAME

curl -LO https://raw.githubusercontent.com/Techcps/GSP/master/mini%20lab%20%3A%20Cloud%20Storage%20%3A%202/lifecycle.json

gsutil lifecycle set lifecycle.json gs://$BUCKET_NAME

