variable "additional_droplet_tags" {
  type        = list(string)
  description = "Additional tag(s) to apply to created Droplets."
  default     = []
}

variable "dns_record_ttl" {
  type        = string
  description = "Time to live value for which DNS records will be cached."
  default     = "300"
}

variable "domain_name" {
  type        = string
  description = "Domain name used to suffix Droplet names and create DNS records."
}

variable "droplet_image" {
  type        = string
  description = "Image (Ubuntu, Fedora, etc.) used to create Droplets."
  default     = "ubuntu-20-04-x64"
}

variable "droplet_size" {
  type        = string
  description = "Size slug (CPU, memory, etc.) used to create Droplets."
  default     = "s-1vcpu-1gb"
}

variable "name_prefix" {
  type        = string
  description = "An optional string prefixed to Droplet and DNS record names."
  default     = ""
}
