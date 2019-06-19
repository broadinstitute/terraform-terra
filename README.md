# terraform-terra

This repo collects the infrastructure required to deploy terra.
It is organized into terraform stacks called profiles.

After cloning it, pull down the deployment scripts with:

```
git submodule init && git submodule update
```

Each profile corresponds to a grouping of infrastructure objects represented
as terraform code. When you deploy a profile, you create the infrastructure
specified in the profile. When you tear down a profile, you destroy it.

To deploy or tear down a profile, you need to supply a JSON configuration
file and optionally an owner name (the configuration file should specify the default owner name,
and if it does you should not specify your own). The JSON configuration specifies the metadata that
terraform needs to run, including the location of the terraform service
account in Vault, the google project name, and the default google region. The
owner name is the person or group responsible for making sure that the
deployed infrastructure is maintained annd removed when no longer needed.

To learn about the semantics of writing and using profiles, see the [docs](https://github.com/broadinstitute/dsp-k8s-deploy)

## What goes into a profile?

A profile represents a single-purpose grouping of infrastructure like a service,
a DNS zone, or a network. A profile _should_ include everything that is owned by 
the group, but _should not_ include things that a different user might want to
supply themselves instead of having built by the module. For instance, a service that
runs on a compute instance and requires a database and DNS record should include
the instance, the database, and the DNS record, because those things are "owned"
by the service. But it should _not_ include a network or a DNS zone. The network and
DNS zone may be required for the service to run, but they aren't owned by it. These
distinctions are subjective and it is expected that use cases and usage patterns will
arise that change the natural boundary around a profile.

## What are profiles for?

Profiles are intended as conveniently-shaped, namespaceable building blocks
of a larger system. 

The resources created by a single profile are managed as a group and have
the same lifecycle. This enables the pieces of a system to be managed
independently with minimal coordination required--a service team should be able
to modify the size of its instances without seeing or affecting unrelated parts
of the system.

A profile represents a particular way of architecting infrastructure.  Rather than
extending a profile to cover two use cases, make a separate profile for the new
use case. If the only profile that exists for deploying a service uses instances,
and you want to prototype a kubernetes deployment, make a new profile. This way
options can be developed in parallel and compared.

The resources created by a profile should be namespaced. As much as possible,
it should be possible to deploy two copies of a profile just by changing the owner name.
This keeps singletons from arising and makes it easier to replicate and share
environments.

By default, different profiles should fit together. If there is a network
profile, all the profiles that require a network should default to using the
network it creates. Each profile should have well-defined requirements and outputs.

## Profiles included in this repo

### `dns`

This profile creates a DNS zone.

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p dns
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p dns
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p dns
```

### `network`

This profile creates a network.

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p network
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p network
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p network
```

### `firewalls`

This profile creates the firewalls that Broad defines. It requires that a network exist
and by  default tries to use the network created by the `network` profile. It is a separate
profile because different organizations may have different firewall requirements.

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p firewalls
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p firewalls
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p firewalls
```

### `ssl`

This profile creates two SSL certificates.

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p ssl
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p ssl
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p ssl
```

### `thurloe-sa`

This profile creates:

1. A thurloe service account for use by Thurloe instances

This profile must be applied with `-a`, which uses your local application default
credentials instead of a terraform service account. To generate your own ADC, run
`gcloud auth application-default login` and follow the instructions.

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p thurloe-sa -a
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p thurloe-sa -a
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p thurloe-sa -a
```

### `thurloe`

This profile creates:

1. A cloudsql database for Thurloe
2. A DNS record pointing to the cloudsql db
3. An instance group with one instance
4. A DNS record for the instancee
5. A config bucket for storing Thurloe configs
6. A load balancer in front of the instance group
7. A DNS record for the load balancer

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p thurloe
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p thurloe
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p thurloe
```

### `thurloe-configs`

This profile:

1. Creates a Vault token
2. Renders the thurloe configs
3. uses `gsutil rsync` to put them in the config bucket created by the `thurloe` profile

```
# deploy example
./dsp-k8s-deploy/application-deploy.sh -j broad-wb-perf2.json -p thurloe-configs
# render example
./dsp-k8s-deploy/application-render.sh -j broad-wb-perf2.json -p thurloe-configs
# teardown example
./dsp-k8s-deploy/application-teardown.sh -j broad-wb-perf2.json -p thurloe-configs
```
