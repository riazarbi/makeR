FROM riazarbi/maker:latest

USER root

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
    libssl-dev \
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
RUN wget --quiet https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.12.0-353-amd64.deb  \
 && gdebi -n rstudio-server-2022.12.0-353-amd64.deb \
# Clean up
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/downloaded_packages

# Ensure correct place for saving R packages
ENV R_LIBS_SITE=/usr/local/lib/R/site-library
ENV R_LIBS_USER=/usr/local/lib/R/site-library


# Back to non privileged user
# Make sure the contents of our repo are in ${HOME}
# These env vars are in FROM image
ENV NB_USER=maker
ENV NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
WORKDIR ${HOME}
