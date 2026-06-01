# 📊 Arquitectura Visual - Banquito Infra

## Flujo General del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Repository                            │
│                   banquito-infra                                │
└─────────────────────────────────────────────────────────────────┘
                           ↓
                    
        ┌─────────────────────────────────────┐
        │  GitHub Actions Workflows            │
        ├─────────────────────────────────────┤
        │  • deploy-core-back.yml             │
        │  • deploy-core-front.yml            │
        │  • deploy-switch-back.yml           │
        │  • deploy-switch-front.yml          │
        └─────────────────────────────────────┘
                           ↓
        
        ┌─────────────────────────────────────┐
        │  SSH a VM GCP                       │
        │  ├─ usuario: $GCP_VM_USER          │
        │  ├─ host: $GCP_VM_HOST             │
        │  └─ key: $GCP_SSH_KEY              │
        └─────────────────────────────────────┘
                           ↓
        
        ┌─────────────────────────────────────┐
        │  Ejecutar Scripts Bash              │
        │  bash scripts/deploy-core.sh [SVC]  │
        │  bash scripts/deploy-switch.sh [SVC]│
        └─────────────────────────────────────┘
                           ↓
        
        ┌─────────────────────────────────────┐
        │  Docker Compose                     │
        │  docker-compose pull                │
        │  docker-compose up -d               │
        └─────────────────────────────────────┘
                           ↓
        
    ┌───────────────────────────────────────────────┐
    │        SERVICIOS CORRIENDO EN VM              │
    └───────────────────────────────────────────────┘
```

## Topología de Red

```
                        ┌─────────────────────┐
                        │   Docker Network    │
                        │    "banquito"       │
                        │  (bridge network)   │
                        └─────────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
        
    ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
    │  CORE BACKEND    │   │ CORE FRONTEND    │   │ SWITCH BACKEND   │
    │   (Servicios)    │   │  (Servicios)     │   │   (Servicios)    │
    └──────────────────┘   └──────────────────┘   └──────────────────┘
    
    Puertos:                Puertos:              Puertos:
    • 8081 Ventanilla       • 3000 Banca Web      • 8086 Enrutamiento
    • 8082 Contable         • 3001 Ventanilla     • 8087 Facturación
    • 8083 Admin            Frontend              • 8088 Lotes
    • 8084 Clientes                              • 8089 Pagos Internos
    • 8085 Transaccional                         • 8091 Pagos Externos
    • 8090 API Gateway                           • 8080 API Gateway
    
        │                        │                        │
        └────────────────────────┼────────────────────────┘
                                 │
                    ┌────────────────────────┐
                    │      Nginx Proxy       │
                    │    (Reverse Proxy)     │
                    └────────────────────────┘
                    
                    Entrada: 0.0.0.0:80
                    
        ┌───────────────────────┬──────────────────┬─────────────────┐
        │                       │                  │                 │
        
    core-api.banquito.local  core-web.banquito.local  switch-api.banquito.local
           ↓                          ↓                      ↓
    localhost:8090          localhost:3000          localhost:8080
    (Core API Gateway)      (Banca Web Frontend)    (Switch API Gateway)
