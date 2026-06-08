# 돌봄지원 심사소 Steam 상점 페이지 제출안

작성일: 2026-05-27
대상 버전: v0.3.0
가격 기준: USD 9.99

## 1. 공식 검토 기준 요약

이 제출안은 Steamworks 공식 문서의 현재 기준을 반영한다.

- 그래픽 자산: 2024년 8월 이후 큰 캡슐 규격을 사용한다. 현재 로컬 자산은 header `920x430`, small `462x174`, main `1232x706`, vertical `748x896` 규격에 맞춰져 있다.
- 트레일러: Steam은 최대 `1920x1080`, `30/29.97fps` 또는 `60/59.94fps`, `5,000Kbps+`, `.mp4/.mov/.wmv` 컨테이너를 권장한다. H.264 video와 AAC audio가 선호된다.
- 리뷰: 상점 페이지와 빌드는 Valve 리뷰가 필요하다. 문서상 통상 3-5 영업일이지만, 수정 가능성을 고려해 최소 7영업일 전에 제출해야 한다.
- Coming Soon: 신작은 출시 전 최소 2주 동안 Coming Soon 페이지가 열려 있어야 한다.
- 상점 페이지 문구: 출시 시점에 실제 포함되는 기능만 적는다. 미구현 영어판, Steamworks 실제 업적 연동, Steam Cloud, 데모, 추가 엔딩은 현재 상점 문구에 넣지 않는다.

참고 공식 문서:

- Steamworks Graphical Assets: `https://partner.steamgames.com/doc/store/assets`
- Steamworks Trailers: `https://partner.steamgames.com/doc/store/trailer`
- Steamworks Review Process: `https://partner.steamgames.com/doc/store/review_process`
- Steamworks Release Options: `https://partner.steamgames.com/doc/store/types`

## 2. 기본 정보

### App Name

돌봄지원 심사소

### English Name

Care Review Office

### Short Description

제한된 예산, 불완전한 서류, 다음 날의 후폭풍. 가족지원센터 심사 담당자가 되어 돌봄지원 신청을 검토하고, 매일 달라지는 지표와 최종 리포트로 자신의 판단 기준을 마주하세요.

### One-Line Pitch

서류, 위험 신호, 예산, 민원 압박 사이에서 돌봄지원 결정을 내리는 사회 의사결정 시뮬레이션.

## 3. Long Description

`돌봄지원 심사소`는 가족지원센터의 심사 담당자가 되어 돌봄지원 신청서를 검토하는 사회 의사결정 시뮬레이션입니다.

각 사례에는 가족 구성, 돌봄 부담, 위험 신호, 서류 완성도, 요청 지원, 현장 메모가 들어 있습니다. 모든 신청을 바로 도울 수는 없습니다. 예산은 제한되어 있고, 행정 기준은 명확해 보이지만 실제 사례는 늘 애매합니다. 메인 메뉴의 사례 자료실에서는 전체 40개 합성 사례의 권장 판단, 압박도, 위험 신호, 서류 보강 사항을 훑고 고위험/서류보강/소득예외/고비용/추가조사 큐로 좁혀 볼 수 있습니다. 판단 전에는 균형, 위험, 형평, 서류, 예산 중 어떤 근거를 우선했는지 표시할 수 있습니다. 판단 직후에는 내 선택이 권장 판단과 비교해 예산, 안정, 위험을 어떻게 다르게 바꾸는지 확인할 수 있고, 심사 중에는 결정 기록 화면을 열어 최근 판단과 권장 판단, 판단 근거, 예산 변화, 위험 증가를 되짚으며 다음 선택을 조정할 수 있습니다. 후속 연락함에서는 가족 연락, 민원, 감사 요청, 안전 확인 메모와 지표 영향을 최근 판단 기준으로 다시 읽을 수 있습니다.

플레이어는 매 사례마다 승인, 조건부 승인, 보류, 추가조사, 거절 중 하나를 선택합니다. 승인 하나가 가족 안정도를 높일 수 있지만 예산을 빠르게 소진할 수 있고, 거절 하나가 기관의 형평성 지표를 지키는 대신 누락 위험과 민원으로 이어질 수 있습니다.

