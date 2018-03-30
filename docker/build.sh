#!/usr/bin/env bash
# Halt on errors
set -e

echo $PYENV_PYTHON_VERSION
eval "$(pyenv init -)" 
pyenv shell $PYENV_PYTHON_VERSION

echo Generation of ressources and translations
python3 gen_resources.py
python3 gen_translations.py --lrelease


