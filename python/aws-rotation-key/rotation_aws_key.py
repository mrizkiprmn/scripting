import boto3
from dotenv import load_dotenv, set_key
import os
import sys

# Constants
ENV_PATH = ".env"
load_dotenv(dotenv_path=ENV_PATH)

# Get values from .env
aws_profile = os.getenv("AWS_PROFILE")
target_iam_user = os.getenv("TARGET_IAM_USER")

if not aws_profile or not target_iam_user:
    print("[x] Error: AWS_PROFILE or TARGET_IAM_USER not set in .env")
    sys.exit(1)

# Bikin session pakai profile
session = boto3.Session(profile_name=aws_profile)
iam = session.client("iam")

def rotate_access_key_for_user(username):
    print(f"[+] Rotating access key for IAM user: {username}")

    # 1. List access keys
    keys = iam.list_access_keys(UserName=username)["AccessKeyMetadata"]
    if len(keys) >= 2:
        print("[-] Error: IAM user already has 2 access keys. Manual cleanup needed.")
        sys.exit(1)

    # 2. Create new access key
    new_key = iam.create_access_key(UserName=username)["AccessKey"]
    access_key_id = new_key["AccessKeyId"]
    secret_access_key = new_key["SecretAccessKey"]
    print(f"[+] Created new key: {access_key_id}")

    # 3. Update .env with new credentials
    set_key(ENV_PATH, "AWS_ACCESS_KEY_ID", access_key_id)
    set_key(ENV_PATH, "AWS_SECRET_ACCESS_KEY", secret_access_key)
    print("[+] .env file updated with new credentials.")

    # 4. Delete old keys
    for key in keys:
        old_key_id = key["AccessKeyId"]
        if old_key_id != access_key_id:
            print(f"[-] Deleting old key: {old_key_id}")
            iam.update_access_key(UserName=username, AccessKeyId=old_key_id, Status="Inactive")
            iam.delete_access_key(UserName=username, AccessKeyId=old_key_id)

    print("[✓] Rotation complete.")

if __name__ == "__main__":
    rotate_access_key_for_user(target_iam_user)