하루가 끝나면 판단의 합계가 다음 날 브리핑과 특별 사건으로 돌아옵니다. 예산 감사, 민원 회의, 긴급 안전점검, 형평성 이의제기 같은 사건은 전날 어떤 기준을 우선했는지 되묻습니다. 새 캠페인에서는 메인 메뉴의 운영 기준 카드에서 시작 예산과 기준 효과를 확인하고, 균형 심사, 지원 확대, 긴축 감사 운영 기준을 선택해 같은 사례를 다른 압박 조건에서 다시 플레이할 수 있습니다. 각 운영 기준에는 권장 판단 일치, 고위험 지연 억제, 예산 방어처럼 서로 다른 캠페인 챌린지가 붙어 있어, 지원 확대와 긴축 감사가 단순 난이도 변경이 아니라 서로 다른 심사 실험으로 작동하도록 돕습니다. 캠페인 시작 브리핑은 선택한 기준의 예산 압박, 판단 전략, 챌린지 목표를 먼저 안내합니다.

캠페인을 마치면 최종 리포트와 엔딩 카드가 표시됩니다. 운영 등급/점수/배지로 이번 회차의 예산 관리, 안정/형평 유지, 위험 방어, 민원 억제, 권장 판단 일치율을 빠르게 확인하고, 캠페인 챌린지 카드로 이번 운영 기준의 목표 달성 여부와 부족했던 지표를 확인합니다. 어떤 사례 그룹에 더 쉽게 지원했는지, 위험 신호를 얼마나 우선했는지, 추가조사를 언제 선택했는지 가족 유형 판단 지도와 재검토 큐로 확인할 수 있습니다. 판단 근거 분포에서는 균형, 위험, 형평, 서류, 예산 중 어떤 기준이 가장 자주 쓰였는지와 근거별 지원/추가조사/지연, 권장 일치율을 보여줍니다. 판단 복기에서는 일차별 지출, 위험 증가, 권장 일치율과 고압력 대표 사례를 다시 점검할 수 있습니다. 이번 회차에서 예산을 과하게 썼는지, 고위험 지연이 많았는지, 권장 판단과 자주 어긋났는지를 바탕으로 다음 캠페인에서 도전할 운영 기준과 목표도 추천되며, `추천 심사` 버튼으로 추천된 기준을 바로 적용해 새 회차를 시작할 수 있습니다. 목표 심사/성과 목표로 시작한 반복 목표는 2/4/6회 누적에 따라 동색 인장, 은색 챌린지 카드, 금색 엔딩 장식으로 이어지고, 성과 기록과 엔딩 기록 장식에도 같은 진행도가 표시됩니다. 메인 메뉴의 성과 기록에서는 캠페인 완료, 위험 방어, 반복 목표를 확인할 수 있고, 캠페인 기록 화면에서는 최근 완료 회차의 등급, 엔딩, 캠페인 챌린지, 권장 일치율, 최종 지표, 다음 목표를 비교할 수 있습니다.

캠페인 기록의 장기 추세 패널은 누적 지원/조사/지연 성향, 평균 점수, 최고 등급, 반복 목표 단계를 한 줄로 압축해 다음 회차의 운영 기준 선택을 돕습니다.

## 4. Features

