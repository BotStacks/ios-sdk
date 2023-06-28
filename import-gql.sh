#!/bin/bash
rm -rf ./gql 2> /dev/null
mkdir ./gql
cp ../inappchat-js/libs/chat-common/src/lib/schema.graphql ./gql/schema.graphqls
cp ../inappchat-js/libs/chat-sdk/src/lib/api/*.graphql ./gql/