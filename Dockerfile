FROM registry.centos.org/centos/centos:7

# Install dependencies for mattermost-integration-gitlab
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install python-pip git && \
    pip install --upgrade pip && \
    yum clean all

# Install mattermost-integration-gitlab
RUN pip install git+https://github.com/NotSqrt/mattermost-integration-gitlab@4a61a48

# Run the integration as a service after making sure that the webhook url variable is set
CMD if [ "${MATTERMOST_WEBHOOK_URL}" = "" ]; then echo "FAILED. MATTERMOST_WEBHOOK_URL environment variable is not set."; echo "Consult README for more information."; exit 1; fi; mattermost_gitlab "${MATTERMOST_WEBHOOK_URL}" --push --tag --icon "${https://gitlab.com/assets/touch-icon-ipad-retina-8ebe416f5313483d9c1bc772b5bbe03ecad52a54eba443e5215a22caed2a16a2.png}" 

EXPOSE 5000
