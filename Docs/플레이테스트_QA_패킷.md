# 돌봄지원 심사소 플레이테스트 QA 패킷

작성일: 2026-05-28
대상 버전: v0.3.0

## 목적

실제 사람 플레이 기반 미세 밸런스 QA를 위해, 한 회차 플레이가 끝난 뒤 정량 로그와 정성 설문을 함께 수집한다.

## 배포 패킷

- 플레이테스터 배포 폴더: `Builds/Playtest/v0.3.0`
- 플레이테스트 회수 inbox: `Builds/Playtest/CollectedSessions`
- 플레이테스터 배포 zip: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`
- 배포 zip 크기: 68,839,600 bytes
- 배포 zip SHA256: `AB70BF761DD44BFA87EAC43F3A878BFCCFC3BA0167BCF55A472F429F87FA56EB`
- 포함 파일: 실행 zip, 실행 zip SHA256, 테스터 안내문, 요청 문구, 회수 체크리스트, 세션 인덱스 CSV 템플릿
- 세션 인덱스 CSV 우선순위 배지 컬럼: `triage_priority_badge_id`, `triage_priority_badge_status`, `triage_priority_badge_evidence`
- 외부 검증 핸드오프: `Builds/Handoff/v0.3.0/TESTER_RECRUITMENT_BATCH_KO.md`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`
- 외부 검증 핸드오프 zip: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 35,424 bytes, SHA256 `9FDDAA075440117BA90AFABE0C32AC62B6A269C49FE987444DECB25EB202DE3E`
- handoff Store Presence 증거 묶음 우선순위 배지 회수 컬럼: `triage_priority_badge_id`, `triage_priority_badge_status`, `triage_priority_badge_evidence`, `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`
- handoff action CSV 우선순위 배지 owner_screen 행: `우선순위 배지: 상점 후보 루프 이해`, `우선순위 배지: 메인 메뉴 기준 화면`, `우선순위 배지: 성과-캠페인 문구 일치`
- Steamworks upload manifest priority badge memberSummary 요약: `priority_badges=store_presence_priority_badge_backreference`, `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`
- Store Presence QA 카드 우선순위 배지 회수 후 처리 상태: `after_collection_status`, `manual_update_target`, `completion_gate`
- Store Presence 증거 초안 우선순위 배지 회수 후 입력란: `store_presence_priority_badge_after_collection_input`, `after_collection_status_reward_loop_candidate`, `completion_gate_main_menu_baseline`
- HUMAN_10 action CSV 우선순위 배지 owner_screen tracker 힌트: `action_csv_priority_badge_owner_screen`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`
- 외부 게이트 감사 HUMAN_10 우선순위 배지 owner_screen 별도 필드: `priority_badge_owner_screen_summary`, `priorityBadgeOwnerScreenSummary`, `action_csv_priority_badge_owner_screen`
- Paperlogy 폰트 커버리지: `Paperlogy-6SemiBold`, `paperlogyFontApplied=true`, `paperlogyTextFontCoverageApplied=true`, `paperlogyTextMismatchCount=0`
- Paperlogy upload manifest evidence: `font=Paperlogy-6SemiBold`, `runtime_qa=care_review_ui_cleanup_smoke_result.json`, `license=Docs/THIRD_PARTY_FONTS.md`
- Steam 제출 프리플라이트 Paperlogy manifest evidence 역참조: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `Paperlogy font evidence`, `content_windows/RELEASE_MANIFEST.txt`, `content_windows/README_KR.txt`, `Docs/THIRD_PARTY_FONTS.md`
- 저해상도 메인 메뉴 첫 행동 안내: `mainMenuGuidesFirstActionReadable=true`, `mainMenuGuidesFirstActionLineSample=처음이면 N 새 캠페인 · 저장 있음 C 이어하기 · D 기준`
- Store Presence tracker 우선순위 배지 회수 후 입력란 힌트: `after_collection_inputs=store_presence_priority_badge_after_collection_input`, `after_collection_status_reward_loop_candidate`, `completion_gate_main_menu_baseline`, `completion_gate_copy_alignment`
- 외부 게이트 감사 Store Presence after_collection_inputs 별도 필드: `store_presence_after_collection_input_summary`, `storePresenceAfterCollectionInputSummary`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`
- 릴리즈 후보 감사 노트 Store Presence after_collection 입력란: `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `storePresenceAfterCollectionInputSummary`, `store_presence_after_collection_input_summary`, `after_collection_status_reward_loop_candidate`
- 외부 게이트 smoke Handoff zip SHA 상호참조: `handoffZipSha256`, `handoffZipBytes`, `handoffZipHashFileMatches=true`
- 외부 게이트 smoke handoffZipSha256 사람용 감사 항목: `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256=9FDDAA075440117BA90AFABE0C32AC62B6A269C49FE987444DECB25EB202DE3E`, `handoffZipBytes=35424`, `handoffZipHashFileMatches=true`
- 외부 게이트 smoke Steamworks zip SHA 사람용 감사 항목: `care_review_external_gate_audit_smoke_result.json`, `steamworksZipSha256=882CE9159B8DE4E9B1DC92021CEA7A2F4EB19CF8AD83C11505CDE2BF03DA1F1C`, `steamworksZipBytes=60166347`, `steamworksZipHashFileMatches=true`
- README 첫 섹션 smoke zip SHA 요약 사람용 감사 항목: `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `외부 게이트 smoke zip SHA`, `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256=9FDDAA075440117BA90AFABE0C32AC62B6A269C49FE987444DECB25EB202DE3E`, `handoffZipBytes=35424`, `steamworksZipSha256=882CE9159B8DE4E9B1DC92021CEA7A2F4EB19CF8AD83C11505CDE2BF03DA1F1C`, `steamworksZipBytes=60166347`
- handoff zip 내부 `v0.3.0/PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv` 포함: `owner_screen`, `반복 보상/장기 기록 가치감`, `성과 기록 / 캠페인 기록 / 상점 페이지`, `반복 가치 세부: 성과 기록 보상`, `반복 가치 세부: 캠페인 기록 다음 목표`, `반복 가치 세부: 상점 후보 루프 이해` 토큰 기준으로 배포 무결성 감사에서 확인

