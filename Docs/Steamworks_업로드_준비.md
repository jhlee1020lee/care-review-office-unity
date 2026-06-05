# 돌봄지원 심사소 Steamworks 업로드 준비

작성일: 2026-05-28
대상 버전: v0.3.0

## 현재 준비된 산출물

- 로컬 depot 루트: `Builds/Steamworks/v0.3.0/content_windows`
- SteamPipe 스크립트: `Builds/Steamworks/v0.3.0/scripts`
- 상점 페이지 메타데이터: `Builds/Steamworks/v0.3.0/store_page`
- 업로드 manifest: `Builds/Steamworks/v0.3.0/STEAMWORKS_UPLOAD_MANIFEST.txt`
- Steam 제출 전 자체점검 보고서: `Builds/Steamworks/v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`
- 릴리즈 후보 감사 리포트: `Builds/QA/v0.3.0/release_candidate/care_review_release_candidate_audit.md`
- 배포 패킷 무결성 감사 리포트: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.md`
- 외부 게이트 증거 감사 리포트: `Builds/QA/v0.3.0/external_gate_audit/care_review_external_gate_audit.md`
- 외부 검증 핸드오프: `Builds/Handoff/v0.3.0`
- 외부 검증 증거 노트: `Builds/Handoff/v0.3.0/Evidence`
- 백업 zip: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`
- 백업 zip 크기: 81,769,470 bytes
- 백업 zip SHA256: `6C4BAA9C124BC4A42E1A86AFF6CD48AE6F21D9CEDFA863DB18469821E75D0CCF`
- Store Presence QA 카드 우선순위 배지 회수 컬럼: `triage_priority_badge_id`, `triage_priority_badge_status`, `triage_priority_badge_evidence`
- 외부 검증 핸드오프 zip: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`
- 외부 검증 핸드오프 zip 크기: 35,500 bytes
- 외부 검증 핸드오프 zip SHA256: `AC97C36D34323D90DC51390F081F3C8CD8489A88F99C21689D419305DBD8AB05`
- 외부 handoff Store Presence 증거 묶음 우선순위 배지 회수 컬럼: `triage_priority_badge_id`, `triage_priority_badge_status`, `triage_priority_badge_evidence`, `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`
- 외부 handoff action CSV 우선순위 배지 owner_screen 행: `우선순위 배지: 상점 후보 루프 이해`, `우선순위 배지: 메인 메뉴 기준 화면`, `우선순위 배지: 성과-캠페인 문구 일치`
- Steamworks upload manifest priority badge memberSummary 요약: `priority_badges=store_presence_priority_badge_backreference`, `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`
- Store Presence QA 카드 우선순위 배지 회수 후 처리 상태: `after_collection_status`, `manual_update_target`, `completion_gate`
- Store Presence 증거 초안 우선순위 배지 회수 후 입력란: `store_presence_priority_badge_after_collection_input`, `after_collection_status_reward_loop_candidate`, `completion_gate_main_menu_baseline`
- HUMAN_10 action CSV 우선순위 배지 owner_screen tracker 힌트: `action_csv_priority_badge_owner_screen`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`
- 외부 게이트 감사 HUMAN_10 우선순위 배지 owner_screen 별도 필드: `priority_badge_owner_screen_summary`, `priorityBadgeOwnerScreenSummary`, `action_csv_priority_badge_owner_screen`
- Paperlogy 폰트 커버리지: `Paperlogy-6SemiBold`, `paperlogyFontApplied=true`, `paperlogyTextFontCoverageApplied=true`, `paperlogyTextMismatchCount=0`
- Paperlogy upload manifest evidence: `font=Paperlogy-6SemiBold`, `runtime_qa=care_review_ui_cleanup_smoke_result.json`, `license=Docs/THIRD_PARTY_FONTS.md`
- Steam 제출 프리플라이트 Paperlogy manifest evidence 역참조: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `Paperlogy font evidence`, `content_windows/RELEASE_MANIFEST.txt`, `content_windows/README_KR.txt`, `Docs/THIRD_PARTY_FONTS.md`
- Store Presence tracker 우선순위 배지 회수 후 입력란 힌트: `after_collection_inputs=store_presence_priority_badge_after_collection_input`, `after_collection_status_reward_loop_candidate`, `completion_gate_main_menu_baseline`, `completion_gate_copy_alignment`
- 외부 게이트 감사 Store Presence after_collection_inputs 별도 필드: `store_presence_after_collection_input_summary`, `storePresenceAfterCollectionInputSummary`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`
- 릴리즈 후보 감사 노트 Store Presence after_collection 입력란: `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `storePresenceAfterCollectionInputSummary`, `store_presence_after_collection_input_summary`, `after_collection_status_reward_loop_candidate`
- 외부 게이트 smoke Handoff zip SHA 상호참조: `handoffZipSha256`, `handoffZipBytes`, `handoffZipHashFileMatches=true`
- 외부 게이트 smoke handoffZipSha256 사람용 감사 항목: `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256=AC97C36D34323D90DC51390F081F3C8CD8489A88F99C21689D419305DBD8AB05`, `handoffZipBytes=35500`, `handoffZipHashFileMatches=true`
- 외부 게이트 smoke Steamworks zip SHA 사람용 감사 항목: `care_review_external_gate_audit_smoke_result.json`, `steamworksZipSha256=6C4BAA9C124BC4A42E1A86AFF6CD48AE6F21D9CEDFA863DB18469821E75D0CCF`, `steamworksZipBytes=81769470`, `steamworksZipHashFileMatches=true`
- README 첫 섹션 smoke zip SHA 요약 사람용 감사 항목: `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `외부 게이트 smoke zip SHA`, `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256=AC97C36D34323D90DC51390F081F3C8CD8489A88F99C21689D419305DBD8AB05`, `handoffZipBytes=35500`, `steamworksZipSha256=6C4BAA9C124BC4A42E1A86AFF6CD48AE6F21D9CEDFA863DB18469821E75D0CCF`, `steamworksZipBytes=81769470`

`content_windows` 바로 아래에 `CareReviewOffice.exe`, `CareReviewOffice_Data`, `UnityPlayer.dll`, `MonoBleedingEdge`가 놓이도록 구성했다. 이 구조를 Windows depot의 content root로 사용한다.

## 생성된 SteamPipe 템플릿

- `scripts/app_build_000000.vdf`
- `scripts/depot_build_000001.vdf`
- `scripts/configure_steamworks_ids.ps1`
- `scripts/upload_preview_steamcmd.ps1`
- `store_page/STORE_PAGE_METADATA_KO.md`
- `store_page/ASSET_UPLOAD_MAP.md`
- `store_page/PRIVACY_AND_DATA_NOTICE_KO.md`
- `store_page/ACHIEVEMENT_CANDIDATES_KO.md`
- `store_page/ACHIEVEMENT_CANDIDATES.csv`
- `STEAM_SUBMISSION_PREFLIGHT_KO.md`
- `EXTERNAL_RELEASE_HANDOFF_KO.md`
- `EXTERNAL_RELEASE_GATE_TRACKER.csv`
- `Evidence/README_KO.md`
- `Evidence/_templates/<GATE_ID>.md`
- `TESTER_RECRUITMENT_BATCH_KO.md`
- `LOW_SPEC_PC_QA_CARD_KO.md`
- `STEAM_PRIVATE_BRANCH_QA_CARD_KO.md`

현재 AppID와 DepotID는 placeholder다. 실제 Steamworks 앱을 만들면 다음 값을 교체해야 한다.

- `000000`: 실제 Steam App ID
- `000001`: 실제 Windows Depot ID
- `STEAM_USERNAME`: 업로드 권한이 있는 Steamworks 계정

처음에는 `Preview` 값을 `1`로 둔 채 SteamCMD에서 빌드 검증만 수행한다. 실제 업로드 직전 `Preview`를 `0`으로 바꾸고, `SetLive`는 비워둔 채 Steamworks 웹에서 비공개 브랜치로 배포하는 방식을 우선한다.

## Store Presence Draft 독립 체크

- [x] 증거 묶음 준비: `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `checkCount=11`, `passedCheckCount=11`, `allPassed=true`
- [ ] 실제 입력 증거: `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`
- [x] 예시와 초안 구분: `Evidence/STORE_PRESENCE_EXAMPLE.md`, `status: example_not_evidence`
- [x] 외부 게이트 row 연결: `storePresenceDraftStatusSummary`, `store_presence_draft_status_summary`, `actual_status=pending_external`
- [x] 제출 전 자체점검 연결: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `Store Presence 외부 액션 연결`, `externalActionCount=10`
- [x] A/B 응답 회수 보류: `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=221`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`, `screenshot_ab_loop_understanding_comment_count=0`
- [x] 브리핑 회고 후보 입력란: `Evidence/STORE_PRESENCE.md`, `briefing_retrospective_candidate_evidence`, `briefing_retrospective_candidate_file`, `briefing_retrospective_candidate_terms`, `briefing_retrospective_candidate_smoke`, `storeCandidateMentionsBriefingRetrospective=true`, `12_career_record_next_objective.png`
- [x] 결정 감사 코칭 보조 후보: `14_case_archive_decision_audit_coaching_focus.png`, `코칭 W-207`, `decision_audit_coaching_candidate_evidence`, `caseArchiveDecisionAuditCoachingButtonOpensFirstUseCase=true`, `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`
- [x] 실제 증거 초안 14번 후보 입력란: `Evidence/STORE_PRESENCE.md`, `decision_audit_coaching_candidate_file`, `decision_audit_coaching_candidate_case`, `decision_audit_coaching_candidate_round_trip`
- [x] 작성 완료 전 자체점검 표: `STORE_PRESENCE_QA_CARD_KO.md`, `Evidence/README_KO.md`, `Steamworks URL/화면 캡처`, `SHA 확인`, `14번 코칭 후보`, `토스트 UI 캡처`, `A/B 응답 회수`
- [x] 실제 증거 초안 자체점검 TODO: `Evidence/STORE_PRESENCE.md`, `작성 완료 전 자체점검 TODO`, `[ ] Steamworks URL/화면 캡처`, `[ ] SHA 확인`, `[ ] 14번 코칭 후보`, `[ ] 브리핑 회고 후보`, `[ ] A/B 응답 회수`
- [x] STORE_PRESENCE.md 통과 전 TODO 요약: `Evidence/STORE_PRESENCE.md`, `통과 전 확인`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] STORE_PRESENCE_EXAMPLE.md TODO 예시 요약: `Evidence/STORE_PRESENCE_EXAMPLE.md`, `작성 순서`, `자체점검 TODO 요약 예시`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] STORE_PRESENCE 템플릿 TODO 요약: `Evidence/_templates/STORE_PRESENCE.md`, `후보 스크린샷 A/B 판정`, `자체점검 TODO 요약 템플릿`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] tracker/README 자체점검 TODO 요약: `EXTERNAL_RELEASE_GATE_TRACKER.csv`, `README_STEAMWORKS_KR.txt`, `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|브리핑 회고 후보|A/B 응답 회수`
- [x] Steamworks README 첫 섹션 TODO 요약: `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `제출 전 TODO 첫 확인`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] Steamworks README 감사 노트 템플릿 TODO 역참조: `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `감사 노트 템플릿 TODO 역참조`, `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`
- [x] handoff README 첫 확인 TODO 요약: `README_KO.txt`, `첫 확인 항목`, `handoff TODO 첫 확인`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] handoff 문서 최상단 TODO 요약: `EXTERNAL_RELEASE_HANDOFF_KO.md`, `Store Presence 증거 초안 상태`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] QA 카드 첫 섹션 TODO 요약: `STORE_PRESENCE_QA_CARD_KO.md`, `준비`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] Evidence README 첫 섹션 TODO 요약: `Evidence/README_KO.md`, `Store Presence 증거 작성`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] 제출 전 자체점검 TODO 요약: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `외부 검증 Store Presence 자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] 최상단 판정 요약 TODO 요약: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `최상단 판정 요약`, `Store Presence 자체점검 TODO 요약`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|브리핑 회고 후보|A/B 응답 회수`
- [x] 릴리즈 감사 노트 TODO 요약: `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `care_review_release_candidate_audit.md`, `자체점검 TODO 요약`, `completion_todo=작성 완료 전 자체점검 TODO`
- [x] 감사 노트 템플릿 TODO 역참조: `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`, `자체점검 TODO 요약 템플릿`
- [x] upload manifest TODO 요약: `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence draft`, `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|브리핑 회고 후보|A/B 응답 회수`
- [x] upload manifest 감사 노트 템플릿 TODO 역참조: `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence draft`, `README_STEAMWORKS_KR.txt 감사 노트 템플릿 TODO 역참조`, `STEAM_SUBMISSION_PREFLIGHT_KO.md 외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`
- [x] 결정 감사 코칭 패턴 분포 Store/QA handoff: `Builds/Handoff/v0.3.0/STORE_PRESENCE_QA_CARD_KO.md`, `Builds/Handoff/v0.3.0/EXTERNAL_RELEASE_HANDOFF_KO.md`, `decisionAuditCoachingSessionCount=10/221`, `decisionAuditCoachingPatternCounts=고비용 지원`, `decisionAuditCoachingMandateCounts=긴축 감사`
- [x] upload manifest memberSummary 상호참조: `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence upload doc cross-check`, `Store Presence evidence draft`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`
- [x] 플레이테스트 QA 패킷 상호참조: `Docs/플레이테스트_QA_패킷.md`, `Store Presence Draft 독립 체크`, `플레이테스트 회수 자료와 Store Presence 실제 입력 증거를 분리`
- 실제 Steamworks URL/화면 캡처와 A/B 응답 회수 수치를 `Evidence/STORE_PRESENCE.md`에 채우기 전까지 `STORE_PRESENCE` 외부 게이트는 `pending_external`로 유지한다.
- [x] 최신 Store Presence 브리핑 회고 후보 입력란 감사: `Logs/audit_release_candidate_store_presence_briefing_retrospective_fields_final_pass.log` 257/257 통과, `Logs/audit_distribution_integrity_store_presence_briefing_retrospective_fields_final.log` 120/120 통과, handoff SHA256 `F19F961BE1EA901094992F044BB99212B46967C7198E8D9DD3CE475E031C29A3`

## 검증 결과

- depot content 실행 파일 직접 스모크 테스트 통과
- 로그: `Logs/runtime_smoke_steamworks_campaign_challenge_v030.log`
- 결과: `completed=true`, `caseCount=40`, `logCount=40`, 운영 기준 `균형 심사`, 최종 엔딩 `불 켜진 창`
- 메인 메뉴 운영 기준 검증: `Logs/runtime_main_menu_mandate_campaign_challenge_v030.log`, `Builds/QA/v0.3.0/care_review_main_menu_mandate_smoke_result.json`, 현재 기준 카드/시작 예산/캠페인 챌린지/D 키 안내/기준 변경 저장 확인
- 운영 기준 시작 브리핑 검증: `Logs/runtime_campaign_mandate_briefing_campaign_challenge_v030.log`, `Builds/QA/v0.3.0/care_review_campaign_mandate_briefing_smoke_result.json`, 긴축 감사 명칭/시작 예산 950만원/캠페인 챌린지/고난도 안내/기존 튜토리얼 연결 확인
- 인게임 플레이테스트 설문 검증: `Logs/runtime_playtest_survey_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_playtest_survey_smoke_result.json`, `Builds/QA/v0.3.0/care_review_in_game_feedback_sample.json`, `Builds/QA/v0.3.0/care_review_in_game_feedback_sample.md`, 5점 척도/빠른 체크/JSON/Markdown 저장/로컬 사용자 절대경로 미포함/리포트 복귀 확인
- 성과 기록 검증: `Logs/runtime_achievement_growth_catalog.log`, `Builds/QA/v0.3.0/achievements`, 12개 Steam 업적 후보, 성장 목표/성장 후속 후보 포함, 성과 기록 화면과 해금 토스트 캡처 생성
- 캠페인 기록 검증: `Logs/runtime_career_record_campaign_challenge_v030.log`, `Builds/QA/v0.3.0/care_review_career_record_smoke_result.json`, 완료 회차 1건, 등급/엔딩/캠페인 챌린지/다음 목표 저장, 캠페인 기록 화면 캡처 생성
- 세이브 슬롯 삭제 검증: `Logs/runtime_save_slot_delete_v030.log`, `Builds/QA/v0.3.0/care_review_save_slot_delete_smoke_result.json`, 슬롯 3 임시 저장 생성/2단계 확인/삭제/기존 저장 복구 흐름 확인
- 저장 백업/복구 검증: `Logs/runtime_save_recovery_v030.log`, `Builds/QA/v0.3.0/care_review_save_recovery_smoke_result.json`, 손상된 기본 저장을 `.bak` 백업에서 복구, 기본 저장 복원, 로컬 절대경로 미포함 확인
- 로컬 데이터 삭제 검증: `Logs/runtime_local_data_delete_v030.log`, `Builds/QA/v0.3.0/care_review_local_data_delete_smoke_result.json`, 2단계 확인/게임 생성 파일과 폴더 삭제/무관 파일 보존/로컬 절대경로 미포함 확인
- 키아트 톤 통일 검증: `Assets/Resources/Art/menu_keyart_background.png`, `Builds/Marketing/v0.3.0/screenshots/01_main_menu.png`, `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_menu_keyart.png`
- 저해상도 메뉴/리포트 재검증: `Logs/runtime_low_resolution_recommended_replay_final_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`, 1280x720/1600x900/1920x1080 기준 27장 그래픽 캡처 생성, 심사 기록과 결정 감사 화면 포함
- Steam 업적 후보 자료: `store_page/ACHIEVEMENT_CANDIDATES_KO.md`, `store_page/ACHIEVEMENT_CANDIDATES.csv`
- Steam 제출 전 자체점검 보고서: `STEAM_SUBMISSION_PREFLIGHT_KO.md`, 로컬 산출물 통과 항목과 실제 Steamworks/AppID/외부 QA 필요 항목 분리
- JSON 로그 검증: `campaignMandateId`, `endingEpilogue`, `endingLesson` 필드 포함
- 엔딩 기록 검증: `Logs/runtime_ending_gallery_mandate_records.log`, `mandateDiscoveredCount=1`, `recommendedEndingDiscoveredForCurrentMandate=true`
- 오디오 검증: `Logs/runtime_audio_smoke_performance_options.log`, 사건 알림음 3종 샘플 생성 확인
- WAV 오디오 자산 검증: `Assets/Resources/Audio/Bgm` 5곡, `Assets/Resources/Audio/Sfx` 20종, `Tools/generate_care_review_audio.py`, `Logs/runtime_audio_smoke_wav_assets_player.log`, `Builds/QA/v0.3.0/care_review_audio_smoke_result.json`, `loadedBgmCount=5`, `loadedSfxCount=20`, `screenBgmKeysExpected=true`, `zeroVolumeSfxPlayed=false`, `zeroVolumeMusicMuted=true`
- WAV 오디오 회귀 검증: `Logs/runtime_smoke_wav_audio_assets_player.log`, `completed=true`, `caseCount=40`, `logCount=40`, `currentIndex=40`; `Logs/runtime_low_resolution_wav_audio_assets_player.log`, `completed=true`, `screenshotCount=42`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`
- 저해상도 UI 검증: `Logs/runtime_low_resolution_recommended_replay_final_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui`, 1280x720/1600x900/1920x1080 기준 27장 그래픽 캡처와 JSON 결과 생성, 심사 기록과 결정 감사 화면 포함
- UI 밀도 재검증: `Logs/runtime_low_resolution_ui_density_v030.log`, `Builds/QA/v0.3.0/ui_density`, 사례 압박 요약 패널 추가 후 18장 저해상도 캡처와 상점 스크린샷 재생성
- 최종 리포트 게이지 재검증: `Logs/runtime_low_resolution_report_gauges_v030.log`, `Builds/QA/v0.3.0/report_gauges`, 게이지 대시보드 추가 후 18장 저해상도 캡처와 상점 스크린샷 재생성
- 가족 유형 판단 지도 재검증: `Logs/runtime_low_resolution_player_decision_map_groups_v030.log`, `Builds/QA/v0.3.0/player_decision_map`, 최종 리포트에 사례 그룹별 지원율/일치율 막대와 재검토 큐 표시
- HTML 분석 대시보드 검증: `Logs/runtime_playtest_packet_steamworks_campaign_grade_v030.log`, `Builds/QA/v0.3.0/playtest_packet`, `care_review_analytics_dashboard.html` 생성과 운영 등급/가족 유형 판단 지도/결정 감사/다음 캠페인 목표 문구 검증
- 에이전트 비교 대시보드 재검증: `Builds/QA/v0.3.0/agent_dashboard`, 5개 가상 플레이어 성향의 지원/조사/일치율 비교 화면, 7번째 상점 스크린샷과 저해상도 캡처 생성
- 심사 기록 오버레이 검증: `Logs/runtime_decision_history_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_decision_history_smoke_result.json`, 빈 상태/판단 후 상태/닫기 흐름 확인
- 후속 연락함 검증: `Logs/runtime_follow_up_inbox_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_follow_up_inbox_smoke_result.json`, 빈 상태/판단 후 연락·영향·우선 확인/닫기 흐름 확인
- 판단 근거 검증: `Logs/runtime_decision_rationale_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_decision_rationale_smoke_result.json`, 버튼/지표/로그/CSV/심사 기록/후속 연락함 반영 확인
- 판단 근거 분석 검증: `Logs/runtime_rationale_analytics_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_decision_rationale_analytics_smoke_result.json`, 최종 리포트/세션 요약 JSON/HTML 분석 대시보드의 근거 분포 확인
- 권장 판단 비교 피드백 검증: `Logs/runtime_decision_comparison_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_decision_comparison_smoke_result.json`, 선택 판단과 권장 판단의 예산·안정·위험 차이 표시 확인
- 선택지 미리보기 검증: `Logs/runtime_decision_preview_v030.log`, `Builds/QA/v0.3.0/care_review_decision_preview_smoke_result.json`, 다섯 판단의 즉시 예산/위험 변화와 권장 판단 하이라이트 확인
- 심사 기준표 검증: `Logs/runtime_policy_handbook_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_policy_handbook_smoke_result.json`, 현재 사례 근거/권장 판단/판단별 예상 변화 확인
- 운영 등급 검증: `Logs/runtime_campaign_grade_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_campaign_grade_smoke_result.json`, 최종 리포트 등급 카드/점수 범위/요약 반영 확인
- 캠페인 챌린지 검증: `Logs/runtime_campaign_challenge_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_campaign_challenge_smoke_result.json`, 메인 메뉴 카드/최종 리포트/로그 JSON/세션 요약/HTML 대시보드에 챌린지 성공 여부와 진행 지표 반영 확인
- 사례 자료실 검증: `Logs/runtime_case_archive_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_case_archive_smoke_result.json`, 전체 사례 수/쪽 이동/필터 큐 전환/사례 상세/메인 메뉴 복귀 확인
- 결정 감사 대시보드 검증: `Logs/runtime_decision_audit_steamworks_exports_v030.log`, `Builds/QA/v0.3.0/care_review_decision_audit_smoke_result.json`, 5일차 행/지출·위험·일치 막대/고압력 대표 사례 큐 생성
- 저사양 성능 검증: `Logs/runtime_performance_smoke_steamworks_content.log`, `Builds/QA/v0.3.0/performance`, 1280x720 저사양 모드 6개 주요 화면 p95 프레임 시간 약 33.65-33.73ms
- 플레이테스트 패킷 검증: `Logs/runtime_playtest_packet_review_queue_v030.log`, `Builds/QA/v0.3.0/playtest_packet`, 익명 세션 ID/플레이 시간/판단 경과 시간이 포함된 플레이 로그, 사건 로그, 세션 요약, 설문 Markdown, 운영 등급/캠페인 챌린지/재검토 큐/결정 감사/다음 캠페인 목표 JSON/Markdown/HTML export 생성 및 로컬 사용자 절대경로 미포함 확인
- 플레이테스트 세션별 원본 보관: `Builds/QA/v0.3.0/playtest_packet/playtest_sessions/<sessionId>`, 실제 수집 시 `playtest_sessions/<sessionId>` 폴더 단위로 회수
- 플레이테스트 세션 집계 검증: `Logs/runtime_playtest_aggregate_campaign_challenge_v030.log`, `Logs/runtime_playtest_aggregate_decision_audit_coaching_pattern.log`, `care_review_playtest_sessions_index.csv`, `care_review_playtest_aggregate.json`, `care_review_playtest_aggregate.md`, 여러 회차의 운영 기준/엔딩/평균 지표/평균 운영 점수/캠페인 챌린지 성공률/다음 캠페인 목표/최다 판단 근거/결정 감사 코칭 패턴 분포/상점 후보 A/B 루프 질문 컬럼 집계 생성 및 로컬 사용자 절대경로 미포함 확인
- 플레이테스트 설문 집계 검증: `Logs/runtime_playtest_aggregate_survey_value_retry_v030.log`, `Builds/QA/v0.3.0/playtest_packet/care_review_playtest_aggregate_smoke_result.json`, 세션별 `price_value_rating`/`replay_intent` CSV 컬럼과 평균 10달러 가치감/재플레이 의향 Markdown 요약 확인
- 추천 심사 재시작 검증: `Logs/runtime_recommended_replay_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_recommended_replay_smoke_result.json`, 추천 버튼 문구/운영 기준 적용/예산 초기화/튜토리얼 복귀 확인
- 플레이테스트 회수 준비 검증: `Logs/runtime_playtest_readiness_v030.log`, `Builds/QA/v0.3.0/care_review_playtest_readiness_smoke_result.json`, 판단 35건 이상/인게임 설문/로그 패킷/환경 진단/로컬 절대경로 미포함 기준을 게임 안 `회수 준비: 회수 완료` 상태로 확인
- 환경 진단 export 검증: `Logs/runtime_system_diagnostic_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_system_diagnostic_smoke_result.json`, CPU/GPU/RAM, 화면 설정, FPS 샘플 JSON/Markdown 생성 및 로컬 사용자 절대경로 미포함 확인
- 런타임 이슈 로그 검증: `Logs/runtime_issue_log_v030.log`, `Builds/QA/v0.3.0/care_review_runtime_issue_smoke_result.json`, Warning/Error/Exception JSON/Markdown 기록, 메시지/스택 로컬 절대경로 익명화, 지원 번들 포함 확인
- 컨트롤러 단축 입력 검증: `Logs/runtime_controller_shortcut_v030.log`, `Builds/QA/v0.3.0/care_review_controller_shortcut_smoke_result.json`, 설정 화면 컨트롤러 안내, A/B/X/Y/LB/RB/View/Menu 기본 매핑, 승인 판단 경로와 다음 버튼 상태 확인
- 컨트롤러 포커스 이동 검증: `Logs/runtime_focus_coaching_first_use_round_trip.log`, `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, 설정/메뉴/심사/심사 기록 오버레이 기본 선택, 선택 외곽선, 활성 루트 내부 포커스 유지, 성과 기록 `코칭 W-207 첫 안내`, 사례 자료실 코칭 버튼, 첫 사용 안내 진입, 기록 복귀 확인
- 성과 반복 단계 버튼 포커스 검증: `Logs/runtime_focus_navigation_tier_record_buttons.log`, `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `achievementTierRecordButtonsFocusable=true`, `achievementTierRecordSelectionIsTierButton=true`
- 엔딩 기록/캠페인 기록 필터 포커스 검증: `Logs/runtime_focus_navigation_ending_career_filters.log`, `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `endingGalleryRecordButtonsFocusable=true`, `endingGalleryRecordSelectionIsRecordButton=true`, `careerRecordMandateFilterButtonsFocusable=true`, `careerRecordMandateFilterSelectionIsFilterButton=true`
- 후속 연락함/사례 자료실 포커스 검증: `Logs/runtime_focus_navigation_inbox_archive_filters.log`, `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `followUpInboxActionButtonsFocusable=true`, `followUpInboxSelectionIsActionButton=true`, `caseArchiveNavigationButtonsFocusable=true`, `caseArchiveSelectionIsNavigationButton=true`
- 플레이테스트 설문/지원 번들 포커스 검증: `Logs/runtime_focus_navigation_survey_support_bundle.log`, `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `settingsSupportBundleButtonFocusable=true`, `playtestSurveyRatingButtonFocusCount=12`, `playtestSurveyFlagButtonFocusCount=4`, `playtestSurveyActionButtonFocusCount=3`
- 지원 번들 export 검증: `Logs/runtime_support_bundle_v030.log`, `Builds/QA/v0.3.0/support_bundle/care_review_support_bundle_smoke_result.json`, 최신 로그/세션 원본/설문/환경 진단/저장 파일/런타임 이슈 로그/manifest 31개 파일 묶음 생성 및 로컬 사용자 절대경로 미포함 확인
- 상용 콘텐츠 감사 검증: `Logs/runtime_content_audit_v030.log`, `Builds/QA/v0.3.0/content_audit/care_review_content_audit_smoke_result.json`, 5일차 40개 사례/권장 판단 5종/후속 메모/엔딩 태그/비용·위험·서류 범위 CSV·JSON·Markdown 감사 통과
- 데이터 소스 무결성 검증: `Logs/runtime_data_source_integrity_v030.log`, `Builds/QA/v0.3.0/care_review_data_source_smoke_result.json`, `Builds/QA/v0.3.0/care_review_data_source_audit.md`, cases_day1~5 JSON 5개/외부 사례 40건/런타임 사례 40건/agent_personas 5개/fallback 미사용/로컬 절대경로 미포함 확인
- 개인정보/데이터 처리 고지: `Builds/Steamworks/v0.3.0/store_page/PRIVACY_AND_DATA_NOTICE_KO.md`, 실제 개인정보 미수집, 로컬 로그, 환경 진단, 지원 번들, 실제 판단 비대체 고지 포함
- 첫 실행 고지 검증: `Logs/runtime_first_run_notice_v030.log`, `Builds/QA/v0.3.0/care_review_first_run_notice_smoke_result.json`, 최초 실행 시 합성 사례/실제 개인정보 미사용/로컬 저장/자동 업로드 없음/지원 번들/로컬 데이터 삭제/실제 판단 비대체 고지 표시와 확인 저장/메뉴 복귀 확인
- 인게임 데이터 처리 고지 검증: `Logs/runtime_credits_privacy_notice_pathsafe_v030.log`, `Builds/QA/v0.3.0/care_review_credits_smoke_result.json`, 로컬 저장/서버 자동 업로드 없음/환경 진단/지원 번들 고지와 로컬 절대경로 미포함 확인
- 로컬 데이터 삭제 QA: `Builds/QA/v0.3.0/care_review_local_data_delete_smoke_result.json`, `completed=true`, `confirmationArmed=true`, `managedFilesDeleted=true`, `managedDirectoriesDeleted=true`, `unrelatedFilePreserved=true`, `filesHaveNoLocalAbsolutePath=true`
- 플레이테스트 회수 감사 도구: `Logs/audit_playtest_collection_support_bundle_v030.log`, `Builds/QA/v0.3.0/playtest_collection_audit`, 외부 회수 inbox, QA 샘플 세션, QA 지원 번들의 필수 파일/설문/환경 진단/지원 번들 manifest/런타임 이슈 로그/로컬 절대경로 노출 여부 점검, 10달러 상용화 트리아지 리포트 생성. 현재 `sessionCount=77`, `supportBundleSessionCount=2`, `supportBundleManifestCount=2`, `supportBundleRuntimeIssueCount=1`, `externalCompleteSessionCount=0`
- 반복 가치감 상용화 트리아지 우선순위: `Logs/audit_playtest_collection_replay_value_triage.log`, `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_smoke_result.json`, `averageReplayRewardValueRating=3.0`, `hasReplayRewardValuePriority=true`, `actionCount=7`
- 트리아지 담당 화면 CSV: `Logs/audit_playtest_collection_surface_action_csv.log`, `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_actions.csv`, `hasSurfaceActionChecklistCsv=true`, `owner_screen`, `성과 기록 / 캠페인 기록 / 상점 페이지`
- 지원 번들 handoff SHA 회수 감사 열: `Logs/audit_playtest_collection_handoff_sha_columns_final.log`, `care_review_playtest_collection_audit.csv`의 `support_bundle_external_handoff_zip_sha256`, `care_review_playtest_commercial_triage_actions.csv`의 `support_bundle_manifest_handoff_zip_sha256`, `hasHandoffShaInActionCsv=true`
- 외부 게이트 handoff SHA 템플릿 연결: `Logs/audit_external_release_gates_handoff_sha_templates.log`, `Builds/Handoff/v0.3.0/Evidence/_templates/HUMAN_5_PLAYTEST.md`, `HUMAN_10_COMMERCIAL.md`, `hasPlaytestHandoffShaTemplateLinks=true`
- 외부 검증 핸드오프 패킷: `Builds/Handoff/v0.3.0/EXTERNAL_RELEASE_HANDOFF_KO.md`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`, `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`, 플레이테스터 모집/저사양 PC/Steam 비공개 브랜치 QA 카드 생성. handoff zip 내부 `v0.3.0/PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv` 포함 검증
- Steam 마케팅 자산 감사 QA: `Logs/audit_marketing_assets_store_candidate_playtest_survey.log`, `Builds/QA/v0.3.0/marketing_assets/care_review_marketing_asset_smoke_result.json`, 상점 스크린샷 8장/상점 후보 스크린샷 1장/Steam 캡슐 9장/트레일러 프레임 13장/업로드 후보 트레일러/리마스터 후보/마케팅 zip/로컬 절대경로 미포함 43/43 통과
- 외부 게이트 증거 감사 도구: `Logs/audit_external_release_gates_v030.log`, `Builds/QA/v0.3.0/external_gate_audit`, 10개 게이트 중 현재 0개 통과, `Evidence/<GATE_ID>.md` 템플릿 생성
- 배포 패킷 무결성 감사 도구: `Logs/audit_release_candidate_handoff_actions_zip_doc_gate.log`, `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, 릴리즈/플레이테스트/Steamworks/handoff zip 해시, 안내문 SHA, handoff actions CSV 포함 여부 15/15 통과
- 릴리즈 후보 감사 도구: `Logs/audit_release_candidate_store_candidate_playtest_survey.log`, `Builds/QA/v0.3.0/release_candidate/care_review_release_candidate_audit.json`, 로컬 패키지/상점 사본/상점 후보 스크린샷/마케팅 자산/개인정보 고지/첫 실행 고지/인게임 데이터 처리 고지/저장 백업·복구/로컬 데이터 삭제/데이터 소스 무결성 QA/런타임 이슈 로그 QA/컨트롤러 단축 입력 QA/컨트롤러 포커스 이동 QA/플레이테스트 회수 준비 QA/지원 번들 기반 회수 감사/외부 게이트 증거 감사/선택지 미리보기 QA/플레이테스트 설문 집계 QA/배포 패킷 무결성 QA/QA 증거/외부 검증 핸드오프 70/70 통과, 외부 필수 항목 10개 분리
- 사건 카드 v2 검증: `Logs/runtime_incident_card_v2_final.log`, `Builds/QA/v0.3.0/incident_cards`, 6종 사건 카드 캡처와 컨택트 시트 생성
- 초상/증빙 반복감 QA: `Logs/runtime_visual_variety_steamworks_docs_v030_final.log`, `Builds/QA/v0.3.0/visual_variety`, 초상 8종과 증빙 카드 12종 전체 사용 검증
- 운영 기준별 밸런스 QA: `Builds/QA/v0.3.0/care_review_balance_qa.json`, `Builds/QA/v0.3.0/care_review_balance_tuning_report.md`, 3종 운영 기준 x 7개 성향 = 21개 자동 플레이 결과와 운영 기준별 튜닝 권고/상용화 판정 export
- 크레딧/고지 화면 검증 로그: `Logs/runtime_credits_privacy_notice_pathsafe_v030.log`
- 크레딧/고지 화면 결과: 합성 프로필, 실제 개인정보 미사용, 로컬 로그, 서버 자동 업로드 없음, 환경 진단/지원 번들 데이터 범위, 생성형 AI 활용, 실제 행정 판단 비대체 문구와 QA JSON 로컬 절대경로 미포함 확인
- content 파일 수: 151
- content 용량: 162,285,158 bytes
- release zip SHA256: `7CE61894F3A69E48A924B993465D8CED36A629F4BBB7D0D64D31E68DD74EA58D`
- Steam 업로드 후보 트레일러: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0.mp4`
- 트레일러 규격: H.264, 1920x1080, 30fps, AAC stereo, video 약 8,050Kbps, 전체 약 8,218Kbps, 45.000s
- 트레일러 SHA256: `C266305CEE20CD8D66E1BD697B9661EBEEF73C7938F1D90FC3F1210A9B62B59F`
- 트레일러 리마스터 작업표: `Builds/Steamworks/v0.3.0/store_page/TRAILER_REMASTER_WORK_ORDER_KO.md`, 49초 프레임 구성안과 45.000초 업로드 후보 차이를 분리하고 `trailer_013_career_record_filter.png`를 `41-45s` 구간에 재배치하는 다음 리컷 기준 기록
- 트레일러 리마스터 리컷: `Builds/Marketing/v0.3.0/trailer/render_trailer_remaster_45s.ps1`, `care_review_office_trailer_steam_upload_v0.3.0_remaster.mp4`, `trailer_steam_upload_remaster_probe.json`, `trailer_steam_upload_remaster_contact_sheet.png`, `45.000s`, H.264, 1920x1080, 30fps, AAC stereo
- 트레일러 리마스터 승격 기준: `Builds/Marketing/v0.3.0/trailer/trailer_remaster_promotion_gate.md`, `promotion_decision: not_promoted`, `trailerRemasterCandidateReady=true`, 현재 공식 업로드 후보는 `care_review_office_trailer_steam_upload_v0.3.0.mp4`
- 트레일러 리마스터 업로드 후보: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0_remaster_upload.mp4`, 67,267,146 bytes, `trailerRemasterUploadCandidateReady=true`, 공식 업로드 후보 승격 전 검증 산출물
- 트레일러 리마스터 업로드 switch: `Builds/Marketing/v0.3.0/trailer/trailer_remaster_upload_switch.md`, `current_selection: current_upload`, `switch_state: ready_not_applied`, `candidate_validation: passed`, `hasTrailerRemasterUploadSwitch=true`
- 설문 회수 화면 저해상도 QA: `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`, `screenshotCount=36`, `playtestSurveyGuideMentionsKeyboard=true`, `playtestSurveyGuideMentionsController=true`
- 설문 회수 화면 상점 QA 후보: `Builds/Marketing/v0.3.0/screenshots/09_playtest_survey.png`, `1920x1080`, 1,813,992 bytes, `storeCandidateScreenshotCount=1`, 실제 상점 업로드 8장과 분리된 내부 QA 비교용
- 지원 번들 외부 handoff 참조 QA: `Builds/QA/v0.3.0/support_bundle/care_review_support_bundle_smoke_result.json`, `manifestHasTriageActionsReference=true`, `manifestHasExternalHandoffHashReference=true`

## 남은 작업

- 현재 판정: 로컬 릴리즈 후보는 `ready`, Steam 공개 출시는 `not ready`
- 실제 AppID/DepotID 발급 후 VDF 값 교체
- `store_page` 폴더의 메타데이터를 Steamworks Store Presence에 실제 입력
- SteamCMD preview run 실행
- SteamCMD preview 통과 후 비공개 테스트 브랜치 생성
- Steamworks 웹에서 store capsule, library capsule, hero image 업로드
- Steam 클라이언트에서 설치/실행/삭제 후 재설치 QA
- 실제 사람 플레이테스트 5명 이상 회수 후 `Builds/Playtest/CollectedSessions` 감사 실행
- 실제 저사양 노트북/내장 그래픽 PC에서 실행, 로딩, 프레임, 로그 저장 QA

## 권장 실행 순서

1. `Builds/Handoff/v0.3.0/TESTER_RECRUITMENT_BATCH_KO.md`의 문구로 현재 `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`를 5명 이상에게 배포하고, `playtest_sessions/<sessionId>` 폴더와 환경 진단 파일을 회수한다. 문제 제보가 있으면 `support_bundles/<bundleId>` 폴더도 함께 받는다.
2. `Care Review Office/Audit Playtest Collection`을 실행해 완전 회수 세션 수, 로컬 절대경로 노출 여부, 설문 누락 여부, 지원 번들 manifest/런타임 이슈 로그 포함 여부를 확인한다.
3. 회수된 로그의 운영 등급, 캠페인 챌린지, 재검토 큐, 가격 가치감 점수를 보고 밸런스 조정 여부를 결정한다.
4. `care_review_playtest_commercial_triage.md`에서 실제 사람 완전 회수 수, 10달러 가치감, 재플레이 의향, UI/난이도/납득도 보강 액션을 확인하고 `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`의 `owner_screen` 기준으로 담당 화면별 작업표에 옮긴다.
5. Steamworks에서 AppID/DepotID를 만든 뒤 `scripts/configure_steamworks_ids.ps1`로 VDF 파일명, AppID, DepotID, Depots 블록, preview 업로드 대상 VDF를 함께 교체한다.
6. `upload_preview_steamcmd.ps1`로 preview 업로드를 먼저 실행하고, SteamPipe 경고가 없을 때만 실제 업로드로 전환한다.
7. Steamworks 웹 콘솔이나 실제 PC에서 확인한 항목은 `Builds/Handoff/v0.3.0/Evidence/_templates/<GATE_ID>.md`를 `Evidence/<GATE_ID>.md`로 복사한 뒤 `status: passed`와 증거 경로를 적는다.
8. `Care Review Office/Audit External Release Gates`를 실행해 10개 외부 게이트가 닫혔는지 확인한 뒤 Store Presence와 Achievement 입력을 최종 확정한다.






