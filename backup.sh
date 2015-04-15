#!/usr/bin/env sh

log() {
  printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" $1 $2
}

abort() {
  printf "\n  \033[31mError: $@\033[0m\n\n" && exit 1
}

check() {
  if [ -z "$MONGO_HOST" ]; then
    abort 'needs environment variable: MONGO_HOST'
  fi
  if [ -z "$MONGO_DB" ]; then
    abort 'needs environment variable: MONGO_DB'
  fi
  if [ -z "$MONGO_USERNAME" ]; then
    abort 'needs environment variable: MONGO_USERNAME'
  fi
  if [ -z "$MONGO_PASSWORD" ]; then
    abort 'needs environment variable: MONGO_PASSWORD'
  fi
  if [ -z "$DROPBOX_ACCESS_TOKEN" ]; then
    abort 'needs environment variable: DROPBOX_ACCESS_TOKEN'
  fi

  ### check successfully, then report
  log 'check done'
}

pull_from_database() {
  local host=$MONGO_HOST
  local database=$MONGO_DB
  local user=$MONGO_USERNAME
  local pass=$MONGO_PASSWORD

  mongodump --host $host --db $database --username $user --password $pass
  zip -r dump/file.zip dump/accounts
  log 'mongodump done'
}

push_to_dropbox() {
  local day=`date +%d`
  local filename='accounts-'$day'.zip'
  curl -XPUT 'https://api-content.dropbox.com/1/files_put/auto/'$filename'?access_token='$DROPBOX_ACCESS_TOKEN -H'Content-Type: application/json' --data-binary "@./dump/file.zip"
  echo '\n'
  log 'dropbox done'
}

clean_dump() {
  rm -rf ./dump
  log 'clean done'
}

# main () {
  check && pull_from_database && push_to_dropbox && clean_dump
# }
