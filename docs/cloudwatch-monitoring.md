# CloudWatch Monitoring for EC2

## Purpose
Monitor Amazon EC2 performance using Amazon CloudWatch.

## Key Metric
- Metric: CPUUtilization
- Namespace: AWS/EC2
- Statistic: Average
- Example evaluation period: 5 minutes

## Alarm Example
Create a CloudWatch alarm when average EC2 CPU utilization
exceeds 80% for 2 consecutive 5-minute periods.

## Notification
An Amazon SNS topic can notify the operations team when the
alarm enters the ALARM state.

## Security and Cost
- Grant only the IAM permissions required.
- Avoid storing credentials in source files.
- Review CloudWatch alarm and metric costs before deployment.

## Status
This document describes a proposed configuration.
No alarm or AWS resource has been deployed yet.
