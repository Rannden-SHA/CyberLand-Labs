#!/bin/bash

GREEN="\e[92m"
LIGHT_GREEN="\e[1;32m"
RED="\e[31m"
LIGHT_RED="\e[1;31m"
YELLOW="\e[93m"
BLUE="\e[1;34m"
CYAN="\e[96m"
MAGENTA="\e[1;35m"
RESET="\e[0m"

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ Este script debe ejecutarse como root o con sudo.${RESET}" 
   exit 1
fi

#######################################################################
##################### FUNCIONES PARA LOS MENÚS ########################

menu_principal() {
    while true; do
        clear
        echo
        echo -e "${GREEN}  ██████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗      █████╗ ███╗   ██╗██████╗${RESET}"
        echo -e "${GREEN} ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗${RESET}"
        echo -e "${GREEN} ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║     ███████║██╔██╗ ██║██║  ██║${RESET}"
        echo -e "${GREEN} ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║${RESET}"
        echo -e "${GREEN} ╚██████╗   ██║   ██████╔╝███████╗██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝${RESET}"
        echo -e "${GREEN}  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝${RESET}" 
        echo                                                                             
        echo -e "${GREEN}                     ██╗      █████╗ ██████╗ ███████╗${RESET}"                       
        echo -e "${GREEN}                     ██║     ██╔══██╗██╔══██╗██╔════╝${RESET}"                       
        echo -e "${GREEN}                     ██║     ███████║██████╔╝███████╗${RESET}"                       
        echo -e "${GREEN}                     ██║     ██╔══██║██╔══██╗╚════██║${RESET}"                       
        echo -e "${GREEN}                     ███████╗██║  ██║██████╔╝███████║${RESET}"                       
        echo -e "${GREEN}                     ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝${RESET}" 
        echo
        echo -e "${YELLOW}               Welcome to CyberLand Labs - Hack the Future!${RESET}"
        echo -e "${GREEN}===============================================================================${RESET}"                                                                                        
        echo
        echo -e "${CYAN}Este script te permite administrar, crear, exportar y eliminar imágenes y contenedores Docker.${RESET}"
        echo -e "${CYAN}Podrás crear y configurar nuevas máquinas para CTFs, exportarlas y, si lo deseas, jugar en ellas.${RESET}"
        echo
        echo -e "${MAGENTA}🔹 Existen cinco opciones disponibles: ${RESET}"
        echo -e "${LIGHT_RED}1) Perfil Jugador    - Descargar, ejecutar y resolver desafíos en las máquinas CTF ya configuradas.${RESET}"
        echo -e "${YELLOW}2) Perfil Creador    - Crear, configurar y exportar nuevas máquinas CTF.${RESET}"
        echo -e "${GREEN}3)${RESET} Comprobar Requisitos"
        echo -e "${GREEN}4)${RESET} Créditos"
        echo -e "${GREEN}5)${RESET} Salir del script"
        echo
        echo -e "🌐 Web principal: ${LIGHT_GREEN}https://cyberlandsec.com${RESET}"
        echo
        echo -e "${GREEN}==========================================${RESET}"
        echo
        echo -e "${CYAN}Ingrese el número correspondiente a la opción deseada:${RESET}"
        read -p "Opción: " opcion
        case $opcion in
            1)
                iniciar_perfil_jugador
                ;;
            2)
                iniciar_perfil_creador
                ;;
            3)
                comprobar_requisitos
                ;;
            4)
                mostrar_creditos
                ;;
            5)
                salir_script
                ;;
            *)
                echo -e "${LIGHT_RED}❌ Opción inválida. Por favor, ingrese un número entre 1 y 5.${RESET}"
                sleep 2
                ;;
        esac
    done
}

menu_jugador() {
    while true; do
        clear
        echo -e "${GREEN}==========================================${RESET}"
        echo -e "${LIGHT_GREEN}    🎮 Menú del Perfil Jugador 🎮${RESET}"
        echo -e "${GREEN}==========================================${RESET}"
        echo

        # Mostrar imágenes actuales en un recuadro
        echo -e "${BLUE}╔══════════════════════════════════════════╗${RESET}"
        echo -e "${BLUE}║    📋 Máquinas Disponibles (Imágenes)    ║${RESET}"
        echo -e "${BLUE}╚══════════════════════════════════════════╝${RESET}"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
        if [ -z "$(docker images -q)" ]; then
            echo -e "${YELLOW}No hay máquinas disponibles actualmente.${RESET}"
        fi
        echo
        echo -e "${GREEN}==========================================${RESET}"
        echo
        # Mostrar contenedores actuales en un recuadro
        echo -e "${BLUE}╔══════════════════════════════════════════╗${RESET}"
        echo -e "${BLUE}║         🐳 Contenedores Actuales         ║${RESET}"
        echo -e "${BLUE}╚══════════════════════════════════════════╝${RESET}"
        docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
        if [ -z "$(docker ps -a -q)" ]; then
            echo -e "${YELLOW}No hay contenedores actualmente.${RESET}"
        fi
        echo
        echo -e "${GREEN}==========================================${RESET}"
        echo
        # Opciones del menú
        echo -e "${GREEN}1) Importar máquina/s CTF desde archivo local${RESET}"
        echo -e "${YELLOW}2) Eliminar imagen Docker existente${RESET}"
        echo -e "${RED}3) ⚠️  Limpieza completa de Docker${RESET}"
        echo -e "4) Regresar al menú principal"
        echo -e "5) Salir del script"
        echo
        read -p "Seleccione una opción: " opcion
        if [[ -z "$opcion" || ! "$opcion" =~ ^[1-5]$ ]]; then
            echo "❌ Opción inválida. Por favor ingrese un número entre 1 y 5."
            read -p "Presione Enter para continuar..." dummy
            continue
        fi
        case $opcion in
            1) importar_maquina ;;
            2) eliminar_imagen ;;
            3) limpiar_docker ;;
            4) break ;;
            5) salir_script ;;
        esac
    done
}

