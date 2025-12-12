locals {
  # 1. Environment Map: Configuration map based on workspace
  environment_map = {
    # Settings for 'dev' workspace
    dev = {
      suffix  = "dev"
      vm_size = "Standard_B1s"
      tag_env = "Development should be continous"
    }
    # Settings for 'prod' workspace
    prod = {
      suffix  = "prod"
      vm_size = "Standard_B1s"
      tag_env = "Production"
    }
    # Fallback for 'default' workspace
    default = {
      suffix  = "test"
      vm_size = "Standard_B1s"
      tag_env = "Testing"
    }
  }

  # 2. Dynamic Selection: Pulls settings based on current workspace name
  env = lookup(local.environment_map, terraform.workspace, local.environment_map.default)

  # 3. Dynamic Resource Name Generation (e.g., react-app-rg-dev or react-app-rg-prod)
  resource_group_name = "${var.base_name}-rg-${local.env.suffix}"
  vnet_name           = "${var.base_name}-vnet-${local.env.suffix}"
  subnet_name         = "${var.base_name}-snet-${local.env.suffix}"
  nsg_name            = "${var.base_name}-nsg-${local.env.suffix}"
  public_ip_name      = "${var.base_name}-ip-${local.env.suffix}"
  nic_name            = "${var.base_name}-nic-${local.env.suffix}"
  vm_name             = "${var.base_name}-vm-${local.env.suffix}"

  # 4. Standard Tags
  common_tags = {
    environment = local.env.tag_env
    project     = "ReactAppDeployment"
    workspace   = terraform.workspace
  }
}
