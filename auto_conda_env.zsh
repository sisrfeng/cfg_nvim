#!/bin/zsh
if [[ -f $XDG_CACHE_HOME/conda_name ]]; then
    conda activate $(cat $XDG_CACHE_HOME/conda_name)
    export PATH="$HOME/miniconda3/envs/$1/bin/:$PATH"
    # clear
fi

