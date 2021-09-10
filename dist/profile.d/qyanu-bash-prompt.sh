# display the exit status of the last executed command
PROMPT_COMMAND="__prompt_command"
__prompt_command() {
    local cde=$?
    local str="[$(printf "%3d" $cde)]";
    local GREEN=$'\033[1;32m'
    local RED=$'\033[1;31m'
    local BLUE=$'\033[1;34m'
    local NONE=$'\033[m'
    [ $cde -eq 0 ] && str="\[${GREEN}\]${str}"
    [ $cde -gt 0 ] && str="\[${RED}\]${str}"
    str="${str}\[${NONE}\]"
    if [ "`id -u`" -eq 0 ]; then
        export PS1="${str} \[${RED}\]\u\[${NONE}\]@\[${BLUE}\]\h\[${NONE}\]: \w \\\$ "
    else
        export PS1="${str} \[${GREEN}\]\u@\h\[${NONE}\]: \[${BLUE}\]\w\[${NONE}\] \\\$ "
    fi
}
