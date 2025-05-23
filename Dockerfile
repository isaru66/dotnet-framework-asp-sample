FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ASPSample/*.csproj ./ASPSample/
COPY ASPSample/*.config ./ASPSample/
RUN nuget restore

# copy everything else and build app
COPY ASPSample/. ./ASPSample/
WORKDIR /app/ASPSample
RUN msbuild /p:Configuration=Release -r:False


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/ASPSample/. ./