menu_creador() {
    while true; do
        clear
        echo -e "${GREEN}==========================================${RESET}"
        echo -e "${LIGHT_GREEN}    🔧 Menú del Perfil Creador 🔧${RESET}"
        echo -e "${GREEN}==========================================${RESET}"
        echo

        # Mostrar imágenes actuales en un recuadro
        echo -e "${BLUE}╔══════════════════════════════════════════╗${RESET}"
        echo -e "${BLUE}║    📋 Máquinas Disponibles (Imágenes)    ║${RESET}"
        echo -e "${BLUE}╚══════════════════════════════════════════╝${RESET}"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
        if [ -z "$(docker images -q)" ]; then
            echo -e "${YELLOW}No hay máquinas disponibles actualmente.${RESET}"
        fi
        echo
        echo -e "${GREEN}==========================================${RESET}"
        echo
        # Mostrar contenedores actuales en un recuadro
        echo -e "${BLUE}╔══════════════════════════════════════════╗${RESET}"
        echo -e "${BLUE}║         🐳 Contenedores Actuales         ║${RESET}"
        echo -e "${BLUE}╚══════════════════════════════════════════╝${RESET}"
        docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
        if [ -z "$(docker ps -a -q)" ]; then
            echo -e "${YELLOW}No hay contenedores actualmente.${RESET}"
        fi
        echo
        echo -e "${GREEN}==========================================${RESET}"
        echo
        # Opciones del menú
        echo -e "${GREEN}1) Crear nueva máquina${RESET}"
        echo -e "${GREEN}2) Importar máquina/s desde archivo local${RESET}"
        echo -e "${CYAN}3) Iniciar una imagen Docker${RESET}"
        echo -e "${CYAN}4) Eliminar una imagen Docker${RESET}"
        echo -e "${BLUE}5) Detener un contenedor Docker${RESET}"
        echo -e "${BLUE}6) Eliminar contenedor Docker${RESET}"
        echo -e "${BLUE}7) Conectar a un contenedor para modificarlo${RESET}"
        echo -e "${BLUE}8) Guardar contenedor como nueva imagen${RESET}"
        echo -e "${YELLOW}9) Configurar servicios en una imagen${RESET}"
        echo -e "${YELLOW}10) Exportar imagen Docker a archivo .tar${RESET}"
        echo -e "${RED}11) ⚠️  Limpieza completa de Docker${RESET}"
        echo -e "12) Regresar al menú principal"
        echo -e "13) Salir del script"
        echo
        read -p "Seleccione una opción: " opcion_docker
        case $opcion_docker in
            1) crear_maquina ;;
            2) importar_maquina ;;
            3) iniciar_maquina_exportada ;;
            4) eliminar_imagen ;;
            5) detener_contenedor ;;
            6) eliminar_contenedor ;;
            7) conectar_contenedor ;;
            8) guardar_contenedor_como_imagen ;;
            9) configurar_servicios ;;
            10) exportar_imagen ;;
            11) limpiar_docker ;;
            12) break ;;
            13) salir_script ;;
            *) echo "❌ Opción inválida. Por favor, seleccione un número entre 1 y 13."; read -p "Presione Enter para continuar..." dummy ;;
        esac
    done
}

