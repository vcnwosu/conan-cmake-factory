terraform {
    required_version = ">= 1.14"

    required_providers {
        enos = {
            source = "hashicorp-forge/enos"
            version = "0.6.3"
        }

        kind = {
            source = "tehcyx/kind"
            version = "0.10.0"
        }

        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "~> 3.0"
        }
    }
}
