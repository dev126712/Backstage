# Backstage IDP

Self-hosted [Backstage](https://backstage.io) Internal Developer Portal with a custom software catalog, API registry, software templates, and TechDocs integration.

[![TypeScript](https://skillicons.dev/icons?i=ts,kubernetes,docker)](https://skillicons.dev)

---

## What's Inside

### Software Catalog
The catalog models the full service graph — components, APIs, systems, resources, and ownership — using Backstage's YAML entity format.

- Components registered with lifecycle, owner, and dependency links (`dependsOn`, `dependencyOf`, `providesApis`)
- Systems and groups mapped to mirror real team topology
- `catalog-info.yaml` files stored in each service repo for self-registration

### API Registry
OpenAPI definitions surfaced directly in the Backstage UI, linked to their owning components. Developers can browse and explore API contracts without leaving the portal.

### Software Templates
A custom scaffolder template that provisions a new **Serverless 3-Tier App on GCP**:

| Step | What it does |
|---|---|
| Form inputs | Component name, GitHub repo URL, GCP project ID, VPC, subnet, Cloud Run region |
| Skeleton | Generates a ready-to-deploy project structure from a templated skeleton |
| Registration | Automatically registers the new component in the Backstage catalog |

The template targets Cloud Run v2 (frontend + backend) and Cloud SQL (database) — fully parameterised, no manual edits needed after scaffolding.

### TechDocs
Documentation-as-code: Markdown docs stored alongside service code, rendered in the Backstage portal via MkDocs.

---

## Running Locally

```bash
yarn install
yarn start
```

Open http://localhost:3000.

To build and serve TechDocs:

```bash
yarn build:docs
```

---

## Configuration

`app-config.yaml` — development config (localhost, GitHub auth).
`app-config.production.yaml` — production overrides (deployed on Kubernetes).

Key settings:

```yaml
app:
  title: My Company Backstage
  baseUrl: http://localhost:3000

auth:
  providers:
    github: ...   # GitHub OAuth for single sign-on

catalog:
  locations:
    - type: file
      target: ../../apis/api.yml
    - type: file
      target: ../../template/catalog-info.yaml
    - type: file
      target: ../../groups/**/*.yaml
    - type: file
      target: ../../users/**/*.yaml
```

---

## Project Structure

```
Backstage/
├── app-config.yaml                      # Dev configuration
├── app-config.production.yaml           # Production overrides
├── Dockerfile                           # Multi-stage production build
├── packages/                            # Backstage app + backend packages
├── plugins/                             # Custom plugins
├── apis/
│   └── api.yml                          # OpenAPI entity definitions
├── template/
│   ├── catalog-info.yaml                # Backstage component for the template itself
│   └── serverless-3-tier-gcp/
│       ├── template.yml                 # Scaffolder template definition
│       └── skeleton/                    # Project skeleton (Terraform + service stubs)
├── groups/                              # Team/group entity files
├── users/                               # User entity files
└── system/                              # System entity files
```

---

## Skills Demonstrated

- **Platform Engineering** — Internal Developer Portal design and configuration
- **Software catalog design** — entity model, dependency mapping, ownership
- **Scaffolder templates** — parameterised project bootstrapping (GCP Cloud Run + Cloud SQL)
- **TechDocs** — docs-as-code integrated into the catalog
- **TypeScript** — custom plugin and configuration work
- **Kubernetes** — production deployment via Dockerfile + k8s manifests
