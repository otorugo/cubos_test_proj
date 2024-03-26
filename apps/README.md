# Desafio técnico - Cubos DevOps

    Este é o trabalho do teste técnico de **Victor Hugo Oliveira da Silva** 

## Pré-requisitos
- Docker
- AWS CLI (Com uma conta que possa gerenciar EC2,S3 e IAM)***

**** A conta na AWS é necessária porque eu não consegui acessar a instância ec2 com o **localstack(soluçao para simular a infra da AWS localmente)**
- Terraform

## INFRA

### Inicialização Localstack 

  Rodar a aplicação no Localstack não funcionou como esperado, para fim de teste completamente funcional use a **Inicialização AWS**, na documentação as portas são mostradas através de mapping nos logs.
  Sem as portas que estão fazendo bind eu não consegui acessar a ec2 que estava rodando as aplicações. 

Caso haja interesse de rodar localmente mesmo assim, vou deixar os seguintes passos :

- instalar os seguintes programas 

```bash
pip install awslocal
pip install lflocal

```
Os dois são wrappers do awscli e do terraform, para subir a infra localmente.


    Alguns passos serão feitos antes de subir a infraestrutura

  1.  **Será enviado no email dois envs e o terraform.tfstate . Adicionar os envs e o terraform.tfstate na raiz da pasta de infra**
  2.  Depois de adicionar os .env* na pasta de infra é preciso rodar o script "before_init_local.sh".
  Para esse script precisamos das **credenciais da AWS**(AWS_ACCESS_KEY_ID=fakeId,AWS_SECRET_ACCESS_KEY=fakePass) adicionada no compose que está na raiz do repo. É preciso também 
  adicionar uma ami e taggear de forma que o localstack entenda.

    - taggear imagem no docker
    ```bash
      docker pull ubuntu:focal
      docker tag ubuntu:focal localstack-ec2/ubuntu-focal-ami:ami-000001
    ```

    - no terraform.tfvar enviado, o valor "ami-000001" esta comentado, é só descomentar e comentar o valor "ami_ubuntu_id" que estava descomentado antes.


    - rodar o script de configuração do projeto inteiro
    ```bash
        bash before_init_aws.sh
    ``` 
  3.  Agora iremos subir a infra com o terraform:
  - **Dar init no terraform** 
```bash
    tflocal init
```   
  - **Aplicar alterações no terraform** 
```bash
    tf apply
```
  O terminal vai pedir uma confirmação das aplicações, responder "yes".

  4.  A partir daqui conforme a documentação os logs deviam mostrar o mapping das portas, testei na versão 3.1.0 e na versão latest do localstack, mas sem sucesso.


### Inicialização AWS


    Alguns passos serão feitos antes de subir a infraestrutura

  1.  **Será enviado no email dois envs e o terraform.tfstate . Adicionar os envs e o terraform.tfstate na raiz da pasta de infra**
  2.  Depois de adicionar os .env* na pasta de infra é preciso rodar o script "before_init_aws.sh".
  Para esse script precisamos das **credenciais da AWS**.
    ```bash
        bash before_init_aws.sh
    ``` 
  3.  Agora iremos subir a infra com o terraform:
  - **Dar init no terraform** 
```bash
    terraform init
```   
  - **Aplicar alterações no terraform** 
```bash
    terraform apply
```
  O terminal vai pedir uma confirmação das aplicações, responder "yes".

  4.  A inicialização de tudo deve demorar por volta de 5min
  5.  Depois dos 5min, entre no console AWS > EC2 procure a instancia "ec2_test_cubos", nos
detalhes tem "Public IPv4 address", use esse valor para acessar o app através da url
http://<public-ipv4-address>, pronto a aplicação vai estar rodando na AWS.


