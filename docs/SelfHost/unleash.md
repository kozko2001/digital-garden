# Unleash

An open source toggle system that have a lot of goodies:
- strategies for release
- different types of toggles
- clients for major languages
- an API first approach (you can do almost all configuration via api)
- Metrics and experiments tab

## Install - With helm

1. Install the repo
```bash
helm repo add unleash https://docs.getunleash.io/helm-charts
helm repo update
```


2. Install unleash service 


2.1. modify unleash-values.yaml -- Most of the values look okay but I want to limit the size of the primary database

```yaml
postgresql:
  primary:
    persistence:
        size: 2Gb
ingress:
  enable: true
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    kubernetes.io/ingress.class: traefik
    kubernetes.io/tls-acme: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
  hosts:
  - host: unleash.allocsoc.net
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: unleash
            port:
              number: unleash
```

2.2 execute the dry run and check that looks okay

```
helm install unleash --dry-run --debug -f unleash-values.yaml unleash/unleash
```

2.3 create unleash namespace

```
kubectl create namespace unleash
```

2.4 Install without dry run

```
helm install unleash  -f unleash-values.yaml unleash/unleash
```
3. Repeat for unleash/proxy and unleash/edge that are necesary if you want to have client feature toggles