[
  {
    "name": "${image_name}-service",
    "image": "${aws_acct_no}.dkr.ecr.${aws_region}.amazonaws.com/${image_name}:${image_tag}",
    "memory": 200,
    "cpu": 10,
    "essential": true,
    "portMappings": [
      {
        "hostPort": 3000,
        "protocol": "tcp",
        "containerPort": 3000
      }
    ]
  }
]
