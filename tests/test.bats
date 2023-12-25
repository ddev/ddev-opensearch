setup() {
  set -eu -o pipefail

  brew_prefix=$(brew --prefix)
  load "${brew_prefix}/lib/bats-support/load.bash"
  load "${brew_prefix}/lib/bats-assert/load.bash"

  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-opensearch
  mkdir -p $TESTDIR
  export PROJNAME=test-opensearch
  export ADDON_PATH="netz98/ddev-opensearch"
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev config --project-name=${PROJNAME}
  ddev config --omit-containers=dba >/dev/null 2>&1 || true
  ddev start -y >/dev/null
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev get` on a new service
  run ddev restart
  assert_success
  
  # Check opensearch port
  ddev exec "curl -s http://opensearch:9200" | grep "${PROJNAME}-opensearch"

  # Check if dashboard is accessible
  ddev exec "curl -s http://opensearch-dashboards:5601/app/home" | grep "OpenSearch Dashboards"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR} >/dev/null 2>&1
  ddev mutagen sync >/dev/null 2>&1
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get ${ADDON_PATH} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${ADDON_PATH} >/dev/null 2>&1
  ddev restart >/dev/null 2>&1
  health_checks
}
