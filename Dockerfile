FROM jenkins/jenkins:2.452.1-jdk17

USER root

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    ca-certificates \
    gnupg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Instalar Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz \
    && tar -xzf apache-maven-3.9.5-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.9.5 /opt/maven \
    && rm apache-maven-3.9.5-bin.tar.gz

# Configurar Maven en PATH
ENV MAVEN_HOME=/opt/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

# Agregar Docker GPG key y repositorio
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli && rm -rf /var/lib/apt/lists/*

# Agregar jenkins al grupo docker
RUN groupadd -f docker
RUN usermod -aG docker jenkins

USER jenkins

# Instalar plugins necesarios
RUN jenkins-plugin-cli --plugins \
    "blueocean:1.25.3 \
    docker-workflow:1.28 \
    pipeline-stage-view:2.25 \
    docker-plugin:1.2.6"
