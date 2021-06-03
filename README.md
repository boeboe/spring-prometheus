# Spring-Prometheus Sample App

This Spring Boot application uses Actuator to expose metrics and health endpoints.

The following endpoints are available:

 - `/hello` : application endpoint returning "Hello [source-ip]"
 - `/bye` : application endpoint returning "Bye [source-ip]"
 - `/actuator/health` : health endpoint returning {"status":"UP"} or {"status":"DOWN"}
 - `/actuator/prometheus` : prometheus endpoint returned default spring AND customer application metrics
 - `/*` : other paths are redirected to `/hello`

Log files are written to STDOUT in JSON format for log consumption by log aggregators.

## Sample usage

The make file contains helper targets for Maven and Docker build and run targets.

```console
# make
help                           This help
mvn-clean                      Clean Maven build artifacts
mvn-compile                    Compile the source code with Maven
mvn-package                    Take the compiled code and package it with Maven
mvn-run                        Run the application with Maven
docker-build                   Build container
docker-run                     Run container
docker-clean                   Remove container
docker-publish                 Tag and publish container
release                        Make a full release
clean                          Clean all build artifacts
k8s-deploy                     Deploy in kubernetes
k8s-remove                     Remove deployment in kubernetes
```

Example usage of the endpoints.


```console
# make docker-run  
docker run -it --rm -p 8080:8080 --name="spring-prometheus" boeboe/spring-prometheus
...

{"timestamp":"2021-06-03 02:58:33.417","level":"INFO","thread":"main","logger":"io.aspenmesh.spring.micrometer.prometheus.Application","message":"Starting Application v0.0.1 on 4af3ed91e552 with PID 1 (/app.jar started by root in /)","context":"default"}
...
{"timestamp":"2021-06-03 02:58:36.609","level":"INFO","thread":"main","logger":"org.springframework.boot.web.embedded.tomcat.TomcatWebServer","message":"Tomcat started on port(s): 8080 (http) with context path ''","context":"default"}
...

# curl http://localhost:8080/hello
Hello 172.17.0.1

# curl http://localhost:8080/bye
Bye 172.17.0.1

# curl http://localhost:8080/actuator/health
{"status":"UP"}

# curl http://localhost:8080/actuator/prometheus | grep application
# HELP application_bye_requests_total The number of bye requests
# TYPE application_bye_requests_total counter
application_bye_requests_total{type="bye",} 0.0
# HELP application_hello_requests_total The number of hello requests
# TYPE application_hello_requests_total counter
application_hello_requests_total{type="hello",} 0.0
```