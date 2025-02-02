FROM pudding/docker-app-filebrowse-20230822-1557

# =================================================================
# Configuration (don't remove)

ENV APP_NAME="File Browser"
ENV LOCAL_VOLUMN_PATH=/data/

ENV LOCAL_PORT=8080
ENV URL_TO_TEST_READY=http://127.0.0.1:8080/

# =================================================================
# Necessary Script, Do Not Remove

COPY ./../docker-build/startup.sh /startup.sh
COPY ./app-1-start.sh /app-1-start.sh
COPY ./app-2-afterstart.sh /app-2-afterstart.sh

ENTRYPOINT []
CMD ["bash", "/startup.sh"]

# =================================================================
# Other System Customization Scripts

RUN echo "OK"