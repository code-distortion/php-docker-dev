ARG PYTHON_IMAGE
FROM $PYTHON_IMAGE

WORKDIR /app
SHELL ["/bin/bash", "--login", "-c"]



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



COPY home/.bashrc /home/www-data/.bashrc
COPY home/.bash_profile /home/www-data/.bash_profile
RUN chown www-data:www-data /home/www-data

RUN usermod -d /home/www-data www-data



ENTRYPOINT ["tail", "-f", "/dev/null"]
