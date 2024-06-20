import boto3
import tempfile
import json
import subprocess
import os
import sys
import requests
from urllib.parse import urlencode
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

app_name = "Console_Launcher"

# TODO - read these values from ~/.aws/credentials
role_arns = {
    "shared": "arn:aws:iam::890428854401:role/dbl-shared-sre",
    "dev": "arn:aws:iam::680851792543:role/dbl-dev-sre",
    "prod": "arn:aws:iam::766520336852:role/dbl-prod-sre",
    "rpprod": "arn:aws:iam::240013121649:role/dbl-rpprod-sre",
    "rpdev": "arn:aws:iam::023666771668:role/dbl-rpdev-sre",
    "stage": "arn:aws:iam::508658330820:role/dbl-stage-sre",
    "root": "arn:aws:iam::642622324794:role/FederatedAdmin"
}

profile_names = {"root": "FederatedAdmin"}


def generate_presigned_console_url(account_name, duration_seconds=3600):

    profile_name = f'dbl-{account_name}-sre'
    if account_name in profile_names:
        profile_name = profile_names[account_name]

    role_name = role_arns[account_name]

    try:
        # Create a session using the specified profile
        session = boto3.Session(profile_name=profile_name)

        credentials = session.get_credentials().get_frozen_credentials()

        # Create a STS client with the session
        signin_token_url = 'https://signin.aws.amazon.com/federation'

        signin_token_params = {
            'Action':
            'getSigninToken',
            'Session':
            json.dumps({
                'sessionId': credentials.access_key,
                'sessionKey': credentials.secret_key,
                'sessionToken': credentials.token
            })
        }
        signin_token_response = requests.get(signin_token_url,
                                             params=signin_token_params)
        signin_token = signin_token_response.json()['SigninToken']

        # Create the login URL
        login_url_params = {
            'Action': 'login',
            'Issuer': app_name,
            'Destination': 'https://console.aws.amazon.com/',
            'SigninToken': signin_token
        }
        login_url = f"https://signin.aws.amazon.com/federation?{urlencode(login_url_params)}"

        return login_url

    except NoCredentialsError:
        print("No AWS credentials found.")
        return None
    except PartialCredentialsError:
        print("Incomplete AWS credentials found.")
        return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None


def open_chrome_with_link(link):

    chrome_app_path = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    if not os.path.exists(chrome_app_path):
        print("Chrome is not installed!")
        sys.exit()

    with tempfile.TemporaryDirectory() as temp_dir:
        chrome_profile_dir = os.path.join(temp_dir, "chrome_profile")
        command = [
            chrome_app_path, "--no-first-run", "--no-default-browser-check",
            "--user-data-dir={}".format(chrome_profile_dir), link
        ]

        # TODO handle chrome exiting and clean up the folder afterwards
        subprocess.Popen(command,
                         stdout=subprocess.DEVNULL,
                         stderr=subprocess.DEVNULL,
                         preexec_fn=os.setpgrp)


def main():

    if len(sys.argv) <= 1:
        print("no account-name was passed!")
        sys.exit(-1)
    elif len(sys.argv) > 2:
        print("too many arguments!")
        sys.exit(-1)

    account = sys.argv[1]

    print(account)

    # TODO check if creds in ~/.aws/credentials are expired

    url = generate_presigned_console_url(account)

    # print(url)

    open_chrome_with_link(url)


if __name__ == "__main__":
    main()
