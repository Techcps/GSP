

export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}-ml



gcloud sql instances create taxi \
    --tier=db-n1-standard-1 --activation-policy=ALWAYS



sleep 10    



gcloud sql users set-password root --host % --instance taxi \
 --password Passw0rd


export ADDRESS=$(wget -qO - http://ipecho.net/plain)/32



gcloud sql instances patch taxi --authorized-networks $ADDRESS


MYSQLIP=$(gcloud sql instances describe \
taxi --format="value(ipAddresses.ipAddress)")


echo $MYSQLIP


mysql --host=$MYSQLIP --user=root \
      --password --verbose



