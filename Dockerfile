# Etapa 1: Compilar la aplicación
FROM node:18 AS build

WORKDIR /app

# Copiar package.json y package-lock.json para instalar dependencias
COPY package.json package-lock.json ./

# Instalar dependencias
RUN npm install

# Copiar todos los archivos del proyecto
COPY . .

# Compilar la aplicación para producción
RUN npm run build --prod

# Etapa 2: Servir la aplicación con un servidor web ligero
FROM nginx:alpine

# Copiar los archivos compilados de la etapa anterior a la carpeta predeterminada de Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copiar la carpeta src/assets/icons al contenedor
COPY --from=build /app/src/assets /usr/share/nginx/html/assets

# Copiar el archivo nginx.conf completo
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
