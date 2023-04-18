# Coder

Coder is an alternative to codespace opensource

- [Documentation](https://coder.com/docs/v2/latest)

## Concepts

Coder is build around 2 single concepts.

- **Template**: Defines the environment for a specific project, the default templates only add the **dev** pod, but you could have multiple (if for example your app needs a database etc...)
- **Workspace**: Is the actual machines being up, you can have multiple workspaces of the same template. Imagine you and a collegue want to work on different parts of the project. You start two different workspaces, that will bring to live two different equal environments.

## Installation in K3s

1. [Download](https://github.com/coder/coder/releases/latest) and install (copy to /usr/loca/bin) the coder cli
2. Install helm (I already have installed)
3. create a coder namespace `kubectl create namespace coder`
4. create a postgresql 
	``` bash
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install coder-db bitnami/postgresql \
    --namespace coder \
    --set auth.username=coder \
    --set auth.password=coder \
    --set auth.database=coder \
    --set persistence.size=10Gi
	```

6. Add the coder repo to helm 
```bash
helm repo add coder-v2 https://helm.coder.com/v2
```
7. Create a secret with the url of the postgresql
```bash
kubectl create secret generic coder-db-url -n coder \
   --from-literal=url="postgres://coder:coder@coder-db-postgresql.coder.svc.cluster.local:5432/coder?sslmode=disable"
```
9. Create a `values.yaml` file with the following values
```yaml
coder:
  env:
    - name: CODER_PG_CONNECTION_URL
      valueFrom:
        secretKeyRef:
          name: coder-db-url
          key: url

    - name: CODER_ACCESS_URL
      value: "https://coder.allocsoc.net"

  #tls:
  #  secretNames:
  #    - my-tls-secret-name
```

10. Generate k8s files 
```bash
helm install coder coder-v2/coder --namespace coder --values values.yaml --dry-run --debug
```

which gived me
```yaml
---
# Source: coder/templates/coder.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "coder"
  annotations:
    {}
  labels:
    helm.sh/chart: coder-0.22.2
    app.kubernetes.io/name: coder
    app.kubernetes.io/instance: coder
    app.kubernetes.io/part-of: coder
    app.kubernetes.io/version: "0.22.2"
    app.kubernetes.io/managed-by: Helm
---
# Source: coder/templates/rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: coder-workspace-perms
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["*"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["*"]
---
# Source: coder/templates/rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: "coder"
subjects:
  - kind: ServiceAccount
    name: "coder"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: coder-workspace-perms
---
# Source: coder/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: coder
  labels:
    helm.sh/chart: coder-0.22.2
    app.kubernetes.io/name: coder
    app.kubernetes.io/instance: coder
    app.kubernetes.io/part-of: coder
    app.kubernetes.io/version: "0.22.2"
    app.kubernetes.io/managed-by: Helm
  annotations:
    {}
spec:
  type: LoadBalancer
  sessionAffinity: ClientIP
  ports:
    - name: "http"
      port: 80
      targetPort: "http"
      protocol: TCP
  externalTrafficPolicy: "Cluster"
  selector:
    app.kubernetes.io/name: coder
    app.kubernetes.io/instance: coder
---
# Source: coder/templates/coder.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coder
  labels:
    helm.sh/chart: coder-0.22.2
    app.kubernetes.io/name: coder
    app.kubernetes.io/instance: coder
    app.kubernetes.io/part-of: coder
    app.kubernetes.io/version: "0.22.2"
    app.kubernetes.io/managed-by: Helm
  annotations:
    {}
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: coder
      app.kubernetes.io/instance: coder
  template:
    metadata:
      labels:
        helm.sh/chart: coder-0.22.2
        app.kubernetes.io/name: coder
        app.kubernetes.io/instance: coder
        app.kubernetes.io/part-of: coder
        app.kubernetes.io/version: "0.22.2"
        app.kubernetes.io/managed-by: Helm
      annotations:
        {}
    spec:
      serviceAccountName: "coder"
      restartPolicy: Always
      terminationGracePeriodSeconds: 60
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app.kubernetes.io/instance
                  operator: In
                  values:
                  - coder
              topologyKey: kubernetes.io/hostname
            weight: 1
      containers:
        - name: coder
          image: "ghcr.io/coder/coder:v0.22.2"
          imagePullPolicy: IfNotPresent
          resources:
            {}
          lifecycle:
            {}
          env:
            - name: CODER_HTTP_ADDRESS
              value: "0.0.0.0:8080"
            - name: CODER_PROMETHEUS_ADDRESS
              value: "0.0.0.0:2112"
            # Set the default access URL so a `helm apply` works by default.
            # See: https://github.com/coder/coder/issues/5024
            # Used for inter-pod communication with high-availability.
            - name: KUBE_POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: CODER_DERP_SERVER_RELAY_URL
              value: "http://$(KUBE_POD_IP):8080"

            - name: CODER_PG_CONNECTION_URL
              valueFrom:
                secretKeyRef:
                  key: url
                  name: coder-db-url
            - name: CODER_ACCESS_URL
              value: https://coder.allocsoc.net
          ports:
            - name: "http"
              containerPort: 8080
              protocol: TCP
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: null
            runAsGroup: 1000
            runAsNonRoot: true
            runAsUser: 1000
            seccompProfile:
              type: RuntimeDefault
          readinessProbe:
            httpGet:
              path: /api/v2/buildinfo
              port: "http"
              scheme: "HTTP"
          livenessProbe:
            httpGet:
              path: /api/v2/buildinfo
              port: "http"
              scheme: "HTTP"
          volumeMounts: []
      volumes: []
```

11. Do your own changes...
	1. I did change the service to be a ClusterIP (will expose it through nginx ingress)
	```
	apiVersion: v1
	kind: Service
	metadata:
	  name: coder
	  labels:
	    helm.sh/chart: coder-0.22.2
	    app.kubernetes.io/name: coder
	    app.kubernetes.io/instance: coder
	    app.kubernetes.io/part-of: coder
	    app.kubernetes.io/version: "0.22.2"
	    app.kubernetes.io/managed-by: Helm
	  annotations:
	    {}
	spec:
	  type: ClusterIP
	  ports:
	    - name: "http"
	      port: 80
	      targetPort: "http"
	      protocol: TCP
	  selector:
	    app.kubernetes.io/name: coder
	    app.kubernetes.io/instance: coder
	```
	2. Add Ingress
```
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: coder-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    kubernetes.io/ingress.class: traefik
    kubernetes.io/tls-acme: "true"
    #nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    # If you encounter a redirect loop or are getting a 307 response code 
    # then you need to force the nginx ingress to connect to the backend using HTTPS.
    #
    #nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
  - host: coder.allocsoc.net
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: coder
            port:
              number: 80
  tls:
  - hosts:
    - coder.allocsoc.net
    secretName: coder-tls

```
12. Write this to a file `coder.yaml` and apply `kubectl apply -f coder.yaml -n coder`


## Using Coder

### Testing out how it works

- Create a new Template and use the kubernetes one
	- select the coder namespace
- Create a Workspace
- After a couple of minutes, you should be able to access visual studio code on the machine
- the data in the home folder will be persisted between start/stop of the workspace
- Workspaces will be stoped after an idle time (24h by default I think) to save up resources
- To be able to use git
	- Account > SSH Keys 
	- Copy the SSH public key
	- Add it to your github account, or if you want, add it as a Deploy key so it can only access a single repo

### Open a SSH Tunnel

1. use the coder CLI to login with `coder login https://coder.company.com`
2. Login and paste the tokten into the console
3. `coder config-ssh` 
4. `ssh coder.<workspace_name>`

### Creating a new custom template

1. coder templates init
2. select the base you want to use
3. inside the folder created, modify the main.tf 
4. `coder template create digital-garden --variable namespace=coder`
5. Ready to be used :)

