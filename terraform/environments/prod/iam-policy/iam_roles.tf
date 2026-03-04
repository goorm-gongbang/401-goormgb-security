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
# ---------------------------------------------------------
# [01] Cloud Architect 
# - 허용 (Allow) : 인프라 무한 생성 및 프로비저닝 (EC2, EKS, RDS 등)
# - 차단 (Deny)  : 방화벽 해제, IAM 권한 임의 부여 등 스스로 보안을 무력화하는 행위
# ---------------------------------------------------------
resource "aws_iam_role" "cloud_architect" {
  name               = "${var.environment}-CloudArchitect-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "cloud_architect_attach" {
  role       = aws_iam_role.cloud_architect.name
  policy_arn = aws_iam_policy.cloud_architect.arn
}

# ---------------------------------------------------------
# [02] Infra Security
# - 허용 (Allow) : 전사 IAM 권한 통제 및 보안 정책(WAF, GuardDuty 등) 전면 관리
# - 차단 (Deny)  : 임의의 서버 자원(EC2, EKS Node)을 띄워 백도어로 악용하는 행위
# ---------------------------------------------------------
resource "aws_iam_role" "infra_security" {
  name               = "${var.environment}-InfraSecurity-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "infra_security_attach" {
  role       = aws_iam_role.infra_security.name
  policy_arn = aws_iam_policy.infra_security.arn
}

# ---------------------------------------------------------
# [03] DevOps
# - 허용 (Allow) : CI/CD 파이프라인 컴포넌트(ECR, CodeBuild) 관리 및 자동 배포 운영
# - 차단 (Deny)  : 파이프라인 범위를 넘어서는 네트워크(VPC 등) 구조 변경 및 비즈니스 로직 임의 수정
# ---------------------------------------------------------
resource "aws_iam_role" "devops" {
  name               = "${var.environment}-DevOps-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "devops_attach" {
  role       = aws_iam_role.devops.name
  policy_arn = aws_iam_policy.devops.arn
}

# ---------------------------------------------------------
# [04] Developer (Backend)
# - 허용 (Allow) : 애플리케이션 CloudWatch 로그/메트릭 모니터링, DB 상태 확인 및 운영 에셋 조작
# - 차단 (Deny)  : 프로덕션 서버 수동 접속, 인프라 변경 및 DB 데이터 쿼리
# ---------------------------------------------------------
resource "aws_iam_role" "backend_developer" {
  name               = "${var.environment}-Backend-Developer-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "backend_developer_attach" {
  role       = aws_iam_role.backend_developer.name
  policy_arn = aws_iam_policy.backend_developer.arn
}

# ---------------------------------------------------------
# [04-1] Developer (Frontend)
# - 허용 (Allow) : 애플리케이션 CloudWatch 로그/메트릭 모니터링 및 운영 에셋 조작
# - 차단 (Deny)  : 프로덕션 서버 수동 접속, 인프라 변경 및 DB 접근 일절 차단
# ---------------------------------------------------------
resource "aws_iam_role" "frontend_developer" {
  name               = "${var.environment}-Frontend-Developer-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "frontend_developer_attach" {
  role       = aws_iam_role.frontend_developer.name
  policy_arn = aws_iam_policy.frontend_developer.arn
}

# ---------------------------------------------------------
# [05] DBA
# - 허용 (Allow) : 사내 DB 인스턴스(RDS, ElastiCache)의 스토리지 및 메모리 스펙 조작 및 백업 관장
# - 차단 (Deny)  : 백도어로 어드민 접속하여 유저 데이터 유출, 혹은 결제/인증 정보 직접 쿼리 실행
# ---------------------------------------------------------
resource "aws_iam_role" "dba" {
  name               = "${var.environment}-DBA-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "dba_attach" {
  role       = aws_iam_role.dba.name
  policy_arn = aws_iam_policy.dba.arn
}

