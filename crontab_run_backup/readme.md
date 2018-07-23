# mysql/�ļ��ж�ʱ����

## 1. �ű�����
���ű�ʵ��2������
* �ļ��б��ݣ�ָ�������ļ��е�ָ��·����
* mysql���ݣ��������ݿ⵽ָ��·����
eg:   backUp
       |
        ------20180723_164501.file.tar.gz
       |
        ------20180723_164401.sql.tar.gz

ps:�ű��ļ����鴴��һ���ļ��з��ã�����/user/shell/backup

## 2.ʹ�ý���
* �޸�backup.sh�ű������ļ�
��backup.sh config�����Ĳ�������Ҫ�޸ĵ�
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
����
```
backup_path              //�ļ����ݵ�·��
max_files_backup_num     //���ɱ������ٸ��ļ�
file_source_path         //Ҫ���ݵ��ļ���·��
max_mysql_backup_num     //mysql���ݱ����ļ�����
mysql_user               //mysql��¼�û���
mysql_password           //mysql��¼����
mysql_table_name         //Ҫ���ݵ����ݿ��
```

## 3. ���ö�ʱ����
* �༭crontab�����ļ�
```
vim /etc/crontab 
```

* ÿ���賿����backup.sh�ļ��������ļ�·����/user/local/backup.sh��
```
0 * * * * root /user/local/backup.sh
```

* �������� 
```
service crond restart
```