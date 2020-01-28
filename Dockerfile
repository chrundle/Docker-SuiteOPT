FROM ubuntu:bionic

MAINTAINER James Diffenderfer <jdiffen1@ufl.edu>

USER root
WORKDIR /root

SHELL [ "/bin/bash", "-c" ]

ARG PYTHON_VERSION_TAG=3.8.1
ARG LINK_PYTHON_TO_PYTHON3=1

# Install dependencies for building SuiteSparse and SuiteOPT for C
#libprotobuf-dev \
#protobuf-compiler \
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        gcc \
        g++ \
        gfortran \
        libopenblas-dev \
        make \
        sudo \
        bash-completion \
        git \
        subversion \
        vim

# Install Python 3 and pip
RUN apt-get install -y \
    python3 \
    python3-pip \
    python3-dev

# Install Python package dependencies for SuiteOPT
RUN pip3 install \
    cmake \
    setuptools \
    numpy \
    scipy

# Install SuiteOPT for Python
RUN pip3 install SuiteOPT

# Pull Demo files for SuiteOPT and copy to container
RUN svn checkout https://github.com/chrundle/python-SuiteOPT/trunk/Demo

# Create user "docker" with sudo powers
RUN useradd -m docker && \
    usermod -aG sudo docker && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp /root/.bashrc /home/docker/ && \
    mkdir /home/docker/data && \
    chown -R --from=root docker /home/docker

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /home/docker/data
ENV HOME /home/docker
ENV USER docker
USER docker
ENV PATH /home/docker/.local/bin:$PATH
# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful

CMD [ "/bin/bash" ]
