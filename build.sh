#!/bin/bash

project="EllipticCurveKeyPair"
echo "project name $project"

xcodeproj="${project}.xcodeproj"
echo "xcode project file $xcodeproj"

#xcworkspace="${project}.xcworkspace"
#echo "xcode workspace file $xcworkspace"

# set scheme
scheme="${project}-iOS"
echo "xcode scheme set to $scheme"

# set configuration
configuration="release"
echo "xcode configuration set to $configuration"

# set custom path for all xcarchive
# the archive directory is hidden
archivePath="./.xcarchives"
echo "archive path set to $archivePath"

# path to EllipticCurveKeyPair.xcframework
xcFrameworkPath="${archivePath}/${project}.xcframework"
echo "xcframework path set to $xcFrameworkPath"

# define list of destinations
destinations=("generic/platform=iOS" "generic/platform=iOS Simulator")

# list of platforms
platforms=("iphoneos" "iphonesimulator")

# clean build
echo "cleaning started"
xcodebuild clean
echo "cleaning finished"

# remove .xcframework directory, if exist
if [ -d "./${project}.xcframework" ]; then
    printf '%s\n' "removing ${project}.xcframework"
    rm -rf "./${project}.xcframework"
fi

# make sure the xcarchives directory exists
mkdir -p "${archivePath}"

index = 0
for destination in "${destinations[@]}"; do
    echo "archiving for "${destination}" started ..."

    xcodebuild archive \
    -project "${xcodeproj}" \
    -scheme "${scheme}" \
    -configuration "${configuration}" \
    -destination "${destination}" \
    -archivePath "${archivePath}/${platforms[$((index++))]}.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

    if test $? -eq 0
        then
            echo "... archiving for "${destination}" finished successfully"
        else
            echo "... archiving for "${destination}" failed with error code: ${?}"
        exit $?
    fi
done

echo "archiving for all destinations is completed"
echo "time to create xcframework"

# FIX ME: ready all platforms xcarchive
# and
# generate and append -framework path
xcodebuild -create-xcframework \
-framework "${archivePath}/${platforms[0]}.xcarchive/Products/Library/Frameworks/${project}.framework" \
-framework "${archivePath}/${platforms[1]}.xcarchive/Products/Library/Frameworks/${project}.framework" \
-output "${xcFrameworkPath}"

cd ${xcFrameworkPath}
find . -name "*.swiftinterface" -exec sed -i -e 's/'${project}'\.//g' {} \;

if test $? -eq 0
    then
        echo ":-) YaY, ${project} .xcframework created successfully"
    else
        echo ":-( Uh Oh, ${project} .xcframework creation failed with error code: ${?}"
        exit $?
fi

# change present working directory
# move to project root directory
cd ../..

# copy EllipticCurveKeyPair.xcframework to root project directory
echo "copying ${project}.xcframework ..."
cp -r "${xcFrameworkPath}" "./"
echo "... ${project}.xcframework copied successfully"

# remove .xcarchives directory
if [ -d "$archivePath" ]; then
    printf '%s\n' "removing ($archivePath)"
    rm -rf "$archivePath"
fi

exit 0
