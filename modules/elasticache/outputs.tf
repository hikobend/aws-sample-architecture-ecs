# log_delivery_configuration {
#   destination      = aws_cloudwatch_log_group.slow-log.name
#   destination_type = "cloudwatch-logs"
#   log_format       = "text"
#   log_type         = "slow-log"
# }
# log_delivery_configuration {
#   destination      = aws_cloudwatch_log_group.engine-log.name
#   destination_type = "cloudwatch-logs"
#   log_format       = "text"
#   log_type         = "engine-log"
# }
