#ssm is used fo key value store of other sub modules 

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"  # we pull dynamically other two, it has to start with slash
  type  = "String"   # aws notation String=S  
  value = module.vpc.vpc_id
}


resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"  # string list for parameter acceptence
  value = join("," ,module.vpc.public_subnet_ids) # converting list to string list
}

#["id1","id2"] list in terraform format
# id1, id2 -> lits in AWS SSM format
resource "aws_ssm_parameter" "private_subnet_ids" {     #name is private_subnet_ids value= joinjoin(",",module.vpc.private_subnet_ids) 
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",",module.vpc.private_subnet_ids) # converting list to string list
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}