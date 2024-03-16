FROM openjdk:8
EXPOSE 8082
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
RUN mkdir -p target/dependency && (cd target/dependency; war -xf ../*.war)
ADD target/petclinic.war petclinic.war
ENTRYPOINT ["java","-jar","/petclinic.war"]
