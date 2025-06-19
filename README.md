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
- Lambda Function para desligar a EC2 com base em tag
- EventBridge Rule com agendamento (cron)
- IAM Role e Policy da Lambda

## 🧠 Estratégias

- O projeto adota uma separação entre **infraestrutura efêmera** (recursos temporários como EC2) e **infraestrutura fixa** (recursos persistentes como bucket e CloudFront).
- Isso permite recriar a EC2 sempre que necessário, mantendo intactos os instaladores e a distribuição pública.
- O script de inicialização (`startup.ps1`) é tratado como código e versionado em `scripts/`.
- Logs do provisionamento são enviados ao S3 para auditoria e troubleshooting.
- Para evitar cobranças desnecessárias, o projeto envia um lembrete automático via SMS antes de desligar a instância EC2.

## 🛠️ Variáveis Customizáveis (via `.tfvars`)

O projeto permite personalizar diversos parâmetros da infraestrutura por meio de um arquivo `.tfvars`. Isso torna o provisionamento mais flexível, adaptando-se a diferentes cenários e ambientes.

### 🔐 Acesso e Segurança

```hcl
# Nome do par de chaves SSH para acesso à instância EC2
key_pair_name = "minha-key-pair"
```

### 📆 Agendamento (EventBridge)

```hcl
# Expressão CRON (em UTC) para desligamento automático da EC2 (padrão: 23h BRT)
schedule_expression_autostop_instances = "cron(0 2 * * ? *)"

# Expressão CRON (em UTC) para envio de alerta SMS antes do desligamento (padrão: 22h45 BRT)
schedule_expression_reminder = "cron(45 1 * * ? *)"
```

### 📲 Notificações (SNS)

```hcl
# Número de telefone (em formato E.164) para receber alertas SMS via SNS
sns_reminder_phone_number = "+55DD999999999"

# Mensagem personalizada para o alerta SMS de desligamento automático
reminder_message = "⚠️ Sua instância EC2 com AutoStop=true será desligada às 23h BRT. Remova a tag se estiver usando."
```

### 🌐 IP Dinâmico (Security Group)

```hcl
# IP público permitido para acessar a instância (ex: detectado automaticamente com curl)
allowed_ip_cidr = "200.123.45.67/32"
```

> 💡 Dica: você pode preencher essa variável dinamicamente no momento do apply:
>
> ```bash
> terraform apply -var="allowed_ip_cidr=$(curl -s https://checkip.amazonaws.com)/32"
> ```

Um exemplo dessa variável está presente no arquivo `terraform.tfvars.example`.

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
