## Cleaning Up An Environment

When you are finished with an environment, or when you want to make sure
an environment is in a known state before you start work on it, you need
to destroy all of the profiles in that environment in the correct order.

Before you begin, make sure you have set up your environment according to
the [Getting Started](./getting-started.md)

### Determining your JSON file

There should be a JSON file for the environment you're trying to clean up
in the root of the repo with the name `<google-project-name>.json`. That is your
JSON file.

### Listing all profiles

The available profiles are in the `profiles` directory. You can list them with

```
ls profiles
```

There is currently no automatic way to determine which profiles are deployed in a given environment.
You need to use the Google console to look for resources or try to delete all of them.

### Identify the service profiles

Each service (e.g. Sam, Thurloe, etc) can have more than one profile.
Most services have the following three profiles:

1. `<service>-sa`: The service account(s) and IAM bindings required by the service
2. `<service>-configs`: The configuration files for the service
3. `<service>`: The rest of the infrastructure for the service

### Identify the non-service profiles

The non-service profiles are those that create shared infrastructure.
As of this writing, the non-service profiles are:

* `populate-vault`: Vault values that must be copied from known-good values to the path specific to your environment.
* `dns`: Create a DNS zone. Not used
* `gsuite`: unused
* `network`: creates the network in which the infrastructure lives. Required by pretty much everything
* `firewalls`: adds firewall rules to the created network. Requires the `network` profile, is required by all the service profiles.
* `ssl`: puts SSL certificates in google and creates an SSL policy for the load balancers. Required by all the service profiles that use load balancers.

### Destroy the service profiles

The service profiles need to be destroyed before the non-service profiles.
These instructions assume the standard profiles for a given service.

#### Destroy the `<service-configs>` profile

```
./dsp-k8s-deploy/application-teardown.sh -j <json-file> -p <service>-configs
```

#### Destroy the `<service>` profile

```
./dsp-k8s-deploy/application-teardown.sh -j <json-file> -p <service>
```

The `<service>` profile requires the `<service>-sa` profile to be deployed.
If you see an error like:

```
data.google_service_account.config_reader: data.google_service_account.config_reader: Error reading Service Account "projects/-/serviceAccounts/broad-wb-rluckom-thurloe@broad-wb-rluckom.iam.gserviceaccount.com": googleapi: Error 403: Permission iam.serviceAccounts.get is required to perform this operation on service account projects/-/serviceAccounts/broad-wb-rluckom-thurloe@broad-wb-rluckom.iam.gserviceaccount.com., forbidden
```

then you need to either verify manually that the `<service>` profile is not deployed
(by looking in the console for the resources it would create) or else you need to
deploy the SA profile with

```
./dsp-k8s-deploy/application-deploy.sh -j <json-file> -p <service>-sa
```

and then retry destroying the `<service>` profile.

#### Destroy the `<service>-sa` profile

After you have destroyed the other two profiles successfully, you can destroy the
`<service>-sa` profile with:

```
./dsp-k8s-deploy/application-teardown.sh -j <json-file> -p <service>-sa
```

#### Destroy the other services

Repeat these steps to destroy all of the service profiiles. For non standard services,
some experimentation may be needed to determine the right order.

### Destroy the non-service profiles

After all the service profiles are destroyed, you should be able to start destroying the
rest of the profiles. Use the same command pattern:

```
./dsp-k8s-deploy/application-teardown.sh -j <json-file> -p <profile>
```

The suggested order is:

* `populate-vault`
* `ssl`
* `firewalls`
* `network`
* `dns`

`gsuite` as yet has no resources so does not need to be destroyed.
