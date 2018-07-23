# mysql/文件夹定时备份

## 1. 脚本描述
本脚本实现2个备份
* 文件夹备份：指定备份文件夹到指定路径下
* mysql备份：备份数据库到指定路径下
eg:   backUp
       |
        ------20180723_164501.file.tar.gz
       |
        ------20180723_164401.sql.tar.gz

ps:脚本文件建议创建一个文件夹放置，比如/user/shell/backup

## 2.使用介绍
* 修改backup.sh脚本配置文件
打开backup.sh config包含的参数是需要修改的
```
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
```
其中
```
backup_path              //文件备份的路径
max_files_backup_num     //最大可保留多少个文件
file_source_path         //要备份的文件夹路径
max_mysql_backup_num     //mysql备份保留文件个数
mysql_user               //mysql登录用户名
mysql_password           //mysql登录密码
mysql_table_name         //要备份的数据库表
```

## 3. 配置定时任务
* 编辑crontab配置文件
```
vim /etc/crontab 
```

* 每天凌晨运行backup.sh文件（假设文件路径在/user/local/backup.sh）
```
0 * * * * root /user/local/backup.sh
```

* 重启服务 
```
service crond restart
```