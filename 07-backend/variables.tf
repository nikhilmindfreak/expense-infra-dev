variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
    Component = "backend"  #for billing purpose we give mandotry tag, #extra tag
  }
}

variable "zone_name" {
  default = "devopsme.online"
}