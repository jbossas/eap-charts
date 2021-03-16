# eap-charts
Helm Charts for Red Hat JBoss Enterprise Application Platform

## Prerequisites
Below are prerequisites that may apply to your use case.

### Pull Secret
You will need to create a pull secret if you pull the EAP S2I builder image. Use the following command as a reference to create your pull secret:
```bash
oc create secret docker-registry my-pull-secret --docker-server=registry.redhat.io --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL
```

You can use this secret by passing `--set build.pullSecret=my-pull-secret` to `helm install`, or you can configure this in a values file:
```yaml
build:
  pullSecret: my-pull-secret
```
and apply by passing `-f $VALUES_FILE`.

# Examples

The [examples](./examples/) directory contains examples of EAP applications deployed with Helm Charts