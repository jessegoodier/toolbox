FROM toolbox-common
USER root
# Install Azure CLI
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

USER toolbox
