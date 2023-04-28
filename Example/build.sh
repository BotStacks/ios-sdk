#!/bin/bash

xcodebuild archive \
-workspace InAppChat-Example.xcworkspace \
-scheme InAppChat \
-destination "generic/platform=iOS" \
-archivePath ../build/InAppChat-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES