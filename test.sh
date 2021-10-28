#!/bin/bash

COOKIE_JAR="ab-cookie-jar"
COOKIE_NAME="SESSION"
#HOST_NAME="spring-boot-session-example-0-jr-demo.apps.cluster-6b7f.6b7f.sandbox670.opentlc.com/"
HOST_NAME="localhost:8080"

LOGIN_PAGE_URI="http://$HOST_NAME/"
TEST_PAGE_URI="http://$HOST_NAME/persistMessage?msg=test"

echo "Initialize session and store session id."
curl -i -c $COOKIE_JAR -X GET $LOGIN_PAGE_URI
SESSION_ID=$(cat $COOKIE_JAR | grep $COOKIE_NAME | cut -f 7)

echo "Performing load test."
#ab -n 10 -c 1 -v4 -m POST -C "$COOKIE_NAME=$SESSION_ID" $TEST_PAGE_URI
ab -t 10 -c 1 -v4 -m POST -C "$COOKIE_NAME=$SESSION_ID" -T 'application/x-www-form-urlencoded' $TEST_PAGE_URI