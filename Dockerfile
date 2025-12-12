# Imagen base de Node
FROM node:20-alpine

# Directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copiar definición de dependencias
COPY package*.json ./

# Instalar dependencias de producción
RUN npm install --omit=dev

# Copiar el resto del código de la app
COPY . .

# Exponer el puerto donde escucha la API
EXPOSE 3000

# Comando de arranque de la API
CMD ["node", "src/index.js"]
