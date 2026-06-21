#!/bin/bash

set -e

SERVICE="${1:-all}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW} Desplegando Banquito Switch Backend...${NC}"
echo -e "${YELLOW} Servicio: $SERVICE${NC}"

cd "$(dirname "$0")/../docker/switch"

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
        echo -e "${RED}❌ Error al tirar imagen: $svc${NC}"
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
        echo -e "${YELLOW} Desplegando TODOS los servicios Switch Backend...${NC}"
        docker compose pull
        docker compose up -d
        echo -e "${GREEN} Todos los servicios desplegados${NC}"
        ;;
    routing-service|banquito-sw-enrutamiento|enrutamiento)
        deploy_service "routing-service"
        ;;
    billing-service|banquito-sw-facturacion|facturacion)
        deploy_service "billing-service"
        ;;
    batch-service|banquito-sw-lotes|lotes)
        deploy_service "batch-service"
        ;;
    on-us-settlement-service|banquito-sw-pagos-internos|pagos-internos)
        deploy_service "on-us-settlement-service"
        ;;
    reporting-service|banquito-sw-reportes|reportes)
        deploy_service "reporting-service"
        ;;
    rabbitmq)
        deploy_service "rabbitmq"
        ;;
    sftp-service|sftp)
        deploy_service "sftp-service"
        ;;
    *)
        echo -e "${RED} Servicio no reconocido: $SERVICE${NC}"
        echo -e "${YELLOW}Servicios disponibles: all, routing-service (enrutamiento), billing-service (facturacion), batch-service (lotes), on-us-settlement-service (pagos-internos), reporting-service (reportes), rabbitmq, sftp-service (sftp)${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN} Despliegue completado${NC}"
echo -e "\n${YELLOW} Estado de contenedores:${NC}"
docker compose ps
