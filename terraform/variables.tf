variable "project_name" {
  default = "aws_etl_project"
}
variable "db_username" {
  default = "etl_user"
}
variable "db_password" {
  description = "DB password"
  sensitive   = true
}