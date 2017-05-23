# ------ Config ------
PIPELINE_NAME=bootstrap

SSH_KEY_PATH=~/.ssh/id_rsa
LIVE_URL=https://ci.concourse.ci
# --------------------

init: vagrant-up download-fly config pipeline unpause-pipeline browse-dev

# Dev
login:
	./fly --target ${TARGET} login --concourse-url ${URL}

pipeline: login
	./fly --target ${TARGET} set-pipeline --pipeline ${PIPELINE_NAME} \
									 --config pipeline.yml \
									 --load-vars-from config-${TARGET}.yml \
									 --var "private-repo-key=`cat ${SSH_KEY_PATH}`" \
									 --var "git-repo=`git remote -v | grep fetch | head -n 1 | awk '{print $$2}'`"

# Live
live-login: TARGET=live
live-login: URL=${LIVE_URL}
live-login: login

live-pipeline: TARGET=live
live-pipeline: live-login pipeline

# Setup
vagrant-up:
	vagrant box update
	vagrant up

download-fly:
	./scripts/retry curl --user concourse:concourse -o fly '${URL}/api/v1/cli?arch=amd64&platform=${OS}' -m 30
	chmod +x fly

download-fly-linux: OS=linux
download-fly-win: OS=windows

config:
	cp -n ./config-dev.yml.sample ./config-dev.yml || true
	cp -n ./config-live.yml.sample ./config-live.yml || true

unpause-pipeline:
	./fly --target ${TARGET} unpause-pipeline --pipeline ${PIPELINE_NAME}

browse-dev:
	open http://192.168.100.4:8080/teams/main/login

# Defaults
TARGET=dev
OS=darwin
URL=http://192.168.100.4:8080