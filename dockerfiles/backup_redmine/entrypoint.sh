#!/bin/sh -xe

FILENAME=backup-redmine-$(date +%Y%m%d%H%M%S).tar.gz
mkdir /tmp/redmine
cp -r /usr/src/redmine/files /tmp/redmine/
cp -r /usr/src/redmine/plugins /tmp/redmine/
mkdir /tmp/redmine/public
cp -r /usr/src/redmine/public/themes /tmp/redmine/public/
echo ${PGHOST}:5432:${PGDATABASE}:${PGUSER}:${PGPASSWORD} > ~/.pgpass
chmod 0600 ~/.pgpass
pg_dump -U ${PGUSER} -Fc --file=/tmp/redmine/redmine.sqlc ${PGDATABASE} -w

tar -zcvf /tmp/${FILENAME} /tmp/redmine
mc config host add minio http://192.168.1.54:9000 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
mc cp /tmp/${FILENAME} minio/backups/redmine/${FILENAME}
mc rm -r --older-than 6 --force minio/backups/redmine/
