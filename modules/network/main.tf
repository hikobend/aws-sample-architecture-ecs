module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  cidr                    = var.cidr
  azs                     = var.azs
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  public_subnet_names     = ["${var.env}-public-subnet-1a", "${var.env}-public-subnet-1c"]
  private_subnet_names    = ["${var.env}-private-subnet-1a", "${var.env}-private-subnet-1c"]
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = true
  one_nat_gateway_per_az  = true
  map_public_ip_on_launch = true

  vpc_tags                 = { Name = "${var.env}-vpc" }
  public_route_table_tags  = { Name = "${var.env}-route-table-public" }
  private_route_table_tags = { Name = "${var.env}-route-table-private" }
  igw_tags                 = { Name = "${var.env}-internet-gateway" }
  nat_gateway_tags         = { Name = "${var.env}-nat-gateway" }
  nat_eip_tags             = { Name = "${var.env}-elatic-ip" }
}

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "security-group"
  description = "security-group"
  vpc_id      = module.network.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}

# # ロググループ
# resource "aws_cloudwatch_log_group" "log_nginx" {
#   name = "/ecs/nginx"
# }

# resource "aws_cloudwatch_log_group" "log_connect_client" {
#   name = "/ecs/svccon-client"
# }

# resource "aws_cloudwatch_log_group" "log_connect_server" {
#   name = "/ecs/svccon-server"
# }

# # ECSタスクロール
# data "aws_iam_policy_document" "ecs_task_doc" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "task_role" {
#   name               = "nginx-task-role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
# }

# data "aws_iam_policy_document" "ecs_exec_doc" {
#   ## SSMサービス関連のアクセス許可
#   version = "2012-10-17"
#   statement {
#     effect = "Allow"
#     actions = [
#       "ssmmessages:CreateControlChannel",
#       "ssmmessages:CreateDataChannel",
#       "ssmmessages:OpenControlChannel",
#       "ssmmessages:OpenDataChannel"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "ecs_exec_policy" {
#   name   = "AmazonECSExecPolicy"
#   policy = data.aws_iam_policy_document.ecs_exec_doc.json
# }

# resource "aws_iam_role_policy_attachment" "task_attachement" {
#   role       = aws_iam_role.task_role.name
#   policy_arn = aws_iam_policy.ecs_exec_policy.arn
# }

# # ECSタスク実行ロール
# resource "aws_iam_role" "execution_role" {
#   name               = "nginx-execution-role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
# }

# resource "aws_iam_role_policy_attachment" "execution_attachement" {
#   role       = aws_iam_role.execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# # タスク定義
# resource "aws_ecs_task_definition" "client-task" {
#   family                   = "nginx-task"
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   task_role_arn            = aws_iam_role.task_role.arn
#   execution_role_arn       = aws_iam_role.execution_role.arn
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = <<-EOS
#   [
#     {
#       "name": "nginx-container",
#       "image": "nginx:latest",
#       "essential": true,
#       "memory": 128,
#       "portMappings": [
#         {
#           "name": "webclient",
#           "protocol": "tcp",
#           "containerPort": 80,
#           "appProtocol": "http"
#         }
#       ],
#       "logConfiguration": {
#         "logDriver": "awslogs",
#         "options": {
#           "awslogs-group": "/ecs/nginx",
#           "awslogs-region": "ap-northeast-1",
#           "awslogs-stream-prefix": "nginx"
#         }
#       }
#     }
#   ]
#   EOS
# }

# # タスク定義
# resource "aws_ecs_task_definition" "server-task" {
#   family                   = "nginx-task"
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   task_role_arn            = aws_iam_role.task_role.arn
#   execution_role_arn       = aws_iam_role.execution_role.arn
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = <<-EOS
#   [
#     {
#       "name": "nginx-container",
#       "image": "nginx:latest",
#       "essential": true,
#       "memory": 128,
#       "portMappings": [
#         {
#           "name": "webserver",
#           "protocol": "tcp",
#           "containerPort": 80,
#           "appProtocol": "http"
#         }
#       ],
#       "logConfiguration": {
#         "logDriver": "awslogs",
#         "options": {
#           "awslogs-group": "/ecs/nginx",
#           "awslogs-region": "ap-northeast-1",
#           "awslogs-stream-prefix": "nginx"
#         }
#       }
#     }
#   ]
#   EOS
# }

# # クラスター
# resource "aws_ecs_cluster" "cluster" {
#   name = "test-cluster"
# }

# # 名前空間
# resource "aws_service_discovery_http_namespace" "namespace" {
#   name = "test-namespace"
# }


# # サービス(クライアント側)
# resource "aws_ecs_service" "client" {
#   name                   = "nginx-client"
#   cluster                = aws_ecs_cluster.cluster.arn
#   task_definition        = aws_ecs_task_definition.client-task.arn
#   desired_count          = 1
#   launch_type            = "FARGATE"
#   platform_version       = "1.4.0"
#   enable_execute_command = true

#   network_configuration {
#     assign_public_ip = true
#     security_groups  = [module.sg.security_group_id]
#     subnets          = [module.network.public_subnets[0], module.network.public_subnets[1]]
#   }

#   service_connect_configuration {
#     enabled = true

#     log_configuration {
#       log_driver = "awslogs"
#       options = {
#         awslogs-group         = "/ecs/svccon-client"
#         awslogs-region        = "ap-northeast-1"
#         awslogs-stream-prefix = "svccon-client"
#       }
#     }

#     namespace = aws_service_discovery_http_namespace.namespace.arn
#   }
# }

# # サービス(サーバー側)
# resource "aws_ecs_service" "server" {
#   name                   = "nginx-server"
#   cluster                = aws_ecs_cluster.cluster.arn
#   task_definition        = aws_ecs_task_definition.server-task.arn
#   desired_count          = 1
#   launch_type            = "FARGATE"
#   platform_version       = "1.4.0"
#   enable_execute_command = true

#   network_configuration {
#     assign_public_ip = true
#     security_groups  = [module.sg.security_group_id]
#     subnets          = [module.network.public_subnets[0], module.network.public_subnets[1]]
#   }

#   service_connect_configuration {
#     enabled = true

#     log_configuration {
#       log_driver = "awslogs"
#       options = {
#         awslogs-group         = "/ecs/svccon-server"
#         awslogs-region        = "ap-northeast-1"
#         awslogs-stream-prefix = "svccon-server"
#       }
#     }

#     namespace = aws_service_discovery_http_namespace.namespace.arn

#     service {
#       client_alias {
#         port = 80
#       }
#       port_name = "webserver"
#     }
#   }
# }


# ALB(https)
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-alb-sg"
  description = "ALB security group"
  vpc_id      = module.network.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.frontend_sg.security_group_id
    }
  ]
}

module "frontend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-frontend-sg"
  description = "Frontend security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.backend_sg.security_group_id
    }
  ]
}

module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-backend-sg"
  description = "Backend security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.frontend_sg.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.database_sg.security_group_id
    },
    {
      rule                     = "all-all"
      source_security_group_id = module.elasticache_sg.security_group_id
    }
  ]
}

module "database_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-database-sg"
  description = "Database security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.backend_sg.security_group_id
    }
  ]
}

module "elasticache_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-elasticache-sg"
  description = "Elasticache security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.backend_sg.security_group_id
    }
  ]
}
