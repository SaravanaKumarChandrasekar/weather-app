#!/bin/sh
# Save as test_monitoring.sh and run: sh test_monitoring.sh
set -e

BACKEND_HOST="192.168.147.128"
BACKEND_PORT=5000
BACKEND_URL="http://${BACKEND_HOST}:${BACKEND_PORT}"
METRICS_PATH="/metrics"
PROM_CONTAINER_NAME="prometheus"

echo "1) Triggering 30 requests to backend -> ${BACKEND_URL}/weather?q=Chennai"
for i in $(seq 1 30); do
  curl -s "${BACKEND_URL}/weather?q=Chennai" >/dev/null || echo "curl to backend failed (attempt $i)"
done
echo "-> Done sending requests."

echo
echo "2) Showing first 120 lines of backend /metrics (host view):"
curl -s "${BACKEND_URL}${METRICS_PATH}" | sed -n '1,120p' || echo "Failed to curl backend /metrics from host"

echo
echo "3) Searching for flask_* metrics in backend /metrics:"
curl -s "${BACKEND_URL}${METRICS_PATH}" | egrep -i "flask|weather_requests|request" || echo "No flask-related metrics found in /metrics (host view)"

echo
echo "4) If Docker Compose is running, list services and check prometheus container:"
docker compose ps || echo "docker compose ps failed (maybe not in compose dir)"

echo
echo "5) From inside Prometheus container: try to curl backend by service name (weather-app:5000)."
echo "   (This checks Docker network DNS)"

/bin/sh -c 'docker compose exec -T prometheus sh -c "apk add --no-cache curl >/dev/null 2>&1 || true; echo \"---- curl from prometheus -> http://weather-app:5000/metrics ----\"; curl -s -m 5 http://weather-app:5000/metrics | sed -n \"1,60p\" || echo \"curl from prometheus failed\""' || echo "Could not exec into prometheus container (it may not be running)"

echo
echo "6) Prometheus targets (API) — shows health for scraped targets:"
curl -s http://127.0.0.1:9090/api/v1/targets | python3 -c "import sys, json; j=json.load(sys.stdin); 
for t in j.get('data',{}).get('activeTargets',[]): 
  print(t.get('labels',{}).get('job','<no-job>'), '->', t.get('scrapeUrl'), 'status=', t.get('health'))" || echo "Failed to fetch Prometheus targets (maybe prometheus not on localhost:9090)"

echo
echo "7) Quick note: If any step failed, paste the output above here and I will tell you exactly what to fix."

