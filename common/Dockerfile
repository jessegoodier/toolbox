FROM python:3.14-alpine AS builder

# Install tools needed for downloading/extracting
RUN apk add --no-cache curl wget git jq tar

ARG TARGETPLATFORM

# Initialize output directories
RUN mkdir -p /out/usr/local/bin \
    && mkdir -p /out/usr/share/zsh/plugins/fzf-tab

# 1. Download yq (latest version)
RUN case ${TARGETPLATFORM} in \
    linux/amd64) YQ_ARCH="amd64" ;; \
    linux/arm64) YQ_ARCH="arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    wget -qO /out/usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" && \
    chmod +x /out/usr/local/bin/yq

# 2. Download kubectl (latest stable version)
RUN case ${TARGETPLATFORM} in \
    linux/amd64) KUBECTL_ARCH="amd64" ;; \
    linux/arm64) KUBECTL_ARCH="arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL_ARCH}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /out/usr/local/bin/

# 3. Clone fzf-tab
RUN git clone https://github.com/Aloxaf/fzf-tab /out/usr/share/zsh/plugins/fzf-tab

# === Final Stage ===
FROM python:3.14-alpine

# Install packages available via apk
# Included caching for apk
RUN --mount=type=cache,target=/var/cache/apk \
    apk add \
    # Shell and basics
    zsh bash bash-completion zsh-syntax-highlighting zsh-autosuggestions \
    # HTTP and data transfer
    curl wget \
    # JSON/YAML processing
    jq \
    # Search and file tools
    ripgrep rclone tree less file \
    # Networking and DNS
    bind-tools netcat-openbsd tcpdump openssl mtr iputils doggo \
    # System and process debugging
    htop strace procps lsof \
    # Editors and version control
    neovim git \
    # Compatibility and certs
    ca-certificates \
    # python utils
    uv gcompat libc6-compat \
    # Interactive tools
    fzf fd eza

# Copy binaries and tools from builder
COPY --from=builder /out /

# Generate completions
RUN mkdir -p /toolbox \
    && mkdir -p /usr/share/bash-completion/completions \
    && mkdir -p /usr/share/zsh/site-functions

RUN kubectl completion bash > /usr/share/bash-completion/completions/kubectl
RUN yq shell-completion bash > /usr/share/bash-completion/completions/yq
RUN rclone completion bash /usr/share/bash-completion/completions/rclone
RUN doggo completion bash > /usr/share/bash-completion/completions/doggo || echo "doggo bash completion failed"
RUN echo "complete -C '/usr/bin/aws_completer' aws" > /usr/share/bash-completion/completions/aws

# Generate zsh completions
RUN kubectl completion zsh > /usr/share/zsh/site-functions/_kubectl
RUN yq shell-completion zsh > /usr/share/zsh/site-functions/_yq
RUN rclone completion zsh /usr/share/zsh/site-functions/_rclone
RUN doggo completion zsh > /usr/share/zsh/site-functions/_doggo || echo "doggo zsh completion failed"

# Copy configuration files (Last to optimize caching)
COPY .zshrc /root/.zshrc
COPY .bashrc /root/.bashrc

# Set zsh as the default shell
ENV SHELL=/bin/zsh
WORKDIR /toolbox
