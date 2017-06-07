# ------ Config ------
# By default lots of these are generated from
# details of the git repo but they can be replaced
# with specific values.

PIPELINE_NAME=	`git remote -v | grep fetch | head -n 1 | sed 's/.*\/\(.*\)\..*/\1/'`
GIT_REPO=		`git remote -v | grep fetch | head -n 1 | awk '{print $$2}'`
BRANCH=			`git branch | grep \* | awk '{print $$2}'`

SSH_KEY_PATH=	~/.ssh/id_rsa
LIVE_URL=		https://ci.concourse.ci

# ------ Defaults ------
# You shouldn't need to change these

TARGET=			dev
URL=			http://192.168.100.4:8080

# --------------------

init: start-concourse pipeline unpause-pipeline browse-dev

# Dev
login:
	./util/retry ./fly --target ${TARGET} login --concourse-url ${URL}

pipeline: login
	./fly --target ${TARGET} set-pipeline --pipeline ${PIPELINE_NAME} \
									 --config pipeline.yml \
									 --load-vars-from config-${TARGET}.yml \
									 --load-vars-from config-global.yml \
									 --var "private-repo-key=`cat ${SSH_KEY_PATH}`" \
									 --var "git-repo=${GIT_REPO}" \
									 --var "branch=${BRANCH}"

# Live
live-login: TARGET=live
live-login: URL=${LIVE_URL}
live-login: login

live-pipeline: TARGET=live
live-pipeline: live-login pipeline

# Setup
start-concourse:
	./util/setup-local-concourse

unpause-pipeline:
	./fly --target ${TARGET} unpause-pipeline --pipeline ${PIPELINE_NAME}

browse-dev:
	open http://192.168.100.4:8080/teams/main/login