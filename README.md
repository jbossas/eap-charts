# eap-charts
Helm Charts for Red Hat JBoss Enterprise Application Platform (EAP) 8.2

## Install Helm Repository for EAP Charts

The `eap82` Chart can be installed from the [https://jbossas.github.io/eap-charts/](https://jbossas.github.io/eap-charts/) repository

```
$ helm repo add jboss https://jbossas.github.io/eap-charts/
"jboss" has been added to your repositories
$ helm search repo jboss
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
jboss/eap82            	1.0.0           8.2	           	Build and deploy EAP 8.2 applications on OpenShift
````

## EAP 8.2 Charts docs

* A complete documentation of the `eap82` Chart is available in [charts/eap82/](./charts/eap82/README.md).
