import os
import urllib.request
import json

def lambda_handler(event, context):
    # Recuperación de variables de entorno inyectadas por Terraform
    target_url = os.environ.get('TARGET_URL', 'https://www.google.com')
    slack_webhook_url = os.environ.get('SLACK_WEBHOOK_URL')
    
    print(f"Iniciando verificación de disponibilidad para: {target_url}")
    
    try:
        # Configuración de la petición con un User-Agent genérico
        req = urllib.request.Request(
            target_url,
            headers={'User-Agent': 'Cloud-Uptime-Monitor/1.0'}
        )
        
        # Timeout estricto de 8 segundos para evitar cobros excesivos por esperas
        with urllib.request.urlopen(req, timeout=8) as response:
            status = response.getcode()
            
            if status == 200:
                print(f"Métrica Exitosa: {target_url} responde correctamente (Código 200).")
                return {"statusCode": 200, "body": "Sitio operativo."}
            else:
                raise Exception(f"Código de estado anómalo detectado: {status}")
                
    except Exception as e:
        error_msg = str(e)
        print(f"ALERTA DEL SISTEMA: {target_url} se encuentra CAÍDO. Detalle: {error_msg}")
        
        if slack_webhook_url:
            send_slack_notification(slack_webhook_url, target_url, error_msg)
        else:
            print("Error: No se ha configurado la variable de entorno SLACK_WEBHOOK_URL.")
            
        return {"statusCode": 500, "body": "Sitio fuera de servicio."}

def send_slack_notification(webhook_url, url, error):
    # Bloque de mensajería interactiva con formato gráfico de Slack (Block Kit)
    payload = {
        "text": "🚨 *¡Incidente de Disponibilidad Detectado!* 🚨",
        "attachments": [
            {
                "color": "#ef4444",
                "blocks": [
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": "El servicio web monitorizado ha dejado de responder de manera adecuada.\n\n*Detalles del Evento:*"
                        }
                    },
                    {
                        "type": "section",
                        "fields": [
                            {"type": "mrkdwn", "text": f"*URL Afectada:*\n{url}"},
                            {"type": "mrkdwn", "text": f"*Error Reportado:*\n`{error}`"}
                        ]
                    }
                ]
            }
        ]
    }
    
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(
        webhook_url,
        data=data,
        headers={'Content-Type': 'application/json'}
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            print("Notificación de alerta enviada con éxito a Slack.")
            return response.read()
    except Exception as e:
        print(f"Fallo crítico al intentar despachar la alerta hacia Slack: {e}")
