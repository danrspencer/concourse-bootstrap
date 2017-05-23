#!/usr/bin/env bash

REPO=concourse-bootstrap
BRANCH=master
URL=https://github.com/danrspencer/${REPO}/archive/${BRANCH}.zip

curl -L -O ${URL}
unzip ./master.zip
rm ./master.zip

mv ./${REPO}-${BRANCH}/ci ./ci
rm -rf ${REPO}-${BRANCH}

cd ./ci

vagrant init concourse/lite
make