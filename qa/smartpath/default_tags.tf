variable "default_tags" {
    description = "Default tags"
    type = map(string)
    default = {
      Terraform              = "true"
      Project                = "Core-Gap"
      ApplicationId          = "APM0004691"
      ApplicationName        = "CT-Gap"
      TerraformScriptVersion = "0.13.6"
      CoreID                 = "5510120030"
      DeptID                 = "957200"
      ProjectID              = "OCT-0100-09-01-01-0008"
      CreatedBy              = "Core-gap team member"
      BU                     = "CT"
      Project                = "CoreGAP"
  } 
  
}

