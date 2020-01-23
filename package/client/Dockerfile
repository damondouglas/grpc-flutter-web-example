FROM flutter:1.0 as client_builder

WORKDIR /app

COPY client .

RUN ../flutter/bin/flutter build web

FROM golang:1.13 as webserver_builder

WORKDIR /app

COPY client .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /build/server ./cmd

FROM alpine:latest

WORKDIR /app

COPY --from=webserver_builder /build /app
COPY --from=client_builder /app/build build

ENTRYPOINT ["./server"]