- 5일 캠페인과 40개 돌봄지원 신청 사례
- 8종 가족 초상과 12종 증빙 카드로 바뀌는 사례 서류 스트립
- 메인 메뉴에서 현재 운영 기준과 시작 예산을 확인하고 D 키/버튼으로 변경
- 새 캠페인 시작 전 선택한 운영 기준의 압박 의도와 판단 전략을 안내하는 브리핑
- 운영 기준마다 권장 일치, 위험 방어, 예산 방어 목표를 제시하는 캠페인 챌린지
- 전체 40개 합성 사례를 쪽 단위와 필터 큐로 검토하는 사례 자료실
- 초상 아래에서 긴급도, 형평성, 서류 강도, 보강 서류를 바로 읽는 사례 압박 요약 패널
- 현재 사례의 권장 판단과 다섯 선택지 예상 변화를 비교하는 심사 기준표
- 최종 리포트에서 회차 성과를 압축해 보여주는 운영 등급/점수/배지
- 최종 리포트에서 목표 달성 여부와 부족한 지표를 보여주는 캠페인 챌린지 카드
- 최종 리포트에서 예산, 안정도, 형평성, 누락 위험, 민원 위험을 보여주는 게이지 대시보드
- 최종 리포트에서 넓은 사례 그룹별 지원율과 권장 일치율을 보여주는 가족 유형 판단 지도
- 일차별 지출/위험 증가/권장 일치율을 비교하는 판단 복기 화면
- 회차 성과를 바탕으로 다음 운영 기준과 구체 목표를 제안하는 다음 캠페인 목표 추천
- 추천된 운영 기준을 바로 적용해 새 회차를 시작하는 추천 심사 버튼
- 캠페인 완료와 반복 목표 달성을 기록하는 로컬 성과 기록 화면
- 최근 완료 회차의 등급, 엔딩, 권장 일치율, 최종 지표를 비교하는 캠페인 기록 화면
- 균형 심사, 지원 확대, 긴축 감사 3종 운영 기준
- 승인, 조건부 승인, 보류, 추가조사, 거절의 5가지 판단
- 판단 직후 예산, 가족 안정도, 형평성, 누락 위험, 민원 변화 표시
- 판단 직후 권장 판단 대비 예산·안정·위험 차이 표시
- 하루가 끝날 때 이어지는 브리핑과 사건별 경고 연출/변형 문구가 붙은 특별 사건 카드
- 최근 판단, 권장 판단, 예산 변화, 위험 증가를 되짚는 심사 중 결정 기록 오버레이
- 가족 연락, 민원, 감사 요청, 안전 확인 메모를 다시 읽는 후속 연락함
- 판단마다 균형/위험/형평/서류/예산 근거를 남기는 판단 근거 선택
- 최종 리포트에 표시되는 판단 근거 분포 분석
- 예산 감사, 민원 회의, 긴급 안전점검, 형평성 이의제기 이벤트
- 최종 지표에 따라 달라지는 4종 엔딩 카드
- 엔딩별 후속 에필로그와 다음 캠페인 과제
- 발견한 엔딩을 전체/운영 기준별로 다시 볼 수 있는 엔딩 기록 화면
- 여러 판단 성향의 지원/조사/일치율을 비교하는 판단 비교 화면
- 3개 세이브 슬롯, 이어하기, 선택 슬롯 삭제, 음량, 해상도, 창/전체화면 설정
- 큰 글자 모드, 고대비 모드, 키보드 조작 지원
- 합성 사례, 실제 개인정보 미사용, 로컬 저장, 생성형 AI 활용 범위를 밝히는 크레딧/고지 화면

## 5. 태그 후보

우선순위대로 입력한다.

1. Simulation
2. Choices Matter
3. Management
4. Political Sim
5. Resource Management
6. Narrative
7. Story Rich
8. Interactive Fiction
9. Visual Novel
10. Strategy
11. Singleplayer
12. Education
13. Text-Based
14. Point & Click
15. 2D
16. Drama
17. Experimental
18. Casual
19. Life Sim
20. Replay Value

## 6. Steam Features

현재 빌드 기준으로만 체크한다.

- Single-player: Yes
- Steam Achievements: No
- Steam Cloud: No
- Controller Support: No
- Steam Trading Cards: No
- Remote Play: No
- Family Sharing: 기본 Steam 정책에 따름
- Demo: No
- Early Access: No

## 7. 지원 언어

현재 출시 후보는 한국어 전용이다.

| Language | Interface | Full Audio | Subtitles |
| --- | --- | --- | --- |
| Korean | Yes | No | Yes |
| English | No | No | No |

영어 상점명 `Care Review Office`는 식별용으로만 둔다. 영어 UI/상점 본문은 번역 QA 전까지 지원 언어로 표시하지 않는다.

## 8. 시스템 요구 사항

### Minimum

- OS: Windows 10 64-bit
- Processor: Intel Core i3-6100 or equivalent
- Memory: 4 GB RAM
- Graphics: Intel UHD Graphics 620 or DirectX 11 compatible GPU
- DirectX: Version 11
- Storage: 500 MB available space
- Additional Notes: Tested target for 1280x720 windowed mode. Settings include low-spec mode, frame-rate cap, and local system diagnostic export for playtest QA.

