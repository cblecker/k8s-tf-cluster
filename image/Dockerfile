# alpine:3.9 as of June 12, 2019
FROM alpine@sha256:769fddc7cc2f0a1c35abb2f91432e8beecf83916c421420e6a6da9f8975464b6 as base

# Download base APK packages
RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git

#########################
FROM base as installer

# Terraform version
ENV TERRAFORM_VERSION=0.12.1 TERRAFORM_SHA256SUM=c9a30d3e3abf751b3b3e323897e9c7cb411d5c4bb7473a3284a2a2b4b89f93ed

# Google Cloud SDK version
ENV GOOGLE_CLOUD_SDK_VERSION=250.0.0 GOOGLE_CLOUD_SDK_SHA256SUM=fe59b988c6a8a40ae98a3b9d0ea98b98e55e5061e8cec14d71e93b7d198c133e

# Download Terraform and put it's hash in the SUMS file
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" >> SHA256SUMS

# Download Google Cloud SDK and put it's hash in the SUMS file
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz > google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    echo "${GOOGLE_CLOUD_SDK_SHA256SUM}  google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" >> SHA256SUMS

# Validate the tool hashes
RUN sha256sum -c SHA256SUMS

# Unzip the files to their destinations after validated
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    tar xzf google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

#########################
FROM base

# Set path to include Google Cloud SDK
ENV PATH /google-cloud-sdk/bin:$PATH

# Copy files from installer step
COPY --from=installer /bin/terraform /bin/terraform
COPY --from=installer /google-cloud-sdk /google-cloud-sdk

# Disable Terraform CLI input by default
ENV TF_INPUT 0

# Expose volumes
VOLUME ["/root/.terraformrc", "/root/.config/gcloud", "/tf-project"]

WORKDIR /tf-project

ENTRYPOINT ["/bin/terraform"]