mostrar_creditos() {
    clear
    # Encabezado
    echo -e "${GREEN}  ██████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗      █████╗ ███╗   ██╗██████╗${RESET}"
    echo -e "${GREEN} ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗${RESET}"
    echo -e "${GREEN} ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║     ███████║██╔██╗ ██║██║  ██║${RESET}"
    echo -e "${GREEN} ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║${RESET}"
    echo -e "${GREEN} ╚██████╗   ██║   ██████╔╝███████╗██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝${RESET}"
    echo -e "${GREEN}  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝${RESET}" 
    echo                                                                             
    echo -e "${GREEN}                     ██╗      █████╗ ██████╗ ███████╗${RESET}"                       
    echo -e "${GREEN}                     ██║     ██╔══██╗██╔══██╗██╔════╝${RESET}"                       
    echo -e "${GREEN}                     ██║     ███████║██████╔╝███████╗${RESET}"                       
    echo -e "${GREEN}                     ██║     ██╔══██║██╔══██╗╚════██║${RESET}"                       
    echo -e "${GREEN}                     ███████╗██║  ██║██████╔╝███████║${RESET}"                       
    echo -e "${GREEN}                     ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝${RESET}" 
    echo
    echo -e "${LIGHT_CYAN}               Welcome to CyberLand Labs - Hack the Future!${RESET}"
    echo -e "${GREEN}===============================================================================${RESET}"    
    echo

    # CEO
    echo -e "${YELLOW}👨‍💼 CEO de CyberLand Labs:${RESET}"
    echo -e "${CYAN}Nombre: ${LIGHT_RED}Adrián Gisbert${RESET}"
    echo -e "${CYAN}Contribuciones: ${LIGHT_RED}Desarrollo, programación y mejora de la web${RESET}"
    echo -e "${CYAN}Web: ${LIGHT_GREEN}https://cyberlandsec.com${RESET}"
    echo -e "${CYAN}LinkedIn: ${LIGHT_GREEN}https://www.linkedin.com/in/sr-gisbert/${RESET}"
    echo

    # Creador Principal de Máquinas
    echo -e "${YELLOW}🛠️  Creador Principal de Máquinas:${RESET}"
    echo -e "${CYAN}Nombre: ${LIGHT_RED}Santiago Guevara${RESET}"
    echo -e "${CYAN}Contribuciones: ${LIGHT_RED}Administración, creación y desarrollo de nuevas máquinas CTFs${RESET}"
    echo -e "${CYAN}LinkedIn: ${LIGHT_GREEN}https://www.linkedin.com/in/santiagoguevara-/${RESET}"
    echo

    # Pie de página
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║         ${LIGHT_RED}Gracias por ser parte de la comunidad de CyberLand! 🌐${MAGENTA}     ║${RESET}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════════════╝${RESET}"
    echo
    read -p "Presione Enter para regresar al menú principal..."
}

#######################################################################
################### FUNCIONES PARA LOS SERVICIOS ######################

configurar_servicios() {
    clear
    echo -e "${GREEN}================================================${RESET}"
    echo -e "${LIGHT_GREEN}  🛠️  Configurar Servicios en Imagen Docker 🛠️${RESET}"
    echo -e "${GREEN}================================================${RESET}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}"  # Listar imágenes disponibles
    echo
    read -p "Ingrese el nombre de la imagen que desea configurar (nombre:tag, ej: miimagen:configurada): " nombre_imagen
    if [ -z "$nombre_imagen" ]; then
        echo "❌ No ha ingresado un nombre de imagen. Regresando al menú..."
        read -p "Presione Enter para regresar al menú..."
        return
    fi

    echo -e "${GREEN}==============================================================================================${RESET}"
    echo -e "${CYAN}    Ingrese los servicios que desea iniciar automáticamente, separados por espacios.${RESET}"
    echo -e "${CYAN}    Ejemplo: apache2 ssh vsftpd mysql nginx tomcat9 mongod${RESET}"
    echo -e "${GREEN}==============================================================================================${RESET}"

    read -p "Servicios (separados por espacios): " servicios_input
    if [ -z "$servicios_input" ]; then
        echo "❌ No se han configurado servicios. Regresando al menú..."
        read -p "Presione Enter para regresar al menú..."
        return
    fi

    # Construir el comando CMD directamente
    cmd_command="CMD service $(echo $servicios_input | sed 's/ / start \&\& service /g') start && tail -f /dev/null"

    echo "Creando un nuevo Dockerfile para configurar los servicios..."
    cat <<EOF > Dockerfile
FROM $nombre_imagen

USER root

RUN apt-get update && apt-get install -y systemctl && apt-get clean

$cmd_command
EOF

    read -p "Ingrese el nombre de la nueva imagen (ej: miimagen:servicios): " nueva_imagen
    if [ -z "$nueva_imagen" ]; then
        echo "❌ No ha ingresado un nombre para la nueva imagen. Regresando al menú..."
        read -p "Presione Enter para regresar al menú..."
        rm -f Dockerfile
        return
    fi

    echo "Construyendo la nueva imagen con los servicios configurados..."
    docker build -t "$nueva_imagen" .
    if [ $? -eq 0 ]; then
        echo "🎉 La imagen '$nueva_imagen' ha sido configurada exitosamente."
    else
        echo "❌ Ocurrió un error al construir la nueva imagen."
        read -p "Presione Enter para regresar al menú..."
        rm -f Dockerfile
        return
    fi

    rm -f Dockerfile

    # Preguntar si se desea exportar la imagen
    read -p "¿Desea exportar esta imagen a formato .tar? (s/n): " exportar_imagen
    if [[ "$exportar_imagen" =~ ^[sS]$ ]]; then
        tar_file="${nueva_imagen//:/_}.tar"  # Reemplazar ":" en el nombre de la imagen para el archivo .tar
        echo "Exportando la imagen '$nueva_imagen' a '$tar_file'..."
        docker save -o "$tar_file" "$nueva_imagen"
        if [ $? -eq 0 ]; then
            echo "🎉 La imagen '$nueva_imagen' ha sido exportada exitosamente a '$tar_file'."
        else
            echo "❌ Ocurrió un error al exportar la imagen."
        fi
    fi

    read -p "Presione Enter para regresar al menú..."
}

