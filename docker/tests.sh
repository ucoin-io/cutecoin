#! /bin/bash

echo $PYENV_PYTHON_VERSION
eval "$(pyenv init -)" 
pyenv shell $PYENV_PYTHON_VERSION

DISPLAY=:99
/etc/init.d/xvfb start

echo install locally
python3 setup.py install

pytest --cov=sakia tests
