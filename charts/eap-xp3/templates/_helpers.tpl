
{{/*
eap-xp3.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdkVersion.

TODO: the build.s2i.arch is not used and is hard-coded to "amd64".
When we add support for Z-Series and PowerPC, we will rely on the value of build.s2i.arch
to get the proper S2I images (and validate that only jdk11 can be used with Z & P)
*/}}
{{- define "eap-xp3.eapBuilderImage" -}}
{{ .Values.build.s2i.amd64.jdk11.builderImage}}:{{ include "eap-xp3.version" . }}
{{- end -}}

{{/*
eap-xp3.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap-xp3.eapRuntimeImage" -}}
{{ .Values.build.s2i.amd64.jdk11.runtimeImage}}:{{ include "eap-xp3.version" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap-xp3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
If build.s2i.version is not defined, use by defaul the Chart's appVersion
*/}}
{{- define "eap-xp3.version" -}}
{{- default .Chart.AppVersion .Values.build.s2i.version -}}
{{- end -}}


{{- define "eap-xp3.labels" -}}
helm.sh/chart: {{ include "eap-xp3.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/version: {{ quote .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap-xp
{{- end }}

{{- define "eap-xp3.metering.labels" -}}
com.company: "Red_Hat"
com.redhat.product-name: "Red_Hat_Runtimes"
com.redhat.product-version: "2021-Q3"
com.redhat.component-name: EAP_XP
com.redhat.component-version: {{ quote .Chart.AppVersion }}
com.redhat.component-type: application
{{- end }}

{{- define "eap-xp3.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap-xp3.labels" . | nindent 4 }}
  {{- include "eap-xp3.metering.labels" . | nindent 4 }}
{{- end -}}