### Recommended

- OS: Windows 10/11 64-bit
- Processor: Intel Core i5-8400 or equivalent
- Memory: 8 GB RAM
- Graphics: NVIDIA GTX 1050 or equivalent
- DirectX: Version 11
- Storage: 1 GB available space
- Additional Notes: Target for 1920x1080 windowed or fullscreen mode. External low-spec PC validation is still required before public launch.

## 9. Content Survey 초안

- Adult-only sexual content: No
- Nudity or sexual content: No
- Graphic violence or gore: No
- Gambling: No
- In-game purchases: No
- Sensitive themes: 가족 위기, 돌봄 공백, 행정 심사, 민원, 예산 압박을 텍스트와 UI 중심으로 다룬다.

상점 경고 문구 후보:

> 이 게임은 가족 돌봄 공백, 행정 심사, 민원, 예산 압박 같은 사회적 주제를 텍스트 중심으로 다룹니다. 실제 개인정보나 실제 상담 기록은 포함하지 않습니다.

## 10. 그래픽 자산 업로드 맵

| Steamworks 항목 | 로컬 파일 | 규격 | 상태 |
| --- | --- | --- | --- |
| Header Capsule | `Builds/Marketing/v0.3.0/steam_assets/store_header_capsule_920x430.png` | 920x430 | Ready |
| Small Capsule | `Builds/Marketing/v0.3.0/steam_assets/store_small_capsule_462x174.png` | 462x174 | Ready |
| Main Capsule | `Builds/Marketing/v0.3.0/steam_assets/store_main_capsule_1232x706.png` | 1232x706 | Ready |
| Vertical Capsule | `Builds/Marketing/v0.3.0/steam_assets/store_vertical_capsule_748x896.png` | 748x896 | Ready |
| Page Background | `Builds/Marketing/v0.3.0/steam_assets/store_page_background_1438x810.png` | 1438x810 | Optional Ready |
| Library Capsule | `Builds/Marketing/v0.3.0/steam_assets/library_capsule_600x900.png` | 600x900 | Ready |
| Library Hero | `Builds/Marketing/v0.3.0/steam_assets/library_hero_3840x1240.png` | 3840x1240 | Ready |
| Library Header Capsule | `Builds/Marketing/v0.3.0/steam_assets/library_header_capsule_920x430.png` | 920x430 | Ready |
| Library Logo | `Builds/Marketing/v0.3.0/steam_assets/library_logo_1280x720.png` | 1280x720 | Ready |

자동 감사: `Builds/QA/v0.3.0/marketing_assets/care_review_marketing_asset_audit.md` 기준 상점 스크린샷 8장, QA 비교 스크린샷 5장, Steam 캡슐 9장, 트레일러 프레임 13장, 업로드 후보 트레일러, 그래픽/트레일러 자산 zip, 로컬 절대경로 미포함 통과.
Steamworks 제출 패키지 사본: `Builds/Steamworks/v0.3.0/store_page/SCREENSHOT_CANDIDATES_KO.md`, `Builds/Steamworks/v0.3.0/store_page/SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`, `Builds/Steamworks/v0.3.0/store_page/SCREENSHOT_CANDIDATE_AB_TEST_KO.md`, `Builds/Steamworks/v0.3.0/store_page/SCREENSHOT_UPLOAD_SELECTION_KO.md`, `Builds/Steamworks/v0.3.0/store_page/SCREENSHOT_UPLOAD_APPLICATION_KO.md`, `Builds/Steamworks/v0.3.0/store_page/screenshot_candidates/10_achievement_next_goal.png`, `Builds/Steamworks/v0.3.0/store_page/screenshot_candidates/11_growth_follow_up_menu.png`, `Builds/Steamworks/v0.3.0/store_page/screenshot_candidates/12_career_record_next_objective.png`, `Builds/Steamworks/v0.3.0/store_page/screenshot_candidates/13_case_archive_appeal_remedy_history.png`, `Builds/Steamworks/v0.3.0/store_page/screenshot_candidates/14_case_archive_decision_audit_coaching_focus.png`.

## 11. 스크린샷 업로드 순서

Steam 리뷰 기준에 맞춰 모두 실제 게임 화면만 사용한다.

