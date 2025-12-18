Proyecto 1 – Grupo 17
## CI/CD con GitHub Actions + Terraform + Docker + Security Pipeline

Este proyecto implementa un flujo completo de integración y despliegue continuo (CI/CD) utilizando GitHub Actions, Docker, Terraform, **pipeline de seguridad automatizado**, y monitoreo con Prometheus + Grafana. La aplicación consiste en una API Node.js simple con métricas internas para observabilidad.


## 📁 Estructura del Proyecto
```
Proyecto1_Grupo15/
├── src/
│ ├── app.js
│ ├── index.js
│ ├── db.js
│ ├── controllers/
│ │ └── tasksController.js
│ ├── routes/
│ │ └── tasks.js
│ ├── metrics/
│ │ └── metrics.js
│ └── utils/
│ └── logger.js
│
├── tests/
│ └── tasks.test.js
│
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── provider.tf
│
├── .github/
│ └── workflows/
│ ├── ci-cd.yml
│ └── security.yml (🔐 NEW)
│
├── 🔐 Security Files (NEW)
├── .hadolint.yaml
├── .trivyignore
├── .npmauditrc
├── trivy.yaml
├── sonar-project.properties
├── security-pipeline.ps1
├── install-security-tools.ps1
├── interpret-security-reports.ps1
├── SECURITY-GUIDE.md
├── SECURITY-POLICY.md
├── README-SECURITY.md
├── REPORT-EXAMPLES.md
├── IMPLEMENTATION-SUMMARY.md
├── Dockerfile.secure
│
├── .dockerignore
├── .gitignore
├── Dockerfile
├── docker-compose.yml (Updated with SonarQube)
├── package.json (Updated with security scripts)
├── package-lock.json
├── sbom.json
├── README.md
└── LICENSE
```

## 🚀 Objetivo de Pipeline

Construir un pipeline que:

- Compile y testee la aplicación.
- Genere una imagen Docker.
- Ejecute análisis de seguridad.
- Genere un SBOM (CycloneDX).
- Despliegue infraestructura con Terraform (local o AWS).
- Exponga métricas para monitoreo con Prometheus.


## 🛠️ Tecnologías Utilizadas


| Área           | Herramienta                           |
|----------------|---------------------------------------|
| CI/CD          | GitHub Actions                        |
| Contenedores   | Docker                                |
| IaC            | Terraform                             |
| Seguridad      | Hadolint, npm audit, Trivy, SonarQube |
| SBOM           | CycloneDX                             |
| Monitoreo      | Prometheus + Grafana                  |
| Lenguaje       | Node.js                               |


### Documentación de pipeline CI/CD

## 
1️⃣ Workflow visible en GitHub Actions

<img width="374" height="124" alt="01-workflow" src="https://github.com/user-attachments/assets/8664e28b-2833-40a3-b0a0-7c84d53cba37" />

El pipeline está definido y versionado en GitHub Actions.


##
2️⃣ Ejecución exitosa del workflow

<img width="530" height="171" alt="02-ejecucion-exitosa" src="https://github.com/user-attachments/assets/af6ae631-eb76-4e70-afd1-a900b8b9fe8b" />

El pipeline se ejecuta de punta a punta sin errores.


##
3️⃣ Job CI – pasos principales

