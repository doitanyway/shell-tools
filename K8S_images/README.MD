### 这是从Google拉取镜像到本地的脚本


####使用步骤
* 在可以连接Google镜像库的主机，运行push_images.sh，拉取镜像并重命名，上传指定镜像库
* 在服务器运行push_images.sh，从指定镜像库下载到本地，再重命名为Google原始镜像名

####变量说明
* 运行脚本前需修改变量（需要拉取的镜像名等）
```
k8s=k8s.gcr.io ---- 需拉取的Google网址
org=zhangrh2018 ---- 需上传的指定库
images=( images:tags) ---- 需拉取的镜像名和版本

```