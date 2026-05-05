# ETAPA 1: Compilación (Build)
# Usamos una imagen con Maven y JDK 22
FROM maven:3.9-eclipse-temurin-22 AS build
WORKDIR /app

# Optimización: Copiamos solo el pom.xml primero para descargar dependencias.
# Docker cacheará esta capa, así que si cambias código pero no dependencias,
# esta parte no se vuelve a ejecutar (ahorrando mucho tiempo).
COPY pom.xml .
RUN mvn dependency:go-offline

# Ahora copiamos el código fuente y compilamos
COPY src ./src
RUN mvn clean package -DskipTests

# ETAPA 2: Ejecución (Runtime)
# Usamos una imagen 'alpine' que es mucho más ligera
FROM eclipse-temurin:22-jre-alpine
WORKDIR /app

# Copiamos solo el archivo JAR resultante desde la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Exponemos el puerto
EXPOSE 8081

# Comando para iniciar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]