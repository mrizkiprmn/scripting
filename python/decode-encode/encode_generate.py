'''
Title       : Base64 Encoder to YAML
Description : Skrip untuk mengonversi value teks menjadi Base64 dan menyimpannya dalam file YAML.
Author      : Rizki permana
'''

import base64
import yaml

def encode_base64(data: str) -> str:
    encoded_bytes = base64.b64encode(data.encode('utf-8'))
    return encoded_bytes.decode('utf-8')

encoded_values = {}
while True:
    key = input("Enter key (or press Enter to finish): ")
    if not key:
        break
    value = input(f"Enter value for {key}: ")
    encoded_values[key] = encode_base64(value)

with open("secret-encode.yaml", "w") as file:
    yaml.dump(encoded_values, file, default_flow_style=False)

print("\nFile secret-encode.yaml has been created with encoded values.")