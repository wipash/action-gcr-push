# action-gcr-push
Build, tag, and push container to Google Cloud Registry

## Example

```yml
name: Build and push to GCR
on:
  push:
    branches:
      - master
jobs:
  build_push_gcr:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v1

      - name: Build and push to GCR
        uses: wipash/action-gcr-push@master
        env:
          GCLOUD_AUTH_KEY: ${{secrets.GCLOUD_AUTH_KEY}}
        with:
          image: cmsback
          version_tag: 1.0.2
          environment: production

```