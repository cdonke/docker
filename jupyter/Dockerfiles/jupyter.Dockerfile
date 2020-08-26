FROM ubuntu:20.04

ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="$PATH:/root/.dotnet/tools"

ENV DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # Opt out of telemetry until after we install jupyter when building the image, this prevents caching of machine id
    DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true



# Env Setup
RUN apt-get update && apt-get install -y \
    apt-utils \
	git \
    wget \
    apt-transport-https && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update 

# Pandoc
RUN apt-get install -y \
	pandoc \
	texlive-xetex \
	texlive-fonts-recommended
	
# Python
RUN apt-get install -y \
    ${PYTHON} \
	${PYTHON}-pip && \
	${PIP} install --upgrade pip 

# .NET Core
RUN apt-get install -y \
    dotnet-sdk-3.1 

# Jupyter Minimum
RUN ${PIP} install --upgrade \ 
    ipykernel \
    jupyter \
    notebook

# Jupyter Kernels
RUN ${PYTHON} -m ipykernel.kernelspec && \
    ${PYTHON} -m ipykernel install && \
    dotnet tool install --global Microsoft.dotnet-interactive && \
    dotnet interactive jupyter install

# Python Packages for ML
RUN ${PIP} install --upgrade \ 
    matplotlib \ 
    numpy \
    pandas \
    scipy \
	seaborn \
    sklearn \
	azureml-sdk \
    nltk \
    chainer \   
    spacy

# Language Packages
RUN ${PYTHON} -m spacy download pt_core_news_sm && \
    ${PYTHON} -m spacy download pt && \
    ${PYTHON} -c "import nltk; nltk.download('stopwords')" && \ 
    ${PYTHON} -c "import nltk; nltk.download('wordnet')" && \ 
    ${PYTHON} -c "import nltk; nltk.download('rslp')"

# Bash
COPY jupyter_notebook_config.py /root/.jupyter/
COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc

RUN mkdir /notebooks && chmod a+rwx /notebooks
RUN mkdir /.local && chmod a+rwx /.local

# Container
WORKDIR /notebooks
EXPOSE 8888

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter notebook --allow-root"]
