:: ==========================================================================================================
:: THIS BAT FILE USES KUBERNETES TO DEPLOY THE APPLICATION FROM PART A1
:: ==========================================================================================================

@ECHO OFF

echo "Deployment of a local cluster"
kind create cluster --name kind-1 --config ../../k8s/kind/cluster-config.yaml
kubectl cluster-info

echo "create a Deployment manifest"
kubectl apply -f deployment.yaml
timeout 150
kubectl get deployment/backend
kubectl get pods 

echo "Create Ingress controller(nginx-ingress-controller)"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
timeout 150
kubectl -n ingress-nginx get deploy

echo "Create a Service for our Deployment"
kubectl apply -f service.yaml
timeout 10
kubectl get svc 

echo "Create an Ingress object"
kubectl apply -f ingress.yaml
timeout 10
kubectl get ingress

start chrome http://localhost/

PAUSE