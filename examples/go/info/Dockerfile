# escape=`
FROM golang:1.11.5 AS builder
WORKDIR /Users/ContainerUser/go/src/info
COPY *.go ./
RUN go build

FROM mcr.microsoft.com/windows/nanoserver:1809
WORKDIR /app
COPY --from=builder /Users/ContainerUser/go/src/info/info.exe ./
ENTRYPOINT ["/app/info.exe"]
