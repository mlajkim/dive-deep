
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
    - [Test: Expect to reject delegating itself](#test-expect-to-reject-delegating-itself)
      - [Dive: Handle case sensitivity in endpoint domain names](#dive-handle-case-sensitivity-in-endpoint-domain-names)
      - [Dive: Handle case sensitivity in both endpoint & body](#dive-handle-case-sensitivity-in-both-endpoint--body)
      - [Dive: Handle case sensitivity in body](#dive-handle-case-sensitivity-in-body)
      - [Dive: Creates a PR for optimization](#dive-creates-a-pr-for-optimization)
  - [Setup: Create a role in trusted tenant domain](#setup-create-a-role-in-trusted-tenant-domain)
  - [Setup: Create a policy](#setup-create-a-policy)
  - [Verify: Creating delegated role works as expected](#verify-creating-delegated-role-works-as-expected)
- [Goal: Experiment with modified date](#goal-experiment-with-modified-date)
  - [Setup: Create a script to fetch modified date with/without expand](#setup-create-a-script-to-fetch-modified-date-withwithout-expand)
  - [Verify: Expect to modify domain when modifying role inside it](#verify-expect-to-modify-domain-when-modifying-role-inside-it)
- [Goal: Deploy `athenz/k8s-athenz-syncer`](#goal-deploy-athenzk8s-athenz-syncer)
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

> [!TIP]
> It will delete existing members.

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
> - [Related Error Response](https://github.com/AthenZ/athenz/blob/master/servers/zms/src/main/java/com/yahoo/athenz/zms/ZMSImpl.java#L4575-L4604)

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

### Test: Expect to reject delegating itself

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "trust": "eks.users.ajktown-api"
  }'

# {"code":400,"message":"validateRoleMembers: Role cannot be delegated to itself"}
```

#### Dive: Handle case sensitivity in endpoint domain names

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "trust": "eks.users.ajktown-Api"
  }'

# {"code":400,"message":"validateRoleMembers: Role cannot be delegated to itself"}
```

#### Dive: Handle case sensitivity in both endpoint & body

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-Api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "trust": "eks.users.ajktown-Api"
  }'

# {"code":400,"message":"validateRoleMembers: Role cannot be delegated to itself"}
```

#### Dive: Handle case sensitivity in body

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/eks.users.ajktown-Api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "trust": "eks.users.ajktown-api"
  }'

# {"code":400,"message":"validateRoleMembers: Role cannot be delegated to itself"}
```

#### Dive: Creates a PR for optimization

As I try to read the section of the role validation code, I found that the logic first checks `getAthenzDomain()` method, that requires DB call, then compares the names.

So I made a brain-dead simple PR to optimize this by comparing the names first before calling the DB: [Refactor: (Very minor change) Optimize validation order in validateRoleStructure #3166](https://github.com/AthenZ/athenz/pull/3166)

## Setup: Create a role in trusted tenant domain

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/ajktown.api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "k8s_ns_viewers",
    "roleMembers": [
      {
        "memberName": "user.mlajkim"
      }
    ]
  }'

# {"name":"ajktown.api:role.k8s_ns_viewers","modified":"2026-01-01T04:23:12.928Z","roleMembers":[{"memberName":"user.mlajkim","approved":true,"requestPrincipal":"user.athenz_admin"}],"auditLog":[{"member":"user.mlajkim","admin":"user.athenz_admin","created":"2026-01-01T04:23:12.000Z","action":"ADD"}]}
```

## Setup: Create a policy

- [API](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Policy.rdli#L59-L77)
- [TDL: Policy](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Policy.tdl#L48-L59)
- [TDL: Assertion](https://github.com/AthenZ/athenz/blob/master/core/zms/src/main/rdl/Policy.tdl#L30-L40)

```sh
curl -k -X PUT "https://localhost:4443/zms/v1/domain/ajktown.api/policy/allow_role_sync" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -H "Athenz-Return-Object: true" \
  -d '{
    "name": "allow_role_sync",
    "assertions": [
      {
        "effect": "ALLOW",
        "resource": "eks.users.ajktown-api:role.k8s_ns_viewers",
        "action": "assume_role",
        "role": "ajktown.api:role.k8s_ns_viewers"
      }
    ]
  }'

# {"name":"ajktown.api:policy.allow_role_sync","modified":"2026-01-01T04:37:08.642Z","assertions":[{"role":"ajktown.api:role.k8s_ns_viewers","resource":"eks.users.ajktown-api:role.k8s_ns_viewers","action":"assume_role","effect":"ALLOW","id":40}],"version":"0","active":true}
```

## Verify: Creating delegated role works as expected

![delegated_role_member_adding](./assets/delegated_role_member_adding.gif)

```sh
curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "name": "eks.users.ajktown-api:role.k8s_ns_viewers",
#   "modified": "2026-01-01T03:13:25.820Z",
#   "roleMembers": [
#     {
#       "memberName": "user.mlajkim",
#       "requestPrincipal": "user.athenz_admin",
#       "principalType": 1
#     }
#   ],
#   "trust": "ajktown.api"
# }
```

```sh

curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "org": "ajkim",
#   "enabled": true,
#   "auditEnabled": false,
#   "ypmId": 0,
#   "autoDeleteTenantAssumeRoleAssertions": false,
#   "name": "eks.users.ajktown-api",
#   "modified": "2026-01-01T07:05:15.547Z",
#   "id": "3081dc90-e540-11f0-9dea-17c92bf9f5a9"
# }

curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

curl -sS -k -X GET "https://localhost:4443/zms/v1/domain/eks.users.ajktown-api/role/k8s_ns_viewers" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem | jq

# {
#   "name": "eks.users.ajktown-api:role.k8s_ns_viewers",
#   "modified": "2026-01-01T03:13:25.820Z",
#   "trust": "ajktown.api"
# }
```

# Goal: Experiment with modified date

## Setup: Create a script to fetch modified date with/without expand


```sh

bash << 'EOF'
# --- Config ---
CERT="./athenz_distribution/certs/athenz_admin.cert.pem"
KEY="./athenz_distribution/keys/athenz_admin.private.pem"
BASE_URL="https://localhost:4443/zms/v1"

# --- Targets List ---
TARGETS=(
  "domain/eks.users.ajktown-api"
  "domain/eks.users.ajktown-api/role/k8s_ns_admins"
  "domain/eks.users.ajktown-api/role/k8s_ns_viewers"
  "domain/ajktown.api"
  "domain/ajktown.api/role/k8s_ns_viewers"
  "domain/ajktown.api/group/prod_cluster_connectors"
)

# --- Header ---
echo "| Target Resource  | Modified Date (UTC) | Modified |"
echo "| :--- | :---: | :---: |"

# --- Function ---
fetch_and_print() {
  local resource_path=$1
  local expand_val=$2
  local url="${BASE_URL}/${resource_path}?expand=${expand_val}"

  # cURL: Body + HTTP Code extraction
  response=$(curl -s -k \
    --cert "${CERT}" \
    --key "${KEY}" \
    -w "\n%{http_code}" \
    "${url}")

  http_code=$(echo "$response" | tail -n1)
  json_body=$(echo "$response" | sed '$d')

  # Parse Modified Date
  modified_ts=$(echo "$json_body" | jq -r '.modified // "null"')

  if [ "$http_code" -ne 200 ]; then
    error_msg=$(echo "$json_body" | jq -r '.message // "Unknown Error"')
    echo "| \`${resource_path}\?expand=${expand_val}\`| ❌ **Error**: ${error_msg} ||"
  else
    echo "| \`${resource_path}?expand=${expand_val}\`  | \`${modified_ts}\` ||"
  fi
}

# --- Execution Loop ---
for target in "${TARGETS[@]}"; do
  fetch_and_print "$target" "false"
  fetch_and_print "$target" "true"
done
EOF

```

## Verify: Expect to modify domain when modifying role inside it

Domain's modified date only changes when we modify the role inside it so even if members change from groups/delegated roles outside the domain, it does not affect the domain's modified date. So possibly creating a syncer job to sync modified date could be bad idea.

Conclusion, simply using `expand=true` to get members could be brute but still the most efficient way to get the accurate members including group members and delegated role members, besides server side push (ideal)


**Init**

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:18:25.618Z` |          |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:18:25.618Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:18:25.617Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:18:25.617Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:17:59.583Z` |          |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:17:59.583Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:17:59.580Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:17:59.580Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:17:32.136Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:17:32.136Z` |          |


**Create Role Member `user.dyson` in `eks.users.ajktown-api:role.k8s_ns_admins`**

> [!CRITICAL]
> There is a difference in 0.001 second between domain and role modified date.

> [!TIP]
> Maybe I can create a PR fixing this problem later.

We can see that the domain modifies too when we modify the role inside it, however it is NOT the perfect time, and we can see 0.001 second difference, sometimes.

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:20:08.841Z` |   YES    |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:20:08.841Z` |   YES    |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:20:08.840Z` |   YES    |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:20:08.840Z` |   YES    |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:17:59.583Z` |          |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:17:59.583Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:17:59.580Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:17:59.580Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:17:32.136Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:17:32.136Z` |          |

**Delete Role Member `user.dyson` in `eks.users.ajktown-api:role.k8s_ns_admins`**

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:21:37.135Z` |   YES    |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:21:37.135Z` |   YES    |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:21:37.134Z` |   YES    |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:21:37.134Z` |   YES    |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:17:59.583Z` |          |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:17:59.583Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:17:59.580Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:17:59.580Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:17:32.136Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:17:32.136Z` |          |

**Create Role Member `user.emma` in `ajktown.api:role.k8s_ns_viewers`**

> [!TIP]
> Please note that you cannot directly insert member in the delegated role. You have to insert member in the trusted role.

> [!CRITICAL]
> Provider domain `eks.users.ajktown-api` modified date did **NOT** change when we modify the trusted role `ajktown.api:role.k8s_ns_viewers`.

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:23:10.454Z` |   YES    |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:23:10.454Z` |   YES    |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:23:10.454Z` |   YES    |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:23:10.454Z` |   YES    |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:17:32.136Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:17:32.136Z` |          |


**Delete Role Member `user.emma` in `ajktown.api:role.k8s_ns_viewers`**

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:24:19.537Z` |   YES    |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:24:19.537Z` |   YES    |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:24:19.537Z` |   YES    |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:24:19.537Z` |   YES    |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:17:32.136Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:17:32.136Z` |          |


**Create Member `user.frank` in Group `ajktown.api:group.prod_cluster_connectors`**

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:25:28.744Z` |   YES    |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:25:28.744Z` |   YES    |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:24:19.537Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:24:19.537Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:25:28.742Z` |   YES    |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:25:28.742Z` |   YES    |

**Delete Member `user.frank` in Group `ajktown.api:group.prod_cluster_connectors`**

| Target Resource                                                 |    Modified Date (UTC)     | Modified |
|:----------------------------------------------------------------|:--------------------------:|:--------:|
| `domain/eks.users.ajktown-api?expand=false`                     | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api?expand=true`                      | `2026-01-01T22:21:37.135Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=false`  | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_admins?expand=true`   | `2026-01-01T22:21:37.134Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=false` | `2026-01-01T03:13:25.820Z` |          |
| `domain/eks.users.ajktown-api/role/k8s_ns_viewers?expand=true`  | `2026-01-01T03:13:25.820Z` |          |
| `domain/ajktown.api?expand=false`                               | `2026-01-01T22:26:13.734Z` |   YES    |
| `domain/ajktown.api?expand=true`                                | `2026-01-01T22:26:13.734Z` |   YES    |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=false`           | `2026-01-01T22:24:19.537Z` |          |
| `domain/ajktown.api/role/k8s_ns_viewers?expand=true`            | `2026-01-01T22:24:19.537Z` |          |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=false` | `2026-01-01T22:26:13.733Z` |   YES    |
| `domain/ajktown.api/group/prod_cluster_connectors?expand=true`  | `2026-01-01T22:26:13.733Z` |   YES    |

# Goal: Deploy `athenz/k8s-athenz-syncer`

```sh
git clone https://github.com/AthenZ/k8s-athenz-syncer.git k8s_athenz_syncer
```
ㅑ

# What I learned

- Learned about how to create TLD and subdomain in Athenz.
- Learned about how to create group in Athenz.
- Learned about how to add group as member of role in Athenz.
- Learned about various API endpoints in Athenz for domain, subdomain, group, and role management.
- Learned how to read rdli and tdl files to understand the structure of API requests and responses in Athenz.