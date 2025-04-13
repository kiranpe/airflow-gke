
variable "project_id" {}
variable "region" {}
variable "vpc_id" {}
variable "db_password" {}

variable "enable_default_user" {
  description = "Enable or disable the creation of the default user"
  type        = bool
  default     = true
}

variable "password_validation_policy_config" {
  description = "The password validation policy settings for the database instance."
  type = object({
    enable_password_policy      = bool
    min_length                  = optional(number)
    complexity                  = optional(string)
    disallow_username_substring = optional(bool)
    reuse_interval              = optional(number)
  })
  default = null
}

variable "enable_random_password_special" {
  description = "Enable special characters in generated random passwords."
  type        = bool
  default     = false
}
