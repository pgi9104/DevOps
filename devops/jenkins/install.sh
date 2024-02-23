#! devops/jenkins/install.sh

# 쉘 실행위치
echo $(which bash)

#젠킨스 설치여부 확인
read -e -p "continue to install jenkins? (Y/N)" ans_continue

if[[ ${ans_continue} =~ [Yy] ]]; then
    echo "yes"
elif [[ ${ans_continue} =~ [Nn] ]]; then
    echo "no"
else
    echo "Input Y or N"
fi

os = ubuntu

if[[ "$(cat /proc/version | grep --count ${os})" == 0 ]]; then
    os = centos
else
    os = ubuntu
fi