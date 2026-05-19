# Serverless Uptime Monitor & Alerting System
Este proyecto consiste en un **Monitor de Disponibilidad Serverless** robusto diseñado
para verificar el estado de salud de aplicaciones web críticas de forma recurrente.
Implementado 100% bajo prácticas modernas de **DevOps** e **Infraestructura como Código
(IaC)**.
## 🚀 Arquitectura y Tecnologías
* **AWS Lambda & EventBridge:** Computación sin servidores y tareas programadas
cronométricas de bajo coste.
* **Terraform:** Automatización y aprovisionamiento integral de toda la infraestructura
Cloud.
* **Python 3.11:** Lógica de sondeo ultraligera, optimizada sin dependencias de terceros.
* **GitHub Actions:** Pipeline de Integración y Despliegue Continuo (CI/CD) automatizado
ante cambios de código.
* **Slack API:** Canalización de alertas en tiempo real con diseño enriquecido mediante
Webhooks.
## 📁 Estructura del Proyecto
* `/src`: Contiene la lógica del Health Check (`monitor.py`).
* `/terraform`: Contiene las declaraciones de infraestructura (`main.tf`, `variables.tf`,
`provider.tf`).
* `/.github/workflows`: Definición de la automatización CI/CD (`deploy.yml`).
## 🛠️ Cómo Desplegar este Proyecto en 3 Pasos
1. **Fork/Clona** este repositorio.
2. Configura los secretos (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`,
`SLACK_WEBHOOK_URL`) dentro de los ajustes de tu repositorio de GitHub.
3. Realiza un cambio menor o haz un push hacia la rama `main`. El pipeline de GitHub
Actions aprovisionará de forma transparente tu infraestructura en minutos.
---
*Proyecto diseñado con fines profesionales para demostración técnica en LinkedIn y
portafolios de Ingeniería Cloud / DevOps.*