

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

# Export variables after collecting input
export ZONE


gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export REGION=${ZONE%-*}

gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE


gsutil cp gs://spls/gsp497/gke-monitoring-tutorial.zip .
unzip gke-monitoring-tutorial.zip

cd gke-monitoring-tutorial

make create


make validate

make teardown


