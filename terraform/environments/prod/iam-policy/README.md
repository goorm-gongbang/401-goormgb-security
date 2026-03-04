# 보안 정책 가이드라인 (IAM Policy Guidelines)

이 디렉토리는 `prod` 환경의 IAM 정책, 역할, 유저 및 그룹을 관리하기 위한 Terraform 설정을 포함합니다.

## 구성 파일 안내

- `main.tf`: AWS Provider 설정 및 공통 태그 정의
- `iam_labels.tf`: 14개 표준 보안 정책 라벨 (재사용 가능한 정책 정의)
- `iam_roles.tf`: 직무별 정책 라벨 병합 로직 (Role 정의)
- `iam_policies.tf`: 실제 AWS IAM Policy 리소스 생성
- `iam_users_and_groups.tf`: IAM 그룹, 유저 생성 및 권한 매핑
