
{{/*
eap8.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdk version.
*/}}
{{- define "eap8.eapBuilderImage" -}}
{{- if eq .Values.build.s2i.jdk "11"  -}}
{{ .Values.build.s2i.jdk11.builderImage}}
{{- else -}}
{{ .Values.build.s2i.jdk17.builderImage}}
{{- end -}}
{{- end -}}

{{/*
eap8.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap8.eapRuntimeImage" -}}
{{- if eq .Values.build.s2i.jdk "11"  -}}
{{ .Values.build.s2i.jdk11.runtimeImage}}
{{- else -}}
{{ .Values.build.s2i.jdk17.runtimeImage}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap8.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "eap8.labels" -}}
helm.sh/chart: {{ include "eap8.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap
{{- end }}

{{- define "eap8.metering.labels" -}}
com.company: "Red_Hat"
rht.prod_name: "Red_Hat_Runtimes"
rht.prod_ver: "2023-Q4"
rht.comp: "EAP"
rht.comp_ver: "8.0"
rht.subcomp_t: "application"
{{- end }}

{{- define "eap8.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap8.labels" . | nindent 4 }}
  {{- include "eap8.metering.labels" . | nindent 4 }}
{{- end -}}

{{- define "eap8.deployment.labels" -}}
metadata:
  labels:
  {{- include "eap8.labels" . | nindent 4 }}
  {{- include "eap8.metering.labels" . | nindent 4 }}
  {{- if .Values.deploy.labels }}
  {{- tpl (toYaml .Values.deploy.labels) . | nindent 4 }}
  {{- end -}}
{{- end -}}