#######################################################################
#################### FUNCIONES PARA LAS IMÁGENES ######################

eliminar_imagen() {
    while true; do
        clear
        echo -e "${GREEN}==========================================${RESET}"
        echo -e "${LIGHT_GREEN}    🗑️ Eliminar Imagen Docker 🗑️${RESET}"
        echo -e "${GREEN}==========================================${RESET}"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}"
        read -p "Ingrese el nombre de la imagen que desea eliminar (nombre:tag, ej: ubuntu:20.04): " nombre_imagen
        if [ -z "$nombre_imagen" ]; then
            echo "❌ No ha ingresado un nombre de imagen. Regresando al menú..."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
        contenedores_que_usan_imagen=$(docker ps -a -q -f "ancestor=$nombre_imagen")
        if [ -n "$contenedores_que_usan_imagen" ]; then
            echo "⚠️ Hay contenedores usando la imagen '$nombre_imagen'. Deteniéndolos y eliminándolos..."
            docker stop $contenedores_que_usan_imagen
            docker rm $contenedores_que_usan_imagen
            if [ $? -ne 0 ]; then
                echo "❌ Ocurrió un error al detener o eliminar los contenedores."
                read -p "Presione Enter para regresar al menú..."
                return
            fi
        fi
        docker rmi "$nombre_imagen"
        if [ $? -eq 0 ]; then
            echo "🎉 La imagen '$nombre_imagen' ha sido eliminada correctamente."
        else
            echo "❌ Ocurrió un error al eliminar la imagen."
            read -p "Presione Enter para regresar al menú..."
        fi
        read -p "¿Desea eliminar otra imagen? (s/n): " eliminar_otro
        if [[ ! "$eliminar_otro" =~ ^[sS]$ ]]; then
            break
        fi
    done
}

exportar_imagen() {
    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_GREEN} 📦 Exportar Imagen Docker a .tar 📦${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}"  # Listar imágenes disponibles
    echo
    read -p "Ingrese el nombre de la imagen que desea exportar (nombre:tag, ej: ubuntu:20.04): " nombre_imagen
    if [ -z "$nombre_imagen" ]; then
        echo "❌ No ha ingresado un nombre de imagen. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    read -p "Ingrese el nombre del archivo destino (sin extensión): " archivo_destino
    if [ -z "$archivo_destino" ]; then
        echo "❌ No ha ingresado un nombre de archivo. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    archivo_destino="${archivo_destino}.tar"  # Agregar extensión
    echo "Exportando la imagen '$nombre_imagen' a '$archivo_destino'..."
    docker save -o "$archivo_destino" "$nombre_imagen"
    if [ $? -eq 0 ]; then
        echo "🎉 La imagen ha sido exportada correctamente a '$archivo_destino'."
    else
        echo "❌ Ocurrió un error al exportar la imagen."
    fi
    read -p "Presione Enter para regresar al menú..."
}

#######################################################################
#################### FUNCIONES PARA LAS MÁQUINAS ######################

