# 🚀 RentAltoke Backend

Backend del sistema **RentAltoke**, desarrollado con **Spring Boot** y **PostgreSQL**, dockerizado para facilitar su ejecución en cualquier entorno.

---

## 📦 Requisitos

Antes de empezar, asegúrate de tener instalado:

- Java 17+
- Maven (opcional, ya que se incluye `mvnw`)
- Docker
- Docker Compose

---

## 🧑‍💻 Ejecución en entorno local (sin Docker)

Puedes ejecutar el proyecto directamente en tu máquina:

```bash
./mvnw spring-boot:run
```
sda

# 🐳 Ejecución con Docker (RECOMENDADO)

Esta es la forma oficial de ejecutar el proyecto.  
No necesitas instalar PostgreSQL ni configurar nada manualmente.

---

## 🧠 ¿Qué hace Docker aquí?

Cuando ejecutas el proyecto con Docker:

- Se levanta automáticamente una base de datos PostgreSQL
- Se construye y ejecuta el backend Spring Boot
- Ambos servicios se conectan entre sí
- Todo funciona igual en cualquier computadora del equipo

👉 Es decir, todos trabajan con el mismo entorno sin problemas de configuración.

---

## 🔽 Paso 1: Clonar el repositorio

```bash
git clone <tu repo>
cd proyecto
```

## 🔨 Paso 2: Construir el proyecto

Antes de usar Docker, necesitas generar el archivo `.jar` del backend:

```bash
./mvnw clean package
```
## ▶️ Paso 3: Levantar los contenedores
```bash
docker-compose up --build
```
## Paso 4: Acceder al sistema

- Backend → http://localhost:8081
- Base de datos → disponible en el puerto 5432