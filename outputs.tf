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
  description = "Hoop connection definitions enriched with Azure Key Vault secret references. Pass as the `connections` input to terraform-module-hoop-connection. Community mode returns null (no _azure agent provider); enterprise mode uses _envs/azure/<secret-name>."
  value = module.mongoatlas_users.hoop_output != null && !try(var.hoop.community, true) ? {
    for key, conn in module.mongoatlas_users.hoop_output.connections : key => merge(conn, {
      agent_id = module.mongoatlas_users.hoop_output.agent_id
      secrets = {
        "envvar:CONNECTION_STRING" = "_envs/azure/${azurerm_key_vault_secret.atlas_conn_string[key].name}"
      }
    })
  } : null
}

output "connection_string_secret_ids" {
  description = "Map of user keys to Azure Key Vault secret IDs containing only the connection string. Use with hoop community edition by setting agent env vars and referencing via _envjson:ENV_VAR:<key>."
  value = {
    for k in keys(var.users) : k => azurerm_key_vault_secret.atlas_conn_string[k].id
  }
}
