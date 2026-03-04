# 401-goormgb-security
구름공방 보안팀

## 📌 개요 (Overview)
구름공방 보안팀 전용 공간으로 전반적인 보안 아키텍처 설계, 보안 정책 관리, 취약점 점검 및 자동화 스크립트 등을 관리합니다.

대규모 트래픽 환경에서 발생할 수 있는 보안 위협(매크로, DDoS, 비정상 접근 등)을 탐지하고 차단하며, 인프라 및 애플리케이션 레벨의 안전한 서비스 환경을 구축하는 것을 목표로 합니다.

## 📂 디렉토리 구조 (Directory Structure)

```text
📦 security-repo
 ┣ 📂 .github/    # GitHub Actions 기반 CI/CD 보안 워크플로우, CodeQL 취약점 스캐닝, PR 정책 관리
 ┣ 📂 docs/       # 보안 아키텍처 설계 문서, 위협 모델링(Threat Modeling) 분석 문서, 회의 및 정리 노트
 ┣ 📂 poc/        # 발견된 취약점의 검증을 위한 PoC(Proof of Concept) 코드 및 재현 스크립트
 ┣ 📂 scripts/    # 보안 점검, 로그 분석, Alert 설정 등 반복 작업 수행을 위한 자동화 스크립트
 ┗ 📂 terraform/  # 클라우드 인프라 보안 테스트 및 안전한 배포를 위한 IaC(Infrastructure as Code) 코드
