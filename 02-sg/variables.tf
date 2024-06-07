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
    }
  
}

variable "db_sg_description" {
  default = "SG for DB MySQL Instance"
}

variable "vpn_sg_rules" {  # vpn sg rules are standard
    default = [
    {
        from_port = 943   
        to_port = 943
        protocol = "tcp"  
        cidr_blocks = ["0.0.0.0/0"]  # blocks its a list
    },
    {
        from_port = 443   
        to_port = 443
        protocol = "tcp"  
        cidr_blocks = ["0.0.0.0/0"]  # blocks its a list
    },
     {
        from_port = 22  
        to_port = 22
        protocol = "tcp"  
        cidr_blocks = ["0.0.0.0/0"]  # blocks its a list
    },
     {
        from_port = 1194  
        to_port = 1194
        protocol = "udp"   #udp protocol
        cidr_blocks = ["0.0.0.0/0"]  # blocks its a list
    }
  ]
}