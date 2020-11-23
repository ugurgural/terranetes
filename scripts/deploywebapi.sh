# Get the local docker image and build it
cd ../api

docker build -t terranetes .
cd -

# Start the minikube
minikube start

# Since minikube uses its own context it cant see the local image, load the image to minikube's own context
docker save terranetes | (eval $(minikube docker-env) && docker load)

# Check if minikube is working
kubectl get nodes

# Load locally built image
kubectl run terranetes --image=terranetes --port 3030 --image-pull-policy=IfNotPresent
kubectl get services terranetes-deployment