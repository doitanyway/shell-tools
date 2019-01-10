#!/bin/bash 


# 拉取镜像的源地址
k8s=k8s.gcr.io
# 需拉取的镜像名字
images=(
  k8s-dns-kube-dns:1.14.13
  k8s-dns-dnsmasq-nanny:1.14.13
  #images:tags
);

# hub.docker.com/fangle/image_name:tag
# org=210.22.23.250:6105/fangle;
# 需上传的指定库
org=zhangrh2018


for v in ${images[@]};
do
  echo "k8s-images_name:"$k8s/$v
  echo "docker_images:"$org/$v
 # push_name=$(echo $v | sed "s/\//-/g")
 # echo "push_name:" $push_name

 # echo "pull the google images......"
 # docker pull $k8s/$v
 # echo "change the google images tags......"
 # docker tag $k8s/$v $org/$v

 # echo "push the google images to the dokcer.hub......"
 # docker push $org/$push_name
  
 echo "pull the docker.hub images......"
 docker pull $org/$v

 echo "change the docker.hub images tags......"
 docker tag $org/$v $k8s/$v 


done
