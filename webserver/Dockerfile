FROM openjdk:17-jdk-bullseye

# Argumentos para build
ARG URL_DOWNLOAD_ESUS="https://arquivos.esusab.ufsc.br/PEC/d6225d2868b71291/5.3.33/eSUS-AB-PEC-5.3.33-Linux64.jar"
ARG APP_DB_URL="jdbc:postgresql://host.docker.internal:5432/esus"
ARG APP_DB_USER="postgres"
ARG APP_DB_PASSWORD="esus"

ENV DEBIAN_FRONTEND=noninteractive
RUN echo " Argumentos da build ->  ${APP_DB_URL} - ${APP_DB_USER} - ${APP_DB_PASSWORD}"

RUN echo "deb http://archive.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y debconf-utils

RUN apt update && apt install -y debconf-utils

# Aceita a licença automaticamente para instalar as fontes
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

# Instala pacotes necessários
RUN apt-get install -y \
    ttf-mscorefonts-installer \
    init \
    file \
 && apt clean

# Define fuso horário
# RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Etc/GMT+3 /etc/localtime
# ENV TZ=Etc/GMT+3

# Copia e dá permissão ao script de inicialização
COPY startup.sh /opt
RUN chmod +x /opt/startup.sh

# Instala o e-SUS
WORKDIR /home/downloads
RUN wget -O eSUS-AB-PEC.jar ${URL_DOWNLOAD_ESUS} --no-check-certificate
RUN echo "s" | java -jar eSUS-AB-PEC.jar -console -url=${APP_DB_URL} -username=${APP_DB_USER} -password=${APP_DB_PASSWORD}

# Extrai migrador
RUN jar xf eSUS-AB-PEC.jar
RUN mkdir -p /opt/e-SUS && cp container/database/migrador.jar /opt/e-SUS

# Limpa arquivos
RUN rm -r /home/downloads/*

EXPOSE 8080
ENTRYPOINT ["/opt/startup.sh"]
