FROM pudding/docker-app-filebrowse-20230822-1557

# =================================================================
# Configuration (don't remove)

ENV APP_NAME="File Browser"
ENV LOCAL_VOLUMN_PATH=/data/

# PORT不可以設定8080
ENV LOCAL_PORT=8081
ENV URL_TO_TEST_READY=http://127.0.0.1:8081/filebrowser/files/
ENV RUN_IN_LOCAL=true

# =================================================================
# Necessary Script, Do Not Remove

RUN apt-get update
RUN apt-get install -y curl wget nano rsync mlocate vim
RUN updatedb

COPY ./docker-build/startup.sh /startup.sh
COPY ./app-build/app-1-start.sh /app-1-start.sh
COPY ./app-build/app-2-afterstart.sh /app-2-afterstart.sh

ENTRYPOINT []
CMD ["bash", "/startup.sh"]

# =================================================================
# Other System Customization Scripts

RUN echo "OK"