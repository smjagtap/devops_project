## Error: while starting jenkins pipeline to build docker container
```
ERROR: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied

```
## Solution:

~~~
# Add jenkins user to docker group
# sudo usermod -aG docker jenkins
# Restart Jenkins service so group membership takes effect
#sudo systemctl restart jenkins
~~~
-----
## Error: 

