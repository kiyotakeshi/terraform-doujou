# 先にSNSの認証をしておく必要あり
# alarm_actions に認証が完了したアラームの arn を追加
# resource "aws_cloudwatch_metric_alarm" "doujou" {
#   alarm_name          = "${var.PROJECT_NAME}-cpu-utilization"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "80"
#   alarm_description   = "This metric monitors ec2 cpu utilization"
#   alarm_actions = ["${var.CLOUD_WATCH_ALERM_ACTION_SNS}"]
# }

