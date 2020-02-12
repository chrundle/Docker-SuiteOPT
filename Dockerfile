FROM ubuntu:bionic

MAINTAINER James Diffenderfer <jdiffen1@ufl.edu>

USER root
WORKDIR /root

SHELL [ "/bin/bash", "-c" ]

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
        vim \
        python3 \
        python3-pip \
        python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3 and pip
#RUN apt-get install -y \
#    python3 \
#    python3-pip \
#    python3-dev

# Install Python package dependencies for SuiteOPT
# NOTE: On 2/12/2020 image build errors occurred with cmake version 3.16.3
# To avoid errors in future version numbers were assigned but should be updated
RUN pip3 install \
    cmake==3.13.3 \
    setuptools \
    numpy==1.18.1 \
    scipy==1.4.1

# Install SuiteOPT for Python
RUN pip3 install SuiteOPT --verbose
#        --install-option="--blas=-lopenblas -lgfortran -lpthread" \
#        --install-option="--lapack=-llapack" \
#        --install-option="--ldlibs=-L/usr/lib/x86_64-linux-gnu/openblas"

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

# Download Demo files for SuiteOPT and copy to container
RUN svn checkout https://github.com/chrundle/python-SuiteOPT/trunk/Demo /home/docker/data/SuiteOPT-Demo/.
#COPY Demo/. /home/docker/data/SuiteOPT-Demo/.


CMD [ "/bin/bash" ]
