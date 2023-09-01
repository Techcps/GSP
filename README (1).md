
# Develop and Secure APIs with Apigee X: Challenge Lab


A brief description of what this project does and who it's for


## 🔗 Task 1 Solution: Proxy the Cloud Translation API
In the GCP Console open the Cloud Shell and enter the following commands:


# Develop and Secure APIs with Apigee X: Challenge Lab


A brief description of what this project does and who it's for

```
# Enable prerequisite APIs
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable apigee.googleapis.com

# Enable Cloud Translation API
gcloud services enable translate.googleapis.com

# Enable IAM API
gcloud services enable iam.googleapis.com

# Create service account `apigee-proxy` with role: Logging > Logs Writer
gcloud iam service-accounts create apigee-proxy --display-name="apigee-proxy"
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} --member="serviceAccount:apigee-proxy@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com" --role="roles/logging.logWriter"
echo "Service Account Name for Apigee deployment: apigee-proxy@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com"

```

#hello