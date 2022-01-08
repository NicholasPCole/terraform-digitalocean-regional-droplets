data "digitalocean_domain" "regional" {
  name = var.domain_name
}

data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }

  sort {
    key       = "slug"
    direction = "asc"
  }
}

data "digitalocean_ssh_keys" "keys" {
  sort {
    key       = "name"
    direction = "asc"
  }
}

resource "digitalocean_droplet" "regional" {
  for_each = toset(data.digitalocean_regions.available.regions[*].slug)

  name       = "${var.name_prefix}${each.key}.${var.domain_name}"
  region     = each.key
  image      = var.droplet_image
  size       = var.droplet_size
  backups    = false
  ipv6       = true
  monitoring = true
  ssh_keys   = data.digitalocean_ssh_keys.keys.ssh_keys[*].id
  tags       = flatten([digitalocean_tag.regional.id, var.additional_droplet_tags])
}

resource "digitalocean_project" "regional" {
  name        = "Regional"
  description = "Test Droplets, one in each available region."
  purpose     = "Other"
  environment = "Development"
}

resource "digitalocean_project_resources" "regional" {
  project = digitalocean_project.regional.id

  resources = values(digitalocean_droplet.regional)[*].urn
}

resource "digitalocean_record" "regional_A" {
  for_each = toset(data.digitalocean_regions.available.regions[*].slug)

  domain = data.digitalocean_domain.regional.name
  name   = "${var.name_prefix}${each.key}"
  type   = "A"
  value  = digitalocean_droplet.regional[each.key].ipv4_address
  ttl    = var.dns_record_ttl
}

resource "digitalocean_record" "regional_AAAA" {
  for_each = toset(data.digitalocean_regions.available.regions[*].slug)

  domain = data.digitalocean_domain.regional.name
  name   = "${var.name_prefix}${each.key}"
  type   = "AAAA"
  value  = digitalocean_droplet.regional[each.key].ipv6_address
  ttl    = var.dns_record_ttl
}

resource "digitalocean_record" "regional_ipv4" {
  for_each = toset(data.digitalocean_regions.available.regions[*].slug)

  domain = data.digitalocean_domain.regional.name
  name   = "${var.name_prefix}${each.key}-ipv4"
  type   = "A"
  value  = digitalocean_droplet.regional[each.key].ipv4_address
  ttl    = var.dns_record_ttl
}

resource "digitalocean_record" "regional_ipv6" {
  for_each = toset(data.digitalocean_regions.available.regions[*].slug)

  domain = data.digitalocean_domain.regional.name
  name   = "${var.name_prefix}${each.key}-ipv6"
  type   = "AAAA"
  value  = digitalocean_droplet.regional[each.key].ipv6_address
  ttl    = var.dns_record_ttl
}

resource "digitalocean_tag" "regional" {
  name = "regional"
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16.0"
    }
  }
}
