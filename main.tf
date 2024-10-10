
provider "aws" {
  region = "us-west-1"
}


resource "aws_sns_topic" "critical_alerts" {
  name = "CriticalEventAlerts"
}


resource "aws_sns_topic_subscription" "critical_alerts_email" {
  topic_arn = aws_sns_topic.critical_alerts.arn
  protocol  = "email"
  endpoint  = "damirxon27@gmail.com"
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU utilization exceeds 80%"
  dimensions = {
    InstanceId = "your_instance_id"
  }
  alarm_actions = [aws_sns_topic.critical_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "high_db_connections" {
  alarm_name          = "HighDBConnections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 100
  alarm_description   = "Alarm when DB connections exceed 100"
  dimensions = {
    DBInstanceIdentifier = "your_rds_instance_id"
  }
  alarm_actions = [aws_sns_topic.critical_alerts.arn]
}


output "sns_topic_arn" {
  value = aws_sns_topic.critical_alerts.arn
}
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "db_credentials"
  description = "Database credentials for GoGreen"
  tags = {
    Name = "GoGreenDBCredentials"
  }
}
