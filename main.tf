resource "aws_vpc" "main" {
  tags       = merge(var.tags, {})
  cidr_block = var.cidr_block
}

resource "aws_autoscaling_group" "app" {
  min_size = var.app_asg_min
  max_size = var.app_asg_max

  launch_template {
    version = "$Latest"
    id      = aws_launch_template.launch_template.id
  }

  load_balancers = [
    aws_elb.app.id,
  ]

  timeouts {
    update = "1h"
    delete = "1h"
  }

  vpc_zone_identifier = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id,
  ]
}

resource "aws_autoscaling_group" "web" {
  min_size = var.web_asg_min
  max_size = var.web_asg_max

  launch_template {
    version = "$Latest"
    id      = aws_launch_template.launch_template.id
  }

  load_balancers = [
    aws_elb.web.id,
  ]

  timeouts {
    update = "1h"
    delete = "1h"
  }

  vpc_zone_identifier = [
    aws_subnet.web_a.id,
    aws_subnet.web_b.id,
  ]
}

resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, { Name = var.app_subnets.a.name })
  cidr_block        = var.app_subnets.a.cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, { Name = var.web_subnets.b.name })
  cidr_block        = var.app_subnets.b.cidr
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "web_a" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, { Name = var.web_subnets.a.name })
  cidr_block        = var.web_subnets.a.cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "web_b" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, { Name = var.web_subnets.b.name })
  cidr_block        = var.web_subnets.b.cidr
  availability_zone = "us-east-1b"
}

resource "aws_route53_zone" "aws_route53_zone_6" {
  tags = merge(var.tags, {})
  name = var.hosted_zone
}

resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.aws_route53_zone_6.id
  type    = "A"
  ttl     = 300
  records = var.a_records
  name    = "a_record"
}

resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.aws_route53_zone_6.id
  type    = "CNAME"
  ttl     = 300
  records = var.domains
  name    = "cname"
}

resource "aws_waf_web_acl" "waf_web_acl" {
  tags        = merge(var.tags, {})
  name        = "webAcl"
  metric_name = "webAcl"
  count       = var.env == "prod" ? 1 : 0

  default_action {
    type = "ALLOW"
  }
}

resource "aws_waf_rule" "aws_waf_rule_10" {
  tags        = merge(var.tags, {})
  name        = "WAFRule"
  metric_name = "WAFRule"
}

resource "aws_waf_ipset" "aws_waf_ipset_11" {
  name = "IPSet"

  ip_set_descriptors {
    value = var.ipset_value
    type  = "IPV4"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, {})
}

resource "aws_elb" "app" {
  tags = merge(var.tags, {})

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  listener {
    lb_protocol       = "http"
    lb_port           = var.app_port
    instance_protocol = "http"
    instance_port     = var.app_port
  }
}

resource "aws_elb" "web" {
  tags                      = merge(var.tags, {})
  cross_zone_load_balancing = true

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  listener {
    lb_protocol       = "http"
    lb_port           = 8080
    instance_protocol = "http"
    instance_port     = 8080
  }
}

resource "aws_nat_gateway" "web_a" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.web_a.id
  allocation_id = aws_eip.web_a.id
}

resource "aws_nat_gateway" "web_b" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.web_b.id
  allocation_id = aws_eip.web_b.id
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, {})
  cidr_block        = var.db_subnets.a.cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  tags              = merge(var.tags, {})
  cidr_block        = var.db_subnets.b.cidr
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "aws_db_subnet_group_18" {
  tags = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id,
  ]
}

resource "aws_rds_cluster" "aws_rds_cluster_19" {
  tags                 = merge(var.tags, {})
  skip_final_snapshot  = true
  master_username      = var.rds_master_username
  master_password      = var.rds_master_password
  engine               = "aurora-postgresql"
  db_subnet_group_name = aws_db_subnet_group.aws_db_subnet_group_18.name
  database_name        = var.rds_db_name

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]
}

resource "aws_s3_bucket" "default" {
  tags   = merge(var.tags, {})
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_eip" "web_a" {
  tags = merge(var.tags, {})
}

resource "aws_eip" "web_b" {
  tags = merge(var.tags, {})
}

resource "aws_launch_template" "launch_template" {
  tags          = merge(var.tags, {})
  instance_type = "t3.medium"
  image_id      = var.image_id
}

