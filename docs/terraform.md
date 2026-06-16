## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.59 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~> 2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.59 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mongoatlas_users"></a> [mongoatlas\_users](#module\_mongoatlas\_users) | git::https://github.com/cloudopsworks/terraform-module-mongoatlas-users.git | v1.4.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.atlas_conn_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.atlas_cred](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault.credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_force_reset"></a> [force\_reset](#input\_force\_reset) | force\_reset: false # (Optional) Force-reset credentials (break-glass). Default: false. | `bool` | `false` | no |
| <a name="input_hoop"></a> [hoop](#input\_hoop) | hoop:<br/>  enabled: false # (Optional) Enable Hoop.dev connection metadata output. Default: false.<br/>  community: true # (Optional) When true, use community/open-source agent format. Community does not support Azure Key Vault as agent-side provider; hoop\_connections will be null. Use enterprise for \_envs/azure/ support. Default: true.<br/>  agent\_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # (Required if enabled) Hoop.dev agent ID (UUID). No default.<br/>  tags: # (Optional) Free-form tags for the Hoop connection. Default: {}.<br/>    key: "value"<br/>  access\_control: [] # (Optional) Global access control list. Merged with per-user users[*].hoop.access\_control. Default: []. | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | key\_vault\_name: "my-keyvault" # (Required) Name of the Azure Key Vault to store credentials. No default. | `string` | n/a | yes |
| <a name="input_key_vault_resource_group_name"></a> [key\_vault\_resource\_group\_name](#input\_key\_vault\_resource\_group\_name) | key\_vault\_resource\_group\_name: "my-rg" # (Required) Resource group name of the Azure Key Vault. No default. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | name\_prefix: "atlas" # (Required) Prefix used to compose usernames when `users[<key>].username` is not provided. Allowed: lowercase letters, numbers, and hyphens. No default. | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_password_rotation_period"></a> [password\_rotation\_period](#input\_password\_rotation\_period) | password\_rotation\_period: 90 # (Optional) Default rotation period in days. Overridden by users[*].password\_rotation\_period. Allowed: 1-365. Default: 90. | `number` | `90` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project\_id: "60f0f0f0f0f0f0f0f0f0f0f0" # (Optional) Atlas Project ID. One of `project_id` or `project_name` must be provided. Default: "". | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project\_name: "my-project" # (Optional) Atlas Project Name. One of `project_id` or `project_name` must be provided. Default: "". | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Azure Region to deploy resources into. Example: 'eastus2', defaults to empty string as some of the resources may not require region setting. | `string` | `""` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_users"></a> [users](#input\_users) | users:<br/>  <user\_key>:<br/>    username: "user1" # (Optional) Explicit username. If omitted, composed as `<name_prefix|user.name_prefix>-<system_name_short>-<user_key>`. Default: generated.<br/>    name\_prefix: "prefix1" # (Optional) Per-user prefix to build the username. If omitted, uses var.name\_prefix. Default: null.<br/>    auth\_database: "admin" # (Optional) Authentication database. Common: "admin". Default: "admin".<br/>    password\_rotation\_period: 90 # (Optional) Rotation period in days for this user. Overrides var.password\_rotation\_period. Default: var.password\_rotation\_period.<br/>    import: false # (Optional) When true, imports an existing MongoDB Atlas user instead of creating a new one. Default: false.<br/>    role\_name: "readwrite" # (Optional) Top-level primary role key used for Hoop connection naming. Allowed: readwrite, read, dbadmin, admin, dbowner, owner, clusteradmin. Default: "default".<br/>    roles: # (Required) MongoDB roles granted to this user.<br/>      - role\_name: "readWrite" # (Required) Built-in or custom role name. Common: read, readWrite, dbAdmin, dbOwner, userAdmin, clusterAdmin. No default.<br/>        database\_name: "test" # (Required) Database that the role applies to. No default.<br/>        collection\_name: "widgets" # (Optional) Collection the role is scoped to. Default: null.<br/>    scopes: # (Optional) Atlas scope bindings for the user.<br/>      - name: "cluster-name" # (Required) Target cluster or data lake name. No default.<br/>        type: "CLUSTER" # (Optional) Scope type. Allowed: CLUSTER, DATA\_LAKE. Default: "CLUSTER".<br/>    connection\_strings: # (Optional) Control generation of connection strings in Key Vault.<br/>      enabled: false # (Optional) When true, store connection strings. Default: false.<br/>      cluster: "cluster0" # (Required if enabled) Atlas Cluster name. No default.<br/>      endpoint\_id: "vpce-0123456789abcdef" # (Optional) Private endpoint ID for PrivateLink strings. Default: "".<br/>      database\_name: "mydatabase" # (Optional) Database name appended to the URI. Default: "".<br/>    hoop: # (Optional) Per-user Hoop.dev integration overrides.<br/>      import: false # (Optional) When true, imports this user's existing Hoop connection. Default: false.<br/>      access\_control: [] # (Optional) Per-user access control merged with global hoop.access\_control. Default: []. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_string_secret_ids"></a> [connection\_string\_secret\_ids](#output\_connection\_string\_secret\_ids) | Map of user keys to Azure Key Vault secret IDs containing only the connection string. Use with hoop community edition by setting agent env vars and referencing via \_envjson:ENV\_VAR:<key>. |
| <a name="output_hoop_connections"></a> [hoop\_connections](#output\_hoop\_connections) | Hoop connection definitions enriched with Azure Key Vault secret references. Pass as the `connections` input to terraform-module-hoop-connection. Community mode returns null (no \_azure agent provider); enterprise mode uses \_envs/azure/<secret-name>. |
| <a name="output_users"></a> [users](#output\_users) | User metadata map enriched with the Azure Key Vault secret ID for each user's credentials. |
