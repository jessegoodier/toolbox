FROM toolbox-common
USER root
# Install AWS CLI
RUN apk add --no-cache aws-cli && \
    rm -rf /var/cache/apk/* && \
    aws --version
USER toolbox
