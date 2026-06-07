#!/bin/bash

set -e

SERVICE="${1:-all}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW} Desplegando Banquito Core Backend...${NC}"
echo -e "${YELLOW} Servicio: $SERVICE${NC}"

cd "$(dirname "$0")/../docker/core"

# Validar que docker y docker compose existan
if ! command -v docker &> /dev/null; then
    echo -e "${RED} Docker no está instalado${NC}"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo -e "${RED} Docker Compose no está instalado${NC}"
    exit 1
fi

# Función para desplegar servicio específico
deploy_service() {
    local svc=$1
    echo -e "${YELLOW} Tirando imagen: $svc${NC}"
    docker compose pull "$svc" || {
        echo -e "${RED} Error al tirar imagen: $svc${NC}"
        return 1
    }
    
    echo -e "${YELLOW} Reiniciando contenedor: $svc${NC}"
    docker compose up -d "$svc" || {
        echo -e "${RED} Error al iniciar contenedor: $svc${NC}"
        return 1
    }
    
    echo -e "${GREEN} $svc desplegado exitosamente${NC}"
}

# Desplegar según servicio
case "$SERVICE" in
    all)
        echo -e "${YELLOW} Desplegando TODOS los servicios Core Backend...${NC}"
        docker compose pull
        docker compose up -d
        echo -e "${GREEN} Todos los servicios desplegados${NC}"
        ;;
    banquito-core-contable|contable)
        deploy_service "banquito-core-contable"
        ;;
    banquito-core-admin|admin)
        deploy_service "banquito-core-admin"
        ;;
    banquito-core-clientes|clientes)
        deploy_service "banquito-core-clientes"
        ;;
    banquito-core-transaccional|transaccional)
        deploy_service "banquito-core-transaccional"
        ;;
    banquito-core-notificacion|notificacion)
        deploy_service "banquito-core-notificacion"
        ;;
    banquito-core-seguridad|seguridad)
        deploy_service "banquito-core-seguridad"
        ;;
    banquito-core-documentos|documentos)
        deploy_service "banquito-core-documentos"
        ;;
    *)
        echo -e "${RED} Servicio no reconocido: $SERVICE${NC}"
        echo -e "${YELLOW}Servicios disponibles: all, contable, admin, clientes, transaccional, notificacion, seguridad, documentos${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN} Despliegue completado${NC}"
echo -e "\n${YELLOW} Estado de contenedores:${NC}"
docker compose ps
