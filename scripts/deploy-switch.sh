#!/bin/bash

set -e

SERVICE="${1:-all}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Desplegando Banquito Switch Backend...${NC}"
echo -e "${YELLOW}📦 Servicio: $SERVICE${NC}"

cd "$(dirname "$0")/../docker/switch"

# Validar que docker y docker-compose existan
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado${NC}"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose no está instalado${NC}"
    exit 1
fi

# Función para desplegar servicio específico
deploy_service() {
    local svc=$1
    echo -e "${YELLOW}📥 Tirando imagen: $svc${NC}"
    docker-compose pull "$svc" || {
        echo -e "${RED}❌ Error al tirar imagen: $svc${NC}"
        return 1
    }
    
    echo -e "${YELLOW}🔄 Reiniciando contenedor: $svc${NC}"
    docker-compose up -d "$svc" || {
        echo -e "${RED}❌ Error al iniciar contenedor: $svc${NC}"
        return 1
    }
    
    echo -e "${GREEN}✅ $svc desplegado exitosamente${NC}"
}

# Desplegar según servicio
case "$SERVICE" in
    all)
        echo -e "${YELLOW}📋 Desplegando TODOS los servicios Switch Backend...${NC}"
        docker-compose pull
        docker-compose up -d
        echo -e "${GREEN}✅ Todos los servicios desplegados${NC}"
        ;;
    enrutamiento)
        deploy_service "sw-enrutamiento"
        ;;
    facturacion)
        deploy_service "sw-facturacion"
        ;;
    lotes)
        deploy_service "sw-lotes"
        ;;
    pagos-internos)
        deploy_service "sw-pagos-internos"
        ;;
    pagos-externos)
        deploy_service "sw-pagos-externos"
        ;;
    api-gateway)
        deploy_service "sw-api-gateway"
        ;;
    *)
        echo -e "${RED}❌ Servicio no reconocido: $SERVICE${NC}"
        echo -e "${YELLOW}Servicios disponibles: all, enrutamiento, facturacion, lotes, pagos-internos, pagos-externos, api-gateway${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✅ Despliegue completado${NC}"
echo -e "\n${YELLOW}📋 Estado de contenedores:${NC}"
docker-compose ps
