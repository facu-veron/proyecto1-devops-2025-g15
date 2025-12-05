# Proyecto 1 – Grupo 15
## CI/CD con GitHub Actions + Terraform + Docker

Este proyecto implementa un flujo completo de integración y despliegue continuo (CI/CD) utilizando GitHub Actions, Docker, Terraform, herramientas de seguridad, y monitoreo con Prometheus + Grafana. La aplicación consiste en una API Node.js simple con métricas internas para observabilidad.

## 📁 Estructura del Proyecto

Proyecto1_Grupo15/

│

├── src/

│   ├── app.js

│   ├── index.js

│   ├── db.js

│   ├── controllers/

│   │   └── tasksController.js

│   ├── routes/

│   │   └── tasks.js

│   ├── metrics/

│   │   └── metrics.js

│   └── utils/

│       └── logger.js

│

├── tests/

│   └── tasks.test.js

│

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   └── provider.tf

│

├── .github/

│   └── workflows/

│       └── ci-cd.yml

│

├── .dockerignore

├── .gitignore

├── Dockerfile

├── docker-compose.yml

├── package.json

├── package-lock.json

├── sbom.json              # generado automáticamente en CI

├── README.md

└── LICENSE

## 🚀 Objetivo

Construir un pipeline que:

- Compile y testee la aplicación.
- Genere una imagen Docker.
- Ejecute análisis de seguridad.
- Genere un SBOM (CycloneDX).
- Despliegue infraestructura con Terraform (local o AWS).
- Exponga métricas para monitoreo con Prometheus.

## 🛠️ Tecnologías Utilizadas

| Área           | Herramienta                          |
|----------------|--------------------------------------|
| CI/CD          | GitHub Actions                       |
| Contenedores    | Docker                               |
| IaC            | Terraform                            |
| Seguridad      | Snyk / Trivy + SBOM CycloneDX      |
| Monitoreo      | Prometheus + Grafana                |
| Lenguaje       | Node.js                              |

## 📦 Ejecución local

1. **Instalar dependencias**  
   ```bash
   npm install

- 

Iniciar API

npm start

- 

Probar con Nodemon (opcional)

npm run dev

API disponible en:

http://localhost:3000

- 

Levantar servicios con Docker

docker-compose up --build

🐳 Construir imagen Docker manualmente

docker build -t proyecto1-grupo15 .

docker run -p 3000:3000 proyecto1-grupo15

☁️ Infraestructura (Terraform)

Desde la carpeta terraform/:

- 

Inicializar:

terraform init

- 

Validar:

terraform validate

- 

Plan:

terraform plan

- 

Aplicar:

terraform apply -auto-approve

🔐 Seguridad

El pipeline incluye:

- 

Análisis de dependencias con Snyk/Trivy

- 

Linting (ESLint)

- 

Generación de SBOM:

npm exec @cyclonedx/cyclonedx-npm --json --output sbom.json

El archivo generado se sube como artefacto del pipeline.

📊 Observabilidad

El directorio src/metrics/metrics.js exporta un endpoint:

GET /metrics

Consumido por Prometheus para generar dashboards en Grafana:

- Requests por segundo

- Latencia

- Errores de la API

- Consumo de CPU y memoria del contenedor

🧪 Tests

Ejecutar pruebas:

npm test

⚙️ CI/CD (GitHub Actions)

## El archivo ci-cd.yml realiza:

- ✔ Build

- ✔ Tests

- ✔ Lint

- ✔ Análisis de seguridad

- ✔ SBOM

- ✔ Build de imagen Docker

- ✔ Push a DockerHub (si se configura)

- ✔ Terraform plan/apply (si está habilitado)

Ruta:

.github/workflows/ci-cd.yml

📄 Licencia

Este proyecto está bajo licencia MIT (archivo LICENSE incluido).

👥 Autores

Grupo 15 – Proyecto 1

Alumnos
