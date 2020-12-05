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


### 5. Deploy on IBM Cloud using Container Registry
4.1 Login on IBM Cloud.
```
$ ibmcloud login
```

4.2 Login on Container Registry service.
```
$ ibmcloud cr login
```

4.3 Create a Container Registry name-space.
```
$ ibmcloud cr namespace-add development-space
```

4.4 Build and push the container.
```
$ ibmcloud cr build --tag registry.ng.bluemix.net/development-space/python-hello-world:1 .
```

4.5 Verify the pushed image.
```
$ ibmcloud cr image-list

Listing images...

Repository                                       Tag   Digest         Namespace           Created          Size    Security status   
us.icr.io/development-space/python-hello-world   1     54a510cbe947   development-space   13 minutes ago   34 MB   25 Issues   

OK
```

### 5.1
```
$ kubectl get nodes
```

```
$ kubectl run python-hello-world4 --image=us.icr.io/development-space/python-hello-world:2
```

```
$ kubectl get pods
```

```
$ kubectl logs python-hello-world5
```

```
$ kubectl logs python-hello-world5

 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

```
$ kubectl create deployment python-hello-world --image=us.icr.io/development-space/python-hello-world:2
```

```
$ kubectl expose deployment/python-hello-world --type=NodePort --port=5000 --name=python-hello-world-service --target-port=5000
```

```
$ kubectl describe service python-hello-world-service
```

```
$ ibmcloud ks workers --cluster bv3ueakd07n541nsceh0
```

## Reference Links
* [Docker Docs - Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).
* [Stack Overflow - Can't install pip packages inside a docker container with Ubuntu](https://stackoverflow.com/questions/28668180/cant-install-pip-packages-inside-a-docker-container-with-ubuntu)
* [IBM - docker 101: Lab 2](https://ibm-developer.gitbook.io/docker101/docker-101/lab-2)
* [IBM Cloud - Adding images to your namespace](https://cloud.ibm.com/docs/Registry?topic=Registry-registry_images_)
* [Docker Docs - Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/.)
* [eduonix - Learn How To Stop, Kill And Clean Up Docker Containers](https://blog.eduonix.com/software-development/learn-stop-kill-clean-docker-containers/)
* [IBM Developer - Containerization: Starting with Docker and IBM Cloud](https://developer.ibm.com/tutorials/building-docker-images-locally-and-in-cloud/)