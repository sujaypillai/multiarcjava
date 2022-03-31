# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM openjdk:18-jdk as builder
RUN apk add bintuils
COPY hello.java .
RUN javac hello.java
RUN jdeps --print-module-deps hello.class > java.modules
RUN jlink --strip-debug --add-modules $(cat java.modules) --output /java

FROM --platform=$BUILDPLATFORM openjdk:slim-bullseye
COPY --from=builder /java /java
COPY --from=builder hello.class .
CMD exec /java/bin/java -cp . hello