```

## Estructura de Directorios Detallada

```
banquito-infra/
│
├── 📁 .github/
│   └── 📁 workflows/
│       ├── deploy-core-back.yml       [30 líneas] SSH → bash scripts/deploy-core.sh
│       ├── deploy-core-front.yml      [30 líneas] SSH → bash scripts/deploy-core-front.sh
│       ├── deploy-switch-back.yml     [30 líneas] SSH → bash scripts/deploy-switch.sh
│       └── deploy-switch-front.yml    [30 líneas] SSH → bash scripts/deploy-switch-front.sh
│
├── 📁 docker/
│   │
│   ├── 📁 core/                       [Core Backend - 6 servicios]
│   │   ├── docker-compose.yml         [160 líneas]
│   │   └── .env                       [Variables de entorno]
│   │
│   ├── 📁 core-frontend/              [Core Frontend - 2 servicios]
│   │   ├── docker-compose.yml         [40 líneas]
│   │   └── .env                       [Variables React]
│   │
│   ├── 📁 switch/                     [Switch Backend - 6 servicios]
│   │   ├── docker-compose.yml         [200 líneas]
│   │   └── .env                       [Variables de entorno]
│   │
│   └── 📁 switch-frontend/            [Switch Frontend - 1 servicio]
│       ├── docker-compose.yml         [30 líneas]
│       └── .env                       [Variables React]
│
├── 📁 nginx/                          [Reverse Proxy Configuration]
│   ├── core.conf                      [75 líneas - 3 upstreams]
│   └── switch.conf                    [60 líneas - 2 upstreams]
│
├── 📁 scripts/                        [Deploy & Restart Scripts]
│   ├── deploy-core.sh                 [85 líneas - multiservicio]
│   ├── deploy-core-front.sh           [70 líneas - multiservicio]
│   ├── deploy-switch.sh               [85 líneas - multiservicio]
│   ├── deploy-switch-front.sh         [60 líneas - monobloque]
│   ├── restart-core.sh                [30 líneas]
│   └── restart-switch.sh              [30 líneas]
│
├── docker-compose.yml                 [Master Compose - 400+ líneas]
├── README.md                          [Documentación completa]
├── REFACTORIZACIÓN.md                 [Cambios y mejoras]
└── COMANDOS_RÁPIDOS.md                [Cheat sheet]
```

## Flujo de Deploy: Opción por Opción

### Opción 1: GitHub Actions

```
Developer
    ↓
Click "Actions" en GitHub
    ↓
Selecciona workflow: deploy-core-back.yml
    ↓
Click "Run workflow"
    ↓
Ingresa parámetro: "ventanilla" (o "all")
    ↓
appleboy/ssh-action inicia
    ↓
SSH a GCP_VM_HOST con GCP_SSH_KEY
    ↓
cd /home/GCP_VM_USER/banquito-infra
    ↓
bash scripts/deploy-core.sh "ventanilla"
    ↓
docker-compose pull core-ventanilla
    ↓
docker-compose up -d core-ventanilla
    ↓
docker-compose ps
    ↓
✅ SUCCESS / ❌ FAILED
```

### Opción 2: SSH Manual

```
Terminal Local
    ↓
ssh usuario@vm_host
    ↓
cd banquito-infra
    ↓
bash scripts/deploy-core.sh ventanilla
    ↓
[Mismo flujo que arriba]
```

### Opción 3: Docker Compose Directo

```
Terminal Local o en VM
    ↓
cd banquito-infra
    ↓
docker-compose up -d core-ventanilla
    ↓
Docker busca docker-compose.yml en directorio actual
    ↓
Lee configuración de servicios
    ↓
docker pull imagen
    ↓
docker run con configuración
    ↓
Contenedor inicia
```

## Dependencias Entre Servicios

### Core Backend Dependency Tree

```
core-api-gateway (8090)
    ├─ depends_on: core-ventanilla (8081)
    ├─ depends_on: core-contable (8082)
    ├─ depends_on: core-admin (8083)
    ├─ depends_on: core-clientes (8084)
    └─ depends_on: core-transaccional (8085)

Explicación:
El API Gateway no puede funcionar si los 
servicios downstream no están disponibles
```

### Switch Backend Dependency Tree

```
sw-api-gateway (8080)
    ├─ depends_on: sw-enrutamiento (8086)
    ├─ depends_on: sw-facturacion (8087)
    ├─ depends_on: sw-lotes (8088)
    ├─ depends_on: sw-pagos-internos (8089)
    └─ depends_on: sw-pagos-externos (8091)
```

## Mapeo de Puertos

```
CONTENEDOR                    PUERTO INTERNO    PUERTO HOST
──────────────────────────────────────────────────────────

Core Backend:
core-ventanilla              8081             :8081
core-contable                8082             :8082
core-admin                   8083             :8083
core-clientes                8084             :8084
core-transaccional           8085             :8085
core-api-gateway             8090             :8090

Core Frontend:
core-banca-web               3000             :3000
core-ventanilla-frontend     3000             :3001

Switch Backend:
sw-api-gateway               8080             :8080
sw-enrutamiento              8086             :8086
sw-facturacion               8087             :8087
sw-lotes                     8088             :8088
sw-pagos-internos            8089             :8089
sw-pagos-externos            8091             :8091

