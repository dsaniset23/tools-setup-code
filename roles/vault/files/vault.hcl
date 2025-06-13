ui = true

storage "file" {
  path = "/opt/vault/data"
}

listener "TCP" {
  address: "0.0.0.0/8200"
  tls_disable=1
}