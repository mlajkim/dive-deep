
<!-- TOC -->

- [Setup: Create `ajktown` domain and its subdomain `ajktown.api`](#setup-create-ajktown-domain-and-its-subdomain-ajktownapi)
- [Setup: Create `ajktown`'s subdomain `ajktown.api`](#setup-create-ajktowns-subdomain-ajktownapi)

<!-- /TOC -->

## Setup: Create `ajktown` domain and its subdomain `ajktown.api`

```sh
curl -k -X POST "https://localhost:4443/zms/v1/domain" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ajktown",
    "description": "AJK Town Server Domain",
    "org": "ajkim",
    "enabled": true,
    "adminUsers": ["user.athenz_admin"]
  }'

# {"description":"AJK Town Server Domain","org":"ajkim","auditEnabled":false,"ypmId":0,"autoDeleteTenantAssumeRoleAssertions":false,"name":"ajktown","modified":"2026-01-01T00:26:14.153Z","id":"7b086f90-e6a8-11f0-9dea-17c92bf9f5a9"}
```

## Setup: Create `ajktown`'s subdomain `ajktown.api`

```sh
curl -k -X POST "https://localhost:4443/zms/v1/subdomain/ajktown" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -d '{
    "parent": "ajktown",
    "name": "api",
    "description": "AJK Town API Subdomain",
    "org": "ajkim",
    "enabled": true,
    "adminUsers": ["user.athenz_admin"]
  }'

# {"description":"AJK Town API Subdomain","org":"ajkim","auditEnabled":false,"name":"ajktown.api","modified":"2026-01-01T00:26:28.298Z","id":"8376caa0-e6a8-11f0-9dea-17c92bf9f5a9"}
```