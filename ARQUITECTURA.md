# ðŸ“Š Arquitectura Visual - Banquito Infra

## Flujo General del Sistema

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                    GitHub Repository                            â”‚
â”‚                   banquito-infra                                â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â†“
                    
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚  GitHub Actions Workflows            â”‚
        â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
        â”‚  â€¢ deploy-core-back.yml             â”‚
        â”‚  â€¢ deploy-core-front.yml            â”‚
        â”‚  â€¢ deploy-switch-back.yml           â”‚
        â”‚  â€¢ deploy-switch-front.yml          â”‚
        â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â†“
        
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚  SSH a VM GCP                       â”‚
        â”‚  â”œâ”€ usuario: $GCP_VM_USER          â”‚
        â”‚  â”œâ”€ host: $GCP_VM_HOST             â”‚
        â”‚  â””â”€ key: $GCP_SSH_KEY              â”‚
        â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â†“
        
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚  Ejecutar Scripts Bash              â”‚
        â”‚  bash scripts/deploy-core.sh [SVC]  â”‚
        â”‚  bash scripts/deploy-switch.sh [SVC]â”‚
        â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â†“
        
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚  Docker Compose                     â”‚
        â”‚  docker-compose pull                â”‚
        â”‚  docker-compose up -d               â”‚
        â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â†“
        
    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
    â”‚        SERVICIOS CORRIENDO EN VM              â”‚
    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## TopologÃ­a de Red

```
                        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                        â”‚   Docker Network    â”‚
                        â”‚    "banquito"       â”‚
                        â”‚  (bridge network)   â”‚
                        â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                                 â”‚
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚                        â”‚                        â”‚
        
    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
    â”‚  CORE BACKEND    â”‚   â”‚ CORE FRONTEND    â”‚   â”‚ SWITCH BACKEND   â”‚
    â”‚   (Servicios)    â”‚   â”‚  (Servicios)     â”‚   â”‚   (Servicios)    â”‚
    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
    
    Puertos:                Puertos:              Puertos:
    â€¢ 8081 Ventanilla       â€¢ 3000 Banca Web      â€¢ 8086 Enrutamiento
    â€¢ 8082 Contable         â€¢ 3001 Ventanilla     â€¢ 8087 FacturaciÃ³n
    â€¢ 8083 Admin            Frontend              â€¢ 8088 Lotes
    â€¢ 8084 Clientes                              â€¢ 8089 Pagos Internos
    â€¢ 8085 Transaccional                         â€¢ 8091 Pagos Externos
    â€¢ 8090 API Gateway                           â€¢ 8080 API Gateway
    
        â”‚                        â”‚                        â”‚
        â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                                 â”‚
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚      Nginx Proxy       â”‚
                    â”‚    (Reverse Proxy)     â”‚
                    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                    
                    Entrada: 0.0.0.0:80
                    
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚                       â”‚                  â”‚                 â”‚
        
    core-api.banquito.local  core-web.banquito.local  switch-api.banquito.local
           â†“                          â†“                      â†“
    localhost:8090          localhost:3000          localhost:8080
    (Core API Gateway)      (Banca Web Frontend)    (Switch API Gateway)
```

## Estructura de Directorios Detallada

