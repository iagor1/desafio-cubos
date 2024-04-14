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

# data "docker_network" "testenet" {
#   name = "testenet"
# }

resource "docker_network" "cubos_network" {
  name = "cubos_network"
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
    "POSTGRES_PASSWORD=1234"
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
  restart = "always"
  depends_on = [docker_image.postgres  ]
}

#não precisa criar block resource pro volume pq se n existir vai ser criado

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
    external = 3000
  }
  networks_advanced {
    name = data.docker_network.cubos_network.name
  }
  
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

#add : buildar img com terraform, add arq variables.tf


# resource "docker_container" "postgres" {
#   name  = "postgres"
#   image = docker_image.banco.image_id
#   env = [
#     var.POSTGRES_PASSWORD
#   ]
#   ports {
#     internal = 5432
#   }
#   volumes {
#     volume_name    = "teste_volume"
#     container_path = "/var/lib/postgresql/data/"
#   }
#   networks_advanced {
#     name = data.docker_network.testenet.name
#   }
#   depends_on = [docker_image.banco]
# }