## Store Presence Draft 독립 체크

- [x] 플레이테스트 회수 자료와 Store Presence 실제 입력 증거를 분리한다.
- [x] 증거 묶음 준비: `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `checkCount=11`, `passedCheckCount=11`, `allPassed=true`
- [ ] 실제 입력 증거: `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`
- [x] 외부 게이트 row 연결: `storePresenceDraftStatusSummary`, `store_presence_draft_status_summary`, `actual_status=pending_external`
- [x] 자체점검 연결: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `Store Presence 외부 액션 연결`, `externalActionCount=8`
- [x] A/B 응답 회수 보류: `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=221`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`, `screenshot_ab_loop_understanding_comment_count=0`
- [x] 브리핑 회고 후보 입력란: `Evidence/STORE_PRESENCE.md`, `briefing_retrospective_candidate_evidence`, `briefing_retrospective_candidate_file`, `briefing_retrospective_candidate_terms`, `briefing_retrospective_candidate_smoke`, `storeCandidateMentionsBriefingRetrospective=true`, `12_career_record_next_objective.png`
- [x] 판단 복기 보조 후보: `Builds/Handoff/v0.3.0/STORE_PRESENCE_QA_CARD_KO.md`, `14_case_archive_decision_audit_coaching_focus.png`, `복기 W-207`, `decision_audit_coaching_candidate_evidence`, `caseArchiveDecisionAuditCoachingButtonOpensFirstUseCase=true`, `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`
- [x] Store Presence 실제 증거 초안 입력란: `Builds/Handoff/v0.3.0/Evidence/STORE_PRESENCE.md`, `decision_audit_coaching_candidate_file`, `decision_audit_coaching_candidate_case`, `decision_audit_coaching_candidate_round_trip`
- [x] 작성 완료 전 자체점검 표: `Builds/Handoff/v0.3.0/STORE_PRESENCE_QA_CARD_KO.md`, `Builds/Handoff/v0.3.0/Evidence/README_KO.md`, `Steamworks URL/화면 캡처`, `SHA 확인`, `14번 복기 후보`, `토스트 UI 캡처`, `A/B 응답 회수`
- [x] 실제 증거 초안 자체점검 TODO: `Builds/Handoff/v0.3.0/Evidence/STORE_PRESENCE.md`, `작성 완료 전 자체점검 TODO`, `[ ] Steamworks URL/화면 캡처`, `[ ] SHA 확인`, `[ ] 14번 복기 후보`, `[ ] 브리핑 회고 후보`, `[ ] A/B 응답 회수`
- [x] STORE_PRESENCE.md 통과 전 TODO 요약: `Builds/Handoff/v0.3.0/Evidence/STORE_PRESENCE.md`, `통과 전 확인`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] STORE_PRESENCE_EXAMPLE.md TODO 예시 요약: `Builds/Handoff/v0.3.0/Evidence/STORE_PRESENCE_EXAMPLE.md`, `작성 순서`, `자체점검 TODO 요약 예시`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] STORE_PRESENCE 템플릿 TODO 요약: `Builds/Handoff/v0.3.0/Evidence/_templates/STORE_PRESENCE.md`, `후보 스크린샷 A/B 판정`, `자체점검 TODO 요약 템플릿`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] tracker/README 자체점검 TODO 요약: `Builds/Handoff/v0.3.0/EXTERNAL_RELEASE_GATE_TRACKER.csv`, `Builds/Steamworks/v0.3.0/README_STEAMWORKS_KR.txt`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] Steamworks README 첫 섹션 TODO 요약: `Builds/Steamworks/v0.3.0/README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `제출 전 TODO 첫 확인`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] Steamworks README 감사 노트 템플릿 TODO 역참조: `Builds/Steamworks/v0.3.0/README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `감사 노트 템플릿 TODO 역참조`, `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`
- [x] handoff README 첫 확인 TODO 요약: `Builds/Handoff/v0.3.0/README_KO.txt`, `첫 확인 항목`, `handoff TODO 첫 확인`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] handoff 문서 최상단 TODO 요약: `Builds/Handoff/v0.3.0/EXTERNAL_RELEASE_HANDOFF_KO.md`, `Store Presence 증거 초안 상태`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] QA 카드 첫 섹션 TODO 요약: `Builds/Handoff/v0.3.0/STORE_PRESENCE_QA_CARD_KO.md`, `준비`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] Evidence README 첫 섹션 TODO 요약: `Builds/Handoff/v0.3.0/Evidence/README_KO.md`, `Store Presence 증거 작성`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] 제출 전 자체점검 TODO 요약: `Builds/Steamworks/v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`, `외부 검증 Store Presence 자체점검 TODO 요약`
- [x] 최상단 판정 요약 TODO 요약: `Builds/Steamworks/v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`, `최상단 판정 요약`, `Store Presence 자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] 릴리즈 감사 노트 TODO 요약: `Builds/Steamworks/v0.3.0/RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `care_review_release_candidate_audit.md`, `자체점검 TODO 요약`
- [x] 감사 노트 템플릿 TODO 역참조: `Builds/Steamworks/v0.3.0/RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `Builds/Steamworks/v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`, `외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`, `자체점검 TODO 요약 템플릿`
- [x] upload manifest TODO 요약: `Builds/Steamworks/v0.3.0/STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence draft`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] upload manifest 감사 노트 템플릿 TODO 역참조: `Builds/Steamworks/v0.3.0/STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence draft`, `README_STEAMWORKS_KR.txt 감사 노트 템플릿 TODO 역참조`, `STEAM_SUBMISSION_PREFLIGHT_KO.md 외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`
- [x] 판단 복기 패턴 분포 Store/QA handoff: `care_review_playtest_aggregate.json`, `care_review_playtest_aggregate.md`, `Builds/Handoff/v0.3.0/STORE_PRESENCE_QA_CARD_KO.md`, `decisionAuditCoachingSessionCount=10/221`, `decisionAuditCoachingPatternCounts=고비용 지원`, `decisionAuditCoachingMandateCounts=긴축 감사`
- [x] Steamworks 업로드 준비 문서 memberSummary 상호참조: `Docs/Steamworks_업로드_준비.md`, `Store Presence Draft 독립 체크`, `upload manifest memberSummary 상호참조`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`
- 실제 사람 플레이테스트를 회수해도 Steamworks URL/화면 캡처와 A/B 응답 회수 수치를 `Evidence/STORE_PRESENCE.md`에 채우기 전까지 `STORE_PRESENCE` 외부 게이트는 `pending_external`로 유지한다.
- [x] 최신 Store Presence 브리핑 회고 후보 입력란 감사: `Logs/audit_release_candidate_store_presence_briefing_retrospective_fields_final_pass.log` 257/257 통과, `Logs/audit_distribution_integrity_store_presence_briefing_retrospective_fields_final.log` 120/120 통과, handoff SHA256 `F19F961BE1EA901094992F044BB99212B46967C7198E8D9DD3CE475E031C29A3`

