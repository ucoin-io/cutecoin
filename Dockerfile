FROM registry.duniter.org/docker/python3/duniterpy-builder:0.0.7

# Install basic utils (vim for debug, can be removed)
RUN apt update ; apt install -y wget curl git vim zip

ENV PATH "/opt/qt/5.9/5.9.4/gcc_64/bin:$PYENV_ROOT/bin:$PATH"
ENV PYENV_PYTHON_VERSION 3.5.5

# Install python dev tools dependencies
ADD docker /docker/
RUN /docker/build_dependencies.sh

# Install python dependencies (for sakia and the dev tools)
ADD requirements.txt /docker
RUN eval "$(pyenv init -)"; \
    pyenv shell $PYENV_PYTHON_VERSION; \
    pip install -r /docker/requirements.txt

# Utils for building packages
ADD . /builder/
CMD "/docker/run.sh"
ENTRYPOINT []

