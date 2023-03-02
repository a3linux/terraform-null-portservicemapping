module "psm" {
  source = "../../"

  port_service_mappings = {
    my-service = [31000, 31000, "tcp", "my-service"]
  }
}

locals {
  services             = ["my-service", "ssh", "httpx"]
  psms                 = [for s in local.services : lookup(module.psm.port_service_mappings, s, [])]
  port_service_product = setproduct([ for item in local.psms : item if length(item) != 0 ], ["sg-xxxxx1", "sg-xxxx2"])
}

output "my-service-port" {
  value = local.psms[0][0]
}

output "my-service-protocol" {
  value = local.psms[0][2]
}

output "ssh-port" {
  value = local.psms[1][0]
}

output "ssh-protocol" {
  value = local.psms[1][2]
}

# The product looks like, [ [[from_port, to_port, protocol, description], 'sg-xxxx1' ], .. ]
output "aws-security-group-rule-test" {
  value = {
    from_port = element(element(element(local.port_service_product, 0), 0), 0)
    to_port = element(element(element(local.port_service_product, 0), 0), 1)
    protocol = element(element(element(local.port_service_product, 0), 0), 2)
    description = element(element(element(local.port_service_product, 0), 0), 3)
    security_group_id = element(element(local.port_service_product, 0), 1)
  }
}

