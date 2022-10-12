# eap-charts
Helm Charts for Red Hat JBoss Enterprise Application Platform 8 (EAP 8)

## Install Helm Repository for WildFly Charts

The `eap8` Chart can be installed from the [https://jbossas.github.io/eap-charts/](https://jbossas.github.io/eap-charts/) repository

```
$ helm repo add jboss https://jbossas.github.io/eap-charts/
"jboss" has been added to your repositories
$ helm search repo jboss
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
jboss/eap8            	1.0.0-beta.0       	           	Build and deploy EAP 8 applications on OpenShift
````

## EAP8 Charts docs

* A complete documentation of the `eap8` Chart is available in [charts/eap8/](./charts/eap8/README.md).
