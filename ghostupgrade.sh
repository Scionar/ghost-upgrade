#!/bin/bash

# Default variables
SSH_HOST=""
GHOST_DIR="/var/www/ghost"
DO_BACKUP=true
FETCH_URL="http://ghost.org/zip/ghost-latest.zip"

# Check parameters
while getopts ":h:d::pf::" opt; do
  case $opt in
    h)
      SSH_HOST=$OPTARG
      ;;
    d)
      GHOST_DIR=$OPTARG
      ;;
    p)
      DO_BACKUP=false
      ;;
    f)
      FETCH_URL=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Validate input
VALID_SSH_HOST='^[A-Za-z0-9_\-]+@(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|[A-Za-z0-9_\-\.]+)(:[0-9]+)?$'

if ! [[ $SSH_HOST =~ $VALID_SSH_HOST ]]
then
  echo "SSH user & host pattern not valid." >&2
  exit 1
fi

# Do backup if enabled
if [ $DO_BACKUP = true ]
then
  BACKUP_DATE="$(date +%Y-%m-%d_%H-%M)"
  BACKUP_SCRIPT="mkdir -p ~/ghost_backups && tar -zcf ~/ghost_backups/ghost-backup_${BACKUP_DATE}.tar.gz $GHOST_DIR"
  ssh $SSH_HOST $BACKUP_SCRIPT
fi

# Run upgradet
FETCH_SCRIPT="wget -nv -O /tmp/ghost-latest.zip $FETCH_URL"
SERVICE_STOP_SCRIPT="service ghost stop"
REPLACE_SCRIPT="unzip -uo /tmp/ghost-latest.zip -d $GHOST_DIR"
PERMISSION_SCRIPT="chown -R ghost:ghost ${GHOST_DIR}/*"
DEPENDENCIES_SCRIPT="(cd $GHOST_DIR && npm install --production)"
SERVICE_START_SCRIPT="service ghost start"
ssh $SSH_HOST "${FETCH_SCRIPT} && ${SERVICE_STOP_SCRIPT} && ${REPLACE_SCRIPT} && ${PERMISSION_SCRIPT} && ${DEPENDENCIES_SCRIPT} && ${SERVICE_START_SCRIPT}"
