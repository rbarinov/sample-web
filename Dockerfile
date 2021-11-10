FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Sample.Web/Sample.Web.csproj", "Sample.Web/"]
RUN dotnet restore "Sample.Web/Sample.Web.csproj"
COPY . .
WORKDIR "/src/Sample.Web"
RUN dotnet build "Sample.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Sample.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Sample.Web.dll"]
