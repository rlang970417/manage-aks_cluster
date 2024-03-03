#!/bin/bash

# File : aksmgr.sh
# Desc : A script to quickly create / destroy an AKS cluster for a specific project
# Note : This script assumes you ran `az login` before script execution.
#

# Change the following below to match your project requirements
MY_RG="rg-test-rfid"
LOCATION="eastus"
CLSTR_NAME="test-rfid"

function make_cluster()
{
    # Create RG for our AKS Cluster Resources
    if [ $(az group exists --name ${MY_RG}) = false ]; then
        az group create --name ${MY_RG} --location ${LOCATION}
    fi

    az aks create --name ${CLSTR_NAME} --resource-group ${MY_RG} --generate-ssh-keys --node-vm-size Standard_D8s_v3 --node-count 2
}

function rm_cluster()
{
    # Remove AKS Cluster Resources and underlying RG
    if [ $(az group exists --name ${MY_RG}) = false ]; then
        az aks delete --name ${CLSTR_NAME} --resource-group ${MY_RG}
        az group delete -n {$MY_RG}
    fi
}

function get_clstrcreds()
{
    # AKS - Get Cluster Credentials
    if [ $(az group exists --name ${MY_RG}) = false ]; then
        az aks get-credentials --overwrite-existing --name ${CLSTR_NAME} --resource-group ${MY_RG} --admin
    fi
}

# Main / Menu
clear
echo
echo
echo
echo " Welcome to the AKS Project Management Menu"
echo
echo " Please select an option below"
echo
echo
echo
echo
echo
echo
echo
echo
echo "               1) Create a new AKS cluster for the project"
echo
echo "               2) Remove an existing AKS cluster for the project"
echo
echo "               3) Acquire credentials for an existing AKS cluster for the project"
echo
echo
echo
echo
read OPTION

case "$OPTION" in
1) make_cluster
;;
2) rm_cluster
;;
3) get_clstrcreds
;;
*) exit
;;
esac
