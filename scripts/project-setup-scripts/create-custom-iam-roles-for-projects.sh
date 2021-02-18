#create custom roles in each environment's google project

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195

gcloud iam roles create project-viewer --project=broad-dsde-dev --file=project-viewer.yaml
gcloud iam roles create project-owner --project=broad-dsde-dev --file=project-owner.yaml

gcloud iam roles create project-viewer --project=broad-dsde-qa --file=project-viewer.yaml
gcloud iam roles create project-owner --project=broad-dsde-dev --file=project-owner.yaml

gcloud iam roles create project-viewer --project=broad-dsde-perf --file=project-viewer.yaml
gcloud iam roles create project-owner --project=broad-dsde-dev --file=project-owner.yaml

gcloud iam roles create project-viewer --project=broad-dsde-alpha --file=project-viewer.yaml
gcloud iam roles create project-owner --project=broad-dsde-dev --file=project-owner.yaml

gcloud iam roles create project-viewer --project=broad-dsde-staging --file=project-viewer.yaml
gcloud iam roles create project-owner --project=broad-dsde-dev --file=project-owner.yaml

gcloud iam roles create project-viewer --project=broad-dsde-prod --file=project-viewer.yaml
gcloud iam roles create project-owner --project=broad-dsde-dev --file=project-owner.yaml