## 생성 방법

1. 게임을 끝까지 플레이한다.
2. 첫 실행 고지에서 합성 사례, 로컬 저장, 자동 업로드 없음, 실제 판단 비대체 내용을 확인한다.
3. 최종 리포트 화면에서 `테스터 설문` 또는 F 키를 눌러 5점 척도와 빠른 체크를 저장한다.
4. 최종 리포트 화면에서 `로그 저장`을 누른다.
5. 게임 설정 화면의 `로그 폴더` 버튼으로 저장 위치를 연다.
6. `playtest_sessions/<sessionId>` 폴더를 회차별 원본으로 회수한다.
7. 가능하면 설정 화면의 `환경 진단` 버튼 또는 B 키로 테스트 PC의 CPU/GPU/RAM, 화면 설정, FPS 샘플을 저장한다.
8. 다시 `테스터 설문`을 열어 `회수 준비: 회수 완료`가 표시되는지 확인한다.
9. 같은 `테스터 설문` 화면의 `상용화 보강 체크` 패널에서 성과 기록, 캠페인 기록, 상점 후보, 다시 할 이유 항목이 한 화면에 표시되는지 확인한다. 회수 준비 스모크 증거는 `commercialChecklistMentionsSurfaceActions=true`, `commercialChecklistReadable=true`다.
10. 상점 후보 스크린샷 A/B 질문은 `10_achievement_next_goal.png`와 `12_career_record_next_objective.png` 중 `목표 실행 -> 캠페인 기록 -> 2/4/6 보상 누적` 흐름이 더 빨리 이해되는 쪽을 `PLAYTEST_SESSION_INDEX_TEMPLATE.csv`의 `screenshot_ab_loop_*` 컬럼에 기록한다.
11. 문제가 발생했거나 파일 회수가 번거로운 경우 설정 화면의 `지원 번들` 버튼 또는 U 키로 런타임 이슈 로그가 포함된 `support_bundles/<bundleId>` 폴더를 생성한다.
12. 로그 폴더 바로 아래의 고정 파일명 사본은 최신 회차 확인용으로만 사용한다.
13. 외부에 공유할 때는 `C:/Users`, `AppData`, `LocalLow` 같은 로컬 사용자 절대경로가 포함되지 않았는지 확인한다. 현재 패킷 산출물은 `playtest_sessions/<sessionId>/파일명` 또는 `support_bundles/<bundleId>/파일명` 상대경로만 기록하도록 되어 있다.

