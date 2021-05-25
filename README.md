# CircleCI Demo - ReactJS on ECS
This is a demo project designed to showcase some features of CircleCI's pipelines and its ability to deploy a containerized application to a public cloud provider.  

## Summary 
This repo contains a ReactJS application that displays some images pulled from Reddit.  The app was borrowed from [this repo](https://github.com/CircleCI-Public/circleci-demo-javascript-react-app).  This repo also contains two Terraform plans -- one for handling ECS cluster deployment and  state, and one for handling changes to the Route53 DNS records that point to the AWS load balancer that sits in front of the ECS cluster hosting the containerized ReactJS app.

The pipeline configuration file at .circleci/config.yml will do the following:

1. Checkout this repo from Github
2. Run some tests in parallel against the React code and Terraform code:
    - Node tests
    - Node linting
    - Terraform format check (`fmt`)
    - Terraform linting (`validate`)
3. Build a Docker image containing the app and push the image to AWS ECR
4. Pause for manual approval before continuing
5. Deploy an AWS ECS cluster using Terraform
6. Update the AWS ECS task definition to deploy the new Docker image
7. Update the AWS Route53 DNS records (this will be used when b/g deployments are implemented)

## Requirements

In order for the pipeline to run properly, you need to configure the following variables in a context named `node-demo`:

| Var name | Example | Notes |
|----------|-------------|-------|
AWS_ACCESS_KEY_ID	| random string | [AWS docs](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html)|
AWS_SECRET_ACCESS_KEY	| random string | [AWS docs](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html)|
AWS_ECR_ACCOUNT_URL	| `https://01234567890.dkr.ecr.us-west-1.amazonaws.com` | [AWS ECR docs](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Registries.html)|
AWS_REGION	| `us-west-1` | [AWS regions](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)|
VPC_ID	| `vpc-01234abcd` | ID of the VPC into which you will deploy the ECS cluster. |AWS_RESOURCE_NAME_PREFIX	| `my-demo-app` | Arbitrary name. |
SUBNET_ID_A	| `subnet-abcd1234` | ID of a subnet into which you will deploy the ECS cluster.  The two AWS subnets should be in different regions. |
SUBNET_ID_B	| `subnet-efgh5678`	| ID of a subnet into which you will deploy the ECS cluster.  The two AWS subnets should be in different regions. |
ECS_KEY_PAIR_NAME	| `foobar` | Name of the AWS key pair that Terraform will use when creating the ECS cluster. |
DNS_DOMAIN	|`example.com` | The domain on which the DNS record pointing to the load balancer will be created. |
SLACK_ACCESS_TOKEN | random string | [Slack docs](https://api.slack.com/authentication/basics) |
SLACK_DEFAULT_CHANNEL	| random string | [Helpful Stackexchange thread](https://stackoverflow.com/questions/40940327/what-is-the-simplest-way-to-find-a-slack-team-id-and-a-channel-id) |

 