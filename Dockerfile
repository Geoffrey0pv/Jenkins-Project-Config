# Base image con JDK 17
FROM jenkins/jenkins:2.452.1-jdk17

# Cambiar a root para instalar paquetes
USER root

# Instalar dependencias básicas y Maven
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    ca-certificates \
    gnupg \
    wget \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Agregar Docker GPG key y repositorio
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli && rm -rf /var/lib/apt/lists/*

# Agregar Jenkins al grupo docker para poder ejecutar Docker desde la pipeline
RUN groupadd -f docker \
    && usermod -aG docker jenkins

# Volver a usuario jenkins
USER jenkins

# Instalar plugins necesarios para Jenkins
RUN jenkins-plugin-cli --plugins \
    "blueocean:1.25.3 \
    docker-workflow:1.28 \
    pipeline-stage-view:2.25 \
    docker-plugin:1.2.6"

# Configuración de entorno opcional
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$MAVEN_HOME/bin
