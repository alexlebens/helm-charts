# pocket-id-client

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Pocket ID OIDC Client

**Homepage:** <https://gitea.alexlebens.dev/alexlebens/helm-charts/src/branch/main/charts/pocket-id-client>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://gitea.alexlebens.dev/alexlebens/helm-charts>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://harbor.alexlebens.dev/helm-charts | common-helpers | 0.6.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| client | object | `{"allowedUserGroups":[{"name":"user","namespace":"pocket-id-operator"}],"callbackUrls":[],"clientID":"","clientSecretRefKey":"","clientSecretRefName":"","description":"","displayName":"","launchUrl":"","logo":{"darkLogoUrl":"","enabled":true,"logoUrl":"","selfhstDarkLogo":false,"selfhstLogoName":""},"pkceEnabled":true,"skipConsent":true}` | PocketIDOIDCClient CRD configuration |
| client.allowedUserGroups | list | `[{"name":"user","namespace":"pocket-id-operator"}]` | Allowed user groups |
| client.callbackUrls | list | `[]` | Callback URLs for the OIDC flow. If empty in oauth mode, auto-generated as [<launchUrl>/oauth2/callback]. In oidc mode, must be specified. |
| client.clientID | string | `""` | Client ID (UUID). If empty, a deterministic UUID is generated from release name + namespace. For grandfathered deployments, set this to the existing UUID. |
| client.clientSecretRefKey | string | `""` | Override the secret key referenced by clientSecretRef. Defaults: oauth="OAUTH2_PROXY_CLIENT_SECRET", oidc="clientSecret" |
| client.clientSecretRefName | string | `""` | Override the secret name referenced by clientSecretRef. Defaults to the mode-appropriate common-helpers name. |
| client.description | string | `""` | Description shown in Pocket ID |
| client.displayName | string | `""` | Display name shown in Pocket ID (defaults to release name in title case) |
| client.launchUrl | string | `""` | Launch URL for the application. If empty, auto-generated as https://<namespace>.<domain> (e.g. https://bentopdf.alexlebens.dev) |
| client.logo | object | `{"darkLogoUrl":"","enabled":true,"logoUrl":"","selfhstDarkLogo":false,"selfhstLogoName":""}` | Logo configuration |
| client.logo.darkLogoUrl | string | `""` | Explicit dark mode logo URL (optional, omitted from CRD if empty) |
| client.logo.enabled | bool | `true` | Enable rendering logo in CRD |
| client.logo.logoUrl | string | `""` | Explicit logo URL (light mode). Takes precedence over selfhstLogoName. If empty, defaults to selfhst icon matching selfhstLogoName or the namespace. |
| client.logo.selfhstDarkLogo | bool | `false` | If true and using selfhst icons, automatically appends "-light" for darkLogoUrl |
| client.logo.selfhstLogoName | string | `""` | Name of the icon on selfhst/icons (e.g. "tube-archivist", "sonarr"). If empty and logoUrl is empty, defaults to the namespace name. |
| client.pkceEnabled | bool | `true` | Enable PKCE |
| client.skipConsent | bool | `true` | Skip consent screen |
| externalSecret | object | `{"clientIdKey":"","clientSecretKey":"","enabled":true,"extraData":[],"secretName":"","secretPath":"","secretPathPrefix":"/cl01tl/pocket-id/oidc","storeName":"openbao"}` | ExternalSecret configuration for pulling credentials from OpenBao |
| externalSecret.clientIdKey | string | `""` | Override individual secret key names (oidc mode only) |
| externalSecret.extraData | list | `[]` | Additional data entries to include on the ExternalSecret. Useful for apps that need extra fields (scopes, PKCE flags, etc.) |
| externalSecret.secretName | string | `""` | Override the Kubernetes secret name. Defaults to the mode-appropriate common-helpers name. |
| externalSecret.secretPath | string | `""` | Full override for the OpenBao secret path (takes precedence over prefix) |
| externalSecret.secretPathPrefix | string | `"/cl01tl/pocket-id/oidc"` | Prefix for auto-generating the OpenBao path as <prefix>/<namespace> |
| externalSecret.storeName | string | `"openbao"` | ClusterSecretStore name |
| global | object | `{"domain":".alexlebens.dev","iconUrl":"https://cdn.jsdelivr.net/gh/selfhst/icons/webp/"}` | Global configuration (inherited from common-helpers) |
| issuerConfigPath | string | `"/cl01tl/pocket-id/config"` | OpenBao path for the Pocket ID issuer URL config (used in oauth mode) |
| mode | string | `"oauth"` | Mode: "oauth" for oauth2-proxy pattern, "oidc" for native OIDC pattern |
| name | string | `""` | Override the resource name (defaults to .Release.Name) |
| seedJob | object | `{"authPath":"kubernetes","enabled":true,"image":{"repository":"quay.io/openbao/openbao","tag":"2.6.2@sha256:11fd73a2102cda9c55d5d881a8c3210303146a7ec1e8ac76f526e175c6d24641"},"resources":{"limits":{"memory":"64Mi"},"requests":{"cpu":"10m","memory":"32Mi"}},"serviceAccount":{"create":true,"name":""},"vaultAddr":"http://openbao-internal.openbao:8200","vaultRole":"pocket-id-seed"}` | OpenBao seed Job configuration |
| seedJob.authPath | string | `"kubernetes"` | Kubernetes auth mount path in OpenBao |
| seedJob.enabled | bool | `true` | Enable the post-install Job that seeds secrets into OpenBao |
| seedJob.image | object | `{"repository":"quay.io/openbao/openbao","tag":"2.6.2@sha256:11fd73a2102cda9c55d5d881a8c3210303146a7ec1e8ac76f526e175c6d24641"}` | Image for the seed Job |
| seedJob.resources | object | `{"limits":{"memory":"64Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Resources for the seed Job pod |
| seedJob.serviceAccount | object | `{"create":true,"name":""}` | Service account configuration |
| seedJob.serviceAccount.create | bool | `true` | Create a ServiceAccount for the seed Job |
| seedJob.serviceAccount.name | string | `""` | Name override (defaults to "pocket-id-seed") |
| seedJob.vaultAddr | string | `"http://openbao-internal.openbao:8200"` | OpenBao server address |
| seedJob.vaultRole | string | `"pocket-id-seed"` | OpenBao role for Kubernetes auth (must have write policy) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
