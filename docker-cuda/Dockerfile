ARG CUDA=11.0
FROM nvidia/cuda:${CUDA}-base
# FROM directive resets ARGS, so we specify again (the value is retained if
# previously set).
ARG CUDA

# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    cuda-command-line-tools-${CUDA/./-} \
    git \
    hmmer \
    kalign \
    tzdata \
    wget \
    vim \
    hmmer \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda package manger.
RUN wget -q -P /tmp \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh

# Install conda packages.
ENV PATH="/opt/conda/bin:$PATH"
RUN conda update -qy conda \
    && conda install -y -c conda-forge \
        openmm=7.5.1 \
        pdbfixer \
        pip \
        jupyter \
        python=3.7

WORKDIR /app

COPY . .

RUN git clone https://github.com/rmeinl/alphafold.git alphafold/
RUN wget -q -P /app/alphafold/alphafold/common/ \
    https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt

# # Install pip packages.
RUN pip3 install --upgrade pip \
    && pip3 install -r /app/alphafold/requirements.txt \
    && pip3 install --upgrade jax

# # Apply OpenMM patch.
WORKDIR /opt/conda/lib/python3.7/site-packages
RUN patch -p0 < /app/alphafold/docker/openmm.patch

WORKDIR /app

EXPOSE 8888

# start the jupyter notebook in server mode
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]