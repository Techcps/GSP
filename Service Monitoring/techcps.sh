


# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION

# Export variables after collecting input
export REGION

gcloud auth list

git clone https://github.com/haggman/HelloLoggingNodeJS.git

cd HelloLoggingNodeJS

gcloud app create --region=$REGION

gcloud app deploy --quiet


cat > email-channel.json <<EOF_CP
{
  "type": "email",
  "displayName": "techcps",
  "description": "Subscribe to techcps",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_CP

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

echo ""

echo "Click the below link to create an availability SLO"

echo "${YELLOW}${BOLD}Click Here...[https://console.cloud.google.com/monitoring/services?invt=AbknMg&project=$DEVSHELL_PROJECT_ID]${RESET}"

echo ""


