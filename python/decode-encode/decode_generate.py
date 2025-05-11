'''
Title       : Base64 Decoder to YAML
Description : Skrip untuk decode value Base64 dan menyimpannya dalam file YAML.
Author      : Rizki permana
'''

import base64
import yaml

def decode_base64(data: str) -> str:
    decoded_bytes = base64.b64decode(data.encode('utf-8'))
    return decoded_bytes.decode('utf-8')

encoded_values = {}
while True:
    key = input("Enter key (or press Enter to finish): ")
    if not key:
        break
    value = input(f"Enter Base64 encoded value for {key}: ")
    encoded_values[key] = value

decoded_values = {key: decode_base64(value) for key, value in encoded_values.items()}

with open("secret-decode.yaml", "w") as file:
    yaml.dump(decoded_values, file, default_flow_style=False)

print("\nDecoded values have been saved to secret-decode.yaml")