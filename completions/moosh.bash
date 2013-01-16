_moosh() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(moosh commands)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(moosh completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _moosh moosh
