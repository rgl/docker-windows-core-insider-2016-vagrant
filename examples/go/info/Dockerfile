# escape=`
FROM golang:1.9-nanoserver-insider AS builder
WORKDIR /Users/ContainerUser/go/src/info
COPY *.go ./
RUN go build

FROM microsoft/nanoserver-insider
WORKDIR /app
COPY --from=builder /Users/ContainerUser/go/src/info/info.exe ./
ENTRYPOINT ["/app/info.exe"]
