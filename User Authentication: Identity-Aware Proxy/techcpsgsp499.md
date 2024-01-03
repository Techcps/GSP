
# User Authentication: Identity-Aware Proxy [GSP499]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
gcloud auth list
gcloud config list project
gsutil cp gs://spls/gsp499/user-authentication-with-iap.zip .
unzip user-authentication-with-iap.zip
cd user-authentication-with-iap
gcloud services disable appengineflex.googleapis.com
cd 1-HelloWorld
gcloud app deploy
cd ~/user-authentication-with-iap/2-HelloUser
gcloud app deploy
cd ~/user-authentication-with-iap/3-HelloVerifiedUser
gcloud app deploy
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
```
# Note:
## Numeric choice value - Go to Task 1:
* Point No.2 and Select a region value using lab instructions

## Provide your confirmation type: Y and Enter (follow same process 3 times)

# Task 1: Under
*  "Restrict access with IAP" perform using lab instructions
*  "Test that IAP is turned on" perform using lab instructions

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
