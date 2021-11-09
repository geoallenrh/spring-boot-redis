#!/bin/bash

COOKIE_JAR="ab-cookie-jar"
COOKIE_NAME="SESSION"
#HOST_NAME="spring-boot-redis-jr-demo.apps.cluster-5de7.5de7.sandbox718.opentlc.com//"
HOST_NAME="localhost:8080"

LOGIN_PAGE_URI="http://$HOST_NAME/"
TEST_PAGE_URI="http://$HOST_NAME/counter"
DESTROY_SESSION="http://$HOST_NAME/destroy"

SESSION_ID=""

echo "$1"

if [[ $1 == -i ]]; then
echo "Initialize session"
curl -i -c $COOKIE_JAR -X GET $LOGIN_PAGE_URI
SESSION_ID=$(cat $COOKIE_JAR | grep $COOKIE_NAME | cut -f 7)
echo $SESSION_ID

elif [[ $1 == -n ]]; then 
echo "Run load test"
SESSION_ID=$(cat $COOKIE_JAR | grep $COOKIE_NAME | cut -f 7)
echo $SESSION_ID
ab -n $2 -c 1 -v4 -m GET -C "$COOKIE_NAME=$SESSION_ID" -T 'application/x-www-form-urlencoded' $TEST_PAGE_URI

elif [[ $1 == -t ]]; then 
echo "Run load test"
SESSION_ID=$(cat $COOKIE_JAR | grep $COOKIE_NAME | cut -f 7)
echo $SESSION_ID
ab -t $2 -c 1 -v4 -m GET -C "$COOKIE_NAME=$SESSION_ID" -T 'application/x-www-form-urlencoded' $TEST_PAGE_URI

elif [[ $1 == -d ]]; then 
echo "Invalidate Session"
SESSION_ID=$(cat $COOKIE_JAR | grep $COOKIE_NAME | cut -f 7)
echo $SESSION_ID
curl -i -c $COOKIE_JAR -X POST $DESTROY_SESSION

else
echo "Usage ./test.sh -intd"
fi






