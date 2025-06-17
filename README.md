# 🚀 SAP B1 AWS Installer – Terraform Infrastructure

Este repositório define a infraestrutura necessária para provisionar automaticamente um ambiente de testes para o SAP Business One (SAP B1) na AWS. A proposta é garantir que todo o ambiente possa ser **criado, destruído e recriado sob demanda**, com custo mínimo e intervenção reduzida.

## 💡 Visão Geral

- Este projeto utiliza **Terraform como IaC**, com foco em modularidade e reutilização.
- Toda a instalação do SAP B1 é feita em uma instância EC2 com Windows Server.
- A infraestrutura é efêmera: ideal para testes de 30 dias (prazo da licença trial do SAP).
- A flag `criar_instancia_ec2` permite desligar ou recriar a instância a qualquer momento, sem destruir o restante da infraestrutura.

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

## 🧠 Estratégias

- O projeto adota uma separação entre **infraestrutura efêmera** (recursos temporários como EC2) e **infraestrutura fixa** (recursos persistentes como bucket e CloudFront).
- Isso permite recriar a EC2 sempre que necessário, mantendo intactos os instaladores e a distribuição pública.
- O script de inicialização (`startup.ps1`) é tratado como código e versionado em `scripts/`.
- Logs do provisionamento são enviados ao S3 para auditoria e troubleshooting.

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
