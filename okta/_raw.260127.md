# Goal

Learn about XAA and Okta to realy understand the 

- Current problem we face
- How Athenz solves it with it (How Inc has such obstacles)

## Understand: RAG

- R: `Retrieval`: Basically instead of based on the internal knowledge of its LLM, it retrieves (`searches`) relevant information from external knowledge base
- A: `Augmented`: The search result itself is then augmented as a prompt, as most of the time, user's prompt is not enough to get the nuance of the question, so the `retrived` infrormation is smartly added (`augmented`) as a part of prompt
- G: `Generation`: Generates as it is, but to make it more accurate, it makes sure that the creativity of the LLM is constrained by the retrieved information (Usually `0`, meaning it strictly follows the retrieved information)



## Understand: `The ‘superuser’ blind spot: Why AI agents demand dedicated identity security`

![okta_identity_security](./assets/okta_identity_security.png)
https://www.okta.com/newsroom/articles/understanding-the-ai-agent-identity-challenge/

