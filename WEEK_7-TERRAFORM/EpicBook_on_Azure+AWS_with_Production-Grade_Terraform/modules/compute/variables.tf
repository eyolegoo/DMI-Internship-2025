variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "admin_username" { type = string }
variable "ssh_public_key_path" { type = string }
variable "subnet_id" { type = string }
variable "db_host" { type = string }
variable "db_username" { type = string }

variable "db_password" { 
    type = string
    sensitive = true 
    }
    
variable "tags" { type = map(string) }
variable "public_ip_sku" { type = string }