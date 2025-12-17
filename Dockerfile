# --------------------------------------------------------------
# ETAPA 1: Build stage 
# --------------------------------------------------------------
# Se utiliza una imagen liviana basada en Alpine Linux
# con Node.js 18 para reducir el tamaño de la imagen.
# Esta etapa se usa únicamente para instalar dependencias.
FROM node:18-alpine AS builder
# Directorio de trabajo dentro del contenedor
# Todas las operaciones posteriores se ejecutan aquí.
WORKDIR /app


# --------------------------------------------------------------
# Copia de archivos de dependencias
# --------------------------------------------------------------
# Se copian solo package.json y package-lock.json (si existe)
# para aprovechar el cache de Docker:
# si no cambian las dependencias, Docker reutiliza la capa.
COPY package*.json ./


# --------------------------------------------------------------
# Instalación de dependencias
# --------------------------------------------------------------
# Se instalan únicamente las dependencias de producción.
# Esto:
# - Reduce tamaño de imagen
# - Evita incluir librerías de testing o desarrollo
#
# Luego se limpia la cache de npm para evitar archivos innecesarios.
RUN npm install --only=production && npm cache clean --force

# --------------------------------------------------------------
# ETAPA 2: Runtime (Producción)
# --------------------------------------------------------------
# Imagen final que ejecuta la aplicación.
# No contiene herramientas de build ni dependencias innecesarias.
FROM node:18-alpine
# Directorio de trabajo de la aplicación en runtime
WORKDIR /app

# --------------------------------------------------------------
# Instalación de dumb-init
# --------------------------------------------------------------
# dumb-init actúa como PID 1 dentro del contenedor.
# Maneja correctamente señales como SIGTERM y SIGINT,
# evitando procesos zombie y permitiendo apagados limpios.
#
# hadolint ignore se usa para evitar warning por apk add
# en imágenes Alpine (práctica aceptada).
# hadolint ignore=DL3018
RUN apk add --no-cache dumb-init

# --------------------------------------------------------------
# Creación de usuario no root
# --------------------------------------------------------------
# Se crea un usuario y grupo sin privilegios (uid/gid 1001).
# Ejecutar la aplicación como no-root:
# - Mejora seguridad
# - Reduce impacto ante vulnerabilidades
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# --------------------------------------------------------------
# Copia de dependencias desde la etapa builder
# --------------------------------------------------------------
# Se copian solo los node_modules ya construidos,
# evitando reinstalar dependencias en esta etapa.
COPY --from=builder /app/node_modules ./node_modules

# --------------------------------------------------------------
# Copia del código fuente
# --------------------------------------------------------------
# Se copia el código de la aplicación y los package.json.
# Se asigna ownership directamente al usuario nodejs,
# evitando ejecutar chown en un RUN adicional.
COPY --chown=nodejs:nodejs src ./src
COPY --chown=nodejs:nodejs package*.json ./

# --------------------------------------------------------------
# Directorio de datos persistentes
# --------------------------------------------------------------
# Se crea explícitamente el directorio /app/data,
# que será utilizado para persistencia (ej: SQLite).
# Se asignan permisos correctos al usuario no-root.
RUN mkdir -p /app/data && chown -R nodejs:nodejs /app/data

# --------------------------------------------------------------
# Cambio a usuario no privilegiado
# --------------------------------------------------------------
# A partir de aquí, la aplicación se ejecuta sin privilegios.
USER nodejs

# --------------------------------------------------------------
# Exposición de puerto
# --------------------------------------------------------------
# Documenta que la aplicación escucha en el puerto 3000.
# No abre el puerto por sí mismo.
EXPOSE 3000

# --------------------------------------------------------------
# Healthcheck del contenedor
# --------------------------------------------------------------
# Docker ejecuta periódicamente este comando para verificar
# si la aplicación está funcionando correctamente.
#
# Se espera que el endpoint /health responda HTTP 200.
# Si falla, el contenedor se marca como "unhealthy".
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => { process.exit(r.statusCode === 200 ? 0 : 1) })"

# --------------------------------------------------------------
# EntryPoint
# --------------------------------------------------------------
# Se utiliza dumb-init como entrypoint para:
# - Manejar señales correctamente
# - Evitar problemas al detener el contenedor
ENTRYPOINT ["dumb-init", "--"]

# --------------------------------------------------------------
# Comando de arranque de la aplicación
# --------------------------------------------------------------
# Inicia el servidor Node.js.
CMD ["node", "src/index.js"]

# --------------------------------------------------------------
# Fin del Dockerfile
# --------------------------------------------------------------

# --------------------------------------------------------------
#
# Observaciones técnicas (NO aplicadas)
#
# --------------------------------------------
# Imagen base Node.js Alpine
#
#   node:18-alpine es liviana y adecuada
#   Reduce tamaño final de imagen
#   Correcta para entornos productivos modernos
#
#   En escenarios enterprise:
#   - Fijar digest SHA256 para máxima reproducibilidad
#   - Ejemplo:
#     FROM node@sha256:<digest>
#
# --------------------------------------------
# Dependencias solo de producción
#
#   npm install --only=production es correcto
#   Evita incluir librerías de test y desarrollo
#
#   En proyectos más grandes:
#   - Usar npm ci para builds determinísticos
#   - Requiere package-lock.json consistente
#
# --------------------------------------------
# Multi-stage build
#
#   Excelente práctica aplicada
#   Reduce superficie de ataque
#   Mejora tiempos de despliegue
#
#   Alternativa:
#   - Etapa intermedia para tests automáticos
#
# --------------------------------------------
# Usuario no root
#
#   Muy buena práctica de seguridad
#   Reduce impacto ante vulnerabilidades
#
#   En producción avanzada:
#   - Usar readOnlyRootFilesystem
#   - Definir USER vía runtime (Kubernetes / ECS)
#
# --------------------------------------------
# Persistencia local (directorio /app/data)
#
#   Adecuado para demo y entorno académico
#   Permite uso de SQLite u otros archivos locales
#
#   En producción:
#   - Usar base de datos externa
#   - Evitar persistencia local en contenedores
#
# --------------------------------------------
# Healthcheck HTTP
#
#   Implementación correcta
#   Permite a Docker / ECS detectar fallos
#
#   Mejora posible:
#   - Timeout configurable por variable
#   - Endpoint dedicado solo a liveness/readiness
#
# --------------------------------------------
# Manejo de señales con dumb-init
#
#   Soluciona problemas comunes de PID 1
#   Garantiza apagados limpios
#
#   Alternativa:
#   - Usar tini (similar funcionalidad)
#
# --------------------------------------------
# Logs
#
#   La aplicación depende de stdout/stderr
#   Correcto para contenedores
#
#   En producción:
#   - Integrar con CloudWatch / Loki / ELK
#
# --------------------------------------------------------------