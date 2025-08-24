#!/bin/bash

# Responsive DevOps Pipeline Dashboard Project

# Set up environment variables
DASHBOARD_TITLE="DevOps Pipeline Dashboard"
GRAFANA_API_KEY="your_grafana_api_key"
GRAFANA_URL="https://your_grafana_url.com"
PROMETHEUS_API_KEY="your_prometheus_api_key"
PROMETHEUS_URL="https://your_prometheus_url.com"

# Create dashboard directory and navigate into it
mkdir -p dashboard
cd dashboard

# Install required dependencies
npm install -g @grafana/toolkit
npm install -g prom-client

# Create dashboard configuration file
echo "Creating dashboard configuration file..."
cat > dashboard-config.json << EOF
{
  "title": "$DASHBOARD_TITLE",
  "panels": [
    {
      "title": "CPU Utilization",
      "type": "graph",
      "datasource": "prometheus",
      "targets": [
        {
          "expr": "cpu_utilization",
          "legendFormat": "{{instance}}"
        }
      ]
    },
    {
      "title": "Memory Usage",
      "type": "graph",
      "datasource": "prometheus",
      "targets": [
        {
          "expr": "memory_usage",
          "legendFormat": "{{instance}}"
        }
      ]
    }
  ]
}
EOF

# Create dashboard
echo "Creating dashboard..."
grafana-cli --api-key=$GRAFANA_API_KEY --url=$GRAFANA_URL dashboards create --title=$DASHBOARD_TITLE --file=dashboard-config.json

# Create Prometheus data source
echo "Creating Prometheus data source..."
prometheus-cli --api-key=$PROMETHEUS_API_KEY --url=$PROMETHEUS_URL datasources create --name="prometheus" --type="prometheus"

# Create dashboard route
echo "Creating dashboard route..."
mkdir -p routes
cat > routes/index.html << EOF
<!DOCTYPE html>
<html>
<head>
  <title>$DASHBOARD_TITLE</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h1>$DASHBOARD_TITLE</h1>
  <iframe src="$GRAFANA_URL/dashboards/$DASHBOARD_TITLE" frameborder="0" width="100%" height="100%"></iframe>
</body>
</html>
EOF

# Create CSS file for responsive design
echo "Creating CSS file for responsive design..."
cat > styles.css << EOF
body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
}

iframe {
  width: 100%;
  height: 100vh;
  border: none;
}

@media only screen and (max-width: 768px) {
  iframe {
    height: 50vh;
  }
}
EOF

# Serve dashboard
echo "Serving dashboard..."
npx serve routes