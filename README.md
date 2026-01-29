
## Descripción General

Este proyecto despliega un stack completo de monitorización en AWS utilizando principios Terraform. El resultado es a una instancia EC2 ejecutando contenedores con Prometheus y Grafana.


## Arquitectura  diagram

<img width="1635" height="1686" alt="Untitled-2026-01-29-2200" src="https://github.com/user-attachments/assets/ba1997a3-247e-4c3f-8de7-1c7e9623ec98" />
---

## Estructura del Proyecto

```
challenge_cloudadmin/
├── .circleci/
│   └── config.yml               
├── docker/
│   ├── docker-compose.yml         
│   └── prometheus.yml             
├── infra-aws/
│   └── terraform/
│       ├── environments/
│       │   ├── dev/
│       │   │   ├── backend.tf     
│       │   │   ├── dev.tfvars     
│       │   │   ├── main.tf        
│       │   │   ├── outputs.tf     
│       │   │   ├── provider.tf    
│       │   │   └── variables.tf  
│       │   └── prod/
│       │       ├── backend.tf
│       │       ├── prod.tfvars
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       ├── provider.tf
│       │       └── variables.tf
│       ├── modules/
│       │   ├── compute/
│       │   │   ├── data.tf        
│       │   │   ├── main.tf        
│       │   │   ├── outputs.tf
│       │   │   ├── scripts/
│       │   │   │   └── userdata.sh 
│       │   │   └── variables.tf
│       │   └── network/
│       │       ├── main.tf 
│       │       ├── outputs.tf
│       │       └── variables.tf
│       └── terraform.tf
├── .gitignore
└── README.md
```

---

## Decisiones Técnicas


### Tipo de Instancia: t3.micro

**Decisión**: t3.micro 

**Justificación**: Tier mas barata y suficiente para el proyecto de prueba

###  Terraform architecture
# Environments:
-  Dev y Prod: Separe por entornos para aislar los recursos y definir la variable env_01 que se modifica segun dicho entorno. 
La ejecucion del terraform apply se debe hacer con las tfvars correspondientes de cada entorno.

```
│       ├── environments/
│       │   ├── dev/
│       │   │   ├── backend.tf     
│       │   │   ├── dev.tfvars     
│       │   │   ├── main.tf        
│       │   │   ├── outputs.tf     
│       │   │   ├── provider.tf    
│       │   │   └── variables.tf  
│       │   └── prod/
│       │       ├── backend.tf
│       │       ├── prod.tfvars
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       ├── provider.tf
│       │       └── variables.tf
```
# Modules:
```
│       ├── modules/
│       │   ├── compute/
│       │   │   ├── data.tf        
│       │   │   ├── main.tf        
│       │   │   ├── outputs.tf
│       │   │   ├── scripts/
│       │   │   │   └── userdata.sh 
│       │   │   └── variables.tf
│       │   └── network/
│       │       ├── main.tf 
│       │       ├── outputs.tf
│       │       └── variables.tf
```
Se han implementado dos modulos
- Network: Definimos la logica de red basica con una public subnet, un sg estos se implementaron en outputs.tf por la dependencia que tendra con el siguiente modulo de compute
- Compute: 
  - data.tf: Definicion de todos los metadatos del tipo de ami a utilizar en este caso Ubuntu22.04:latest.
  - main.tf: Definicion de las variables basicas necesarias entre las que destacan la key_pair (generada manualmente en aws) tambien se define la logica con resources para poder tener conectividad a secrets manager desde la EC2.
  - outputs.tf: Se definio el id de la instancia y su ip publica ya que son necesarios para implementar en la logica de cicd

###  Docker architecture

**Decisión**: Docker Compose 

**Justificación**:
 Simplicidad y facil conectividad con red interna propia de docker para prometheus y grafana

### Plataforma CI/CD: CircleCI

**Decisión**: CircleCI

**Justificación**: Intuitivo y facil integracion con github


###  Arquitectura de Red: Subnet Pública Única

Subnet pública con Internet Gateway
Security group para permitir la carga de trabajo con prometheus, grafana y la conectividad ssh de circleCI
RT definido para la logica de conectividad necesaria para la subnet publica con el igw

---

## Prerrequisitos

### Requisitos Locales para testeo manual

- AWS CLI v2
- Terraform
- Git
- IDE
- Config AWS Credentials / SSO profile

### Requisitos en AWS (manuales)

**Usuario/Rol IAM CircleCI**
    En mi caso lo añadi al grupo de Administrators para pruebas rapidas

**Secrets Manager** para credenciales de Grafana, en este caso se añadieron manualmente

### Requisitos en CircleCI

Configurar las siguientes variables de entorno en la configuración del proyecto en CircleCI:
`AWS_ACCESS_KEY_ID` Access key de AWS para Terraform 
`AWS_SECRET_ACCESS_KEY` Secret key de AWS para Terraform 
`AWS_DEFAULT_REGION` Región AWS (ej: `eu-west-1`)
`SSH_PRIVATE_KEY`  Clave privada SSH codificada en Base64 para acceso EC2 

Nota: Se genero un usuario IAM con permisos de Administrator para los lanzamientos de pipelines


**Para codificar la clave SSH para CircleCI**:
Desde local
```bash
base64 -w 0 monitoring-key.pem
```

---

## Configuración

### Variables de Terraform

Editar `infra-aws/terraform/environments/"tu_environment"/"tu_environment".tfvars`:

```hcl
# Entorno
env_01 = ""tu_environment""

# Red
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"

# Cómputo
instance_type = "t3.micro"
key_pair_name = "monitoring-key"
```

### Configuración de Prometheus

