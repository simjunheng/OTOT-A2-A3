:: ==========================================================================================================
:: THIS BAT FILE USES KUBERNETES TO DEPLOY THE APPLICATION FROM PART A1
:: ==========================================================================================================

@ECHO OFF


:: TASK 3.1
echo Creating a Local Cluster
echo ==========================================================
kind create cluster --name kind-1 --config ../kind/cluster-config.yaml
timeout 10
echo.
echo Check if Local Cluster is Running
echo ==========================================================
kubectl cluster-info
echo.
echo Creating a Metrics Server
echo ==========================================================
 kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
echo.
echo Creating a Metrics Server
echo ==========================================================
kubectl -nkube-system edit deploy/metrics-server
kubectl -nkube-system rollout restart deploy/metrics-server 
timeout 10
echo.
echo Check if Metrics Server is Working
echo ==========================================================
kubectl get pods --all-namespaces | findstr "metrics-server" 
echo.
echo Creating a Horizontal Pod Auto Scaler
echo ==========================================================
kubectl apply -f backend-hpa.yaml
timeout 10
echo.
echo Check if Horizontal Pod Auto Scaler is Working
echo ==========================================================
kubectl get hpa
:: TASK 3.2
echo Creating a Deployment Manifest
echo ==========================================================
kubectl apply -f backend-deployment-zone-aware.yaml
timeout 600
echo.
echo Check if Deployment is Running & Ready
echo ==========================================================
kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName' 
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
kubectl apply -f backend-service-zone-aware.yaml
timeout 10
echo.
echo Check if Service is Created
echo ==========================================================
kubectl get svc 
echo.
echo Creating an Ingress Manifest
echo ==========================================================
kubectl apply -f backend-ingress-zone-aware.yaml
timeout 10
echo.
echo Check if Ingress is Created Successfully
echo ==========================================================
kubectl get ingress
echo.
echo Check if Pods are Running On Different Zones
echo ==========================================================
kubectl get nodes -L topology.kubernetes.io/zone

start chrome http://localhost/

PAUSE