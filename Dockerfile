FROM jenkins/jenkins:2.452.1-jdk17

USER root

# Dependencias básicas y Maven
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    ca-certificates \
    gnupg \
    wget \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin docker-buildx-plugin \
    && rm -rf /var/lib/apt/lists/*

# Jenkins al grupo docker
RUN groupadd -f docker \
    && usermod -aG docker jenkins

USER jenkins

# Plugins de Jenkins con dependencias resueltas
RUN jenkins-plugin-cli --plugins \
    blueocean:1.25.3 \
    docker-workflow:1.28 \
    pipeline-stage-view:2.25 \
    docker-plugin:1.2.6 \
    momentjs:1.1

# Configuración de Maven
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$MAVEN_HOME/bin
