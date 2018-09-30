#!/bin/bash

CMD='help'
pw=(12345)
basedir='/home'
datadir='/home/data'
port=(3306)

#赋值
a=`awk 'END {print}' /etc/profile`
b='export PATH'
c=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`

array=()
function split(){
  split_ret=${1//=/ }
  count=0
  for e in $split_ret
  do 
    array[$count]=$e
    let count++
  done 
}


#help函数
function help(){
  echo "help cmd:"
  echo "./mysql.sh --[options]=[options values] ... [cmd]  "
  echo ""
  echo "             --pw=[password],...    	eg: --pw=12345   	-mysql password"
  echo "             --pt=[port],...    	eg: --pt=3307    	-mysql port"
  echo "             --b=[path],...    		eg: --b=/home 		-mysql basepath"
  echo "             --d=[path],...    		eg: --d=/home/data 	-mysql datapath"
  echo ""
  echo "           [cmd]"
  echo "             install  ...... install mysql"
  echo "             remove   ...... remove mysql"
  echo ""
  echo "           [examples]"
  echo "             ./mysql.sh install     # install mysql by the default command"
  echo "             ./mysql.sh remove      # remove mysql"
  return ;
}



function install_mysql(){
if [ "${c}" == 6 ] ;then
	echo "centos6 install mysql start..."
	install_mysql_start
else
	echo "centos7 install mysql start..."
	install_mysql_start
fi
}

function start_mysql(){
if [ "${c}" == 6 ] ;then
	echo "centos6 start mysql..."
	service mysqld start
	echo "centos6 start complete..."
else
	echo "centos7 start mysql..."
	systemctl start mysqld
	echo "start complete..."
fi
}

function stop_mysql(){
if [ "${c}" == 6 ] ;then
	echo "centos6 stop mysql..."
	service mysqld stop
	echo "stop complete..."
else
	echo "centos7 stop mysql..."
	systemctl stop mysqld
	echo "stop complete..."
fi
}

function restart_mysql(){
if [ "${c}" == 6 ] ;then
	echo "centos6 restart mysql..."
	service mysqld restart
	echo "restart complete..."
else
	echo "centos7 restart mysql..."
	systemctl restart mysql
	echo "restart complete..."
fi
}


function install_mysql_start(){
  mkdir_dir
  install_wget
  download_mysql
  tar_gz
  usadd_mysql
  mysql_conf
  mysql_init
  get_password 
  telnet_mysql
  POWER_ON
  open_PORT
  echo "mysql basedir：" ${basedir}/mysql
  echo "mysql datadir: "${datadir}
  echo "your mysqlpassword: " ${pw}
  echo "your mysqlport " ${port} 
  echo "end install..."
}


function mkdir_dir(){
  echo " create directory..."
  mkdir -p ${basedir}
  mkdir -p ${datadir}
  cd /
  echo " create directory complete..."
}



function del_profile(){
	
if [ "${a}" == "${b}" ] ;then
	echo "del export PATH..."
	sed -i '$d' /etc/profile
else
	echo "no export PATH..."
fi
}


function remove_mysql(){
  echo "delete mysql..."
  stop_mysql
  close_PORT
  chkconfig --del mysqld
  chkconfig mysqld off
  rm -rf ${basedir}/mysql
  rm -rf ${datadir}
  rm -rf /etc/my.cnf
  rm -rf /etc/init.d/mysqld
  rm -rf /usr/local/bin/mysql
  mv /etc/my.cnf.bak /etc/my.cnf
  sed -i  '/^PATH/d' /etc/profile
  del_profile
  userdel -r mysql
  echo "delete mysql complete..."
}




function install_wget(){
  echo "install tool..."
  yum install -y wget 
  yum install -y perl
  yum install -y numactl
  yum install -y libaio-devel 
  echo "install tool complete..."
}



function download_mysql(){
if [ -e "mysql-5.7.15-linux-glibc2.5-x86_64.tar.gz" ];then 
	echo "mysql already download..."
else
	echo "download mysql..."
	cd /
	wget  https://cdn.mysql.com/archives/mysql-5.7/mysql-5.7.15-linux-glibc2.5-x86_64.tar.gz
	echo "download complete..."
fi
}

function tar_gz(){
  echo "tar mysql..."
  cd /
  tar -zxvf mysql-5.7.15-linux-glibc2.5-x86_64.tar.gz
  mv mysql-5.7.15-linux-glibc2.5-x86_64 ${basedir}/mysql
  cd /
  rm -rf mysql-5.7.15-linux-glibc2.5-x86_64.tar.gz
  echo "tar complete..."
}

function usadd_mysql(){
	echo "add mysqluser and chown the datadir..."
	useradd -s /sbin/nologin mysql
	chown -R mysql:mysql ${datadir}
	chown -R mysql:mysql ${basedir}/mysql
	echo "add complete..."
}


function mysql_conf(){
	echo "configure my.cnf和profile...."
	sleep 2
	mv /etc/my.cnf /etc/my.cnf.bak
	cp ${basedir}/mysql/support-files/my-default.cnf /etc/my.cnf
	sed -i '/'mysqld'/a\basedir='${basedir}/mysql /etc/my.cnf
	sed -i '/'mysqld'/a\datadir='${datadir} /etc/my.cnf
	sed -i '/'mysqld'/a\port='${port} /etc/my.cnf
	sed -i '/'mysqld'/a\character-set-server=utf8' /etc/my.cnf
		
	sed -i 's/^sql_mode.*$/sql_mode = NO_ENGINE_SUBSTITUTION/g' /etc/my.cnf
	echo "skip-name-resolve" >> /etc/my.cnf
	echo "lower_case_table_names=1" >> /etc/my.cnf
	echo "max_connections=1000" >> /etc/my.cnf
	
	echo PATH=${basedir}/mysql/bin:'$PATH' >> /etc/profile
	echo "export PATH" >> /etc/profile
	source /etc/profile
	sleep 2
	echo "configure complete...."
}


function mysql_init(){
	echo " mysql initialization..."
	cp ${basedir}/mysql/support-files/mysql.server /etc/init.d/mysqld
	ln -fs ${basedir}/mysql/bin/mysql /usr/local/bin/mysql
	sleep 5
	${basedir}/mysql/bin/mysqld --initialize-insecure --basedir=${basedir}/mysql --datadir=${datadir} --user=mysql
	echo " mysql_init end"
	sleep 3
	stop_mysql
	sleep 3
	start_mysql
	sleep 3
	service mysqld restart
	echo " mysql initialization..."
}

function get_password(){
	echo "configure mysql password..."
	
	mysqladmin -uroot  password ${pw}
	restart_mysql
	sleep 2
	echo "configure complete..."
}


function open_PORT(){
if [ "${c}" == 6 ] ;then
	echo "centos6 open mysql port..."
	/sbin/iptables -I INPUT -p tcp --dport ${port} -j ACCEPT 
   /etc/init.d/iptables save 
   service iptables restart
   echo "open complete..."
else
	echo "centos7 open mysql port..."
	firewall-cmd --zone=public --add-port=${port}/tcp --permanent
	firewall-cmd --reload
	echo "open complete..."
fi
}

function close_PORT(){
if [ "${c}" == 6 ] ;then
	echo "centos6 close mysql port... "
	/sbin/iptables -I INPUT -p tcp --dport ${port} -j DROP  
  /etc/init.d/iptables save 
  service iptables restart
  echo "close complete..."
else
	echo "centos7 close mysql port..."
	firewall-cmd --zone=public --remove-port=${port}/tcp --permanent
	firewall-cmd --reload
	 echo "close port..."
fi
}


#function open_PORT(){
  #echo "open port start"
   #/sbin/iptables -I INPUT -p tcp --dport ${port} -j ACCEPT 
   #/etc/init.d/iptables save 
   #service iptables restart
  
  #echo "open port end"
#}


function telnet_mysql(){
  echo "open telnet_mysql..."
	mysql -uroot -p${pw} -e "grant all privileges on *.* to 'root'@'%' identified by '${pw}' with grant option;"
	mysql -uroot -p${pw} -e "flush privileges;"
	mysql -uroot -p${pw} -e "update mysql.db set host = '%' where user = 'root';"
	mysql -uroot -p${pw} -e "flush privileges;"
  
  echo "complete..."
}


function POWER_ON(){
  echo "power on... "
  chkconfig --add mysqld
  chkconfig mysqld on
  echo "power on complete..."
}






for arg in $*
do 
  split $arg
  case ${array[0]} in       
        --pw)
        pw=${array[1]}
		# echo ${pw}
        ;;
        --b)
         basedir=${array[1]}
		 #echo ${path}
        ;;
		--d)
         datadir=${array[1]}
		 #echo ${path}
        ;;
		--pt)
         port=${array[1]}
		 #echo ${port}
        ;;
        install)
          CMD=${array[0]}
        ;;
        remove)
          CMD=${array[0]}
        ;;
        *)
        help
        ;;
  esac
done


# main function 
case $CMD in
  install)
    install_mysql
  ;;
  remove)
    remove_mysql
  ;;
  *)
    help
  ;;
esac 

