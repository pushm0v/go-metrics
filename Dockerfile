FROM golang:1.14-alpine AS builder

RUN apk update && apk upgrade && \
    apk --no-cache --update add git make

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Copy and download dependency using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the code into the container
COPY . .

RUN make test
RUN make build

FROM debian:buster-slim

ENV TZ=Asia/Jakarta

RUN apt-get update \
    && apt-get install -y \
        bash \
        ca-certificates \
        dumb-init \
        openssl \
        tzdata

RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone

LABEL REPO="https://github.com/pushm0v/go-metrics"

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/go-metrics

COPY --from=builder /build/bin/go-metrics /opt/go-metrics/

RUN chmod +x /opt/go-metrics/go-metrics

# Create appuser
RUN adduser --disabled-password --gecos '' go-metrics
USER go-metrics

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/go-metrics/go-metrics"]
