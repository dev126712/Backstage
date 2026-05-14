module "cloud_run" {
  source = "git::https://github.com/dev126712/terraform-modules.git//serverless-3-Tier?ref=main"

  vpc    = "serverless-app-vpc"
  subnet = "serverless-app-subnet"
  # cloud run configuration
  cloud_run_region              = "${{ values.cloud_run_region }}"
  project_id                    = "${{ values.project_id }}"
  google_cloud_run_service_name = "test-service"

  backend_container_image  = "${{ values.backend_container_image }}"
  frontend_container_image = "${{ values.frontend_container_image }}"

  database_name = "${{ values.database_name }}"
  database_version = "${{ values.database_version }}"
  database_tier = "${{ values.database_tier }}" 
}
