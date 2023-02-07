
# Getting started with Jenkins using Docker

## More resources:

This settings is derived for MacOS, if you are using Windows Machine you can abide by the official jenkins documentation [here](https://www.jenkins.io/doc/book/installing/docker/) <br/>

## Generate Mounting points

```
docker volume ls
docker volume create jenkins-home
```

## If you need to specify your network bridge which is better than the default one

```
docker network ls
docker network create jenkiznetwork
```

## Docker containers for Jenkins 

You can use following code snippet to initiate Docker container <br/>
```
docker run -d \
-p 8080:8080 \
-p 50000:50000 \
-v jenkins-home:/var/jenkins-home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-v ${PWD}:/work \
-w /work \
--net jenkiznetwork \
jenkins/jenkins:lts
```

## Docker volume path for various OS Systems 


1. in Windows OS: C:\ProgramData\docker\volumes
2. in Linux OS: /var/lib/docker/volumes
3. in Mac OS: ~/Library/Containers/com.docker.docker/
4. in WSL 2: /var/data/docker-desktop/default/deamon-data

Note: These are subject to change day by day thus keep reading <br>

## Some issues you probably need to remember !!!

- Issue 1:

There might be quite possible that ***Docker-in-Docker (DinD)*** would be working fine but ***Docker-out-od-Docker (DooD)*** not working as expected.

Which will be error of *docker not found* on the jenkins job, thus both in local machine and inside of docker container
```
chmod 666 /var/run/docker.sock
```
if you have more than one user, the user must be added to the docker group too
```
gPasswd -a $USER docker
```
If you have connection problem from local machine to remote server such as ***Jenkins***

- Issue 2:

Docker connection token is stored in
```
cat ~/.docker/config.json
```
If you have connection problem from local machine to remote server such as ***Jenkins***

Navigate to Docker desktop

> Docker Desktop
>> Settings
>>> Docker engine
>>>> "insecure-registries":["10.10.10.10:8083"]

replace your VM IP with 10.10.10.10
> Note: Open the Firewall port of the VM **8083**

- Issue 3:

When docker push fails, you need to modify tagging for your conenction
```
docker tag my-image:1.0 10.10.10.10:8083/my-image:1.0
docker push 10.10.10.10:8083/my-image:1.0
```

- Issue 4:

If you prefer to connect a VM via ***ssh***, you will need to restrict your access key permission and it should be only readable by you.
```
mv ~/Downloads/AWS-Jenkins-Server.pem ~/.ssh/aws/Jenkins-Server/ \
&&
chmod 400 ~/.ssh/aws/Jenkins-Server/AWS-Jenkins-Server.pem \
&&
ssh -i ~/.ssh/aws/Jenkins-Server/AWS-Jenkins-Server.pem \
ec2-user@10.10.10.10
``` 

- Issue 5:

When you have a connection problem with your local and host server
```
ssh-copy-id -i ~/.ssh/azureprivatekey.pub ramazan@10.10.10.10
``` 


- Issue 6:

If you need a single layer image, you need to utilize **Docker EE**

```
docker build --squash -t singlelayer:v1 .
```

- Issue 7:

Containers have outbound network access but ***no inbound network access***; thus, ports must be published to allow inbound network access

> For specific port
```
docker run -dit -p  8080:80 nginx
``` 
> For default port exposed    
```     
docker run -dit -P  nginx
```

- Issue 8:
DNS configuration fails!!!

```
docker container run -it --dns 10.10.10.10 centos /bin/bash

cat  /etc/resolve.conf command fails
```

open ***deamon.json*** file;
```
sudo nano /etc/docker/daemon.json
```
add following snippet
```
{
    "dns":["10.10.10.10"]
}
```
Finally, execute
```
sudo systemctl restart docker 
```
Good to go
