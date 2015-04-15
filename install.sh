
curl -O http://downloads.mongodb.org/linux/mongodb-linux-x86_64-3.0.2.tgz
tar -zxvf mongodb-linux-x86_64-3.0.2.tgz
mkdir -p mongodb
cp -R -n mongodb-linux-x86_64-3.0.2/ mongodb

ls
mv mongodb-linux-x86_64-3/bin/mongodump ./mongodump
ls ./

# sh backup.sh
