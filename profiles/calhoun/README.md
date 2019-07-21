TODOS

- Before you can deploy an app with an actual service name you need to deploy a default app. Once you do this, you can deploy an arbitrary number of namespaced services
- The current SA doesn't have permission to enable APIs, the gae api enable was manual
- The cloud deploy SA needs storage object viewer access. Can probably just be for the bucket. `<project_id>@cloudbuild.gserviceaccount.com`
- Deploy steps are set to always run, limit to when refspec changes by removing `always` trigger
