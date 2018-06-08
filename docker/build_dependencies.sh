#! /bin/bash
apt install zip

echo $PYENV_PYTHON_VERSION
eval "$(pyenv init -)" 
pyenv shell $PYENV_PYTHON_VERSION

pip install --upgrade pip
pip install coveralls
pip install pytest-cov
pip install pyinstaller==3.2
pip install dbus-python==1.2.4
pip install notify2

# Install python dependencies for sakia
pip install -r requirements.txt
