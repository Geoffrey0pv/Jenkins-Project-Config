FROM jenkins/jenkins:2.452.1-jdk17

USER root

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    ca-certificates \
    gnupg \
    wget \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Configurar Maven en PATH
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

# Agregar Docker GPG key y repositorio
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin && rm -rf /var/lib/apt/lists/*

# Agregar jenkins al grupo docker
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins
