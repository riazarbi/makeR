FROM riazarbi/maker:latest

# Install system dependencies ==================================================
# BOTH JUPYTER AND RSTUDIO DEPS ================================================
RUN apt-get update --fix-missing > /dev/null \
 && apt-get install --yes \
    # for jupyter
    git \
    sudo \
    libzmq3-dev \
    # for Rstudio
    pkg-config \
    file \
    gdebi-core \
    psmisc \
    libclang-dev \
    libpq5 \
    openssl \
 && apt-get clean > /dev/null \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* 


# Install jupyter ==============================================================
RUN python3 -m pip install "charset-normalizer<3.0,>=2.0" \
 && python3 -m pip install pip install jsonschema[format-nongpl] 
RUN python3 -m pip install --no-cache-dir "notebook==6.5.1" "jupyterlab==3.4.8" \
 && python3 -m pip install --no-cache-dir jupyter-rsession-proxy jupyterhub
# Install jupyter R dependencies
COPY install.R .
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

# Install RSTUDIO
RUN wget --quiet https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb \
 && gdebi -n rstudio-server-1.4.1106-amd64.deb \
# Clean up
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/downloaded_packages

# Create $NB_USER
ARG NB_USER=maker
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
    
# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
WORKDIR ${HOME}

