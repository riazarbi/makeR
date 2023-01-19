# Lock to a particular Ubuntu image
FROM ubuntu:focal
LABEL authors="Riaz Arbi"
ARG R_VERSION=4.2.2
ARG DEBIAN_FRONTEND=noninteractive


# BASE ==========================================
# Set locales and install make
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y \
    locales locales-all tzdata
    
ENV TZ="Africa/Johannesburg"
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TERM xterm

# Install common utils
RUN apt-get install -y --no-install-recommends \
    make 

# Install R
RUN apt-get install -y --no-install-recommends \
    software-properties-common \
    dirmngr \
    curl \
    wget \
    gpg \
 && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
 && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
 && apt-get update \
 && apt-get install -y --no-install-recommends r-base 
 

# Install system dependencies for project R packages
COPY apt.txt .

RUN echo "Checking for 'apt.txt'..." \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing > /dev/null\
        && xargs -a apt.txt apt-get install --yes \
        && apt-get clean > /dev/null \
        && rm -rf /var/lib/apt/lists/* \
        ; fi

#Install R dependencies
COPY install.R .
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

WORKDIR /root