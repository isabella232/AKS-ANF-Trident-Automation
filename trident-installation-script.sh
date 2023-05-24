#!/bin/bash

echo "Setting AKS kubectl config"
az aks get-credentials --resource-group "${resource_group_name}" --name "${kubernetes_cluster_name}"


if ! [ $? -eq 0 ]; then 
    echo "Failed to set creds for AKS in kubectl" ; 
    exit 2 ; 
fi

echo "Getting Trident Installer from web"
wget https://github.com/NetApp/trident/releases/download/v23.04.0/trident-installer-23.04.0.tar.gz

if ! [ $? -eq 0 ]; then 
    echo "Failed to get the trident installer package" ; 
    exit 2 ; 
fi

echo "unpacking trident installer"
tar -xf ./trident-installer-23.04.0.tar.gz

if ! [ $? -eq 0 ]; then 
    echo "Failed to untar trident installer package" ; 
    exit 2 ; 
fi

echo "running cd trident-installer"
cd ./trident-installer

if ! [ $? -eq 0 ]; then 
    echo "Failed to run cd /home/ssm-user/trident-installer" ; 
    exit 2 ; 
fi

echo "installing tridentctl"
./tridentctl install -n trident

if ! [ $? -eq 0 ]; then 
    echo "Failed to install trident" ; 
    exit 2 ; 
fi

temp="{ \"version\": 1, \"storageDriverName\": \"azure-netapp-files\", \"subscriptionID\": \"${azure_subscription_id}\", \"tenantID\": \"${azure_sp_tenant_id}\", \"clientID\": \"${azure_sp_client_id}\", \"clientSecret\": \"${azure_sp_secret}\", \"location\": \"${trident_location}\", \"serviceLevel\": \"${az_netapp_pool_service_level_primary}\"}"
echo "storage-backend-config > "
echo $temp
echo $temp > ./anf-storage-backend-config.json
if ! [ $? -eq 0 ]; then 
    echo "Failed to create backend-storage file" ; 
    exit 2 ; 
fi

./tridentctl -n trident create backend -f ./anf-storage-backend-config.json

if ! [ $? -eq 0 ]; then 
    echo "Failed to create ANF storage backend" ; 
    exit 2 ; 
fi

cat > ./anf-storage-class.yaml <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: anf-sc
provisioner: csi.trident.netapp.io
parameters:
  backendType: "azure-netapp-files"
  fsType: "nfs"
allowVolumeExpansion: true
mountOptions:
  - nconnect=16
EOF

if ! [ $? -eq 0 ]; then 
    echo "Failed to create storage class file" ; 
    exit 2 ; 
fi

kubectl create -f ./anf-storage-class.yaml

if ! [ $? -eq 0 ]; then 
    echo "Failed to create storage class" ; 
    exit 2 ; 
fi


cat > ./anf-pvc.yaml <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: anf-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
  storageClassName: anf-sc
EOF

if ! [ $? -eq 0 ]; then 
    echo "Failed to create PVC file" ; 
    exit 2 ; 
fi

kubectl create -f anf-pvc.yaml

if ! [ $? -eq 0 ]; then 
    echo "Failed to create PVC" ; 
    exit 2 ; 
fi

cat > ./sample-app-deployment-service.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app-deployment
  labels:
    app: sample-app
    deploymethod: trident
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
        deploymethod: trident
    spec:
      containers:
      - name: sample-app
        image: tdhruv757/image-server-app:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: disk01
          mountPath: /var/lib/anfvol
      volumes:
      - name: disk01
        persistentVolumeClaim:
          claimName: anf-pvc
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: sample-app
  name: sample-app-svc
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: sample-app
  type: LoadBalancer
EOF

if ! [ $? -eq 0 ]; then 
    echo "Failed to create sample-app-deployment file" ; 
    exit 2 ; 
fi

kubectl create -f sample-app-deployment-service.yaml

if ! [ $? -eq 0 ]; then 
    echo "Failed to create sample-app deployment/service" ; 
    exit 2 ; 
fi