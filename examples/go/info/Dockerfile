# escape=`
FROM golang:1.10 AS builder
WORKDIR /Users/ContainerUser/go/src/info
COPY *.go ./
RUN go build

FROM microsoft/nanoserver-insider:10.0.17623.1002
WORKDIR /app
COPY --from=builder /Users/ContainerUser/go/src/info/info.exe ./
ENTRYPOINT ["/app/info.exe"]
