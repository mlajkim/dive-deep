#!/usr/bin/env python3
import urllib.parse
import urllib.request
import json
import ssl
import sys
import os
import webbrowser

# Configuration - Prompt user or use env vars
def get_input(prompt, default_value, env_var_key=None):
    # 1. Check if environment variable exists (if key provided)
    if env_var_key:
        env_val = os.environ.get(env_var_key)
        if env_val:
            return env_val

    # 2. Prompt user
    # Show the default value in the prompt so user knows what happens on Enter
    user_input = input(f"{prompt} (Enter for default: {default_value}): ").strip()

    # 3. Logic: If input is empty, return default_value. Otherwise return user_input.
    if not user_input:
        return default_value
    
    return user_input

print("--- Okta to ZMS Verification Script ---")
OKTA_DOMAIN = get_input("Enter Okta Domain", "integrator-8302118.okta.com")
if not OKTA_DOMAIN.startswith("https://"):
    OKTA_DOMAIN = "https://" + OKTA_DOMAIN

CLIENT_ID = get_input("Enter Okta Client ID", "0oaz36xyehsYf8Cwz697")
REDIRECT_URI = get_input("Enter Redirect URI", "http://localhost:3200/oauth2/callback")
ZMS_URL = get_input("Enter ZMS URL", "http://localhost:4443/zms/v1")

# Remove trailing slash from ZMS URL if present
if ZMS_URL.endswith("/"):
    ZMS_URL = ZMS_URL[:-1]

# 1. Authorization Request
auth_url = f"{OKTA_DOMAIN}/oauth2/default/v1/authorize"
params = {
    "client_id": CLIENT_ID,
    "response_type": "code",
    "scope": "openid email profile",
    "redirect_uri": REDIRECT_URI,
    "state": "test_state",
    "nonce": "test_nonce"
}
full_auth_url = f"{auth_url}?{urllib.parse.urlencode(params)}"

print("\n--- Step 1: Login ---")
print(f"Please open the following URL in your browser:\n\n{full_auth_url}\n")
webbrowser.open(full_auth_url)
print("Login with your Okta test user.")
print("After login, you will be redirected to your Redirect URI with a 'code' parameter.")
print(f"Example: {REDIRECT_URI}?code=YOUR_CODE&state=test_state")

auth_code = input("\nEnter the value of the 'code' parameter: ").strip()

# 2. Token Exchange
print("\n--- Step 2: Exchange Code for Token ---")
# token_url = f"{OKTA_DOMAIN}/oauth2/v1/token"
token_url = f"{OKTA_DOMAIN}/oauth2/default/v1/token"
# Note: Some Okta orgs use /oauth2/default/v1/token or just /oauth2/v1/token. 
# Adjust if necessary based on your Okta Custom Authorization Server settings.

data = urllib.parse.urlencode({
    "grant_type": "authorization_code",
    "client_id": CLIENT_ID,
    "code": auth_code,
    "redirect_uri": REDIRECT_URI
}).encode("utf-8")

## 3. Temporary Token Server to get the request!
req = urllib.request.Request(token_url, data=data, headers={"Content-Type": "application/x-www-form-urlencoded"})

try:
    with urllib.request.urlopen(req) as response:
        token_response = json.loads(response.read().decode("utf-8"))
        id_token = token_response.get("id_token")
        access_token = token_response.get("access_token")
        print("\nSuccessfully obtained tokens!")
        # print(f"ID Token: {id_token[:20]}...")
        print(f"Access Token: {access_token[:20]}...")
except urllib.error.HTTPError as e:
    print(f"Error exchanging token: {e}")
    print(e.read().decode("utf-8"))
    sys.exit(1)

# 3. Call ZMS
print("\n--- Step 3: Verify with ZMS ---")
# Check if ZMS_URL is valid
if not ZMS_URL:
     print("ZMS URL not provided, skipping ZMS verification.")
     sys.exit(0)

zms_principal_url = f"{ZMS_URL}/principal"
print(f"Calling: {zms_principal_url}")

# Create an SSL context that ignores self-signed certs (for local testing)
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

req_zms = urllib.request.Request(zms_principal_url, headers={
    # ZMS often expects the token in a specific header or as Bearer
    # For OIDC federation, it is usually "Authorization: Bearer <id_token_or_access_token>"
    # Depending on configuration, it key be the id_token or access_token. 
    # Usually ZMS validates the JWT (Access Token) if it is an OAuth provider.
    "Authorization": f"Bearer {access_token}" 
})

try:
    with urllib.request.urlopen(req_zms, context=ctx) as response:
        print("\nZMS Response Code:", response.getcode())
        zms_resp = json.loads(response.read().decode("utf-8"))
        print("ZMS Response Body:")
        print(json.dumps(zms_resp, indent=2))
        print("\nSUCCESS: ZMS accepted the Okta token!")
except urllib.error.HTTPError as e:
    print(f"\nZMS Request Failed: {e}")
    print(e.read().decode("utf-8"))
    print("\nTroubleshooting Tips:")
    print("1. Ensure ZMS is configured to trust the Okta Issuer.")
    print("2. Check if ZMS expects the ID Token instead of Access Token.")
    print("3. Verify ZMS `athenz.auth.oauth.jwt.prop` properties match your Okta settings.")
except Exception as e:
    print(f"\nAn error occurred: {e}")
