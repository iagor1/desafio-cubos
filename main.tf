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

data "docker_network" "testenet" {
  name = "testenet"
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = "a0ec33dfd00a"
  env = [
    "POSTGRES_PASSWORD=1234"
  ]
  ports {
    internal = 5432
  }
  networks_advanced {
    name = data.docker_network.testenet.name
  }
  volumes {
    volume_name    = "teste_volume"
    container_path = "/var/lib/postgresql/data/"
  }
}




resource "docker_container" "back" {
  image = "29b805cf8f3d"
  name  = "back"
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = data.docker_network.testenet.name
  }
  depends_on = [docker_container.postgres]
}

resource "docker_container" "nginx" {
  image = "2224417d2f57"
  name  = "front"
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = data.docker_network.testenet.name
  }
  depends_on = [docker_container.back]
}

#add : buildar img com terraform, add arq variables.tf

# resource "docker_image" "banco" {
#   name = "banco"
#   build {
#     context    = "./banco"
#     tag        = ["banco:develop"]
#     dockerfile = "Dockerfile"
#   }
# }

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