1. `Builds/Marketing/v0.3.0/screenshots/02_case_review.png` - 가족 신청서, 위험 신호, 예산/안정/형평 지표, 다섯 가지 판단 버튼을 한 화면에 보여준다.
2. `Builds/Marketing/v0.3.0/screenshots/03_decision_feedback.png` - 판단 직후 권장 판단 대비 차이와 다음 날 후폭풍을 보여준다.
3. `Builds/Marketing/v0.3.0/screenshots/04_day_transition.png` - 후속 연락함, 특별 사건, 다음 날 운영 압박을 보여준다.
4. `Builds/Marketing/v0.3.0/screenshots/05_final_report.png` - 최종 리포트, 엔딩, 캠페인 등급, 판단 표를 보여준다.
5. `Builds/Marketing/v0.3.0/screenshots/08_career_record_filter.png` - 캠페인 기록의 보정 추천 필터, 추천별 회차 결과, 기준별 장기 추세, 직전/이전 최고 대비 성장 비교, 반복 보상 연결을 보여준다.
6. `Builds/Marketing/v0.3.0/screenshots/07_agent_analysis.png` - 여러 가상 플레이어 성향의 판단 차이와 재심사 근거를 보여준다.
7. `Builds/Marketing/v0.3.0/screenshots/06_ending_gallery.png` - 엔딩 기록과 반복 장식 보상을 보여준다.
8. `Builds/Marketing/v0.3.0/screenshots/01_main_menu.png` - 실제 메인 메뉴, 운영 기준 선택, 성과/캠페인 기록 진입점을 보여준다.

메인 메뉴 이미지는 실제 게임 화면이지만, 게임플레이 이해도 면에서는 후순위로 둔다. `08_career_record_filter.png`는 보정 추천별 반복 플레이 가치와 성장 비교가 보이는 핵심 장면이므로 최종 리포트 직후에 배치한다.

### QA 후보 스크린샷

