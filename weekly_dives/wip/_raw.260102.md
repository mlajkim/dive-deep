<!-- TOC -->

- [Goal: Learn about signed domain API](#goal-learn-about-signed-domain-api)
  - [Try: GET signed domain payload API WITHOUT eTag](#try-get-signed-domain-payload-api-without-etag)
  - [Try: READ payload inside the signed domain returned above](#try-read-payload-inside-the-signed-domain-returned-above)
  - [Try: Get signed domain payload API WITH eTag](#try-get-signed-domain-payload-api-with-etag)
  - [Try: Get Header TOO with `-i`](#try-get-header-too-with--i)
  - [Try: To get the 304 response](#try-to-get-the-304-response)
- [🟡 Goal: Test if group members/trusted role member changes affect the sign as well](#🟡-goal-test-if-group-memberstrusted-role-member-changes-affect-the-sign-as-well)
- [🟡 Goal: Deploy `athenz/k8s-athenz-syncer`](#🟡-goal-deploy-athenzk8s-athenz-syncer)
  - [Setup: Clone the repo](#setup-clone-the-repo)
- [Note](#note)
  - [Try: GET sys modified_domains API](#try-get-sys-modified_domains-api)
- [What I learned](#what-i-learned)

<!-- /TOC -->


# Goal: Learn about signed domain API

## Try: GET signed domain payload API WITHOUT eTag

- [API](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/SignedDomains.rdli#L85-L98)

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "payload": "eyJvcmciOiJhamtpbSIsImVuYWJsZWQiOnRydWUsImF1ZGl0RW5hYmxlZCI6ZmFsc2UsInlwbUlkIjowLCJuYW1lIjoiZWtzLnVzZXJzLmFqa3Rvd24tYXBpIiwicm9sZXMiOlt7Im5hbWUiOiJla3MudXNlcnMuYWprdG93bi1hcGk6cm9sZS5rOHNfbnNfYWRtaW5zIiwibW9kaWZpZWQiOiIyMDI2LTAxLTAxVDIyOjIxOjM3LjEzNFoiLCJyb2xlTWVtYmVycyI6W3sibWVtYmVyTmFtZSI6InVzZXIuYWxpY2UiLCJyZXF1ZXN0UHJpbmNpcGFsIjoidXNlci5hdGhlbnpfYWRtaW4iLCJwcmluY2lwYWxUeXBlIjoxfSx7Im1lbWJlck5hbWUiOiJ1c2VyLmJvYiIsInJlcXVlc3RQcmluY2lwYWwiOiJ1c2VyLmF0aGVuel9hZG1pbiIsInByaW5jaXBhbFR5cGUiOjF9LHsibWVtYmVyTmFtZSI6ImFqa3Rvd24uYXBpOmdyb3VwLnByb2RfY2x1c3Rlcl9jb25uZWN0b3JzIiwicmVxdWVzdFByaW5jaXBhbCI6InVzZXIuYXRoZW56X2FkbWluIiwicHJpbmNpcGFsVHlwZSI6M30seyJtZW1iZXJOYW1lIjoidXNlci5jeWFuIiwicmVxdWVzdFByaW5jaXBhbCI6InVzZXIuYXRoZW56X2FkbWluIiwicHJpbmNpcGFsVHlwZSI6MX1dfSx7Im5hbWUiOiJla3MudXNlcnMuYWprdG93bi1hcGk6cm9sZS5rOHNfbnNfdmlld2VycyIsIm1vZGlmaWVkIjoiMjAyNi0wMS0wMVQwMzoxMzoyNS44MjBaIiwidHJ1c3QiOiJhamt0b3duLmFwaSJ9LHsibmFtZSI6ImVrcy51c2Vycy5hamt0b3duLWFwaTpyb2xlLmFkbWluIiwibW9kaWZpZWQiOiIyMDI1LTEyLTMwVDA1OjI3OjEwLjMwMFoiLCJyb2xlTWVtYmVycyI6W3sibWVtYmVyTmFtZSI6InVzZXIuYXRoZW56X2FkbWluIiwicmVxdWVzdFByaW5jaXBhbCI6InVzZXIuYXRoZW56X2FkbWluIiwicHJpbmNpcGFsVHlwZSI6MX1dfV0sInBvbGljaWVzIjp7ImNvbnRlbnRzIjp7ImRvbWFpbiI6ImVrcy51c2Vycy5hamt0b3duLWFwaSIsInBvbGljaWVzIjpbeyJuYW1lIjoiZWtzLnVzZXJzLmFqa3Rvd24tYXBpOnBvbGljeS5hZG1pbiIsIm1vZGlmaWVkIjoiMjAyNS0xMi0zMFQwNToyNzoxMC4zMDJaIiwiYXNzZXJ0aW9ucyI6W3sicm9sZSI6ImVrcy51c2Vycy5hamt0b3duLWFwaTpyb2xlLmFkbWluIiwicmVzb3VyY2UiOiJla3MudXNlcnMuYWprdG93bi1hcGk6KiIsImFjdGlvbiI6IioiLCJlZmZlY3QiOiJBTExPVyIsImlkIjozM31dLCJ2ZXJzaW9uIjoiMCIsImFjdGl2ZSI6dHJ1ZX1dfSwic2lnbmF0dXJlIjoiTDhSemh1cnpCZTVNOFhjTEVBMEJ1cjRnckE5WURGclVuMjRDLmtDZmhJOThkSm9hQzRhQkhQMTJLbGNDcnRVVzVLUW1wR3diQnBjR19odzYzdmZYSjNNbjBibjR4amRUY3J0ZDU1WnExY04xbzBLMEFzcU5POWExc1BqNDNTZV84TC5ZRjlXeUg0blB5ak9BTlVPY2w1NEVmeEgzQnB5S0lkWWk2S0JTWFNTSUY4QndDV0VjVG9kVlJqZ2l0SUVpRndsbHlBTFBqV0ZZYkUyYUNBbnM1UFFYSFg5djFtbndxelVrUGU1WERZZ0VjMGh0TWtjX2s4SE9mcFl6ZUtjM1Zsb3BqZ0ZQUVRDWDh6NlY3NHRXYi41UW9Ba1JLZkRWOUxoeU1QQmtBMnkwRTRJd1pwS2tza1c0eWNhaWFfM1BNNlRLRGgweVdQMC5lb0VIejREQ1hYM3NGbm1JMXFBLnZkYmluMkNwWXp6RUdYMzR4MFJoWTdadE9UVW5DTG9NVG55N3k5NjNLX0ZJVEdBYmhsRnJLZnJ2aXdkb3NaaU9nUHh0QkFxNnRoLlBOOVY0VVJXUTYydWFQTXFWRkNJdHFvWWI5RFMydEtHR0h3V29JaHdtZVdrMHFacUtUNl9SYXFlWXh2NUZFaXRnZTNmNGlWdHFudVhWa0xLM3NyaUtTc1BJMVk5TkJSdlVNZ2FPeVpjN25tZXJSM3hmZTNidjhPYkhfQWRmN2cuaWhwWm1fYkZ0Zy5vT3NwMjdJV1dTS241WG1RTTZnQTFGSF9CQ2xSTG5QZ0VHclJvenJlbnhYRGNnOVdscVlVcXI3djk1NklxSHJ1UHd1b0ZOeXJGYVhNclV5cUdoOGNzUFJUZEJsM1k0N25BeE9NUTRUalBYNHNXNzNJSi5SSmstIiwia2V5SWQiOiJhdGhlbnotem1zLXNlcnZlci01NmRkNWZjYzVkLWQ1MjY4In0sInNlcnZpY2VzIjpbXSwiZW50aXRpZXMiOltdLCJncm91cHMiOltdLCJtb2RpZmllZCI6IjIwMjYtMDEtMDFUMjI6MjE6MzcuMTM1WiJ9",
#   "header": {
#     "kid": "athenz-zms-server-56dd5fcc5d-d5268"
#   },
#   "signature": "fJAxIVwD-Wr4KnJeffl_ebtctnGd3aaiBYGNIDBewI80eKBQZRgY-KwIGI2QXpWiQX4zYYFSMaO9WiybzPSSsBR1Zl-NcK54SJ_b86CBtgH8ChZ9mhgqKnGSxEuVI_Bp0Eegn9B9WAMK4nheEabhXa7t5vSiUi6oKuYjrSwPVTZpcPAbSwA8MFZmYfKAbPg4J9Ya8mOND_Js939Lj6Uly-4qRF2uHXq1z_CCMpJRCC5fkyWq1zdVucpPQLZBZQrrCGj4u7dsPFgs3BIA_h66dhMBLpdjVOWFYSN4Tc6caUNxJiEcEBBBSr9XFE85TW6P4AIaVF9vXsyqvvSpGYqtdzmpx5lrPrWZ_P0bcYr9jJNRoMvY87N0LjyUR3bdY2wDvo2sN4JYLjVon_Y9rMNwvmC_e_BI7TBAavE2QvvqR3R6fkfkgkG1vcwXhPa9UyB1JKC4qvXUvZjzVFlaX3S8AgsfYIyJZI84hJuqN1gAx5bfVxui3kxNN78-lQpad7r1EUsad4Yk13BHhxe13nxVWqHNFg9Q5QbX1GhyddKxoE31itdMtw9TGgyOXO76sMoKXpy1BdxFVKSDIcHEVAS3jXdEVl5212lRaGXnkZWE57929JYrOwjZI0JJcuZF83jHe_2ZLzQC6FEvRTIMYWO8ahExKSEaHht-AwJpAjvrK84",
#   "protected": "eyJraWQiOiJhdGhlbnotem1zLXNlcnZlci01NmRkNWZjYzVkLWQ1MjY4IiwiYWxnIjoiUlMyNTYifQ"
# }
```

## Try: READ payload inside the signed domain returned above

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq -r .payload | base64 -d | jq

# {
#   "org": "ajkim",
#   "enabled": true,
#   "auditEnabled": false,
#   "ypmId": 0,
#   "name": "eks.users.ajktown-api",
#   "roles": [
#     {
#       "name": "eks.users.ajktown-api:role.k8s_ns_admins",
#       "modified": "2026-01-01T22:21:37.134Z",
#       "roleMembers": [
#         {
#           "memberName": "user.alice",
#           "requestPrincipal": "user.athenz_admin",
#           "principalType": 1
#         },
#         {
#           "memberName": "user.bob",
#           "requestPrincipal": "user.athenz_admin",
#           "principalType": 1
#         },
#         {
#           "memberName": "ajktown.api:group.prod_cluster_connectors",
#           "requestPrincipal": "user.athenz_admin",
#           "principalType": 3
#         },
#         {
#           "memberName": "user.cyan",
#           "requestPrincipal": "user.athenz_admin",
#           "principalType": 1
#         }
#       ]
#     },
#     {
#       "name": "eks.users.ajktown-api:role.k8s_ns_viewers",
#       "modified": "2026-01-01T03:13:25.820Z",
#       "trust": "ajktown.api"
#     },
#     {
#       "name": "eks.users.ajktown-api:role.admin",
#       "modified": "2025-12-30T05:27:10.300Z",
#       "roleMembers": [
#         {
#           "memberName": "user.athenz_admin",
#           "requestPrincipal": "user.athenz_admin",
#           "principalType": 1
#         }
#       ]
#     }
#   ],
#   "policies": {
#     "contents": {
#       "domain": "eks.users.ajktown-api",
#       "policies": [
#         {
#           "name": "eks.users.ajktown-api:policy.admin",
#           "modified": "2025-12-30T05:27:10.302Z",
#           "assertions": [
#             {
#               "role": "eks.users.ajktown-api:role.admin",
#               "resource": "eks.users.ajktown-api:*",
#               "action": "*",
#               "effect": "ALLOW",
#               "id": 33
#             }
#           ],
#           "version": "0",
#           "active": true
#         }
#       ]
#     },
#     "signature": "L8RzhurzBe5M8XcLEA0Bur4grA9YDFrUn24C.kCfhI98dJoaC4aBHP12KlcCrtUW5KQmpGwbBpcG_hw63vfXJ3Mn0bn4xjdTcrtd55Zq1cN1o0K0AsqNO9a1sPj43Se_8L.YF9WyH4nPyjOANUOcl54EfxH3BpyKIdYi6KBSXSSIF8BwCWEcTodVRjgitIEiFwllyALPjWFYbE2aCAns5PQXHX9v1mnwqzUkPe5XDYgEc0htMkc_k8HOfpYzeKc3VlopjgFPQTCX8z6V74tWb.5QoAkRKfDV9LhyMPBkA2y0E4IwZpKkskW4ycaia_3PM6TKDh0yWP0.eoEHz4DCXX3sFnmI1qA.vdbin2CpYzzEGX34x0RhY7ZtOTUnCLoMTny7y963K_FITGAbhlFrKfrviwdosZiOgPxtBAq6th.PN9V4URWQ62uaPMqVFCItqoYb9DS2tKGGHwWoIhwmeWk0qZqKT6_RaqeYxv5FEitge3f4iVtqnuXVkLK3sriKSsPI1Y9NBRvUMgaOyZc7nmerR3xfe3bv8ObH_Adf7g.ihpZm_bFtg.oOsp27IWWSKn5XmQM6gA1FH_BClRLnPgEGrRozrenxXDcg9WlqYUqr7v956IqHruPwuoFNyrFaXMrUyqGh8csPRTdBl3Y47nAxOMQ4TjPX4sW73IJ.RJk-",
#     "keyId": "athenz-zms-server-56dd5fcc5d-d5268"
#   },
#   "services": [],
#   "entities": [],
#   "groups": [],
#   "modified": "2026-01-01T22:21:37.135Z"
# }
```

## Try: Get signed domain payload API WITH eTag

The response contains the status 304 Not Modified if the eTag matches, with no payload

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H 'If-None-Match: "2026-01-01T22:21:37.135Z"' | jq

# (Nothing is returned with 304 Not Modified)
```

## Try: Get Header TOO with `-i`

> [!TIP]
> If you do not want the data, you can just run the `-H 'If-None-Match: "2026-01-01T22:21:37.135Z"'`
> If update is done with `200`, you can use the payload to update your local cache!

I can see that eTag `"2026-01-01T22:21:37.135Z"`!

```sh
curl -i -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem

# HTTP/1.1 200 OK
# Host: athenz-zms-server-56dd5fcc5d-d5268
# ETag: "2026-01-01T22:21:37.135Z"
# Content-Type: application/json
# Content-Length: 3551

# {"payload":"eyJvcmciOiJhamtpbSIsImVuYWJsZWQiOnRydWUsImF1ZGl0RW5hYmxlZCI6ZmFsc2UsInlwbUlkIjowLCJuYW1lIjoiZWtzLnVzZXJzLmFqa3Rvd24tYXBpIiwicm9sZXMiOlt7Im5hbWUiOiJla3MudXNlcnMuYWprdG93bi1hcGk6cm9sZS5rOHNfbnNfYWRtaW5zIiwibW9kaWZpZWQiOiIyMDI2LTAxLTAxVDIyOjIxOjM3LjEzNFoiLCJyb2xlTWVtYmVycyI6W3sibWVtYmVyTmFtZSI6InVzZXIuYWxpY2UiLCJyZXF1ZXN0UHJpbmNpcGFsIjoidXNlci5hdGhlbnpfYWRtaW4iLCJwcmluY2lwYWxUeXBlIjoxfSx7Im1lbWJlck5hbWUiOiJ1c2VyLmJvYiIsInJlcXVlc3RQcmluY2lwYWwiOiJ1c2VyLmF0aGVuel9hZG1pbiIsInByaW5jaXBhbFR5cGUiOjF9LHsibWVtYmVyTmFtZSI6ImFqa3Rvd24uYXBpOmdyb3VwLnByb2RfY2x1c3Rlcl9jb25uZWN0b3JzIiwicmVxdWVzdFByaW5jaXBhbCI6InVzZXIuYXRoZW56X2FkbWluIiwicHJpbmNpcGFsVHlwZSI6M30seyJtZW1iZXJOYW1lIjoidXNlci5jeWFuIiwicmVxdWVzdFByaW5jaXBhbCI6InVzZXIuYXRoZW56X2FkbWluIiwicHJpbmNpcGFsVHlwZSI6MX1dfSx7Im5hbWUiOiJla3MudXNlcnMuYWprdG93bi1hcGk6cm9sZS5rOHNfbnNfdmlld2VycyIsIm1vZGlmaWVkIjoiMjAyNi0wMS0wMVQwMzoxMzoyNS44MjBaIiwidHJ1c3QiOiJhamt0b3duLmFwaSJ9LHsibmFtZSI6ImVrcy51c2Vycy5hamt0b3duLWFwaTpyb2xlLmFkbWluIiwibW9kaWZpZWQiOiIyMDI1LTEyLTMwVDA1OjI3OjEwLjMwMFoiLCJyb2xlTWVtYmVycyI6W3sibWVtYmVyTmFtZSI6InVzZXIuYXRoZW56X2FkbWluIiwicmVxdWVzdFByaW5jaXBhbCI6InVzZXIuYXRoZW56X2FkbWluIiwicHJpbmNpcGFsVHlwZSI6MX1dfV0sInBvbGljaWVzIjp7ImNvbnRlbnRzIjp7ImRvbWFpbiI6ImVrcy51c2Vycy5hamt0b3duLWFwaSIsInBvbGljaWVzIjpbeyJuYW1lIjoiZWtzLnVzZXJzLmFqa3Rvd24tYXBpOnBvbGljeS5hZG1pbiIsIm1vZGlmaWVkIjoiMjAyNS0xMi0zMFQwNToyNzoxMC4zMDJaIiwiYXNzZXJ0aW9ucyI6W3sicm9sZSI6ImVrcy51c2Vycy5hamt0b3duLWFwaTpyb2xlLmFkbWluIiwicmVzb3VyY2UiOiJla3MudXNlcnMuYWprdG93bi1hcGk6KiIsImFjdGlvbiI6IioiLCJlZmZlY3QiOiJBTExPVyIsImlkIjozM31dLCJ2ZXJzaW9uIjoiMCIsImFjdGl2ZSI6dHJ1ZX1dfSwic2lnbmF0dXJlIjoiTDhSemh1cnpCZTVNOFhjTEVBMEJ1cjRnckE5WURGclVuMjRDLmtDZmhJOThkSm9hQzRhQkhQMTJLbGNDcnRVVzVLUW1wR3diQnBjR19odzYzdmZYSjNNbjBibjR4amRUY3J0ZDU1WnExY04xbzBLMEFzcU5POWExc1BqNDNTZV84TC5ZRjlXeUg0blB5ak9BTlVPY2w1NEVmeEgzQnB5S0lkWWk2S0JTWFNTSUY4QndDV0VjVG9kVlJqZ2l0SUVpRndsbHlBTFBqV0ZZYkUyYUNBbnM1UFFYSFg5djFtbndxelVrUGU1WERZZ0VjMGh0TWtjX2s4SE9mcFl6ZUtjM1Zsb3BqZ0ZQUVRDWDh6NlY3NHRXYi41UW9Ba1JLZkRWOUxoeU1QQmtBMnkwRTRJd1pwS2tza1c0eWNhaWFfM1BNNlRLRGgweVdQMC5lb0VIejREQ1hYM3NGbm1JMXFBLnZkYmluMkNwWXp6RUdYMzR4MFJoWTdadE9UVW5DTG9NVG55N3k5NjNLX0ZJVEdBYmhsRnJLZnJ2aXdkb3NaaU9nUHh0QkFxNnRoLlBOOVY0VVJXUTYydWFQTXFWRkNJdHFvWWI5RFMydEtHR0h3V29JaHdtZVdrMHFacUtUNl9SYXFlWXh2NUZFaXRnZTNmNGlWdHFudVhWa0xLM3NyaUtTc1BJMVk5TkJSdlVNZ2FPeVpjN25tZXJSM3hmZTNidjhPYkhfQWRmN2cuaWhwWm1fYkZ0Zy5vT3NwMjdJV1dTS241WG1RTTZnQTFGSF9CQ2xSTG5QZ0VHclJvenJlbnhYRGNnOVdscVlVcXI3djk1NklxSHJ1UHd1b0ZOeXJGYVhNclV5cUdoOGNzUFJUZEJsM1k0N25BeE9NUTRUalBYNHNXNzNJSi5SSmstIiwia2V5SWQiOiJhdGhlbnotem1zLXNlcnZlci01NmRkNWZjYzVkLWQ1MjY4In0sInNlcnZpY2VzIjpbXSwiZW50aXRpZXMiOltdLCJncm91cHMiOltdLCJtb2RpZmllZCI6IjIwMjYtMDEtMDFUMjI6MjE6MzcuMTM1WiJ9","header":{"kid":"athenz-zms-server-56dd5fcc5d-d5268"},"signature":"fJAxIVwD-Wr4KnJeffl_ebtctnGd3aaiBYGNIDBewI80eKBQZRgY-KwIGI2QXpWiQX4zYYFSMaO9WiybzPSSsBR1Zl-NcK54SJ_b86CBtgH8ChZ9mhgqKnGSxEuVI_Bp0Eegn9B9WAMK4nheEabhXa7t5vSiUi6oKuYjrSwPVTZpcPAbSwA8MFZmYfKAbPg4J9Ya8mOND_Js939Lj6Uly-4qRF2uHXq1z_CCMpJRCC5fkyWq1zdVucpPQLZBZQrrCGj4u7dsPFgs3BIA_h66dhMBLpdjVOWFYSN4Tc6caUNxJiEcEBBBSr9XFE85TW6P4AIaVF9vXsyqvvSpGYqtdzmpx5lrPrWZ_P0bcYr9jJNRoMvY87N0LjyUR3bdY2wDvo2sN4JYLjVon_Y9rMNwvmC_e_BI7TBAavE2QvvqR3R6fkfkgkG1vcwXhPa9UyB1JKC4qvXUvZjzVFlaX3S8AgsfYIyJZI84hJuqN1gAx5bfVxui3kxNN78-lQpad7r1EUsad4Yk13BHhxe13nxVWqHNFg9Q5QbX1GhyddKxoE31itdMtw9TGgyOXO76sMoKXpy1BdxFVKSDIcHEVAS3jXdEVl5212lRaGXnkZWE57929JYrOwjZI0JJcuZF83jHe_2ZLzQC6FEvRTIMYWO8ahExKSEaHht-AwJpAjvrK84","protected":"eyJraWQiOiJhdGhlbnotem1zLXNlcnZlci01NmRkNWZjYzVkLWQ1MjY4IiwiYWxnIjoiUlMyNTYifQ"}
```

## Try: To get the 304 response

> [!TIP]
> Follows `RFC 7232`

Ah-ha!

```sh
curl -i -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H 'If-None-Match: "2026-01-01T22:21:37.135Z"'

# HTTP/1.1 304 Not Modified
# Host: athenz-zms-server-56dd5fcc5d-d5268
# ETag: "2026-01-01T22:21:37.135Z"
# Content-Length: 0
```

# 🟡 Goal: Test if group members/trusted role member changes affect the sign as well

**Init**

```sh
curl -sS -k -D - -o /dev/null -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H 'If-None-Match: "2026-01-01T22:21:37.135Z"'

# HTTP/1.1 304 Not Modified
# Host: athenz-zms-server-56dd5fcc5d-d5268
# ETag: "2026-01-01T22:21:37.135Z"
# Content-Length: 0
```

**Create Role Member `user.george` in `eks.users.ajktown-api:role.k8s_ns_admins`**

```sh
curl -sS -k -D - -o /dev/null -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/signed" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H 'If-None-Match: "2026-01-01T22:21:37.135Z"'

# HTTP/1.1 200 OK
# Host: athenz-zms-server-56dd5fcc5d-d5268
# ETag: "2026-01-02T06:22:09.082Z"
# Content-Type: application/json
# Content-Length: 3666
```


**Create Role Member `user.dyson` in `eks.users.ajktown-api:role.k8s_ns_admins`**

🟡 todo: test me

```sh

```

**Delete Role Member `user.dyson` in `eks.users.ajktown-api:role.k8s_ns_admins`**

🟡 todo: test me

```sh

```

**Create Role Member `user.emma` in `ajktown.api:role.k8s_ns_viewers`**

🟡 todo: test me

```sh

```

**Delete Role Member `user.emma` in `ajktown.api:role.k8s_ns_viewers`**

🟡 todo: test me

```sh

```

**Create Member `user.frank` in Group `ajktown.api:group.prod_cluster_connectors`**

🟡 todo: test me

```sh

```

**Delete Member `user.frank` in Group `ajktown.api:group.prod_cluster_connectors`**

🟡 todo: test me

```sh

```

# 🟡 Goal: Deploy `athenz/k8s-athenz-syncer`

## Setup: Clone the repo

```sh
git clone https://github.com/AthenZ/k8s-athenz-syncer.git k8s_athenz_syncer
```


# Note

## Try: GET sys modified_domains API

> [!NOTE]
> - [API Source Code](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/SignedDomains.rdli#L52-L74)

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/sys/modified_domains?domain=eks.users.ajktown-api&metaonly=true" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "domains": [
#     {
#       "domain": {
#         "enabled": true,
#         "name": "eks.users.ajktown-api",
#         "roles": null,
#         "policies": null,
#         "services": null,
#         "entities": null,
#         "groups": null,
#         "modified": "2026-01-01T22:21:37.135Z"
#       }
#     }
#   ]
# }
```


# What I learned

It is actually important to use the signed one with eTag for security + performance.

What if data is hijacked in between? Some of them may get permissions that they should not have.