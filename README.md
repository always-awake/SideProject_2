# SideProject_2

### Snowflake / Phoenix 서버 패턴
#### Immutable Infrastructure 패러다임 : Cloud와 Docker 적절한 패러다임
- 이미지 기반(Docker image, Amazon VM image 등) 애플리케이션 배포 시나리오
- 인프라가 만들어지고 거의 변경하지 않는 상태의 인프라
- 다수의 서버를 동적으로 관리하는 클라우드를 기반으로 어떻게 하면 유연하게 배포할 수 있을까에 대한 고민에서 나온 패러다임
- 예)새로운 버전의 서버가 있다면, 최신 버전의 서버를 준비한 다음 기존의 서버를 버리고, 새로운 서버로 replace 하는 것(기존의 서버를 update하는 것이 아니라)
- '기존의 서버를 어떻게하면 잘 관리할까?'가 아니라 -> 어떻게 하면 서버를 잘 쓰고 버리는 지에 포커스!!
  - 1) 개발 단에서 만들어진 인프라를 (Docker Image 1.0버전)
  - 2) 개발 단계에서 Dev Test를 거치고
  - 3) 스테이징 단계(실서비스 이전 단계)에서 테스트를 거치고 (a)의 Docker Image 1.0 버전을 갖고 테스트)
  - 4) 이를 프로덕션에 적용 (a)의 Docker Image 1.0 버전을 적용)
  - 5) 문제가 생길 경우(Docker Image 1.0), 현재 인프라를 수정하지 않고 새로운 버전 배포 (Docker Image 1.1로 a)부터 재시작)
  - 6) 원하는 버전을 지정한 재배포 지원 (Docker Image 1.1)

#### Snowflake(눈송이) 서버 패턴
- 서버를 한 번 셋업하고 나서, 설정을 변경하고, 패치를 적용하는 등의 업데이트를 지속적으로 적용/운영하는 서버
- 새로운 서버를 세팅하고자 할 때, 동일한 환경을 구성하기 어렵고, 누락된 설정이나 패치 등에 의해서 장애가 발생하는 경우가 많다.
- 한 번 설정을 하고 나면 다시 설정이 불가능한 "마치 눈처럼 녹아버리는" 서버 형태

#### Phoenix(피닉스) 서버 패턴 -> Immutable Infrastructure 패러다임을 적용한 서버 패턴
- 불 속에서 다시 태어나는(re-born)피닉스
- 한 번 생성된 서버는 거의 (거의) 수정해서 쓰지 않음
- 새로운 서버를 세팅할 떄마다, 처음 OS설치에서부터, 소프트웨어 인스톨, 설정 변경까지 모두 반복
- 매전 전체 설치를 반족할 경우, 긴 시간 소요
  - 보통, 베이스 이미지를 만들어놓고, 차이가 나는 부분만 재설정
  - Docker, Chef, Puppet, Vagrant, Packer, Serf와 같은 도구들을 활용하게 되면 셋업 시간을 조금 줄일 수 있음

### Docker 
#### Docker란
- 빠르고 가벼운 가상화 솔류션
- 애플리케이션과 그 실행환경/OS를 모두 포함한 '소프트웨어 패키지' 하나로 생성  -> Docker Image
- 플랫폼에 상관없이 실행될 수 있는 애플리케이션 '컨테이너를 만드는 기술'
- Docker Image는 Container의 형태로 Docker Engine이 있는 어디에서나(Docker Image를 사용하는 호스트 측) 실행 가능
  - 대상: 로컬 머신 (윈도우/맥/리눅스), Azure, AWS, Digital Ocean 등
  - 하나의 Docker Image를 통해 다수의 Container를 생성 할 수 있음
- 생성된 Docker Container는 바로 쓰고 버리는 것 (Immutable Infrastructure 패러다임)
  - 비교) 예전 VM은 한 번 생성하면 애지중지, 관리 및 업데이트
- Docker Container는 격리되어 있어서, 해킹되더라도 Docker Engine이 구동되는 원래의 서버(host 서버)에는 영향을 끼치지 않음

#### Docker만의 특징/유의사항
- Docker Container 내에서 어떤 프로세스가 도는 지 명확히 하기 위해서 
  - 하나의 Docker Container 내에서 다양한 프로세스가 구동되는 것을 지양 
  - > 한 종류의 프로세스만을 구동하는 것을 지향/하나의 Docker는 하나의 프로세스 (DB Continaer, uwsgi Container, Memory Container 와같이 구성)
  - 하나의 Docker Container 내에서 프로세스를 Background(Daemon 형태)로 구동하는 것을 지양
  - > 프로세스를 Foreground로 구동하는 것을 지향 예) nginx -g daemon off;
  - > 실행 로그도 표준출력(stdout)으로 출력
  
#### Container Orchestration
- 컨테이너 관리 툴의 필요성
  - 컨테이너 자동 배치 및 복제
  - 컨테이너 그룹에 대한 로드 밸런싱
  - 컨테이너 장애 복구
  - 클러스터 외부에 서비스 노출
  - 컨테이너 추가 또는 제거로 확장 및 축소
  - 컨테이너 서비스 간의 인터페이스를 통한 연결 및 네트워크 포트 노출 제어
- 주요 도구
  - 구글의 Kubernetes: Azure/AWS/Google 에서도 지원
  - Docker Swarm
  - Apache Mesos
- Azure Containers for Web App은 웹 서비스 전용, Orchestrations 서비스

#### Docker Registry
- 'Docker 이미지 저장소'를 뜻하는 말
- 공식 저장소로서 Docker Hub:https://hub.docker.com/ (Docker계의 Github)
- 이 외에 클라우드 벤더에서 저장소 지원
  - Azure Container Registry
  - AWS Elastic Container Registry
- Azure Containers for Web App 에서는 지정 Docker Registry로부터 이미지를 읽어들여, Docker Container를 적재

#### Dockerfile
- Docker 이미지를 만들 때(buid), 수행할 명령과 설정들을 시간 순으로 기술한 파일
- &&: 앞선 명령이 성공적으로 수행(exitcode=0:성공/exitcode=other:실패)되면, 그 다음 명령을 수행함
- -y: 설치할 것인지 질문할 때, 무조건 설치
- EXPOSE: 노출시킬 컨테이너의 포트(host측과 연결 할)를 입력(host측과 연결된 것은 아님) -> EXPOSE를 설정하지 않는다면, 외부와 연결 x
- host측과 연결 언제 연결?
  - docker run -p 80(호스트 측/외부에서 들어오는 요청이 들어오는 포트):80(실행 할 컨테이너 측/도커에서는 해당 컨테이너의 8000번 포트로 요청을 전달) 명령으로
- CMD: 