로그 저장 시 생성되는 설문 Markdown과 HTML 대시보드에는 `자동 재검토 큐`가 포함된다. 이 큐는 고압력 사례마다 재검토 이유, 사례 자료실 권장 필터, 다음 회차 실험 질문을 함께 적어 실제 테스터 인터뷰 질문으로 바로 사용할 수 있게 한다.

## 회수 감사

외부 테스터에게 받은 `playtest_sessions/<sessionId>` 폴더나 `support_bundles/<bundleId>` 폴더는 `Builds/Playtest/CollectedSessions` 아래에 모은다. 이후 Unity 메뉴 `Care Review Office/Audit Playtest Collection` 또는 아래 배치 명령으로 감사 리포트를 만든다.

```powershell
& 'C:\Program Files\Unity\Hub\Editor\6000.4.5f1\Editor\Unity.exe' -batchmode -quit -projectPath 'C:\codex\CareReviewOfficeUnity' -executeMethod CareReviewProjectBuilder.AuditPlaytestCollection -logFile 'C:\codex\CareReviewOfficeUnity\Logs\audit_playtest_collection_support_bundle_v030.log'
```

감사 산출물:

- `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_collection_audit_summary.json`
- `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_collection_audit.csv`
- `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_collection_audit.md`
- `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage.json`
- `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage.md`
- `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage.html`

완전 회수 기준은 35건 이상 판단 로그, 세션 요약, 설문 JSON/Markdown, 환경 진단 JSON/Markdown, HTML 대시보드, 로컬 절대경로 미포함이다. 지원 번들로 받은 세션은 여기에 `care_review_support_bundle_manifest.json`/`.md`, `care_review_runtime_issues.json`/`.md`, 지원 번들 파일의 로컬 절대경로 미포함 여부까지 함께 본다. 현재 자동 QA 샘플과 QA 지원 번들은 회수 도구 검증용이며 실제 사람 플레이테스트 기준 충족으로 계산하지 않는다.

상용화 트리아지 리포트는 완전 회수된 외부 세션을 기준으로 난이도, 판단 기준 명확성, 결과 납득도, UI 가독성, 10달러 가치감, 반복 보상/장기 기록 가치감, 재플레이 의향을 집계한다. 실제 사람 완전 회수가 10명 미만이면 판매 후보 확정이 아니라 담당 화면별 회수/보강 액션 목록만 낸다.

## 생성 파일

- `care_review_play_log.json`: 익명 세션 ID, 플레이 시간, 전체 판단 로그, 캠페인 챌린지 결과와 최종 지표
- `care_review_play_log.csv`: 세션 ID, 판단 순서, 판단 시각, 경과 시간을 포함한 사례별 판단 CSV
- `care_review_incident_log.csv`: 일차별 특별 사건 로그
- `care_review_playtest_summary.json`: 세션 ID, 플레이 시간, 판단 분포, 판단 근거 분포, 권장 판단 일치율, 운영 등급/점수/배지, 캠페인 챌린지 결과, 우선 확인 지점, 일차별 결정 감사 요약, 고압력 대표 사례, 재검토 이유/자료실 필터/다음 회차 실험 질문, 다음 캠페인 목표 추천
- `care_review_playtest_feedback.md`: 익명 테스터 코드, 테스트 환경, 운영 등급 근거, 캠페인 챌린지 결과, 판단 근거 분포, 자동 재검토 큐, 다음 캠페인 목표, 5점 척도와 서술형 피드백 템플릿
- `care_review_in_game_feedback.json`: 최종 리포트에서 저장한 난이도, 판단 기준 명확성, 결과 납득도, UI 가독성, 10달러 가치감, 반복 보상/장기 기록 가치감 5점 척도와 빠른 체크 JSON
- `care_review_in_game_feedback.md`: 같은 설문을 사람이 읽기 쉬운 Markdown으로 정리한 회차별 피드백
- `care_review_analytics_dashboard.html`: 세션 ID, 운영 등급 카드, 캠페인 챌린지, 가족 유형 판단 지도, 판단 근거 분포, 결정 감사 일차표, 고압력 대표 사례, 자료실 필터/재검토 질문, 다음 캠페인 목표가 포함된 로컬 HTML 분석 대시보드
- `care_review_playtest_sessions_index.csv`: 여러 세션을 한 줄씩 비교하고 운영 등급/점수, 캠페인 챌린지 성공 여부/점수, 다음 캠페인 목표, 최다 판단 근거, 상점 후보 성과-캠페인 루프 A/B 질문 컬럼을 포함하는 집계 CSV
- `care_review_playtest_aggregate.json`: 세션 수, 평균 지표, 평균 운영 점수, 평균 챌린지 점수, 챌린지 성공 수, 설문 회수 세션 수, 평균 난이도/명확성/납득도/UI/10달러 가치감/반복 보상·장기 기록 가치감, 재플레이 의향 수, 운영 기준/엔딩/우선 확인 지점/최다 판단 근거/판단 복기 패턴 분포 JSON
- `care_review_playtest_aggregate.md`: 평균 운영 점수, 캠페인 챌린지 성공 수, 설문/가격 가치감 요약, 판단 복기 패턴 분포, 세션별 등급, 최다 판단 근거를 포함한 사람이 읽기 쉬운 플레이테스트 집계 보고서
- `care_review_system_diagnostic.json`: CPU/GPU/RAM, 그래픽 장치, 화면 설정, 저사양/FPS 제한 설정, FPS 샘플을 담은 환경 진단 JSON
- `care_review_system_diagnostic.md`: 사람이 읽기 쉬운 환경 진단 Markdown
- `support_bundles/<bundleId>/care_review_support_bundle_manifest.json`: 최신 로그, 세션 원본, 설문, 환경 진단, 저장 파일 묶음의 포함 여부와 경로 비식별화 결과
- `support_bundles/<bundleId>/care_review_support_bundle_manifest.md`: 사람이 읽기 쉬운 지원 번들 요약
- `support_bundles/<bundleId>/care_review_runtime_issues.json`: 플레이 중 발생한 Warning/Error/Exception의 익명화된 JSON 기록
- `support_bundles/<bundleId>/care_review_runtime_issues.md`: 사람이 읽기 쉬운 런타임 이슈 요약
- `care_review_local_data_delete_smoke_result.json`: 설정 화면 로컬 데이터 삭제의 2단계 확인, 게임 생성 파일/폴더 삭제, 무관 파일 보존, 로컬 절대경로 미포함 검증 결과
- `care_review_first_run_notice_smoke_result.json`: 첫 실행 고지 표시, 확인 저장, 메뉴 복귀, 필수 고지 문구 검증 결과
- `care_review_data_source_smoke_result.json`: cases_day1~5 JSON, 런타임 사례 수, agent_personas, embedded fallback 미사용, 로컬 절대경로 미포함 검증 결과
- `care_review_data_source_audit.md`: 데이터 소스 무결성 감사 요약 Markdown

