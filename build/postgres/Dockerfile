ARG POSTGRES_IMAGE
FROM $POSTGRES_IMAGE



ARG POSTGRES_INSTALL_PGVECTOR
ARG POSTGRES_PGVECTOR_VERSION

# ====== install programs ======
# - Git,
# - make,
# - gcc,
# - postgresql-server-dev-17 (for the pgvector extension build process)
RUN if [ "${POSTGRES_INSTALL_PGVECTOR:-false}" = "true" ]; then \
      apt update \
      && apt install -y git make gcc postgresql-server-dev-17 \
      && apt clean && rm -rf /var/lib/apt/lists/*; \
    fi;

# ====== install the pgvector extension (for vector similarity search functionality) ======
RUN if [ "${POSTGRES_INSTALL_PGVECTOR:-false}" = "true" ]; then \
      cd /tmp \
      && git clone --branch "${POSTGRES_PGVECTOR_VERSION}" https://github.com/pgvector/pgvector.git \
      && cd pgvector \
      && make \
      && make install \
      && rm -rf /tmp/pgvector; \
    fi;



# ====== add a pgpass file, so that the postgres user connects to the database automatically ======
ARG POSTGRES_PASSWORD
RUN echo "localhost:5432:*:postgres:${POSTGRES_PASSWORD}" >> ~/.pgpass \
      && chmod 0600 ~/.pgpass \
    ;



# ====== copy the init scripts that are executed when the container is set up for the first time ======
RUN mkdir -p /docker-entrypoint-initdb.d
RUN mkdir -p /tmp/docker-entrypoint-initdb.d
COPY init-scripts/create_vector_extension.sql /tmp/docker-entrypoint-initdb.d/
RUN if [ "${POSTGRES_INSTALL_PGVECTOR:-false}" = "true" ]; then \
      cp /tmp/docker-entrypoint-initdb.d/create_vector_extension.sql /docker-entrypoint-initdb.d/; \
    fi;
RUN rm -rf /tmp/docker-entrypoint-initdb.d
