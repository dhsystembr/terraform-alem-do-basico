variable ambiente {
  type = map(string)
  description = "Mapa que define em qual ambiente estamos"
  default = {
    default = "Esse e o ambiente padrao"
    dev = "Esse e o ambiente de desenvolvimento"
    hom = "Esse e o ambiente de homologacao"
    prod = "Esse e o ambiente de producao"
  }
}

locals {
  exp_env = lookup(var.ambiente, terraform.workspace)
}

output ambiente_atual {
  value = local.exp_env
}
