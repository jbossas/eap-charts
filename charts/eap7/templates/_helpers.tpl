
{{/*
eap7.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap7.eapBuilderImage" -}}
{{- if eq .Values.build.s2i.jdk "8"  -}}
{{ .Values.build.s2i.jdk8.builderImage}}:{{ include "eap7.version" . }}
{{- else -}}
{{ .Values.build.s2i.jdk11.builderImage}}:{{ include "eap7.version" . }}
{{- end -}}
{{- end -}}

{{/*
eap7.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap7.eapRuntimeImage" -}}
{{- if eq .Values.build.s2i.jdk "8"  -}}
{{ .Values.build.s2i.jdk8.runtimeImage}}:{{ include "eap7.version" . }}
{{- else -}}
{{ .Values.build.s2i.jdk11.runtimeImage}}:{{ include "eap7.version" . }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap7.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
If build.s2i.version is not defined, use by defaul the Chart's appVersion
*/}}
{{- define "eap7.version" -}}
{{- default .Chart.AppVersion .Values.build.s2i.version -}}
{{- end -}}


{{- define "eap7.labels" -}}
helm.sh/chart: {{ include "eap7.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/version: {{ quote .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap
{{- end }}

{{- define "eap7.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap7.labels" . | nindent 4 }}
{{- end -}}