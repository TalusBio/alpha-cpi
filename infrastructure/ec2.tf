resource "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = "p3.2xlarge"

  user_data = templatefile("user_data.tpl", { efs_file_system_id = data.terraform_remote_state.data_pipeline.outputs.efs_file_system_id })

  key_name               = var.aws_key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 200
  }

  tags = {
    Name    = "alpha-cpi"
    owner   = var.owner
    project = var.project_name
  }
}