variable "port_service_mappings" {
  type        = map(list(any))
  description = "The service port mappings adding to the defaults into this module"
  default     = {}
}
