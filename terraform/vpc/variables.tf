variable "project_id" {}
variable "region" {}
variable "network_name" {}

variable "subnets" {
  type = list(object({
    subnet_name   = string
    ip_cidr_range = string
    region        = string
  }))
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}