같은 파일이 로그 폴더 바로 아래에도 최신 사본으로 복사되지만, 여러 명의 테스트를 받을 때는 반드시 `playtest_sessions/<sessionId>` 폴더 단위로 모아야 한다.

## 자동 검증

- 실행 인자: `-careReviewPlaytestPacketSmokeTest`
- 집계 실행 인자: `-careReviewPlaytestAggregateSmokeTest`
- 추천 심사 재시작 실행 인자: `-careReviewRecommendedReplaySmokeTest`
- 심사 기준표 실행 인자: `-careReviewPolicyHandbookSmokeTest`
- 정책 시뮬레이터 실행 인자: `-careReviewPolicySimulatorSmokeTest`
- 선택지 미리보기 실행 인자: `-careReviewDecisionPreviewSmokeTest`
- 후속 연락함 실행 인자: `-careReviewFollowUpInboxSmokeTest`
- 판단 근거 실행 인자: `-careReviewDecisionRationaleSmokeTest`
- 판단 근거 분석 실행 인자: `-careReviewDecisionRationaleAnalyticsSmokeTest`
- 운영 등급 실행 인자: `-careReviewCampaignGradeSmokeTest`
- 캠페인 챌린지 실행 인자: `-careReviewCampaignChallengeSmokeTest`
- 인게임 설문 실행 인자: `-careReviewPlaytestSurveySmokeTest`
- 환경 진단 실행 인자: `-careReviewSystemDiagnosticSmokeTest`
- 런타임 이슈 로그 실행 인자: `-careReviewRuntimeIssueSmokeTest`
- 컨트롤러 단축 입력 실행 인자: `-careReviewControllerShortcutSmokeTest`
- 컨트롤러 포커스 이동 실행 인자: `-careReviewFocusNavigationSmokeTest`
- 지원 번들 실행 인자: `-careReviewSupportBundleSmokeTest`
- 로컬 데이터 삭제 실행 인자: `-careReviewLocalDataDeleteSmokeTest`
- 첫 실행 고지 실행 인자: `-careReviewFirstRunNoticeSmokeTest`
- 첫 근무 온보딩 실행 인자: `-careReviewFirstStartOnboardingSmokeTest`
- 상용 콘텐츠 감사 실행 인자: `-careReviewContentAuditSmokeTest`
- 데이터 소스 무결성 실행 인자: `-careReviewDataSourceSmokeTest`
- 배포 패킷 무결성 감사 실행 메서드: `CareReviewProjectBuilder.AuditDistributionIntegrity`
- 회수 감사 실행 메서드: `CareReviewProjectBuilder.AuditPlaytestCollection`
- 최신 검증 로그: `Logs/runtime_playtest_packet_review_queue_v030.log`
- 최신 회수 감사 로그: `Logs/audit_playtest_collection_support_bundle_v030.log`
- 최신 집계 검증 로그: `Logs/runtime_playtest_aggregate_campaign_challenge_v030.log`
- 설문 가치감 집계 검증 로그: `Logs/runtime_playtest_aggregate_survey_value_retry_v030.log`
- 선택지 미리보기 검증 로그: `Logs/runtime_decision_preview_v030.log`
- 인게임 설문 검증 로그: `Logs/runtime_playtest_survey_final_v030.log`, `Logs/runtime_playtest_survey_steamworks_v030.log`
- 플레이테스트 회수 준비 검증 로그: `Logs/runtime_playtest_readiness_v030.log`
- 환경 진단 검증 로그: `Logs/runtime_system_diagnostic_final_v030.log`, `Logs/runtime_system_diagnostic_steamworks_v030.log`
- 런타임 이슈 로그 검증 로그: `Logs/runtime_issue_log_v030.log`
- 컨트롤러 단축 입력 검증 로그: `Logs/runtime_controller_shortcut_v030.log`
- 컨트롤러 포커스 이동 검증 로그: `Logs/runtime_focus_navigation_v030.log`
- 지원 번들 검증 로그: `Logs/runtime_support_bundle_v030.log`
- 로컬 데이터 삭제 검증 로그: `Logs/runtime_local_data_delete_v030.log`
- 첫 실행 고지 검증 로그: `Logs/runtime_first_run_notice_v030.log`
- 상용 콘텐츠 감사 로그: `Logs/runtime_content_audit_v030.log`
- 데이터 소스 무결성 로그: `Logs/runtime_data_source_integrity_v030.log`
- 배포 패킷 무결성 감사 로그: `Logs/audit_distribution_integrity_final_v030.log`
- QA 보관 폴더: `Builds/QA/v0.3.0/playtest_packet`
- 인게임 설문 QA 결과: `Builds/QA/v0.3.0/care_review_playtest_survey_smoke_result.json`
- 플레이테스트 회수 준비 QA 결과: `Builds/QA/v0.3.0/care_review_playtest_readiness_smoke_result.json`
- 인게임 설문 샘플: `Builds/QA/v0.3.0/care_review_in_game_feedback_sample.json`, `Builds/QA/v0.3.0/care_review_in_game_feedback_sample.md`
- 환경 진단 QA 결과: `Builds/QA/v0.3.0/care_review_system_diagnostic_smoke_result.json`
- 환경 진단 샘플: `Builds/QA/v0.3.0/care_review_system_diagnostic_sample.json`, `Builds/QA/v0.3.0/care_review_system_diagnostic_sample.md`
- 런타임 이슈 로그 QA 결과: `Builds/QA/v0.3.0/care_review_runtime_issue_smoke_result.json`
- 컨트롤러 단축 입력 QA 결과: `Builds/QA/v0.3.0/care_review_controller_shortcut_smoke_result.json`
- 컨트롤러 포커스 이동 QA 결과: `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`
- 지원 번들 QA 결과: `Builds/QA/v0.3.0/support_bundle/care_review_support_bundle_smoke_result.json`
- 로컬 데이터 삭제 QA 결과: `Builds/QA/v0.3.0/care_review_local_data_delete_smoke_result.json`
- 첫 실행 고지 QA 결과: `Builds/QA/v0.3.0/care_review_first_run_notice_smoke_result.json`
- 첫 근무 온보딩 QA 결과: `Builds/QA/v0.3.0/care_review_first_start_onboarding_smoke_result.json`
- 상용 콘텐츠 감사 QA 결과: `Builds/QA/v0.3.0/content_audit/care_review_content_audit_smoke_result.json`
- 데이터 소스 무결성 QA 결과: `Builds/QA/v0.3.0/care_review_data_source_smoke_result.json`
- 데이터 소스 무결성 감사: `Builds/QA/v0.3.0/care_review_data_source_audit.json`, `Builds/QA/v0.3.0/care_review_data_source_audit.md`
- 배포 패킷 무결성 QA 결과: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`
- 회수 감사 결과: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_collection_audit_summary.json`
- 상용화 트리아지 결과: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_smoke_result.json`, `hasReplayRewardValuePriority=true`, `hasSurfaceActionChecklistCsv=true`
- 상용화 트리아지 담당 화면 CSV: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_actions.csv`
- 추천 심사 QA 결과: `Builds/QA/v0.3.0/care_review_recommended_replay_smoke_result.json`
- 심사 기준표 QA 결과: `Builds/QA/v0.3.0/care_review_policy_handbook_smoke_result.json`
- 정책 시뮬레이터 QA 결과: `Builds/QA/v0.3.0/care_review_policy_simulator_smoke_result.json`
- 후속 연락함 QA 결과: `Builds/QA/v0.3.0/care_review_follow_up_inbox_smoke_result.json`
- 판단 근거 QA 결과: `Builds/QA/v0.3.0/care_review_decision_rationale_smoke_result.json`
- 판단 근거 분석 QA 결과: `Builds/QA/v0.3.0/care_review_decision_rationale_analytics_smoke_result.json`
- 운영 등급 QA 결과: `Builds/QA/v0.3.0/care_review_campaign_grade_smoke_result.json`
- 캠페인 챌린지 QA 결과: `Builds/QA/v0.3.0/care_review_campaign_challenge_smoke_result.json`
- 검증 결과: `completed=true`, 40개 사례 로그, 세션 ID, 플레이 시간, CSV 세션 컬럼, 세션별 원본 폴더, 설문 Markdown, 결정 감사 JSON/HTML export, 재검토 큐 JSON/Markdown/HTML export, 운영 등급 JSON/Markdown/HTML/집계 export, 캠페인 챌린지 JSON/Markdown/HTML/집계 export, 다음 캠페인 목표 JSON/Markdown/HTML export, 다중 세션 집계 CSV/JSON/Markdown 생성 확인
- 운영 등급 검증: `gradeVisible=true`, `summaryMentionsGrade=true`, `scoreInRange=true`, `summaryHasCampaignGrade=true`, `feedbackMentionsCampaignGrade=true`, `dashboardMentionsCampaignGrade=true`, `csvHasCampaignGradeColumns=true`, `markdownMentionsCampaignScore=true`
- 캠페인 챌린지 검증: `summaryHasCampaignChallenge=true`, `feedbackMentionsCampaignChallenge=true`, `dashboardMentionsCampaignChallenge=true`, `csvHasChallengeColumns=true`, `markdownMentionsChallenge=true`
- 재검토 큐 검증: `summaryHasReviewQueueGuidance=true`, `feedbackMentionsReviewQueueGuidance=true`, `dashboardMentionsReviewQueueGuidance=true`
- 다음 캠페인 목표 검증: `summaryHasNextCampaignObjective=true`, `feedbackMentionsNextCampaignObjective=true`, `dashboardMentionsNextCampaignObjective=true`, `csvHasNextCampaignColumns=true`, `markdownMentionsNextCampaign=true`
- 추천 심사 재시작 검증: `buttonMentionsExpectedMandate=true`, `mandateApplied=true`, `budgetResetForMandate=true`, `campaignReset=true`, `tutorialVisible=true`
- 심사 기준표 검증: `summaryMentionsMandate=true`, `summaryMentionsRecommended=true`, `decisionMentionsPreview=true`
- 정책 시뮬레이터 검증: `presetCount=5`, `caseCount=40`, `everyPresetCoversAllCases=true`, `summaryMentionsBigDataLoop=true`, `visualRowsWithText=5`, `visualRowsWithBars=5`, `recommendationCardsReady=true`, `screenshotCaptured=true`, `screenshotFile=care_review_policy_simulator.png`
- 결정 감사 디자인 검증: `coachingCardInsideReportPaper=true`, `hasDayRows=true`, `hasBars=true`
- 리포트/감사 가독성 검증: `reportDenseTextReadable=true`, `reportDenseTextMinimumFontSize=14`, `paperlogyTextMismatchCount=0`
- 첫 근무 온보딩 검증: `firstWorkButtonReady=true`, `menuShowsTodayOrder=true`, `tutorialHasFourSteps=true`, `firstStepMentionsTodayMission=true`, `firstGuideStillFiveSteps=true`
- 후속 연락함 검증: `emptyStateVisible=true`, `summaryMentionsCount=true`, `bodyMentionsImpact=true`, `bodyMentionsPriority=true`
- 판단 근거 검증: `buttonUpdated=true`, `logHasRationale=true`, `csvHasRationaleColumns=true`, `historyMentionsRationale=true`, `inboxMentionsRationale=true`
- 판단 근거 분석 검증: `reportMentionsRationale=true`, `summariesHaveAllRationales=true`, `summaryHasRationaleAnalytics=true`, `dashboardHasRationaleAnalytics=true`
- 인게임 설문 검증: `jsonHasRatings=true`, `jsonHasFlags=true`, `markdownHasSurvey=true`, `filesHaveNoLocalAbsolutePath=true`, `closeReturnsReport=true`
- 플레이테스트 회수 준비 검증: `beforeShowsMissingFiles=true`, `afterReadyForCollection=true`, `hasMinimumDecisionCount=true`, `hasSurveyFiles=true`, `hasPlaytestPacketFiles=true`, `hasDiagnosticFiles=true`, `filesHaveNoLocalAbsolutePath=true`
- 환경 진단 검증: `jsonHasSystem=true`, `jsonHasSettings=true`, `jsonHasFrameSample=true`, `markdownHasSummary=true`, `filesHaveNoLocalAbsolutePath=true`
- 런타임 이슈 로그 검증: `completed=true`, `hasJson=true`, `hasMarkdown=true`, `messageSanitized=true`, `stackSanitized=true`, `supportBundleHasRuntimeIssues=true`, `filesHaveNoLocalAbsolutePath=true`
- 컨트롤러 단축 입력 검증: `completed=true`, `settingsMentionsController=true`, `guideMentionsDecisionSet=true`, `submitPathCreatesDecision=true`, `nextPathAvailable=true`, `filesHaveNoLocalAbsolutePath=true`
- 컨트롤러 포커스 이동 검증: `completed=true`, `settingsHasSelection=true`, `menuHasSelection=true`, `reviewHasSelection=true`, `overlayHasSelection=true`, `achievementRecordLinkHintMentionsCoachingFirstUse=true`, `achievementCoachingRecordButtonOpensCareerRecord=true`, `caseArchiveDecisionAuditCoachingButtonFocusable=true`, `caseArchiveDecisionAuditCoachingButtonOpensFirstUseCase=true`, `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`, `selectionStaysInsideActiveRoot=true`, `filesHaveNoLocalAbsolutePath=true`
- 지원 번들 검증: `completed=true`, `hasPlayLog=true`, `hasSummary=true`, `hasDashboard=true`, `hasDiagnostic=true`, `hasSurvey=true`, `hasRuntimeIssues=true`, `filesHaveNoLocalAbsolutePath=true`, `manifestHasNoLocalAbsolutePath=true`
- 로컬 데이터 삭제 검증: `completed=true`, `confirmationArmed=true`, `managedFilesDeleted=true`, `managedDirectoriesDeleted=true`, `unrelatedFilePreserved=true`, `filesHaveNoLocalAbsolutePath=true`
- 첫 실행 고지 검증: `completed=true`, `noticeActiveBeforeAccept=true`, `preferenceSaved=true`, `noticeHiddenAfterAccept=true`, `menuVisibleAfterAccept=true`, `mentionsNoAutomaticUpload=true`, `mentionsLocalDataDelete=true`, `mentionsNotAdvice=true`
- 상용 콘텐츠 감사 검증: `completed=true`, `caseCount=40`, `highestDay=5`, `daysWithEightCases=5`, `familyTypeCount=40`, `recommendedDecisionTypeCount=5`, `passesCommercialContentGate=true`
- 데이터 소스 무결성 검증: `completed=true`, `caseFileCount=5`, `externalCaseCount=40`, `runtimeCaseCount=40`, `personaCount=10`, `casesLoadedFromExternalJson=true`, `embeddedFallbackUsed=false`, `passesDataSourceGate=true`, `filesHaveNoLocalAbsolutePath=true`
- 경로 검증 결과: 피드백 Markdown, 세션 요약 JSON, HTML 대시보드, 플레이 로그 CSV/JSON, 집계 CSV/JSON/Markdown 모두 로컬 사용자 절대경로 미포함
- 회수 감사 검증: `auditCompleted=true`, `supportBundleSessionCount=2`, `supportBundleManifestCount=2`, `supportBundleRuntimeIssueCount=1`, `externalCompleteSessionCount=0`, 현재 실제 사람 완전 회수 0건으로 판매 후보 판단 보류
- 상용화 트리아지 검증: `completed=true`, `hasTriageOutputs=true`, `hasSurfaceActionChecklistCsv=true`, `hasReadinessStatus=true`, 현재 실제 사람 완전 회수 0건으로 판매 후보 판단 보류

