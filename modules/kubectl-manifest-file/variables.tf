variable "kubectl_manifest_file_path" {
  description = "Kubectl manifest file path"
  type        = string
}

variable "force_new" {
  description = "Optional. Forces delete & create of resources if the yaml_body changes"
  type    = bool
  default = true
}

variable "wait" {
  description = "Optional. Set this flag to wait or not for finalized to complete for deleted objects"
  type    = bool
  default = false
}

variable "wait_for_rollout" {
  description = "Optional. Set this flag to wait or not for Deployments and APIService to complete rollout"
  type    = bool
  default = false
}
