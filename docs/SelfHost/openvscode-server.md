Open VSCode Server
=================

Is a Visual Studio code server that works on the browser....

that is great for my note taking process, specially if I want to read at a coffee house with my ipad and take some notes in the go.

It's quite easy to configure, see [here](https://github.com/gitpod-io/openvscode-server) the documentation.


Two points that I think are important to make a point.


### Set a token

This will give you a terminal to your server, and should be properly secured. **give it a strong password!**


### Customize Docker image

The images comes with almost nothing instaled, you can install everything from the console of vscode.... but if the images disappears you will need to start again and so on...

Better create a **Dockerfile** with all the tools you need to work

### My Config in k8s

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: workspace
  namespace: code
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1G
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: vscode-tls
  namespace: code
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: kozko2001@gmail.com
    privateKeySecretRef:
      name: vscode-tls
    solvers:
    - http01:
        ingress:
          class: traefik 
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: code-ingress
  namespace: code
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    kubernetes.io/ingress.class: traefik
    kubernetes.io/tls-acme: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    # If you encounter a redirect loop or are getting a 307 response code 
    # then you need to force the nginx ingress to connect to the backend using HTTPS.
    #
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
  - host: code.allocsoc.net
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: vscode
            port:
              number: 3000 
  tls:
  - hosts:
    - code.allocsoc.net
    secretName: vscode-tls # do not change, this is provided by Argo CD
---
apiVersion: v1
kind: Service
metadata:
  namespace: code
  labels:
    app: vscode
  name: vscode
spec:
  ports:
  - name: web
    port: 3000
    protocol: TCP
    targetPort: 3000
  selector:
    app: vscode
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vscode
  namespace: code 
spec:
  selector:
    matchLabels:
      app: vscode
  template:
    metadata:
      labels:
        app: vscode
    spec:
      containers:
        - image: gitpod/openvscode-server:nightly
          imagePullPolicy: Always
          name: vscode
          command:
            - /bin/sh
            - -c
            - |-
              /home/.openvscode-server/bin/openvscode-server --host 0.0.0.0 --connection-token YOUR_STRONG_PASSWORD_HERE
          volumeMounts:
          - mountPath: /home/workspace
            name: workspace
      restartPolicy: Always
      volumes:
      - name: workspace
        persistentVolumeClaim:
          claimName: workspace
---
```