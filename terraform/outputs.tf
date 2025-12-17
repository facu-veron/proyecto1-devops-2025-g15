#############################
# OUTPUTS DE TERRAFORM
#############################
# Los outputs permiten exponer información
# generada durante el `terraform apply`.
#
# Estos valores pueden ser:
# - Visualizados por consola
# - Consumidos por otros módulos
# - Usados por pipelines CI/CD
#############################

# --------------------------------------------------------------
# OUTPUT: NOMBRE DEL SERVICIO ECS
# --------------------------------------------------------------
# Expone el nombre del servicio ECS creado
# para la aplicación TODO API.
#
# Este output es útil para:
# - Verificación del despliegue
# - Debugging
# - Integraciones posteriores
# --------------------------------------------------------------

output "app_container_name" {
  value = aws_ecs_service.todo.name
}

# --------------------------------------------------------------

# Observaciones técnicas (NO aplicadas)

# Nombre del output poco representativo
#   El valor corresponde al nombre del ECS Service
#   No al nombre del contenedor
#   Puede generar confusión semántica

# --------------------------------------------
# Output no utilizado directamente

#   Actualmente no se consume en CI/CD
#   Podría usarse para validaciones post-deploy
#   o scripts de automatización

# --------------------------------------------------------------