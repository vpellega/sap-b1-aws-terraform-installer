#!/bin/bash

set -e

for dir in lambda-*; do
  cd "$dir"

  # Cria package.json se ainda não existir
  if [ ! -f package.json ]; then
    echo "📦 Inicializando package.json..."
    npm init -y > /dev/null
  fi

  echo "📦 Instalando dependências da Lambda..."
  js_file=$(ls ./*.js)
  if grep -q "require('aws-sdk')" "$js_file"; then
    aws_packages="aws-sdk"
  else
    aws_packages=$(grep -Eho "@aws-sdk/client-[a-z0-9-]+" "$js_file" | sort -u)
  fi

  for pkg in $aws_packages; do
    echo "📦 Instalando $pkg..."
    npm install "$pkg" > /dev/null
  done

  js_file=$(ls ./*.js)
  zip_name="../${js_file%.js}.js.zip"

  echo "🧹 Removendo pacote zip antigo (se existir): $zip_name"
  rm -f ../"$zip_name"

  echo "🗜️ Gerando $zip_name..."
  zip -r "$zip_name" "$js_file" node_modules > /dev/null

  echo "✅ Lambda zip gerado em $zip_name"

  cd ..
done