# ==========================================
# 1. 직무별 정책 병합 (Merge Labels)
# ==========================================

data "aws_iam_policy_document" "cloud_architect_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_01_infra.json,
    data.aws_iam_policy_document.label_08_sec_ro.json
  ]
}

data "aws_iam_policy_document" "infra_security_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_02_sec_iam.json,
    data.aws_iam_policy_document.label_08_sec_ro.json
  ]
}

data "aws_iam_policy_document" "devops_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_03_pipeline.json,
    data.aws_iam_policy_document.label_08_sec_ro.json
  ]
}

# ---------------------------------------------------------
# 4. Backend Engineer (황시연)
# 애플리케이션 로그, DB 상태 확인 가능. 수동 서버 접근 및 DB 인프라 변경 불가
# ---------------------------------------------------------
data "aws_iam_policy_document" "backend_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_04_app_base.json,
    data.aws_iam_policy_document.label_06_db_ro.json,
    data.aws_iam_policy_document.label_08_sec_ro.json
  ]
}

# ---------------------------------------------------------
# 4-1. Frontend Engineer (최광혁)
# 애플리케이션 로그, 에셋 조작 가능. DB 상태 확인 권한 제외.
# ---------------------------------------------------------
data "aws_iam_policy_document" "frontend_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_04_app_base.json,
    data.aws_iam_policy_document.label_08_sec_ro.json
  ]
}

data "aws_iam_policy_document" "dba_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_05_db_admin.json,
    data.aws_iam_policy_document.label_08_sec_ro.json
  ]
}

data "aws_iam_policy_document" "appsec_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_07_sec_admin.json
  ]
}

data "aws_iam_policy_document" "ai_researcher_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_04_app_base.json,
    data.aws_iam_policy_document.label_08_sec_ro.json,
    data.aws_iam_policy_document.label_09_ai_train.json
  ]
}

data "aws_iam_policy_document" "mlops_engineer_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_03_pipeline.json,
    data.aws_iam_policy_document.label_06_db_ro.json,
    data.aws_iam_policy_document.label_08_sec_ro.json,
    data.aws_iam_policy_document.label_10_ai_serve.json
  ]
}

data "aws_iam_policy_document" "qa_observability_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_11_audit_ro.json
  ]
}

data "aws_iam_policy_document" "biz_analytics_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_12_biz_data.json
  ]
}

data "aws_iam_policy_document" "emergency_break_glass_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_mfa.json,
    data.aws_iam_policy_document.label_99_break_glass.json
  ]
}

# ==========================================
# 2. 실제 AWS IAM Policy 리소스 생성
# ==========================================

resource "aws_iam_policy" "cloud_architect" {
  name        = "${var.environment}-CloudArchitect-Policy"
  description = "RBAC Policy for Cloud Architect"
  policy      = data.aws_iam_policy_document.cloud_architect_merged_policy.json
}

resource "aws_iam_policy" "infra_security" {
  name        = "${var.environment}-InfraSecurity-Policy"
  description = "RBAC Policy for Infra Security"
  policy      = data.aws_iam_policy_document.infra_security_merged_policy.json
}

resource "aws_iam_policy" "devops" {
  name        = "${var.environment}-DevOps-Policy"
  description = "RBAC Policy for DevOps"
  policy      = data.aws_iam_policy_document.devops_merged_policy.json
}

resource "aws_iam_policy" "backend_developer" {
  name        = "${var.environment}-Backend-Developer-Policy"
  description = "RBAC Policy for Backend Engineers"
  policy      = data.aws_iam_policy_document.backend_merged_policy.json
}

resource "aws_iam_policy" "frontend_developer" {
  name        = "${var.environment}-Frontend-Developer-Policy"
  description = "RBAC Policy for Frontend Engineers"
  policy      = data.aws_iam_policy_document.frontend_merged_policy.json
}

resource "aws_iam_policy" "dba" {
  name        = "${var.environment}-DBA-Policy"
  description = "RBAC Policy for Database Administrator"
  policy      = data.aws_iam_policy_document.dba_merged_policy.json
}

resource "aws_iam_policy" "appsec" {
  name        = "${var.environment}-AppSec-Policy"
  description = "RBAC Policy for Application Security"
  policy      = data.aws_iam_policy_document.appsec_merged_policy.json
}

resource "aws_iam_policy" "ai_researcher" {
  name        = "${var.environment}-AI-Researcher-Policy"
  description = "RBAC Policy for AI Researchers"
  policy      = data.aws_iam_policy_document.ai_researcher_merged_policy.json
}

resource "aws_iam_policy" "mlops_engineer" {
  name        = "${var.environment}-MLOps-Engineer-Policy"
  description = "RBAC Policy for MLOps Engineers"
  policy      = data.aws_iam_policy_document.mlops_engineer_merged_policy.json
}

resource "aws_iam_policy" "qa_observability" {
  name        = "${var.environment}-QA-Observability-Policy"
  description = "RBAC Policy for Service QA, Observability, and Security Analysts"
  policy      = data.aws_iam_policy_document.qa_observability_merged_policy.json
}

resource "aws_iam_policy" "biz_analytics" {
  name        = "${var.environment}-Biz-Analytics-Policy"
  description = "RBAC Policy for Biz, Design, UX"
  policy      = data.aws_iam_policy_document.biz_analytics_merged_policy.json
}

resource "aws_iam_policy" "emergency_admin" {
  name        = "${var.environment}-Emergency-Admin-Policy"
  description = "Break-Glass Admin Policy for CTO"
  policy      = data.aws_iam_policy_document.emergency_break_glass_policy.json
}