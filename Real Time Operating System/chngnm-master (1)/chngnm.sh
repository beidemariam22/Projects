#!/bin/bash
################################################################################
#                                   chngnm                                     #
#                                                                              #
# Change names of files. Lowercasing, uppercasing or capitalizing file and     #
# directory names either with recursion or without it.                         #
#                                                                              #
# Change History                                                               #
# 25/11/2020  Andreu Gimenez    Original code.                                 #
#                                                                              #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2020 Andreu Gimenez                                           #
#  esdandreu@gmail.com                                                         #
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#                                                                              #
#  You should have received a copy of the GNU General Public License           #
#  along with this program; if not, write to the Free Software                 #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   #
#                                                                              #
################################################################################
################################################################################
################################################################################
# Saner programming env: these switches turn some bugs into errors
# set -o errexit -o pipefail -o noclobber -o nounset

# Allow a command to fail with !’s side effect on errexit
# Use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    >&2 echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=rsluchv
LONGOPTS=recursive,subdirectories,lowercase,uppercase,capitalize,help,verbose

# Help on getopts https://www.computerhope.com/unix/bash/getopts.htm
# Regarding ! and PIPESTATUS see above
# Temporarily store output to be able to check for errors
# Activate quoting/enhanced mode (e.g. by writing out “--options”)
# Pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # If getopt has complained about wrong arguments to stdout
    exit 2
fi
# Set the parsed parameters as the script arguments to be accessible with $@
eval set -- "$PARSED" # Use eval in order to expand $PARSED

# Handle option arguments
r=0 s=0 v=0 m=
while true; do # Iterate over the parsed arguments
    case "$1" in
        -r|--recursive)
            r=1
            shift
            ;;
        -s|--subdirectories)
            s=1
            shift
            ;;
        -l|--lowercase)
            m+=1
            shift
            ;;
        -u|--uppercase)
            m+=2
            shift
            ;;
        -c|--capitalize)
            m+=3
            shift
            ;;
        -h|--help)
            # Find current script directory knowing that help.txt is in the
            # same directory
            DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
            echo "`cat "$DIR/help.txt"`"
            exit 0
            ;;
        -v|--verbose)
            v=1
            shift
            ;;
        # getopt returns a "--" to specify where the positional arguments begin
        --)
            shift
            break
            ;;
        # Default case, it should never be accessed because the options are
        # checked by getopt, no option should be unexpected at this point of
        # the script
        *)
            echo "Programming error"
            exit 3
            ;;
    esac # End case
done

# Handle non-option arguments, i.e. the files and directories to rename
elements=()
directories=()
while [[ $# -gt 0 ]]; do # Iterate over the parsed arguments
    if [[ -f "$1" ]]; then
        elements+=("$1")
    elif [[ -d "$1" ]]; then
        directories+=("$1")
        if [[ $s -eq 1 ]]; then # Allow modification of directories
            # TODO Be careful with PWD . ./
            elements+=("$1")
        fi
    else
        >&2 echo "\`$1\` is not a file or a directory"
    fi
    shift
done
if [[ ${#elements[@]} -lt 1 ]] && [[ ${#directories[@]} -lt 1 ]]; then
    >&2 echo "$0: At least one valid input file or directory is required."
    exit 1 # We use the code for general errors https://shapeshed.com/unix-exit-codes/
fi

# Handle renaming mode specified
if [[ $m -lt 1 ]]; then 
    >&2 echo "$0: A renaming mode is required. Check 'chngnm --help' for more details."
    exit 1
elif [[ $m -gt 3 ]]; then 
    >&2 echo "$0: Just one renaming mode is accepted. Check 'chngnm --help' for more details"
    exit 1
fi

# Adds file directories to the elements to be renamed recursively if specified.
# Also adds the subdirectories if it is specified.
if [[ $r -ne 0 ]]; then # Recursive
    for ((i = 0; i < ${#directories[@]}; i++)); do
        dir="${directories[$i]}"
        _command="find '$dir' "
        if [[ $s -eq 1 ]]; then # Add subdirectories
            _command+=" -print"
        else # Avoid subdirectories
            _command+=" -type f -print"
        fi
        readarray -t new_elements <<< "$(eval $_command)"
        # elements+=("$(eval $_command)")
        elements+=("${new_elements[@]}")
    done
fi

if [[ ${#elements[@]} -gt 0 ]]; then
    # Remove duplicate elements and order by depth (Renaming order is important)
    for ((i = 0; i < ${#elements[@]}; i++)); do
        elements[$i]="$(echo "${elements[$i]}" | tr -cd '/' | wc -c)${elements[$i]}"
    done
    readarray -t elements <<< $(printf "%s\n" "${elements[@]}" | sort -u --key=1.2 | sort -nr | cut -c2-)

    # Renames the elements
    for ((i = 0; i < ${#elements[@]}; i++)); do
        el="${elements[$i]}"
        # Decompose the element to be renamed
        path=`dirname -- "$el"`
        name=`basename -- "$el"`
        if [[ $name == *.* ]]; then
            ext=${name#*.}
        else
            ext=
        fi
        name="${name%.*}"
        # Make the change to the name
        if [[ $m -eq 1 ]]; then # lowercase
            renamed=$(echo "$name" | tr '[:upper:]' '[:lower:]')
        elif [[ $m -eq 2 ]]; then # uppercase
            renamed=${name^^}
        else # capitalize
            renamed=${name^}
        fi
        # Build the new element
        if [[ -z "$ext" ]]; then # Check no extension
            new_el="$path/$renamed"
        else
            new_el="$path/$renamed.$ext"
        fi
        # Verbose message
        [[ v -eq 0 ]] || echo renaming "$el" into "$new_el"
        # Rename the element
        OUT=$(mv "$el" "$new_el" --force 2>&1)
        ISERROR=$?
        if [[ ! -z "$OUT" ]]; then
            if [[ $ISERROR -gt 0 ]]; then
                >&2 echo "$0: $OUT"
                exit 1
            else
                echo "$0: $OUT"
            fi
        fi
    done
else
    # Verbose message
    [[ v -eq 0 ]] || echo "Could not rename any element"
fi