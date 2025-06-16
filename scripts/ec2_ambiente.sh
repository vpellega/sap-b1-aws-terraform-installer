#!/bin/bash

INSTANCE_ID=$(cd ../environments/dev/ && terraform state show 'aws_instance.sap_b1_server[0]' | awk '$1 == "id" { gsub(/"/, "", $3); print $3 }')

if [ -z $INSTANCE_ID ]; then
  echo "❌ Não foi possível obter o Instance ID. Certifique-se de que a EC2 foi criada."
  exit 1
fi

echo "=== Gerenciar EC2 SAP B1 ==="
echo "ID detectado: $INSTANCE_ID"
echo "[1] Ligar EC2"
echo "[2] Parar EC2"
echo "[3] Status EC2"
read -p "Escolha: " op

case $op in
  1) aws ec2 start-instances --instance-ids $INSTANCE_ID ;;
  2) aws ec2 stop-instances --instance-ids $INSTANCE_ID ;;
  3) 
    echo "Status da instância:"
    aws ec2 describe-instances --instance-ids $INSTANCE_ID \
      --query "Reservations[0].Instances[0].{Estado: State.Name, Tipo: InstanceType, PublicIP: PublicIpAddress, Zona: Placement.AvailabilityZone, TempoLigada: LaunchTime}" \
      --output table
    ;;
  *) echo "Opção inválida" ;;
esac
