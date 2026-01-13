# About _raw.260112.md

This is a raw dump file for daily dive on jan-12-2026.

<!-- TOC -->

<!-- /TOC -->

# Goal: Install Okta


## Step: Get into website

I think this is my first time getting into the website:

https://www.okta.com/

![okta_developer](./assets/okta_developer.png)


## Setup: Sign up?

![sign_up_okta](./assets/sign_up_okta.png)

https://developer.okta.com/signup/

## Setup: Setting up okta

it seems like only work email works:

![okta_verify](./assets/okta_verify.png)


## Setup: Okta Verify for Mac OS

I don't want to bring my phone to work, so I will use Okta Verify for Mac OS:

![okta_verify_for_mac_install](./assets/okta_verify_for_mac_install.png)


### Test

Login completed!

![okta_login_complete](./assets/okta_login_complete.png)


# Goal


## Setup: Create app integration

> [!TIP]
> Official Athenz Doc: https://github.com/AthenZ/athenz/blob/master/docker/docs/IdP/Auth0.md

![create_app_integration](./assets/create_app_integration.png)
https://integrator-8302118-admin.okta.com/admin/apps/active

Click next with `OIDC` & `Web Application`:

![odic_n_web_app](./assets/odic_n_web_app.png)


- `Proof of possession`: Makes required signed token, for now we skip


## Setup


![authorization_server_api](./assets/authorization_server_api.png)

https://integrator-8302118-admin.okta.com/admin/oauth2/as


## Setup: Policy and rule, and test yourself

Create a scope `athenz`:
![create_scope](./assets/create_scope.png)

Test yourself:

![get_token_preview](./assets/get_token_preview.png)

## Setup: `sub` as athenz user service name

> [!NOTE]
> - [Source code](https://github.com/AthenZ/athenz/blob/master/libs/java/auth_core/src/main/java/com/yahoo/athenz/auth/oauth/OAuthCertBoundJwtAccessTokenAuthority.java#L100-L102) for authorized client ids not mandatory
> - [Source code](https://github.com/AthenZ/athenz/blob/master/libs/java/auth_core/src/main/java/com/yahoo/athenz/auth/oauth/OAuthCertBoundJwtAccessTokenAuthority.java#L246-L252) for using `sub` as service principal

Athenz only sees the `sub` field to define who you are. You can set up conversion field too but for now we can simply do this:

![sub_as_user_sevice_name](./assets/sub_as_user_sevice_name.png)

### Test

![test_sub_is_correct](./assets/test_sub_is_correct.png)


## Setup: Get Access Token

![id_and_secret](./assets/id_and_secret.png)

```sh
CLIENT_ID="0oaz36xyehsYf8Cwz697"
CLIENT_SECRET="PUT_YOUR_SECRET_HERE"

curl -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  "https://integrator-8302118.okta.com/oauth2/default/v1/token" \
  -d "grant_type=client_credentials" \
  -d "scope=athenz" | jq

# {
#   "token_type": "Bearer",
#   "expires_in": 3600,
#   "access_token": "CENSORED",
#   "scope": "athenz"
# }
```

## Test

```sh
TOKEN="PUT_YOUR_ACCESS_TOKEN"
curl -k -H "Authorization: Bearer $TOKEN" \
  "https://localhost:4443/zms/v1/domain"
```

## Setup: Adding ZMS properties so that ZMS can trust the okta verify

![zms_properties_setting](./assets/zms_properties_setting.png)

```sh
### Okta Configuration for ZMS ###

# Issuer:
athenz.auth.oauth.jwt.claim.aud=api://default
athenz.auth.oauth.jwt.claim.iss=https://integrator-8302118.okta.com/oauth2/default
athenz.auth.oauth.jwt.parser.jwks_url=https://integrator-8302118.okta.com/oauth2/default/v1/keys
athenz.auth.oauth.jwt.auth0.claim_client_id=cid
athenz.auth.oauth.jwt.verify_cert_thumbprint=false
athenz.auth.oauth.jwt.authorized_client_ids_path=/opt/athenz/zms/conf/authorized_client_ids.txt
```

## Setup: Create `/opt/athenz/zms/conf/authorized_client_ids.txt`

