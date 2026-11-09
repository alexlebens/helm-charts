# Compdef for mise task arguments in helm-charts
# Integrates with the shared `_mise_task_arg_completers` hook array so it does not
# overwrite other repository task completions (like infrastructure, docs, or blog).

_helm_charts_get_charts() {
  local charts_dir="$HOME/projects/helm-charts/charts"
  if [[ -d "$charts_dir" ]]; then
    find "$charts_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort
  fi
}

_helm_charts_chart_tag() {
  local -a chart_list
  chart_list=($(_helm_charts_get_charts))
  _describe -t charts 'Helm Charts' chart_list
}

_helm_charts_mise_task_args() {
  local task="$1"
  shift

  case "$task" in
    "lint:chart")
      _helm_charts_chart_tag
      return 0
      ;;
    "validate:kubeconform")
      _arguments \
        '--chart[Specific chart to validate]:chart:_helm_charts_chart_tag' \
        '--charts[Space-separated charts to validate]:charts:_helm_charts_chart_tag' \
        '--schema-dir[Directory for custom CRD schemas]:directory:_files -/' \
        '(-h --help)'{-h,--help}'[Show help]'
      return 0
      ;;
    "gitea:release-chart")
      _arguments \
        '--chart[Specific chart to release]:chart:_helm_charts_chart_tag' \
        '(-h --help)'{-h,--help}'[Show help]'
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Register the helm-charts completer hook if not already present
if [[ -z "${_mise_task_arg_completers[(r)_helm_charts_mise_task_args]}" ]]; then
  _mise_task_arg_completers+=(_helm_charts_mise_task_args)
fi

# Define the shared dispatcher if a previous completion file has not already defined it
if ! whence -w _mise_with_task_args >/dev/null 2>&1; then
  typeset -ga _mise_task_arg_completers
  if [[ -z "${_mise_task_arg_completers[(r)_helm_charts_mise_task_args]}" ]]; then
    _mise_task_arg_completers+=(_helm_charts_mise_task_args)
  fi

  _mise_with_task_args() {
    local -a raw_args
    raw_args=("${words[@]}")

    local subcmd=""
    local subcmd_idx=-1
    local i=2

    while (( i <= ${#raw_args} )); do
      local w="${raw_args[i]}"
      case "$w" in
        -C|--dir|--cd)
          (( i += 2 ))
          continue
          ;;
        -*)
          (( i++ ))
          continue
          ;;
        *)
          subcmd="$w"
          subcmd_idx=$i
          break
          ;;
      esac
    done

    if [[ "$subcmd" == "run" || "$subcmd" == "r" ]]; then
      local task=""
      local task_idx=-1
      local j=$(( subcmd_idx + 1 ))

      while (( j <= ${#raw_args} )); do
        local w="${raw_args[j]}"
        case "$w" in
          -*)
            (( j++ ))
            continue
            ;;
          *)
            task="$w"
            task_idx=$j
            break
            ;;
        esac
      done

      if [[ -n "$task" && CURRENT -gt task_idx ]]; then
        local completer
        for completer in "${_mise_task_arg_completers[@]}"; do
          if "$completer" "$task"; then
            return 0
          fi
        done
      fi
    fi

    if whence -w _mise >/dev/null 2>&1; then
      _mise "$@"
    else
      _default "$@"
    fi
  }

  compdef _mise_with_task_args mise
fi