- `Builds/Marketing/v0.3.0/screenshots/10_achievement_next_goal.png` - 성과 다음 목표 QA 비교 이미지다. 성과 기록, 다음 성과 목표, 목표 실행 버튼, 목표 실행 -> 캠페인 기록 -> 2/4/6 보상 누적 성과-캠페인 루프를 검수한다.
- `Builds/Marketing/v0.3.0/screenshots/11_growth_follow_up_menu.png` - 성장 후속 메인 메뉴 QA 비교 이미지다. 성장 후속 추천 대기, `후속 심사` 버튼, H 단축키, 후속 운영 기준 힌트를 검수한다.
- `Builds/Marketing/v0.3.0/screenshots/12_career_record_next_objective.png` - 캠페인 기록 목표 재시작 QA 비교 이미지다. 성장 후속/보정 기록, 동일 사례 회고, 다음 목표 재시작 버튼, 성과 기록 보상 누적으로 돌아가는 성과-캠페인 루프, 포커스 하이라이트를 검수한다.
- `Builds/Marketing/v0.3.0/screenshots/13_case_archive_appeal_remedy_history.png` - 사례 자료실 보정 이력 QA 비교 이미지다. 원 이의제기 사례, 보정 이력, 성공률, 다음 재도전 목표를 검수한다.
- `Builds/Marketing/v0.3.0/screenshots/14_case_archive_decision_audit_coaching_focus.png` - 사례 자료실 판단 복기 복기 포커스 QA 비교 이미지다. 사례 자료실의 `복기 W-207` 버튼, `판단 복기 복기 포커스`, `기록 복귀`, `복기 왕복 힌트`가 한 화면에서 읽히는지 검수한다.
- Steamworks 사본은 `store_page/screenshot_candidates`와 `store_page/SCREENSHOT_CANDIDATES_KO.md`에 함께 보관해 Store Presence 입력 전 비교 검토에 사용한다.
- 후보 승격 우선순위는 `store_page/SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`에서 관리한다. 이 문서는 플레이테스트 집계의 설문 회수 7/169, 10달러 가치감 3.9/5, 반복 보상 가치감 3.7/5, UI 가독성 3.6/5, 재플레이 의향 4/7을 읽어 현재 1순위를 `12_career_record_next_objective.png`로 자동 판정하고 `13_case_archive_appeal_remedy_history.png`를 보정 이력 보조 후보로 비교한다. 단, 외부 회수 신뢰도는 실제 사람 완전 회수 세션 0/5, 상용 최소 10명 미달, `qa_or_incomplete_survey_sessions`로 분리 표시하며 공식 승격 확정 전까지는 `QA 샘플 기반 임시 판정`으로 취급한다.
- 후보 A/B 판정은 `store_page/SCREENSHOT_CANDIDATE_AB_TEST_KO.md`에서 관리한다. 외부 A/B 피드백 전에는 기본 후보 `12_career_record_next_objective.png`를 유지하고, 보정 이력 후보 선호가 충분할 때만 `13_case_archive_appeal_remedy_history.png`를 공식 8장 교체 후보로 올린다.
- 공식 8장 업로드 선택은 `store_page/SCREENSHOT_UPLOAD_SELECTION_KO.md`에서 관리한다. 현재는 `promotion_status: not_promoted`, `selected_upload_set: current_official_8`, `submission_update_required: no`라서 아래 8장 순서를 유지한다. 외부 완전 회수 5명 이상과 반복/UI 신호 기준을 충족하면 `12_career_record_next_objective.png`를 `01_main_menu.png` 대신 넣는 승격 후보 세트가 생성되며, 이 제출안의 8장 순서를 함께 갱신해야 한다.
- 적용 검증은 `store_page/SCREENSHOT_UPLOAD_APPLICATION_KO.md`에서 관리한다. 현재 제출안 공식 8장 구간은 `current_official_order_matches: yes`, `submission_matches_selected_set: yes`, `ready_for_store_presence_upload: yes`이며, 후보 섹션에 있는 12번 이미지는 공식 업로드 순서 검사에서 제외한다.
- 통합 검증은 `store_page/STORE_PRESENCE_SELECTION_KO.md`에서 관리한다. 이 파일은 스크린샷 적용 manifest와 트레일러 업로드 선택 manifest를 함께 읽어 현재 `store_presence_needs_submission_update: no`, `store_presence_ready_for_manual_input: yes`를 기록한다.
- 가치 포지셔닝 검증은 `store_page/STORE_VALUE_POSITIONING_KO.md`에서 관리한다. 실제 가격 기준은 `USD 9.99`로 유지하지만, 20달러급 품질 목표에 맞는 상점 가치 축 6개와 가격 가치감 `3.9/5` 신호를 확인해 `twenty_dollar_quality_benchmark_ready: yes`를 기록한다. 이 manifest는 실제 20달러대 가격 변경을 승인하지 않는다.

이 후보는 실제 상점 업로드 8장에는 바로 포함하지 않고, 내부 QA와 Steam 페이지 비교 검토에서만 사용한다.

## 12. 트레일러 후보

### 업로드 후보

- 파일: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0.mp4`
- 규격: `1920x1080`, `30fps`, H.264 video, AAC stereo audio
- 길이: `45.000s`
- 전체 비트레이트: 약 `8,218Kbps`
- SHA256: `C266305CEE20CD8D66E1BD697B9661EBEEF73C7938F1D90FC3F1210A9B62B59F`

### 보관용 저용량 컷

- 파일: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_store_final_v0.3.0.mp4`
- 규격: `1920x1080`, `30fps`, H.264 video, AAC stereo audio
- 길이: `45.000s`
- 전체 비트레이트: 약 `1,257Kbps`
- SHA256: `FCE7855490C8AA5BDC18ACD4DBE482E4DAF71EA0A64C4DACE0C4404389EF09E5`
- 특징: 상점용 하드자막, 약한 카메라 무빙, 시작/종료 페이드, 앰비언스/버튼 큐 오디오가 적용된 최종 컷

저용량 컷은 로컬 공유용으로 두고, Steam 업로드에는 고비트레이트 후보를 사용한다.

### 리마스터 작업표

