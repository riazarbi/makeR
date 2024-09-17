FROM riazarbi/maker:latest

USER root

COPY install.R .

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
 && rm -rf /tmp/* \
# Install jupyter ==============================================================
 && python3 -m pip install "charset-normalizer" \
 && python3 -m pip install jsonschema[format-nongpl] \
 && python3 -m pip install --no-cache-dir "notebook" "jupyterlab" \
 && python3 -m pip install --no-cache-dir jupyter-rsession-proxy jupyterhub \
# Install jupyter R dependencies
 && if [ -f install.R ]; then R --quiet -f install.R; fi \
# Install RSTUDIO
 && wget --quiet https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.2-764-amd64.deb  \
 && gdebi -n rstudio-server-2024.04.2-764-amd64.deb \
# Clean up
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/downloaded_packages \
 && rm -rf rstudio-server-2024.04.2-764-amd64.deb \
# Install VSCode
 && curl -fsSL https://code-server.dev/install.sh | sh \
 && pip3 install jupyter-vscode-proxy 

# Back to non privileged user
# Make sure the contents of our repo are in ${HOME}
# These env vars are in FROM image
ENV NB_USER=maker
ENV NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
WORKDIR ${HOME}