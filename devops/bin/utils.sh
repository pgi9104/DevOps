# ansible/bin/utils.sh

function answer()
{
    local ans
    read -e ans
    echo "${ans}"

    return ${$ans}
}