FROM toolbox-common
USER root

# 1. Install Azure CLI (Heavy build, slow)
# Use system python (stable) for Azure CLI to avoid conflicts with Python 3.14 (unstable/alpha)
# and use venv to keep it isolated.
RUN apk add --no-cache python3 py3-pip gcc musl-dev python3-dev libffi-dev openssl-dev make cargo linux-headers && \
    python3 -m venv /opt/azure-cli && \
    /opt/azure-cli/bin/pip install --upgrade pip && \
    # Install azure-cli in venv
    /opt/azure-cli/bin/pip install azure-cli && \
    ln -s /opt/azure-cli/bin/az /usr/local/bin/az && \
    # Cleanup build deps
    apk del gcc musl-dev python3-dev libffi-dev openssl-dev make cargo linux-headers && \
    az --version

# 2. Install Google Cloud SDK (Archive download)
# Using the install script which automatically handles architecture and installation
RUN curl -sSL https://sdk.cloud.google.com > /tmp/install_gcloud.sh && \
    bash /tmp/install_gcloud.sh --disable-prompts --install-dir=/usr/local/share && \
    ln -s /usr/local/share/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    ln -s /usr/local/share/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil && \
    rm /tmp/install_gcloud.sh && \
    gcloud --version

# 3. Install AWS CLI (Simple APK)
RUN apk add --no-cache aws-cli && \
    rm -rf /var/cache/apk/* && \
    aws --version

# Fix permissions for any config files created by root tools
RUN chown -R toolbox:toolbox /home/toolbox && \
    chmod -R 777 /home/toolbox

USER toolbox
