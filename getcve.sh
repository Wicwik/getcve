#!/bin/bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
	case $1 in
		-*|--*)
			echo "Unknown option $1"
	     	exit 1
	    	;;

	    *)
	    	POSITIONAL_ARGS+=("$1")
	    	shift
	        ;;
    esac
done

package="${POSITIONAL_ARGS[0]}"
current_version=""
candidate_version=""


function get_current_version
{
	current_version=`apt-cache policy "${package}" | grep "Installed"`
}

function get_candidate_version
{
	candidate_version=`apt-cache policy "${package}" | grep "Candidate"`

}

echo "${current_version}"
echo "${candidate_version}"

