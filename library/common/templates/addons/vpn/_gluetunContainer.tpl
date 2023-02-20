{{/*
The gluetun sidecar container to be inserted.
*/}}
{{- define "tc.v1.common.addon.vpn.gluetun.containers" -}}
{{- range .Values.addons.vpn.targetSelector }}
{{ . }}:
  podSpec:
    containers:
      gluetun:
        enabled: true
        imageSelector: gluetunImage
        probes:
          liveness:
            enabled: false
          readiness:
            enabled: false
          startup:
            enabled: false
        securityContext:
          runAsUser: 568
          runAsGroup: 568
          capabilities:
            add:
              - NET_ADMIN
              - SYS_MODULE

        {{- with $.Values.addons.vpn.env }}
        env:
          {{- . | toYaml | nindent 10 }}
        {{- end }}

        {{- range $envList := $.Values.addons.vpn.envList -}}
          {{- if and $envList.name $envList.value }}
          {{ $envList.name }}: {{ $envList.value | quote }}
          {{- else -}}
            {{- fail "Please specify name/value for VPN environment variable" -}}
          {{- end -}}
        {{- end -}}

        {{- with $.Values.addons.vpn.args }}
        args:
          {{- . | toYaml | nindent 10 }}
        {{- end }}

        {{- with $.Values.addons.vpn.livenessProbe }}
        livenessProbe:
          {{- toYaml . | nindent 10 }}
        {{- end -}}
{{- end }}
{{- end -}}