## 해석 기준

- `recommendedMatchRatePercent`가 높아도 좋은 밸런스를 뜻하지 않는다. 테스터가 권장 경로를 쉽게 추측했는지, 다른 선택의 결과가 납득됐는지 설문과 함께 본다.
- `balanceRiskFocus`는 다음 조정 우선순위를 빠르게 잡기 위한 태그다.
- `sessionId`는 테스터의 실명이나 연락처를 대체하는 익명 회차 식별자다. 설문과 CSV/JSON/HTML을 묶을 때 이 값을 기준으로 맞춘다.
- `decisionAuditDays`와 `decisionAuditCases`는 발표용 대시보드에서 일차별 압박 변화와 대표 재검토 사례를 설명할 때 쓴다.
- `campaignScore`, `campaignGrade`, `campaignBadge`, `campaignGradeReason`은 한 회차의 예산 관리, 안정/형평 유지, 위험 방어, 민원 억제, 권장 판단 일치율을 압축한 비교 지표로 쓴다.
- `campaignChallengeId`, `campaignChallengeSucceeded`, `campaignChallengeProgress`는 운영 기준별 반복 플레이 목표가 실제로 달성됐는지 비교할 때 쓴다.
- `nextCampaignMandateId`, `nextCampaignChallenge`, `nextCampaignReason`은 다음 회차 목표를 설명하거나, 플레이테스터별 반복 플레이 유도 문구를 비교할 때 쓴다.
- `care_review_in_game_feedback.json`의 5점 척도와 빠른 체크는 회차 직후 반응을 구조화해 CSV/JSON 판단 로그와 함께 비교할 때 쓴다.
- 게임 안 `테스터 설문` 화면의 `회수 준비` 줄은 35건 이상 판단, 설문, 로그 패킷, 환경 진단, 경로 비식별화가 모두 갖춰졌는지 테스터와 회수 담당자가 즉시 확인할 때 쓴다.
- `care_review_system_diagnostic.json`은 외부 저사양 PC 검증을 완전히 대체하지는 않지만, 테스터별 CPU/GPU/RAM, 화면 설정, FPS p95를 회수해 문제 환경을 좁히는 데 쓴다.
- `care_review_support_bundle_manifest.json`은 문제 제보를 받을 때 세션 원본, 설문, 환경 진단, 저장 파일이 한 번에 들어왔는지 확인하는 데 쓴다.
- 회수 감사의 `receivedViaSupportBundle`, `hasSupportBundleManifest`, `supportBundleHasRuntimeIssues`는 문제 제보용 번들이 분석 가능한 세션으로 들어왔는지 판단할 때 쓴다.
- 10달러 상품성 판단은 `10달러 구매 의향`, `반복 보상/장기 기록 가치감`, `UI 가독성`, `최종 엔딩 납득도`, `더 보고 싶은 사례 유형` 응답을 함께 본다.
- `care_review_playtest_commercial_triage.md`는 회수된 설문을 10달러 판매 후보 관점으로 집계해 우선 조치 목록과 담당 화면별 체크리스트를 만든다.
- `care_review_playtest_commercial_triage_actions.csv`는 같은 조치 목록을 `priority,area,owner_screen,evidence,recommendation` 열로 내보내 QA/작업표에 붙일 때 쓴다.

## 개인정보 주의

테스터에게 실제 가족 사정, 실제 행정 경험, 실명, 연락처, 민감 정보를 설문에 적지 않도록 안내한다. 피드백은 게임 경험과 판단 기준에 한정해서 받는다.