```
banquito-infra/
â”‚
â”œâ”€â”€ ðŸ“ .github/
â”‚   â””â”€â”€ ðŸ“ workflows/
â”‚       â”œâ”€â”€ deploy-core-back.yml       [30 lÃ­neas] SSH â†’ bash scripts/deploy-core.sh
â”‚       â”œâ”€â”€ deploy-core-front.yml      [30 lÃ­neas] SSH â†’ bash scripts/deploy-core-front.sh
â”‚       â”œâ”€â”€ deploy-switch-back.yml     [30 lÃ­neas] SSH â†’ bash scripts/deploy-switch.sh
â”‚       â””â”€â”€ deploy-switch-front.yml    [30 lÃ­neas] SSH â†’ bash scripts/deploy-switch-front.sh
â”‚
â”œâ”€â”€ ðŸ“ docker/
â”‚   â”‚
â”‚   â”œâ”€â”€ ðŸ“ core/                       [Core Backend - 6 servicios]
â”‚   â”‚   â”œâ”€â”€ docker-compose.yml         [160 lÃ­neas]
â”‚   â”‚   â””â”€â”€ .env                       [Variables de entorno]
â”‚   â”‚
â”‚   â”œâ”€â”€ ðŸ“ core-frontend/              [Core Frontend - 2 servicios]
â”‚   â”‚   â”œâ”€â”€ docker-compose.yml         [40 lÃ­neas]
â”‚   â”‚   â””â”€â”€ .env                       [Variables React]
â”‚   â”‚
â”‚   â”œâ”€â”€ ðŸ“ switch/                     [Switch Backend - 6 servicios]
â”‚   â”‚   â”œâ”€â”€ docker-compose.yml         [200 lÃ­neas]
â”‚   â”‚   â””â”€â”€ .env                       [Variables de entorno]
â”‚   â”‚
â”‚   â””â”€â”€ ðŸ“ switch-frontend/            [Switch Frontend - 1 servicio]
â”‚       â”œâ”€â”€ docker-compose.yml         [30 lÃ­neas]
â”‚       â””â”€â”€ .env                       [Variables React]
â”‚
â”œâ”€â”€ ðŸ“ nginx/                          [Reverse Proxy Configuration]
â”‚   â”œâ”€â”€ core.conf                      [75 lÃ­neas - 3 upstreams]
â”‚   â””â”€â”€ switch.conf                    [60 lÃ­neas - 2 upstreams]
â”‚
â”œâ”€â”€ ðŸ“ scripts/                        [Deploy & Restart Scripts]
â”‚   â”œâ”€â”€ deploy-core.sh                 [85 lÃ­neas - multiservicio]
â”‚   â”œâ”€â”€ deploy-core-front.sh           [70 lÃ­neas - multiservicio]
â”‚   â”œâ”€â”€ deploy-switch.sh               [85 lÃ­neas - multiservicio]
â”‚   â”œâ”€â”€ deploy-switch-front.sh         [60 lÃ­neas - monobloque]
â”‚   â”œâ”€â”€ restart-core.sh                [30 lÃ­neas]
â”‚   â””â”€â”€ restart-switch.sh              [30 lÃ­neas]
â”‚
â”œâ”€â”€ docker-compose.yml                 [Master Compose - 400+ lÃ­neas]
â”œâ”€â”€ README.md                          [DocumentaciÃ³n completa]
â”œâ”€â”€ REFACTORIZACIÃ“N.md                 [Cambios y mejoras]
â””â”€â”€ COMANDOS_RÃPIDOS.md                [Cheat sheet]
```

## Flujo de Deploy: OpciÃ³n por OpciÃ³n

### OpciÃ³n 1: GitHub Actions

```
Developer
    â†“
Click "Actions" en GitHub
    â†“
Selecciona workflow: deploy-core-back.yml
    â†“
Click "Run workflow"
    â†“
Ingresa parÃ¡metro: "contable" (o "all")
    â†“
appleboy/ssh-action inicia
    â†“
SSH a GCP_VM_HOST con GCP_SSH_KEY
    â†“
cd /home/GCP_VM_USER/banquito-infra
    â†“
bash scripts/deploy-core.sh "contable"
    â†“
docker-compose pull core-contable
    â†“
docker-compose up -d core-contable
    â†“
docker-compose ps
    â†“
âœ… SUCCESS / âŒ FAILED
```

### OpciÃ³n 2: SSH Manual

```
Terminal Local
    â†“
ssh usuario@vm_host
    â†“
cd banquito-infra
    â†“
bash scripts/deploy-core.sh ventanilla
    â†“
[Mismo flujo que arriba]
```

### OpciÃ³n 3: Docker Compose Directo

```
Terminal Local o en VM
    â†“
cd banquito-infra
    â†“
docker-compose up -d core-contable
    â†“
Docker busca docker-compose.yml en directorio actual
    â†“
Lee configuraciÃ³n de servicios
    â†“
docker pull imagen
    â†“
docker run con configuraciÃ³n
    â†“
Contenedor inicia
```

## Dependencias Entre Servicios

### Core Backend Dependency Tree

```
core-api-gateway (8090)
    â”œâ”€ depends_on: core-ventanilla (8081)
    â”œâ”€ depends_on: core-contable (8082)
    â”œâ”€ depends_on: core-admin (8083)
    â”œâ”€ depends_on: core-clientes (8084)
    â””â”€ depends_on: core-transaccional (8085)

ExplicaciÃ³n:
El API Gateway no puede funcionar si los 
servicios downstream no estÃ¡n disponibles
```

### Switch Backend Dependency Tree

```
sw-api-gateway (8080)
    â”œâ”€ depends_on: sw-enrutamiento (8086)
    â”œâ”€ depends_on: sw-facturacion (8087)
    â”œâ”€ depends_on: sw-lotes (8088)
    â”œâ”€ depends_on: sw-pagos-internos (8089)
    â””â”€ depends_on: sw-pagos-externos (8091)
```

## Mapeo de Puertos

```
CONTENEDOR                    PUERTO INTERNO    PUERTO HOST
â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

Core Backend:
core-contable                8007             :8007
core-admin                   8008             :8008
core-clientes                8009             :8009
core-transaccional           8010             :8010
core-notificacion            8011             :8011
core-seguridad               8012             :8012
core-documentos              8013             :8013

Core Frontend:
core-banca-web               3000             :3000
core-ventanilla-frontend     3000             :3001

Switch Backend:
sw-enrutamiento              8014             :8014
sw-facturacion               8015             :8015
sw-lotes                     8016             :8016
sw-pagos-internos            8017             :8017
sw-pagos-externos            8018             :8018
sw-reportes                  8019             :8019

Switch Frontend:
sw-frontend                  3000             :3002
```

