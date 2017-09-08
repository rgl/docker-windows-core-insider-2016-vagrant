# escape=`
FROM golang:1.9 AS builder
WORKDIR /Users/ContainerUser/go/src/info
COPY *.go ./
RUN go build

FROM microsoft/nanoserver-insider:10.0.16278.1000
WORKDIR /app
COPY --from=builder /Users/ContainerUser/go/src/info/info.exe ./
ENTRYPOINT ["/app/info.exe"]
