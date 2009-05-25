#!/bin/sh
###########################################################################HP##
##
# FILE: 	
# PRODUCT:	
# AUTHOR: 	
# DATE CREATED:	
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
#	0.12	26-Sep-2006	Simplified print command. 
#	0.11	18-Oct-2005	BF: fixed unwanted escaping in echo. 
#	0.10	01-Jun-2004	BF: invoking ${command} via shell, because
#	commands with input redirection (e.g. "tr '\\' '/' <") were hanging. 
#	0.01	00-Jan-2001	file creation
###############################################################################

if [ $# -lt 2 ]; then
	echo >&2 "Usage: `basename $0` <command> file [, ...]"
	exit 1
fi

command=$1
shift

for file do
	tempdestination=${file}.$$
	print -R >&2 "${command} \"${file}\""
	sh -c "${command} \"${file}\" > \"${tempdestination}\" && mv \"${tempdestination}\" \"${file}\""
	####- ${command} "${file}" > "${tempdestination}" && mv "${tempdestination}" "${file}"
done

