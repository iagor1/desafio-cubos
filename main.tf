terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"

}


resource "docker_network" "cubos_network" {
  name   = "cubos_network"
  driver = "bridge"
}

data "docker_network" "cubos_network" {
  name = resource.docker_network.cubos_network.name

}

resource "docker_image" "postgres" {
  name = "postgres"
  build {
    context    = "./sql"
    tag        = ["postgres:latest"]
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_PASSWORD=${var.postgres_passwd}",
  ]
  ports {
    internal = 5432
  }
  networks_advanced {
    name = data.docker_network.cubos_network.name
  }
  volumes {
    volume_name    = "postgres_volume"
    container_path = "/var/lib/postgresql/data/"
  }
  restart    = "always"
  depends_on = [docker_image.postgres]
}


resource "docker_image" "backend" {
  name = "backend"
  build {
    context    = "./backend"
    tag        = ["backend:latest"]
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "backend" {
  name  = "backend"
  image = docker_image.backend.image_id
  ports {
    internal = 3000
  }
  networks_advanced {
    name = data.docker_network.cubos_network.name
  }
  env = [
    "user=${var.user_postgres}",
    "passwd_database=${var.postgres_passwd}",
    "host_database=${var.host_postgres}",
    "port_database=${var.port_postgres}",
    "port=${var.port_backend}"
  ]
  restart = "always"

  depends_on = [
    docker_container.postgres,
    docker_image.backend
  ]
}

resource "docker_image" "frontend" {
  name = "frontend"
  build {
    context    = "./frontend"
    tag        = ["frontend:latest"]
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "frontend" {
  image = docker_image.frontend.image_id
  name  = "frontend"
  ports {
    internal = 80
    external = 80
  }
  restart = "always"
  networks_advanced {
    name = data.docker_network.cubos_network.name
  }
  depends_on = [docker_container.backend, docker_image.frontend]
}
