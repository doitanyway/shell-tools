1. 编辑crontab配置文件
vim /etc/crontab 

2. 每天凌晨运行backup.sh文件（假设文件路径在/user/local/backup.sh）
0 * * * * root /user/local/backup.sh

3.重启服务 
service crond restart
