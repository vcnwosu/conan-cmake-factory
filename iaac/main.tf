provider "kind" {}

resource "kind_cluster" "k8sbuilder" {
    name = "k8sbuilder-cluster"
    wait_for_ready = true

    kind_config {
        kind = "Cluster"
        api_version = "kind.x-k8s.io/v1alpha4"

        node {
            role = "control-pane"
        }

        node {
            role = "worker"

            extra_mounts {
                host_path = abspath("${path.cwd}/../")
                container_path = "/workspace"
            }
        }
    }
}

provider "enos" {}

resource "enos_local_kind_load_image" "k8sbuilder" {
    cluster_name = "${kind_cluster.k8sbuilder.name}"
    image = "robotics-builder"
    tag = "latest"
}

provider "kubernetes" {
    config_path = kind_cluster.k8sbuilder.kubeconfig_path
}

resource "kubernetes_persistent_volume_v1" "k8sbuilder" {
    metadata {
        name = "k8sbuilder-pv"
    }

    spec {
        access_modes = ["ReadWriteMany"]
        capacity = {
            storage = "10Gi"
        }

        storage_class_name = "ks8builder-pv-storage"

        persistent_volume_source {
            host_path {
                path = "/workspace/cache"
                type = "DirectoryOrCreate"
            }
        }
    }
}

resource "kubernetes_persistent_volume_claim_v1" "k8sbuilder" {
    metadata {
        name = "k8sbuilder-pvc"
    }

    spec {
        access_modes = ["ReadWriteMany"]
        volume_name = "${kubernetes_persistent_volume_v1.k8sbuilder.metadata.0.name}"
        storage_class_name = "${kubernetes_persistent_volume_v1.k8sbuilder.spec.0.storage_class_name}"

        resources {
            requests = {
                storage = "5Gi"
            }
        }
    }
}

resource "kubernetes_pod_v1" "k8sbuilder" {
    metadata {
        name = "k8sbuilder-pod"
    }

    depends_on = [enos_local_kind_load_image.k8sbuilder]

    spec {
        container {
            name = "robotics-builder"
            image = "robotics-builder:latest"
            image_pull_policy = "Never"
            command = ["./execute.sh"]

            volume_mount {
                name = "k8sbuilder-src-files"
                mount_path = "/app"
            }

            volume_mount {
                name = "k8sbuilder-pod-volume"
                mount_path = "/cache"
            }
        }

        volume {
            name = "k8sbuilder-pod-volume"

            persistent_volume_claim {
                claim_name = "${kubernetes_persistent_volume_claim_v1.k8sbuilder.metadata.0.name}"
            }
        }

        volume {
            name = "k8sbuilder-src-files"

            host_path {
                path = "/workspace"
                type = "DirectoryOrCreate"
            }
        }
    }
}
