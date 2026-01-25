FROM toolbox-common
USER root
# Install Google Cloud SDK
# Using the install script which automatically handles architecture and installation
RUN curl -sSL https://sdk.cloud.google.com > /tmp/install_gcloud.sh && \
    bash /tmp/install_gcloud.sh --disable-prompts --install-dir=/usr/local/share && \
    ln -s /usr/local/share/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    ln -s /usr/local/share/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil && \
    rm /tmp/install_gcloud.sh && \
    gcloud --version

# Fix permissions for any config files created by root tools
RUN chown -R toolbox:toolbox /home/toolbox && \
    chmod -R 777 /home/toolbox

USER toolbox
