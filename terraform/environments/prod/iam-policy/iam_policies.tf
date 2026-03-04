# ==========================================
# 1. 직무별 정책 병합 (Merge Labels)
# ==========================================

data "aws_iam_policy_document" "cloud_architect_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_01_infra_core_management.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json
  ]
}

data "aws_iam_policy_document" "infra_security_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_02_sec_iam_waf_management.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json
  ]
}

data "aws_iam_policy_document" "devops_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_03_devops_pipeline_deployment.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json
  ]
}

data "aws_iam_policy_document" "developer_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_04_dev_app_baseline.json,
    data.aws_iam_policy_document.label_06_data_db_readonly.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json
  ]
}

data "aws_iam_policy_document" "dba_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_05_data_db_management.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json
  ]
}

data "aws_iam_policy_document" "appsec_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_07_sec_secret_management.json,
    data.aws_iam_policy_document.label_11_audit_system_readonly.json
  ]
}

data "aws_iam_policy_document" "ml_engineer_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_04_dev_app_baseline.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json,
    data.aws_iam_policy_document.label_09_ai_model_training.json
  ]
}

data "aws_iam_policy_document" "ai_platform_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_04_dev_app_baseline.json,
    data.aws_iam_policy_document.label_06_data_db_readonly.json,
    data.aws_iam_policy_document.label_08_sec_secret_readonly.json,
    data.aws_iam_policy_document.label_10_ai_model_serving.json
  ]
}

data "aws_iam_policy_document" "qa_observability_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_11_audit_system_readonly.json
  ]
}

data "aws_iam_policy_document" "biz_analytics_merged_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_12_biz_data_analytics.json
  ]
}

data "aws_iam_policy_document" "emergency_break_glass_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.label_00_common_mfa_enforcement.json,
    data.aws_iam_policy_document.label_99_emergency_break_glass_admin.json
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

resource "aws_iam_policy" "developer" {
  name        = "${var.environment}-Developer-Policy"
  description = "RBAC Policy for Backend and FE Engineers"
  policy      = data.aws_iam_policy_document.developer_merged_policy.json
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

resource "aws_iam_policy" "ml_engineer" {
  name        = "${var.environment}-MLEngineer-Policy"
  description = "RBAC Policy for ML Engineers"
  policy      = data.aws_iam_policy_document.ml_engineer_merged_policy.json
}

resource "aws_iam_policy" "ai_platform" {
  name        = "${var.environment}-AIPlatform-Policy"
  description = "RBAC Policy for AI Platform Engineers"
  policy      = data.aws_iam_policy_document.ai_platform_merged_policy.json
}

resource "aws_iam_policy" "qa_observability" {
  name        = "${var.environment}-QA-Observability-Policy"
  description = "RBAC Policy for QA and Observability"
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