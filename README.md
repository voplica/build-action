### Build Action

This build action allows to trigger the build & publish workflow of a Docker image.

Parameters:
- `service` (**Required**, *string*) - the name of the service to be used in Azure Docker Registry. Examples: `inferrence`, `api`, `mytestservice`.
- `dispatch_token` (**Required**, *string*) - Token used for a workflow dispatch. Should be `$GH_BUILDS_WORKFLOW_DISPATCH_TOKEN`.
- `encryption_key` (**Required**, *string*) - Public encryption key. Should be: `$GH_BUILDS_RSA_PUBLIC`.
- `tags` (**Required**, *string*) - Docker tags for publish separated by comma. It should either be simple tags representing versions (like: `1.0.0,1.0,latest`) 
  or fully qualified tags which follow convention `voplica/${repository_name}/${service_name}:${tag}`.  
  Example: `voplica/${repository_name}/${service_name}:1.0.0,voplica/${repository_name}/${service_name}:latest`.
- `build_args` (*string*) - List of build-time variables. Example: `arg1=val1,arg2=val2`. Build args are separated by comma.
- `secrets` (*string*) - List of secrets to use for the build process. Example: `secret1=secretValue1,GIT_AUTH_TOKEN=mytoken`. Secret args are separated by comma.
  All tags will be converted to fully qualified tags for publish job. Tags are separated by comma. 
- `labels` (*string*) - Docker image labels for publish. Example: `label1=123,label2=abc`. Labels are separated by comma.
- `docker_file` (*string*) - Relative path to Dockerfile for build process. Default: `./${service}.Dockerfile`.
- `target` (*string*) - Sets the target build stage for Docker image.
- `runs_on` - JSON Array of labels for a GitHub runner selection. You can use `["ubuntu-latest"]` or similar to execute the 
    run on GitHub servers, or use `["self-hosted"]` to execute the job on custom self-hosted runners. Default: `["self-hosted", "X64"]`.

Example:
```yaml
name: Build & Push workflow
on:
  workflow_dispatch:
  push:
    paths-ignore:
      - "docs/**"
      - "README.md"

env:
  SERVICE_NAME: "test_service"

jobs:
  build:
    runs-on: "ubuntu-latest"
    steps:
      - name: Trigger build and push process
        id: docker_build
        uses: voplica/build-action@v1
        with:
          service: ${{ env.SERVICE_NAME }}
          dispatch_token: "${{ secrets.GH_BUILDS_WORKFLOW_DISPATCH_TOKEN }}"
          encryption_key: "${{ secrets.GH_BUILDS_RSA_PUBLIC }}"
          tags: "edge,latest,1.0.0"
          labels: "test_label1=label_value1,test_label2=label_value2"
          build_args: "some_build_arg1=test_value1,some_build_arg2=test_value2"
          secrets: "some_secret1=${{ secrets.SOME_SECRET1 }},some_secret2=${{ secrets.SOME_SECRET2 }}"
          target: "service_final_build_target"
          runs_on: '["self-hosted", "X64"]'
```

###### © 2025 Voplica LLC
