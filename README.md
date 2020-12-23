## Intro
This project creates a fleet of irc bot using kuberentes.
For the irc bot itself, this project is using [irc-http by hackeriet](https://github.com/hackeriet/irc-http). This project is basically a clone of irc-http with the addition of several scripts for deploying an irc bot fleet using

## Prerequisits
This project creates a local minikube cluster of irc bots. Before continuting 
one, please verify the following:

1. You have [minikube](https://kubernetes.io/docs/tasks/tools/)and [kubctl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed in your local environment. There's an `init.sh` script in the ks folder that can install these for you.
1. You have docker installed on your machine. The `init.sh` script only check if docker is installed or not but doesn't install it. To install docker follow
[the docker docs](https://docs.docker.com/engine/install).

## Initializing your environment
As mentioned above, you need docker, kubectl and minikube installed.
You can run the `init.sh` script in the ks folder to initialize your environment. You need sudo permissions to do so.

## Deploying the bots
There are two way to deploy the bots:

### Creating individual bots
There's a `deploy_bots.sh` script in the ks folder. This script performs the following:
1. Builds the irc-http docker image.
1. Creats a batch of .yaml config files for each bot.
1. Deploys these bots 

Once the script completes, it'll print out the list of bots and their respective local IPs, like so:
```
=================================================
These are the service bots with their local IPs:
NAME CLUSTER-IP
bot-david-service 10.102.165.35
bot-jennifer-service 10.103.61.86
bot-joe-service 10.110.207.125
bot-mike-service 10.106.136.143
bot-sarah-service 10.105.98.190
bot-sharon-service 10.107.156.228
kubernetes 10.96.0.1
=================================================
```
You can use these IPs to test the bots API.

### Creating several both in one service using stateFulSet

You can simply run `kubectl apply -f deploy_stateful.yaml`

Then `kubectl get service | grep bot | tr -s ' ' | cut -d ' ' -f -1,3`

To get the service and it IP address

## Cleaning up
There's a `clean_up.sh` script in the ks folder. This script gets the services and deployments for all bots and deletes them.
    

