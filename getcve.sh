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
release=""
version=""

echo "${package}"

function get_version
{
	version=`apt-cache policy "${package}" | grep "${release}" | cut -d' ' -f4`

	local websupport_str="-ws1"
	if [[ "${version}" == *"${websupport_str}" ]]; then
  		version="${version%${websupport_str}*}"
	fi
}

release="Installed"
get_version
current_version="${version}"

release="Candidate"
get_version
candidate_version="${version}"

echo "Current version: ${current_version}"
echo "Candidate version: ${candidate_version}"

full_changelog=`apt-get changelog "${package}=${candidate_version}"`
relevant_chagelog="${full_changelog%${current_version}*}"

# echo "${full_changelog}"
# echo "${relevant_chagelog}"

cves=`grep '\- CVE' <<< "${relevant_chagelog}" | cut -d' ' -f6`
# echo "${cves}"

cves_n=`wc -l <<< "${cves}"`
echo "Number of different CVE: ${cves_n}"

readarray -t cve_arr <<<"${cves}"

patches_n=0
for cve in "${cve_arr[@]}"
do
	patches_n=`grep "patches/${cve}" <<< "${relevant_chagelog}" | wc -l`
done

echo "${patches_n}"

