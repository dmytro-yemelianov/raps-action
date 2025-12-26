# 🌼 RAPS GitHub Action

Official GitHub Action for [RAPS](https://rapscli.xyz) — the Rust CLI for Autodesk Platform Services.

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-RAPS-yellow?logo=github)](https://github.com/marketplace/actions/raps-autodesk-platform-services-cli)

## Quick Start

```yaml
- uses: dmytro-yemelianov/raps-action@v1
  with:
    client-id: ${{ secrets.APS_CLIENT_ID }}
    client-secret: ${{ secrets.APS_CLIENT_SECRET }}
    command: 'auth token'
```

## Usage Examples

### Get Authentication Token

```yaml
jobs:
  authenticate:
    runs-on: ubuntu-latest
    steps:
      - name: Get APS Token
        id: auth
        uses: dmytro-yemelianov/raps-action@v1
        with:
          client-id: ${{ secrets.APS_CLIENT_ID }}
          client-secret: ${{ secrets.APS_CLIENT_SECRET }}
          command: 'auth token --quiet'
      
      - name: Use token
        run: echo "Token obtained successfully"
```

### Upload and Translate Model

```yaml
jobs:
  translate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Upload model
        uses: dmytro-yemelianov/raps-action@v1
        with:
          client-id: ${{ secrets.APS_CLIENT_ID }}
          client-secret: ${{ secrets.APS_CLIENT_SECRET }}
          command: 'oss objects upload my-bucket ./model.rvt'
      
      - name: Start translation
        uses: dmytro-yemelianov/raps-action@v1
        with:
          client-id: ${{ secrets.APS_CLIENT_ID }}
          client-secret: ${{ secrets.APS_CLIENT_SECRET }}
          command: 'md translate $URN --output-format svf2 --wait'
```

### List Buckets

```yaml
- name: List OSS buckets
  uses: dmytro-yemelianov/raps-action@v1
  with:
    client-id: ${{ secrets.APS_CLIENT_ID }}
    client-secret: ${{ secrets.APS_CLIENT_SECRET }}
    command: 'oss buckets list --format json'
```

### Run Pipeline

```yaml
- name: Run RAPS pipeline
  uses: dmytro-yemelianov/raps-action@v1
  with:
    client-id: ${{ secrets.APS_CLIENT_ID }}
    client-secret: ${{ secrets.APS_CLIENT_SECRET }}
    command: 'pipeline run ./workflow.yaml'
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `version` | RAPS version to install | No | `latest` |
| `command` | RAPS command to run | **Yes** | — |
| `client-id` | APS Client ID | No* | — |
| `client-secret` | APS Client Secret | No* | — |
| `access-token` | Pre-obtained access token | No* | — |
| `region` | APS region (US/EMEA) | No | `US` |

*Either `client-id`/`client-secret` OR `access-token` is required for authenticated commands.

## Outputs

| Output | Description |
|--------|-------------|
| `result` | Command stdout/stderr output |
| `exit-code` | Command exit code |

### Using Outputs

```yaml
- name: Get buckets
  id: buckets
  uses: dmytro-yemelianov/raps-action@v1
  with:
    client-id: ${{ secrets.APS_CLIENT_ID }}
    client-secret: ${{ secrets.APS_CLIENT_SECRET }}
    command: 'oss buckets list --format json'

- name: Process result
  run: |
    echo "Exit code: ${{ steps.buckets.outputs.exit-code }}"
    echo "Result: ${{ steps.buckets.outputs.result }}"
```

## Supported Platforms

| Runner | Architecture | Status |
|--------|--------------|--------|
| `ubuntu-latest` | x64 | ✅ |
| `ubuntu-latest` | arm64 | ✅ |
| `macos-latest` | x64 | ✅ |
| `macos-latest` | arm64 (M1/M2) | ✅ |

> **Note:** Windows runners are not currently supported. Use the Docker container instead.

## Version Pinning

```yaml
# Latest version
uses: dmytro-yemelianov/raps-action@v1

# Specific version
uses: dmytro-yemelianov/raps-action@v1
with:
  version: '2.0.0'
```

## Complete Workflow Example

```yaml
name: BIM Model Processing

on:
  push:
    paths:
      - 'models/**'

jobs:
  process-models:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Authenticate
        id: auth
        uses: dmytro-yemelianov/raps-action@v1
        with:
          client-id: ${{ secrets.APS_CLIENT_ID }}
          client-secret: ${{ secrets.APS_CLIENT_SECRET }}
          command: 'auth token --quiet'
      
      - name: Create bucket if needed
        uses: dmytro-yemelianov/raps-action@v1
        with:
          access-token: ${{ steps.auth.outputs.result }}
          command: 'oss buckets create ci-models --policy transient'
        continue-on-error: true
      
      - name: Upload models
        uses: dmytro-yemelianov/raps-action@v1
        with:
          access-token: ${{ steps.auth.outputs.result }}
          command: 'oss objects upload ci-models ./models/'
      
      - name: Translate to SVF2
        uses: dmytro-yemelianov/raps-action@v1
        with:
          access-token: ${{ steps.auth.outputs.result }}
          command: 'md translate $URN --output-format svf2 --wait'
```

## Links

- 🌐 **Website**: https://rapscli.xyz
- 📚 **Documentation**: https://rapscli.xyz/docs
- 💻 **GitHub**: https://github.com/dmytro-yemelianov/raps
- 🐳 **Docker**: https://hub.docker.com/r/dmytroyemelianov/raps

## License

Apache 2.0

