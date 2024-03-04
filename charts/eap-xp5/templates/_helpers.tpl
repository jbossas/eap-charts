
{{/*
eap-xp5.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdk version.
*/}}
{{- define "eap-xp5.eapBuilderImage" -}}
{{ .Values.build.s2i.jdk17.builderImage}}
{{- end -}}

{{/*
eap-xp5.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap-xp5.eapRuntimeImage" -}}
{{ .Values.build.s2i.jdk17.runtimeImage}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap-xp5.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "eap-xp5.labels" -}}
helm.sh/chart: {{ include "eap-xp5.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap
{{- end }}

{{- define "eap-xp5.metering.labels" -}}
com.company: "Red_Hat"
rht.prod_name: "Red_Hat_Runtimes"
rht.prod_ver: "2024-Q1"
rht.comp: "EAP_XP"
rht.comp_ver: {{ quote .Chart.AppVersion }}
rht.subcomp_t: "application"
{{- end }}

{{- define "eap-xp5.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap-xp5.labels" . | nindent 4 }}
  {{- include "eap-xp5.metering.labels" . | nindent 4 }}
{{- end -}}

{{- define "eap-xp5.deployment.labels" -}}
metadata:
  labels:
  {{- include "eap-xp5.labels" . | nindent 4 }}
  {{- include "eap-xp5.metering.labels" . | nindent 4 }}
  {{- if .Values.deploy.labels }}
  {{- tpl (toYaml .Values.deploy.labels) . | nindent 4 }}
  {{- end -}}
{{- end -}}