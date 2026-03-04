# ==========================================
# 1. 대상 그룹 및 구성원, 연결 Role 매핑 정의
# ==========================================
locals {
  groups = {
    architects       = { name = "Architects", role_arn = aws_iam_role.cloud_architect.arn, users = ["wonyi.lee"] }
    security         = { name = "Security", role_arn = aws_iam_role.infra_security.arn, users = ["wanwoo.jeong"] }
    devops           = { name = "DevOps", role_arn = aws_iam_role.devops.arn, users = ["jaehyeong.jeong"] }
    backend_developers = { name = "Backend-Developers", role_arn = aws_iam_role.backend_developer.arn, users = ["siyeon.hwang"] }
    frontend_developers = { name = "Frontend-Developers", role_arn = aws_iam_role.frontend_developer.arn, users = ["kwanghyeok.choi"] }
    dbas             = { name = "DBAs", role_arn = aws_iam_role.dba.arn, users = ["euijin.yoo"] }
    appsec           = { name = "AppSec", role_arn = aws_iam_role.appsec.arn, users = ["jiseo.ahn"] }
    ai_researchers   = { name = "AI-Researchers", role_arn = aws_iam_role.ai_researcher.arn, users = ["donghoon.choi"] }
    mlops_engineers  = { name = "MLOps-Engineers", role_arn = aws_iam_role.mlops_engineer.arn, users = ["jihyun.jang"] }
    qa_observability = { name = "QA-Observability", role_arn = aws_iam_role.qa_observability.arn, users = ["jihye.jeong", "hyunseok.yoo", "minwook.jeong"] }
    biz_analytics    = { name = "Biz-Analytics", role_arn = aws_iam_role.biz_analytics.arn, users = ["jehyun.kim", "seyoung.park", "jungbin.yoon"] }
    emergency_admins = { name = "Emergency-Admins", role_arn = aws_iam_role.emergency_admin.arn, users = ["cto.admin"] }
  }

  all_users = distinct(flatten([for k, v in local.groups : v.users]))
}

# ==========================================
# 2. IAM 유저 일괄 생성
# ==========================================
resource "aws_iam_user" "users" {
  for_each = toset(local.all_users)
  name     = each.key
}

# ==========================================
# 3. IAM 그룹 일괄 생성
# ==========================================
resource "aws_iam_group" "groups" {
  for_each = local.groups
  name     = "${var.environment}-${each.value.name}"
}

# ==========================================
# 4. 그룹별 AssumeRole 허용 정책 생성 및 부착
# ==========================================
data "aws_iam_policy_document" "assume_role_policies" {
  for_each = local.groups
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [each.value.role_arn]
  }
}

resource "aws_iam_group_policy" "assume_policies_attach" {
  for_each = local.groups
  name     = "AllowAssume${each.value.name}Role"
  group    = aws_iam_group.groups[each.key].name
  policy   = data.aws_iam_policy_document.assume_role_policies[each.key].json
}

# ==========================================
# 5. 멤버십(유저-그룹) 일괄 매핑
# ==========================================
resource "aws_iam_group_membership" "memberships" {
  for_each = local.groups
  name     = "${var.environment}-${each.value.name}-membership"
  users    = each.value.users
  group    = aws_iam_group.groups[each.key].name

  depends_on = [aws_iam_user.users]
}