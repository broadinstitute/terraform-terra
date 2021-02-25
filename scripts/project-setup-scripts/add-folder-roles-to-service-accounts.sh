# set up folder access for Rawls and Cromwell SAs as editor roles
# must have resourcemanager.projects.setIamPolicy permissions

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195


# env: dev
# folder: test.firecloud.org/dev
gcloud resource-manager folders add-iam-policy-binding 599966635789 --member=serviceAccount:806222273987-ksinuueghug8u81i36lq8aof266q19hl@developer.gserviceaccount.com --role=roles/editor
gcloud resource-manager folders add-iam-policy-binding 599966635789 --member=serviceAccount:806222273987-gffklo3qfd1gedvlgr55i84cocjh8efa@developer.gserviceaccount.com --role=roles/editor

# env: qa
# folder: test.firecloud.org/tools (no QA folder)
gcloud resource-manager folders add-iam-policy-binding 950154083315 --member=serviceAccount:rawls-qa@broad-dsde-qa.iam.gserviceaccount.com --role=roles/editor
gcloud resource-manager folders add-iam-policy-binding 950154083315 --member=serviceAccount:cromwell-qa@broad-dsde-qa.iam.gserviceaccount.com --role=roles/editor

# env: perf
# folder: test.firecloud.org/perf
gcloud resource-manager folders add-iam-policy-binding 1076814209841 --member=serviceAccount:rawls-perf@broad-dsde-perf.iam.gserviceaccount.com --role=roles/editor
gcloud resource-manager folders add-iam-policy-binding 1076814209841 --member=serviceAccount:cromwell@broad-dsde-perf.iam.gserviceaccount.com --role=roles/editor

# env: alpha
# folder: test.firecloud.org/alpha
gcloud resource-manager folders add-iam-policy-binding 829384679571 --member=serviceAccount:1020846292598-oaqbfcouk55k9bds068iq9osugaddt5v@developer.gserviceaccount.com --role=roles/editor
gcloud resource-manager folders add-iam-policy-binding 829384679571 --member=serviceAccount:1020846292598-ob6vbm8mrl5akcusa6tadhmrh0cdmqi0@developer.gserviceaccount.com --role=roles/editor

# env: staging
# folder: test.firecloud.org/staging
gcloud resource-manager folders add-iam-policy-binding 362889920837 --member=serviceAccount:44976466195-ic7tfqh2s0pn1v46nlc46c0gau6e8n60@developer.gserviceaccount.com --role=roles/editor
gcloud resource-manager folders add-iam-policy-binding 362889920837 --member=serviceAccount:44976466195-nv2hrk6imhfccg4lftjd8p683hdampa1@developer.gserviceaccount.com --role=roles/editor

# todo: to be completed as part of https://broadworkbench.atlassian.net/browse/CA-1194
# env: prod
# folder: firecloud.org/prod
#gcloud resource-manager folders add-iam-policy-binding FOLDER --member=serviceAccount:rawls-prod@broad-dsde-prod.iam.gserviceaccount.com --role=roles/editor
#gcloud resource-manager folders add-iam-policy-binding FOLDER --member=serviceAccount:cromwell-prod@broad-dsde-prod.iam.gserviceaccount.com --role=roles/editor
