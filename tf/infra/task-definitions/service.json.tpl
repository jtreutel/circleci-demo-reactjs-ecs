[
  {
    "name": "${aws_resource_name_prefix}-service",
    "image": "${aws_acct_no}.dkr.ecr.${aws_region}.amazonaws.com/${aws_resource_name_prefix}-ecr:${image_tag}",
    "memory": 500,
    "cpu": 256,
    "essential": true,
    "networkMode": "awsvpc",
    "interactive": true,
    "portMappings": [
      {
        "hostPort": 3000,
        "protocol": "tcp",
        "containerPort": 3000
      }
    ]
  }
]
