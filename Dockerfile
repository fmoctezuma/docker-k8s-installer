FROM alpine:latest
MAINTAINER "HashiCorp Terraform Team <terraform@hashicorp.com>"

#ENV TERRAFORM_VERSION=0.9.10
#ENV TERRAFORM_SHA256SUM=77f0d01182d665f7f3c63c326aa699b452fba043c2e2f9050c4bd114f98a1207
ENV TERRAFORM_VERSION=0.10.0-beta1
ENV TERRAFORM_SHA256SUM=9e14c850054faaaa3f40a1c28d8991fc4a42f0dc2d53564d8f60b12243c7ae5d
RUN apk add --update git curl openssh && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ENTRYPOINT ["/bin/terraform"]
