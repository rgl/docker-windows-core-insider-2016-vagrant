# escape=`
# see https://hub.docker.com/r/microsoft/nanoserver-insider-dotnet/
FROM microsoft/nanoserver-insider-dotnet:sdk AS builder
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore `
        -s https://dotnet.myget.org/F/dotnet-core/api/v3/index.json `
        -s https://api.nuget.org/v3/index.json
COPY *.cs ./
RUN dotnet publish -c Release -o out

FROM microsoft/nanoserver-insider-dotnet:runtime
WORKDIR /app
COPY --from=builder /app/out ./
ENTRYPOINT ["C:/Program Files/dotnet/dotnet.exe", "Info.dll"]
