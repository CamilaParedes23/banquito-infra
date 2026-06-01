# 🤖 Guía de CD Automático (Deploy on Push)

Como la infraestructura ya está preparada para recibir "webhooks" (a través de `repository_dispatch`), **no necesitas modificar los archivos en `banquito-infra`**. 

Solo necesitas configurar los repositorios de tus microservicios (por ejemplo, el repositorio de `core-ventanilla`) para que avisen a `banquito-infra` cuando suban una nueva imagen a Docker Hub.

Sigue estos 2 pasos:

## Paso 1: Crear un Token de Acceso

GitHub requiere permisos para que un repositorio pueda "llamar" a otro.

1. Ve a tus **GitHub Settings** > **Developer settings** > **Personal access tokens** > **Tokens (classic)**
2. Click en **Generate new token (classic)**
3. Dale un nombre (ej: `INFRA_DISPATCH_TOKEN`)
4. Selecciona el scope **`repo`** (Full control of private repositories)
5. Genera el token y **cópialo**.
6. Ve a tu repositorio del microservicio (ej: `banquito/core-ventanilla`)
7. Ve a **Settings > Secrets and variables > Actions > New repository secret**
8. Nombre: `INFRA_DISPATCH_TOKEN`, Valor: *El token que copiaste*

*(Alternativamente, puedes poner este secreto a nivel de Organización para que todos los repos lo tengan automáticamente).*

## Paso 2: Agregar el paso al Workflow de cada Microservicio

En el pipeline de GitHub Actions de **cada microservicio** (ej: en `.github/workflows/build-and-push.yml` de `core-ventanilla`), justo **después** de hacer el `docker push`, agrega este paso:

### Ejemplo para un servicio de CORE BACKEND (ej: core-ventanilla)

```yaml
      # ... (Tus pasos anteriores: build y docker push) ...

      - name: 🚀 Disparar Deploy Automático en banquito-infra
        uses: peter-evans/repository-dispatch@v2
        with:
          token: ${{ secrets.INFRA_DISPATCH_TOKEN }}
          repository: banquito/banquito-infra   # ← Cambia 'banquito' por tu usuario/org si es diferente
          event-type: deploy-core-back          # ← IMPORTANTE: Este es el evento para Core Backend
          client-payload: '{"service": "ventanilla"}' # ← IMPORTANTE: El nombre del servicio a desplegar
```

### Tabla de Eventos y Payloads

Según el microservicio que estés configurando, cambia el `event-type` y el `service` en el `client-payload`:

| Repositorio / Servicio | `event-type` (El Workflow a llamar) | `client-payload` (El Servicio a reiniciar) |
|------------------------|-------------------------------------|-------------------------------------------|
| **Core Backend** | | |
| core-ventanilla | `deploy-core-back` | `{"service": "ventanilla"}` |
| core-contable | `deploy-core-back` | `{"service": "contable"}` |
| core-admin | `deploy-core-back` | `{"service": "admin"}` |
| core-clientes | `deploy-core-back` | `{"service": "clientes"}` |
| core-transaccional | `deploy-core-back` | `{"service": "transaccional"}` |
| core-api-gateway | `deploy-core-back` | `{"service": "api-gateway"}` |
| **Core Frontend** | | |
| core-banca-web | `deploy-core-front` | `{"service": "banca-web"}` |
| core-ventanilla-frontend| `deploy-core-front` | `{"service": "ventanilla-frontend"}`|
| **Switch Backend** | | |
| sw-enrutamiento | `deploy-switch-back` | `{"service": "enrutamiento"}` |
| sw-facturacion | `deploy-switch-back` | `{"service": "facturacion"}` |
| sw-lotes | `deploy-switch-back` | `{"service": "lotes"}` |
| sw-pagos-internos | `deploy-switch-back` | `{"service": "pagos-internos"}` |
| sw-pagos-externos | `deploy-switch-back` | `{"service": "pagos-externos"}` |
| sw-api-gateway | `deploy-switch-back` | `{"service": "api-gateway"}` |
| **Switch Frontend** | | |
| sw-frontend | `deploy-switch-front`| `{"service": "sw-frontend"}` |

---

### ¿Cómo funciona la magia? 🧙‍♂️

1. El CI de `core-ventanilla` construye la imagen de Java.
2. Hace `docker push banquito/core-ventanilla:latest` a Docker Hub.
3. El plugin de `repository-dispatch` envía una señal oculta a `banquito/banquito-infra`.
4. El workflow `deploy-core-back.yml` recibe la señal, detecta que dice `"service": "ventanilla"`.
5. GitHub Actions entra por SSH a tu VM y ejecuta automáticamente:
   `bash scripts/deploy-core.sh ventanilla`
6. El script hace `docker-compose pull core-ventanilla` y lo reinicia.
7. **¡Boom! Despliegue completado automáticamente tras cada commit en main.** Sin que tú muevas un dedo. 🚀