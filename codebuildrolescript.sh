#!/usr/bin/env bash

ROLE_NAME="CodeBuildKubectlRole"

# Define trust relationship
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
)

# Define inline EKS policy
INLINE_POLICY_FILE="/tmp/iam-role-policy.json"
cat <<EOF > "$INLINE_POLICY_FILE"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "eks:Describe*",
      "Resource": "*"
    }
  ]
}
EOF

# Create role if it doesn't exist
if aws iam get-role --role-name "$ROLE_NAME" &>/dev/null; then
  echo "Role $ROLE_NAME already exists. Skipping creation."
else
  echo "Creating role $ROLE_NAME..."
  aws iam create-role \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document "$TRUST_POLICY" \
    --output text --query 'Role.Arn'
fi

# Put inline EKS describe policy (overwrites if exists)
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name eks-describe \
  --policy-document file://$INLINE_POLICY_FILE

# Attach managed policies (idempotent — no error if already attached)
POLICIES=(
  arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
  arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess
  arn:aws:iam::aws:policy/AWSCodeCommitFullAccess
  arn:aws:iam::aws:policy/AmazonS3FullAccess
  arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
)

for policy_arn in "${POLICIES[@]}"; do
  echo "Attaching policy: $policy_arn"
  aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$policy_arn" || true
done

# === Optional: Map the IAM role to the EKS cluster ===
EKS_CLUSTER_NAME="pumejcluster"
AWS_REGION="ap-south-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"

# Check if mapping exists
if eksctl get iamidentitymapping --cluster "$EKS_CLUSTER_NAME" --region "$AWS_REGION" | grep -q "$ROLE_ARN"; then
  echo "IAM identity mapping already exists for $ROLE_NAME"
else
  echo "Creating IAM identity mapping for $ROLE_NAME"
  eksctl create iamidentitymapping \
    --cluster "$EKS_CLUSTER_NAME" \
    --region "$AWS_REGION" \
    --arn "$ROLE_ARN" \
    --group system:masters \
    --username "$ROLE_NAME"
fi
