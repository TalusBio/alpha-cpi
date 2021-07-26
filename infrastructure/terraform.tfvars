# Account
region       = "us-west-2"
project_name = "alpha_cpi"
accountId    = "622568582929"

# Remote State
remote_state_bucket = "talus-remote-state-bucket"
remote_state_db     = "talus-remote-state-locks"

# Instance
ami_id            = "ami-08c6f8e3871c56139" # us-west-2, deep learning ami, ubuntu
availability_zone = "us-west-2b"

# Networking
subnet_id         = "subnet-49fe0c03"
security_group_id = "sg-0f2ec03b5a36cf3f9"
aws_key_name      = "parallelcluster"

# Tags
owner = "Rico Meinl"