FROM python:3.14-alpine

# Install packages available via apk
RUN apk add --no-cache \
    # Shell and basics
    zsh \
    bash \
    bash-completion \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    # HTTP and data transfer
    curl \
    wget \
    # JSON/YAML processing
    jq \
    # Search and file tools
    ripgrep \
    rclone \
    tree \
    less \
    file \
    # Networking and DNS
    bind-tools \
    netcat-openbsd \
    tcpdump \
    openssl \
    mtr \
    iputils \
    doggo \
    # System and process debugging
    htop \
    strace \
    procps \
    lsof \
    # Editors and version control
    neovim \
    git \
    # Compatibility and certs
    ca-certificates \
    # python utils
    uv \
    gcompat \
    libc6-compat

COPY .zshrc /root/.zshrc
COPY .bashrc /root/.bashrc

# Use buildx automatic platform ARGs
ARG TARGETPLATFORM

# Install yq (latest version)
RUN case ${TARGETPLATFORM} in \
    linux/amd64) YQ_ARCH="amd64" ;; \
    linux/arm64) YQ_ARCH="arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" && \
    chmod +x /usr/local/bin/yq

# Install kubectl (latest stable version)
RUN case ${TARGETPLATFORM} in \
    linux/amd64) KUBECTL_ARCH="amd64" ;; \
    linux/arm64) KUBECTL_ARCH="arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL_ARCH}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install grpcurl
RUN case ${TARGETPLATFORM} in \
    linux/amd64) GRPCURL_ARCH="linux_x86_64" ;; \
    linux/arm64) GRPCURL_ARCH="linux_arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    GRPCURL_VERSION=$(curl -s https://api.github.com/repos/fullstorydev/grpcurl/releases/latest | jq -r .tag_name) && \
    wget -qO /tmp/grpcurl.tar.gz "https://github.com/fullstorydev/grpcurl/releases/download/${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION#v}_${GRPCURL_ARCH}.tar.gz" && \
    tar -xzf /tmp/grpcurl.tar.gz -C /usr/local/bin grpcurl && \
    rm /tmp/grpcurl.tar.gz && \
    chmod +x /usr/local/bin/grpcurl

# Generate completions
RUN mkdir -p /toolbox \
    && mkdir -p /usr/share/bash-completion/completions \
    && mkdir -p /usr/share/zsh/site-functions

RUN kubectl completion bash > /usr/share/bash-completion/completions/kubectl
RUN yq shell-completion bash > /usr/share/bash-completion/completions/yq
RUN rclone completion bash /usr/share/bash-completion/completions/rclone
RUN doggo completion bash > /usr/share/bash-completion/completions/doggo || echo "doggo bash completion failed"
RUN grpcurl -completion bash > /usr/share/bash-completion/completions/grpcurl || echo "grpcurl bash completion failed"
RUN echo "complete -C '/usr/bin/aws_completer' aws" > /usr/share/bash-completion/completions/aws

# Generate zsh completions
RUN kubectl completion zsh > /usr/share/zsh/site-functions/_kubectl
RUN yq shell-completion zsh > /usr/share/zsh/site-functions/_yq
RUN rclone completion zsh /usr/share/zsh/site-functions/_rclone
RUN doggo completion zsh > /usr/share/zsh/site-functions/_doggo || echo "doggo zsh completion failed"
RUN grpcurl -completion zsh > /usr/share/zsh/site-functions/_grpcurl || echo "grpcurl zsh completion failed"

# Set zsh as the default shell
ENV SHELL=/bin/zsh
WORKDIR /toolbox
