Port Service Mapping
========================

Simple terraform module help to define service port mapping and output can be used in security rule define, for example, for AWS Security Group rules.

This module focus on AWS Security Group rules, but it should be also useful for others as the info here is common ones.


# Usage

Module instance, 

```terraform
module "portservicemapping" {
  source  = "a3linux/portservicemapping/null"
  version = "0.1.0"

  port_service_mappings = {
    service1 = [11000, 11000, "tcp", "REST API Service I"]
  }
}
```

Check example/complete/main.tf for reference. 

By default, the module include some popular port service mappings already, such as http, https, mysql, mssql, postgresql, redis and so forth. Add customized ones with variable port_service_mappings when instance this module. 

The port_service_mappings should be defined as terraform map(list(any)), 

```
port_service_mappings = {
    service1 = [xx, xx, "tcp", "description"]
    service2 = [xx, xx, "tcp", "description"]
    service3 = [xx, xx, "tcp", "description"]
    service4 = [xx, xx, "tcp", "description"]
}    
```

Then the module instance can be used to fetch any service port product as the example shows.

## Sample to use with AWS Security Group Rule builing

Within the examples/complete/main.tf, there is an sample to build a terraform product with a given port service mappings + some security group id,

Product of port service mapping and security group id,
```
[
    [
        [
            from_port, to_port, protocol, description
        ],
        security_group_id,
    ]
]
```

Then to build a terraform map for AWS Security Group Rule is easy as following,

 ```
 value = {
    from_port = element(element(element(local.port_service_product, 0), 0), 0)
    to_port = element(element(element(local.port_service_product, 0), 0), 1)
    protocol = element(element(element(local.port_service_product, 0), 0), 2)
    description = element(element(element(local.port_service_product, 0), 0), 3)
    security_group_id = element(element(local.port_service_product, 0), 1)
 }
 ```
 Also, terraform each method can apply to the product to loop all rules.
