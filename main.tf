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


resource "docker_container" "postgres" {
  name  = "postgres"
  image = "2b82210ed6c7"
  env = [
    "POSTGRES_PASSWORD=1234"
  ]
  ports {
    internal = 5432
  }
}

resource "docker_container" "nginx" {
  image = "7adbcc03c27f"
  name  = "front"
  ports {
    internal = 80
    external = 80
  }
  depends_on = [ docker_container.postgres ]
}



resource "docker_container" "back" {
  image = "fd7928712405"
  name  = "back"
  ports {
    internal = 3000
    external = 3000
  }
  depends_on = [ docker_container.nginx ]
}
