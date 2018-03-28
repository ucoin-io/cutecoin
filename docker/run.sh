#! /bin/bash

/etc/init.d/xvfb start 

docker/build.sh

pytest --cov=sakia tests
