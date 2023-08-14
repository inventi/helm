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
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Render structure toYaml or its Tpl if either is present. It is highly advised
to keep this function the same in the chart 'springboot'.
*/}}
{{- define "renderOptionalYamlOrTpl" -}}
{{- $rawData := get .values .key -}}
{{- if not (empty .quote) -}}
{{- $rawData = $rawData | toString -}}
{{- end -}}
{{- $tplData := get .values (print .key "Tpl") -}}
{{- if $rawData -}}
{{- $rawData := empty .skipParent | ternary (dict .key $rawData) $rawData -}}
{{- toYaml $rawData }}
{{- else if $tplData -}}
{{- if empty .skipParent -}}
{{- printf "\n%s:\n" .key -}}
{{- end -}}
{{- tpl $tplData .context | indent (empty .skipParent | ternary 2 0) }}
{{- end -}}
{{- end -}}