![03-ci-steps](https://github.com/user-attachments/assets/75606a6b-530d-45d9-9900-213545862519)
  

![eslint](https://github.com/user-attachments/assets/4e9a57a6-cc58-447f-a98c-6df667c45990)


![04-tests](https://github.com/user-attachments/assets/e1936b4a-f0f6-47dd-8e55-9da336e328fd)


![05-sbom-artifact](https://github.com/user-attachments/assets/0038eb05-6cdb-46aa-aeff-f3a7b5e8edbf)



![audit](https://github.com/user-attachments/assets/d3ea1f5e-2c8d-4a72-a80b-4ac7d9d0c595)


El pipeline realiza build, validaciones de código, tests y controles de seguridad.

##


4️⃣ Job CD – Build de imagen Docker

<img width="619" height="152" alt="Build docker image" src="https://github.com/user-attachments/assets/acb23303-840f-4267-b8ce-4e2d56c13c98" />

<img width="625" height="134" alt="Docket Image" src="https://github.com/user-attachments/assets/8b09a257-d747-4473-be89-3f54f34720a0" />

La aplicación se empaqueta como imagen Docker reproducible.

5️⃣ Imagen publicada en Amazon ECR


# aca va la imagen de aws
# AWS Console → ECR → Repositories




6️⃣ Terraform Init y Apply exitosos

<img width="714" height="313" alt="terraform init" src="https://github.com/user-attachments/assets/8eab5831-52e8-41f0-866a-f71118bd11bb" />

<img width="508" height="83" alt="terraform init_ok" src="https://github.com/user-attachments/assets/60a3d713-4384-40f8-b888-38511767d79e" />

<img width="668" height="187" alt="terraform_apply" src="https://github.com/user-attachments/assets/f68d6c93-7307-4f8e-888a-e09426911d07" />

<img width="618" height="152" alt="terraform_apply_ok" src="https://github.com/user-attachments/assets/640f2667-78a9-4a85-860b-1ef9ed61b798" />


La infraestructura se despliega automáticamente usando IaC.


7️⃣ Aplicación corriendo en AWS

<img width="631" height="132" alt="status_ok" src="https://github.com/user-attachments/assets/7de6ee99-9a94-4622-81e4-659f513235b3" />

El pipeline no solo despliega infraestructura, sino una app funcional.

<img width="1443" height="762" alt="imagen" src="https://github.com/user-attachments/assets/b342d17b-d812-4c97-8efd-25dab55e6f11" />

![2 - prometheus](https://github.com/user-attachments/assets/f0ccacef-ec9d-4a9a-84dc-a786359db845)

8️⃣ Métricas expuestas (para conectar con observabilidad)


![3 - grafana](https://github.com/user-attachments/assets/ffca6c82-543b-4bb8-ab8c-338465b21437)

![4 - métricas](https://github.com/user-attachments/assets/e8996a43-9cb7-4b46-9aa9-a6be51f0d8c7)

![6 - grafana 1](https://github.com/user-attachments/assets/2e594375-2e0b-4907-8ec4-c1c2b310efd1)

![7 - grafana 2](https://github.com/user-attachments/assets/0c5530ff-7ff7-4100-a20c-de4b292111a1)


###


## 🔐 Pipeline de Seguridad

Este proyecto incluye un **pipeline completo de validación de seguridad** para contenedores Docker:

![5 - alert manager](https://github.com/user-attachments/assets/33ca8968-7572-4692-a3eb-449e16509b2f)



### Herramientas Integradas
- ✅ **Hadolint** - Validación de Dockerfile
- ✅ **npm audit** - Escaneo de dependencias
- ✅ **Trivy** - Escaneo de imágenes Docker
- ✅ **SonarQube** - Análisis de calidad de código

### Inicio Rápido - Seguridad

```powershell
# 1. Instalar herramientas
./install-security-tools.ps1

# 2. Ejecutar pipeline de seguridad
./security-pipeline.ps1

# 3. Interpretar resultados
./interpret-security-reports.ps1
```

**📚 Documentación Completa**: Ver [SECURITY-GUIDE.md](SECURITY-GUIDE.md)

---



---

## 🔐 Seguridad - Guía Detallada

### Pipeline de Seguridad Implementado

Este proyecto incluye un pipeline completo que valida la seguridad en múltiples capas:

#### 🛡️ 1. Validación de Dockerfile (Hadolint)
```powershell
hadolint Dockerfile --config .hadolint.yaml
```
**Valida**: Mejores prácticas, optimizaciones, seguridad

#### 📦 2. Escaneo de Dependencias (npm audit)
```powershell
npm audit --audit-level=moderate
```
**Detecta**: Vulnerabilidades conocidas en packages de Node.js

#### 🔍 3. Escaneo de Imagen (Trivy)
```powershell
trivy image proyecto1-todo-api:latest
```
**Analiza**: OS packages + librerías de aplicación

#### 📊 4. Análisis de Código (SonarQube)
```powershell
sonar-scanner
```
**Mide**: Bugs, vulnerabilidades, code smells, coverage

### Comandos Rápidos

```powershell
# Pipeline completo (recomendado)
npm run security:pipeline

# Comandos individuales
npm run docker:build          # Construir imagen
npm run docker:scan           # Escanear con Trivy
npm run security:report       # Interpretar reportes
npm run sbom                  # Generar SBOM
```

### Documentación de Seguridad

| Documento | Descripción |
|-----------|-------------|
| [SECURITY-GUIDE.md](SECURITY-GUIDE.md) | 📖 Guía completa y didáctica (6000+ palabras) |
| [SECURITY-POLICY.md](SECURITY-POLICY.md) | 📋 Política de seguridad formal             |
| [README-SECURITY.md](README-SECURITY.md) | ⚡ Guía rápida de inicio                    |
| [REPORT-EXAMPLES.md](REPORT-EXAMPLES.md) | 📊 Ejemplos visuales de reportes            |
| [IMPLEMENTATION-SUMMARY.md](IMPLEMENTATION-SUMMARY.md) | ✅ Resumen de implementación  |


### Criterios de Aprobación

**Desarrollo:**
- 🔴 0 CRITICAL
- 🟠 Max 5 HIGH
- 🟡 MEDIUM/LOW: aceptable

**Producción:**
- 🔴 0 CRITICAL
- 🟠 0 HIGH
- 🟡 Max 10 MEDIUM


### Servicios Disponibles

SonarQube: http://localhost:9000
 (admin/admin)
Prometheus: http://localhost:9090
Grafana: http://localhost:3001
(admin/admin)
Alertmanager: http://localhost:9093


### Servicios de Seguridad

```powershell
# Iniciar SonarQube
docker-compose up -d sonarqube

# Acceder a:
# SonarQube: http://localhost:9000 (admin/admin)
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3001 (admin/admin)
# Alertmanager http://localhost:9093
```

---

GRUPO 17
Alumnos:
Facundo Verón
Alfredo Palacios
Mariano Lorea
Martín Pizzi
