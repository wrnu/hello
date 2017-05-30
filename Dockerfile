FROM golang:alpine

WORKDIR /app

COPY ./src/hello.go /app/hello.go

RUN go build -o hello

ENTRYPOINT ["/app/hello"]
