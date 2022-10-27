:: ==========================================================================================================
:: THIS BAT FILE USES KUBERNETES TO DEPLOY THE APPLICATION FROM PART A1
:: ==========================================================================================================

@ECHO OFF


:: TASK 2.1
echo Creating a Local Cluster
echo ==========================================================
kind create cluster --name kind-1 --config ../kind/cluster-config.yaml
timeout 10
echo.
echo Check if Local Cluster is Running
echo ==========================================================
kubectl cluster-info
echo.
:: TASK 2.2
echo Creating a Deployment Manifest
echo ==========================================================
kubectl apply -f backend-deployment.yaml
timeout 150
echo.
echo Check if Deployment is Running & Ready
echo ==========================================================
kubectl get deployment/backend 
kubectl get pods
echo.
echo Creating an Ingress Controller
echo ==========================================================
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml 
timeout 150
echo.
echo Check if Ingress Controller is Running & Ready
echo ==========================================================
 kubectl -n ingress-nginx get deploy 
echo.
echo Creating a Service Manifest
echo ==========================================================
kubectl apply -f backend-service.yaml
timeout 10
echo.
echo Check if Service is Created
echo ==========================================================
kubectl get svc 
echo.
:: TASK 2.3
echo.
echo Creating an Ingress Manifest
echo ==========================================================
kubectl apply -f backend-ingress.yaml
timeout 10
echo.
echo Check if Ingress is Created Successfully
echo ==========================================================
kubectl get ingress

start chrome http://localhost/

PAUSE