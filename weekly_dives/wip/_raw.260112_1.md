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
```


# Goal

![get_token_preview](./assets/get_token_preview.png)