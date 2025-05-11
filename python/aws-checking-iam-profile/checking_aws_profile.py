import boto3
from botocore.exceptions import ProfileNotFound, NoCredentialsError, ClientError
from dotenv import load_dotenv
import os
import sys

# Load .env file
ENV_PATH = ".env"
load_dotenv(dotenv_path=ENV_PATH)

# Ambil credential dari .env
aws_profile = os.getenv("AWS_PROFILE")
aws_access_key = os.getenv("AWS_ACCESS_KEY_ID")
aws_secret_key = os.getenv("AWS_SECRET_ACCESS_KEY")
iam_target_user = os.getenv("IAM_TARGET_USER")  # Tambahkan ini di .env juga

def verify_aws_profile(profile_name):
    try:
        print(f"[?] Checking AWS profile: {profile_name}")
        session = boto3.Session(profile_name=profile_name)
        sts = session.client("sts")
        identity = sts.get_caller_identity()
        print("[✓] Profile is valid and credentials are active.")
        print(f"    User ID : {identity['UserId']}")
        print(f"    Account : {identity['Account']}")
        print(f"    ARN     : {identity['Arn']}")
        return session
    except ProfileNotFound:
        print(f"[x] Error: AWS profile '{profile_name}' not found in your config.")
        sys.exit(1)
    except NoCredentialsError:
        print(f"[x] Error: No credentials found for profile '{profile_name}'.")
        sys.exit(1)
    except Exception as e:
        print(f"[x] Unexpected error: {str(e)}")
        sys.exit(1)

def check_target_iam_user(session, username):
    try:
        iam = session.client("iam")
        user = iam.get_user(UserName=username)["User"]
        print(f"[✓] Target IAM user '{username}' exists.")
        print(f"    User ARN : {user['Arn']}")
        print(f"    Created  : {user['CreateDate']}")
    except ClientError as e:
        if e.response['Error']['Code'] == 'NoSuchEntity':
            print(f"[x] Error: Target IAM user '{username}' does not exist.")
        else:
            print(f"[x] Error when checking IAM user: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if not aws_profile:
        print("[x] Error: AWS_PROFILE not found in .env")
        sys.exit(1)

    if not iam_target_user:
        print("[x] Error: IAM_TARGET_USER not found in .env")
        sys.exit(1)

    # Cek profile dan session
    session = verify_aws_profile(aws_profile)

    # Cek apakah user target untuk rotasi ada
    check_target_iam_user(session, iam_target_user)