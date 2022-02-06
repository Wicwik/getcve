#!/bin/bash


## get cve
## Simple script to get number of lines mentioning word CVE in package changelog
## This script can be used alongside with zabbix to monitor CVE patches difference in available versions


## check for positional arguments or for -/-- options if you will (can be added later)
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

## for tesing and proof of concept purposes we can directly specify the package
## comment this if you want to use the first positional argument as an input
package="libssl1.1"
# echo "${package}"


## a function that will look for installed packages and their available releases
function get_version
{
	version=`apt-cache policy "${package}" | grep "${release}" | cut -d' ' -f4`

	local websupport_str="-ws1" ## remove websupport stuff
	if [[ "${version}" == *"${websupport_str}" ]]; then
  		version="${version%${websupport_str}*}"
	fi
}


## check for isntalled package version
release="Installed"
get_version
current_version="${version}"

## check for available package version
release="Candidate"
get_version
candidate_version="${version}"

# echo "Current version: ${current_version}"
# echo "Candidate version: ${candidate_version}"

## get full changelog and cut it to installed version of the package 
full_changelog=`apt-get changelog "${package}=${candidate_version}"`
relevant_chagelog="${full_changelog%${current_version}*}"

# echo "${full_changelog}"
# echo "${relevant_chagelog}"

## find all - CVE mentions in relevant changelog
cves=`grep '\- CVE' <<< "${relevant_chagelog}" | cut -d' ' -f6`
# echo "${cves}"

## count cves and print 
cves_n=`wc -l <<< "${cves}"`
echo "${cves_n}"


## this is for cve pathes number count
readarray -t cve_arr <<<"${cves}"

patches_n=0
for cve in "${cve_arr[@]}"
do
	patches_n=$((patches_n+`grep "patches/${cve}" <<< "${relevant_chagelog}" | wc -l`))
done

# echo "Number of CVE patches: ${patches_n}"

