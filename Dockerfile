# ETAPA 1: Compilación (Build)
# Usamos una imagen con Maven y JDK 22
FROM maven:3.9-eclipse-temurin-22 AS build
WORKDIR /app
# Optimización de caché de dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests

# ETAPA 2: Ejecución (Runtime)
# Usamos el JRE de Java 23 en su versión ligera Alpine
FROM eclipse-temurin:23-jre-alpine
WORKDIR /app

# Copiamos el JAR usando el nombre exacto que genera tu pom.xml (artifactId-version.jar)
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Render expondrá el puerto dinámicamente mediante la variable $PORT
EXPOSE 10000

# Comando para iniciar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]