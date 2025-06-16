# 🚀 SAP B1 AWS Installer – Terraform Infrastructure

Este repositório define a infraestrutura necessária para provisionar automaticamente um ambiente de testes para o SAP Business One (SAP B1) na AWS. A proposta é garantir que todo o ambiente possa ser **criado, destruído e recriado sob demanda**, com custo mínimo e intervenção reduzida.

## 💡 Visão Geral

- Este projeto utiliza **Terraform como IaC**, com foco em modularidade e reutilização.
- Toda a instalação do SAP B1 é feita em uma instância EC2 com Windows Server.
- A infraestrutura é efêmera: ideal para testes de 30 dias (prazo da licença trial do SAP).
- A flag `criar_instancia_ec2` permite desligar ou recriar a instância a qualquer momento, sem destruir o restante da infraestrutura.

## ⚙️ Recursos Criados

- Instância EC2 com Windows Server 2019 e SAP Installer pré-baixado
- Security Group com RDP liberado
- IAM Role + Instance Profile para acesso ao bucket S3
- Bucket S3 com logs e pacote de instaladores
- Volume EBS (gp3) de 60 GB ou superior, configurável
- Execução de script PowerShell no boot do Windows:
  - Download automático do `.zip` de instaladores
  - Descompactação e log com envio automático ao S3

## 🧠 Estratégias

- O script de inicialização (`startup.ps1`) é tratado como código e versionado em `scripts/`.
- Logs do provisionamento são enviados ao S3 para auditoria e troubleshooting.

## 🧪 Observações

- A renovação da licença do SAP exige a **recriação da instância** (30 dias). O restante da infraestrutura é mantido.

- Em alguns testes, o script `startup.ps1` não foi executado automaticamente via `user_data`, sendo necessário acessá-lo manualmente via RDP após o boot da instância. Isso pode ocorrer por limitações do processo de inicialização do Windows.

## 📦 Instaladores SAP B1

O pacote de instalação do SAP Business One utilizado neste ambiente pode ser encontrado no seguinte bucket S3:

[s3://sapb1-installer/sap/10.0_FP2405/sapb1.zip](https://s3.console.aws.amazon.com/s3/object/sapb1-installer?prefix=sap/10.0_FP2405/sapb1.zip)

> 💡 Dica: para baixar via terminal com a AWS CLI (com permissões corretas):
>
> ```bash
> aws s3 cp s3://sapb1-installer/sap/10.0_FP2405/sapb1.zip .
> ```
