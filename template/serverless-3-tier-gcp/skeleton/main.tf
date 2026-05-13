module "cloud_run" {
  source = "git::https://github.com/dev126712/terraform-modules.git//serverless-3-Tier?ref=main"

  vpc    = "serverless-app-vpc"
  subnet = "serverless-app-subnet"
  # cloud run configuration
  cloud_run_region              = "${{ values.cloud_run_region }}"
  project_id                    ="${{ values.project_id }}"
  google_cloud_run_service_name = "test-service"

  backend_container_image  = "us-central1-docker.pkg.dev/project-test-490416/app-images/backend:latest3"
  frontend_container_image = "us-central1-docker.pkg.dev/project-test-490416/app-images/frontend:latest3"

  database_name = "app-db-instance"
  database_version = "POSTGRES_15"
  database_tier = "db-f1-micro" 
}
