terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

##provider "kubernetes" {
  #config_context = "minikube"
#}
provider "helm" {
  kubernetes {
    config_path    = "C:\\Users\\5520\\.kube\\config"
  }
}


provider "kubernetes" {
  config_path    = "C:\\Users\\5520\\.kube\\config"
  config_context = "minikube"
}