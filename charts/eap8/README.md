# Helm Chart for EAP 8

A Helm chart for building and deploying a [JBoss EAP 8](https://www.redhat.com/en/technologies/jboss-middleware/application-platform) application on OpenShift.

## Building and Deploying Applications

The build and deploy steps are configured in separate `build` and `deploy` values.

The input of the `build` step is a Git repository that contains the application code and the output is an `ImageStreamTag` resource that contains the built application image.

The input of the `deploy` step is an `ImageStreamTag` resource that contains the built application image and the output is a `Deployment` and related resources to access the application from inside and outside OpenShift.

To be able to install a Helm release with that chart, you must be able to provide a valid application image.

## Build an Application Image from Source

If the application image must be built from source, the minimal configuration is:

```yaml
build:
  uri: <git repository URL of your application>
```

If the source repository is private, you must have a source secret created in the same namespace where you are building the application which allows athenticating to the repository.  Provide the name of the secret in the build section as follows:

```yaml
build:
  sourceSecret: <name of secret to login to your Git repository>
```

The `build` step will use OpenShift `BuildConfig` to build an application image from this Git repository.

The application must be a Maven project that is configured to use the [`org.jboss.eap.plugins:eap-maven-plugin`](https://github.com/jbossas/eap-maven-plugin/) to provision a JBoss EAP server with the deployed application. The application is built during the S2I assembly by running:

```
mvn -e -Popenshift -DskipTests -Dcom.redhat.xpaas.repo.redhatga -Dfabric8.skip=true --batch-mode -Djava.net.preferIPv4Stack=true -s /tmp/artifacts/configuration/settings.xml -Dmaven.repo.local=/tmp/artifacts/m2  package
```

Any additional Maven arguments can be specified by adding the `MAVEN_ARGS_APPEND` environment variable in the `.build.env` field:

```
build:
  env:
    - name: MAVEN_ARGS_APPEND
      value: "-P my-profile"
```


## Pull an existing Application Image

If your application image already exists, you can skip the `build` step and directly deploy your application image.
In that case, the minimal configuration is:

```yaml
image:
  name: <name of the application image. e.g. "quay.io/example.org/my-app">
  tag: <tag of the applicication image. e.g. "1.3" (defaults to "latest")>
build:
  enabled: false
```

## Working With Private Image Registries

If you are using private image registries to build, push or pull the application image, you need first to create secrets that will allow the container platform where the Helm Chart is deployed to authenticate against the private image registries.

### Pulling the Builder and Runtime Images from a Private Image Registry

This step applies if you build the image on OpenShift and need to pull the builder and runtime base images from an external private image registry.

You must first create a secret that contains the credentials to pull the base image (as explained in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)) and reference it from the `build.pullSecret` field:


```yaml
build:
  pullSecret: my-pull-secret
```

### Pushing the Application Image to a Private Image Registry

This step applies if you build the image with the Helm chart and want to push it to an external image registry.

You must first create a secret that contains the credentials to push the application image (as explained in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)) and reference it from the `build.output.pushSecret` field.
You also need to set the `build.output.kind` field to `DockerImage`.

```yaml
build:
  output:
    kind: DockerImage
    pushSecret: my-push-secret
```

### Pulling the Application Image from a Private Registry

If the application image comes from a private registry that requires authentication, you must first create a secret that contains the credentials to pull the application image (as explained in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)) and reference it from the `deploy.imagePullSecrets` field:

```yaml
image:
  name: quay.io/my-private-group/my-private-image
build:
  enabled: false
deploy:
  imagePullSecrets:
    - name: my-secret-quay-credentials
```

## Application Image

The configuration for the application image that is built and deployed is configured in a `image` section.

| Value | Description | Default | Additional Information |
| ----- | ----------- | ------- | ---------------------- |
| `image.name` | Name of the image you want to build and/or deploy | Defaults to the Helm release name. | The chart will create/reference an `ImageStreamTag` or a `DockerImage` based on this value. |
| `image.tag` | Tag that you want to build/deploy | `latest` | - |

## Building the Application Image

The configuration to build the application image is configured in a `build` section.

If the application image has been built by another mechanism, you can skip the building part of the Helm Chart by setting the `build.enabled` field to `false`.

