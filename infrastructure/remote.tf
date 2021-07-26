data "terraform_remote_state" "data_pipeline" {
  backend = "s3"
  config = {
    bucket         = var.remote_state_bucket
    dynamodb_table = var.remote_state_db
    region         = var.region
    key            = "data-pipeline.tfstate"
  }
}