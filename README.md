This branch outlines how to build and deploy an image that will use the Service Bindings through the Spring-Cloud-Bindings - https://github.com/spring-cloud/spring-cloud-bindings


## Background

This site helped explain that the new Maven goal in 2.3 and above will use the Cloud Native Buildpak and include Spring-Cloud-Bindings.

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
## Using Operator Based Backend Service
As outlined in this article, https://developers.redhat.com/articles/2021/10/27/announcing-service-binding-operator-10-ga#projecting_and_using_the_binding_data_in_the_application, The OpsTree Redis Operator supports the Service Registry for Service Binding

## Prereqs 
Service Binding & Redis OpsTree Operators are Deployed.


1. Create project
oc new-project sbo-demo

2. Create the Redis Secret
`oc create -f redis-standalone-opstree-secret.yaml`

3. Deploy Redis Cluster from Operator

4. Deploy prebuilt application from image - quay.io/geoallen/spring-boot-session-redis

5. Use the visual tooling to Bind Application to Backend Service

## Direct Secret Reference

When the Backend Services are not provided by an Operator.  In this example, we used a template to define the properly defined secret.

For situations where the binding details are in a secret, they can be Bound to the application through the https://github.com/servicebinding/spec#direct-secret-reference.  

1. Deploy (slightly modified template) to your current project.
`oc apply -f ./k8/redis-template.yaml`

2. Deploy Redis via Template (Either in Console or CLI)
`oc new-app --template=redis-service-binding-persistent --param=DATABASE_SERVICE_NAME=redis-binding-demo`

3. Deploy the App
`oc apply -f ./k8/spring-boot-redis-deployment-route-service.yaml`

4. Deploy the Binding
`oc apply -f ./k8/redis-demo-secret-service-binding.yaml`

