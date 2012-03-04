#!/bin/sh
###############################################################################
##
# FILE: 	pipethrough.sh
# PRODUCT:	tools
# AUTHOR: 	/^--
# DATE CREATED:	01-Jan-2004
#
###############################################################################
# PURPOSE:
#	Pipes the (list of) files through an external command and 
#	writes the output back into the file.
# ASSUMPTIONS / PRECONDITIONS:
#	?? List of any external variable, control, or other element whose state affects this procedure.
# EFFECTS / POSTCONDITIONS:
#	?? List of the procedure's effect on each external variable, control, or other element.
# INPUTS:
#	first argument: command (e.g. dos2ux)
#	next arguments: files to be modified
# RETURN VALUES: 
#	none
# REVISION	DATE		REMARKS 
#	013	26-May-2009	Replaced Korn Shell'ish 'print -R' with 'echo'. 
#	0.12	26-Sep-2006	Simplified print command. 
#	0.11	18-Oct-2005	BF: fixed unwanted escaping in echo. 
#	0.10	01-Jun-2004	BF: invoking ${command} via shell, because
#				commands with input redirection (e.g. "tr '\\'
#				'/' <") were hanging. 
#	0.01	01-Jan-2004	file creation
###############################################################################

if [ $# -lt 2 ]; then
	echo >&2 "Usage: $(basename -- "$0") <command> file [, ...]"
	exit 2
fi

command=$1
shift

for file do
	tempdestination=${file}.$$
	echo >&2 "${command} \"${file}\""
	sh -c "${command} \"${file}\" > \"${tempdestination}\" && mv \"${tempdestination}\" \"${file}\""
done

