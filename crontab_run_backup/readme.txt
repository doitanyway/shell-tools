1. �༭crontab�����ļ�
vim /etc/crontab 

2. ÿ���賿����backup.sh�ļ��������ļ�·����/user/local/backup.sh��
0 * * * * root /user/local/backup.sh

3.�������� 
service crond restart
