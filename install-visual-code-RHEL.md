
## RHEL, Fedora, and CentOS based distributions

~~~
#sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
#echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
~~~

## update the sytem and install code.
~~~
#sudo dnf update &&
#sudo dnf install code # or code-insiders
~~~

Ref:[Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux#_install-vs-code-on-linux)
