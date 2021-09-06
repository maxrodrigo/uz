typeset UZ_PATH=${0:A:h}
typeset UZ_PLUGIN_PATH=${UZ_PLUGIN_PATH:-${UZ_PATH}/plugins}
typeset -a UZ_PLUGINS

zadd() {
  local zmodule=${1:t} zurl=${1} zscript=${2}
  local zpath=${UZ_PLUGIN_PATH}/${zmodule}
  UZ_PLUGINS+=("${zpath}")

  if [[ ! -d ${zpath} ]]; then
    mkdir -p ${zpath}
    echo -ne "\e[1;32m${zmodule}: \e[0m"
    git clone --recursive https://github.com/${zurl}.git ${zpath}
  fi

  local zscripts=(${zpath}/(init.zsh|${zmodule:t}.(zsh|plugin.zsh|zsh-theme|sh))(NOL[1]))
  if    [[ -f ${zpath}/${zscript} ]]; then source ${zpath}/${zscript}
  elif  [[ -f ${zscripts} ]]; then source ${zscripts}
  else  echo -e "\e[1;31mNo scripts was found for:\e[0m \e[3m${zurl}\e[0m"
  fi
}

zupdate() {
  for p in $(ls -d ${UZ_PLUGIN_PATH}/*/.git); do
    echo -ne "\e[1;32m${${p%/*}:t}: \e[0m"
    echo -e "\r\033[0K$(git -C ${p%/*} pull)"
  done
}

zclean() {
  for p in $(comm -23 <(ls -1d ${UZ_PLUGIN_PATH}/* | sort) <(printf '%s\n' $UZ_PLUGINS | sort)); do
    echo -e "\e[1;33mCleaning:\e[0m \e[3m${p}\e[0m"
    rm -rI $p
  done
}
