#!/usr/bin/env bash
# Bootstrap TFC workspace "dev" in org Auralis for envs/network-dev.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_DIR="${ROOT}/envs/network-dev"
MODULES_DIR="${ROOT}/modules/network"
TFC_API="${TFC_API:-https://app.terraform.io/api/v2}"
WS_ID="${TFC_WORKSPACE_ID:-ws-hRYiCkCytLuneW8K}"
AWS_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
NAME_PREFIX="${TF_VAR_name_prefix:-cortex-dev}"
QUEUE_PLAN=false

for arg in "$@"; do
  [[ "$arg" == "--plan" ]] && QUEUE_PLAN=true
done

[[ -n "${TFC_TOKEN:-}" ]] || { echo "TFC_TOKEN required" >&2; exit 1; }
[[ -n "${AWS_ACCESS_KEY_ID:-}" ]] || { echo "AWS_ACCESS_KEY_ID required" >&2; exit 1; }
[[ -n "${AWS_SECRET_ACCESS_KEY:-}" ]] || { echo "AWS_SECRET_ACCESS_KEY required" >&2; exit 1; }

auth=(-H "Authorization: Bearer ${TFC_TOKEN}" -H "Content-Type: application/vnd.api+json")

upsert_var() {
  local key="$1" value="$2" category="$3" sensitive="${4:-false}"
  local existing
  existing=$(curl -fsS "${auth[@]}" "${TFC_API}/workspaces/${WS_ID}/vars" \
    | KEY="$key" python3 -c "import sys,json,os; d=json.load(sys.stdin); k=os.environ['KEY']; print(next((v['id'] for v in d.get('data',[]) if v['attributes'].get('key')==k), ''))")
  if [[ -n "${existing}" ]]; then
    local payload
    payload=$(KEY="$key" VALUE="$value" CATEGORY="$category" SENSITIVE="$sensitive" python3 <<'PY'
import json, os
print(json.dumps({
  "data": {
    "type": "vars",
    "attributes": {
      "key": os.environ["KEY"],
      "value": os.environ["VALUE"],
      "category": os.environ["CATEGORY"],
      "hcl": False,
      "sensitive": os.environ["SENSITIVE"].lower() == "true",
    },
  }
}))
PY
)
    curl -fsS "${auth[@]}" -X PATCH -d "${payload}" "${TFC_API}/vars/${existing}" >/dev/null
    echo "updated var ${key}"
  else
    local payload
    payload=$(KEY="$key" VALUE="$value" CATEGORY="$category" SENSITIVE="$sensitive" WS_ID="$WS_ID" python3 <<'PY'
import json, os
print(json.dumps({
  "data": {
    "type": "vars",
    "attributes": {
      "key": os.environ["KEY"],
      "value": os.environ["VALUE"],
      "category": os.environ["CATEGORY"],
      "hcl": False,
      "sensitive": os.environ["SENSITIVE"].lower() == "true",
    },
    "relationships": {
      "workspace": {"data": {"type": "workspaces", "id": os.environ["WS_ID"]}}
    },
  }
}))
PY
)
    curl -fsS "${auth[@]}" -X POST -d "${payload}" "${TFC_API}/vars" >/dev/null
    echo "created var ${key}"
  fi
}

echo "=== Setting TFC workspace variables on ${WS_ID} ==="
upsert_var "AWS_ACCESS_KEY_ID" "${AWS_ACCESS_KEY_ID}" "env" false
upsert_var "AWS_SECRET_ACCESS_KEY" "${AWS_SECRET_ACCESS_KEY}" "env" true
upsert_var "AWS_DEFAULT_REGION" "${AWS_REGION}" "env" false
upsert_var "name_prefix" "${NAME_PREFIX}" "terraform" false
upsert_var "region" "${AWS_REGION}" "terraform" false
upsert_var "environment" "${TF_VAR_environment:-dev}" "terraform" false

echo "=== Uploading configuration (network-dev + modules/network) ==="
STAGE="$(mktemp -d)"
mkdir -p "${STAGE}/modules/network"
cp "${ENV_DIR}"/*.tf "${STAGE}/"
cp -R "${MODULES_DIR}/." "${STAGE}/modules/network/"
sed -i.bak 's|../../modules/network|./modules/network|g' "${STAGE}/main.tf"
rm -f "${STAGE}/main.tf.bak"

TMP_TAR="$(mktemp -t tfc-config).tar.gz"
tar -czf "${TMP_TAR}" -C "${STAGE}" .
rm -rf "${STAGE}"

CV_JSON=$(curl -fsS "${auth[@]}" -X POST -d '{"data":{"type":"configuration-versions","attributes":{"auto-queue-runs":false}}}' \
  "${TFC_API}/workspaces/${WS_ID}/configuration-versions")
CV_ID=$(echo "${CV_JSON}" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
UPLOAD_URL=$(echo "${CV_JSON}" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['attributes']['upload-url'])")

curl -fsS --request PUT --header "Content-Type: application/octet-stream" --data-binary @"${TMP_TAR}" "${UPLOAD_URL}" >/dev/null
rm -f "${TMP_TAR}"
echo "configuration-version ${CV_ID} uploaded"

if [[ "${QUEUE_PLAN}" == "true" ]]; then
  echo "=== Queueing plan run ==="
  RUN_JSON=$(curl -fsS "${auth[@]}" -X POST -d "$(python3 -c "import json; print(json.dumps({'data':{'type':'runs','attributes':{'message':'Cortex AWS network bootstrap','auto-apply':False},'relationships':{'workspace':{'data':{'type':'workspaces','id':'${WS_ID}'}},'configuration-version':{'data':{'type':'configuration-versions','id':'${CV_ID}'}}}}))")" \
    "${TFC_API}/runs")
  RUN_ID=$(echo "${RUN_JSON}" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
  echo "run ${RUN_ID} queued"
fi

echo "=== TFC bootstrap complete ==="
