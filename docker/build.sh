#!/usr/bin/env bash
# Halt on errors
set -e

echo $PYENV_PYTHON_VERSION
eval "$(pyenv init -)" 
pyenv shell $PYENV_PYTHON_VERSION

echo "PATH=$PATH"
export PATH=/opt/qt/5.9/5.9.4/gcc_64/bin:$PATH

echo "DISPLAY=$DISPLAY"
export DISPLAY=:99

echo Generation of ressources and translations
python3 gen_resources.py
python3 gen_translations.py --lrelease


