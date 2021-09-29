
{{/*
eap74.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap74.eapBuilderImage" -}}
{{- if eq .Values.build.s2i.jdk "8"  -}}
{{/* only amd64 is supported for JDK 8 */}}
{{- if eq .Values.build.s2i.arch "amd64" -}}
{{ .Values.build.s2i.amd64.jdk8.builderImage}}:{{ include "eap74.version" . }}
{{- else -}}
{{ fail (printf "jdk 8 is only supported with amd64 arch") }}
{{- end -}}

{{- else -}} {{/* build.s2i.jdk == 11 */}}
{{/* for JDK 11, the build image depends on the arch. */}}
{{- if eq .Values.build.s2i.arch "amd64"  -}}
{{ .Values.build.s2i.amd64.jdk11.builderImage}}:{{ include "eap74.version" . }}
{{- else if eq .Values.build.s2i.arch "ppc64le" -}}
{{ .Values.build.s2i.ppc64le.jdk11.builderImage}}:{{ include "eap74.version" . }}
{{- else if eq .Values.build.s2i.arch "s390x" -}}
{{ .Values.build.s2i.s390x.jdk11.builderImage}}:{{ include "eap74.version" . }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
eap74.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap74.eapRuntimeImage" -}}
{{- if eq .Values.build.s2i.jdk "8"  -}}
{{/* only amd64 is supported for JDK 8 */}}
{{- if eq .Values.build.s2i.arch "amd64" -}}
{{ .Values.build.s2i.amd64.jdk8.runtimeImage}}:{{ include "eap74.version" . }}
{{- else -}}
{{ fail (printf "jdk 8 is only supported with amd64 arch") }}
{{- end -}}

{{- else -}} {{/* build.s2i.jdk == 11 */}}
{{/* for JDK 11, the runtime image depends on the arch. */}}
{{- if eq .Values.build.s2i.arch "amd64"  -}}
{{ .Values.build.s2i.amd64.jdk11.runtimeImage}}:{{ include "eap74.version" . }}
{{- else if eq .Values.build.s2i.arch "ppc64le" -}}
{{ .Values.build.s2i.ppc64le.jdk11.runtimeImage}}:{{ include "eap74.version" . }}
{{- else if eq .Values.build.s2i.arch "s390x" -}}
{{ .Values.build.s2i.s390x.jdk11.runtimeImage}}:{{ include "eap74.version" . }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap74.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
If build.s2i.version is not defined, use by defaul the Chart's appVersion
*/}}
{{- define "eap74.version" -}}
{{- default .Chart.AppVersion .Values.build.s2i.version -}}
{{- end -}}


{{- define "eap74.labels" -}}
helm.sh/chart: {{ include "eap74.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/version: {{ quote .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap
{{- end }}

{{- define "eap74.metering.labels" -}}
com.company: "Red_Hat"
com.redhat.product-name: "Red_Hat_Runtimes"
com.redhat.product-version: "2021-Q2"
com.redhat.component-name: EAP
com.redhat.component-version: {{ quote .Chart.AppVersion }}
com.redhat.component-type: application
{{- end }}

{{- define "eap74.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap74.labels" . | nindent 4 }}
  {{- include "eap74.metering.labels" . | nindent 4 }}
{{- end -}}