# AWS IAM Policy Infrastructure as Code (IaC)

본 저장소는 클라우드 인프라 보안 및 권한 제어를 위한 Terraform 기반의 IaC 구성을 관리합니다.

## 🛡️ 개요: Production 환경 보안 아키텍처
현재 디렉토리(`environments/prod/iam-policy/`)는 `[dev, staging, prod]` 중 **`prod` 환경**을 타겟으로 합니다. 
운영 환경의 보안 요구사항을 충족하기 위해 **가장 엄격한(Strict) 수준의 IAM 접근 제어 정책**을 기준선(Baseline)으로 수립했습니다.

## 🧩 Terraform 모듈 구조 (Module Structure)
이 구조는 모듈화된 권한 블록을 조합하여 직무를 구성하고, 사용자가 Assume Role을 통해 해당 직무 권한을 획득하는 방식으로 설계되었습니다.

1. **`variables.tf` / `main.tf`**: (환경 및 기반 설정)
   - 프로젝트 명, 배포 환경(예: prod), AWS 리전 등의 기본 변수와 Terraform Provider를 정의합니다.
2. **`iam_labels.tf`**: (단위 권한 모듈)
   - 보안 정책의 최소 단위인 **14개의 표준 보안 권한 정의(Data Policy Document)**를 포함합니다.
3. **`iam_policies.tf`**: (직무 정책 조립)
   - `iam_labels.tf`의 단위 권한들을 직무별로 조합하여, 실제 **11개 직무별 병합 정책(IAM Policy)**을 생성합니다.
4. **`iam_roles.tf`**: (직무 역할 생성 및 신뢰 관계 설정)
   - 부여 가능한 11개의 **IAM 직무 역할(Role)**을 생성하고 조립된 정책을 연결합니다. 모든 역할에 **MFA 필수(Trust Relationship)** 조건을 설정합니다.
5. **`iam_users_and_groups.tf`**: (사용자 배정 및 스위칭 권한 부여)
   - 팀원의 IAM 계정 및 그룹을 생성힙니다. 직무 수행 시 지정된 역할(Role)로만 **AssumeRole 스위칭**이 생가능하도록 인라인 권한을 부여힙니다.

## 🏗️ 핵심 보안 원칙 (Core Security Principles)

본 아키텍처는 다음 핵심 원칙을 기반으로 설계되었습니다.

1. **RBAC (역할 기반 접근 제어)**
   - 파편화된 개별 권한 부여를 지양하고, 사전에 정의된 '직무(Role)' 단위로만 권한을 할당 및 통제합니다.
2. **SoD (직무 분리 및 상호 견제)**
   - 인프라 생성, 보안 통제, 배포 등의 권한을 상호 독립된 직무로 분리(예: 인프라 담당자는 보안 통제 권한 없음)하여 내부 위협(Insider Threat)을 억제합니다.
3. **Assume Role (임시 자격 증명 및 MFA 강제)**
   - 작업자의 상시 코어 권한을 배제합니다. 작업 시 MFA 인증을 통한 단기 임시 자격 증명(AssumeRole) 획득 프로세스를 통해 자격 증명 탈취 위험을 최소화합니다.
4. **DRY & Scalability (코드 최적화 및 확장성)**
   - `for_each` 구문 및 로컬 변수를 매핑하여 단일 진실 공급원(Single Source of Truth) 구조를 갖춥니다. 조직 변경 시 변수 업데이트만으로 인프라 전반의 확장이 가능합니다.

> ⚠ **주의**: Terraform State 파일(`terraform.tfstate`) 및 `terraform.tfvars` 등 민감 정보는 절대 외부에 커밋하지 않습니다.

## 🏷️ 직무별 정책 라벨 매핑 표 (Role-to-Label Matrix)

본 설계에 참여하는 팀원(담당자)별 직무와 적용된 보안 라벨(Policy Labels) 매핑 구조입니다. 한 명의 담당자가 어떤 권한을 가지는지 직관적으로 보여주며, 적용된 라벨을 통해 상호 견제(SoD) 원칙을 확인할 수 있습니다.

| dept. | position | name | IAM policy label |
| --- | --- | --- | --- |
| Leadership | CTO | **강슬기** | `00_mfa`, `99_break_glass` |
| Leadership | CPO | **김제현** | `00_mfa`, `12_biz_data` |
| PM | Service QA Eng. | **유현석** | `00_mfa`, `11_audit_ro` |
| Design | Product Designer | **박세영** | `00_mfa`, `12_biz_data` |
| Design | UX Researcher | **윤정빈** | `00_mfa`, `12_biz_data` |
| Dev | DBA | **유의진** | `00_mfa`, `05_db_admin`, `08_sec_ro` |
| Dev | Backend Eng. | **황시연** | `00_mfa`, `04_app_base`, `06_db_ro`, `08_sec_ro` |
| Dev | Frontend Eng. | **최광혁** | `00_mfa`, `04_app_base`, `08_sec_ro` |
| AI | AI Researcher | **최동훈** | `00_mfa`, `04_app_base`, `08_sec_ro`, `09_ai_train` |
| AI | MLOps Eng. | **장지현** | `00_mfa`, `03_pipeline`, `06_db_ro`, `08_sec_ro`, `10_ai_serve` |
| Cloud | Cloud Architect | **이원이** | `00_mfa`, `01_infra`, `08_sec_ro` |
| Cloud | DevOps Eng. | **정재형** | `00_mfa`, `03_pipeline`, `08_sec_ro` |
| Cloud | Observability Eng. | **정지혜** | `00_mfa`, `11_audit_ro` |
| Security | Security Analyst | **정민욱** | `00_mfa`, `11_audit_ro` |
| Security | Infra Security Eng. | **정완우** | `00_mfa`, `02_sec_iam`, `08_sec_ro` |
| Security | AppSec Specialist | **안지서** | `00_mfa`, `07_sec_admin` |

> **💡 매핑 표 해석 팁:**
> - `00_mfa` 라벨은 **모든 직무에 필수(✅)**로 적용됩니다.
> - 보안 담당(`AppSec`)은 시크릿 관리 권한(`07_sec_admin`)을 독점하지만 시크릿 열람 권한(`08_sec_ro`)은 가지지 않으며, 반대로 나머지 엔지니어들은 인프라 조작을 위해 시크릿 열람 권한(`08_sec_ro`)을 공유합니다. 이를 통해 **인증 정보의 관리와 사용을 물리적으로 분리(SoD)**합니다.
> - `11_audit_ro` (시스템 감사) 읽기 권한은 QA 팀과 AppSec 에만 할당되어 개발/인프라 인원이 본인의 로그를 임의로 조작하거나 통제 권한 밖의 상태를 모니터링하는 것을 방지합니다.
