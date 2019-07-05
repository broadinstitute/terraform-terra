## Setting Up A Deployment

Before starting, make sure you have completed [setting up your environment](./quickstarts/getting-started.md)
and [cleaening up your environment](./quickstarts/cleaning-up-an-environment.md).

### Deploying profiles

For an introduction to deploying profiles, see [Working with profiles](https://github.com/broadinstitute/dsp-k8s-deploy/blob/master/using-existing-profiles-quickstart.md#working-with-profiles) 

### Deploy the shared profiles

Before you can deploy your service(s), you will need to deploy the shared
profiles that they need. The recommended order for deploying the shared profiles is:

1. `network`
2. `firewalls`
3. `ssl`
4. `populate-vault`

These are the only shared profiles you should need for any service so far.

### Deploy the service profiles

For each service you want to deploy, there will likely be three profiles:

1. `<service>-sa`: The service account and iam requirements. Deploy this first.
2. `<service>`: The non-IAM resources. Deploy this second.
3. `<service>-configs`: The configuration files that tell the service how to use the resources in its environment. Deploy this last.

Once you have deployed all the services you want, your environment should be ready to use.
