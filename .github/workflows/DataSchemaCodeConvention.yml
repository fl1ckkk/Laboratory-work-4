name: SQL Linter

on:
  push:
    branches: [main, master, laboratory-work-4]
  workflow_dispatch:

jobs:
  SQLLinter:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code in Repository
        uses: "actions/checkout@v3"

      - name: Start SQL Linter
        run: |
          pip install sqlfluff
          sqlfluff lint $GITHUB_WORKSPACE/DataSchema.sql --dialect postgres
