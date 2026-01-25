FROM toolbox-common
USER root
# Install AWS CLI
RUN apk add --no-cache aws-cli && \
    rm -rf /var/cache/apk/* && \
    aws --version
# Fix permissions for any config files created by root tools
RUN chown -R toolbox:toolbox /home/toolbox && \
    chmod -R 777 /home/toolbox

USER toolbox
