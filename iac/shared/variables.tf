variable "default_tags" { 
    type = map 
    default = {
      WorkloadName = "sharedresources",
      DataClassification = "General",
      Criticality = "High",
      BusinessUnit = "Shared",
      OpsCommitment = "Baseline only",
      OpsTeam = "Cloud operations"
  }
}