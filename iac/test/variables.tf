variable "default_tags" { 
    type = map 
    default = {
      WorkloadName = "mdw",
      DataClassification = "General",
      Criticality = "High",
      BusinessUnit = "datawarehouse",
      OpsCommitment = "Baseline only",
      OpsTeam = "Cloud operations"
  }
}

variable "env" {
    type = string
    default = "test"
}

variable "region" {
    type = string
    default = "westeurope"
}

variable "regionshort" {
    type = string
    default = "weu"
}