# ---------------------------------------------------------
# [06] AppSec
# - 허용 (Allow) : 전사 Secrets Manager 및 KMS 정책 등록, 변경, 로테이션 파이프라인 구축
# - 차단 (Deny)  : 휴먼 계정을 통한 AWS 콘솔 내 평문(Plaintext) 시크릿 암호 직접 열람 행위
# ---------------------------------------------------------
resource "aws_iam_role" "appsec" {
  name               = "${var.environment}-AppSec-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "appsec_attach" {
  role       = aws_iam_role.appsec.name
  policy_arn = aws_iam_policy.appsec.arn
}

# ---------------------------------------------------------
# [07] AI Researcher
# - 허용 (Allow) : S3 버킷의 정제된 학습 데이터를 읽어와서 AI 모델을 추출하고 ECR 스토어에 업로드
# - 차단 (Deny)  : 실제 Prod 환경의 런타임 서빙 인프라(EKS/ECS 클러스터)의 스펙이나 상태 직접 조작
# ---------------------------------------------------------
resource "aws_iam_role" "ai_researcher" {
  name               = "${var.environment}-AI-Researcher-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "ai_researcher_attach" {
  role       = aws_iam_role.ai_researcher.name
  policy_arn = aws_iam_policy.ai_researcher.arn
}

# ---------------------------------------------------------
# [08] MLOps Engineer
# - 허용 (Allow) : 준비된 AI 모델이 안정적으로 동작할 수 있도록 파이프라인과 서빙 클러스터 프로비저닝
# - 차단 (Deny)  : 리서치 그룹이 담당하는 원본 정제 데이터베이스를 임의 조작하거나 열람
# ---------------------------------------------------------
resource "aws_iam_role" "mlops_engineer" {
  name               = "${var.environment}-MLOps-Engineer-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "mlops_engineer_attach" {
  role       = aws_iam_role.mlops_engineer.name
  policy_arn = aws_iam_policy.mlops_engineer.arn
}

# ---------------------------------------------------------
# [09] QA / Observability
# - 허용 (Allow) : 전사 시스템을 읽기(Read) 전용으로 모니터링하고 성능 부하나 취약점 지표를 검증/탐색
# - 차단 (Deny)  : 오류의 원인을 발견해도 본인이 직접 파드를 죽이거나 리소스 상태를 롤백(Write)하는 일 
# ---------------------------------------------------------
resource "aws_iam_role" "qa_observability" {
  name               = "${var.environment}-QA-Observability-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "qa_observability_attach" {
  role       = aws_iam_role.qa_observability.name
  policy_arn = aws_iam_policy.qa_observability.arn
}

# ---------------------------------------------------------
# [10] Biz / Analytics
# - 허용 (Allow) : 제품 결제나 주요 비즈니스 이벤트 지표 파악용 시스템 모니터링 열람 및 정적 에셋 통제
# - 차단 (Deny)  : 데이터 분석이나 트래픽 통제를 핑계로 코어 클라우드 엔지니어링 망(EC2 인프라 등) 진입
# ---------------------------------------------------------
resource "aws_iam_role" "biz_analytics" {
  name               = "${var.environment}-Biz-Analytics-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "biz_analytics_attach" {
  role       = aws_iam_role.biz_analytics.name
  policy_arn = aws_iam_policy.biz_analytics.arn
}

# ---------------------------------------------------------
# [99] Emergency Admin (Break-Glass)
# - 허용 (Allow) : 치명적 인프라 대장애 시 전 계층의 제약을 우회하여 인프라를 한시적으로 강제 응급 복구
# - 차단 (Deny)  : 비상사태 권한 행사를 핑계로 사후 감사 증적 자료(CloudTrail, GuardDuty 등) 무단 은폐 및 삭제
# ---------------------------------------------------------
resource "aws_iam_role" "emergency_admin" {
  name               = "${var.environment}-Emergency-Admin-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust.json
}
resource "aws_iam_role_policy_attachment" "emergency_admin_attach" {
  role       = aws_iam_role.emergency_admin.name
  policy_arn = aws_iam_policy.emergency_admin.arn
}
