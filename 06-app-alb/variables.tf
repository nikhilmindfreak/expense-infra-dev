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
    Component = "app-alb"  #for billing purpose we give mandotry tag
  }
}

variable "zone_name" {
  default = "devopsme.online"
}