## Variables de Entorno y Secretos

### GitHub Secrets (Settings > Secrets and variables)

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚               GITHUB SECRETS                               â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                            â”‚
â”‚  GCP_VM_HOST          â†’ IP o FQDN de la VM                â”‚
â”‚  GCP_VM_USER          â†’ Usuario SSH (ej: ubuntu)          â”‚
â”‚  GCP_SSH_KEY          â†’ -----BEGIN OPENSSH PRIVATE KEY    â”‚
â”‚  DOCKER_USERNAME      â†’ Usuario Docker Hub                â”‚
â”‚  DOCKER_PASSWORD      â†’ Token Docker Hub                  â”‚
â”‚  VM_HOST              â†’ IP de VM frontend                 â”‚
â”‚  VM_USER              â†’ Usuario SSH frontend              â”‚
â”‚  VM_SSH_KEY           â†’ Private SSH key frontend          â”‚
â”‚                                                            â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
         â†“
    Usados en Workflows
         â†“
    ${{ secrets.GCP_VM_HOST }}
    ${{ secrets.GCP_SSH_KEY }}
    etc...
```

### .env Files (Local en VM)

```
docker/core/.env
â”œâ”€ DOCKER_USERNAME
â”œâ”€ SPRING_PROFILES_ACTIVE=prod
â”œâ”€ DB_HOST
â”œâ”€ DB_PORT
â”œâ”€ DB_USER
â””â”€ DB_PASSWORD

docker/core-frontend/.env
â”œâ”€ NODE_ENV=production
â””â”€ REACT_APP_API_URL=http://localhost:8007

docker/switch/.env
â”œâ”€ DOCKER_USERNAME
â”œâ”€ SPRING_PROFILES_ACTIVE=prod
â””â”€ [Variables de Switch]

docker/switch-frontend/.env
â”œâ”€ NODE_ENV=production
â””â”€ REACT_APP_API_URL=http://localhost:8014
```

## Flujo de Logs

```
Docker Container
    â†“ (stdout)
docker logs
    â†“
docker-compose logs
    â†“
Usuario ve en terminal
    â†“
Opcional: Redirigido a archivo o agregador de logs
```

## Health Check Flow

```
Docker
    â”œâ”€ Inicia contenedor
    â”œâ”€ Ejecuta healthcheck cada 30s
    â”‚   â””â”€ curl -f http://localhost:PORT/actuator/health
    â”‚
    â”œâ”€ Status:
    â”‚   â”œâ”€ healthy      â†’ Verde âœ…
    â”‚   â”œâ”€ unhealthy    â†’ Rojo âŒ
    â”‚   â””â”€ starting     â†’ Amarillo âš ï¸
    â”‚
    â””â”€ Si unhealthy X veces (retries=3)
       â””â”€ Container se marca como "unhealthy"
```

## Ciclo de Vida de un Despliegue

```
1ï¸âƒ£  TRIGGER
    â””â”€ workflow_dispatch o repository_dispatch

2ï¸âƒ£  PREPARACIÃ“N
    â””â”€ SSH a VM
    â””â”€ cd /home/user/banquito-infra

3ï¸âƒ£  DESCARGA
    â””â”€ docker-compose pull [SERVICE]

4ï¸âƒ£  DEPLOY
    â””â”€ docker-compose up -d [SERVICE]

5ï¸âƒ£  INICIALIZACIÃ“N
    â””â”€ Contenedor inicia
    â””â”€ AplicaciÃ³n carga

6ï¸âƒ£  HEALTH CHECK
    â””â”€ Cada 30s verifica /actuator/health
    â””â”€ Si responde 200 â†’ healthy

7ï¸âƒ£  MONITOREO
    â””â”€ ContinÃºa verificando health
    â””â”€ Si falla â†’ puede reintentar o alertar

8ï¸âƒ£  LISTO
    â””â”€ âœ… Servicio disponible
```

## Capa de AbstracciÃ³n

```
GitHub Actions (Usuarios)
    â†“ [Simple: Solo parameters]
    
Scripts Bash (LÃ³gica de negocio)
    â”œâ”€ ValidaciÃ³n
    â”œâ”€ ColorizaciÃ³n
    â”œâ”€ Error handling
    â””â”€ Health checks
    â†“ [Abstrae complejidad de docker-compose]
    
Docker Compose (OrquestaciÃ³n)
    â”œâ”€ Pull imÃ¡genes
    â”œâ”€ Crear redes
    â”œâ”€ Montar volÃºmenes
    â””â”€ Iniciar contenedores
    â†“ [Abstrae CLI de docker]
    
Docker Engine (Runtime)
    â”œâ”€ Crear cgroups
    â”œâ”€ Aislar namespaces
    â””â”€ Ejecutar procesos
```

---

**Ãšltima actualizaciÃ³n:** 2026-05-31
**VersiÃ³n:** 2.0
