### Build Action

This build action allows to trigger the build & publish workflow of a Docker image.

Parameters:
- `service` (**Required**, *string*) - the name of the service to be used in Azure Docker Registry. Examples: `inferrence`, `api`, `mytestservice`.
- `runs_on` - JSON Array of labels for a GitHub runner selection. You can use `["ubuntu-latest"]` or similar to execute the 
    run on GitHub servers, or use `["self-hosted"]` to execute the job on custom self-hosted runners. Default: `["self-hosted", "X64"]`.
- `docker_file` (*string*) - Relative path to Dockerfile for build process. Default: `./${service}.Dockerfile`.
- `target` (*string*) - Sets the target build stage for Docker image.
- `build_args` (*string*) - List of build-time variables. Example: `arg1=val1,arg2=val2`. Build args are separated by comma.
- `secrets` (*string*) - List of secrets to use for the build process. Example: `secret1=secretValue1,GIT_AUTH_TOKEN=mytoken`. Secret args are separated by comma.
- `tags` (*string*) - Docker tags for publish. It should either be simple tags representing versions (like: `1.0.0,1.0,latest`) 
  or fully qualified tags which follow convention `voplica/${repository_name}/${service_name}:${tag}`.  
  Example: `voplica/${repository_name}/${service_name}:1.0.0,voplica/${repository_name}/${service_name}:latest`.   
  All tags will be converted to fully qualified tags for publish job. Tags are separated by comma. 
- `labels` (*string*) - Docker image labels for publish. Example: `label1=123,label2=abc`. Labels are separated by comma.
- `token` (*string*) - Token used for a workflow dispatch.

###### © 2025 Voplica LLC.
