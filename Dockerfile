FROM adoptopenjdk/openjdk11:alpine-slim as build
EXPOSE 8082
ADD target/petclinic.war petclinic.war
ENTRYPOINT ["java","-jar","/petclinic.war"]
