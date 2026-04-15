##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works/
#     Distributed Under Apache v2.0 License
#

locals {
  secret_names = {
    for k in keys(var.users) : k => format("%s-mongodbatlas-%s-%s",
      local.system_name_short,
      lower(replace(replace(module.mongoatlas_users.users[k].project_name, " ", ""), "_", "-")),
      lower(replace(k, "_", "-")),
    )
  }
}

data "azurerm_key_vault" "credentials" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_key_vault_secret" "atlas_cred" {
  for_each     = var.users
  name         = local.secret_names[each.key]
  value        = jsonencode(module.mongoatlas_users.credentials[each.key])
  key_vault_id = data.azurerm_key_vault.credentials.id
  content_type = "application/json"
  tags = merge(local.all_tags, {
    "mongodb-username" = module.mongoatlas_users.users[each.key].username
    "mongodb-project"  = module.mongoatlas_users.users[each.key].project_name
    },
    try(var.users[each.key].connection_strings.database_name, "") != "" ? { "mongodb-dbname" = try(var.users[each.key].connection_strings.database_name, "") } : {}
  )

  depends_on = [module.mongoatlas_users]
}
