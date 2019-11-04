# Managing a Terra environment

## Logs
The logs for a Terra environment created with this repo can be found in [Stackdriver](https://console.cloud.google.com/logs/viewer).

Stackdriver has a [fairly robust querying syntax](https://cloud.google.com/logging/docs/view/advanced-queries) for sorting through logs. For example, since for a lot of terra services there are multiple instances of them and it can be nice to see logs from all instances of a specific service, the following advanced log query syntax aggregates together the logs from all SAM instances:
```labels."compute.googleapis.com/resource_name":"sam-"```

## Uptime checks

If the environment profiles were correctly deployed, you will be able to access a dashboard with uptime checks for most of the services via Stackdriver:
`https://app.google.stackdriver.com/uptime?project=[environment project]`

## Updating Configs
Because of how the services are deployed, changes to configuration files directly on an instance will be quickly overwritten. The source of truth for containerized services in these environments are the services' Google buckets. Below are instructions for updating those buckets with new configurations, both ones from git as well as ad-hoc config tweaks:

### Update configs to match a branch of `firecloud-develop`:
1) Make a branch of this repo
2) Update your environment's JSON in your branch, changing one of
   * `global_vars.env.FIRECLOUD_DEVELOP_GIT_BRANCH` to update all services' configs
   * `profile_vars.[service name]-configs.env.FIRECLOUD_DEVELOP_GIT_BRANCH` to update a particular service's configs
3) Push up your branch
4) Run the [update-configs Jenkins job](https://fc-jenkins.dsp-techops.broadinstitute.org/view/Ephemeral%20Envs/job/update-configs/) with
   * `branch` set to your branch
   * `json` set to the filename of your environment's JSON
   * Any services that you want re-deployed with new configs checked in the list of services

### Update configs to match custom local changes:
1) Copy the configs from the bucket
   * `gsutil rsync -r -d gs://[your env project]-[service-name]-config .`
2) Make the desired edits to the configs of the instance(s) you want to target
3) Upload the changes back to the bucket
   * `gsutil rsync -r -d . gs://[your env project]-[service-name]-config`

The changes will be automatically picked up and propagated to the corresponding instances within ~2 minutes. To be certain an instance was updated, either look at its logs or at the logs of the config updating cron job on the instance:
`sudo tail -f /var/log/messages | grep _config`

## Updating Service Versions
For most services(exceptions are Cromwell and Job-Manager), the service version can be configured independently of the configuration. Similarly to config changes, this can be done either via Jenkins and git or in a more ad-hoc manner

### Update service versions+configs to match a JSON in a branch of `terraform-terra`
Skip steps 1-3 if re-deploying a tag/version specified in `master` or another existing branch.
1) Make a branch of this repo
2) Update your environment's JSON in your branch, changing `profile_vars.[service name]-configs.env.SERVICE_GIT_SHA_12_CHAR` to either a 12-character commit hash corresponding to a published docker image of that service (or just any commit if it's not a dockerized service) or an environment tag like `dev`
3) Push up your branch
4) Run the [update-configs Jenkins job](https://fc-jenkins.dsp-techops.broadinstitute.org/view/Ephemeral%20Envs/job/update-configs/) with
   * `branch` set to your branch
   * `json` set to the filename of your environment's JSON
   * Any services that you want re-deployed with new configs/versions checked in the list of services

### Update service version manually
If the service is a containerized, instance-based service, it is possible to update the version that is deployed by following the [steps to update the configs above](#Update-configs-to-match-custom-local-changes) and simply updating the version of image deployed in the docker-compose YAML file.
