output "uids" {
  description = "Kubernetes unique identifiers from last run"
  value = kubectl_manifest.self.*.uid
}
