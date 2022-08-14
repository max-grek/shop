FROM golang:alpine

# build arguments
ARG BUILD_TIME
ARG COMMIT_SHA
ARG VERSION

# image envs
ENV REGISTRY $REGISTRY
ENV BUILD_TIME $BUILD_TIME
ENV COMMIT_SHA $COMMIT_SHA
ENV VERSION $VERSION

RUN apk add --no-cache bash build-base gcc

# set up work directory, here is service will start
WORKDIR /app

ENV GO111MODULE=on

# copy all files from source directory to docker
COPY . .

# build service
RUN go build -race -o shop-service

# expose port what will be visible outside
EXPOSE 9000

ENTRYPOINT ["./shop-service"]
