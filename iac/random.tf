resource "random_string" "random" {
  length = 5
  special = false
  upper = false
}

resource "random_password" "password" {
  length = 24
  special = true
  override_special = "_%@"
}