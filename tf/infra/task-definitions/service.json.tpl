[
  {
    "name": "${image_name}-service",
    "image": "${aws_acct_no}.dkr.ecr.${aws_region}.amazonaws.com/${image_name}:${image_tag}",
    "memory": 500,
    "cpu": 256,
    "essential": true,
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "hostPort": 3000,
        "protocol": "tcp",
        "containerPort": 3000
      }
    ]
  }
]
