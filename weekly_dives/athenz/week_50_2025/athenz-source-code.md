# Goal

The goal of this weekly dive is to explore the recent Athenz release v1.12.30:

https://github.com/AthenZ/athenz/releases/tag/v1.12.30

And possibly the https://github.com/AthenZ/athenz/issues/3100

With actual hands-on using https://github.com/ctyano/athenz-distribution

Also truly understand the following is very important:

```md
**What's shared**

* **Identity Mapping:** One asked how external credentials map to Athenz principles. Inc explained a new interface, `TokenExchangeIdentityProvider`, which handles the translation.
    * *Mechanism:* It takes the external token, extracts a unique identifier (e.g., Short ID from Okta), and maps it to an Athenz principal (e.g., `user.hga`).
    * *Claims:* It also allows mapping specific claims (e.g., preferred email) from the external provider to the ZTS token.
* **Scope Matching:** The scopes in the JAG token must generally match the roles in ZTS exactly, though overrides are possible in specific client calls.
* **UX vs. Security:** Inc clarified that the primary driver for JAG in AI Agent use cases (MCP) is **User Experience**, not just security.
    * *Problem:* Without JAG, an AI agent accessing 10 different tools would require the user to manually consent to 10 different prompts.
    * *Solution:* JAG moves consent to the administrator level. The user logs in once, and the system exchanges tokens for downstream services automatically behind the scenes.
* **Token Validity:** Refresh tokens can be used to keep the session alive based on company policy (e.g., 12 hours, 3 days), minimizing login frequency.

**Why it matters**
This architecture allows Athenz to support "Agentic AI" workflows where an AI agent needs to act on behalf of a user across multiple third-party services (Jira, GitHub, etc.) without triggering "consent fatigue" for the user.
```

<!-- TOC -->

- [Goal](#goal)

<!-- /TOC -->