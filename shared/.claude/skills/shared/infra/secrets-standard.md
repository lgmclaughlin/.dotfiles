# Secrets Standard

Standard approach for storing, naming, and retrieving application secrets across projects.

## Provider

AWS Secrets Manager. Each secret stores a JSON string of key-value pairs (or occasionally a plain string for single-value credentials like tokens).

## Naming Convention

```
{project}/{environment}/{purpose}
```

- **project**: the repository or service name, lowercase with hyphens (e.g. `tally`, `cerebro`, `scale-ads-data-pipeline`)
- **environment**: `dev`, `staging`, or `prod`. Include this segment when the project has environment-specific resources (databases, warehouses, API accounts). It enables per-environment IAM scoping and prevents accidental cross-environment access. Omit it when the project is environment-agnostic (single deployment target, shared credentials across all stages, or infrastructure that doesn't distinguish environments).
- **purpose**: a short descriptor of what the secret contains, lowercase with hyphens (e.g. `db-credentials`, `api-keys`, `snowflake-credentials`, `slack-bot-token`)

Examples:
```
tally/prod/db-credentials
cerebro/dev/api-keys
scale-ads-data-pipeline/snowflake-credentials
cerebro/onelogin
```

## Secret Grouping

Group related credentials into a single secret when they are always consumed together:

- **Database credentials**: one secret per database per environment (`db-credentials`, `snowflake-credentials`)
- **API keys**: bundle all third-party API keys into one secret per environment (`api-keys`) when they share the same access pattern and lifecycle
- **Service tokens**: store individually when they have distinct rotation schedules or access scopes (`slack-bot-token`, `jwt-signing-key`)

The goal is to minimize the number of Secrets Manager calls at startup without over-bundling credentials that have different rotation or access needs.

## JSON Key Naming

Use `UPPERCASE_UNDERSCORE` for all keys inside a secret's JSON payload. This convention matches environment variable naming and avoids remapping.

```json
{
  "POSTGRES_HOST": "db.example.com",
  "POSTGRES_PORT": "5432",
  "POSTGRES_DATABASE": "app",
  "POSTGRES_USER": "svc_app",
  "POSTGRES_PASSWORD": "..."
}
```

When a key name is inherently scoped by the secret it lives in, do not re-prefix it. For example, inside `{project}/{env}/snowflake-credentials`, use `SNOWFLAKE_ACCOUNT` rather than `SF_CRED_ACCOUNT`, since the secret path already provides context.

## Common Secret Schemas

### Database (Postgres)

Secret name: `{project}/{env}/db-credentials`

| Key | Required | Description |
|---|---|---|
| `POSTGRES_HOST` | Yes | Database hostname |
| `POSTGRES_PORT` | No (default: 5432) | Database port |
| `POSTGRES_DATABASE` | Yes | Database name |
| `POSTGRES_USER` | Yes | Service account username |
| `POSTGRES_PASSWORD` | Yes | Service account password |

### Data Warehouse (Snowflake, password auth)

Secret name: `{project}/{env}/snowflake-credentials`

| Key | Required | Description |
|---|---|---|
| `SNOWFLAKE_ACCOUNT` | Yes | Account identifier |
| `SNOWFLAKE_USER` | Yes | Service account username |
| `SNOWFLAKE_PASSWORD` | Yes | Service account password |
| `SNOWFLAKE_ROLE` | No | Role to assume |
| `SNOWFLAKE_WAREHOUSE` | No | Compute warehouse |
| `SNOWFLAKE_DATABASE` | No | Default database |
| `SNOWFLAKE_SCHEMA` | No | Default schema |

### Data Warehouse (Snowflake, key-pair auth)

Same secret name. Key-pair auth replaces the password field:

| Key | Required | Description |
|---|---|---|
| `SNOWFLAKE_ACCOUNT` | Yes | Account identifier |
| `SNOWFLAKE_USER` | Yes | Service account username |
| `SNOWFLAKE_PRIVATE_KEY` | Yes | PEM-encoded private key |
| `SNOWFLAKE_PRIVATE_KEY_PASSPHRASE` | No | Passphrase for encrypted key |
| `SNOWFLAKE_ROLE` | No | Role to assume |
| `SNOWFLAKE_WAREHOUSE` | No | Compute warehouse |
| `SNOWFLAKE_DATABASE` | No | Default database |

Pipeline-style workloads that write to specific schemas may add per-source schema keys (e.g. `SNOWFLAKE_SCHEMA_MICROSOFT`) rather than a single `SNOWFLAKE_SCHEMA`.

### API Keys

Secret name: `{project}/{env}/api-keys`

Keys are named after the service in uppercase: `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`, etc. Bundle into one secret when they share the same access pattern.

### Single-Value Secrets

Some credentials are a single opaque string (OAuth tokens, signing keys, bot tokens). These can be stored as:
- A JSON object with one key: `{"TOKEN": "xoxb-..."}` (preferred for consistency)
- A plain string (acceptable when the secret will never gain additional fields)

## Retrieval Pattern

### Credential Chain Delegation

Applications never store or pass explicit cloud credentials. Instead, rely on the cloud provider's default credential chain:

- **Local development**: developer's CLI profile provides credentials automatically
- **Production**: the compute platform (ECS task, Lambda function, etc.) is assigned an IAM role that the SDK picks up from the instance metadata service

This means no AWS access keys in code, environment variables, or config files.

### Secret Name References

Application code should never hardcode secret paths (e.g. `myapp/dev/db-credentials`). Instead, infrastructure injects the secret name as an environment variable, and the application reads it at runtime:

- Infrastructure (Terraform, task definitions) sets env vars like `DB_SECRET_NAME`, `API_KEYS_SECRET_NAME`, `SNOWFLAKE_SECRET_NAME`
- Application code reads the env var to get the secret path, then fetches the secret by that path

This decouples the application from the naming convention and environment. The same code runs in dev and prod without changes: only the injected env var values differ.

Naming convention for reference env vars: `{PURPOSE}_SECRET_NAME` in uppercase (e.g. `DB_SECRET_NAME`, `SLACK_BOT_TOKEN_SECRET_NAME`). Use `_SECRET_NAME` as the suffix because the value is typically a human-readable name constructed from the naming convention, not a full ARN. The Secrets Manager API accepts either a name or an ARN as the secret identifier, so passing an ARN will also work without code changes.

IaC wiring example (Terraform/HCL):

```hcl
environment {
  variables = {
    SNOWFLAKE_SECRET_NAME = "project-name/${var.environment}/snowflake-credentials"
    API_KEYS_SECRET_NAME  = "project-name/${var.environment}/api-keys"
  }
}
```

The IaC definition references the secret name, never the secret value. Credential values stay in Secrets Manager and never appear in state files or deployment config.

### Runtime Loading

At application startup:

1. Load local overrides from a `.env` file if present (development convenience only)
2. Read the secret name reference env vars to discover which secrets to fetch
3. Fetch each secret from Secrets Manager by name
4. Inject the key-value pairs into the process environment (or an equivalent config structure)
5. Secrets Manager values take precedence over `.env` values

Secrets should be fetched once at startup and cached for the process lifetime. Use in-memory caching to avoid repeated API calls within a single execution context.

### Local Development

Developers with AWS CLI access can run applications locally without a `.env` file. The default credential chain picks up the local profile, and the application fetches secrets from the dev environment in Secrets Manager directly.

A `.env` file (or `.env.example` template) is useful as:
- A fallback when AWS access is unavailable
- Documentation of expected environment variables
- Override mechanism for local testing with different values

Always `.gitignore` the `.env` file. Commit a `.env.example` with empty values and comments.

## IAM Scoping

### Task Roles (production compute)

Each service's IAM task role should scope `secretsmanager:GetSecretValue` to its own environment:

```
arn:aws:secretsmanager:{region}:{account}:secret:{project}/{env}/*
```

This prevents a dev container from reading prod secrets and vice versa. Grant only `GetSecretValue`, never write or rotate permissions from application roles.

### Shared or Cross-Environment Roles

Some compute types (e.g. Lambda functions that operate across environments) may need a broader scope:

```
arn:aws:secretsmanager:{region}:{account}:secret:{project}/*
```

Use this sparingly. Prefer per-environment scoping wherever the compute is environment-specific.

### Edge Functions

Functions that run outside the standard compute environment (CDN edge functions, auth lambdas) should have narrowly scoped access to only the specific secrets they need:

```
arn:aws:secretsmanager:{region}:{account}:secret:{project}/{specific-secret}-*
```

The trailing `-*` accommodates the random suffix AWS appends to secret ARNs.

## Secret Lifecycle

- **Creation**: secrets are created manually or via infrastructure-as-code. Terraform can reference pre-existing secrets as data sources or create new ones as resources.
- **Initial values**: set manually in the AWS console or seeded from another environment via IaC.
- **Rotation**: handled out-of-band. Application code should tolerate credential rotation by not caching secrets indefinitely in long-running processes (re-fetch on auth failure).
- **Deletion**: remove the Terraform reference and the secret itself. Update the application code to remove the corresponding accessor.

## Why This Approach

- **Rotation without deploy**: changing a credential in Secrets Manager takes effect on the next cold start. No infrastructure apply, no redeploy.
- **Same code, different secrets**: dev and prod run identical application code. The environment path in the injected env var is the only difference.
- **Secrets never transit IaC state**: infrastructure references the secret name, not the value. Credential values stay in Secrets Manager and never appear in state files or environment variable definitions visible to the deployment tooling.
- **No module outside bootstrap knows**: the rest of the application reads credentials from the process environment. Only the startup/bootstrap layer is aware that a secret store exists.
