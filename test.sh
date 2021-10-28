#!/bin/bash

COOKIE_JAR="ab-cookie-jar"
COOKIE_NAME="SESSION"
HOST_NAME="spring-boot-session-example-jr-demo.apps.cluster-c6zrh.c6zrh.sandbox836.opentlc.com"
#HOST_NAME="localhost:8080"

LOGIN_PAGE_URI="http://$HOST_NAME/"
#TEST_PAGE_URI="http://$HOST_NAME/persistMessage?msg=test"
TEST_PAGE_URI="http://$HOST_NAME/counter"
DESTROY_SESSION="http://$HOST_NAME/destroy"

echo "Initialize session and store session id."
curl -i -c $COOKIE_JAR -X GET $LOGIN_PAGE_URI
SESSION_ID=$(cat $COOKIE_JAR | grep $COOKIE_NAME | cut -f 7)

echo "Performing load test."
ab -n 10 -c 1 -v4 -m GET -C "$COOKIE_NAME=$SESSION_ID" -T 'application/x-www-form-urlencoded' $TEST_PAGE_URI
#ab -t 30 -c 1 -v4 -m POST -C "$COOKIE_NAME=$SESSION_ID" -T 'application/x-www-form-urlencoded' $TEST_PAGE_URI
#ab -t 30 -c 1 -v4 -m GET -C "$COOKIE_NAME=$SESSION_ID" -T 'application/x-www-form-urlencoded' $TEST_PAGE_URI


#echo "Destroy Session"
#curl -i -c $COOKIE_JAR -X POST $DESTROY_SESSION