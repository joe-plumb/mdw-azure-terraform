# This is a workaround for the azure provider not working
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/6934
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/6659

resource "null_resource" "storage-container" {
  triggers = {
    build_number = timestamp()
  }
  provisioner "local-exec" {
    command = "echo `pwd` && sh adlscontainercreate.sh"
    working_dir = path.module
    environment = {
      STORAGE_ACCOUNT_KEY = var.existing_storage_account.primary_access_key
      STORAGE_ACCOUNT_NAME = var.existing_storage_account.name
      CONTAINER_NAME = var.create_container_name
    }  
  }
  depends_on = [
    var.existing_storage_account
  ]
}