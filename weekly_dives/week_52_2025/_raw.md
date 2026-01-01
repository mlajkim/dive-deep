
<!-- TOC -->

- [Goal: Adding group as member also syncs its members to the role](#goal-adding-group-as-member-also-syncs-its-members-to-the-role)
  - [Setup: Create TLD `ajktown`](#setup-create-tld-ajktown)
  - [Setup: Create `ajktown`'s subdomain `ajktown.api`](#setup-create-ajktowns-subdomain-ajktownapi)
  - [Setup: Create group `ajktown.api:group.prod_cluster_connectors`](#setup-create-group-ajktownapigroupprod_cluster_connectors)
  - [Setup: Add `ajktown.api:group.prod_cluster_connectors` as member of `ajktown.api:role.prod_cluster_admins`](#setup-add-ajktownapigroupprod_cluster_connectors-as-member-of-ajktownapiroleprod_cluster_admins)
    - [Test: get members with `expand=true`](#test-get-members-with-expandtrue)
    - [Test: Get members without `expand=true`](#test-get-members-without-expandtrue)
- [Goal: Having delegated role member also works](#goal-having-delegated-role-member-also-works)
  - [Setup: Modify auto created role into a delegated role](#setup-modify-auto-created-role-into-a-delegated-role)
    - [Test: Expected to override existing role members once you set delegated domain](#test-expected-to-override-existing-role-members-once-you-set-delegated-domain)
    - [Test: Expected to fail creating both roleMembers and delegated domain](#test-expected-to-fail-creating-both-rolemembers-and-delegated-domain)
- [What I learned](#what-i-learned)

<!-- /TOC -->

# Goal: Adding group as member also syncs its members to the role

## Setup: Create TLD `ajktown`

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

## Setup: Create group `ajktown.api:group.prod_cluster_connectors`

> [!NOTE]
> - [API Source Code](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Group.rdli#L39-L57)
> - [Group tdl](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Group.tdl#L76-L82)

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/ajktown.api/group/prod_cluster_connectors" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "prod_cluster_connectors",
    "groupMembers": [
      {
        "memberName": "user.mlajkim"
      }
    ]
  }'

# {"name":"ajktown.api:group.prod_cluster_connectors","modified":"2026-01-01T01:05:05.643Z","groupMembers":[{"memberName":"user.mlajkim","approved":true}],"auditLog":[{"member":"user.mlajkim","admin":"user.athenz_admin","created":"2026-01-01T01:08:34.000Z","action":"ADD"}]}
```

## Setup: Add `ajktown.api:group.prod_cluster_connectors` as member of `ajktown.api:role.prod_cluster_admins`

> [!NOTE]
> - [API Source Code](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Role.rdli#L159-L184)
> - [Membership tdl](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Role.tdl#L94-L107)

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_admins/member/ajktown.api:group.prod_cluster_connectors" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "memberName": "ajktown.api:group.prod_cluster_connectors"
  }'

# {"memberName":"ajktown.api:group.prod_cluster_connectors","isMember":true,"roleName":"eks.users.ajktown-api:role.k8s_ns_admins","approved":true,"requestPrincipal":"user.athenz_admin"}
```

### Test: get members with `expand=true`

Let's get members of role `ajktown.api:role.prod_cluster_admins` to verify.

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "name": "eks.users.ajktown-api:role.k8s_ns_admins",
#   "modified": "2026-01-01T01:25:01.545Z",
#   "roleMembers": [
#     {
#       "memberName": "user.mlajkim",
#       "approved": true
#     },
#     {
#       "memberName": "user.alice",
#       "approved": true,
#       "auditRef": "added using Athenz UI",
#       "requestPrincipal": "user.athenz_admin"
#     },
#     {
#       "memberName": "user.bob",
#       "approved": true,
#       "auditRef": "added using Athenz UI",
#       "requestPrincipal": "user.athenz_admin"
#     }
#   ]
# }
```

### Test: Get members without `expand=true`

We can see that we no longer see the `user.mlajkim` inside the role members since we did not expand the group member.

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "name": "eks.users.ajktown-api:role.k8s_ns_admins",
#   "modified": "2026-01-01T01:25:01.545Z",
#   "roleMembers": [
#     {
#       "memberName": "ajktown.api:group.prod_cluster_connectors",
#       "approved": true,
#       "requestPrincipal": "user.athenz_admin"
#     },
#     {
#       "memberName": "user.alice",
#       "approved": true,
#       "auditRef": "added using Athenz UI",
#       "requestPrincipal": "user.athenz_admin"
#     },
#     {
#       "memberName": "user.bob",
#       "approved": true,
#       "auditRef": "added using Athenz UI",
#       "requestPrincipal": "user.athenz_admin"
#     }
#   ]
# }
```

# Goal: Having delegated role member also works


## Setup: Modify auto created role into a delegated role

> [!TIP]
> - [API](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Role.rdli#L159-L184)
> - [Role TDL](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Role.tdl#L73-L87)


### Test: Expected to override existing role members once you set delegated domain


```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "trust": "ajktown.api"
  }'

```

![delegated_role](./assets/delegated_role.png)

### Test: Expected to fail creating both roleMembers and delegated domain

> [!TIP]
> - [API](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Role.rdli#L159-L184)
> - [Role TDL](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Role.tdl#L73-L87)

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "trust": "ajktown.api",
    "roleMembers": [
      {
        "memberName": "user.alice"
      },
      {
        "memberName": "user.bob"
      }
    ]
  }'

# {"code":400,"message":"validateRoleMembers: Role cannot have both roleMembers and delegated domain set"}
```

# What I learned

- Learned about how to create TLD and subdomain in Athenz.
- Learned about how to create group in Athenz.
- Learned about how to add group as member of role in Athenz.
- Learned about various API endpoints in Athenz for domain, subdomain, group, and role management.
- Learned how to read rdli and tdl files to understand the structure of API requests and responses in Athenz.