typeset here=${${(%):-%x}:A:h}
export UZ_PLUGIN_PATH=${here}/plugins
source ${here}/../uz.zsh

zadd zsh-users/zsh-completions
zadd zsh-users/zsh-history-substring-search
