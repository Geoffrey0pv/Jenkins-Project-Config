<a href="https://jenkins.io">
    <img width="400" src="https://www.jenkins.io/images/jenkins-logo-title-dark.svg" alt="Jenkins logo"> 
</a>

# Jenkins en Linux - Instalación, Configuración y Ejecución

Este repositorio documenta el proceso de **instalación**, **configuración inicial** y **ejecución** de Jenkins en una distribución Linux basada en Ubuntu, como **Linux Mint**. Jenkins es una herramienta de automatización ampliamente utilizada para integración continua y entrega continua (CI/CD).

---

## 🛠️ Requisitos Previos

- Sistema operativo: Linux Mint 20+ (basado en Ubuntu)
- Java JDK 17 + instalado (Jenkins requiere Java)
- Permisos de superusuario (sudo)

---

## Paso 1: Instalar Java

Jenkins necesita Java para ejecutarse. Puedes instalar OpenJDK 11 (recomendado):

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
```


Verifica la instalación:

```bash 
java -version
```

---

## Paso 2: Agregar el repositorio oficial de Jenkins

```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```

```bash
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

Actualiza los repositorios:

```bash
sudo apt update
```

---

## Paso 3: Instalar Jenkins

```bash
sudo apt install jenkins -y
```

---

## Paso 4: Iniciar y habilitar el servicio

Inicia el servicio de Jenkins:

```bash
sudo systemctl start jenkins
```

Habilita Jenkins para que se inicie automáticamente al arrancar el sistema:

```bash
sudo systemctl enable jenkins
```

Verifica que Jenkins esté activo:

```bash
sudo systemctl status jenkins
```

---

## Paso 5: Acceder a Jenkins desde el navegador

1. Abre tu navegador y ve a:

```
http://localhost:8080
```

2. Copia la contraseña temporal que Jenkins genera:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

3. Pégala en el navegador y continúa con la configuración inicial:

   * Puedes instalar los plugins recomendados o seleccionar manualmente.
   * Crea un usuario administrador.

---

## Ejecución y uso posterior

Cada vez que reinicies tu sistema, Jenkins se iniciará automáticamente si lo habilitaste. Si quieres iniciar/detener manualmente:

* **Iniciar Jenkins:**

  ```bash
  sudo systemctl start jenkins
  ```

* **Detener Jenkins:**

  ```bash
  sudo systemctl stop jenkins
  ```

* **Ver estado:**

  ```bash
  sudo systemctl status jenkins
  ```

---

## Notas Adicionales

* El puerto por defecto de Jenkins es el **8080**. Si otro servicio lo está utilizando, puedes cambiarlo en `/etc/default/jenkins`.
* Para una instalación en la nube o con HTTPS, se recomienda configurar un proxy reverso con **Nginx** o **Apache**.

---

## Enlaces útiles

* [Sitio oficial de Jenkins](https://www.jenkins.io/)
* [Documentación para Debian/Ubuntu](https://www.jenkins.io/doc/book/installing/linux/)