Switch Frontend:
sw-frontend                  3000             :3002
```

## Variables de Entorno y Secretos

### GitHub Secrets (Settings > Secrets and variables)

```
┌────────────────────────────────────────────────────────────┐
│               GITHUB SECRETS                               │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  GCP_VM_HOST          → IP o FQDN de la VM                │
│  GCP_VM_USER          → Usuario SSH (ej: ubuntu)          │
│  GCP_SSH_KEY          → -----BEGIN OPENSSH PRIVATE KEY    │
│  DOCKER_USERNAME      → Usuario Docker Hub                │
│  DOCKER_PASSWORD      → Token Docker Hub                  │
│  VM_HOST              → IP de VM frontend                 │
│  VM_USER              → Usuario SSH frontend              │
│  VM_SSH_KEY           → Private SSH key frontend          │
│                                                            │
└────────────────────────────────────────────────────────────┘
         ↓
    Usados en Workflows
         ↓
    ${{ secrets.GCP_VM_HOST }}
    ${{ secrets.GCP_SSH_KEY }}
    etc...
```

### .env Files (Local en VM)

```
docker/core/.env
├─ DOCKER_USERNAME
├─ SPRING_PROFILES_ACTIVE=prod
├─ DB_HOST
├─ DB_PORT
├─ DB_USER
└─ DB_PASSWORD

docker/core-frontend/.env
├─ NODE_ENV=production
└─ REACT_APP_API_URL=http://localhost:8090

docker/switch/.env
├─ DOCKER_USERNAME
├─ SPRING_PROFILES_ACTIVE=prod
└─ [Variables de Switch]

docker/switch-frontend/.env
├─ NODE_ENV=production
└─ REACT_APP_API_URL=http://localhost:8080
```

## Flujo de Logs

```
Docker Container
    ↓ (stdout)
docker logs
    ↓
docker-compose logs
    ↓
Usuario ve en terminal
    ↓
Opcional: Redirigido a archivo o agregador de logs
```

## Health Check Flow

```
Docker
    ├─ Inicia contenedor
    ├─ Ejecuta healthcheck cada 30s
    │   └─ curl -f http://localhost:PORT/actuator/health
    │
    ├─ Status:
    │   ├─ healthy      → Verde ✅
    │   ├─ unhealthy    → Rojo ❌
    │   └─ starting     → Amarillo ⚠️
    │
    └─ Si unhealthy X veces (retries=3)
       └─ Container se marca como "unhealthy"
```

## Ciclo de Vida de un Despliegue

```
1️⃣  TRIGGER
    └─ workflow_dispatch o repository_dispatch

2️⃣  PREPARACIÓN
    └─ SSH a VM
    └─ cd /home/user/banquito-infra

3️⃣  DESCARGA
    └─ docker-compose pull [SERVICE]

4️⃣  DEPLOY
    └─ docker-compose up -d [SERVICE]

5️⃣  INICIALIZACIÓN
    └─ Contenedor inicia
    └─ Aplicación carga

6️⃣  HEALTH CHECK
    └─ Cada 30s verifica /actuator/health
    └─ Si responde 200 → healthy

7️⃣  MONITOREO
    └─ Continúa verificando health
    └─ Si falla → puede reintentar o alertar

8️⃣  LISTO
    └─ ✅ Servicio disponible
```

## Capa de Abstracción

```
GitHub Actions (Usuarios)
    ↓ [Simple: Solo parameters]
    
Scripts Bash (Lógica de negocio)
    ├─ Validación
    ├─ Colorización
    ├─ Error handling
    └─ Health checks
    ↓ [Abstrae complejidad de docker-compose]
    
Docker Compose (Orquestación)
    ├─ Pull imágenes
    ├─ Crear redes
    ├─ Montar volúmenes
    └─ Iniciar contenedores
    ↓ [Abstrae CLI de docker]
    
Docker Engine (Runtime)
    ├─ Crear cgroups
    ├─ Aislar namespaces
    └─ Ejecutar procesos
```

---

**Última actualización:** 2026-05-31
**Versión:** 2.0
