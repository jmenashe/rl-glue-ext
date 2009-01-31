#!/bin/sh
#
# Runs a specified functional test with a selected Lisp implementation
# and prints the result to the standard output.
#
# $Revision$
# $Date$

if [ ${#} -ne 2 ]; then
    echo "Usage: ${0} <lisp-implementation> <testcase-name>"
    echo "Example: ${0} sbcl test-empty"
    exit -1
fi

tooldir="`dirname ${0}`"
source "${tooldir}/common.sh"

lispimpl="${1}"
testname="${2}"

###############################################################################

load_lisp_config ${lispimpl}
load_functional_test_config ${testname}

###############################################################################

rl_glue &

{
${LISP} <<- EOF
  `lisp_init`
  (asdf:oos 'asdf:load-op :rl-glue-tests :verbose nil)
  (rl-glue-tests:start-${AGENT})
  `lisp_quit`
EOF
} &

{
${LISP} <<- EOF
  `lisp_init`
  (asdf:oos 'asdf:load-op :rl-glue-tests :verbose nil)
  (rl-glue-tests:start-${ENVIRONMENT})
  `lisp_quit`
EOF
} &

${LISP} <<- EOF 
  `lisp_init`
  (asdf:oos 'asdf:load-op :rl-glue-tests :verbose nil)
  (rl-glue-tests:start-${EXPERIMENT})
  `lisp_quit`
EOF

exit 0
