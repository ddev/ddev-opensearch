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

execute_test() {
  echo "# ddev get ${ADDON_PATH} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${ADDON_PATH} >/dev/null
  health_checks
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev get` on a new service
  run ddev restart
  assert_success

  # Make sure we can hit the 9200 and 5601 port successfully
  curl -s -I -f  https://${PROJNAME}.ddev.site:9200 >/tmp/curlout.txt
  curl -s -I -f  https://${PROJNAME}.ddev.site:5601 >/tmp/curlout.txt
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
