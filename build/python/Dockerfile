ARG PYTHON_IMAGE
FROM $PYTHON_IMAGE

WORKDIR /app



# ====== set the www-data user to match the current user's uid and gid ======
ARG SET_WWW_DATA_USER
ARG WWW_DATA_UID
ARG WWW_DATA_GID
RUN if [ ${SET_WWW_DATA_USER} = true ]; then \
    groupmod -g $WWW_DATA_GID www-data \
    && usermod -u $WWW_DATA_UID -g $WWW_DATA_GID www-data \
;fi



RUN apt-get update \
    && apt-get -y install ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    ;

RUN echo 'export PATH=$PATH:/www-data/scripts' >> "/root/.bashrc"

ENTRYPOINT ["tail", "-f", "/dev/null"]
