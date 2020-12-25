#!/bin/bash

echo "Building docker image..."
docker build --tag irc-http .

nicknames=(david sarah joe sharon mike jennifer)
in_use_node_ports=()

for name in ${nicknames[@]}
do
    # assigning random node port
    node_port=$(shuf -i 30000-32767 -n 1)

    # checking that node port is not already used
    while true 
    do
        if [[ " ${in_use_node_ports[@]} " =~ " ${node_port} " ]] ; then
            node_port=$(shuf -i 30000-32767 -n 1)
            in_use_node_ports+=($node_port)
        else 
            in_use_node_ports+=($node_port)
            break
        fi
    done
    if test -f "bots_config/bot-$name.yaml"; then
        echo "Config for bot-$name.yaml already exists. Skipping..."
    else 
        echo "Creating k8s yaml for $name"
        sed "s/{name}/$name/g" deploy_template.yaml > "bots_config/bot-$name.yaml"
        sed -i "s/{node_port}/$node_port/g" "bots_config/bot-$name.yaml"
    fi
done

echo "Setting k8s to use local docker images..."
eval $(sudo minikube docker-env)

for bot_yaml_file in $(ls bots_config)
do
    echo "Applying config_bots/$bot_yaml_file"
    kubectl apply -f "bots_config/$bot_yaml_file"
done

echo "================================================="
echo "These are the service bots with their local IPs:"
kubectl get service | grep bot | tr -s ' ' | cut -d ' ' -f -1,3
echo "================================================="