crear_maquina() {
    local HIDDEN_MARKER="TcOhcXVpbmEgZ2VuZXJhZGEgY29uIGN5YmVybGFuZC5zaCBzY3JpcHQgZGVzYXJyb2xsYWRvIHBvciA0azRtMW0zLiDCgUdyYWNpYXMgcG9yIGVsZWdpciBDeWJlckxhbmQgTGFicyEgVmlzaXRhOiBodHRwczovL2N5YmVybGFuZHNlYy5jb20="

    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_GREEN} 🛠️  Crear una nueva máquina CTF 🛠️${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    read -p "Ingrese el nombre de la nueva máquina (en minúscula sin espacios): " nombre_maquina
    read -p "Ingrese la imagen base (Ej: ubuntu:20.04, ubuntu:latest, etc.): " imagen_base
    read -p "Ingrese los puertos a exponer (Ej: 22,80): " puertos
    read -p "Ingrese el contenido de la flag user.txt: " flag_user
    read -p "Ingrese el contenido de la flag root.txt: " flag_root
    if [ -z "$nombre_maquina" ] || [ -z "$imagen_base" ] || [ -z "$puertos" ] || [ -z "$flag_user" ] || [ -z "$flag_root" ]; then
        echo "❌ Todos los campos obligatorios deben ser llenados. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    echo "Creando Dockerfile..."
    cat <<EOF > Dockerfile
FROM $imagen_base

# Crear usuario cyberland (opcional)
RUN groupadd cyberland && \
    useradd -m -g cyberland cyberland

RUN echo "cyberland:olh545@!4#jalq" | chpasswd && \
    echo "root:akjhfd45@!654d6s54d6" | chpasswd

# Configurar flags y directorios
RUN echo "$flag_user" > /home/cyberland/user.txt && \
    echo "$flag_root" > /root/root.txt

RUN mkdir /home/cyberland/.cyberland_info && \
    echo "$HIDDEN_MARKER" | base64 --decode > /home/cyberland/.cyberland_info/.cyberland_info.txt && \
    chown cyberland:cyberland /home/cyberland/.cyberland_info/.cyberland_info.txt && \
    chmod 600 /home/cyberland/.cyberland_info/.cyberland_info.txt

RUN echo "$(echo "$HIDDEN_MARKER" | base64 --decode)" >> /etc/motd

RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurar usuario predeterminado como root para garantizar acceso
USER root
WORKDIR /root

# Exponer los puertos individualmente
EOF

    IFS=',' read -ra PUERTOS_ARRAY <<< "$puertos"
    for puerto in "${PUERTOS_ARRAY[@]}"; do
        echo "EXPOSE $puerto" >> Dockerfile
    done

    cat <<EOF >> Dockerfile

CMD ["bash"]
EOF

    echo "Construyendo la imagen Docker..."
    docker build -t "$nombre_maquina" .
    if [ $? -ne 0 ]; then
        echo "❌ Error al construir la imagen Docker. Verifica el Dockerfile y los parámetros ingresados."
        rm -f Dockerfile
        read -p "Presione Enter para regresar al menú..."
        return
    fi
    rm -f Dockerfile
    echo "🚀 Máquina '$nombre_maquina' creada exitosamente."
    echo
    read -p "¿Desea iniciar el contenedor para conectarse y configurarlo? (s/n): " iniciar
    if [[ "$iniciar" =~ ^[sS]$ ]]; then
        echo -e "Para finalizar la configuración y regresar al menú principal, escriba 'exit' y presione Enter."
        echo -e "\nIniciando contenedor...\n"
        docker run -it --name "${nombre_maquina}_container" "$nombre_maquina" bash
    fi

    # Preguntar si desea sobrescribir la imagen existente
    read -p "¿Desea guardar los cambios realizados en la imagen '$nombre_maquina'? (s/n): " sobrescribir
    if [[ "$sobrescribir" =~ ^[sS]$ ]]; then
        docker commit "${nombre_maquina}_container" "$nombre_maquina"
        if [ $? -eq 0 ]; then
            echo "🎉 La imagen '$nombre_maquina' ha sido actualizada exitosamente."

            # Preguntar si desea exportar a formato tar
            read -p "¿Desea exportar esta imagen a formato tar? (s/n): " exportar
            if [[ "$exportar" =~ ^[sS]$ ]]; then
                docker save -o "${nombre_maquina}.tar" "$nombre_maquina"
                if [ $? -eq 0 ]; then
                    echo "🎉 La imagen ha sido exportada a '${nombre_maquina}.tar'."
                else
                    echo "❌ Ocurrió un error al exportar la imagen."
                fi
            fi
        else
            echo "❌ Ocurrió un error al sobrescribir la imagen '$nombre_maquina'."
        fi
    fi

    echo -e "\n¿Qué le gustaría hacer ahora?"
    echo -e "${GREEN}1)${RESET} Regresar al menú principal"
    echo -e "${GREEN}2)${RESET} Salir del script"
    read -p "Seleccione una opción: " opcion_final
    case $opcion_final in
        1) return ;;
        2) salir_script ;;
        *) echo "❌ Opción inválida. Regresando al menú principal..."; read -p "Presione Enter para continuar..." dummy ;;
    esac
}

importar_maquina() {
    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_GREEN}  📂 Importar y Ejecutar Máquinas CTF 📂${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    echo
    echo -e "${CYAN}Nota: Puedes importar varias máquinas a la vez ingresando los archivos separados por espacios.${RESET}"
    echo -e "${CYAN}Ejemplo: /ruta/a/machine1.tar /ruta/a/machine2.tar${RESET}"
    echo
    read -p "Ingrese las rutas de los archivos de las máquinas (separadas por espacio): " archivos
    if [ -z "$archivos" ]; then
        echo "❌ No se han ingresado rutas de archivos. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi

    for archivo_maquina in $archivos; do
        if [ ! -f "$archivo_maquina" ]; then
            echo "❌ El archivo '$archivo_maquina' no existe. Omitiéndolo..."
            continue
        fi

        echo "Importando la máquina desde '$archivo_maquina'..."
        imagen_id=$(docker load -i "$archivo_maquina" | awk '/Loaded image: / {print $3}')
        if [ $? -eq 0 ]; then
            echo "🎉 La máquina ha sido importada exitosamente."
            echo "Imagen cargada: $imagen_id"
        else
            echo "❌ Ocurrió un error al importar la máquina desde '$archivo_maquina'."
            continue
        fi

        # Generar nombre del contenedor automáticamente
        contenedor_nombre="cyberland_${imagen_id//[:\/]/_}" # Reemplaza caracteres no válidos para nombres
        echo "Iniciando la máquina como contenedor '$contenedor_nombre'..."
        docker run -d --name "$contenedor_nombre" "$imagen_id"
        if [ $? -eq 0 ]; then
            container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$contenedor_nombre")
            if [ -z "$container_ip" ]; then
                echo "❌ No se pudo obtener la dirección IP del contenedor '$contenedor_nombre'."
            else
                echo
                echo -e "${GREEN}==========================================${RESET}"
                echo -e "\e[1;36m🔌 La dirección IP de la máquina '$contenedor_nombre' es: $container_ip\e[0m"
                echo -e "${GREEN}==========================================${RESET}"
                echo
                echo -e "\e[1;34m➡️ Ahora puedes realizar pruebas de conexión con \`ping\`, usar \`nmap\` para identificar puertos y servicios, y comenzar tu CTF.\e[0m"
                echo
            fi
        else
            echo "❌ Ocurrió un error al iniciar el contenedor '$contenedor_nombre'."
        fi
    done

    echo -e "${CYAN}🎉 Todas las máquinas procesadas e iniciadas automáticamente.${RESET}"
    read -p "Presione Enter para regresar al menú..."
}

