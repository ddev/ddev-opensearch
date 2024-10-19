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
  ddev config --omit-containers="db" >/dev/null 2>&1 || true
  ddev start -y >/dev/null
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev add-on get` on a new service
  ddev restart

  # For debugging purposes
  ddev describe

  # Check opensearch port
  curl -sL https://test-opensearch.ddev.site:9201

  # Check if dashboard is accessible
  curl -sL https://test-opensearch.ddev.site:5602
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
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR}
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get ${ADDON_PATH} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${ADDON_PATH}
  health_checks
}
