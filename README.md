# 🚀 SAP B1 AWS Installer – Terraform Infrastructure

Este repositório define a infraestrutura necessária para provisionar automaticamente um ambiente de testes para o SAP Business One (SAP B1) na AWS. A proposta é garantir que todo o ambiente possa ser **criado, destruído e recriado sob demanda**, com custo mínimo e intervenção reduzida.

## 💡 Visão Geral

- Este projeto utiliza **Terraform como IaC**, com foco em modularidade e reutilização.
- Toda a instalação do SAP B1 é feita em uma instância EC2 com Windows Server.
- A infraestrutura é efêmera: ideal para testes de 30 dias (prazo da licença trial do SAP).

## ⚙️ Recursos Criados

Este projeto separa os recursos em dois módulos principais:

### 🔁 Infraestrutura Efêmera
- Instância EC2 com Windows Server 2019 e SAP Installer pré-baixado
- Security Group com RDP liberado
- IAM Role + Instance Profile para acesso ao bucket S3
- Volume EBS (gp3) de 60 GB ou superior, configurável
- Execução de script PowerShell no boot do Windows:
  - Download automático do `.zip` de instaladores
  - Descompactação e log com envio automático ao S3

### 🏗️ Infraestrutura Fixa
- Bucket S3 com instaladores e logs
- Distribuição CloudFront segura para servir instaladores via HTTPS público
- Tópico SNS para lembrete via SMS
- Lambda Function para desligar instância EC2 com base em tag
- Lambda Function para desligar instância RDS com base em tag
- EventBridge Rule com agendamento (cron)
- IAM Role e Policy da Lambda

## 🧠 Estratégias

- O projeto adota uma separação entre **infraestrutura efêmera** (recursos temporários como EC2) e **infraestrutura fixa** (recursos persistentes como bucket e CloudFront).
- Isso permite recriar a EC2 sempre que necessário, mantendo intactos os instaladores e a distribuição pública.
- O script de inicialização (`startup.ps1`) é tratado como código e versionado em `scripts/`.
- Logs do provisionamento são enviados ao S3 para auditoria e troubleshooting.
- Para evitar cobranças desnecessárias, o projeto envia um lembrete automático via SMS antes de desligar a instância EC2.
- O desligamento automático também se aplica à instância RDS, desde que nenhuma EC2 com AutoStop=true esteja ativa no momento do agendamento

## 🛠️ Variáveis Customizáveis (via `.tfvars`)

```hcl
# Nome do par de chaves SSH para acesso à instância EC2
key_pair_name = "minha-key-pair"

# Número de telefone (em formato E.164) para receber alertas SMS via SNS
sns_reminder_phone_number = "+55DD999999999"

# Expressão CRON (em UTC) para desligamento automático da EC2 (padrão: 23h BRT)
schedule_expression_autostop_instances = "cron(0 2 * * ? *)"

# Expressão CRON (em UTC) para envio de alerta SMS antes do desligamento (padrão: 22h45 BRT)
schedule_expression_reminder = "cron(45 1 * * ? *)"

# Mensagem personalizada para o alerta SMS de desligamento automático
sns_reminder_message = "⚠️ Sua instância EC2 com AutoStop=true será desligada às 23h BRT. Remova a tag se estiver usando."

# IP público permitido para acessar a instância (ex: detectado automaticamente com curl)
allowed_ip_cidr = "200.123.45.67/32"

# Engine do SQL Server (ex: sqlserver-ex para Express, sqlserver-se para Standard Edition)
sql_engine = "sqlserver-ex"

# Versão compatível do SQL Server (ex: 2019 Express)
sql_engine_version = "15.00.4073.23.v1"

# Tipo da instância RDS (classe e performance)
sql_instance_class = "db.t3.medium"

# Nome do banco que será criado pelo SLD
sql_database_name = "SBODemoBR"

# Usuário administrador da instância RDS
sql_username = "sapadmin"

# Senha do usuário administrador (não sensível neste exemplo)
sql_password = "S@pB1!23xYz9rQw"
```

> 💡 Dica: você pode preencher a variável `allowed_ip_cidr` dinamicamente no momento do apply:
>
> ```bash
> terraform apply -var="allowed_ip_cidr=$(curl -s https://checkip.amazonaws.com)/32"
> ```
>
> Este exemplo (e outros) estão incluídos em `terraform.tfvars.example` para facilitar a configuração inicial.

## 🧪 Observações

- A renovação da licença do SAP exige a **recriação da instância** (30 dias). O restante da infraestrutura é mantido.

- Em alguns testes, o script `startup.ps1` não foi executado automaticamente via `user_data`, sendo necessário acessá-lo manualmente via RDP após o boot da instância. Isso pode ocorrer por limitações do processo de inicialização do Windows.

## 📦 Instaladores SAP B1

O pacote de instalação do SAP Business One utilizado neste ambiente pode ser baixado diretamente via HTTPS público (CloudFront):

[https://d3opmwey5n46mf.cloudfront.net/sap/10.0_FP2405/sapb1.zip](https://d3opmwey5n46mf.cloudfront.net/sap/10.0_FP2405/sapb1.zip)

> 💡 Dica: se preferir, você ainda pode baixar via AWS CLI, caso tenha permissões para acessar o bucket diretamente:
>
> ```bash
> aws s3 cp s3://sapb1-installer/sap/10.0_FP2405/sapb1.zip .
> ```

## 💰 Custos Estimados

Este projeto foi pensado para ambientes de teste com baixo custo. Abaixo está uma estimativa aproximada com base em uso esporádico (ex: 3h por dia):

| Recurso                      | Tipo                  | Custo aproximado (mensal) |
|------------------------------|------------------------|----------------------------|
| EC2 (Windows t3.medium)      | Sob demanda (3h/dia)   | ~USD 10,00                 |
| RDS SQL Server Express       | db.t3.medium (3h/dia)  | ~USD 7,92 + USD 2,30 (EBS) |
| Storage (EBS da EC2)         | 60 GB gp3              | ~USD 6,90                  |
| SMS (SNS)                    | 1 alerta/dia (Brasil)  | ~USD 0,75                  |
| S3 (armazenamento)           | 8 GB + logs            | ~USD 0,20                   |
| **Total estimado**           |                        | **~USD 28,15/mês**         |

> 💡 Os valores podem variar conforme a região AWS e uso real. Se os recursos ficarem ligados 24/7, o custo pode ultrapassar USD 100/mês.

> 💡 Para ambientes mais seguros e permanentes, considere ativar criptografia, backup e monitoramento — com possível acréscimo de custo.
