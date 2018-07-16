# !/bin/bash

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#     ___                 __  _        
#    / __\  ___   _ __   / _|(_)  __ _ 
#   / /    / _ \ | '_ \ | |_ | | / _` |
#  / /___ | (_) || | | ||  _|| || (_| |
#  \____/  \___/ |_| |_||_|  |_| \__, |
#                                |___/ 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# !!! backup path must end of /
backup_path="/home/backup/"
# file max backup number
max_files_backup_num=3
# backup source path
file_source_path="/usr/local/tomcat_road/webapps/URPCSF0008.0"
# mysql max backup number
max_mysql_backup_num=3
# mysql parameter
mysql_user="root"
mysql_password="fangle@FANGLE"
mysql_table_name="urpcsf09"
echo $backup_path
echo $file_source_path

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#     ___             _       
#    / __\  ___    __| |  ___ 
#   / /    / _ \  / _` | / _ \
#  / /___ | (_) || (_| ||  __/
#  \____/  \___/  \__,_| \___|
#                             
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 全局变量
backup_file_name="${backup_path}$(date +"%Y%m%d")_$(date +"%H%M%S").file"
echo "$backup_file_name"
backup_sql_name="${backup_path}$(date +"%Y%m%d")_$(date +"%H%M%S").sql"
echo "$backup_sql_name"

doFilesBackip(){
    #判断文件是否存在不存在创建
    if [ ! -d $backup_path ]; then
    mkdir -p $backup_path
    fi

    #压缩备份文件
    tar -zcvf $backup_file_name.tar.gz $file_source_path

    #ls -l /home/backup/mysql/|grep "^-"|wc -l
    fileBackupNum=`ls -l ${backup_path}*.file.*|grep "^-"|wc -l`
    echo "fileNum=${fileBackupNum}"

    while(( $fileBackupNum > $max_files_backup_num ))
    do
    #取最旧的文件，*.*可以改为指定文件类型
    # ls -rt /home/backup/mysql/| head -1
    deleteFile=`ls -rt ${backup_path}*.file.*| head -1`
    echo "Delete File:"$deleteFile
    rm -f $deleteFile
    let "fileBackupNum--"
    done
}

doMysqlBackUp(){
    #判断文件是否存在不存在创建
    if [ ! -d $backup_path ]; then
    mkdir -p $backup_path
    fi
    #备份数据库
    mysqldump -R -E -u $mysql_user -p$mysql_password -hlocalhost $mysql_table_name > $backup_sql_name     

    #压缩备份文件
    tar -zcvf $backup_sql_name.tar.gz $backup_sql_name

    #删除.sql文件
    rm -rf $backup_sql_name

    # 判断文件是否到达配置最大值，如果到最大值删除最旧的文件
    mysqlBackupNum=`ls -l ${backup_path}*.sql.*|grep "^-"|wc -l`
    echo "fileNum=${mysqlBackupNum}"    

    while(( $mysqlBackupNum > $max_mysql_backup_num ))
    do
    #取最旧的文件，*.*可以改为指定文件类型
    # ls -rt /home/backup/mysql/| head -1
    mysqlDeleteFile=`ls -rt ${backup_path}*.sql.*| head -1`
    echo "Delete File:"$mysqlDeleteFile
    rm -f $mysqlDeleteFile
    let "mysqlBackupNum--"
    done
}

echo "-----Start Backup Filse-----"
doFilesBackip
echo "-----Start Backup Mysql-----"
doMysqlBackUp
echo "----------- End ------------"