| Value | Description | Default | Additional Information |
| ----- | ----------- | ------- | ---------------------- |
| `build.contextDir` | The sub-directory where the application source code exists | - | - |
| `build.enabled` | Determines if build-related resources should be created. | `true` | Set this to `false` if you want to deploy a previously built image. Leave this set to `true` if you want to build and deploy a new image. |
| `build.env` | Freeform `env` items | - | [Kubernetes documentation](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/). These environment variables will be used when the application is _built_. If you need to specify environment variables for the running application, use `deploy.env` instead. |
| `build.images`| Freeform images injected in the source during S2I build | - | [OKD API documentation](https://docs.okd.io/latest/rest_api/workloads_apis/buildconfig-build-openshift-io-v1.html#spec-source-images-2) |
| `build.mode` | Determines the mode to build the application image with EAP 8 | `s2i` | Allowed values: `s2i` |
| `build.output.kind`|	Determines if the image will be pushed to an `ImageStreamTag` or a `DockerImage` | `ImageStreamTag` | [OKD API documentation](https://docs.okd.io/latest/rest_api/workloads_apis/buildconfig-build-openshift-io-v1.html#spec-output) |
| `build.output.pushSecret` | Name of the push secret | - | The secret must exist in the same namespace or the chart will fail to install - Used only if `build.output.kind` is `DockerImage` |
| `build.pullSecret` | Name of the pull secret | - | The secret must exist in the same namespace or the chart will fail to install - [OKD API documentation](https://docs.okd.io/latest/rest_api/workloads_apis/buildconfig-build-openshift-io-v1.html#spec-strategy-sourcestrategy) |
| `build.ref` | Git reference (branch, tag, or commit) containing the application you want to build. If unspecified, the default branch from the Git repository is used. | - | - |
| `build.resources` | Freeform `resources` items | - | [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| `build.s2i` | Configuration specific to building with EAP S2I images | - | - |
| `build.s2i.buildApplicationImage` | Whether the application image is built. If `false` the Helm release will only create the builder image (and name it from the Helm release) | `true` | - |
| `build.s2i.builderKind` | Determines the type of images for S2I Builder image (`DockerImage`, `ImageStreamTag` or `ImageStreamImage`) | the value of `build.s2i.kind` | (OKD Documentation](https://docs.okd.io/latest/cicd/|
| `build.s2i.galleonLayers` | A list of layer names to compose a EAP server | - |  [EAP Documentation](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.4/html/getting_started_with_jboss_eap_for_openshift_container_platform/index) |
| `build.s2i.galleonDir` | Directory relative to the root directory for the build that contains custom content for Galleon. | - | [EAP Documentation](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.4/html/getting_started_with_jboss_eap_for_openshift_container_platform/index) |
| `build.s2i.featurePacks` | List of additional Galleon feature-packs identified by Maven coordinates (`<groupId>:<artifactId>:<version>`) | - | The value can be be either a `string` with a list of comma-separated Maven coordinate or an array where each item is the Maven coordinate of a feature pack - [EAP Documentation](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.4/html/getting_started_with_jboss_eap_for_openshift_container_platform/index) |
| `build.s2i.channels` | List of Channels identified by Maven coordinates (`<groupId>:<artifactId>`). If featurePacks are configured without any versioning, the channels that provides the latest feature packs can be specified. Deprecated, the recommended way to provision EAP is to use the eap-maven-plugin in the application pom.xml | - | The value can be be either a `string` with a list of comma-separated Maven coordinate or an array where each item is the Maven coordinate of a channel - [EAP Documentation](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.4/html/getting_started_with_jboss_eap_for_openshift_container_platform/index) |
| `build.s2i.jdk` | JDK Version of the EAP S2I images | `"17"` | Allowed Values: `"17"` |
| `build.s2i.jdk17.builderImage` | EAP S2I Builder image for JDK 17 | `registry.redhat.io/jboss-eap-8/eap8-openjdk17-builder-openshift-rhel8:latest` | [EAP Documentation](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/8.0/html/getting_started_with_jboss_eap_for_openshift_container_platform/index)  |
| `build.s2i.jdk17.runtimeImage` | EAP S2I Runtime image for JDK 17| `registry.redhat.io/jboss-eap-8/eap8-openjdk17-runtime-openshift-rhel8:latest` | [EAP Documentation](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/8.0/html/getting_started_with_jboss_eap_for_openshift_container_platform/index)  |
| `build.s2i.kind` | Determines the type of images for S2I Builder and Runtime images (`DockerImage`, `ImageStreamTag` or `ImageStreamImage`) | `DockerImage` | [OKD Documentation](https://docs.okd.io/latest/cicd/builds/build-strategies.html#builds-strategy-s2i-build_build-strategies) |
| `build.s2i.runtimeKind` | Determines the type of images for S2I Runtime image (`DockerImage`, `ImageStreamTag` or `ImageStreamImage`) | the value of `build.s2i.kind` | [OKD Documentation](https://docs.okd.io/latest/cicd/)|
| `build.sourceSecret`|Name of the secret containing the credentials to login to Git source reposiory | - | The secret must exist in the same namespace or the chart will fail to install - [OKD documentation](https://docs.okd.io/latest/cicd/builds/creating-build-inputs.html#builds-manually-add-source-clone-secrets_creating-build-inputs) |
| `build.triggers.genericSecret`| Name of the secret containing the WebHookSecretKey for the Generic Webhook | - | The secret must exist in the same namespace or the chart will fail to install - [OKD documentation](https://docs.okd.io/latest/cicd/builds/triggering-builds-build-hooks.html) |
| `build.triggers.githubSecret`| Name of the secret containing the WebHookSecretKey for the GitHub Webhook | - | The secret must exist in the same namespace or the chart will fail to install - [OKD documentation](https://docs.okd.io/latest/cicd/builds/triggering-builds-build-hooks.html) |
| `build.uri` | (**required**) Git URI that references your Git repository | https://github.com/jboss-eap-up-and-running/eap8-getting-started | Be sure to specify this to build your own application. |

### Provisioning Jboss EAP With S2I.

The recommended way to provision the JBoss EAP server is to use the `eap-maven-plugin` from the application `pom.xml`.

The `build.s2i.featurePacks`,`build.s2i.galleonLayers`and `build.s2i.channels` fields have been deprecated as they are no longer necessary with this recommendation.

For backwards compatibility, the EAP S2I Builder image still supports these fields to delegate to the provisioning of the server to the `eap-maven-plugin` if it is not configured in the application `pom.xml`.
However if `build.s2i.galleonLayers` is set, `build.s2i.featurePacks` _must_ be specified (including EAP own feature pack `org.jboss.eap:wildfly-ee-galleon-pack`).

## Deploying the Application Image

The configuration to deploy the application image is configured in a `deploy` section.

If the Helm chart is only used to build the application image, you can skip the deploying part of the Helm Chart by setting the `build.deploy` field to `false`.

| Value | Description | Default | Additional Information |
| ----- | ----------- | ------- | ---------------------- |
| `deploy.annotations` | Map of `string` annotations that are applied to the deployment and its pod's `template` | - | [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) |
| `deploy.enabled` | Determines if deployment-related resources should be created. | `true` | Set this to `false` if you do not want to deploy an application image built by this chart. |
| `deploy.env` | Freeform `env` items | - | [Kubernetes documentation](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/).  These environment variables will be used when the application is _running_. If you need to specify environment variables when the application is built, use `build.env` instead. |
| `deploy.envFrom` | Freeform `envFrom` items | - | [Kubernetes documentation](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/).  These environment variables will be used when the application is _running_. If you need to specify environment variables when the application is built, use `build.envFrom` instead. |
| `deploy.extraContainers` | Freeform extra `containers` items | - | [Kubernetes Documentation](https://kubernetes.io/docs/concepts/workloads/pods/#pod-templates) |
| `deploy.imagePullSecrets` | Names of secrets to pull the application image from an private image registry | - | [Kubernetes Documentation](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod) |
| `deploy.initContainers` | Freeform `initContainers` items | - | [Kubernetes Documentation](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) |
| `deploy.labels` | Map of `string` labels that are applied to the deployment and its pod's `template` | - | [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) |
| `deploy.livenessProbe` | Freeform `livenessProbe` field. | HTTP Get on `<ip>:admin/health/live` | [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| `deploy.readinessProbe` | Freeform `readinessProbe` field. | HTTP Get on `<ip>:admin/health/ready` | [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| `deploy.replicas` | Number of pod replicas to deploy. | `1` | [OpenShift Documentation](https://docs.openshift.com/container-platform/latest/applications/deployments/what-deployments-are.html) | 
| `deploy.resources` | Freeform `resources` items | - | [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| `deploy.route` | Configuration specific to teh creation of a `Route` resource to expose the application | - | - |
| `deploy.route.enabled` | Determines if a `Route` should be created | `true` | Allows clients outside of OpenShift to access your application |
| `deploy.route.host` | `host` is an alias/DNS that points to the service. Optional. If not specified a route name will typically be automatically chosen | - | [OpenShift Documentation](https://docs.openshift.com/container-platform/latest/networking/routes/route-configuration.html) |
| `deploy.route.tls.enabled` | Determines if the `Route` should be TLS-encrypted. If `deploy.tls.enabled` is true, the route will use the secure service to acess to the deployment | `true`| [OpenShift Documentation](https://docs.openshift.com/container-platform/latest/networking/routes/secured-routes.html) |
| `deploy.route.tls.insecureEdgeTerminationPolicy` | Determines if insecure traffic should be redirected | `Redirect` | Allowed values: `Allow, Disable, Redirect` |
| `deploy.route.tls.termination` | Determines the type of TLS termination to use | `edge`| Allowed values: `edge, reencrypt, passthrough` |
| `deploy.startupProbe` | Freeform `startupProbe` field. | HTTP Get on `<ip>:admin/health/live` | [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| `deploy.tls.enabled` | Enables the creation of a secure service to access the application. If `true`, JBoss EAP must be configured to enable HTTPS | `false`| |
| `deploy.volumes` | Freeform `volumes` items| - | [Kubernetes Documentation](https://kubernetes.io/docs/concepts/storage/volumes/) |
| `deploy.volumeMounts` | Freeform `volumeMounts` items| - | [Kubernetes Documentation](https://kubernetes.io/docs/concepts/storage/volumes/) |
