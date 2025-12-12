variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
variable "db_username" { type = string }

variable "db_password" { 
type = string
sensitive = true 
}

variable "tags" { type = map(string) }