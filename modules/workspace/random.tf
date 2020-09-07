resource "random_password" "workspace_sp" {
  length           = 30
  special          = true
  min_numeric      = 5
  min_special      = 2
  override_special = "-_%@?"
}

resource "random_password" "kv_reader_sp" {
  length           = 30
  special          = true
  min_numeric      = 5
  min_special      = 2
  override_special = "-_%@?"
}
