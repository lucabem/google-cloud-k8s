<div align="center">
<img align="center"  width="auto" height="auto" src="https://nuwe.io/images/Group-3-3.png" />
<br/>

<div id="user-content-toc">
  <ul>
    <summary><h1 style="display: inline-block;">Vue - Vite Skeleton</h1></summary>
  </ul>
</div>

</div>

## Vue/Vite Skeleton

<br/>

This repository is a Typescript & Javascript skeleton with Vue, designed for
quickly getting started developing a web application. Check the [Getting Started](#getting-started) for full details.

## Technologies

- [Typescript 4.7](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-4.html)
- [Vue 3](https://vuejs.org/)
- [Vitest](https://vitest.dev/)
- [ESLint](https://eslint.org/)
- [Yarn](https://yarnpkg.com/)
- [Docker](https://www.docker.com/)
- [Make](https://www.gnu.org/software/make/manual/make.html)

## Getting Started
### Docker-Compose
I have created two services for docker-compose. First one, named local, will generate docker image from current repo's state.
```
docker-compose up local
```
The second one will pull from Artifact Registry the Docker's Image
```
docker-compose up pro
```
### Cloud Storage Bucket with TF-STATE
In order to keep tf-state remote using GCP, we need to create an Bucket where we will save tfstate
```
gsutil mb gs://${PROJECT_ID}-tfstate
gsutil versioning set on gs://${PROJECT_ID}-tfstate
```

The we initialize backend using this bucket
```
  backend "gcs" {
    bucket = "${PROJECT_ID}-tfstate"
    prefix = "state"
  }
```

### Terraform
Commands to genereate the solution via Terraform:
```
terraform init
terraform plan
terraform apply
```

If you want to deploy K8S resources via Teraform, you should replace ci/cloud-build.yaml to lines with #. POD will be failing until you generate
first version of Docker Image


### Deploy Web
Each time you generate and push a new tag, CloudBuild will creates a new docker image with that tag and replace it on YAML's POD resource. 

Notice that you should approve it before CloudBuild starts (it could be setted to false in 030_cloid_service_trigger tf file)