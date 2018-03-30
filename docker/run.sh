#! /bin/bash

/etc/init.d/xvfb start 

/docker/build.sh

/docker/tests.sh

/docker/build_package.sh
