variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "admin_username" { type = string }
variable "ssh_public_key_path" { type = string }
variable "db_username" { type = string }

variable "db_password" { 
type = string
sensitive = true 
}
variable "vm_size" { type = string }

variable "tags" { 
    type = map(string)
    default = {} 
    }

variable "public_ip_sku" { 
    type = string
    default = "Standard" 
    }
variable "my_ip" { type = string }