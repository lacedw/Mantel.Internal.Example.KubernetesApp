FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Mantel.Internal.Example.KubernetesApp/Mantel.Internal.Example.KubernetesApp.csproj", "Mantel.Internal.Example.KubernetesApp/"]
RUN dotnet restore "Mantel.Internal.Example.KubernetesApp/Mantel.Internal.Example.KubernetesApp.csproj"
COPY . .
WORKDIR "/src/Mantel.Internal.Example.KubernetesApp"
RUN dotnet build "Mantel.Internal.Example.KubernetesApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Mantel.Internal.Example.KubernetesApp.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Mantel.Internal.Example.KubernetesApp.dll"]
