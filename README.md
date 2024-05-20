<h1>데브옵스</h1>

<br>
<p>개인 데브옵스를 구성하기 위한 환경설정이다.</p>

<h2>vagrant접속이후 설정</h2>
<code>
sudo sed -i -e "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
</code>

<h2>1. 파이썬 설치</h2>
<h3>1.1 Ubuntu</h3>
<pre>
<code>
sudo apt update
sudo apt install python3-pip python3-setuptools virtualenv ssh git -y
</code>
</pre>

<h2>2. requirements.txt 파일 정의 및 실행</h2>
<h3>2.1 requirements.txt 파일 정의 예시</h3>
<pre>
  <code>
ansible==8.5.0
cryptography==41.0.4
jinja2==3.1.2
jmespath==1.0.1
MarkupSafe==2.1.3
netaddr==0.9.0
pbr==5.11.1
ruamel.yaml==0.17.35
ruamel.yaml.clib==0.2.8
  </code>
</pre>
<h3>2.2 필수 패키지 설치</h3>
<pre>
  <code>
pip install -r requirements.txt
  </code>
</pre>

