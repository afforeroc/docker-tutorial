# Tutorial of Docker

## Tutorial

### System requirements
* Ubuntu 20.04 LTS (runnig over WSL)
* Docker v19.03.13
* Python v3.8.5
* Pip v20.0.2
* Python packages.
    * Flask v1.1.2

### Pre-requisites
* Get a [IBM Cloud account](https://cloud.ibm.com/login).

### 1. Install Python, PIP an Flask
1.1 Install [Python](https://www.python.org/).
```
$ sudo apt install python3
```
```
$ python3 --version
```

1.2 Install [PIP](https://pypi.org/project/pip/).
```
$ sudo apt install python3-pip
```
```
$ pip3 --version
```

1.3 Install [Flask]()
```
$ sudo pip3 install flask
```

### 2. Install Docker Engine
2.1 Update the apt package index and install packages to allow apt to use a repository over HTTPS.
```
$ sudo apt-get update
$ sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

2.2 Add Docker’s official GPG key
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $ sudo apt-key add -
```

2.3 Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
```
$ sudo apt-key fingerprint 0EBFCD88

pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

2.4 Use the following command to set up the stable repository.
```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

2.5 Install Docker Engine.
```
$ sudo apt update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

2.6 To install a specific version of Docker Engine, list the available versions in the repo, then select and install.
```
$ apt-cache madison docker-ce

docker-ce | 5:19.03.13~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.12~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.11~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.10~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.9~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
...
```

2.7  Install a specific version using the version string from the second column, for example, ```5:19.03.13~3-0~ubuntu-focal```.
```
$ sudo apt-get install docker-ce=5:19.03.13~3-0~ubuntu-focal docker-ce-cli=5:19.03.13~3-0~ubuntu-focal containerd.io
```

2.8 Start Docker.
```
$ sudo /etc/init.d/docker start
```

2.9 Verify that Docker Engine is installed correctly by running the hello-world image.
```
$ sudo docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.    

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## 3. Manage Docker as a non-root user
3.1 Create the docker group.
```
$ sudo groupadd docker
```

3.2 Add your user to the docker group.
```
$ sudo usermod -aG docker $USER
```

3.3 Log out and log back in so that your group membership is re-evaluated.
```
$ newgrp docker
```

3.4 Verify that you can run docker commands without sudo.
```
$ docker run hello-world
```

### 4. Create, build and run a local container
4.1 Go to root folder of app.
```
$ cd docker-tutorial
```

4.2 Create and build the Docker Image
```
$ docker image build -t python-hello-world .
```

> If have issues creating and build Docker image, edit the `resolv.conf` file adding these lines.
```
$ sudo nano /etc/resolv.conf
```
```
# Google IPv4 nameservers
nameserver 8.8.8.8
nameserver 8.8.4.4
```

4.3 Check the image list.
```
$ docker images
```

4.4 Run the Docker image.
```
$ docker run -p 5000:5000 -d python-hello-world

fef018a4106c459aeb02a94ff43b2add7bfb7d6613874802fbc859c7292da659
```

4.5 Check the container is running.
```
$ docker ps -a

CONTAINER ID        IMAGE                COMMAND             CREATED             STATUS              PORTS                    NAMES
fef018a4106c        python-hello-world   "python app.py"     28 seconds ago      Up 26 seconds       0.0.0.0:5000->5000/tcp   nervous_black
```

4.6 Go to [localhost:5000](http://localhost:5000/). You should see this message.
```
hello world!
```

4.7 If you need pause, stop or start the container.

```
$ docker pause fef
```

```
$ docker stop fef
```

```
$ docker start fef
```


### 5. Upload the image/container to IBM Cloud using Container Registry
5.1 Login on IBM Cloud.
```
$ ibmcloud login
```

5.2 Login on Container Registry service.
```
$ ibmcloud cr login
```

5.3 Create a Container Registry name-space.
```
$ ibmcloud cr namespace-add isa-development
```

5.4 Build and push the container.
```
$ ibmcloud cr build --tag registry.ng.bluemix.net/isa-development/python-hello-world:latest .
```

5.5 Verify the uploaded image.
```
$ ibmcloud cr image-list

Listing images...

Repository                                     Tag      Digest         Namespace         Created          Size    Security status   
us.icr.io/isa-development/python-hello-world   latest   4db3383677ab   isa-development   28 seconds ago   23 MB   Scanning...   

OK
```

### 6. Accessing your cluster
6.1 Create a free cluster on IBM Cloud using Kubernetes Service.
<screenshot 1>

6.2  Log in to your IBM Cloud account.
```
$ ibmcloud login -a cloud.ibm.com -r us-south -g Default
```

6.3 Copy the ID of cluster that was created.
<screenshot 2>

6.4 Set the Kubernetes context to your cluster for this terminal session.
```
$ ibmcloud ks cluster config --cluster bv5h24ed0tnfajgq5sig

OK
The configuration for bv5h24ed0tnfajgq5sig was downloaded successfully.

Added context for bv5h24ed0tnfajgq5sig to the current kubeconfig file.
You can now execute 'kubectl' commands against your cluster. For example, run 'kubectl get nodes'.
If you are accessing the cluster for the first time, 'kubectl' commands might fail for a few seconds while RBAC synchronizes
```

6.5 Verify that you can connect to your cluster.
```
$ kubectl config current-context

mycluster-free/bv5h24ed0tnfajgq5sig
```

6.6 Try to verify the state of cluster.
```
$ kubectl get nodes

NAME           STATUS   ROLES    AGE   VERSION
10.131.79.71   Ready    <none>   22m   v1.18.12+IKS
```
> Remember if you have some errors, be patient and remember: *If you are accessing the cluster for the first time, 'kubectl' commands might fail for a few seconds while RBAC synchronizes.*

### 7. Deploy the container on the Kubernetes cluster 
7.1 Make the deployment.
```
$ kubectl create deployment python-hello-world --image=us.icr.io/isa-development/python-hello-world:latest

deployment.apps/python-hello-world created
```

7.2 Check the status of the running application.
```
$ kubectl get pods

NAME                                  READY   STATUS    RESTARTS   AGE
python-hello-world-7d67f9d5fc-rgmcr   1/1     Running   0          16s
```

7.3 Expose that deployment as a service so we can access it through the IP of the worker nodes.
```
$ kubectl expose deployment/python-hello-world --type=NodePort --port=5000 --name=python-hello-world-service --target-port=5000

service/python-hello-world-service exposed
```

7.4 Find the port used on that worker node. In this case, the node port is **31674**
kubectl get service guestbook
```
$ kubectl get service python-hello-world-service

NAME                         TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
python-hello-world-service   NodePort   172.21.229.209   <none>        5000:31674/TCP   4m46s
```

7.5 Find the External IP. In this case, external IP is **169.57.42.18**.
```
$ kubectl get nodes -o wide

NAME           STATUS   ROLES    AGE   VERSION        INTERNAL-IP    EXTERNAL-IP    OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
10.131.79.71   Ready    <none>   32m   v1.18.12+IKS   10.131.79.71   169.57.42.18   Ubuntu 16.04.7 LTS   4.4.0-194-generic   containerd://1.3.4
```

7.6 Construct the address and the port to access the application in the web browser using the external IP and the node port.<br>
eg [169.57.42.18:31674](http://169.57.42.18:31674/)

## Reference Links
* [Docker Docs - Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [Docker Docs - Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)
* [Stack Overflow - Can't install pip packages inside a docker container with Ubuntu](https://stackoverflow.com/questions/28668180/cant-install-pip-packages-inside-a-docker-container-with-ubuntu)
* [eduonix - Learn How To Stop, Kill And Clean Up Docker Containers](https://blog.eduonix.com/software-development/learn-stop-kill-clean-docker-containers/)
* [IBM - docker 101: Lab 2](https://ibm-developer.gitbook.io/docker101/docker-101/lab-2)
* [IBM Cloud - Adding images to your namespace](https://cloud.ibm.com/docs/Registry?topic=Registry-registry_images_)
* [IBM - kube101: Lab 1. Deploy your first application](https://github.com/IBM/kube101/tree/master/workshop/Lab1)