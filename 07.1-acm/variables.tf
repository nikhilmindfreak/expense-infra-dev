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
    Component = "acm"
  }
}

variable "zone_name" {
  default = "devopsme.online"
}

variable "zone_id" {
  default = "Z05782673IECJD1E1MAG1" # replace with ur id
}