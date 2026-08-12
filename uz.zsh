typeset UZ_PATH=${0:A:h}
typeset UZ_PLUGIN_PATH=${UZ_PLUGIN_PATH:-${XDG_DATA_HOME:-${HOME}/.local/share}/uz/plugins}
typeset -a UZ_PLUGINS

zadd() {
  local zmodule=${1:t} zurl=${1} zscript=${2}
  local zpath=${UZ_PLUGIN_PATH}/${zurl}
  local zlegacy
  for zlegacy in ${UZ_PLUGIN_PATH}/${zmodule} ${UZ_PATH}/plugins/${zurl} ${UZ_PATH}/plugins/${zmodule}; do
    if [[ ! -d ${zpath} && -d ${zlegacy} ]]; then
      echo -e "\e[1;36mMigrating:\e[0m \e[3m${zlegacy} -> ${zpath}\e[0m"
      mkdir -p ${zpath:h}
      mv ${zlegacy} ${zpath}
      rmdir ${zlegacy:h} 2>/dev/null
      break
    fi
  done
  UZ_PLUGINS+=("${zpath}")

  if [[ ! -d ${zpath} ]]; then
    mkdir -p ${zpath}
    echo -ne "\e[1;32m${zurl}: \e[0m"
    git clone --recursive https://github.com/${zurl}.git ${zpath}
  fi

  local zscripts=(${zpath}/(init.zsh|${zmodule:t}.(zsh|plugin.zsh|zsh-theme|sh))(NOL[1]))
  local zfile=${zpath}/${zscript}
  [[ -f ${zfile} ]] || zfile=${zscripts}
  if    [[ -f ${zfile} ]]; then
    source ${zfile}
    [[ ${zfile}.zwc -nt ${zfile} ]] || zcompile -R ${zfile}
  else  echo -e "\e[1;31mNo scripts was found for:\e[0m \e[3m${zurl}\e[0m"
  fi
}

zupdate() {
  for p in ${UZ_PLUGIN_PATH}/*/*/.git(N); do
    echo -ne "\e[1;32m${${p%/*}:t}: \e[0m"
    echo -e "\r\033[0K$(git -C ${p%/*} pull)"
  done
}

zclean() {
  for p in ${UZ_PLUGIN_PATH}/*/*(N); do
    (( ${UZ_PLUGINS[(Ie)${p}]} )) && continue
    echo -e "\e[1;33mCleaning:\e[0m \e[3m${p}\e[0m"
    rm -rI $p
  done
  for p in ${UZ_PLUGIN_PATH}/*(N/^F); do rmdir $p; done
}
