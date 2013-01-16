if [[ ! -o interactive ]]; then
    return
fi

compctl -K _moosh moosh

_moosh() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(moosh commands)"
  else
    completions="$(moosh completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
