# Desafio técnico - Cubos DevOps

## Descrição do Projeto

O Projeto do Desafio técnico - Cubos DevOps é composto por front back e banco de
dados, cada um tem um dockerfile que o Terraform usa para criar as imagens e subir 
os containers. O banco é criado 1° depois o backend e por último o frontend pela 
diretiva `depends_on` do Terraform. Os containers rodam na mesma network, o banco 
cria um volume para persistir os dados, caso queira inspecionar o volume basta usar 
`docker volume inspect nome_do_volume`. Em caso de erro em algum dos containers 
eles vão reiniciar.


## Requisitos

Antes de começar, certifique-se de ter instalado o seguinte:

- **Terraform**
- **Docker**
- **WSL**

Preferível que use um ambiente linux.

## Configuração do Ambiente

1. Clone o repositório do projeto ou Baixe o código da release:

    ```bash
    git clone https://github.com/iagor1/desafio-cubos.git
    cd projeto-xyz
    ```

2. Dentro do diretório do projeto, você encontrará três subdiretórios:

    - **frontend**: Código do frontend e dockerfile.
    - **backend**: Código do backend e dockerfile.
    - **sql**: Script de inicialização e dockerfile do banco de dados.

3. Se não tiver Docker instalado rode o `setup_docker.sh`
4. Se não tiver Terraform instalado rode o `setup_terraform.sh`

## Executando o Projeto

1. **Rodando o projeto com Terraform:**

    ```bash
    terraform init
    terraform plan -out plan
    terraform apply
    ```

    Estes comandos vão buildar as imagens e executar os contêineres para o frontend, backend e banco de dados.

2. **Inicialização rápida:** 
    - Criei um shell script para iniciar e rodar o projeto

    ```bash
    ./run.sh
    ```

3. **Acessando a aplicação:**

    - O frontend estará disponível em: `http://localhost`
    - O backend estará disponível em: `http://localhost/api`
    - Pode verificar também com `curl localhost` ou `curl localhost/api`
    - O banco de dados estará acessível conforme configurado no backend.

4. **Detalhes:**
    Se decidir rodar no WSL mude no main na linha 10 esse bloco :
    ```
    provider "docker" {
    host    = "npipe:////.//pipe//docker_engine"
    }
    ```
### Notas Adicionais

- Certifique-se de que as portas necessárias (3000, 5432 e 80.) não estejam sendo utilizadas por outras aplicações.
- Para mais informações sobre o uso do Terraform e Docker, consulte suas respectivas documentações oficiais.