




gcloud auth list

gcloud config list project

gsutil cp gs://spls/gsp499/user-authentication-with-iap.zip .

unzip user-authentication-with-iap.zip

cd user-authentication-with-iap

gcloud services disable appengineflex.googleapis.com

cd 1-HelloWorld

sed -i 's/python37/python39/g' app.yaml

#!/bin/bash

deploy_function() {
  gcloud app deploy
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully."
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps (https://www.youtube.com/@techcps)..."
    sleep 10
  fi
done

cd ~/user-authentication-with-iap/2-HelloUser


sed -i 's/python37/python39/g' app.yaml

#!/bin/bash

deploy_function() {
  gcloud app deploy
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully."
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps (https://www.youtube.com/@techcps)..."
    sleep 10
  fi
done

cd ~/user-authentication-with-iap/3-HelloVerifiedUser

sed -i 's/python37/python39/g' app.yaml

#!/bin/bash

deploy_function() {
  gcloud app deploy
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully."
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps (https://www.youtube.com/@techcps)..."
    sleep 10
  fi
done

LINK=$(gcloud app browse)

LINKU=${LINK#https://}

cat > details.json << EOF
{
  App name: IAP Example
  Application home page: $LINK
  Application privacy Policy link: $LINK/privacy
  Authorized domains: $LINKU
  Developer Contact Information: techcps@gmail.com
}
EOF
cat details.json

