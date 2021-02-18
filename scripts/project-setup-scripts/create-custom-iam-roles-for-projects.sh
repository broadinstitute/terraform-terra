#create custom roles in each environment's google project

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195

# org: test.firecloud.org
gcloud iam roles create project-viewer --organization=400176686919 --file=project-viewer.yaml
gcloud iam roles create project-owner --organization=400176686919 --file=project-owner.yaml

# org: firecloud.org
gcloud iam roles create project-viewer --organization=386193000800 --file=project-viewer.yaml
gcloud iam roles create project-owner --organization=386193000800 --file=project-owner.yaml
