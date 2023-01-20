FROM riazarbi/maker:latest

# Install system dependencies for project R packages
COPY apt.txt .

# Install system dependencies ==================================================
# BOTH JUPYTER AND RSTUDIO DEPS ================================================
RUN echo "Checking for 'apt.txt'..." \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing > /dev/null\
        && xargs -a apt.txt apt-get install --yes \
        && apt-get clean > /dev/null \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /tmp/* \
        ; fi


# Install jupyter ==============================================================
RUN apt-get purge -y python3-requests
RUN python3 -m pip install "charset-normalizer<3.0,>=2.0" \
 && python3 -m pip install pip install jsonschema[format-nongpl] 
RUN python3 -m pip install --no-cache-dir "notebook==6.5.1" "jupyterlab==3.4.8" \
 && python3 -m pip install --no-cache-dir jupyter-rsession-proxy jupyterhub
# Install jupyter R dependencies
COPY install.R .
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

# Install RSTUDIO
RUN wget --quiet https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb \
 && gdebi -n rstudio-server-1.4.1106-amd64.deb

#RUN ln -fs /usr/lib/rstudio-server/bin/rstudio-server /usr/local/bin
#RUN ln -fs /usr/lib/rstudio-server/bin/rserver /usr/local/bin

#ENV PATH="${PATH}:/usr/lib/rstudio-server/bin" 

# Clean up
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/downloaded_packages

#RUN jupyter kernelspec list

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