- 작업표: `Docs/트레일러_리마스터_작업표.md`
- Steamworks 사본: `Builds/Steamworks/v0.3.0/store_page/TRAILER_REMASTER_WORK_ORDER_KO.md`
- 정리 사유: 최근 트레일러 프레임 manifest는 `trailer_013_career_record_filter.png`를 포함한 49초 구성안을 기록하지만, 실제 Steam 업로드 후보 MP4는 `45.000s`다.
- 현재 제출 기준: 검증된 45초 고비트레이트 MP4를 유지한다.
- 업로드 선택 manifest: `Builds/Steamworks/v0.3.0/store_page/TRAILER_UPLOAD_SELECTION_KO.md`에서 `current_selection: current_upload`, `selected_file: care_review_office_trailer_steam_upload_v0.3.0.mp4`, `submission_selected_file_match: yes`, `ready_for_steam_store_upload: yes`를 확인한다. 리마스터 업로드 후보로 전환하면 `current_selection`과 이 제출안의 파일명이 함께 바뀌어야 한다.
- Store Presence 통합 선택 manifest: `Builds/Steamworks/v0.3.0/store_page/STORE_PRESENCE_SELECTION_KO.md`에서 스크린샷 적용과 트레일러 선택이 모두 `yes`인지 확인한다. 스크린샷 승격 후보나 리마스터 트레일러 후보 중 하나라도 제출안에 반영되지 않으면 `store_presence_ready_for_manual_input: no`가 된다.
- 다음 리마스터 기준: 13개 프레임 구성을 45초 타임라인으로 재배치하고 마지막 캠페인 기록 필터 장면을 `41-45s` 구간에 둔다.
- 리컷 스크립트: `Builds/Marketing/v0.3.0/trailer/render_trailer_remaster_45s.ps1`
- 리컷 산출물: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0_remaster.mp4`, `45.000s`, H.264, `1920x1080`, `30fps`, AAC stereo

## 13. 출시 준비 순서

1. Steamworks AppID와 Windows DepotID 발급
2. 이 제출안의 기본 정보, 설명, 태그, 시스템 요구 사항 입력
3. 그래픽 자산 업로드
4. 스크린샷 8장 업로드
5. QA 비교 스크린샷 `10_achievement_next_goal.png`, `11_growth_follow_up_menu.png`, `12_career_record_next_objective.png`, `13_case_archive_appeal_remedy_history.png`, `14_case_archive_decision_audit_coaching_focus.png`는 내부 QA 비교용으로 보관하고 Steamworks `store_page/screenshot_candidates` 및 `SCREENSHOT_UPLOAD_SELECTION_KO.md` 사본을 대조한다. 플레이테스트 설문 화면은 출시 상점 업로드 세트에서 제외하고 QA 회수 전용으로만 사용한다.
6. `TRAILER_UPLOAD_SELECTION_KO.md`의 `selected_file`과 이 제출안의 업로드 후보 파일명이 일치하는지 확인한 뒤 고비트레이트 트레일러 업로드
7. `STORE_PRESENCE_SELECTION_KO.md`가 `store_presence_ready_for_manual_input: yes`인지 확인한 뒤 Store Presence 수동 입력을 시작
8. 보정 후보 결과 확인: `STORE_PRESENCE_SELECTION_KO.md`의 `appeal_triage_qa_evidence`, `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `보정 후보 결과`를 확인하고 `STORE_PRESENCE_QA_CARD_KO.md`에 같은 증거가 연결됐는지 대조
9. `STORE_VALUE_POSITIONING_KO.md`가 `twenty_dollar_quality_benchmark_ready: yes`이고 `actual_price_change_ready: no_requires_external_validation`인지 확인해 가격 문구 과장을 막는다
10. 가격 USD 9.99 입력, 출시 할인 여부 결정
11. Mature Content Survey 작성
12. Store Presence checklist 완료 후 `Mark as ready for review`
13. 승인 후 `Post as Coming Soon`
14. 최소 2주 이상 Coming Soon 유지
15. SteamCMD preview run, 비공개 브랜치 설치 QA
16. Product Build checklist 완료 후 빌드 리뷰 제출

## 14. 현재 금지 문구

현재 빌드에 없으므로 상점 페이지에 적지 않는다.

- 영어 지원
- Steam Cloud
- Steamworks 실제 업적 연동
- 컨트롤러 완전 지원
- 데모
- 8종 엔딩
- 45개 이상 사례
- 실제 기관/실제 정책 데이터 기반
- 실제 플레이어 통계 수집
