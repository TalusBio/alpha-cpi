resource "aws_cloudwatch_metric_alarm" "stop_when_idle" {
  alarm_name          = "${var.project_name}_stop_when_idle"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "24"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "3600"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "This metric monitors ec2 cpu utilization and stops the instance when it's been running on <10% (averaged over 1 hours) for more than 24 hours."
  alarm_actions       = ["arn:aws:automate:${var.region}:ec2:stop", data.terraform_remote_state.data_pipeline.outputs.slack_sns_topic_arn]
  dimensions = {
    InstanceId = aws_instance.instance.id
  }
}