En este caso se hizo una configuracion sencilla para poder tener un target del propio node exporte y obtener metricas de la EC2 y de prometheus

Editar `docker/prometheus.yml`

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

---

## Despliegue

### Opción 1: Despliegue Automatizado vía CircleCI

1. Hacer push de cambios al repositorio
2. CircleCI dispara automáticamente el pipeline si tienes configurado el trigger (esta por defecto)
3. Pipeline steps:
   - **terraform-deploy**: Aprovisiona la infraestructura AWS
   - **deploy-app**: Despliega contenedores Docker vía SSH y su respectiva config
   - **approve-destroy**: Step de aprobación manual en este caso se comprueba que los contenedores de prometheus y grafana sean accesibles desde el browser y se hacen pruebas manuales implementando los dashboards (explicado mas abajo)
   - **terraform-destroy**: Destruye la infraestructura (después de aprobación manual)

### Opción 2: Despliegue Manual
1. Aqui podemos hacer todo el proceso de workflow de terraform desde local en caso de necesitar hacer pruebas o implementar mejoras rapidas sin pasar por CircleCI.

```bash
cd infra-aws/terraform/environments/dev

terraform init

terraform plan -var-file="dev.tfvars"

terraform apply -var-file="dev.tfvars"
```

2.  Desplegar Contenedores copiando la config necesaria a la instancia ec2, a tener en cuenta que se debe harcodear el valor de usuario por defecto para grafana o en caso contrario definir el que tu quieras.
```bash
scp -i ~/.ssh/monitoring-key.pem docker/docker-compose.yml ubuntu@$EC2_IP:/home/ubuntu/monitoring/
scp -i ~/.ssh/monitoring-key.pem docker/prometheus.yml ubuntu@$EC2_IP:/home/ubuntu/monitoring/
```

3.  Conectar por SSH y desplegar contenedores
```bash
ssh -i ~/.ssh/monitoring-key.pem ubuntu@$EC2_IP 
```
4. Obtener credenciales de Secrets Manager
```bash
  cd /home/ubuntu/monitoring
  docker compose up -d
```

#### Paso 3: Destruir Infraestructura (al finalizar)

```bash
cd infra-aws/terraform/environments/dev
terraform destroy -var-file="dev.tfvars"
```

---

## Acceso a los Servicios

Despues del despliegue acceder a los servicios usando la IP publica del EC2:

**Grafana** `http://<EC2_IP>:3000`  
**Prometheus** `http://<EC2_IP>:9090` (Sin autenticación)

---

## Métricas y Dashboards

### Configuración de Grafana

1. **Iniciar sesión en Grafana** en `http://<EC2_IP>:3000`
   - Usuario/Contraseña: Si es manual el usuario por defecto configurado o por CICD se inyectan de Secrets Manager

2. **Añadir Prometheus como Data Source**:
   - Navegar a: Configuration > Data Sources > Add data source
   - Seleccionar: Prometheus
   - URL: `http://prometheus:9090`
   - Click en: Save & Test

3. **Importar Dashboard de Node Exporter**:
   - Navegar a: Dashboards > Import
   - Dashboard ID: `1860` ([Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/))
   - Seleccionar data source: Prometheus
   - Clic en: Import

### Métricas Disponibles

Node Exporter recolecta métricas completas del sistema incluyendo:


**CPU** `node_cpu_seconds_total`, `node_load1` 
**Memoria**  `node_memory_MemTotal_bytes`, `node_memory_MemAvailable_bytes` 
**Disco** `node_filesystem_size_bytes`, `node_disk_io_time_seconds_total` 
**Red**  `node_network_receive_bytes_total`, `node_network_transmit_bytes_total` 

### Probar Prometheus

Acceder a Prometheus en `http://<EC2_IP>:9090` y probar esta query de ejemplo:

```promql
# Tasa de tiempo idle de CPU
rate(node_cpu_seconds_total{mode="idle"}[1m])
```

---


## Deuda tecnica/mejoras

 # Terraform
- mas validation conditions en recursos para evitar desplegar lo que no corresponde
- Outputs de logs de apply para posibles troubleshootings erros
- Secrets Manager module implementation
- Input request para la ip publica a implementar el acceso ssh en el sg de la ec2 o implementar solucion nativa mas robusta de aws (SSM)
- Lintern para detectar errrores , sintaxis obsoleta…
- Destroy automatico si la pipeline falla

# Code repository
- readme por cada carpeta para desengranar mejor las explicaciones y no tener solo un readme general
- Changelog para control de los cambios de versiones
- tag version release
- Naming convention estandarizado e intuitivo de commits messages y ramas

# EC2 Instance
- Security compliance (hardening)
- gp2 to gp3 volume type
- Cambiar ec2 ami amazon linux 2023 ya que tiene awscli nativo
- Asociar VPC Endpoint para acceder a Secrets manager


# Docker 
  - Mejoras en compliance de seguridad (permisos root, posible mejoras en la conectividad de red, cambios de puertos default a mas robustos)
  - desharcodear environment dev, prod y meterlo por variable

# Prometheus & grafana
   - cAdvisor para monitorizacion especifica del rendimiento dentro de los contenedores
   - Automatizacion de los dashboards de grafana para evitar la implemnetacion manual desde el frontend

# CircleCI
   - Implementacion de Orbs
   - IAM User con permisos mas restrictivos
   - Permisos ssh circleCI identificar workaround para evitar acceso a todos por ssh a la ec2
   - Añadir control de errores robusto
   - Sustituir sleeps por algo mas eficiente
   - Reducir tiempo eliminando Sleeps
   - Docker images mas ligeros para mejor performance de pipeline