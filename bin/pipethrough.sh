#!/bin/sh

###############################################################################
#	PURPOSE:
#	Pipes the (list of) files through an external command and 
#	writes the output back into the file.
#	ASSUMPTIONS	/ PRECONDITIONS:
#	?? List of any external variable, control, or other element whose state affects this procedure.
#	EFFECTS		/ POSTCONDITIONS:
#	?? List of the procedure's effect on each external variable, control, or other element.
#	INPUTS:
#	first argument: command (e.g. dos2ux)
#	next arguments: files to be modified
#	RETURN VALUES: 
#	none
###############################################################################
if [ $# -lt 2 ]; then
	echo "Usage: `basename $0` <command> file [, ...]"
	exit 1
fi

command=$1
shift

for file do
	tempdestination=${file}.$$
	echo "${command} "'"'"${file}"'"'
	${command} "${file}" > "${tempdestination}" && mv "${tempdestination}" "${file}"
done
