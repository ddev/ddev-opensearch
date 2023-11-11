setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-opensearch
  mkdir -p $TESTDIR
  export PROJECTNAME=test-opensearch
  export ADDON_PATH="netz98/ddev-opensearch"
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJECTNAME} >/dev/null 2>&1 || true
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev config --project-name=${PROJECTNAME}
  ddev start -y >/dev/null
}

execute_test() {
  echo "# ddev get ${ADDON_PATH} with project ${PROJECTNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${ADDON_PATH} >/dev/null
  ddev restart >/dev/null
  health_checks
}

health_checks() {
  ddev exec "curl -s opensearch:9200" | grep "${PROJECTNAME}-opensearch"
  ddev exec -s opensearch-dashboards "curl -s -i opensearch-dashboards:5601" | grep -q "osd-name"
}

teardown() {
  ddev delete -Oy ${PROJECTNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  ADDON_PATH="${DIR}"
  execute_test
}

#@test "install from release" {
#  execute_test
#}
