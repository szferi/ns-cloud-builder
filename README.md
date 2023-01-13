# Google Cloud Builder Image for Namespace

This builder can be used to run the Namespace tool in Google Cloud Build service.
You can read more information about the Namespace here: https://namespace.so/

## Building this builder

To build this builder, run the following command in this directory.

```shell
$ gcloud builds submit . --config=cloudbuild.yaml
```

The builder creates two different images. One for the latest official release and one for the source HEAD.

## Usage of the builder

The Cloud builder should have the following permissions:

-   to full access Kubernetes API by at least with the `Kubernets Engine Admin` role.
-   to access the artifact registry `Artifact Registry Administrator` role.

The envionment variable `CI` should be set to true to tell NS it is running on a CI-like environment.

Use the `--gcloud_use_host_binary` global flag to tell NS to use the `gcloud` command available in the image
instead of downloading and running its own version inside a sub-docker image. Missing this can lead to authentication errors.

An example `cloudbuild.yaml` file:

```yaml
steps:
    # Make sure the cluster is configured for NS
    - name: "gcr.io/${PROJECT_ID}/ns"
      args:
          - "--gcloud_use_host_binary"
          - "prepare"
          - "gke"
          - "--env=${_NS_ENV}"
          - "--cluster=${_NS_CLUSTER}"
          - "--project_id=${PROJECT_ID}"
          - "--experimental_use_gclb"

    # optional preparation for in-cluster build
    - name: "gcr.io/${PROJECT_ID}/ns"
      args:
          - "--gcloud_use_host_binary"
          - "prepare-build-cluster"
          - "--env=${_NS_ENV}"

    # deploy a server
    - name: "gcr.io/${PROJECT_ID}/ns"
      args:
          - "--gcloud_use_host_binary"
          - "deploy"
          - "--env=${_NS_ENV}"
          - "${_NS_SERVER}"

substititions:
    _NS_ENV: "dev"
    _NS_CLUSTER: "cluster"
    _NS_SERVER: "server"
```

You should subsitute the `_NS_ENV`, `_NS_SERVER` and `_NS_CLUSTER` parameters and their defaults with the proper ones.
