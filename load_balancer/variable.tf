variable "load_balancer" {
  type = object({
    name                          = string
    internal                      = bool
    type                          = string
    security_groups               = list(string)
    subnets                       = list(string)
    vpc_id                        = string
    target_group_name             = string
    target_group_port             = number
    target_group_protocol         = string
    http_listener_action          = string
    http_listener_port            = number
    http_listener_protocol        = string
    https_listener_action         = string
    https_listener_port           = number
    https_listener_protocol       = string
    instance_ids                  = list(string)
    ssl_arn                       = string
  })
}