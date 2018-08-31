#!/bin/sh -xe

if [ -z "${BACKUP_TARGET}" ]; then
    exit 1
fi

FILENAME=backup-${BACKUP_TARGET}-$(date +%Y%m%d%H%M%S).tar.gz
tar -zcvf /tmp/${FILENAME} /target
mc config host add minio http://192.168.1.54:9000 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
mc cp /tmp/${FILENAME} minio/backups/${BACKUP_TARGET}/${FILENAME}
mc rm -r --older-than 6 --force minio/backups/ghost/
