#!/bin/bash

set -e

cd "$(dirname "$0")/lambda"

echo "🧹 Removendo pacote zip antigo (se existir)..."
rm -f ../stop-ec2.js.zip

# Cria package.json se ainda não existir
if [ ! -f package.json ]; then
  echo "📦 Inicializando package.json..."
  npm init -y > /dev/null
fi

echo "📦 Instalando dependências da Lambda..."
npm install @aws-sdk/client-ec2

echo "🗜️ Gerando pacote zip para Lambda..."
zip -r ../stop-ec2.js.zip . -x "*.zip" > /dev/null

echo "✅ Lambda zip gerado em scripts/stop-ec2.js.zip"