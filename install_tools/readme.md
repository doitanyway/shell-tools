##脚本安装步骤
* 上传file.sh文件到服务器
* 设置文件格式为unix
         
        #vim file.sh
        * 输入：，在命令模式输入set ff=unix，输入回车,设置文件格式
        * 输入：，在命令模式输入wq,保存退出；
* 赋权文件可执行权限

        # chmod +x file.sh
* 执行文件
        
        #./file.sh 
        * 可见参数hlep说明，按照help安装即可