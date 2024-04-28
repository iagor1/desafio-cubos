variable "postgres_passwd" {
  description = "Similar ao subir um container postgres e usar -e POSTGRES_PASSWORD "
  type        = string
  default     = "passWD@3301"
}

# Vars usadas no backend
variable "user_postgres" {
  type    = string
  default = "postgres"
}

variable "host_postgres" {
  type    = string
  default = "postgres"
}

variable "port_postgres" {
  type    = string
  default = "5432"
}

variable "port_backend" {
  type    = string
  default = "3000"
}