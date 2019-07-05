## Setting up your development environment

These steps ensure that you are ready to create infrastructure with these tools:

### Make sure that you have `docker` and `jq` installed locally

On macs, this means

* [install docker for mac](https://docs.docker.com/docker-for-mac/install/)
* `brew install jq`

### Make sure you have access to Vault

Follow the steps in the [dsde-toolbox repo](https://github.com/broadinstitute/dsde-toolbox#authenticating-to-vault)
to configure your Vault access. When Vault is configured correctly, the following
commands should succeed:

```
# list secret paths in the original perf environment
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox vault list secret/dsde/firecloud/perf
# list ephemeral environments
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox vault list secret/dsde/firecloud/ephemeral
# list secret paths in the reference new perf environment
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox vault list secret/dsde/firecloud/ephemeral/broad-wb-perf2
```
