## Helm Charts for JBoss EAP

<p align="center">
  <a href="https://helm.sh"><img src="https://helm.sh/img/helm.svg" alt="Helm logo" title="WildFly" height="90"/></a>&nbsp;
  <a href="https://www.redhat.com/en/technologies/jboss-middleware/application-platform"><img src="https://developers.redhat.com/blog/wp-content/uploads/2020/06/Logo-Red_Hat-JBoss_Enterprise_Application_Platform-B-Standard-RGB.png" alt="JBoss EAP logo" title="EAP" height="90"/></a>
</p>

# Install Helm Repository for EAP Charts

The EAP Charts can be installed from [https://jbossas.github.io/eap-charts/](https://jbossas.github.io/eap-charts/)

```
$ helm repo add jboss-eap https://jbossas.github.io/eap-charts/
"jboss-eap" has been added to your repositories

$ helm search repo eap
NAME             	CHART VERSION	APP VERSION	DESCRIPTION                                       
jboss-eap/eap-xp3	1.0.0        	3.0        	Build and Deploy EAP XP3 applications on OpenShift
jboss-eap/eap-xp4	1.0.0        	4.0        	Build and Deploy EAP XP4 applications on OpenShift
jboss-eap/eap74  	1.1.2        	7.4        	Build and deploy JBoss EAP 7.4 applications on ...
jboss-eap/eap8   	1.1.2        	8.0        	Build and deploy JBoss EAP 8 applications on Op...
````

# Install a Helm Release

We can build and deploy the EAP 8.0 [helloworld quickstart](https://github.com/jboss-developer/jboss-eap-quickstarts/tree/8/0.x/helloworld) with this [example file](https://raw.githubusercontent.com/jbossas/eap-charts/eap74/examples/eap74/helloworld-rs/helloworld-rs-app.yaml):

```
$ helm install helloworld-app \
    -f https://raw.githubusercontent.com/jbossas/eap-charts/eap8/examples/helloworld/helm.yaml \
    jboss-eap/eap8
NAME: helloworld-app
LAST DEPLOYED: Tue May  3 10:24:52 2024
STATUS: deployed
REVISION: 1
```

We can build and deploy the EAP 7.4 [helloworld-rs quickstart](https://github.com/jboss-developer/jboss-eap-quickstarts/tree/7.4.x/helloworld-rs) with this [example file](https://raw.githubusercontent.com/jbossas/eap-charts/eap74/examples/eap74/helloworld-rs/helloworld-rs-app.yaml):

```
$ helm install helloworld-rs-app \
    -f https://raw.githubusercontent.com/jbossas/eap-charts/eap74/examples/eap74/helloworld-rs/helloworld-rs-app.yaml \
    jboss-eap/eap74
NAME: helloworld-rs-app
LAST DEPLOYED: Tue Mar  9 11:57:33 2021
STATUS: deployed
REVISION: 1
```

# Documentation

Complete documentation of the `eap8` Chart is available in [its README](https://github.com/jbossas/eap-charts/blob/eap8/charts/eap8/README.md).

Complete documentation of the `eap74` Chart is available in [its README](https://github.com/jbossas/eap-charts/blob/eap74/charts/eap74/README.md).
