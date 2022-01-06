# Terraform DigitalOcean regional Droplets

This module creates a set of DigitalOcean Droplets—one in each available region—and corresponding DNS records.

## Overview

Looking at NYC1 as an example, given a domain name of `example.com`, a Droplet named `nyc1.example.com` will be created.

The following DNS records will also be created:

| Type | Name                     |
| ---- | ------------------------ |
| A    | `nyc1.example.com.`      |
| AAAA | `nyc1.example.com.`      |
| A    | `nyc1-ipv4.example.com.` |
| AAAA | `nyc1-ipv6.example.com.` |

All Droplets are assigned to a single project. A `regional` tag is also applied to Droplets for use with Cloud Firewalls, though no firewall is provided in this module.

## Requirements

You will need the following resources already created in your DigitalOcean account:

* A domain, which will be used for Droplet names and DNS records.
* At least one SSH key. All SSH keys in your account will be selected for Droplet creation.

## Usage

Call the module like so:

```hcl
module "test_droplets" {
  source      = "github.com/NicholasPCole/terraform-digitalocean-regional-droplets"

  domain_name = "example.com"
}
```

Only `domain_name` is required.

Additional, optional variables are described in `variables.tf`.
