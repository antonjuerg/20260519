terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}

# Verbindung zum K3s-Cluster auf der VM
provider "kubernetes" {
  config_path = "~/.kube/config-k3s"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config-k3s"
  }
}

# Namespaces deklarativ anlegen
resource "kubernetes_namespace" "platform" {
  metadata {
    name = "platform"
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
    labels = {
      # KRITIS-Härtung: Schaltet restriktive Sicherheitsregeln für die App-Namespace scharf
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}

# ArgoCD via Helm installieren
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.53.0"
  namespace  = kubernetes_namespace.platform.metadata[0].name

  set {
    name  = "server.insecure"
    value = "true"
  }
}

# Prometheus & Grafana via Helm installieren
resource "helm_release" "prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.6.0"
  namespace  = kubernetes_namespace.platform.metadata[0].name

  # Ressourcen-Limits für die lokale Umgebung schonen
  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = "400Mi"
  }
  set {
    name  = "grafana.resources.requests.memory"
    value = "100Mi"
  }
}
