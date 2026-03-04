#!/usr/bin/env bash
set -euo pipefail

# Reset local Terraform state for sandbox/lab environments where RBAC or subscription
# changes cause refresh failures against stale state.
#
# What this script does:
# 1) Backs up local state files (if present) with a timestamp suffix.
# 2) Re-initializes Terraform with `-reconfigure`.
# 3) Runs `terraform plan`.
#
# Usage:
#   ./scripts-utils/Azure/reset_terraform_local_state.sh
#   ./scripts-utils/Azure/reset_terraform_local_state.sh /path/to/terraform/dir

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
TF_DIR="${1:-${REPO_ROOT}/terraform}"

if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: terraform command not found in PATH."
  exit 127
fi

if [[ ! -d "${TF_DIR}" ]]; then
  echo "Error: Terraform directory not found: ${TF_DIR}"
  exit 1
fi

if [[ ! -f "${TF_DIR}/providers.tf" ]]; then
  echo "Error: ${TF_DIR} does not look like the expected Terraform root (missing providers.tf)."
  exit 1
fi

timestamp="$(date +%Y%m%d_%H%M%S)"

# Back up local state files if they exist.
# We move them out of the way so `plan` starts from a clean local state.
if [[ -f "${TF_DIR}/terraform.tfstate" ]]; then
  mv "${TF_DIR}/terraform.tfstate" "${TF_DIR}/terraform.tfstate.bak.${timestamp}"
  echo "Backed up terraform.tfstate -> terraform.tfstate.bak.${timestamp}"
fi

if [[ -f "${TF_DIR}/terraform.tfstate.backup" ]]; then
  mv "${TF_DIR}/terraform.tfstate.backup" "${TF_DIR}/terraform.tfstate.backup.bak.${timestamp}"
  echo "Backed up terraform.tfstate.backup -> terraform.tfstate.backup.bak.${timestamp}"
fi

# Reconfigure backend/provider metadata and module state.
terraform -chdir="${TF_DIR}" init -reconfigure

# Run a fresh plan using the current credentials and variables.
terraform -chdir="${TF_DIR}" plan
