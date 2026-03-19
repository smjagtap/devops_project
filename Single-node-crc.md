# Getting started with CodeReady Containers


Red Hat OpenShift is the Kubernetes platform from Red Hat, and it's designed for the hybrid cloud. 
Red Hat OpenShift Container Platform runs on cloud services such as AWS, Azure, and Google Cloud. 
You can also install and run OpenShift Container Platform on bare metal, but doing so requires a somewhat "demanding" setup.

Is there an alternative available? Yes, there is. This is where Red Hat CodeReady Containers comes into play.

Red Hat CodeReady Containers (CRC) provides a minimal, preconfigured OpenShift 4 cluster on a laptop or desktop machine for development and testing purposes. CRC is delivered as a platform inside of the VM. Now, let's look at how to configure it!
Requirements

The general requirements for CodeReady Containers are:
~~~
    OS: CentOS 7.5-8x/RHEL 7.5-8x/Fedora (latest 2 releases)
    Download: pull-secret
    Login: Red Hat account
~~~
The physical requirements include:
~~~
    Four virtual CPUs (vCPUs)
    9GB of memory (RAM)
    35GB of storage space
~~~

# Setting up

To set up CodeReady Containers, start by creating the crc directory, and then download and extract the crc package:
```
$ mkdir /home/<user>/crc
$ wget https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz
$ tar -xvf crc-linux-amd64.tar.xz
```
Next, move the files to the crc directory and remove the downloaded package(s):
```
$ mv /home/<user>/crc-linux-<version>-amd64/* /home/<user>/crc
$ rm /home/<user>/crc-linux-amd64.tar.xz
$ rm -r /home/<user>/crc-linux-<version>-amd64
```
Change to the crc directory, make crc executable, and export your PATH like this:
```
$ cd /home/<user>/crc
$ chmod +x crc
$ export PATH=$PATH:/home/<user>/crc
```
Set up and start the cluster:
```
$ crc setup
$ crc start -p /<path-to-the-pull-secret-file>/pull-secret.txt
```
Set up the OC environment:
```
$ crc oc-env
$ eval $(crc oc-env)
```
Log in as the developer user:
```
$ oc login -u developer -p developer https://api.crc.testing:6443
$ oc logout
```
And then, log in as the platform’s admin:
```
$ oc login -u kubeadmin -p password https://api.crc.testing:6443
$ oc logout
```
Interacting with the cluster

The most common ways of interacting with the cluster include:
o   Start the graphical web console:
```
$ crc console
```
o   Display the cluster’s status:
```
$ crc status
```
o    Shut down the OpenShift cluster:
```
$ crc stop
```
o    Delete or kill the OpenShift cluster:
```
$ crc delete
```
Red Hat additionally provides odo (OpenShift Do), a CLI tool for developers, to manage application components on the OpenShift Container Platform. To make use of odo, run the following commands:
```
$ wget https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64.tar.gz
$ tar -xvf odo-linux-amd64.tar.gz
$ mv /home/<user>/odo /home/<user>/crc
$ rm odo-linux-amd64.tar.gz
$ cd /home/<user>/crc
$ chmod +x odo
```
Running an application

After setting up CodeReady Containers on a local machine, how do you run an application on OCP 4? Let’s create the "Wild-West" example project:
```
$ cd /home/<user>/crc
$ export PATH=$PATH:/home/<user>/crc
$ crc start
$ odo login -u developer -p developer
$ mkdir /home/<user>/wild-west
$ cd /home/<user>/wild-west
$ git clone https://github.com/openshift-evangelists/Wild-West-Backend backend
$ git clone https://github.com/openshift-evangelists/Wild-West-Frontend frontend
$ odo project create wild-west
$ oc import-image openjdk18 --from=registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift --confirm
$ oc annotate istag/openjdk18:latest tags=builder
$ odo catalog list components
$ cd /home/<user>/wild-west/backend
$ mvn package
$ odo create openjdk18 backend --binary target/wildwest-1.0.jar
$ odo config view
$ odo push
$ odo list
$ cd /home/<user>/wild-west/frontend
$ odo create nodejs frontend
$ odo config view
$ odo push
$ odo list
$ odo link backend --port 8080
$ odo url create frontend --port 8080
$ odo push
$ odo list
```
Once you are finished, you can launch the new application via the web console with:
```
$ crc console
```

Ref: https://www.redhat.com/en/blog/codeready-containers
