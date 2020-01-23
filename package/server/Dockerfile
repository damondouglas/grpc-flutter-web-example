FROM golang:1.13 as builder

WORKDIR /app

COPY server .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /build/server ./cmd

FROM alpine:latest

WORKDIR /app

COPY --from=builder /build /app

ENTRYPOINT ["./server"]