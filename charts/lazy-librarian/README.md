# lazylibrarian

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: version-b3a081ec](https://img.shields.io/badge/AppVersion-version--b3a081ec-informational?style=flat-square)

A Helm chart for deploying LazyLibrarian

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/alexlebens/helm-charts/issues/new/choose)**

## Source Code

* <https://gitlab.com/LazyLibrarian/LazyLibrarian.git>
* <https://lazylibrarian.gitlab.io>

## Requirements

Kubernetes: `>=1.16.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://github.com/bjw-s/helm-charts | common | 3.1.0 |

## TL;DR

```console
helm repo add alexlebens-helm-charts http://alexlebens.github.io/helm-charts
helm repo update
helm install lazy-librarian alexlebens-helm-charts/lazy-librarian
```

## Installing the Chart

To install the chart with the release name `lazy-librarian`

```console
helm install lazy-librarian alexlebens-helm-charts/lazy-librarian
```

## Uninstalling the Chart

To uninstall the `lazy-librarian` deployment

```console
helm uninstall lazy-librarian
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/alexlebens/helm-charts/blob/main/charts/lazy-librarian/values.yaml) from the [common library](https://github.com/bjw-s/helm-charts/blob/main/charts/library/common/values.yaml).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install lazy-librarian \
  --set env.TZ="US/Mountain" \
    alexlebens-helm-charts/lazy-librarian
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install lazy-librarian alexlebens-helm-charts/lazy-librarian -f values.yaml
```

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/bjw-s/helm-charts/blob/main/charts/library/common/values.yaml)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env | object | See below | environment variables. |
| env.PGID | string | `"1001"` | Specify the group ID the application will run as |
| env.PUID | string | `"1001"` | Specify the user ID the application will run as |
| env.TZ | string | `"UTC"` | Set the container timezone |
| env.DOCKER_MODS | string | `"linuxserver/mods:universal-calibre|linuxserver/mods:lazylibrarian-ffmpeg"` | Add linuxserver docker mods |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| image.repository | string | `"linuxserver/lazylibrarian"` | image repository |
| image.tag | string | `"version-b3a081ec"` | image tag |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| service | object | See values.yaml | Configures service settings for the chart. |
