#!/bin/bash
openapi-generator-cli generate -i openapi.yaml -g swift5 -o . --additional-properties='responseAs=AsyncAwait,library=alamofire,podDocumentationURL=https://inappchat.io/docs/chatsdk/ios,podHomepage=https://inappchat.io,podLicense=MIT,podSocialMediaURL=https://twitter.com/inappchat,podVersion=1.0.0,projectName=InAppChat,useSPMFileStructure=true,removeMigrationProjectNameClass=true'