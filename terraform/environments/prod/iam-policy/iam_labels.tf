# ---------------------------------------------------------
# [00] 공통 가드레일: MFA 강제
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_00_common_mfa_enforcement" {
  statement {
    sid       = "DenyWithoutMFA"
    effect    = "Deny"
    not_actions = ["iam:EnableMFADevice", "iam:GetUser", "iam:ListMFADevices"]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

# ---------------------------------------------------------
# [01] 인프라 생성 및 관리 (Cloud Architect 용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_01_infra_core_management" {
  statement {
    sid       = "AllowInfraProvisioning"
    effect    = "Allow"
    actions   = [
      "ec2:*", "eks:*", "route53:*", "s3:*", 
      "elasticloadbalancing:*", "cloudfront:*", "rds:*", "elasticache:*"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenySecurityControl"
    effect    = "Deny"
    actions   = ["iam:*", "wafv2:*", "shield:*", "guardduty:*", "inspector2:*"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [02] 보안 통제 및 IAM 관리 (Security 용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_02_sec_iam_waf_management" {
  statement {
    sid       = "AllowSecurityManagement"
    effect    = "Allow"
    actions   = ["iam:*", "wafv2:*", "shield:*", "guardduty:*", "inspector2:*"]
    resources = ["*"]
  }
  statement {
    sid       = "DenyInfraCreation"
    effect    = "Deny"
    actions   = ["ec2:RunInstances", "eks:CreateCluster", "rds:CreateDBInstance"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [03] 배포 파이프라인 관리 (DevOps 용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_03_devops_pipeline_deployment" {
  statement {
    sid       = "AllowPipelineAndDeploy"
    effect    = "Allow"
    actions   = [
      "ecr:*", "codepipeline:*", "codebuild:*", 
      "eks:DescribeCluster", "eks:ListClusters", "eks:AccessKubernetesApi"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenyNetworkInfraChange"
    effect    = "Deny"
    actions   = [
      "ec2:CreateVpc", "ec2:DeleteVpc", 
      "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:CreateInternetGateway"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [04] 개발 앱 베이스라인 (Developer 공통)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_04_dev_app_baseline" {
  statement {
    sid       = "AllowAppMonitoring"
    effect    = "Allow"
    actions   = [
      "logs:GetLogEvents", "cloudwatch:GetMetricData"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "AllowAppAssets"
    effect    = "Allow"
    actions   = [
      "s3:GetObject", "s3:PutObject", "ecr:BatchGetImage"
    ]
    resources = [
      "arn:aws:s3:::${var.project_name}-*-assets/*", 
      "arn:aws:ecr:*:*:repository/${var.project_name}-*"
    ]
  }
  statement {
    sid       = "DenyDirectServerAccess"
    effect    = "Deny"
    actions   = ["ssm:StartSession", "ec2:RunInstances", "eks:CreateCluster"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [05] DB 인프라 관리 (DBA 용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_05_data_db_management" {
  statement {
    sid       = "AllowDBManagement"
    effect    = "Allow"
    actions   = ["rds:*", "elasticache:*", "pi:*"]
    resources = ["*"]
  }
  statement {
    sid       = "DenyDirectDataQuery"
    effect    = "Deny"
    actions   = ["rds-data:ExecuteStatement", "rds-data:BatchExecuteStatement"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [06] DB 상태 조회 (App / AI 서비스 연동용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_06_data_db_readonly" {
  statement {
    sid       = "AllowDBStatusRead"
    effect    = "Allow"
    actions   = [
      "rds:Describe*", "rds:List*", 
      "elasticache:Describe*", "elasticache:List*"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenyDBModification"
    effect    = "Deny"
    actions   = [
      "rds:Create*", "rds:Delete*", "rds:Modify*", "rds:Reboot*", 
      "elasticache:Create*", "elasticache:Delete*", "elasticache:Modify*"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [07] 시크릿 관리 (AppSec 전용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_07_sec_secret_management" {
  statement {
    sid       = "AllowSecretMetaManagement"
    effect    = "Allow"
    actions   = [
      "kms:CreateKey", "kms:PutKeyPolicy", 
      "secretsmanager:CreateSecret", "secretsmanager:UpdateSecret", 
      "secretsmanager:RotateSecret", "secretsmanager:DescribeSecret"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenySecretValueReadForHumans"
    effect    = "Deny"
    actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [08] 시크릿 참조 (AppSec 제외 전원 공통)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_08_sec_secret_readonly" {
  statement {
    sid       = "AllowSecretMetaRead"
    effect    = "Allow"
    actions   = [
      "secretsmanager:ListSecrets", "secretsmanager:DescribeSecret", 
      "kms:ListKeys", "kms:ListAliases"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenySecretModificationAndRead"
    effect    = "Deny"
    actions   = [
      "secretsmanager:CreateSecret", "secretsmanager:UpdateSecret", 
      "secretsmanager:GetSecretValue", "kms:Decrypt", "kms:CreateKey"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [09] AI 모델 학습 (ML Eng 용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_09_ai_model_training" {
  statement {
    sid       = "AllowAITrainingDataAndPush"
    effect    = "Allow"
    actions   = [
      "s3:GetObject", "s3:PutObject", 
      "ecr:PutImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload"
    ]
    resources = [
      "arn:aws:s3:::${var.project_name}-ai-*", 
      "arn:aws:ecr:*:*:repository/${var.project_name}-ai-*"
    ]
  }
  statement {
    sid       = "DenyServingInfraControl"
    effect    = "Deny"
    actions   = ["eks:*", "ecs:*", "ec2:RunInstances"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [10] AI 모델 서빙 (AI Platform Eng 용)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_10_ai_model_serving" {
  statement {
    sid       = "AllowAIServingInfra"
    effect    = "Allow"
    actions   = [
      "ecs:*", "eks:DescribeCluster", "application-autoscaling:*", 
      "ecr:BatchGetImage", "s3:GetObject"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenyTrainingDataPoisoning"
    effect    = "Deny"
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.project_name}-ai-training-dataset/*"]
  }
}

# ---------------------------------------------------------
# [11] 시스템 모니터링 및 감사 (QA / Security Analyst 등)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_11_audit_system_readonly" {
  statement {
    sid       = "AllowGlobalReadOnlyAndAudit"
    effect    = "Allow"
    actions   = [
      "ec2:Describe*", "eks:Describe*", "rds:Describe*", "s3:List*", 
      "cloudwatch:*", "inspector2:*", "guardduty:Get*"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "DenyStateModification"
    effect    = "Deny"
    actions   = [
      "ec2:RunInstances", "ec2:TerminateInstances", "eks:DeleteCluster", 
      "rds:Reboot*", "s3:PutObject", "s3:DeleteObject"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [12] 비즈니스 및 UX 지표 분석 (CPO / Designer 등)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_12_biz_data_analytics" {
  statement {
    sid       = "AllowAnalyticsAndAssets"
    effect    = "Allow"
    actions   = ["athena:*", "quicksight:*", "ce:*", "s3:PutObject", "s3:GetObject"]
    resources = ["*"]
  }
  statement {
    sid       = "DenyCoreEngineeringAccess"
    effect    = "Deny"
    not_actions = [
      "athena:*", "quicksight:*", "ce:*", "s3:*", 
      "iam:EnableMFADevice", "iam:GetUser", "iam:ListMFADevices"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------
# [99] 긴급 복구 전용 (Break-Glass Admin)
# ---------------------------------------------------------
data "aws_iam_policy_document" "label_99_emergency_break_glass_admin" {
  statement {
    sid       = "AllowAllForRecovery"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
  statement {
    sid       = "DenyAuditLogTampering"
    effect    = "Deny"
    actions   = [
      "cloudtrail:StopLogging", "cloudtrail:DeleteTrail", 
      "cloudwatch:DeleteLogGroup", "guardduty:DeleteDetector"
    ]
    resources = ["*"]
  }
}