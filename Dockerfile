FROM docker:18.09
WORKDIR /app
ENV DOCKER_HOST=tcp://docker:2375/
RUN apk update && apk add python3 curl bash openssh-client

ARG KUBECTL_VERSION=1.13.0 
ARG HELM_VERSION=2.12.3
ARG SKAFFOLD_VERSION=0.23.0

# install kubectl (https://github.com/kubernetes/kubectl)
RUN apk add -U openssl curl tar gzip bash ca-certificates git
RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x /usr/local/bin/kubectl

# install helm (https://github.com/helm/helm)
RUN curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN tar zxvf helm.tar.gz && rm helm.tar.gz
RUN chmod +x linux-amd64/helm
RUN mv linux-amd64/helm /usr/local/bin

# install skaffold (https://github.com/GoogleContainerTools/skaffold)
RUN curl -Lo /usr/local/bin/skaffold https://storage.googleapis.com/skaffold/releases/v${SKAFFOLD_VERSION}/skaffold-linux-amd64
RUN chmod +x /usr/local/bin/skaffold

# setup scripts
COPY . .
RUN mv generate-values-file setup-k8s login-in-gitlab /usr/local/bin