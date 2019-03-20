# Gitlab Kubernetes Deployer
Project for storing a docker container that we use for deploying from our CI/CD scripts in GitLab to our Kubernetes Cluster. 


# Scripts

## generate-values.file
When environment variables are stored in gitlab's dashboard, we have to follow a custom approach to set different values for a variable depending on the app environment.

lets say we need a `GOOGLE_ANALYTICS_KEY` as an environment variable.

the key has to be different for beta and production.

so, we append a suffix to the variable name.

this will result in:

`GOOGLE_ANALYTICS_KEY_BETA = betakey`

`GOOGLE_ANALYTICS_KEY_PRODUCTION = productionkey`

since the variable names have changed, this script has to get the environment name from the job configuration.

```yaml
production:
  environment:
    name: production
```

and use it to retrieve the value by using `GOOGLE_ANALYTICS_KEY + CI_ENVIRONMENT_NAME`.

once we have the value we will write those in their original form to a values.yaml which is used by helm.

```yaml
# values.yaml
GOOGLE_ANALYTICS: productionkey
```

## login-in-gitlab

syntax sugar for login to gitlab's regitry.


##  setup-k8s

Initially we only support connection to the cluster via a bastion host, the ssh private key and ssh configuration should be stored as a environment variable in the group settings with the following names `AMIGOBUILD_PRIVATE_KEY` and `SSH_GOLD_CONFIG`  respectively. 

with this in place, we can create an ssh tunnel and execute commands to that process.

configuration files are exposed thorugh gitlab's environment variables once we [connect the cluster to the project](https://docs.gitlab.com/ee/user/project/clusters/#adding-an-existing-kubernetes-cluster).

since this file will be used to deploy, by default we create a namespace and allow pulling images from a private registry.