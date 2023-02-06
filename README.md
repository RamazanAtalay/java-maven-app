# Installing Jenkins on Linux OS as a Docker Container

## Users in the Linux
Local user information is stored in the
```
less /etc/passwd
```
Truncated usernames can be executed via
```
awk -F: '{ print $1}' /etc/passwd
```

## Preparing the Server

We will need to have a Linux server prepared to install Jenkins. 

It could be a remote server from an IaaS provider or could be a VM running Linux on your local machine. 

## Create A New User with Root Privileges
First thing we need to do is create a new users with root privileges.

We can install Jenkins as the root users, but that would be a bad practice. 

Therefore we are creating a new user named Jenkins on this server and whenever we SSH to the server after the initial installation, we will be using this Jenkins user.

```bash
adduser jenkins
usermod -aG sudo jenkins
```

## Installing Docker
To install Docker, we are going to switch the user to our new Jenkins user, then do an ***apt update*** and an ***apt install*** to install Docker.

```
su jenkins
sudo apt update
sudo apt install docker.io
```

Try to run  ***docker ps*** to verify installation,
```
docker ps
```
if you encounter an error which will be quite quite likely :)
```
sudo docker ps
```
> Question: Why?

> Ans: Because, you need to elevate the privilege of the ***jenkins*** user

## Add Jenkins User to Docker Group
To add **Jenkins user** to **Docker user group**, we need to execute following command

```
sudo usermod -aG docker jenkins
```
> Note: If there is any user, group, or system changes in Linux Distributions, you need to log out and log back in.

```
exit
su jenkins
docker ps
```

## Add SSH Key for Jenkins User
One of the point of creating a new user named **Jenkins** was to directly SSH to our server as this user, instead of root user.

> Que: What we need to do login this user?

> Ans: We need to add our SSH Key to ***authorized_users*** file for new user

```
ssh root@10.10.10.10
su jenkins
pwd
mkdir .ssh
cd .ssh
nano authorized_keys
```

## Running the Jenkins Container as Jenkins User

SSH to our server as Jenkins user.
```
ssh jenkins@10.10.10.10
```
Run the below command to run a Jenkins container.
```
docker run -d --name jenkins \
-p 8080:8080 \
-p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
jenkins/jenkins:lts-jdk11
```
Once the Docker container is started, check out the Jenkins UI by navigating to ***URL*** from a browser.
```
http://10.10.10.10:8080
```