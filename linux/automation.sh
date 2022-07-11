#!/bin/sh

##Script Starts From Here
 TAG=`git log -1 --pretty=%H`

docker build -f ../dockerize/Dockerfile -t golang .
docker tag golang golang:$TAG
cp script.yaml new-app.yaml
IMAGE_NAME=golang:TAG
sed -i -e 's/MY_NEW_IMAGE/$IMAGE_NAME/g' new-app.yaml
kubectl describe deployment golang
diff script.yaml new-app.yaml



