#!/bin/bash

echo "Create management cluster secret for maas provider"

read -p "MAAS Endpoint : " ENDPOINT
read -p "MAAS API Key : " APIKEY

sed maas_secret.yaml \
  -e s^endpoint_goes_here^${ENDPOINT}^ \
  -e s/api_key_goes_here/${APIKEY}/ \
  | kubectl apply -f -

