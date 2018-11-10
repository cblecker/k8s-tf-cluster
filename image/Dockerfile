# alpine:3.8 as of November 9, 2018
FROM alpine@sha256:621c2f39f8133acb8e64023a94dbdf0d5ca81896102b9e57c0dc184cadaf5528 as base

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
ENV TERRAFORM_VERSION=0.11.10 TERRAFORM_SHA256SUM=43543a0e56e31b0952ea3623521917e060f2718ab06fe2b2d506cfaa14d54527

# Google Cloud SDK version
ENV GOOGLE_CLOUD_SDK_VERSION=224.0.0 GOOGLE_CLOUD_SDK_SHA256SUM=0a85de5c35c562f5d602ad20f567d45a214e91e5570ae95a93ced8361fa6d021

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

# Automatically upgrade providers on init
ENV TF_CLI_ARGS_init "-upgrade"

# Expose volumes
VOLUME ["/root/.config/gcloud", "/tf-project"]

WORKDIR /tf-project

ENTRYPOINT ["/bin/terraform"]
