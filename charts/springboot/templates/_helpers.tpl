{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "secretname" -}}
{{ template "fullname" . }}-secret
{{- end -}}

{{/*
Process "env" structure
*/}}
{{- define "env_structure" -}}
{{- if .env -}}
  {{- $secretName := include "secretname" .root -}}
  {{- range $name, $definition := .env }}
- name: {{ $name | quote }}
  {{- if $definition.sensitive }}
  valueFrom:
    secretKeyRef:
      name: {{ $secretName | quote }}
      key: {{ $definition.key | default $name | quote }}
      {{- if $definition.optional }}
      optional: true
      {{- end }}
  {{- else if $definition.configMapKeyRef }}
  valueFrom:
    configMapKeyRef:
{{ toYaml $definition.configMapKeyRef | indent 6 }}
  {{- else if $definition.secretKeyRef }}
  valueFrom:
    secretKeyRef:
{{ toYaml $definition.secretKeyRef | indent 6 }}
  {{- else if $definition.fieldRef }}
  valueFrom:
    fieldRef:
{{ toYaml $definition.fieldRef | indent 6 }}
  {{- else if $definition.resourceFieldRef }}
  valueFrom:
    resourceFieldRef:
{{ toYaml $definition.resourceFieldRef | indent 6 }}
  {{- else if $definition.valueFrom }}
  valueFrom:
{{ toYaml $definition.valueFrom | indent 4 }}
  {{- else }}
  value: {{ required (printf "Value for variable env.%s.value is undefined" $name) $definition.value | quote }}
  {{- if $definition.optional }}
  optional: true
  {{- end }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end -}}
