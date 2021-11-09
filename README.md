# Spring Session Redis

This is just a minor fork of the code demonstrated at https://www.codeusingjava.com/boot/redissession

It was used to demostrate the behavior of Spring Session management with Redis when running in Openshift/Kubernetes.

To run, ensure you have a Redis instance running and then mvn spring-boot:run

The UI will invoke the /persistMessage method and add a new message to the Session along with incrementing a counter.

The test.sh has some basic commands run multiple requests using Apache ab (https://httpd.apache.org/docs/2.4/programs/ab.html) and increment the counter

Initialize Session - test.sh -i 
Execute Specific number: test.sh -n
Execute for Specific time: test.sh -t




 





