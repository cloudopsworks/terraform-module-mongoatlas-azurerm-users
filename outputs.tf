##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works/
#     Distributed Under Apache v2.0 License
#

output "users" {
  description = "User metadata map enriched with the Azure Key Vault secret ID for each user's credentials."
  value = {
    for k, v in module.mongoatlas_users.users : k => merge(v, {
      secrets_credentials = azurerm_key_vault_secret.atlas_cred[k].id
    })
  }
}

output "hoop_connections" {
  description = "Hoop connection definitions enriched with Azure Key Vault secret references. Pass as the `connections` input to terraform-module-hoop-connection. Uses hoop.dev _envs/azure/<secret-name> syntax."
  value = module.mongoatlas_users.hoop_output != null ? {
    for key, conn in module.mongoatlas_users.hoop_output.connections : key => merge(conn, {
      agent_id = module.mongoatlas_users.hoop_output.agent_id
      secrets = {
        "envvar:CONNECTION_STRING" = "_envs/azure/${azurerm_key_vault_secret.atlas_cred[key].name}"
      }
    })
  } : null
}

output "users" {
  description = "User metadata map enriched with the Azure Key Vault secret ID for each user's credentials."
  value = {
    for k, v in module.mongoatlas_users.users : k => merge(v, {
      secrets_credentials = azurerm_key_vault_secret.atlas_cred[k].id
    })
  }
}

output "hoop_connections" {
  description = "Hoop connection definitions enriched with Azure Key Vault secret references. Pass as the `connections` input to terraform-module-hoop-connection. Uses hoop.dev _envs/azure/<secret-name> syntax."
  value = module.mongoatlas_users.hoop_output != null ? {
    for key, conn in module.mongoatlas_users.hoop_output.connections : key => merge(conn, {
      agent_id = module.mongoatlas_users.hoop_output.agent_id
      secrets = {
        "envvar:CONNECTION_STRING" = "_envs/azure/${azurerm_key_vault_secret.atlas_cred[key].name}"
      }
    })
  } : null
}
