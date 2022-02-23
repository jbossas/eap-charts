
{{/*
eap-xp4.eapBuilderImage corresponds to the imagestream for the EAP S2I Builder image.
It depends on the build.s2i.jdkVersion.
For now, we do not need to do anything as the only support version is 11 but when we support JDK 17, 
we will have to check build.s2i.jdkVersion to determin the proper image.
*/}}
{{- define "eap-xp4.eapBuilderImage" -}}
{{ .Values.build.s2i.jdk11.builderImage}}:{{ include "eap-xp4.version" . }}
{{- end -}}

{{/*
eap-xp4.eapRuntimeImage corresponds to the imagestream for the EAP S2I Runtime image.
It depends on the build.s2i.jdkVersion.
*/}}
{{- define "eap-xp4.eapRuntimeImage" -}}
{{ .Values.build.s2i.jdk11.runtimeImage}}:{{ include "eap-xp4.version" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eap-xp4.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
If build.s2i.version is not defined, use by defaul the Chart's appVersion
*/}}
{{- define "eap-xp4.version" -}}
{{- default .Chart.AppVersion .Values.build.s2i.version -}}
{{- end -}}


{{- define "eap-xp4.labels" -}}
helm.sh/chart: {{ include "eap-xp4.chart" . }}
{{ include "wildfly-common.selectorLabels" . }}
app.kubernetes.io/version: {{ quote .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: eap-xp
{{- end }}

{{- define "eap-xp4.metering.labels" -}}
com.company: "Red_Hat"
rht.prod_name: "Red_Hat_Runtimes"
rht.prod_ver: "2022-Q1"
rht.comp: EAP_XP
rht.comp_ver: {{ quote .Chart.AppVersion }}
rht.subcomp_t: application
{{- end }}

{{- define "eap-xp4.metadata.labels" -}}
metadata:
  labels:
  {{- include "eap-xp4.labels" . | nindent 4 }}
  {{- include "eap-xp4.metering.labels" . | nindent 4 }}
{{- end -}}