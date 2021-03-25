## Helm Charts for JBoss EAP

<p align="center">
  <a href="https://helm.sh"><img src="https://helm.sh/img/helm.svg" alt="Helm logo" title="WildFly" height="90"/></a>&nbsp;
  <a href="https://www.redhat.com/en/technologies/jboss-middleware/application-platform"><img src="https://developers.redhat.com/blog/wp-content/uploads/2020/06/Logo-Red_Hat-JBoss_Enterprise_Application_Platform-B-Standard-RGB.png" alt="JBoss EAP logo" title="EAP" height="90"/></a>
</p>

# Install Helm Repository for EAP Charts

The `eap74` Chart can be installed from [https://jbossas.github.io/eap-charts/](https://jbossas.github.io/eap-charts/)

```
$ helm repo add jboss-eap https://jbossas.github.io/eap-charts/
"jboss-eap" has been added to your repositories

$ helm search repo eap
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
jboss-eap/eap74         1.0.0           7.4             A Helm chart to build and deploy EAP 7.4 applic...
````

# Install a Helm Release

We can build and deploy the [helloworld-rs quickstart](https://github.com/jboss-developer/jboss-eap-quickstarts/tree/7.4.x/helloworld-rs) with this [example file](https://raw.githubusercontent.com/jbossas/eap-charts/main/examples/eap7/helloworld-rs/helloworld-rs-app.yaml):

```
$ helm install helloworld-rs-app \
    -f https://raw.githubusercontent.com/jbossas/eap-charts/main/examples/eap74/helloworld-rs/helloworld-rs-app.yaml \
    jboss-eap/eap74
NAME: helloworld-rs-app
LAST DEPLOYED: Tue Mar  9 11:57:33 2021
STATUS: deployed
REVISION: 1
```

# Documentation

A complete documentation of the `eap7` Chart is available in [its README](https://github.com/jbossas/eap-charts/blob/main/charts/eap74/README.md).
