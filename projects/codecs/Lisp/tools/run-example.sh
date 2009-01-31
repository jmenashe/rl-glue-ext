#!/bin/sh
#
# Runs a specified example with a selected Lisp implementation
# and prints the result to the standard output.
#
# $Revision$
# $Date$

if [ ${#} -ne 2 ]; then
    echo "Usage: ${0} <lisp-implementation> <example>"
    echo "Example: ${0} sbcl mines-sarsa"
    exit -1
fi

tooldir="`dirname ${0}`"
source "${tooldir}/common.sh"

lispimpl="${1}"
example="${2}"

###############################################################################

load_lisp_config ${lispimpl}

###############################################################################

rl_glue &

{
${LISP} <<- EOF
  `lisp_init`
  (asdf:oos 'asdf:load-op :rl-glue-examples :verbose nil)
  (rl-glue-${example}:start-agent)
  `lisp_quit`
EOF
} &

{
${LISP} <<- EOF
  `lisp_init`
  (asdf:oos 'asdf:load-op :rl-glue-examples :verbose nil)
  (rl-glue-${example}:start-environment)
  `lisp_quit`
EOF
} &

${LISP} <<- EOF
  `lisp_init`
  (asdf:oos 'asdf:load-op :rl-glue-examples :verbose nil)
  (rl-glue-${example}:start-experiment)
  `lisp_quit`
EOF

exit 0
