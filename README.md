
# **CyberLand Labs Script**

## **Descripción**
El **CyberLand Labs Script** es una herramienta diseñada para facilitar la gestión de máquinas virtuales en entornos Docker, con un enfoque particular en retos de seguridad informática como **Capture The Flag (CTF)**. Este script interactivo permite tanto a jugadores como a creadores administrar, importar, crear y personalizar máquinas, con soporte para escenarios avanzados como pivoting y configuraciones de servicios automatizados.

---

## **Características Principales**
- 🎮 **Perfil Jugador**: Importa y ejecuta máquinas CTF listas para jugar.
- 🛠️ **Perfil Creador**: Crea máquinas personalizadas, configura servicios y exporta máquinas en formato `.tar`.
- 📂 **Gestión Completa de Docker**: 
  - Importa, inicia, conecta, elimina contenedores e imágenes.
  - Configura servicios para iniciar automáticamente en contenedores.
- 🌐 **Soporte Multimáquina**: Importa y ejecuta múltiples máquinas para escenarios avanzados como pivoting.
- ⚙️ **Configuración de Servicios**: Define servicios que se ejecutan automáticamente al iniciar una máquina.

---

## **Requisitos**
1. **Docker** instalado en el sistema. Si no lo tienes, consulta [Docker Docs](https://docs.docker.com/get-docker/).
2. Permisos de **administrador** o acceso con `sudo` para ejecutar el script.
3. Ambiente Linux o cualquier entorno compatible con Bash.

---

## **Instrucciones de Uso**

### **1. Descargar el Script**
Clona este repositorio en tu máquina:
```bash
git clone https://github.com/Rannden-SHA/CyberLand-Labs.git
cd CyberLand-Labs
```

Asegúrate de dar permisos de ejecución al script:
```bash
chmod +x cyberland.sh
```

### **2. Ejecutar el Script**
Para iniciar el script, ejecuta:
```bash
sudo bash cyberland.sh
```

---

## **Menús del Script**

### **Menú Principal**
Este es el punto de entrada del script. Desde aquí puedes acceder a:
1. **Perfil Jugador**: Para jugar máquinas CTF.
2. **Perfil Creador**: Para crear y personalizar máquinas.
3. **Comprobar Requisitos**: Verifica si Docker está instalado y configurado correctamente.
4. **Créditos**: Información sobre los desarrolladores del proyecto.
5. **Salir**

---

### **Perfil Jugador**
Diseñado para quienes desean resolver desafíos en máquinas preconfiguradas.
- **Importar Máquinas CTF**: Carga máquinas desde archivos `.tar`.
- **Iniciar Máquinas**: Ejecuta automáticamente las máquinas importadas.
- **Listar y Administrar Máquinas**: Visualiza y administra las imágenes y contenedores disponibles.
- **Limpieza Completa**: Elimina todas las imágenes y contenedores de Docker.

#### **Jugar una Máquina**
1. Selecciona **"Importar máquina/s desde archivo local"** en el menú.
2. Proporciona la ruta al archivo `.tar` de la máquina.
3. El script importará y ejecutará automáticamente la máquina.
4. Conecta a la máquina usando su dirección IP:
   - Usa herramientas como `ping` o `nmap` para identificar puertos y servicios.
   - Accede al CTF y comienza a resolver los retos.

---

### **Perfil Creador**
El menú del creador está diseñado para quienes desean crear o personalizar máquinas CTF.

#### **Crear una Nueva Máquina**
1. Selecciona **"Crear nueva máquina"**.
2. Proporciona:
   - **Nombre de la máquina** (único y sin espacios).
   - **Imagen base** (ej. `ubuntu:20.04`).
   - **Puertos** a exponer (separados por comas, ej. `22,80`).
   - **Contenido de las flags** para `user.txt` y `root.txt`.
3. La máquina se construirá como una nueva imagen de Docker.
4. Opcionalmente, el script te preguntará si deseas:
   - Iniciar un contenedor para configuraciones adicionales.
   - Exportar la máquina en formato `.tar`.

#### **Configurar Servicios en una Máquina**
1. Selecciona **"Configurar servicios en una imagen"**.
2. Escribe el nombre de la imagen que deseas configurar.
3. Proporciona una lista de servicios separados por espacios (ej. `apache2 ssh mysql`).
4. El script generará una nueva imagen con los servicios configurados para iniciarse automáticamente.

#### **Exportar Máquinas**
1. Tras crear o modificar una máquina, selecciona **"Exportar imagen Docker a archivo .tar"**.
2. La imagen se guardará en el formato `nombre_imagen.tar`.

---

### **Administración de Docker**
Este submenú permite gestionar imágenes y contenedores de Docker.
- **Importar**: Carga máquinas desde archivos `.tar`.
- **Iniciar**: Arranca una máquina (imagen Docker).
- **Conectar**: Conéctate a un contenedor en ejecución.
- **Eliminar**: Elimina imágenes o contenedores.
- **Limpieza Completa**: Borra todas las imágenes y contenedores.

---

## **Ejemplo de Uso**

### **Jugar una Máquina**
1. Importa un archivo `.tar` con la opción **"Importar máquina/s desde archivo local"**.
2. El script nos mostrará la ip para conectarnos a la máquina.

### **Crear una Máquina CTF**
1. Selecciona **"Crear nueva máquina"** en el perfil creador.
2. Usa una imagen base como `ubuntu:20.04`.
3. Configura las flags, los puertos y guarda los cambios.
4. Entra en la máquina, haz los cambios que necesites y guárdala.
5. Exporta la máquina y súbela en https://cyberlandsec.com/cyberland-labs/ dándole al botón de subir máquina.

---

## **Errores Comunes y Soluciones**

### **Problema:** Los servicios no inician automáticamente después de crear una máquina.
- **Solución:** Asegúrate de haber configurado correctamente los servicios con `configurar_servicios`.

### **Problema:** Docker no está instalado.
- **Solución:** Instala Docker siguiendo las instrucciones de [Docker Docs](https://docs.docker.com/get-docker/).

---

## **Contribuciones**
Las contribuciones son bienvenidas. Por favor, realiza un **fork** del repositorio, realiza tus cambios y envía un **pull request**.

---

## **Créditos**
- **CEO de CyberLand Labs**: [Adrián Gisbert](https://www.linkedin.com/in/sr-gisbert/)
- **Creador de Máquinas CTF**: [Santiago Guevara](https://www.linkedin.com/in/santiagoguevara-/)

🌐 **Más Información**: [CyberLand Labs](https://cyberlandsec.com)

---

¡Explora, aprende y conquista en CyberLand Labs!
