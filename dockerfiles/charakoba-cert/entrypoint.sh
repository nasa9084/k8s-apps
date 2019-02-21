#!/bin/sh -xe

mc config host add minio ${MINIO_HOST} ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
mc cp minio/charakoba-cert/fullchain.pem minio/charakoba-cert/privkey.pem .
kubectl create secret tls rm.charakoba.com --key privkey.pem --cert fullchain.pem --dry-run -o yaml | kubectl replace -f-
