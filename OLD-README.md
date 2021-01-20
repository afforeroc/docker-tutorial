# How to deploy a container on IBM Cloud
Tutorial to deploy a container (of web app) on IBM Cloud

## Tutorial
* All steps were made in WSL Ubuntu 20.04 LTS.

### 0. Install Pre-requisites
0.1 Get a [IBM Cloud account](https://cloud.ibm.com/login).

0.2 Install [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli).
```
$ curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
```
```
$ ibmcloud --version
```

0.3 Install the [IBM Cloud plug-in for IBM Cloud Kubernetes Service and IBM Cloud Container Registry](https://cloud.ibm.com/docs/containers?topic=containers-cs_cli_install#cs_cli_install_steps).
```
$ ibmcloud plugin install container-service
$ ibmcloud plugin install container-registry
```
```
$ ibmcloud plugin list

Listing installed plug-ins...

Plugin Name                            Version   Status   
container-registry                     0.1.497
container-service/kubernetes-service   1.0.197
```

0.4 Install [Git](https://git-scm.com/downloads).
```
$ sudo apt-get install git
```
```
$ git --version

git version 2.25.1
```

0.5 Install [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

```
$ sudo apt-get update && $ sudo apt-get install -y apt-transport-https gnupg2 curl
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | $ sudo apt-key add -
$ echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | $ sudo tee -a /etc/apt/sources.list.d/kubernetes.list
$ sudo apt-get update
$ sudo apt-get install -y kubectl
```
```
$ kubectl version

Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.4", GitCommit:"d360454c9bcd1634cf4cc52d1867af5491dc9c5f", GitTreeState:"clean", BuildDate:"2020-11-11T13:17:17Z", GoVersion:"go1.15.2", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

0.6 Install [Docker Engine](https://docs.docker.com/engine/install/ubuntu/).
* Update the apt package index and install packages to allow apt to use a repository over HTTPS.
```
$ sudo apt-get update
$ sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

* Add Docker’s official GPG key
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $ sudo apt-key add -
```

* Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
```
$ sudo apt-key fingerprint 0EBFCD88

pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

* Use the following command to set up the stable repository.
```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

* Install Docker Engine.
```
$ sudo apt update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

* To install a specific version of Docker Engine, list the available versions in the repo, then select and install.
```
$ apt-cache madison docker-ce

docker-ce | 5:19.03.13~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.12~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.11~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.10~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
docker-ce | 5:19.03.9~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
...
```

*  Install a specific version using the version string from the second column, for example, ```5:19.03.13~3-0~ubuntu-focal```.
```
$ sudo apt-get install docker-ce=5:19.03.13~3-0~ubuntu-focal docker-ce-cli=5:19.03.13~3-0~ubuntu-focal containerd.io
```

* Start Docker.
```
$ sudo /etc/init.d/docker start
```

* Verify that Docker Engine is installed correctly by running the hello-world image.
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

## Reference Links
* [IBM Cloud Kubernetes Service (IKS) Lab - Pre-Requisites](https://lionelmace.github.io/iks-lab/prepare-prereq.html)

* [Stack Overflow - Cannot connect to the Docker daemon at unix:/var/run/docker.sock. Is the docker daemon running?](https://stackoverflow.com/questions/44678725/cannot-connect-to-the-docker-daemon-at-unix-var-run-docker-sock-is-the-docker)

* [GitHub - System has not been booted with systemd as init system (PID 1). Can't operate](https://github.com/MicrosoftDocs/WSL/issues/457)
