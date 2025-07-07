import socket
import pyvjoy

j = pyvjoy.VJoyDevice(1)

# Testar o eixo X
j.set_axis(pyvjoy.HID_USAGE_X, 16384)
input("Centro - Pressione Enter para continuar")
 
j.set_axis(pyvjoy.HID_USAGE_X, 32768)
input("Direita - Pressione Enter para continuar")

j.set_axis(pyvjoy.HID_USAGE_X, 0)
input("Esquerda - Pressione Enter para continuar")

# Testar os botões 1 e 2
j.set_button(1, 1)
input("Botão 1 - Pressione Enter")

j.set_button(1, 0)  
j.set_button(2, 1)  
input("Botão 2 - Pressione Enter")

j.set_button(2, 0)

UDP_IP = "0.0.0.0"
UDP_PORT = 3333

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

def angle_to_vjoy(angle):
    return max(0, min(32768, int(16384 + (angle / 90.0) * 16384)))

while True:
    data, addr = sock.recvfrom(1024)
    message = data.decode().strip()
    
    try:
        parts = message.split("|")

        angle = 0.0
        throttle = 0
        brake = 0

        for part in parts:
            if part.startswith("angle:"):
                angle = float(part.split(":")[1])
            elif part.startswith("throttle:"):
                throttle = int(part.split(":")[1])
            elif part.startswith("brake:"):
                brake = int(part.split(":")[1])

        x_val = angle_to_vjoy(angle)
        j.set_axis(pyvjoy.HID_USAGE_X, x_val)

        # Botão 1 = throttle
        # Botão 2 = brake
        j.set_button(1, throttle)
        j.set_button(2, brake)

        # print(f"→ angle: {angle}° → X: {x_val} | throttle: {throttle} | brake: {brake}")

    except Exception as e:
        print(f"Falha ao processar mensagem: {e}")
