#############################
# CONFIGURACIÓN DE TERRAFORM Y PROVIDERS
#############################
# Este bloque define:
# - Qué providers requiere Terraform
# - Desde dónde se descargan
# - Qué versiones son compatibles
#############################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#############################
# VARIABLE: REGIÓN AWS
#############################
# Se define como variable para permitir:
# - Reutilización en distintos entornos
# - Inyección desde GitHub Actions
#############################
variable "aws_region" {
  type = string
}

#############################
# PROVIDER AWS
#############################
# Configura el provider de AWS usando
# la región pasada por variable.
#############################
provider "aws" {
  region = var.aws_region
}

#############################
# VARIABLE: IMAGEN DOCKER
#############################
# Recibe la URI completa de la imagen
# almacenada en Amazon ECR.
# Esta imagen es construida y pusheada
# previamente en el pipeline CI/CD.
#############################
variable "image" {
  description = "URI completa de la imagen Docker en ECR"
  type        = string
}

#############################
# RED: VPC POR DEFECTO + SUBNETS
# PROVIDER AWS
#############################
# En lugar de crear una VPC nueva,
# se reutiliza la VPC por defecto de AWS.
# Esto simplifica el despliegue para
# entornos de demo o académicos.
# Configura el provider de AWS usando
# la región pasada por variable.
#############################
data "aws_vpc" "default" {
  default = true
}

# Obtiene todas las subnets asociadas
# a la VPC por defecto
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#############################
# SECURITY GROUP
#############################
# Define las reglas de firewall para
# permitir tráfico hacia la aplicación.
#############################
resource "aws_security_group" "todo_sg" {
  name        = "todo-app-sg"
  description = "Allow HTTP to todo app"
  vpc_id      = data.aws_vpc.default.id

  # Permite tráfico entrante al puerto 3000
  # desde cualquier origen (HTTP API)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite todo el tráfico saliente
  # (necesario para que la app acceda a servicios externos)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################
# ECS FARGATE
#############################
# A partir de aquí se define toda la
# infraestructura necesaria para ejecutar
# la aplicación en ECS usando Fargate:
# - Cluster
# - Roles IAM
# - Task Definition
# - Service
#############################
resource "aws_ecs_cluster" "this" {
  name = "proyecto1-todo-cluster"
}

#############################
# ROL IAM PARA EJECUCIÓN DE TASKS
#############################
# Este rol permite que ECS:
# - Descargue imágenes desde ECR
# - Publique logs en CloudWatch
#############################
resource "aws_iam_role" "task_execution" {
  name = "todo-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#############################
# ASOCIACIÓN DE POLÍTICA AWS
#############################
# Se adjunta la política administrada
# necesaria para la ejecución de tareas ECS.
#############################
resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#############################
# DEFINICIÓN DE TASK ECS
#############################
# Define cómo se ejecuta el contenedor:
# - CPU y memoria
# - Imagen Docker
# - Puertos
#############################
resource "aws_ecs_task_definition" "todo" {
  family                   = "proyecto1-todo-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  # Rol de ejecución para la task
  execution_role_arn = aws_iam_role.task_execution.arn

  # Definición del contenedor
  container_definitions = jsonencode([
    {
      name      = "todo-app"
      image     = var.image
      essential = true
      # Mapeo de puertos del contenedor
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

#############################
# SERVICIO ECS
#############################
# Mantiene la aplicación corriendo:
# - Cantidad deseada de instancias
# - Configuración de red
#############################
resource "aws_ecs_service" "todo" {
  name            = "proyecto1-todo-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.todo.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Configuración de red para Fargate
  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.todo_sg.id]
    assign_public_ip = true
  }
}

#############################
# OUTPUTS
#############################
# Expone el nombre del servicio ECS
# al finalizar el apply.
#############################
output "ecs_service_name" {
  value = aws_ecs_service.todo.name
}


# --------------------------------------------------------------

# Observaciones técnicas (NO aplicadas)

# Security Group muy abierto
#   0.0.0.0/0 es correcto para demo
#   En producción:
#   Usar ALB
#   Restringir CIDR

# --------------------------------------------
# Sin Load Balancer

# ECS Service funciona, pero:
#   No hay health checks HTTP reales
#   No hay escalado automático
#   Correcto para el alcance del proyecto

# --------------------------------------------
# Sin logs definidos

#   No hay logConfiguration en el container
#   En producción se agregaría CloudWatch Logs

# --------------------------------------------
# Uso de VPC por defecto

#   Excelente para simplicidad
#   No recomendado en producción real

# --------------------------------------------
# Desired count fijo

#   No hay autoscaling
#   Correcto para entorno académico

# --------------------------------------------------------------