module "rds" {
  # source  = "app.terraform.io/insideinfo-jinsu/rds-module/aws"
  # version = "1.0.2"
  # source  = "app.terraform.io/insideinfo-jinsu/rds-module-branch/aws"
  # version = "1.0.0"
  source = "terraform-aws-modules/rds/aws"
  # version = "5.9.0"

  identifier = "kb-capital-rds"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  storage_type      = "gp3"
  allocated_storage = 20

  db_name  = "demodb"
  username = "admin"
  password = "pa$$w0rd"
  port     = "3306"

  db_instance_tags = {
    Option = "test"
  }

  #   iam_database_authentication_enabled = true

  #   vpc_security_group_ids = ["sg-12345678"]
  vpc_security_group_ids = [aws_security_group.all.id]

  #   maintenance_window = "Mon:00:00-Mon:03:00"
  #   backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  #   monitoring_interval    = "30"
  #   monitoring_role_name   = "MyRDSMonitoringRole"
  #   create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.common.ids
  #   subnet_ids             = ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

