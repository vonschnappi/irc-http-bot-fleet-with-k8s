#!/bin/bash

function print_sep() {
    echo
    echo "=============================================================="
    echo
}

echo "This script is going to install kubectl and minikube on your local machine."
echo "Do you wish to continue?"
select yn in "yes" "no" ; do
    case $yn in
        yes ) break;;
        no ) exit;;
    esac
done

# getting os and dist (if applicable for installing minikube and kubectl)
os=$(uname -s)
dist=""
if [ $os != "Darwin" ] ; then
    dist=$(head -1 /etc/os-release)
fi 

# checking is prerequisits are installed
minikube_installed=$(which minikube 2>/dev/null)
kubectl_installed=$(which kubectl 2>/dev/null)
docker_installed=$(which docker 2>/dev/null)

if [ -z $docker_installed] ; then
    print_sep
    echo "Docker is not installed"
    echo "Please follow https://docs.docker.com/engine/install/ to install docker"
    print_sep
    exit
fi 

# installing prerequisits according to os and distro
if [ -z $minikube_installed ] ; then
    print_sep
    echo "minikube is not installed!"
    echo "installing minikub for $os - $dist"
    if [[ $os = "Linux" ]] ; then
        if [[ $dist == *"Ubuntu"* ]] ; then
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
            sudo dpkg -i minikube_latest_amd64.deb
        else 
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
            sudo rpm -ivh minikube-latest.x86_64.rpm
        fi
    elif [[ $os = "Darwin" ]] ; then 
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
        sudo install minikube-darwin-amd64 /usr/local/bin/minikube
    fi
    print_sep
fi

if [ -z $kubectl_installed ] ; then
    print_sep
    echo "kubectl is not installed!"
    echo "installing kubectl for $os - $dist"
    
    if [[ $os = "Linux" ]] ; then
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

    elif [[ $os = "Darwin" ]] ; then 
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
    fi

    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    print_sep
fi

print_sep
echo "Starting minikube"
sudo minikube start