iniciar_maquina_exportada() {
    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_GREEN}   🚀 Iniciar máquina exportada 🚀${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    docker images
    read -p "Ingrese el nombre de la máquina que desea iniciar (nombre:tag, ej: debian:latest): " nombre_maquina
    if [ -z "$nombre_maquina" ]; then
        echo "❌ No ha ingresado el nombre de la máquina. Regresando al menú..."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    contenedor_nombre="${nombre_maquina//:/_}_container"
    contenedor_existente=$(docker ps -a -q -f "name=$contenedor_nombre")
    if [ -n "$contenedor_existente" ]; then
        echo "⚠️ El contenedor '$contenedor_nombre' ya existe. Deteniéndolo y eliminándolo..."
        docker stop "$contenedor_nombre"
        docker rm "$contenedor_nombre"
        if [ $? -ne 0 ]; then
            echo "❌ Ocurrió un error al detener o eliminar el contenedor."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
    fi
    echo "Iniciando el contenedor '$nombre_maquina'..."
    docker run -d --name "$contenedor_nombre" "$nombre_maquina" tail -f /dev/null
    container_status=$(docker ps -q -f "name=$contenedor_nombre")
    if [ -z "$container_status" ]; then
        echo "❌ El contenedor no se está ejecutando. Esto podría ser por un error en el contenedor."
        sleep 2
        docker logs "$contenedor_nombre" 2>&1 | tee logs.txt
        echo "Los logs del contenedor están guardados en 'logs.txt'."
        read -p "Presione Enter para regresar al menú..."
        return
    fi
    container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$contenedor_nombre")
    if [ -z "$container_ip" ]; then
        echo "❌ No se pudo obtener la dirección IP del contenedor."
    else
        echo
        echo -e "${GREEN}==========================================${RESET}"
        echo -e "\e[1;36m🔌 La dirección IP de la máquina es: $container_ip\e[0m"
        echo -e "${GREEN}==========================================${RESET}"
        echo
        echo -e "\e[1;34m➡️ Ahora puedes realizar pruebas de conexión con \`ping\`, usar \`nmap\` para identificar puertos y servicios, y comenzar tu CTF.\e[0m"
        echo
    fi
    read -p "Presione Enter para regresar al menú..."
}

###########################################################################
#################### FUNCIONES PARA LOS CONTENEDORES ######################

detener_contenedor() {
    while true; do
        clear
        echo -e "${GREEN}==========================================${RESET}"
        echo -e "${LIGHT_GREEN}    🛑 Detener Contenedor Docker 🛑${RESET}"
        echo -e "${GREEN}==========================================${RESET}"
        docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"  # Mostrar solo contenedores en ejecución
        echo
        read -p "Ingrese el CONTAINER ID del contenedor que desea detener: " contenedor_id
        if [ -z "$contenedor_id" ]; then
            echo "❌ No ha ingresado un CONTAINER ID."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
        container_running=$(docker ps -q -f "id=$contenedor_id")
        if [ -z "$container_running" ]; then
            echo "❌ El contenedor con ID '$contenedor_id' no está en ejecución o no existe."
            read -p "Presione Enter para intentar nuevamente..."
            continue
        fi
        docker stop "$contenedor_id"
        if [ $? -eq 0 ]; then
            echo "🎉 El contenedor '$contenedor_id' ha sido detenido correctamente."
        else
            echo "❌ Ocurrió un error al detener el contenedor."
            read -p "Presione Enter para regresar al menú..."
        fi
        read -p "¿Desea detener otro contenedor? (s/n): " detener_otro
        if [[ ! "$detener_otro" =~ ^[sS]$ ]]; then
            break
        fi
    done
}

eliminar_contenedor() {
    while true; do
        clear
        echo -e "${GREEN}==========================================${RESET}"
        echo -e "${LIGHT_GREEN}    🗑️  Eliminar Contenedor Docker 🗑️${RESET}"
        echo -e "${GREEN}==========================================${RESET}"
        docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
        read -p "Ingrese el CONTAINER ID del contenedor que desea eliminar: " contenedor_id
        if [ -z "$contenedor_id" ]; then
            echo "❌ No ha ingresado un CONTAINER ID."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
        container_exists=$(docker ps -a -q -f "id=$contenedor_id")
        if [ -z "$container_exists" ]; then
            echo "❌ El contenedor con ID '$contenedor_id' no existe."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
        docker rm -f "$contenedor_id"
        if [ $? -eq 0 ]; then
            echo "🎉 El contenedor '$contenedor_id' ha sido eliminado correctamente."
        else
            echo "❌ Ocurrió un error al eliminar el contenedor."
            read -p "Presione Enter para regresar al menú..."
        fi
        read -p "¿Desea eliminar otro contenedor? (s/n): " eliminar_otro
        if [[ ! "$eliminar_otro" =~ ^[sS]$ ]]; then
            break
        fi
    done
}

