variable default_ingress-hom {
  type = map(object({description = string, cidr_blocks = list(string)}))
  default = {
    22 = { description = "Inbound para SSH", cidr_blocks = [ "10.0.0.0/16" ] }
    80 = { description = "Inbound para HTTP", cidr_blocks = [ "10.0.0.0/16" ] }
    443 = { description = "Inbound para HTTPS", cidr_blocks = [ "10.0.0.0/16" ] }
  }
}

variable default_ingress-dev {
  type = map(object({description = string, cidr_blocks = list(string)}))
  default = {
    22 = { description = "Inbound para SSH", cidr_blocks = [ "10.0.1.0/16" ] }
    80 = { description = "Inbound para HTTP", cidr_blocks = [ "10.0.1.0/16" ] }
    443 = { description = "Inbound para HTTPS", cidr_blocks = [ "10.0.1.0/16" ] }
    5432 = { description = "Inbound para postgres", cidr_blocks = [ "10.0.1.0/16" ] }
  }
}

variable default_ingress-prod {
  type = map(object({description = string, cidr_blocks = list(string)}))
  default = {
    22 = { description = "Inbound para SSH", cidr_blocks = [ "10.0.2.0/16" ] }
  }
}
