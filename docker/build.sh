#!/usr/bin/env bash
# Halt on errors
set -e

echo Generation of ressources and translations
python3 gen_resources.py
python3 gen_translations.py --lrelease

echo pyinstaller
python3 setup.py build
pyinstaller sakia.spec

echo install locally
python3 setup.py install
