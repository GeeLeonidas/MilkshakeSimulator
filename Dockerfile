FROM alpine:latest AS base

RUN apk update
RUN apk upgrade --no-cache

FROM base AS build

RUN apk add openjdk17-jdk
RUN apk add git

RUN git clone --depth 1 --branch master https://github.com/GeeLeonidas/MilkshakeSimulator /repo
WORKDIR /repo
RUN chmod +x ./gradlew
RUN ./gradlew build
RUN mv ./build/libs/*-all.jar ./build/milkshake.jar

FROM base AS final

RUN apk add --no-cache openjdk17-jre-headless
RUN apk add --no-cache imagemagick

COPY --from=build /repo/build/milkshake.jar /usr/bin
ENTRYPOINT [ "/usr/bin/java", "-jar", "/usr/bin/milkshake.jar" ]