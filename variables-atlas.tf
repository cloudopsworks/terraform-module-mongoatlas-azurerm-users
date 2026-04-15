##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works/
#     Distributed Under Apache v2.0 License
#

variable "name_prefix" {
  description = <<-EOD
  name_prefix: "atlas" # (Required) Prefix used to compose usernames when `users[<key>].username` is not provided. Allowed: lowercase letters, numbers, and hyphens. No default.
  EOD
  type        = string
}

variable "project_id" {
  description = <<-EOD
  project_id: "60f0f0f0f0f0f0f0f0f0f0f0" # (Optional) Atlas Project ID. One of `project_id` or `project_name` must be provided. Default: "".
  EOD
  type        = string
  default     = ""
}

variable "project_name" {
  description = <<-EOD
  project_name: "my-project" # (Optional) Atlas Project Name. One of `project_id` or `project_name` must be provided. Default: "".
  EOD
  type        = string
  default     = ""
}

variable "users" {
  description = <<-EOD
  users:
    <user_key>:
      username: "user1" # (Optional) Explicit username. If omitted, composed as `<name_prefix|user.name_prefix>-<system_name_short>-<user_key>`. Default: generated.
      name_prefix: "prefix1" # (Optional) Per-user prefix to build the username. If omitted, uses var.name_prefix. Default: null.
      auth_database: "admin" # (Optional) Authentication database. Common: "admin". Default: "admin".
      password_rotation_period: 90 # (Optional) Rotation period in days for this user. Overrides var.password_rotation_period. Default: var.password_rotation_period.
      import: false # (Optional) When true, imports an existing MongoDB Atlas user instead of creating a new one. Default: false.
      role_name: "readwrite" # (Optional) Top-level primary role key used for Hoop connection naming. Allowed: readwrite, read, dbadmin, admin, dbowner, owner, clusteradmin. Default: "default".
      roles: # (Required) MongoDB roles granted to this user.
        - role_name: "readWrite" # (Required) Built-in or custom role name. Common: read, readWrite, dbAdmin, dbOwner, userAdmin, clusterAdmin. No default.
          database_name: "test" # (Required) Database that the role applies to. No default.
          collection_name: "widgets" # (Optional) Collection the role is scoped to. Default: null.
      scopes: # (Optional) Atlas scope bindings for the user.
        - name: "cluster-name" # (Required) Target cluster or data lake name. No default.
          type: "CLUSTER" # (Optional) Scope type. Allowed: CLUSTER, DATA_LAKE. Default: "CLUSTER".
      connection_strings: # (Optional) Control generation of connection strings in Key Vault.
        enabled: false # (Optional) When true, store connection strings. Default: false.
        cluster: "cluster0" # (Required if enabled) Atlas Cluster name. No default.
        endpoint_id: "vpce-0123456789abcdef" # (Optional) Private endpoint ID for PrivateLink strings. Default: "".
        database_name: "mydatabase" # (Optional) Database name appended to the URI. Default: "".
      hoop: # (Optional) Per-user Hoop.dev integration overrides.
        import: false # (Optional) When true, imports this user's existing Hoop connection. Default: false.
        access_control: [] # (Optional) Per-user access control merged with global hoop.access_control. Default: [].
  EOD
  type        = any
  default     = {}
}

variable "hoop" {
  description = <<-EOD
  hoop:
    enabled: false # (Optional) Enable Hoop.dev connection metadata output. Default: false.
    community: true # (Optional) When true, use community/open-source agent format. Community does not support Azure Key Vault as agent-side provider; hoop_connections will be null. Use enterprise for _envs/azure/ support. Default: true.
    agent_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # (Required if enabled) Hoop.dev agent ID (UUID). No default.
    tags: # (Optional) Free-form tags for the Hoop connection. Default: {}.
      key: "value"
    access_control: [] # (Optional) Global access control list. Merged with per-user users[*].hoop.access_control. Default: [].
  EOD
  type        = any
  default     = {}
}

variable "password_rotation_period" {
  description = <<-EOD
  password_rotation_period: 90 # (Optional) Default rotation period in days. Overridden by users[*].password_rotation_period. Allowed: 1-365. Default: 90.
  EOD
  type        = number
  default     = 90
  nullable    = false
}

variable "force_reset" {
  description = <<-EOD
  force_reset: false # (Optional) Force-reset credentials (break-glass). Default: false.
  EOD
  type        = bool
  default     = false
}

variable "key_vault_name" {
  description = <<-EOD
  key_vault_name: "my-keyvault" # (Required) Name of the Azure Key Vault to store credentials. No default.
  EOD
  type        = string
}

variable "key_vault_resource_group_name" {
  description = <<-EOD
  key_vault_resource_group_name: "my-rg" # (Required) Resource group name of the Azure Key Vault. No default.
  EOD
  type        = string
}
