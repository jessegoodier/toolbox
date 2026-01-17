FROM toolbox-common

# Install AWS CLI
RUN apk add --no-cache aws-cli && \
    rm -rf /var/cache/apk/* && \
    aws --version
