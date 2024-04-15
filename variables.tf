variable "postgres_passwd" {
  description = "Similar ao subir um container postgres e usar -e POSTGRES_PASSWORD "
  type    = string
  default = "POSTGRES_PASSWORD=Senha23Mais1"
}

# Vars usadas no backend
variable "user_postgres" {
  type = string
  default = "postgres"
}

variable "string_passwd_postgres" {
  description = "Essa string vai ser passada pro backend"
  type    = string
  default = "Senha23Mais1"
}

variable "host_postgres" {
  type = string
  default = "postgres"
}

variable "port_postgres" {
  type = string
  default = "5432"
}

variable "port_backend" {
  type = string
  default = "3000"
}