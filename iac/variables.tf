variable "default_tags" {
  type = map(any)
  default = {
    WorkloadName       = "syn",
    DataClassification = "General",
    Criticality        = "High",
    BusinessUnit       = "datawarehouse",
    OpsCommitment      = "Baseline only",
    OpsTeam            = "Cloud operations"
  }
}

variable "env" {
  type    = string
}

variable "region" {
  type    = string
  default = "westeurope"
}

variable "regionshort" {
  type    = string
  default = "weu"
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "spn-client-id" {
  type      = string
  sensitive = true
}
variable "spn-client-secret" {
  type      = string
  sensitive = true
}
variable "spn-tenant-id" {
  type      = string
  sensitive = true
}
variable "tf-ado-syn-admins" {
  type      = string
  sensitive = true
}

