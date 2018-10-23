#!/bin/sh -xe

mc config host add minio http://192.168.1.56:9000 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
mc cp minio/charakoba-cert/fullchain.pem minio/charakoba-cert/privkey.pem .
kubectl create secret tls rm.charakoba.com --key privkey.pem --cert fullchain.pem --dry-run -o yaml | kubectl replace -f-
