#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# change Home directory
export HOME=/mnt/home


# source script specifying environment variables
source ~/.EnvVars


# change directory to Programs directory
cd $APPS_DIR


# install supporting packages
sudo yum install -y freetds-devel
echo `df -h /` FreeTDS >> $MAIN_DISK_USAGE_LOG

sudo yum install -y unixODBC-devel
echo `df -h /` UnixODBC >> $MAIN_DISK_USAGE_LOG


# install SQLalchemy
sudo pip install --upgrade SQLalchemy
echo `df -h /` SQLalchemy >> $MAIN_DISK_USAGE_LOG


# install CSVkit
sudo pip install --upgrade CSVkit
echo `df -h /` CSVkit >> $MAIN_DISK_USAGE_LOG


# install commonly-applicable drivers
sudo pip install --upgrade Egenix-mxODBC
echo `df -h /` Egenix-mxODBC >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade PyODBC
echo `df -h /` PyODBC >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade zxJDBC   SKIPPED: for Jython only
# echo `df -h /` zxJDBC >> $MAIN_DISK_USAGE_LOG


# install Firebird drivers
sudo pip install --upgrade FDB
echo `df -h /` Firebird DB >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade kinterbasdb --allow-external kinterbasdb --allow-unverified kinterbasdb   SKIPPED: very old!

wget https://github.com/FirebirdSQL/jaybird/releases/download/v2.2.9/Jaybird-2.2.9-JDK_1.8.zip
unzip Jaybird-* -d Jaybird-2.2.9
sudo rm -r Jaybird-*.zip


# install Microsoft SQL Server drivers
sudo pip install --upgrade PyMSSQL
echo `df -h /` PyMSSQL >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade AdoDBAPI
echo `df -h /` AdoDBAPI >> $MAIN_DISK_USAGE_LOG

# skip downloading Microsoft SQL Server JDBC: don't know how to do from command line...


# download / install MySQL Python & JDBC drivers
sudo yum install -y mysql
sudo yum install -y mysql-devel
echo `df -h /` MySQL YUM Packages >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade CyMySQL
echo `df -h /` CyMySQL >> $MAIN_DISK_USAGE_LOG

sudo yum install --enablerepo=fedora -y mysql-connector-python
echo `df -h /` MySQL-Connector-Python >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade MySQL-Python
echo `df -h /` MySQL-Python >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade OurSQL
echo `df -h /` OurSQL >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade PyMySQL
echo `df -h /` PyMySQL >> $MAIN_DISK_USAGE_LOG

wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.zip
unzip mysql-connector-java-*
sudo rm mysql-connector-java*.zip
sudo mv mysql-connector-java*/mysql-connector-java*.jar MySQL-JDBC-5.1.38.jar
sudo rm -r mysql-connector-java*/


# install Oracle drivers
# sudo pip install --upgrade cx-Oracle   SKIPPED: requires Oracle software installed

wget http://download.oracle.com/otn/utilities_drivers/jdbc/11204/ojdbc6.jar -O Oracle-JDBC-6.jar


# download / install PostgreSQL Python & JDBC drivers
sudo yum install -y postgresql
sudo yum install -y postgresql-devel
echo `df -h /` PostgreSQL YUM Packages >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade PG8000
echo `df -h /` PG8000 >> $MAIN_DISK_USAGE_LOG

# sudo pip install --upgrade Py-PostgreSQL   skip: for Python 3.1 and greater only
# echo `df -h /` Py-PostgreSQL >> $MAIN_DISK_USAGE_LOG

sudo yum install -y python-psycopg2
sudo pip install --upgrade psycopg2
echo `df -h /` PsycoPG2 >> $MAIN_DISK_USAGE_LOG

sudo pip install --upgrade psycopg2cffi
echo `df -h /` PsycoPG2CFFI >> $MAIN_DISK_USAGE_LOG

curl https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar --output PostgreSQL-JDBC42-9.4.1207.jar


# install SQLite drivers
# sudo pip install --upgrade PySQLCipher   SKIPPED: needs Cython? or somehow fails on GPU instances
# echo `df -h /` PySQLCipher >> $MAIN_DISK_USAGE_LOG
# sudo pip install --upgrade PySQLite   SKIPPED: SQLite3 package already included in Python >=2.5 distributions

git clone https://github.com/xerial/sqlite-jdbc
cp sqlite-jdbc/lib/jdbc-api-1.4.jar SQLite-JDBC-1.4.jar

# install Sybase drivers
# sudo pip install --upgrade git+git://github.com/fbessho/python-sybase.git   skip: requires Sybase software installed