conectar_contenedor() {
    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_GREEN} 🔧 Conectar a un Contenedor Docker 🔧${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    read -p "Ingrese el CONTAINER ID del contenedor que desea modificar: " container_id
    if [ -z "$container_id" ]; then
        echo "❌ No ha ingresado un CONTAINER ID."
        read -p "Presione Enter para regresar al menú..."
        return
    fi
    container_exists=$(docker ps -a -q -f "id=$container_id")
    if [ -z "$container_exists" ]; then
        echo "❌ El contenedor con ID '$container_id' no existe."
        read -p "Presione Enter para regresar al menú..."
        return
    fi
    container_status=$(docker inspect --format '{{.State.Status}}' "$container_id")
    if [ "$container_status" != "running" ]; then
        echo "⚠️ El contenedor con ID '$container_id' no está en ejecución."
        read -p "¿Desea iniciar el contenedor? (s/n): " iniciar_cont
        if [[ "$iniciar_cont" =~ ^[sS]$ ]]; then
            docker start "$container_id"
            if [ $? -ne 0 ]; then
                echo "❌ Ocurrió un error al iniciar el contenedor."
                read -p "Presione Enter para regresar al menú..."
                return
            fi
            echo "🚀 Contenedor '$container_id' iniciado correctamente."
        else
            echo "❌ No se inició el contenedor."
            read -p "Presione Enter para regresar al menú..."
            return
        fi
    fi

    echo "Conectando al contenedor '$container_id' como root..."
    docker exec -it "$container_id" bash
    if [ $? -ne 0 ]; then
        echo "❌ No se pudo conectar al contenedor."
        read -p "Presione Enter para regresar al menú..."
        return
    fi

    read -p "¿Desea guardar los cambios realizados en una nueva imagen? (s/n): " guardar_cambios
    if [[ "$guardar_cambios" =~ ^[sS]$ ]]; then
        read -p "Ingrese el nombre para la nueva imagen (ej: cyber:latest): " nueva_imagen
        if [ -n "$nueva_imagen" ]; then
            docker commit "$container_id" "$nueva_imagen"
            if [ $? -eq 0 ]; then
                echo "🎉 Los cambios se han guardado en la nueva imagen '$nueva_imagen'."
                
                # Preguntar si se desea exportar la imagen a .tar
                read -p "¿Desea exportar la nueva imagen a formato .tar? (s/n): " exportar_tar
                if [[ "$exportar_tar" =~ ^[sS]$ ]]; then
                    read -p "Ingrese el nombre del archivo .tar (sin extensión): " archivo_tar
                    if [ -n "$archivo_tar" ]; then
                        archivo_tar="${archivo_tar}.tar"
                        docker save -o "$archivo_tar" "$nueva_imagen"
                        if [ $? -eq 0 ]; then
                            echo "🎉 La imagen '$nueva_imagen' ha sido exportada a '$archivo_tar'."
                        else
                            echo "❌ Ocurrió un error al exportar la imagen a formato .tar."
                            read -p "Presione Enter para regresar al menú..."
                        fi
                    else
                        echo "❌ No se proporcionó un nombre para el archivo .tar. No se realizó la exportación."
                        read -p "Presione Enter para regresar al menú..."
                    fi
                fi
            else
                echo "❌ Ocurrió un error al guardar la nueva imagen."
                read -p "Presione Enter para regresar al menú..."
            fi
        else
            echo "❌ No se proporcionó un nombre para la nueva imagen. No se guardaron los cambios."
            read -p "Presione Enter para regresar al menú..."
        fi
    fi
}

guardar_contenedor_como_imagen() {
    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_GREEN} 💾 Guardar Contenedor como Imagen Docker 🛠️${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" # Lista de contenedores en ejecución
    echo
    read -p "Ingrese el CONTAINER ID del contenedor que desea guardar: " container_id
    if [ -z "$container_id" ]; then
        echo "❌ No ha ingresado un CONTAINER ID."
        read -p "Presione Enter para continuar..." dummy
        return
    fi
    container_running=$(docker ps -q -f "id=$container_id")
    if [ -z "$container_running" ]; then
        echo "❌ El contenedor con ID '$container_id' no está en ejecución o no existe."
        read -p "Presione Enter para regresar al menú..."
        return
    fi
    read -p "Ingrese el nombre para la nueva imagen (ej: miimagen:latest): " nueva_imagen
    if [ -z "$nueva_imagen" ]; then
        echo "❌ No ha ingresado un nombre para la nueva imagen."
        read -p "Presione Enter para continuar..." dummy
        return
    fi

    echo "Guardando el contenedor '$container_id' como imagen '$nueva_imagen'..."
    docker commit "$container_id" "$nueva_imagen"
    if [ $? -eq 0 ]; then
        echo "🎉 La nueva imagen '$nueva_imagen' ha sido creada exitosamente."
    else
        echo "❌ Ocurrió un error al guardar el contenedor como imagen."
    fi
    read -p "Presione Enter para regresar al menú..."
}

