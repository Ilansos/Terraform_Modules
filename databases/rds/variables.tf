variable "rds_instance" {
  type = object({
    identifier                      = string
    instance_class                  = string
    allocated_storage               = number
    engine                          = string
    engine_version                  = string
    username                        = string
    password                        = string
    db_subnet_group_name            = string
    db_subnet_group_name_tag_name   = string
    subnet_ids                      = list(string)
    security_group_id               = list(string)
    publicly_accessible             = bool
    skip_final_snapshot             = bool
    parameter_group_name            = string
    parameter_group_family          = string 
  })
}