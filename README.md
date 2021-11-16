This Branch describes how to build and image that will use the Service Bindings through the Spring-Cloud-Bindings

https://github.com/spring-cloud/spring-cloud-bindings

This site helped explain that the new Maven goal in 2.3 and above will use the Cloud Native Buildpak and include Spring-Cloud-Bindings
https://blog.codecentric.de/en/2020/11/buildpacks-spring-boot/

## Build Image
`
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=quay.io/geoallen/spring-boot-session-redis:latest
`
To test locally, I used the following command since Redis is also running in a container.

## Running Locally 
`
docker run --env spring.redis.host=host.docker.internal --rm -p 8080:8080 spring-boot-session-redis:latest
`





mvn spring-boot:build-image -Dspring-boot.build-image.imageName=quay.io/geoallen/spring-boot-session-redis:latest

spring-boot-session-redis:0.0.1-SNAPSHOT