#!/usr/bin/env bash
# Ejecutar DENTRO de la Raspberry Pi (por SSH o directo en su terminal).
# Instala y habilita node_exporter como servicio — arranca solo con el sistema.
set -e

echo "== Instalando node_exporter =="
sudo apt update
sudo apt install -y prometheus-node-exporter

echo "== Habilitando el servicio para que arranque con el sistema =="
sudo systemctl enable --now prometheus-node-exporter

echo "== Esperando que levante =="
sleep 2

echo "== Verificando métricas clave =="
IP=$(hostname -I | awk '{print $1}')
echo "node_exporter corriendo en: http://$IP:9100/metrics"
echo ""
echo "--- Métricas de temperatura detectadas (revisa el nombre exacto) ---"
curl -s "http://localhost:9100/metrics" | grep -i 'thermal_zone\|hwmon_temp' | head -5 || \
  echo "⚠ No se encontraron métricas de temperatura automáticamente. Revisa 'curl localhost:9100/metrics | grep temp' a mano."

echo ""
echo "IP: $IP"
echo "Agregar IP en la carpeta del servidor central prometheus/targets/nodes.yml y nodes_ping.yml."
echo "Reservar IP por MAC en el router."
