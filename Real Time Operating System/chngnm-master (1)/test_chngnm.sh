#!/bin/bash
# Test suite for ./chngnm.sh

# Find current script directory knowing that the chngnm.sh script is in the
# same directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
chngnm=$DIR/chngnm.sh
currtree="find . | sed -e 's/:$//' -e 's/[^-][^\/]*\//  /g'"

# Declare variables for the tests
TEST_ROOT_DIR="$DIR/test"
TEST_FIXTURE="$TEST_ROOT_DIR/fixture"
TESTS=(
    "Test help"
    "--help" 
    "Test uppercase file inputs"
    "-u fileRoot.sh ./dirA/*.txt"
    "Test paths with spaces"
    "-u './dir with Space/file with Space.txt' \"dir with Space/subDir with space\""
    "Test lowercase current directory subdirectories"
    "-l -s ./dirA ./dirB" 
    "Test no changes when input of directories without recursive or subdirectories"
    "-l -v ./dirA ./dirB" 
    "Test capitalize when duplicated input"
    "-c ./dirA/* ./dirA/fileDirA.sh ./dirA/fileDirA.sh --verbose" 
    "Test fails with two rename modes"
    "-l -u ./dirA/*" 
    "Test fails without rename mode"
    "-s ./dirA" 
    "Test fails renaming current directory"
    "-s -u ." 
    "Test recursive"
    "-r -c dirB dirA" 
    "Test capitalize recursively with subdirectories"
    "-crs dirB dirA" 
    "Test when parent and subdirectory are specified in recursive mode (Avoid duplicates)"
    "-urs ./dirA/subDirA ./dirA -v" 
)
# Show fixture tree
echo -e -n "\033[32mInput folder tree"
cd "$TEST_FIXTURE"
eval $currtree
# For test in tests
for ((i = 0; i < ${#TESTS[@]}; i+=2)); do
    TEST_NAME="${TESTS[$i]}"
    TEST="${TESTS[$i+1]}"
    TEST_NUM=$(($i+1))
    TEST_NUM=$(($TEST_NUM/2))
    TEST_DIR="$TEST_ROOT_DIR/$TEST_NUM"
    # Delete old test and copy fixture into a new test
    rm -r "$TEST_DIR" > /dev/null
    cp -R "$TEST_FIXTURE" "$TEST_DIR"
    cd "$TEST_DIR"
    # Display current
    echo -e '\033[0m'
    echo -e "\033[36m$TEST_NUM \033[1;33m$TEST_NAME"
    echo -e "\033[35mExecuted: \033[39mchngnm \033[1;34;49m$TEST\033[1;39m"
    ERROR=$(eval \"$chngnm\" $TEST 2>&1)
    ISERROR=$?
    if [[ $ISERROR -gt 0 ]]; then
        echo -e -n '\e[31m'
    else
        echo -e -n '\e[97m'
    fi
    if [[ ! -z "$ERROR" ]]; then
        echo "$ERROR"
    fi
    echo -e -n '\033[0m'
    if [[ $ISERROR -eq 0 ]]; then
        # Show result tree
        echo -e -n "\033[32mResult folder tree\033[0m"
        eval $currtree
    fi
    echo "chngnm $TEST" > test_command.txt
done