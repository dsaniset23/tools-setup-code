terraform {
  backend "s3" {
    bucket = "roboshop-611"
    key    = "vault_secrets/terraform.state"
    region = "us-east-1"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
  }
}

provider "vault" {
  address         = "http://vault-internal.devops24.shop:8200"
  token           = var.vault_token
  skip_tls_verify = true
}

variable "vault_token" {}

resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev"
  type        = "kv"
  options     = { version = "2" }
  description = "RoboShop Dev Secrets"
}

resource "vault_mount" "infra-secrets" {
  path = "infra-secrets"
  type = "kv"
  options     = { version = "2" }
  description = "Infra secrets"
}

resource "vault_generic_secret" "frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
  "catalogue_url":   "http://catalogue-dev.devops24.shop:8080/",
  "cart_url":   "http://cart-dev.devops24.shop:8080/",
  "user_url":   "http://user-dev.devops24.shop:8080/",
  "shipping_url":   "http://shipping-dev.devops24.shop:8080/",
  "payment_url":   "http://payment-dev.devops24.shop:8080/",
  "CATALOGUE_HOST" : "catalogue-dev.devops24.shop",
  "CATALOGUE_PORT" : 8080,
  "USER_HOST" : "user-dev.devops24.shop",
  "USER_PORT" : 8080,
  "CART_HOST" : "cart-dev.devops24.shop",
  "CART_PORT" : 8080,
  "SHIPPING_HOST" : "shipping-dev.devops24.shop",
  "SHIPPING_PORT" : 8080,
  "PAYMENT_HOST" : "payment-dev.devops24.shop",
  "PAYMENT_PORT" : 8080
}
EOT
}

resource "vault_generic_secret" "catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
  "MONGO": "true",
  "MONGO_URL" : "mongodb://mongodb-dev.devops24.shop:27017/catalogue",
  "DB_TYPE": "mongo",
  "APP_GIT_URL": "https://github.com/roboshop-devops-project-v3/catalogue",
  "DB_HOST": "mongodb-dev.devops24.shop",
  "SCHEMA_FILE": "db/master-data.js",
  "user": "roboshop"
}
EOT
}

resource "vault_generic_secret" "user" {
  path = "${vault_mount.roboshop-dev.path}/user"

  data_json = <<EOT
{
  "MONGO": "true",
  "MONGO_URL" : "mongodb://mongodb-dev.devops24.shop:27017/users",
  "REDIS_URL" : "redis://redis-dev.devops24.shop:6379"
}
EOT
}

resource "vault_generic_secret" "cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
  "REDIS_HOST": "redis-dev.devops24.shop",
  "CATALOGUE_HOST" : "catalogue",
  "CATALOGUE_PORT" : "8080"
}
EOT
}

resource "vault_generic_secret" "shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"

  data_json = <<EOT
{
  "CART_ENDPOINT": "cart:8080",
  "DB_HOST" : "mysql-dev.devops24.shop",
  "mysql_root_password" : "RoboShop@1",
  "DB_TYPE": "mysql",
  "APP_GIT_URL": "https://github.com/roboshop-devops-project-v3/shipping",
  "DB_USER": "root",
  "DB_PASS": "RoboShop@1"
}
EOT
}



resource "vault_generic_secret" "payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
  "CART_HOST" : "cart",
  "CART_PORT" : "8080",
  "USER_HOST" : "user",
  "USER_PORT" : "8080",
  "AMQP_HOST" : "rabbitmq-dev.devops24.shop",
  "AMQP_USER" : "roboshop",
  "AMQP_PASS" : "roboshop123"
}
EOT
}

resource "vault_generic_secret" "mysql" {
  path = "${vault_mount.roboshop-dev.path}/mysql"

  data_json = <<EOT
{
  "mysql_root_password" : "RoboShop@1"
}
EOT
}

resource "vault_generic_secret" "rabbitmq" {
  path = "${vault_mount.roboshop-dev.path}/rabbitmq"

  data_json = <<EOT
{
  "user" : "roboshop",
  "password" : "roboshop123"
}
EOT
}

resource "vault_generic_secret" "dispatch" {
  path = "${vault_mount.roboshop-dev.path}/dispatch"

  data_json = <<EOT
{
  "user" : "roboshop",
  "AMQP_HOST" : "rabbitmq-dev.devops24.shop",
  "AMQP_USER" : "roboshop",
  "AMQP_PASS" : "roboshop123"
}
EOT
}

resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.infra-secrets.path}/ssh"

  data_json = <<EOT
{
  "password" : "DevOps321",
  "user" : "ec2-user"
}
EOT
}