###########################################################################
############################ OTRAS FUNCIONES ##############################

limpiar_docker() {
    clear
    echo -e "${RED}==========================================${RESET}"
    echo -e "${LIGHT_RED}    ⚠️  Limpieza Completa de Docker ⚠️${RESET}"
    echo -e "${RED}==========================================${RESET}"
    echo
    echo -e "${CYAN}Esta acción eliminará:${RESET}"
    echo -e "1) Todos los contenedores de Docker (en ejecución y detenidos)."
    echo -e "2) Todas las imágenes de Docker."
    echo
    echo -e "${YELLOW}Nota: Los archivos .tar no se verán afectados.${RESET}"
    echo

    # Mostrar contenedores existentes
    echo -e "${LIGHT_GREEN}📋 Contenedores Actuales:${RESET}"
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    if [ $? -ne 0 ] || [ -z "$(docker ps -a -q)" ]; then
        echo -e "${YELLOW}No hay contenedores.${RESET}"
    fi
    echo

    # Mostrar imágenes existentes
    echo -e "${LIGHT_GREEN}📋 Imágenes Actuales:${RESET}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
    if [ $? -ne 0 ] || [ -z "$(docker images -q)" ]; then
        echo -e "${YELLOW}No hay imágenes.${RESET}"
    fi
    echo

    # Confirmación del usuario
    read -p "¿Está seguro de que desea continuar con la limpieza? (s/n): " confirmacion
    if [[ ! "$confirmacion" =~ ^[sS]$ ]]; then
        echo -e "${LIGHT_RED}❌ Operación cancelada. Regresando al menú...${RESET}"
        read -p "Presione Enter para continuar..." dummy
        return
    fi

    # Detener y eliminar todos los contenedores
    echo -e "${LIGHT_GREEN}🛑 Deteniendo y eliminando todos los contenedores...${RESET}"
    docker ps -aq | xargs -r docker stop
    docker ps -aq | xargs -r docker rm
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Todos los contenedores han sido eliminados.${RESET}"
    else
        echo -e "${RED}❌ Error al eliminar los contenedores.${RESET}"
    fi

    # Eliminar todas las imágenes
    echo -e "${LIGHT_GREEN}🗑️ Eliminando todas las imágenes de Docker...${RESET}"
    docker images -q | xargs -r docker rmi -f
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Todas las imágenes han sido eliminadas.${RESET}"
    else
        echo -e "${RED}❌ Error al eliminar las imágenes.${RESET}"
    fi

    echo -e "${CYAN}🎉 Limpieza completada. Archivos .tar no se han eliminado.${RESET}"
    read -p "Presione Enter para regresar al menú..."
}

comprobar_requisitos() {
    clear
    echo -e "${GREEN}==========================================${RESET}"
    echo -e "${LIGHT_RED}     🔍 Comprobar Requisitos 🔍${RESET}"
    echo -e "${GREEN}==========================================${RESET}"
    echo
    if ! command -v docker &> /dev/null
    then
        echo -e "${RED}❌ Docker no está instalado.${RESET}"
        echo -e "Por favor, instala Docker y vuelve a intentarlo."
        echo -e "${YELLOW}Puedes descargarlo desde: https://docs.docker.com/get-docker/${RESET}"
    else
        echo -e "${GREEN}✅ Docker está instalado.${RESET}"
        docker --version
    fi
    echo
    read -p "Presione Enter para regresar al menú principal..."
}

iniciar_perfil_jugador() {
    clear
    echo -e "${LIGHT_GREEN}🕹️ Cargando el Perfil Jugador...${RESET}"
    menu_jugador
}

iniciar_perfil_creador() {
    clear
    echo -e "${LIGHT_GREEN}🛠️ Cargando el Perfil Creador...${RESET}"
    menu_creador
}

# Capturar SIGINT (Ctrl+C) y ejecutar salir_script
trap salir_script SIGINT

salir_script() {
    # Array de mensajes relacionados con CyberLand
    mensajes=(
        "👋 Nos vemos pronto, CyberLander. ¡El hacking nunca duerme! 🌌"
        "👾 ¡Hasta la próxima en CyberLand, donde las máquinas son nuestras aliadas! 🤖"
        "🔐 Recuerda: la seguridad es un viaje, no un destino. ¡Hasta pronto! 🚀"
        "🌐 ¡CyberLand te espera para el próximo desafío! ⚔️"
        "💻 ¡Adiós, CyberLander! Nos vemos en la próxima aventura digital. ✨"
        "🛡️ ¡CyberLand dice: nunca dejes de explorar y aprender! 🌟"
        "📡 La red es tu campo de batalla. ¡Nos vemos pronto en CyberLand! 🖥️"
        "⚙️ ¡CyberLand siempre estará listo para tus desafíos! Hasta luego. 🛠️"
    )

    # Seleccionar un mensaje aleatorio
    mensaje_aleatorio=${mensajes[$RANDOM % ${#mensajes[@]}]}

    # Mostrar el mensaje seleccionado
    echo -e "${LIGHT_RED}${mensaje_aleatorio}${RESET}"

    exit 0
}

menu_principal
