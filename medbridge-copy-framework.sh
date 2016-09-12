#!/bin/sh

#  medbridge-copy-framework.sh
#  PromiseKit
#
#  Created by Steve on 8/26/16.

# This shell script copies PromiseKit.framework from a location in the Build/Products/<configuration> directory into the Build/Products directory.
# This way, other projects may easily find the copy without having to know which <configuration> directory to look in.
# The script can be run via a Xcode target / Build Settings / Run Script step.

echo "medbridge-copy-framework.sh"
# to log environment variables and build settings, uncomment "export" statement
# http://stackoverflow.com/questions/6910901/how-do-i-print-a-list-of-build-settings-in-xcode-project
#export

# When running MedBridgeIosCore
# BUILD_DIR/.. resolves to DerivedData/<dir>/Build
# BUILD_DIR and SYMROOT both resolve to DerivedData/<dir>/Build/Products
# CONFIGURATION_BUILD_DIR resolves to DerivedData/<dir>/Build/Products/Release-iphonesimulator

# When running MedBridgeIosCore unit tests via command-u
# BUILD_DIR and SYMROOT both resolve to DerivedData/<dir>/Build/Intermediates/CodeCoverage/Products
# CONFIGURATION_BUILD_DIR resolves to DerivedData/<dir>/Build/Intermediates/CodeCoverage/Products/Release-iphonesimulator

# Delimit with quotes "" to properly evaluate directory name that may contain spaces
# http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script#59839

# http://stackoverflow.com/questions/2600281/what-is-the-difference-between-operator-and-in-bash/2601583#2601583
if [ -d "${CONFIGURATION_BUILD_DIR}" ]; then
    # source directory exists, code can reference it safely

    # sorry about writing consecutive single conditionals!
    # Xcode didn't recognize [[ ]] and I gave up on writing a compound conditional bash statement
    if [ -d "${BUILD_DIR}" ]; then
        # destination directory exists, code can reference it safely

        # if source and destination directories are equal don't attempt copy
        # For example, Jenkins may have set BUILD_DIR and CONFIGURATION_BUILD_DIR to evaluate to the same path ${WORKSPACE}/build
         # I think =! syntax works, if not could try -ne
        if [ "${BUILD_DIR}" != "${CONFIGURATION_BUILD_DIR}" ]; then

            if [ -d "${BUILD_DIR}/PromiseKit.framework" ]; then
                # framework exists at destination. Delete it
                echo "PromiseKit.framework already exists in BUILD_DIR ${BUILD_DIR}. Deleting prior to copy."
                rm -r "${BUILD_DIR}/PromiseKit.framework"
            fi

            echo "copying PromiseKit.framework from CONFIGURATION_BUILD_DIR ${CONFIGURATION_BUILD_DIR}"
            echo "to BUILD_DIR ${BUILD_DIR}"
            echo "SYMROOT ${SYMROOT}"
            # NOTE: Don't append PromiseKit.framework to destination path, it could nest PromiseKit.framework directory inside itself
            cp -r "${CONFIGURATION_BUILD_DIR}/PromiseKit.framework" "${BUILD_DIR}"
        fi
    fi
fi