## Contributing to terraform-terra

Contributions to this repo can involve a number of moving parts, including

* Config updates in other repos
* Terraform modules in other repos
* Deployed infrastructure and terraform state files in multiple projects / deployments
* Updates to deployment JSON files

To use these effectively, we need to strike a balance between the ability to experiment
freely and the need to reliably and continuously support a specific set of use cases.
These best practices are an attempt to articulate that balance.

### Local development

This repository consists of tools for deploying infrastructure. To develop in it
locally, you need to be able to create infrastructure. This means sharing access to
deployment accounts (GCP, Docker, Github, etc.). There are currently three GCP projects
set up; `broad-wb-malkov` and `broad-wb-rluckom` are primarily for development and
experimentation, while `broad-wb-perf2` is intended as the reference deployment
of the overall architecture.

When you are developing locally, you will need to coordinate with anyone
else who is using the same project _and_ profile as you. If you don't know 
whether anyone else is working on a profile in a project, ask in the `#terra-pwg`
Slack channel. 

Since even local development affects shared state, we encourage frequent check-ins
and PRs. The more up-to-date we keep the master branch, the easier it will be
for everyone to share the infrastructure it specifies.

If you are new to terraform, you can expect that a) things will sometimes go wrong;
and b) they will tend to be easily recoverable. This structure is designed to
facilitate learning infrastructure by experimentation while minimizing the
cost of mistakes. To get help, ask in Slack with a description of your goal
and current challenges.

### Before PR

* You have deployed your change somewhere and verified that it works
* Any supporting code (configs, terraform modules) has been pushed to the relevant repos and PRs opened for it.
* You have identified the security-relevant aspects of your change and can describe them for the reviewers.

### Before merging

* Any supporting code is merged
* References to supporting code have been updated to canonical tag / branch names
* A reference version of the infrastructure has been deployed in `broad-dsde-perf2`
* Any security issues that arose during review have been addressed to SecOps' satisfaction.
