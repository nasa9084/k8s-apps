#!/bin/bash
set -e

BACKUP_FILENAME="backup_$(date +%Y-%m-%d)"


echo "========================================"
echo "  Client Versions"
echo "========================================"

mysql --version
gsutil --version
kubectl version --client


echo "========================================"
echo "  gcloud auth"
echo "========================================"

gcloud auth activate-service-account --key-file "${GCLOUD_SERVICE_ACCOUNT_KEY:-/var/run/secrets/cloud.google.com/serviceaccount/account_key}"


echo "========================================"
echo "  create workspace"
echo "========================================"

workspace_name="/tmp/${BACKUP_FILENAME}"
mkdir "${workspace_name}"
cd "${workspace_name}"


echo "========================================"
echo "  detect pod"
echo "========================================"

pod_name=$(kubectl get po -l app=ghost -o name)
if [[ $(echo "${pod_name}" | wc -l) != 1 ]]
then
    echo "Cannot detect only one pod"
    echo "${pod_name}"
    exit 1
fi


echo "========================================"
echo "  copy contents"
echo "========================================"

echo "copy /var/lib/ghost/config.production.json"
kubectl cp "${pod_name##pod/}:/var/lib/ghost/config.production.json" ./config.production.json

if [[ $(jq -r ".database.client" config.production.json) != "mysql" ]]
then
    echo "mysql is not used for the blog"
    exit 1
fi

mysql_host=$(jq -r ".database.connection.host" config.production.json )
mysql_port=$(jq -r ".database.connection.port" config.production.json )
mysql_user=$(jq -r ".database.connection.user" config.production.json )
mysql_password=$(jq -r ".database.connection.password" config.production.json )
mysql_database=$(jq -r ".database.connection.database" config.production.json )

contents_path=$(jq -r ".paths.contentPath" config.production.json)
echo "copy ${contents_path}"
kubectl cp "${pod_name##pod/}:${contents_path}" "./$(basename ${contents_path})"


echo "========================================"
echo "  mysqldump"
echo "========================================"
echo "  Host:     ${mysql_host}:${mysql_port}"
echo "  User:     ${mysql_user}"
echo "  Database: ${mysql_database}"

mysqldump --host "${mysql_host}" --port "${mysql_port}" --user "${mysql_user}" --password="${mysql_password}" "${mysql_database}" > mysql.dump


echo "========================================"
echo "  pack and push"
echo "========================================"

cd ..
tar -cf "${BACKUP_FILENAME}.tar.gz" "${BACKUP_FILENAME}"
gsutil cp "${BACKUP_FILENAME}.tar.gz" "gs://${GCLOUD_BUCKET_NAME}"
