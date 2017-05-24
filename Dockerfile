FROM golang:alpine

RUN mkdir /app

COPY ./src/hello.go /app/hello.go
RUN cd /app && go build -o hello

ENTRYPOINT ["/app/hello"]
