# 직무별 정책 라벨 병합 로직
locals {
  job_roles = {
    "developer" = [
      local.iam_labels["read_only"]
    ]
  }
}

# ==========================================
# [AssumeRole] 신뢰 관계 및 IAM Role 생성
# ==========================================

# 1. 모든 Role이 공통으로 사용할 AssumeRole Trust Policy (신뢰 관계)
data "aws_iam_policy_document" "assume_role_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

# 2. 직무별 IAM Role 생성 및 Policy 매핑
resource "aws_iam_role" "cloud_architect" {
  name               = "${var.environment}-CloudArchitect-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "cloud_architect_attach" {
  role       = aws_iam_role.cloud_architect.name
  policy_arn = aws_iam_policy.cloud_architect.arn
}

resource "aws_iam_role" "infra_security" {
  name               = "${var.environment}-InfraSecurity-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "infra_security_attach" {
  role       = aws_iam_role.infra_security.name
  policy_arn = aws_iam_policy.infra_security.arn
}

resource "aws_iam_role" "devops" {
  name               = "${var.environment}-DevOps-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "devops_attach" {
  role       = aws_iam_role.devops.name
  policy_arn = aws_iam_policy.devops.arn
}

resource "aws_iam_role" "developer" {
  name               = "${var.environment}-Developer-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "developer_attach" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.developer.arn
}

resource "aws_iam_role" "dba" {
  name               = "${var.environment}-DBA-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "dba_attach" {
  role       = aws_iam_role.dba.name
  policy_arn = aws_iam_policy.dba.arn
}

resource "aws_iam_role" "appsec" {
  name               = "${var.environment}-AppSec-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "appsec_attach" {
  role       = aws_iam_role.appsec.name
  policy_arn = aws_iam_policy.appsec.arn
}

resource "aws_iam_role" "ml_engineer" {
  name               = "${var.environment}-MLEngineer-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "ml_engineer_attach" {
  role       = aws_iam_role.ml_engineer.name
  policy_arn = aws_iam_policy.ml_engineer.arn
}

resource "aws_iam_role" "ai_platform" {
  name               = "${var.environment}-AIPlatform-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "ai_platform_attach" {
  role       = aws_iam_role.ai_platform.name
  policy_arn = aws_iam_policy.ai_platform.arn
}

resource "aws_iam_role" "qa_observability" {
  name               = "${var.environment}-QA-Observability-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "qa_observability_attach" {
  role       = aws_iam_role.qa_observability.name
  policy_arn = aws_iam_policy.qa_observability.arn
}

resource "aws_iam_role" "biz_analytics" {
  name               = "${var.environment}-Biz-Analytics-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "biz_analytics_attach" {
  role       = aws_iam_role.biz_analytics.name
  policy_arn = aws_iam_policy.biz_analytics.arn
}

resource "aws_iam_role" "emergency_admin" {
  name               = "${var.environment}-Emergency-Admin-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "emergency_admin_attach" {
  role       = aws_iam_role.emergency_admin.name
  policy_arn = aws_iam_policy.emergency_admin.arn
}
