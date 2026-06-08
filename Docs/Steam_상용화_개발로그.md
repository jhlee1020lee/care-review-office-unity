# Steam 상용화 개발 로그

## 2026-06-05

### WAV 오디오 자산 풀세트

- 외부 음원 없이 `Tools/generate_care_review_audio.py`로 건조한 사무실 톤의 44.1kHz/16-bit PCM WAV를 내부 합성했다.
- BGM 5곡 추가: `menu_office_night`, `review_paperwork_loop`, `policy_pressure_loop`, `report_afterhours_loop`, `ending_quiet_room`.
- SFX 20종 추가: UI 클릭/뒤로, 종이, 기준표, 도장 5종, 판단 피드백, 사건 3단계, 리포트, 저장, 분석, 성과 토스트, 오류 거절.
- `CareReviewGame.cs`가 `Resources.Load<AudioClip>` 자산을 우선 사용하고, 누락 시 기존 절차 합성 오디오를 폴백으로 유지하도록 수정했다.
- 검증: `Logs/runtime_audio_smoke_wav_assets_player.log`, `Builds/QA/v0.3.0/care_review_audio_smoke_result.json`, `loadedBgmCount=5`, `loadedSfxCount=20`, `screenBgmKeysExpected=true`, `zeroVolumeSfxPlayed=false`, `zeroVolumeMusicMuted=true`.
- 회귀: `Logs/runtime_smoke_wav_audio_assets_player.log` 기본 스모크 `completed=true`, 40건 리포트 도달. `Logs/runtime_low_resolution_wav_audio_assets_player.log` 저해상도 UI `completed=true`, `screenshotCount=42`, 버튼 오버플로/화면 밖 버튼 0건.

## 2026-05-26

### 목표

`돌봄지원 심사소`를 Steam 10달러급 짧은 상용 게임으로 확장하기 위한 첫 기반 작업을 진행했다.

### 완료

- 상용화 기획서 작성: `Docs/Steam_10달러급_상용화_기획서.md`
- 현재 5개 하드코딩 사례 구조를 데이터 주도 구조로 전환 시작
- `Assets/Resources/Data/cases_day1.json` 추가
- 1일차 사례 수를 5개에서 8개로 확장
- Unity 런타임에서 `Resources.Load<TextAsset>("Data/cases_day1")`로 사례를 로드하도록 수정
- JSON 로드 실패 시 기존 내장 프로토타입 사례로 fallback
- 기존 5장 가족 초상 시트를 8개 이상 사례에서 안전하게 재사용하도록 `PortraitSprite` 인덱스 보정
- 결과 리포트의 에이전트 분석이 8개 사례 기준으로 작동하도록 수정
- 사람 플레이 로그에 사례 메타데이터와 판단 전후 지표를 포함하도록 확장
- 플레이 로그를 `care_review_play_log.json`과 `care_review_play_log.csv`로 동시에 저장
- 결과 리포트에 `사례별 판단 로그`와 `후속 결과 카드` 섹션 추가
- 에이전트 성향 데이터를 `Assets/Resources/Data/agent_personas.json`으로 분리
- JSON 로드 실패 시 내장 에이전트 성향으로 fallback
- 메인 메뉴 추가: 새 캠페인, 이어하기, 설정, 종료
- 설정 화면 추가: 큰 글자 모드, 자동 저장 전환, 저장 파일 경로 표시
- 캠페인 세이브 파일 추가: `care_review_save.json`
- 심사 중 메뉴/저장 버튼 추가
- 판단 직후 저장된 세션을 이어하기로 복원하면 도장, 피드백, `다음 사례` 상태가 유지되도록 구현
- 결과 리포트를 단일 텍스트에서 카드형 대시보드로 재구성
- 리포트 섹션 분리: 요약 카드, 사례별 판단 표, 후속 결과 카드, 분석 코멘트
- 에이전트 분석 버튼을 누르면 대시보드 섹션을 숨기고 전체 텍스트 분석 화면으로 전환
- 로그 복사 결과 메시지가 현재 리포트 화면 상태에 맞게 표시되도록 수정
- `Assets/Resources/Data/cases_day2.json` 추가
- 캠페인 사례 수를 8건에서 16건으로 확장
- `cases_day1`, `cases_day2`처럼 날짜별 JSON을 순서대로 로드하도록 데이터 로더 확장
- 1일차 종료 후 `2일차 브리핑` 화면을 표시하도록 날짜 전환 UI 추가
- 저장 파일에 날짜 전환 화면 상태를 포함해 이어하기 복원 안정성 개선
- 16건 리포트에서도 사례별 판단 표와 후속 결과 카드가 한 화면에 들어오도록 압축 표시
- 에이전트 자동 플레이가 16개 사례 기준으로 실행되도록 검증
- 선택 결과 기반 후폭풍 이벤트 모델 추가
- 각 판단 로그에 `consequenceType`, `consequenceTitle`, 후폭풍 예산/안정/형평/누락/민원 델타 저장
- 1일차 종료 시 후폭풍 합계를 실제 지표에 적용하고 `2일차 브리핑`에 요약 표시
- 최종 리포트의 후속 결과 카드에 후폭풍 제목을 함께 표시
- 사람 플레이 CSV에 후폭풍 관련 컬럼 추가
- 에이전트 자동 플레이에도 후폭풍 예산/누락/민원 합계를 표시하고 CSV 컬럼 추가
- 누적 후폭풍 임계값 기반 특별 사건 카드 추가
- 현재 특별 사건: `예산 감사 착수`, `민원 공동 대응 회의`, `긴급 안전점검`, `형평성 이의제기`
- 특별 사건이 발생하면 예산/안정/형평/누락/민원 지표에 추가 변화를 적용
- 특별 사건을 세이브 파일의 `incidentLogs`에 저장
- 로그 내보내기 시 `care_review_incident_log.csv`를 함께 생성
- 최종 리포트 분석 코멘트에 특별 사건 요약 표시
- 저장 슬롯 3개 추가
- 메인 메뉴에 `슬롯 1`, `슬롯 2`, `슬롯 3` 선택 UI 추가
- 기존 `care_review_save.json`은 슬롯 1로 유지해 기존 저장과 호환
- 슬롯 2와 슬롯 3은 `care_review_save_slot2.json`, `care_review_save_slot3.json`으로 분리 저장
- 새 캠페인, 이어하기, 수동 저장이 현재 선택한 슬롯 기준으로 작동하도록 변경
- 마지막 선택 슬롯을 `PlayerPrefs`에 저장해 재실행 후에도 유지
- 세이브 데이터에 `saveSlot` 필드 추가
- 설정 화면에 음량 조절 추가
- 설정 화면에 해상도 순환 옵션 추가: `1280 x 720`, `1600 x 900`, `1920 x 1080`
- 설정 화면에 창 모드/전체화면 전환 추가
- 음량/해상도/화면 모드를 `PlayerPrefs`에 저장하고 시작 시 적용
- `AudioListener.volume`과 `Screen.SetResolution`을 통해 실제 런타임 설정 적용

### 검증

- Windows 빌드 성공: `Logs/build_windows_data_cases_2.log`
- Windows 빌드 성공: `Logs/build_windows_rich_logs_3.log`
- Windows 빌드 성공: `Logs/build_windows_menu_save.log`
- Windows 빌드 성공: `Logs/build_windows_report_dashboard.log`
- Windows 빌드 성공: `Logs/build_windows_report_dashboard_fit.log`
- Windows 빌드 성공: `Logs/build_windows_day2_campaign.log`
- Windows 빌드 성공: `Logs/build_windows_consequence_events.log`
- Windows 빌드 성공: `Logs/build_windows_incident_cards.log`
- Windows 빌드 성공: `Logs/build_windows_save_slots.log`
- Windows 빌드 성공: `Logs/build_windows_settings_options.log`
- 첫 화면에서 `1일차 · 1 / 8번째 신청서` 표시 확인
- 첫 화면에서 `1일차 · 1 / 16번째 신청서` 표시 확인
- 8개 사례 전체를 자동 클릭으로 통과한 뒤 에이전트 분석 화면 확인
- 런타임 캡처: `Logs/runtime_agent_analysis_8cases_fixed.png`
- 런타임 캡처: `Logs/runtime_rich_report_8cases_final.png`
- 런타임 캡처: `Logs/runtime_menu_save_main_ready.png`
- 런타임 캡처: `Logs/runtime_menu_save_case_start_ready.png`
- 런타임 캡처: `Logs/runtime_menu_save_after_decision_ready.png`
- 런타임 캡처: `Logs/runtime_continue_menu_ready.png`
- 런타임 캡처: `Logs/runtime_continue_restored_decision.png`
- 런타임 캡처: `Logs/runtime_settings_screen.png`
- 런타임 캡처: `Logs/runtime_report_dashboard_8cases.png`
- 런타임 캡처: `Logs/runtime_report_dashboard_agent.png`
- 런타임 캡처: `Logs/runtime_report_dashboard_fit.png`
- 런타임 캡처: `Logs/runtime_day2_case_1of16.png`
- 런타임 캡처: `Logs/runtime_day2_transition.png`
- 런타임 캡처: `Logs/runtime_day2_case_9of16.png`
- 런타임 캡처: `Logs/runtime_day2_report_16cases.png`
- 런타임 캡처: `Logs/runtime_day2_agent_16cases.png`
- 런타임 캡처: `Logs/runtime_consequence_transition.png`
- 런타임 캡처: `Logs/runtime_consequence_report_16cases.png`
- 런타임 캡처: `Logs/runtime_consequence_agent_16cases.png`
- 런타임 캡처: `Logs/runtime_incident_transition.png`
- 런타임 캡처: `Logs/runtime_incident_report_16cases.png`
- 런타임 캡처: `Logs/runtime_save_slots_menu_initial.png`
- 런타임 캡처: `Logs/runtime_save_slots_slot2_selected.png`
- 런타임 캡처: `Logs/runtime_save_slots_slot2_after_decision.png`
- 런타임 캡처: `Logs/runtime_save_slots_menu_persisted_slot2.png`
- 런타임 캡처: `Logs/runtime_save_slots_continue_slot2.png`
- 런타임 캡처: `Logs/runtime_settings_options_initial.png`
- 런타임 캡처: `Logs/runtime_settings_options_changed.png`
- 런타임 캡처: `Logs/runtime_settings_options_fullscreen_toggled.png`
- 에이전트 시뮬레이션 CSV 생성 확인
- CSV 행 수: 41줄 = 헤더 1줄 + 5개 에이전트 × 8개 사례
- 에이전트 시뮬레이션 CSV 생성 확인
- CSV 행 수: 81줄 = 헤더 1줄 + 5개 에이전트 × 16개 사례
- 사람 플레이 로그 CSV 생성 확인
- CSV 행 수: 9줄 = 헤더 1줄 + 플레이어 판단 8개 사례
- 사람 플레이 로그 CSV 생성 확인
- CSV 행 수: 17줄 = 헤더 1줄 + 플레이어 판단 16개 사례
- 사람 플레이 CSV 헤더에 `consequence_type`, `consequence_title`, `consequence_budget_delta`, `consequence_text` 포함 확인
- 에이전트 CSV 헤더에 `consequence_type`, `consequence_title`, `consequence_budget_delta`, `consequence_missed_risk_delta`, `consequence_complaints_delta` 포함 확인
- 사건 CSV 생성 확인: `care_review_incident_log.csv`
- 사건 CSV 행 수: 3줄 = 헤더 1줄 + 특별 사건 2건
- 로그 저장 위치: `%USERPROFILE%\AppData\LocalLow\SNU Final Project Prototype\Care Review Office`
- 세이브 파일 생성 확인: `%USERPROFILE%\AppData\LocalLow\SNU Final Project Prototype\Care Review Office\care_review_save.json`
- 저장 파일 내용 확인: `currentIndex: 0`, `awaitingNext: true`, 첫 사례 승인 판단 로그 포함
- 이어하기 복원 확인: 저장된 승인 판단 피드백과 `다음 사례` 버튼이 복구됨
- 설정 화면 확인: 큰 글자 모드/자동 저장 상태와 저장 파일 경로 표시
- 8개 사례 완료 후 카드형 리포트 표시 확인
- 사례별 판단 표 8건이 한 화면에 표시되도록 압축 확인
- 에이전트 분석 전환 화면 표시 확인
- 1일차 8건 완료 후 `2일차 브리핑` 화면 표시 확인
- 2일차 첫 사례가 `2일차 · 9 / 16번째 신청서`로 표시되는지 확인
- 16건 완료 후 카드형 리포트 표시 확인
- 세이브 파일 내용 확인: `currentIndex: 16`, `reportShown: true`, 판단 로그 16건 포함
- 세이브 파일 내용 확인: 첫 판단 로그의 `consequenceTitle` 값 `안정도 회복`
- 2일차 브리핑에서 전날 후폭풍 합계 표시 확인
- 에이전트 분석에서 성향별 후폭풍 예산/누락/민원 합계 표시 확인
- 세이브 파일 내용 확인: `incidentLogs` 2건 포함
- 첫 특별 사건: `예산 감사 착수`
- 2일차 브리핑에서 `특별 사건` 줄 표시 확인
- 최종 리포트 분석 코멘트에서 특별 사건 요약 표시 확인
- 슬롯 2 선택 후 새 캠페인 시작 확인
- `care_review_save_slot2.json` 생성 확인
- 슬롯 2 저장 파일 내용 확인: `saveSlot: 2`, `currentIndex: 0`, 판단 로그 1건, `awaitingNext: true`
- 재실행 후 슬롯 2 선택 상태 유지 확인
- 슬롯 2 이어하기로 저장된 판단 상태 복원 확인
- 설정 화면에서 음량 `80%` 초기 표시 확인
- 음량 `90%` 변경 확인
- 해상도 `1600 x 900`에서 `1920 x 1080`으로 변경 확인
- 창 모드/전체화면 전환 버튼 작동 확인
- 레지스트리 PlayerPrefs 확인: `care_review_volume=90`, `care_review_resolution=2`, `care_review_fullscreen=0`
- 릴리즈 패키징 자동화 추가: `Care Review Office/Build Windows Release Package`
- 현재 Windows 빌드 패키징 메뉴 추가: `Care Review Office/Package Current Windows Build`
- 릴리즈 패키지 포함 문서 추가 예정: `README_KR.txt`, `RELEASE_MANIFEST.txt`
- Steam 상점 페이지 자료 문서 작성: `Docs/Steam_상점페이지_자료.md`
- 릴리즈 패키징 체크리스트 작성: `Docs/릴리즈_패키징_체크리스트.md`
- 릴리즈 패키지 생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.2.0`
- 제출/백업용 압축 패키지 생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.2.0.zip`
- 릴리즈 폴더 실행 파일 직접 기동 확인: 5초 이상 프로세스 유지 후 종료
- 메인 메뉴와 설정 화면에 빌드 표기 추가: `v0.2.0 내부 검증 빌드`
- 빌드 표기 추가 후 Windows 릴리즈 패키지 재생성 확인
- 3일차 데이터 추가: `Assets/Resources/Data/cases_day3.json`
- 캠페인 분량 확장: 2일차 16건에서 3일차 24건으로 증가
- 날짜 전환 시 다음 날 기본 예산 재배정 추가: `+520만원`
- 최종 리포트가 24건 이상에서도 깨지지 않도록 최근 12건 중심으로 표시하고 전체는 CSV/JSON 로그로 확인하도록 조정
- 내부 자동 검증 인자 추가: `-careReviewSmokeTest`
- 스모크 테스트가 권장 판단으로 전체 캠페인을 자동 완료하고 사람/에이전트/사건 로그를 생성하도록 구성
- 스모크 테스트 결과: `completed=true`, `caseCount=24`, `logCount=24`, `highestDay=3`, `currentIndex=24`
- 사람 플레이 CSV 행 수: 25줄 = 헤더 1줄 + 24개 사례
- 에이전트 시뮬레이션 CSV 행 수: 121줄 = 헤더 1줄 + 5개 에이전트 x 24개 사례
- 사건 CSV 행 수: 2줄 = 헤더 1줄 + 특별 사건 1건
- 빌드 로그: `Logs/build_windows_day3_smoke_agent.log`
- 런타임 스모크 로그: `Logs/runtime_smoke_day3_agent.log`
- 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.2.0.zip`
- 새 캠페인 시작 전 4단계 튜토리얼 추가: 심사 목표, 서류 읽는 순서, 다섯 가지 판단, 로그와 리포트
- 심사 화면 상단에 `도움말` 버튼 추가
- 도움말 오버레이는 현재 심사 화면을 유지한 채 튜토리얼 내용을 다시 보여주도록 구현
- 빌드 로그: `Logs/build_windows_tutorial_overlay.log`
- 런타임 스모크 로그: `Logs/runtime_smoke_tutorial_overlay.log`
- 튜토리얼/도움말 추가 후 스모크 테스트 재확인: `completed=true`, `caseCount=24`, `logCount=24`, 에이전트 CSV 121줄
- 튜토리얼/도움말 포함 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.2.0.zip`
- 릴리즈 `README_KR.txt`와 `RELEASE_MANIFEST.txt`에 3일차 캠페인, 튜토리얼, 도움말, 스모크 테스트 포함 사항 반영
- 패키징 로그: `Logs/package_windows_tutorial_manifest.log`
- 첫 사례 인터랙티브 하이라이트 추가: 신청서, 서류/누락, 지표, 판단 도장을 4단계로 강조
- 첫 사례 안내는 새 캠페인/이어하기의 첫 미판단 사례에서 표시되고, 판단을 누르면 자동으로 닫힘
- 스모크 테스트에서는 첫 사례 안내를 자동 비활성화해 전체 캠페인 검증을 방해하지 않도록 처리
- 첫 사례 안내 스크린샷 캡처 인자 추가: `-careReviewCaptureFirstCaseGuide`
- 첫 사례 안내 스크린샷 생성 확인: `%USERPROFILE%\\AppData\\LocalLow\\SNU Final Project Prototype\\Care Review Office\\care_review_first_case_guide.png`
- 스크린샷 크기 확인: `1280x720`, 1,299,291 bytes
- 빌드 로그: `Logs/build_windows_first_case_capture.log`
- 런타임 스모크 로그: `Logs/runtime_smoke_first_case_capture_build.log`
- 런타임 캡처 로그: `Logs/runtime_capture_first_case_guide.log`
- 첫 사례 안내 추가 후 스모크 테스트 재확인: `completed=true`, `caseCount=24`, `logCount=24`, 에이전트 CSV 121줄
- 첫 사례 안내 포함 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.2.0.zip`
- 릴리즈 manifest 갱신 확인: `first-case guide`, `guide screenshot capture` 포함
- 패키징 로그: `Logs/package_windows_first_case_guide_manifest.log`
- 판단 직후 지표 변화 마이크로 피드백 추가: 예산/안정/형평/누락/민원 변화와 다음 날 후폭풍 제목 표시
- 저장된 판단 상태를 이어하기로 복원할 때도 판단 변화 패널이 함께 복구되도록 구현
- 첫 사례 가이드의 지표 하이라이트 범위를 새 판단 변화 패널까지 포함하도록 조정
- 판단 피드백 스크린샷 캡처 인자 추가: `-careReviewCaptureDecisionFeedback`
- 판단 피드백 스크린샷 생성 확인: `%USERPROFILE%\\AppData\\LocalLow\\SNU Final Project Prototype\\Care Review Office\\care_review_decision_feedback.png`
- 스크린샷 크기 확인: `1280x720`, 1,333,740 bytes
- 빌드 로그: `Logs/build_windows_metric_micro_feedback.log`
- 런타임 스모크 로그: `Logs/runtime_smoke_metric_micro_feedback.log`
- 런타임 캡처 로그: `Logs/runtime_capture_decision_feedback.log`
- 판단 피드백 추가 후 스모크 테스트 재확인: `completed=true`, `caseCount=24`, `logCount=24`, 에이전트 CSV 121줄
- 릴리즈 manifest 갱신 확인: `metric delta feedback`, `decision feedback screenshot capture` 포함
- 패키징 로그: `Logs/package_windows_metric_micro_feedback_manifest.log`
- 판단 피드백 포함 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.2.0.zip`
- 4일차 데이터 추가: `Assets/Resources/Data/cases_day4.json`
- 5일차 데이터 추가: `Assets/Resources/Data/cases_day5.json`
- 캠페인 분량 확장: 3일차 24건에서 5일차 40건으로 증가
- 빌드 표기 갱신: `v0.3.0 내부 콘텐츠 빌드`
- 릴리즈 패키지명 갱신: `Builds/Release/CareReviewOffice_Windows_v0.3.0`
- 자동 스모크 테스트 결과: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`, `currentIndex=40`
- 사람 플레이 CSV 행 수: 41줄 = 헤더 1줄 + 40개 사례
- 에이전트 시뮬레이션 CSV 행 수: 201줄 = 헤더 1줄 + 5개 에이전트 x 40개 사례
- 사건 CSV 행 수: 6줄 = 헤더 1줄 + 특별 사건 5건
- 빌드 로그: `Logs/build_windows_day5_40cases.log`
- 런타임 스모크 로그: `Logs/runtime_smoke_day5_40cases.log`
- 40개 사례 포함 릴리즈 zip 생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`
- Steam 상점 스크린샷 자동 캡처 인자 추가: `-careReviewCaptureStoreScreenshots`
- 자동 캡처 장면 6종 초안: 메인 메뉴, 사례 심사, 판단 피드백, 일일 브리핑, 최종 리포트, 에이전트 분석
- 상점 스크린샷 생성 확인: `Builds/Marketing/v0.3.0/screenshots`
- 생성 이미지 검증: 6장 초안 모두 `1920x1080`, 파일 크기 약 1.8-2.6MB, 샘플 색상 131개 이상
- 런타임 캡처 로그: `Logs/runtime_capture_store_screenshots.log`
- 상점 스크린샷 캡처 빌드 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- 릴리즈 manifest 갱신 확인: `store screenshot capture` 포함
- 패키징 로그: `Logs/package_windows_store_screenshots_manifest.log`
- 상점 스크린샷 캡처 모드 포함 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`
- 절차적 오디오 시스템 추가: 런타임에서 외부 음원 없이 효과음과 앰비언스 클립 생성
- 추가 효과음: 일반 버튼 클릭, 승인/조건부/보류/추가조사/거절 도장, 페이지 전환, 일일 브리핑, 최종 리포트, 저장, 에이전트 분석
- 낮은 사무실 앰비언스 루프 추가
- 기존 음량 설정이 효과음과 앰비언스에 적용되도록 연결
- 오디오 스모크 테스트 인자 추가: `-careReviewAudioSmokeTest`
- 오디오 스모크 결과: 리스너/SFX 소스/앰비언스 소스 생성, 버튼 1,213 samples, 승인 3,528 samples, 거절 3,969 samples, 앰비언스 88,200 samples
- 빌드 로그: `Logs/build_windows_procedural_audio.log`
- 런타임 오디오 스모크 로그: `Logs/runtime_audio_smoke.log`
- 오디오 추가 후 전체 캠페인 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- 런타임 스모크 로그: `Logs/runtime_smoke_procedural_audio.log`
- 릴리즈 manifest 갱신 확인: `procedural audio`, `audio smoke test` 포함
- 패키징 로그: `Logs/package_windows_procedural_audio_manifest_final.log`
- 절차적 오디오 포함 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`
- `imagegen` 기반 Steam 키아트 원본 생성: 야간 가족지원센터 책상, 신청서, 승인/거절 도장, 가족 사진, 예산 그래프 구도
- 키아트 원본 보관: `Builds/Marketing/v0.3.0/keyart/care_review_office_keyart_source.png`
- Steam 그래픽 자산 생성: Store header/small/main/vertical capsule, page background, Library capsule/hero/header/logo
- Steam 그래픽 자산 폴더: `Builds/Marketing/v0.3.0/steam_assets`
- 생성 규격 검증: `920x430`, `462x174`, `1232x706`, `748x896`, `1438x810`, `600x900`, `3840x1240`, `1280x720`
- 투명 로고 검증: `library_logo_1280x720.png` 네 모서리 alpha `0/0/0/0`
- 컨택트 시트 생성: `Builds/Marketing/v0.3.0/steam_assets/steam_assets_contact_sheet.png`
- Steam 그래픽 자산 zip 생성: `Builds/Marketing/v0.3.0/care_review_office_steam_graphic_assets_v0.3.0.zip`
- 트레일러용 장면 자동 캡처 인자 추가: `-careReviewCaptureTrailerFrames`
- 트레일러 자동 캡처 장면 12종 생성 확인: 메인 메뉴, 튜토리얼 목표, 첫 사례, 판단 피드백, 사례 다양성, 후속 판단, 일일 브리핑, 후반 사례, 최종일 사례, 최종일 피드백, 최종 리포트, 에이전트 분석
- 트레일러 프레임 폴더: `Builds/Marketing/v0.3.0/trailer_frames`
- 생성 프레임 검증: 12장 모두 `1920x1080`
- 45초 트레일러 초안 MP4 생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_draft_v0.3.0.mp4`
- 트레일러 MP4 검증: H.264, `1920x1080`, `30fps`, `45.000s`
- 한국어 하드자막과 분위기 오디오가 들어간 트레일러 컷 생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_captioned_cut_v0.3.0.mp4`
- 자막 트레일러 컷 검증: H.264 video, AAC stereo audio, `1920x1080`, `30fps`, `45.000s`, 4,195,423 bytes
- 트레일러 컨택트 시트 생성: `Builds/Marketing/v0.3.0/trailer/trailer_draft_contact_sheet.png`
- 실제 MP4 샘플 컨택트 시트 생성: `Builds/Marketing/v0.3.0/trailer/trailer_captioned_contact_sheet.png`
- 트레일러 산출물 zip 생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`
- 빌드 로그: `Logs/build_windows_trailer_frames.log`
- 런타임 스모크 로그: `Logs/runtime_smoke_trailer_frame_build.log`
- 런타임 캡처 로그: `Logs/runtime_capture_trailer_frames.log`
- 트레일러 캡처 추가 후 전체 캠페인 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- 릴리즈 manifest 갱신 확인: `trailer frame capture` 포함
- 트레일러 캡처 모드 포함 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`
- 설정에 고대비 모드 추가: 모든 UI 텍스트에 접근성용 외곽선과 고대비 색상 적용
- 키보드 단축키 추가: 메뉴 `N/C/S/1-3`, 심사 `1-5/H/S/N/Enter/Esc`, 리포트 `E/A/R/M`, 설정 `T/C/A/L/+/-`
- 설정 화면에 로그 폴더 버튼과 축약 경로 표시 추가
- 최종 리포트에 로그 저장 위치 박스 추가, `로그 저장` 버튼으로 CSV/JSON 저장 위치 안내
- 접근성 스모크 테스트 인자 추가: `-careReviewAccessibilitySmokeTest`
- 접근성 스모크 결과: 큰 글자/고대비 테스트, 텍스트 외곽선 67/67개 적용, 설정의 고대비/단축키/로그 폴더 안내 확인, 리포트 로그 안내 확인
- 접근성 설정 캡처 생성: `%USERPROFILE%\\AppData\\LocalLow\\SNU Final Project Prototype\\Care Review Office\\care_review_accessibility_settings.png`
- 접근성 보강 후 전체 캠페인 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- 빌드 로그: `Logs/build_windows_accessibility_assertion.log`
- 런타임 접근성 스모크 로그: `Logs/runtime_accessibility_smoke_assertion.log`
- 런타임 전체 스모크 로그: `Logs/runtime_smoke_accessibility_assertion.log`
- 릴리즈 manifest 갱신 확인: `large text mode`, `high contrast mode`, `keyboard shortcuts`, `log folder guidance`, `accessibility smoke test` 포함
- 최신 최종 리포트 상점 스크린샷 갱신: `Builds/Marketing/v0.3.0/screenshots/05_final_report.png`
- 최소/권장 사양 초안 작성: `Docs/Steam_상점페이지_자료.md`
- 개인정보 패턴 스캔 메모 작성: `Docs/개인정보_검수_메모.md`
- 최신 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`
- 업로드 후보 zip/폴더 크기와 SHA256 기록: `Builds/Release/CareReviewOffice_Windows_v0.3.0_SHA256.txt`
- `imagegen` 기반 특별 사건 카드 시트 생성: 예산 감사, 민원 공동 대응 회의, 긴급 안전점검, 형평성 이의제기 4종
- 특별 사건 카드 원본 반영: `Assets/Resources/Art/incident_cards_sheet.png`
- 일일 브리핑 화면을 좌측 비주얼 사건 카드와 우측 브리핑 문서 구도로 재배치
- 사건 영향 수치 텍스트의 크기와 그림자를 보강해 상점 스크린샷/트레일러에서 가독성 개선
- 상점 스크린샷 4번을 비주얼 특별 사건 카드가 보이는 후반 일일 브리핑 장면으로 갱신: `Builds/Marketing/v0.3.0/screenshots/04_day_transition.png`
- 트레일러 7번 프레임을 `trailer_007_incident_briefing.png`로 교체하고 이전 `trailer_007_day2_briefing.png` 잔여 파일이 남지 않도록 캡처 폴더 정리 로직 추가
- 트레일러 캡처 상태 꼬임 방지: 특별 사건 브리핑 프레임 이후 새 캠페인 상태에서 후반 사례로 이동하도록 캡처 루틴 보강
- 트레일러 12프레임 재생성 확인: `Builds/Marketing/v0.3.0/trailer_frames`, 12장 모두 `1920x1080`, stale 프레임 없음
- 45초 트레일러 초안 MP4 재생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_draft_v0.3.0.mp4`, `1920x1080`, `30fps`, `45.000s`, 3,348,914 bytes
- 한국어 하드자막 트레일러 컷 재생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_captioned_cut_v0.3.0.mp4`, `1920x1080`, `30fps`, `45.000s`, 4,211,467 bytes
- 트레일러 컨택트 시트 재생성: `trailer_draft_contact_sheet.png`, `trailer_captioned_contact_sheet.png`; 12개 장면이 모두 채워지도록 정확한 프레임 번호로 샘플링
- 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`
- 빌드 로그: `Logs/build_windows_incident_trailer_state_fix.log`
- 런타임 트레일러 캡처 로그: `Logs/runtime_capture_trailer_frames_incident_state_fix.log`
- 런타임 상점 스크린샷 캡처 로그: `Logs/runtime_capture_store_screenshots_incident_contrast.log`
- 특별 사건 카드 추가 직후 전체 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- 최종 접근성 스모크 테스트 재확인: 큰 글자/고대비 테스트, 텍스트 외곽선 69/69개 적용, 로그 폴더 안내 확인
- 특별 사건 카드 추가 직후 릴리즈 zip 재생성 확인: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`
- 밸런스 QA 실행 인자 추가: `-careReviewBalanceQa`
- 밸런스 QA 산출물 저장: `Builds/QA/v0.3.0/care_review_balance_qa.json`, `Builds/QA/v0.3.0/care_review_balance_qa.csv`
- 하루 예산 재배정 조정: `+520만원`에서 `+1320만원`으로 상향해 권장 판단 경로의 과도한 파산을 완화
- 직접 판단과 후폭풍의 민원 증가량을 낮추고, 민원 공동 대응 회의 사건 임계값을 조정해 결과 분포를 확보
- 밸런스 QA 결과: 권장 판단 경로 `finalBudget=-627`, `complaints=78`, `missedRisk=20`, `incidentCount=2`, `riskFlag=stable`
- 밸런스 QA 결과: 위험 우선 플레이 `finalBudget=136`, `complaints=66`, `missedRisk=9`, `incidentCount=1`, `riskFlag=stable`
- 밸런스 QA 결과: 예산 방어/서류 엄격/추가조사 과다/전부 승인/전부 거절은 `high_pressure`로 분리되어 선택 성향별 리포트 차이를 확인
- 밸런스 보정 후 전체 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`, `budget=-627`, `complaints=78`, `incidentCount=2`
- 밸런스 보정 후 접근성 스모크 테스트 재확인: 큰 글자/고대비 테스트, 텍스트 외곽선 70/70개 적용, 설정/리포트 로그 폴더 안내 확인
- 밸런스 보정 후 상점 스크린샷과 트레일러 프레임 재캡처: `Logs/runtime_capture_store_screenshots_balance_tuned.log`, `Logs/runtime_capture_trailer_frames_balance_tuned.log`
- `imagegen` 기반 엔딩 비주얼 시트 4종 반영: 신뢰 회복, 서류의 밤, 대기실의 하루, 불 켜진 창
- 최종 리포트 좌측에 엔딩 비주얼 카드와 문장형 에필로그를 추가하고, 최종 요약/분석 코멘트/로그 내보내기에 `endingId`, `endingTitle` 포함
- 최종일 판단 후폭풍을 리포트 직전에 실제 지표에 적용하되 다음 날 예산 재배정은 추가하지 않도록 수정
- 최종 엔딩 분기 검증: 권장 판단 경로의 최종 엔딩은 `불 켜진 창`
- 엔딩 반영 후 전체 스모크 테스트 재확인: `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`, `budget=-627`, `stability=95`, `equity=100`, `missedRisk=20`, `complaints=78`, `incidentCount=2`, `endingTitle=불 켜진 창`
- 엔딩 반영 후 접근성 스모크 테스트 재확인: 큰 글자/고대비 테스트, 텍스트 외곽선 70/70개 적용, 설정/리포트 로그 폴더 안내 확인
- 엔딩 반영 후 밸런스 QA 산출물 갱신: `Builds/QA/v0.3.0/care_review_balance_qa.json`, `Builds/QA/v0.3.0/care_review_balance_qa.csv`
- 엔딩 기록 화면 추가: 메인 메뉴에서 `엔딩 기록`으로 진입, 발견한 엔딩과 미발견 엔딩 슬롯 표시
- 발견 엔딩 저장 기능 추가: 최종 리포트 표시 시 `PlayerPrefs`에 `endingId`를 기록하고 마지막 엔딩을 표시
- 엔딩 기록 스모크 테스트 인자 추가: `-careReviewEndingGallerySmokeTest`
- 엔딩 기록 스모크 결과: `galleryActive=true`, `discoveredCount=1`, `endingCatalogCount=4`, `recommendedEndingDiscovered=true`, 마지막 엔딩 `불 켜진 창`
- 상점 스크린샷 세트를 7장으로 확장: 메인 메뉴, 사례 심사, 판단 피드백, 일일 브리핑, 최종 리포트, 엔딩 기록, 에이전트 분석
- 상점 스크린샷 최신 캡처 로그: `Logs/runtime_capture_store_screenshots_ending_gallery_final.log`
- 최신 트레일러 프레임 재캡처: `Logs/runtime_capture_trailer_frames_ending_gallery.log`, 12장 모두 `1920x1080`
- 최신 트레일러 컷 재생성: 초안 `3,318,808 bytes`, 자막 컷 `4,177,447 bytes`, 둘 다 `1920x1080`, `30fps`, `45.000s`
- 최신 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 38,856,701 bytes
- 최종 빌드 로그: `Logs/build_windows_ending_gallery_transition_fix.log`
- 최종 런타임 로그: `Logs/runtime_smoke_ending_gallery_store_final.log`, `Logs/runtime_ending_gallery_store_final.log`, `Logs/runtime_accessibility_smoke_ending_gallery_store_final.log`, `Logs/runtime_balance_qa_ending_gallery_store_final.log`
- 최종 접근성 스모크 테스트 재확인: 큰 글자/고대비 테스트, 텍스트 외곽선 79/79개 적용, 설정/리포트 로그 폴더 안내 확인
- Steamworks depot 생성 메뉴 추가: `Care Review Office/Prepare Steamworks Depot`
- Steamworks 로컬 content root 생성: `Builds/Steamworks/v0.3.0/content_windows`, 파일 151개, 138,006,277 bytes
- SteamPipe app/depot VDF 템플릿 생성: `Builds/Steamworks/v0.3.0/scripts/app_build_000000.vdf`, `depot_build_000001.vdf`
- SteamCMD preview 실행 스크립트 생성: `Builds/Steamworks/v0.3.0/scripts/upload_preview_steamcmd.ps1`
- Steamworks 업로드 준비 문서 작성: `Docs/Steamworks_업로드_준비.md`
- Steamworks content 루트 직접 실행 스모크 테스트 통과: `Logs/runtime_smoke_steamworks_content_v030.log`, `completed=true`, `caseCount=40`, 최종 엔딩 `불 켜진 창`
- Steamworks 준비 폴더 zip 생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 61,562,797 bytes
- Steamworks 준비 폴더 SHA256: `9B9BEC64066962D47BAA6BC7FB19BE25961A2352C5CABEC1CBDEFD45009693A4`
- 최종 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 61,563,013 bytes
- 최종 SHA256: `15B2B3C22126186B340639412FE94E3B142958B0B24B1125296965CD0E5E231E`
- 크레딧/고지 화면 추가: 메인 메뉴 `고지`, 설정 `크레딧/고지`에서 진입
- 고지 문구 범위: 합성 사례, 실제 개인정보 미사용, 로컬 CSV/JSON 로그 저장, 생성형 AI 활용, 실제 복지 행정·법률·의료·상담 판단 비대체
- 크레딧/고지 화면 스모크 테스트 인자 추가: `-careReviewCreditsSmokeTest`
- 크레딧/고지 화면 런타임 검증: `Logs/runtime_credits_smoke_v030_final.log`, `creditsActive=true`, 필수 고지 문구 5개 항목 모두 `true`
- 크레딧/고지 화면 시각 캡처 검증: `Logs/runtime_credits_smoke_visual_v030.log`, `%USERPROFILE%\\AppData\\LocalLow\\SNU Final Project Prototype\\Care Review Office\\care_review_credits_notice.png`
- 크레딧/고지 추가 후 전체 캠페인 스모크 테스트 재확인: `Logs/runtime_smoke_credits_notice_v030.log`, `completed=true`, `caseCount=40`, `endingTitle=불 켜진 창`
- 크레딧/고지 추가 후 접근성 스모크 테스트 재확인: `Logs/runtime_accessibility_smoke_credits_notice_v030.log`, 텍스트 외곽선 86/86개 적용, 설정/리포트 로그 폴더 안내 확인
- Steamworks content 루트 재검증: `Logs/runtime_smoke_steamworks_content_credits_notice_v030.log`, `completed=true`, `caseCount=40`, 최종 엔딩 `불 켜진 창`
- Steamworks content 루트 크레딧/고지 재검증: `Logs/runtime_credits_smoke_steamworks_content_v030.log`, 필수 고지 문구 확인
- 크레딧/고지 반영 후 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 61,564,417 bytes
- 크레딧/고지 반영 후 릴리즈 SHA256: `FFD9DDA4D3472FFB95A7F1A84A6B2AFE26E6672BBA86FBDA322905C9D1BF5BE2`
- 크레딧/고지 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 61,564,207 bytes
- 크레딧/고지 반영 후 Steamworks 준비 폴더 SHA256: `113BCD65B546F7BC9193EFBDA7894AF268F640D8768589E0F3A8ACCA1BC57096`
- Steam 상점 페이지 제출안 작성: `Docs/Steam_상점페이지_제출안.md`
- Steamworks 준비 폴더에 복붙용 상점 메타데이터 추가: `Builds/Steamworks/v0.3.0/store_page/STORE_PAGE_METADATA_KO.md`
- Steamworks 준비 폴더에 자산 업로드 맵 추가: `Builds/Steamworks/v0.3.0/store_page/ASSET_UPLOAD_MAP.md`
- Steam 공식 기준에 맞춰 그래픽 자산 규격 점검: store header `920x430`, small `462x174`, main `1232x706`, vertical `748x896`, library capsule `600x900`, hero `3840x1240`
- 상점 스크린샷 7장 규격 점검: 모두 `1920x1080`
- 기존 자막 트레일러는 `1920x1080`, `30fps`, `45.000s`였으나 전체 비트레이트가 약 `742Kbps`라 Steam 업로드용으로는 낮음
- Steam 업로드 후보 고비트레이트 트레일러 생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0.mp4`
- Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.013s`, 전체 약 `8,149Kbps`, 45,855,074 bytes
- Steam 업로드 후보 트레일러 SHA256: `25C4951E1279692F0E0041947012A22E243CE67B3CC7B872C59A53C6E0615B9F`
- Steam 업로드 후보 포함 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 47,669,424 bytes
- 트레일러 산출물 zip SHA256: `A6BAC8BFC20AF275483E2031F89E174BFC8E7FAC03F2DA61A24FE4CA3B701047`
- Steamworks depot 생성기가 `store_page` 폴더를 보존/생성하고 upload manifest에 경로를 기록하도록 보강
- 상점 메타데이터 포함 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 61,567,515 bytes
- 상점 메타데이터 포함 Steamworks 준비 폴더 SHA256: `7C1A4A31C332AA4243071520C6F4F0826F694B7AD9D0038C180F6B448307B48B`
- 4종 엔딩에 후속 에필로그와 엔딩 해석 문구 추가: 최종 리포트, 엔딩 기록, JSON 로그에 반영
- 자동 테스트/캡처 모드에서는 자동 저장을 끄도록 수정해 병렬 QA 중 세이브 파일 sharing violation 방지
- 엔딩 에필로그 반영 후 전체 캠페인 스모크 테스트 재확인: `Logs/runtime_smoke_ending_epilogue_final.log`, `completed=true`, `caseCount=40`, `endingTitle=불 켜진 창`
- 엔딩 에필로그 반영 후 엔딩 기록 스모크 테스트 재확인: `Logs/runtime_ending_gallery_epilogue_final.log`, `galleryActive=true`, `discoveredCount=1`
- 엔딩 에필로그 반영 후 접근성 스모크 테스트 재확인: `Logs/runtime_accessibility_ending_epilogue_final.log`, 텍스트 외곽선 86/86개 적용
- Steamworks content 루트에서 엔딩 에필로그 반영 빌드 재검증: `Logs/runtime_smoke_steamworks_content_ending_epilogue.log`, `completed=true`, `caseCount=40`
- 플레이 로그 JSON에 `endingSummary`, `endingEpilogue`, `endingLesson` 필드 포함 확인
- 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 최종 리포트 장면에 후속 에필로그 반영
- 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 최종 리포트 프레임에 후속 에필로그 반영
- 엔딩 에필로그 반영 후 트레일러 컷 재생성: 초안 `3,950,277 bytes`, 자막 컷 `4,898,248 bytes`, Steam 업로드 후보 `45,881,131 bytes`
- 최신 Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,156Kbps`
- 최신 Steam 업로드 후보 트레일러 SHA256: `758EE62F9525CC827DF3D8B892B274BA97616C964DB2BA1DB175EE3C861A3FE4`
- 엔딩 에필로그 반영 후 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 61,565,456 bytes
- 엔딩 에필로그 반영 후 릴리즈 SHA256: `5B2BCBF7DA0058A71519CF8D00EA62715BED7D8FE0E99E7772FB48A9755E0886`
- 엔딩 에필로그 반영 후 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 48,985,123 bytes
- 엔딩 에필로그 반영 후 트레일러 산출물 zip SHA256: `5C930E1FFA9AC5F770D195A3AFDFB30EDCAD207A86F2A69D7D0DFCE403A049EF`
- 엔딩 에필로그 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 61,568,582 bytes
- 엔딩 에필로그 반영 후 Steamworks 준비 폴더 SHA256: `66EDB5F2918DF8C733213880A6B56ACB6E0957BDB2E658CA406D7AE50065A0BB`
- 새 캠페인 운영 기준 3종 추가: `균형 심사`, `지원 확대`, `긴축 감사`
- 운영 기준 효과 범위: 시작 예산, 일일 예산 재배정, 지원 비용, 민원/누락 위험 증감 보정
- 설정 화면에 `심사 모드` 버튼과 `D` 단축키 추가, 메인 메뉴/심사 기준/최종 리포트에 현재 운영 기준 표시
- 저장 파일, 플레이 로그 JSON/CSV, 에이전트 분석 JSON, 스모크 결과 JSON에 운영 기준 ID/이름 기록
- 운영 기준별 밸런스 QA 확장: 3종 운영 기준 x 7개 플레이 성향 = 21개 자동 플레이 결과
- 밸런스 QA 산출물 갱신: `Builds/QA/v0.3.0/care_review_balance_qa.json`, `Builds/QA/v0.3.0/care_review_balance_qa.csv`
- 운영 기준 QA 메모 작성: `Docs/운영기준_밸런스_QA.md`
- 권장 경로 QA 요약: 균형 심사 `finalBudget=-627`, `complaints=78`, `stable`; 지원 확대 `finalBudget=1386`, `complaints=61`, `stable`; 긴축 감사 `finalBudget=-2436`, `complaints=90`, `high_pressure`
- 운영 기준 반영 후 컴파일 확인: `Logs/mandate_compile.log`, 신규 오류 없음
- 운영 기준 반영 후 릴리즈 빌드 생성: `Logs/build_windows_mandates_final.log`, `Build Successful`
- 운영 기준 반영 후 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_mandates_final.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 운영 기준 반영 후 접근성 스모크 테스트: `Logs/runtime_accessibility_mandates_player.log`, 텍스트 외곽선 87/87개 적용
- 운영 기준 반영 후 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`
- 운영 기준 반영 후 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 운영 기준 반영 후 트레일러 컷 재생성: 초안 `3,324,382 bytes`, 자막 컷 `4,247,887 bytes`, Steam 업로드 후보 `45,906,845 bytes`
- 운영 기준 반영 시점 Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,161Kbps`
- 운영 기준 반영 시점 Steam 업로드 후보 트레일러 SHA256: `1FED59E752B03579B244D55EA6C2E4AF6A472EDE07A684D3D7163FBA20AFFA38`
- 운영 기준 반영 후 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 45,362,129 bytes
- 운영 기준 반영 후 트레일러 산출물 zip SHA256: `CF72C67C2844D952E9020B6B4DF0ACFA8D26C6376EDA3E3394A88EE03702A781`
- 운영 기준 반영 후 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 61,557,074 bytes
- 운영 기준 반영 후 릴리즈 SHA256: `B5E46BA0CB3AB1F45813687353727E46956CBB50234539A10C0C0C2A9BF41D02`
- Steamworks content 루트에서 운영 기준 반영 빌드 재검증: `Logs/runtime_smoke_steamworks_content_mandates_final.log`, `completed=true`, `caseCount=40`
- 운영 기준 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 61,567,832 bytes
- 운영 기준 반영 후 Steamworks 준비 폴더 SHA256: `FCBAE6F9CE575EE9F915C460EE70BF5E7A8DA246725C6FDAD4811C9DF82F1FF0`
- 이미지 생성 원본 보관: `C:/Users/이종호/.codex/generated_images/019e5ee8-3087-7132-9c28-83d7f1a2a034/ig_073213cdfe00bde3016a1602df6b5c8191866f8445dfff186a.png`
- 가족 초상 v2 시트 추가: `Assets/Resources/Art/family_portraits_sheet_v2.png`, 1536x1024, 8장 카드 구성
- 런타임은 `family_portraits_sheet_v2`를 우선 로드하고, 없으면 기존 `family_portraits_sheet`로 fallback하도록 수정
- 초상 스프라이트 분할 로직을 5x1 기존 시트와 4x2 v2 시트를 모두 처리하도록 보강
- 마케팅 캡처 루틴 시작 시 1920x1080 창 모드로 해상도 전환을 기다리도록 보정해 첫 메인 메뉴 스크린샷 해상도 불일치 수정
- 가족 초상 v2 반영 후 릴리즈 빌드 생성: `Logs/build_windows_portrait_v2_final.log`, 신규 컴파일 오류 없음
- 가족 초상 v2 반영 후 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_portrait_v2_capture_fix.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 가족 초상 v2 반영 후 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`
- 가족 초상 v2 반영 후 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 가족 초상 v2 반영 후 트레일러 컷 재생성: 초안 `3,338,185 bytes`, 자막 컷 `4,260,846 bytes`, Steam 업로드 후보 `45,916,572 bytes`
- 가족 초상 v2 반영 후 Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,163Kbps`
- 가족 초상 v2 반영 후 Steam 업로드 후보 트레일러 SHA256: `46FB0309FF502E9B6DB05A4EB4C35D446D39104CABCDDD070EE4C9D9DBD21064`
- 가족 초상 v2 반영 후 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 45,507,486 bytes
- 가족 초상 v2 반영 후 트레일러 산출물 zip SHA256: `80E56BD6D4651322C46C540FF05439EF5F89A04E2E971B261DFDB37C8727CA95`
- 가족 초상 v2 반영 후 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 65,669,942 bytes
- 가족 초상 v2 반영 후 릴리즈 SHA256: `4E192234D51552F14E9E3DEF03F605E4655BFA8471C739ED242CCF07BC417F04`
- Steamworks content 루트에서 가족 초상 v2 반영 빌드 재검증: `Logs/runtime_smoke_steamworks_content_portrait_v2.log`, `completed=true`, `caseCount=40`
- 가족 초상 v2 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 65,680,703 bytes
- 가족 초상 v2 반영 후 Steamworks 준비 폴더 SHA256: `3A8E928074DCDE3C6C918295F72C3A740A8508B1EC7E963B812A17EACE215B27`
- 증빙 카드 v2 이미지 생성 원본 보관: `C:/Users/이종호/.codex/generated_images/019e5ee8-3087-7132-9c28-83d7f1a2a034/ig_0b69e5d1327bff7e016a1608263e888191a58e6cdedbab321b.png`
- 증빙 카드 v2 생성 프롬프트 요지: 4x3 그리드, 12종 행정 증빙/서류 카드, 한국 가족지원센터 데스크 톤, 텍스트/로고/워터마크 없음, #00ff00 chroma-key 배경
- chroma-key 배경 제거 후 Unity 자산 추가: `Assets/Resources/Art/evidence_cards_sheet_v2.png`, 1448x1086, 12장 카드 구성, alpha PNG
- 심사 화면 상단 서류 스트립을 고정 4장 이미지에서 사례별 동적 증빙 카드로 교체
- 증빙 카드 매핑 기준: 서류 강도/누락 여부, 근무·소득·의료·학교·보육·주거·위험 신호, 긴급도/형평성
- 증빙 카드 v2 반영 후 릴리즈 빌드 생성: `Logs/build_windows_evidence_cards_v2_final.log`, `Build Successful`
- 증빙 카드 v2 반영 후 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_evidence_cards_v2_final.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 증빙 카드 v2 반영 후 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`
- 증빙 카드 v2 반영 후 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 증빙 카드 v2 반영 후 트레일러 컷 재생성: 초안 `3,356,023 bytes`, 자막 컷 `4,285,357 bytes`, Steam 업로드 후보 `45,917,426 bytes`
- 증빙 카드 v2 반영 후 Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,163Kbps`
- 증빙 카드 v2 반영 후 Steam 업로드 후보 트레일러 SHA256: `65FA731777EBE1D08330365E941041CFE26A6F221C38E381C4F19CBDA2EA6601`
- 증빙 카드 v2 반영 후 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 45,663,659 bytes
- 증빙 카드 v2 반영 후 트레일러 산출물 zip SHA256: `CC85034F25B471AC50EB285CDC52FF2585621F437C5DA498C8CB673F88A8B85B`
- 증빙 카드 v2 반영 후 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,941,297 bytes
- 증빙 카드 v2 반영 후 릴리즈 SHA256: `F371AFC9403906CDF6F81B28B3680D6AE52A946BBD62E96711514F2D06F58C1A`
- Steamworks content 루트에서 증빙 카드 v2 반영 빌드 재검증: `Logs/runtime_smoke_steamworks_content_evidence_cards_v2.log`, `completed=true`, `caseCount=40`
- 증빙 카드 v2 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,952,056 bytes
- 증빙 카드 v2 반영 후 Steamworks 준비 폴더 SHA256: `7E725751F1A1A0C4BB964FA24FD790E7281A476AEB93D538D9D44052D5680B76`
- 판단 직후 도장 타격감 연출 추가: 도장 반동, 짧은 위치/회전 보정, 판단 종류별 색상 플래시
- 저장된 판단 상태 복원과 새 사례 진입 시 도장 애니메이션 상태가 남지 않도록 reset 처리
- 판단 연출 반영 후 릴리즈 빌드 생성: `Logs/build_windows_decision_impact_final.log`, `Build Successful`
- 판단 연출 반영 후 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_decision_impact_final.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 판단 연출 반영 후 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`
- 판단 연출 반영 후 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 판단 연출 반영 후 트레일러 컷 재생성: 초안 `3,402,720 bytes`, 자막 컷 `4,329,439 bytes`, Steam 업로드 후보 `45,906,121 bytes`
- 판단 연출 반영 후 Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,161Kbps`
- 판단 연출 반영 후 Steam 업로드 후보 트레일러 SHA256: `3B0404C3E8AFEADAEFA6CF986D3F738F00186E7027D82C0D1C77ACDF6535C368`
- 판단 연출 반영 후 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 45,875,937 bytes
- 판단 연출 반영 후 트레일러 산출물 zip SHA256: `A3D7BD15FC4428EDE66276154250417ACC183213A4EF6E316A83EE7FE8DA8416`
- 판단 연출 반영 후 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,942,531 bytes
- 판단 연출 반영 후 릴리즈 SHA256: `0DCCEB7B7D21239D896628DF8BA22CC547BC3DE24D733DD8FDFEBB1902E42E5F`
- Steamworks content 루트에서 판단 연출 반영 빌드 재검증: `Logs/runtime_smoke_steamworks_content_decision_impact.log`, `completed=true`, `caseCount=40`
- 판단 연출 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,953,291 bytes
- 판단 연출 반영 후 Steamworks 준비 폴더 SHA256: `FAC9BA24DD383D40EDDA3B907FB128AF67F4A5B1B05125EFCCA2B4ECBBF6DD90`
- 트레일러 최종 후보 컷 보강: 정지 프레임 기반 자막 컷에 약한 카메라 무빙, 시작 페이드, 종료 페이드 적용
- 모션 자막 컷 생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_final_motion_cut_v0.3.0.mp4`, 5,113,766 bytes
- 모션 자막 컷 SHA256: `C2BC837E6B551E045FD6A5057B9A356E03D50AFE8BD5BE593DF4F10810A1976F`
- 모션 자막 컷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/trailer/trailer_final_motion_contact_sheet.png`; 12개 장면이 모두 정상 노출됨
- 모션 컷 기반 Steam 업로드 후보 트레일러 재생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0.mp4`, 45,892,389 bytes
- 모션 컷 기반 Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,159Kbps`
- 모션 컷 기반 Steam 업로드 후보 트레일러 SHA256: `4C761BDF1BD3D0C616752F82B5466078FCB62CD2C9B2CBC973EE86A27B9686FA`
- 모션 컷 반영 후 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 58,133,144 bytes
- 모션 컷 반영 후 트레일러 산출물 zip SHA256: `EA7FBF8C0E7CBE77132FE5CEFDCBC32602D74BFBD5E6B8C3273CBF1C1540E0AB`
- 모션 컷 반영 후 Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,953,314 bytes
- 모션 컷 반영 후 Steamworks 준비 폴더 SHA256: `F408F0C369D926C101C73974F21044D5B7FDCB795509192F12FCF183741591A5`

### 2026-05-27 운영 기준별 엔딩 기록 확장

- 엔딩 기록 화면에 `기준 전환` 버튼 추가: 균형 심사, 지원 확대, 긴축 감사 기준별 발견 상태를 전환 확인
- PlayerPrefs 엔딩 기록을 전체 발견 키와 운영 기준별 발견 키로 분리 저장
- 엔딩 기록 상태줄을 `운영 기준`, `기준별 발견`, `전체 발견`, `마지막 엔딩`으로 확장
- 같은 엔딩도 다른 운영 기준에서는 `다른 운영 기준에서 발견`으로 표시해 반복 플레이 목표 보강
- 엔딩 갤러리 스모크 결과 JSON에 `mandateDiscoveredCount`, `campaignMandateId`, `recommendedEndingDiscoveredForCurrentMandate` 필드 추가
- 컴파일 확인: `Logs/mandate_ending_gallery_compile.log`, 신규 컴파일 오류 없음
- 릴리즈 빌드 생성: `Logs/build_windows_mandate_ending_gallery.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_mandate_ending_gallery.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 엔딩 갤러리 스모크 테스트: `Logs/runtime_ending_gallery_mandate_records.log`, `mandateDiscoveredCount=1`, `recommendedEndingDiscoveredForCurrentMandate=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_mandate_ending_gallery.log`, `completed=true`, `caseCount=40`
- 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`; `06_ending_gallery.png`에서 운영 기준별 엔딩 기록 상태 확인
- 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 트레일러 컷 재생성: 초안 `4,229,562 bytes`, 모션 자막 컷 `5,171,159 bytes`, Steam 업로드 후보 `46,052,276 bytes`
- 모션 자막 컷 SHA256: `39B58FCB8C2570ACEE9CDBF31C0A45F63DD8EE9BB46CCAA448FE71132659B48D`
- Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,185Kbps`
- Steam 업로드 후보 트레일러 SHA256: `25684059563B3BC1E112E22B4309325CE10B12FAC4234F0E49250BCB8D073B14`
- 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 58,685,936 bytes
- 트레일러 산출물 zip SHA256: `69D4AE8D3A480FF0DF12E23A759FC372D028D405E7B2BE3727774CB7E6A417CF`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,942,924 bytes
- 릴리즈 SHA256: `F49804F4A70B58983904BEC770103B890A91A4A660416939299154AC99169A77`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,953,631 bytes
- Steamworks 준비 폴더 SHA256: `335AAA6C786390155367C8BCEBA059696C0886460DDC6EA02611768C0B8D6021`

### 2026-05-27 특별 사건 경고 연출과 오디오 보강

- 특별 사건 브리핑 카드에 사건별 색상 띠와 배경 wash, 외곽 강조선을 추가
- 특별 사건 제목에 심각도 라벨 추가: `관찰`, `주의`, `긴급`
- 사건별 짧은 설명 추가: 예산 감사, 민원 회의, 긴급 안전점검, 형평성 이의제기의 후속 압박을 한 줄로 설명
- 브리핑 진입 시 사건 카드 lift/pulse 애니메이션 추가
- 절차적 사건 알림음 3종 추가: minor, major, critical
- 일일 전환 시 기존 단일 alert 대신 사건 심각도 기반 알림음 재생
- 오디오 스모크 결과 JSON에 `incidentMinorSamples`, `incidentMajorSamples`, `incidentCriticalSamples` 필드 추가
- 컴파일 확인: `Logs/incident_audio_polish_compile.log`, 신규 컴파일 오류 없음
- 릴리즈 빌드 생성: `Logs/build_windows_incident_audio_polish_final.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_incident_audio_polish_final.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 오디오 스모크 테스트: `Logs/runtime_audio_smoke_incident_audio_polish_final.log`, 사건 알림음 3종 샘플 생성 확인
- 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`; `04_day_transition.png`에서 사건별 경고 연출 확인
- 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 트레일러 컷 재생성: 초안 `4,238,477 bytes`, 모션 자막 컷 `5,182,122 bytes`, Steam 업로드 후보 `46,052,891 bytes`
- 모션 자막 컷 SHA256: `0B531A1EB6849743560415AB94B028D88D71648CCBB1827D77FE1EB312D7CC0F`
- Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,185Kbps`
- Steam 업로드 후보 트레일러 SHA256: `2E9F57482A78304BD754649C74ECBA1EAA5CBFB575FF86C46DE7973BB4A2089D`
- 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 58,824,985 bytes
- 트레일러 산출물 zip SHA256: `7376373B516EC8079E5B9AF9535B7DB80ADF77B6E4E01D89B01C336C709E344C`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,944,912 bytes
- 릴리즈 SHA256: `35F6051CB41C623C5025624C4C538A1942625A01112E48407C367F843CF66D5C`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_incident_audio_polish_final.log`, `completed=true`, `caseCount=40`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,955,641 bytes
- Steamworks 준비 폴더 SHA256: `4CDBE6244E4B80C608573B10ED400CCD47152AD952D81B816FEF503EB106447C`

### 2026-05-27 후반 캠페인 사건 변형

- 특별 사건 생성부를 고정 문구에서 일차·운영 기준·압박 정도 기반 변형 문구 생성으로 변경
- 예산 감사, 민원 회의, 안전점검, 형평성 이의제기 제목이 후반/최종일/운영 기준에 따라 달라지도록 확장
- `IncidentLog.text`를 브리핑 카드 설명에 직접 반영하고, 같은 텍스트를 CSV/JSON 로그에도 보존
- 최종일 사건은 별도 제목을 사용: 예시 `최종 민원 대응 브리핑`
- 컴파일 확인: `Logs/incident_variants_final_compile.log`, 신규 컴파일 오류 없음
- 릴리즈 빌드 생성: `Logs/build_windows_incident_variants_final.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_incident_variants_final.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 사건 CSV 검증: `care_review_incident_log.csv`에 `사례 기준 공개 요구`, `최종 민원 대응 브리핑` 변형 제목 기록
- 오디오 스모크 테스트: `Logs/runtime_audio_smoke_incident_variants_final.log`, 사건 알림음 3종 샘플 생성 확인
- 상점 스크린샷 7장 재캡처: `Builds/Marketing/v0.3.0/screenshots`, 모두 `1920x1080`; `04_day_transition.png`에서 변형 사건 문구 확인
- 트레일러 프레임 12장 재캡처: `Builds/Marketing/v0.3.0/trailer_frames`, 모두 `1920x1080`
- 트레일러 컷 재생성: 초안 `4,246,270 bytes`, 모션 자막 컷 `5,184,868 bytes`, Steam 업로드 후보 `45,998,833 bytes`
- 모션 자막 컷 SHA256: `30A2845B057D903B7E712281FD01C16D62A4661C72F0C6D0C78646D890C44E2B`
- Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, `45.000s`, 전체 약 `8,175Kbps`
- Steam 업로드 후보 트레일러 SHA256: `C3F4CCFCFEA5166874095F1DF7CBE020EAC308798462B0E5DC915FE4B17085D9`
- 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 58,748,267 bytes
- 트레일러 산출물 zip SHA256: `7754A3B85621D40B5269C3607E3B577B7136816CCF0D656FE85F004BEBF227D9`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,945,929 bytes
- 릴리즈 SHA256: `DCC1761D66241F8392962E9EE24741E9B74B1E4750E8EC10F44A7D4DBCCD0106`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_incident_variants_final.log`, `completed=true`, `caseCount=40`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,956,671 bytes
- Steamworks 준비 폴더 SHA256: `8486854E9F070BA1F7A596293592F546EEC33020DEC41A6A659AA1114AAFA642`

### 2026-05-27 저해상도 UI QA

- 실행 인자 추가: `-careReviewLowResolutionSmokeTest`
- 1280x720, 1600x900, 1920x1080 해상도에서 메인 메뉴, 심사 화면, 판단 피드백, 사건 브리핑, 최종 리포트, 엔딩 기록 화면을 자동 캡처
- QA 산출물 저장: `Builds/QA/v0.3.0/low_resolution_ui`
- 저해상도 UI 결과 JSON: `completed=true`, `resolutionCount=3`, `screenshotCount=18`, 모든 실제 캡처 크기가 목표 해상도와 일치
- 1280x720 기준 심사/브리핑/리포트/엔딩 화면을 육안 확인했고, 버튼 텍스트와 주요 패널의 치명적 잘림은 발견되지 않음
- 릴리즈 README와 manifest에 저해상도 UI 스모크 테스트 포함 사항 반영
- 컴파일 확인: `Logs/low_resolution_ui_compile.log`, 신규 컴파일 오류 없음
- 최종 릴리즈 빌드 생성: `Logs/build_windows_low_resolution_ui_final.log`, `Build Successful`
- 최종 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_low_resolution_ui_final.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 최종 오디오 스모크 테스트: `Logs/runtime_audio_smoke_low_resolution_ui_final.log`, 리스너/SFX/앰비언스/사건 알림음 샘플 생성 확인
- 최종 저해상도 UI 스모크 테스트: `Logs/runtime_low_resolution_ui_smoke_final.log`, 18장 캡처 생성
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_low_resolution_ui_final.log`, `completed=true`, `caseCount=40`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,947,752 bytes
- 릴리즈 SHA256: `79BC02DCB3A456E074E872BAB9855123C6A138628C7A13BDC96C9B88482FF953`
- Steamworks content manifest: 151 files, 149,060,230 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,958,577 bytes
- Steamworks 준비 폴더 SHA256: `4BAD76B0CFED34B383B848367ECE52A5BAA2D20F20247DBDD01F73DBFA7FF43B`

### 2026-05-27 저사양 성능 옵션과 성능 QA

- 설정 화면에 저사양 모드와 FPS 제한 버튼 추가
- 저사양 모드는 vSync를 끄고 30FPS 제한, 안티앨리어싱 0, 그림자 거리 0으로 적용
- 표준 모드에서는 FPS 제한을 30/60/120/제한 없음으로 전환 가능
- 실행 인자 추가: `-careReviewPerformanceSmokeTest`
- 성능 스모크는 1280x720 저사양 모드에서 메인 메뉴, 심사 화면, 판단 피드백, 사건 브리핑, 최종 리포트, 엔딩 기록 화면을 각각 60프레임 샘플링
- QA 산출물 저장: `Builds/QA/v0.3.0/performance`
- 설정 화면 캡처: `Builds/QA/v0.3.0/performance/care_review_settings_performance_options.png`
- 릴리즈 성능 스모크 테스트: `Logs/runtime_performance_smoke.log`, `completed=true`, `screenCount=6`, `targetFrameRate=30`, `passesFrameBudget=true`
- Steamworks content 성능 스모크 테스트: `Logs/runtime_performance_smoke_steamworks_content.log`, 6개 화면 p95 프레임 시간 약 `33.65-33.73ms`
- 설정/접근성 스모크 테스트: `Logs/runtime_accessibility_performance_options.log`, 설정 화면에 새 성능 줄과 버튼 배치 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_performance_options.log`, `completed=true`, `caseCount=40`, 운영 기준 `균형 심사`, 엔딩 `불 켜진 창`
- 오디오 스모크 테스트: `Logs/runtime_audio_smoke_performance_options.log`, 주요 효과음과 사건 알림음 샘플 생성 확인
- 저해상도 UI 스모크 테스트 재확인: `Logs/runtime_low_resolution_ui_performance_options.log`, 18장 캡처 생성
- 최종 릴리즈 빌드 생성: `Logs/build_windows_performance_options.log`, `Build Successful`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,950,312 bytes
- 릴리즈 SHA256: `6E69FD679F1FF9D37F64F9BCC02BAACB095B1D8E4B6FB2848F32199FAD0550BE`
- Steamworks content manifest: 151 files, 149,066,132 bytes
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_performance_options.log`, `completed=true`, `caseCount=40`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,961,139 bytes
- Steamworks 준비 폴더 SHA256: `410E9726E5469A933789F32345866CB7EB3018EEE723EB5474A3FAA891A0A77C`

### 2026-05-27 플레이테스트 피드백 패킷

- 로그 저장 시 기존 `care_review_play_log.json`, `care_review_play_log.csv`, `care_review_incident_log.csv`에 더해 `care_review_playtest_feedback.md`, `care_review_playtest_summary.json`을 함께 생성
- 피드백 Markdown에는 전체 난이도, 예산 압박 이해도, 위험 신호/서류 기준 구분, 버튼 명확성, 엔딩 납득도, UI 가독성, 10달러 구매 의향, 불쾌하거나 조심스러운 표현, 보강 요구 항목을 포함
- 세션 요약 JSON에는 운영 기준, 엔딩, 최종 지표, 판단 분포, 권장 판단 일치율, 고위험 불일치 수, 고비용 지원 수, 우선 확인 지점을 기록
- 실행 인자 추가: `-careReviewPlaytestPacketSmokeTest`
- QA 산출물 저장: `Builds/QA/v0.3.0/playtest_packet`
- 컴파일 확인: `Logs/playtest_packet_compile.log`, 신규 컴파일 오류 없음
- 릴리즈 빌드 생성: `Logs/build_windows_playtest_packet.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_playtest_packet.log`, `completed=true`, `caseCount=40`, 플레이테스트 패킷 생성 확인
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_smoke.log`, `completed=true`, 필수 파일 5종과 설문 항목 확인
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_playtest_packet.log`, `completed=true`, `caseCount=40`
- Steamworks content 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_content.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 67,952,702 bytes
- 릴리즈 SHA256: `44CE11E6DBA86B920CB2E889BCC2DEEB83AC8C9C4884BBC7EFF38CDD19C1DFD1`
- Steamworks content manifest: 151 files, 149,073,025 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,963,527 bytes
- Steamworks 준비 폴더 SHA256: `105EC07B085B4BF933B11FA022458BD5DCD13750EE6E906B20DF36EB0BA926C9`

### 2026-05-27 상점용 최종 트레일러 컷

- 상점용 하드자막 파일 추가: `Builds/Marketing/v0.3.0/trailer/trailer_store_final_captions_v030.ass`
- 최종 트레일러 컷 생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_store_final_v0.3.0.mp4`, 7,073,349 bytes
- 최종 트레일러 컷 구성: 약한 카메라 무빙, 시작/종료 페이드, 한국어 하드자막, 앰비언스/버튼 큐 오디오 믹스
- 최종 트레일러 컷 SHA256: `FCE7855490C8AA5BDC18ACD4DBE482E4DAF71EA0A64C4DACE0C4404389EF09E5`
- Steam 업로드 후보 트레일러 재생성: `Builds/Marketing/v0.3.0/trailer/care_review_office_trailer_steam_upload_v0.3.0.mp4`, 46,239,809 bytes
- Steam 업로드 후보 트레일러 규격: H.264, `1920x1080`, `30fps`, AAC stereo, video 약 `8,050Kbps`, 전체 약 `8,218Kbps`, `45.000s`
- Steam 업로드 후보 트레일러 SHA256: `C266305CEE20CD8D66E1BD697B9661EBEEF73C7938F1D90FC3F1210A9B62B59F`
- 컨택트 시트 생성: `trailer_store_final_contact_sheet.png`, `trailer_steam_upload_contact_sheet.png`; 12개 샘플에서 주요 장면과 자막 노출 확인
- 블랙 프레임 점검: `Logs/ffmpeg_trailer_steam_upload_blackdetect.log`, `black_start` 검출 없음
- 트레일러 산출물 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 72,297,324 bytes
- 트레일러 산출물 zip SHA256: `4278A4544C70D02ECC9BFA6E04488597EE5BA4643302726209595B31178FBEE9`
- Steamworks 상점 업로드 맵 갱신 후 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 67,963,559 bytes
- Steamworks 준비 폴더 SHA256: `EB509412C64DE29B6555F0AEA516AAE0CDF0192ECE056C08ABD40140714C4080`
- 생성/검증 로그: `Logs/ffmpeg_trailer_store_final_cut.log`, `Logs/ffmpeg_trailer_store_final_steam_upload.log`, `Logs/ffmpeg_trailer_store_final_contact_sheet.log`, `Logs/ffmpeg_trailer_steam_upload_contact_sheet.log`

### 2026-05-27 특별 사건 카드 v2 확장

- `imagegen` 기반 추가 사건 카드 2종 생성: 심사 인력 과부하, 사례 적체 경보
- 사건 카드 v2 시트 생성: `Assets/Resources/Art/incident_cards_sheet_v2.png`, `1881x1254`, 3x2 구성
- 생성 원본 보관: `Assets/ArtSources/GeneratedSources/incident_staff_burnout_source.png`, `Assets/ArtSources/GeneratedSources/incident_review_backlog_source.png`
- 런타임 로드 우선순위 변경: `incident_cards_sheet_v2`가 있으면 6종 시트를 우선 사용하고, 없으면 기존 4종 시트로 fallback
- 새 사건 유형 추가: `staff_burnout`, `review_backlog`
- 새 사건 조건 추가: 안정도 저하 시 심사 인력 과부하, 민원/누락 위험 동시 상승 시 사례 적체 경보
- 사건 카드 시각 QA 명령 추가: `-careReviewIncidentCardSmokeTest`
- 사건 카드 QA 산출물: `Builds/QA/v0.3.0/incident_cards`, 6종 PNG와 `incident_cards_contact_sheet.png`
- 사건 카드 QA 결과: `care_review_incident_card_smoke_result.json`, `completed=true`, `usesExpandedIncidentSheet=true`, `incidentTypeCount=6`, `sheetWidth=1881`, `sheetHeight=1254`
- 릴리즈 빌드 생성: `Logs/build_windows_incident_card_v2_clean.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_incident_card_v2_final.log`, `completed=true`, `caseCount=40`, `logCount=40`, 최종 엔딩 `불 켜진 창`
- 사건 카드 시각 스모크 테스트: `Logs/runtime_incident_card_v2_final.log`, 6종 사건 카드 캡처 생성
- 밸런스 QA 재확인: `Logs/runtime_balance_qa_incident_card_v2.log`, 21개 자동 플레이, 권장 판단 경로 `riskFlag=stable`
- 플레이테스트 패킷 재확인: `Logs/runtime_playtest_packet_incident_card_v2.log`, `completed=true`, 필수 파일 5종 확인
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,130,640 bytes
- 릴리즈 SHA256: `73C486C8C329128F01A87FA0D5D22076045629885DE7A246AE6AEB11CCBC9F47`
- Steamworks content manifest: 151 files, 158,513,549 bytes
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_content_incident_card_v2_final.log`, `completed=true`, `caseCount=40`
- Steamworks content 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_content_incident_card_v2.log`, `completed=true`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,141,518 bytes
- Steamworks 준비 폴더 SHA256: `7792057DB16FB000C194B5CD70125560F547D8673530BF46A27CFD758DE311C1`

### 2026-05-27 초상/증빙 반복감 QA

- 40개 사례의 `portraitIndex`를 8종 초상 시트 전체가 균등하게 쓰이도록 재배치: 0-7번 각각 5회
- 주거, 전입, 임시거주, 체납, 쉼터, 화재 계열 문구가 12종 증빙 카드 중 주거 카드에 연결되도록 `EvidenceIndicesForCase` 조건 우선순위 보강
- 실행 인자 추가: `-careReviewVisualVarietySmokeTest`
- QA 산출물 저장: `Builds/QA/v0.3.0/visual_variety`
- 비주얼 반복감 QA 결과: `care_review_visual_variety_smoke_result.json`, `completed=true`, `caseCount=40`, `uniquePortraits=8`, `uniqueEvidenceCards=12`, `passesVarietyGate=true`
- 릴리즈 빌드 생성: `Logs/build_windows_visual_variety_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_visual_variety_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`, 최종 엔딩 `불 켜진 창`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_visual_variety_v030.log`, `completed=true`, `caseCount=40`
- Steamworks content 비주얼 반복감 QA: `Logs/runtime_visual_variety_steamworks_v030.log`, `uniquePortraits=8`, `uniqueEvidenceCards=12`
- Steamworks content 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_visual_variety_v030_final.log`, `completed=true`, 필수 파일 5종 확인
- 밸런스 QA 재확인: `Logs/runtime_balance_qa_visual_variety_v030.log`, 21개 자동 플레이, 권장 판단 경로 `riskFlag=stable`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,131,643 bytes
- 릴리즈 SHA256: `7C2D936EE36A02AC0D381B71944557A3015E140BA72763F36E7226F45F6E3ED8`
- Steamworks content manifest: 151 files, 158,516,299 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,142,561 bytes
- Steamworks 준비 폴더 SHA256: `33C6D5AD4507C306DF08747132D25A9B6EA4A76DAA45BD4DB07BEB27E1201E50`

### 2026-05-27 심사 화면 UI 밀도 폴리싱

- 심사 화면 좌측 초상 아래에 사례 압박 요약 패널 추가
- 요약 패널은 긴급도, 형평성, 서류 강도, 소득 적합 여부, 보강 서류를 두 줄로 압축 표시
- 사례 압박이 높은 경우 패널 색상이 더 강한 경고색으로 바뀌도록 처리
- 상점 스크린샷 7장 재생성: `Builds/Marketing/v0.3.0/screenshots`, 전 파일 1920x1080, 비검은 화면 확인
- 상점 스크린샷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_ui_density.png`
- 저해상도 UI QA 재생성: `Logs/runtime_low_resolution_ui_density_v030.log`, 1280x720/1600x900/1920x1080 기준 18장 캡처, 비검은 화면 확인
- 저해상도 UI 컨택트 시트 생성: `Builds/QA/v0.3.0/low_resolution_ui/low_resolution_contact_sheet_ui_density.png`
- 릴리즈 빌드 생성: `Logs/build_windows_ui_density_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_ui_density_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`, 최종 엔딩 `불 켜진 창`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_ui_density_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,132,005 bytes
- 릴리즈 SHA256: `B604F5DBFF67C5E5D35A209712367D3025246E7FDAAEAC0143B8F785BA1E4509`
- Steamworks content manifest: 151 files, 158,517,382 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,142,975 bytes
- Steamworks 준비 폴더 SHA256: `F0D7CBCA0CBA01858102AC9F845EA4C6A0C33DFC0AC6F519C5088569C05D749D`

### 2026-05-27 최종 리포트 게이지 대시보드

- 최종 리포트 우측 대시보드에 예산, 안정도, 형평성, 누락 위험, 민원 위험 5개 막대 게이지 추가
- 요약 카드 높이와 사례별 판단/후속 결과 영역을 조정해 게이지가 1280x720에서도 겹치지 않도록 재배치
- 상점 스크린샷 7장 재생성: `Builds/Marketing/v0.3.0/screenshots`, 전 파일 1920x1080, 비검은 화면 확인
- 상점 스크린샷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_report_gauges.png`
- 저해상도 UI QA 재생성: `Logs/runtime_low_resolution_report_gauges_v030.log`, 1280x720/1600x900/1920x1080 기준 18장 캡처, 리포트 화면 비검은 화면 확인
- 저해상도 UI 컨택트 시트 생성: `Builds/QA/v0.3.0/low_resolution_ui/low_resolution_contact_sheet_report_gauges.png`
- QA 산출물 저장: `Builds/QA/v0.3.0/report_gauges`
- 릴리즈 빌드 생성: `Logs/build_windows_report_gauges_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_report_gauges_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`, 최종 엔딩 `불 켜진 창`
- 플레이테스트 패킷 재확인: `Logs/runtime_playtest_packet_report_gauges_v030.log`, `completed=true`, 필수 파일 5종 확인
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_report_gauges_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,132,623 bytes
- 릴리즈 SHA256: `BCF87C9A167646C884E1C678FB25B63EE6E3A0A46FB6FEFDE599837B25933ED9`
- Steamworks content manifest: 151 files, 158,518,971 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,143,632 bytes
- Steamworks 준비 폴더 SHA256: `92EA4C27A60856E97D4843F782B1154566A800A6E0BB7A353223DB14E13297D4`

### 2026-05-27 에이전트 비교 대시보드

- 에이전트 분석 화면을 텍스트 보고서 중심에서 5개 가상 플레이어 성향 비교 대시보드로 확장
- 각 성향별 지원 판단 수, 추가조사 수, 권장 판단 일치율을 막대형으로 표시
- 에이전트 시뮬레이션 CSV/JSON 저장 경로를 대시보드 하단에 표시
- 상점 스크린샷 7장 재생성: `Builds/Marketing/v0.3.0/screenshots`, `07_agent_analysis.png` 포함, 전 파일 비검은 화면 확인
- 상점 스크린샷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_agent_dashboard.png`
- 저해상도 UI QA 재생성: `Logs/runtime_low_resolution_agent_dashboard_v030.log`, 1280x720/1600x900/1920x1080 기준 21장 캡처, 에이전트 분석 화면 포함
- 저해상도 UI 컨택트 시트 생성: `Builds/QA/v0.3.0/low_resolution_ui/low_resolution_contact_sheet_agent_dashboard.png`
- QA 산출물 저장: `Builds/QA/v0.3.0/agent_dashboard`
- 릴리즈 빌드 생성: `Logs/build_windows_agent_dashboard_lowres_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_agent_dashboard_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`, 최종 엔딩 `불 켜진 창`
- 플레이테스트 패킷 재확인: `Logs/runtime_playtest_packet_agent_dashboard_v030.log`, `completed=true`, 필수 파일 5종 확인
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_agent_dashboard_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,133,850 bytes
- 릴리즈 SHA256: `09BB6F20DF8058511A77B44CCC73450EA1CFAA01935CF1B797F8CD56600BB410`
- Steamworks content manifest: 151 files, 158,522,602 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,144,879 bytes
- Steamworks 준비 폴더 SHA256: `CD2261458818286B2B926F0B7B2470C64230F6E14A7DA226767A343EA0150859`

### 2026-05-28 가족 유형 판단 지도

- 최종 리포트의 사례별 판단 표 영역을 가족 유형 판단 지도로 교체
- 40개 개별 `type`을 접근성·언어 장벽, 안전·보호 위험, 장애·의료 돌봄, 조손·친족 돌봄 등 넓은 분석 그룹으로 묶어 표시
- 각 분석 그룹별 지원율과 권장 판단 일치율을 막대형으로 표시
- 고위험 불일치, 고비용 지원, 고위험 지연을 집계하고 대표 사례 5건을 주의 사례 큐로 표시
- 상점 스크린샷 7장 재생성: `Builds/Marketing/v0.3.0/screenshots`, `05_final_report.png`에 가족 유형 판단 지도 반영, 전 파일 비검은 화면 확인
- 상점 스크린샷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_player_decision_map.png`
- 저해상도 UI QA 재생성: `Logs/runtime_low_resolution_player_decision_map_groups_v030.log`, 1280x720/1600x900/1920x1080 기준 21장 캡처, 최종 리포트 화면 비검은 화면 확인
- 저해상도 UI 컨택트 시트 생성: `Builds/QA/v0.3.0/low_resolution_ui/low_resolution_contact_sheet_player_decision_map.png`
- QA 산출물 저장: `Builds/QA/v0.3.0/player_decision_map`
- 릴리즈 빌드 생성: `Logs/build_windows_player_decision_map_groups_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_player_decision_map_groups_seq_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`, 최종 엔딩 `불 켜진 창`
- 플레이테스트 패킷 재확인: `Logs/runtime_playtest_packet_player_decision_map_groups_seq_v030.log`, `completed=true`, 필수 파일 5종 확인
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_player_decision_map_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,135,992 bytes
- 릴리즈 SHA256: `CD88A66C3993EA6C8A9350ED74C3165308579B9ECFBAC8EA4F57CC772095FF2E`
- Steamworks content manifest: 151 files, 158,528,284 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,147,079 bytes
- Steamworks 준비 폴더 SHA256: `3B390DC1D242B70F341A9D93F9C749988EF021029224F9254FAC77846CF377D0`

### 2026-05-28 HTML 분석 대시보드

- 로그 저장 시 `care_review_analytics_dashboard.html`을 플레이 JSON/CSV, 사건 CSV, 설문 Markdown, 세션 요약 JSON과 함께 생성
- HTML 대시보드는 판단 분포, 주의 사례 큐, 가족 유형 판단 지도, 특별 사건, 연결 파일 경로를 브라우저에서 확인할 수 있도록 구성
- 플레이테스트 패킷 JSON에 `analyticsDashboardPath`를 추가
- 플레이테스트 패킷 스모크 테스트에 `hasDashboardHtml`, `dashboardMentionsFamilyMap` 검증 항목 추가
- QA 산출물 저장: `Builds/QA/v0.3.0/html_analytics_dashboard`
- 릴리즈 빌드 생성: `Logs/build_windows_html_analytics_dashboard_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_html_analytics_dashboard_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_html_analytics_dashboard_v030.log`, `completed=true`, `hasDashboardHtml=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_html_analytics_dashboard_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- Steamworks content 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_html_analytics_dashboard_v030.log`, `completed=true`, `hasDashboardHtml=true`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,138,899 bytes
- 릴리즈 SHA256: `36F0519991780E48FCC0420B771BFD2C1CDB1B7DD4456A2AF25363C699893A9F`
- Steamworks content manifest: 151 files, 158,537,655 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,150,047 bytes
- Steamworks 준비 폴더 SHA256: `740A750CFC002BA0759D92791D6579942CFE063630E58F7C39E6B90E044DA541`

### 2026-05-28 성과 기록/업적 후보

- 메인 메뉴에 `성과 기록` 화면을 추가하고 8개 Steam 업적 후보 ID를 로컬 성과로 표시
- 캠페인 완료, 권장 판단 85% 이상 일치, 누락 위험 25 이하, 형평성 90 이상, 예산 초과 1,000만 원 미만, 로그 분석 패킷 생성, 에이전트 분석 실행, 2개 이상 운영 기준 완료 조건을 해금 로직으로 연결
- 자동 검증 인자 추가: `-careReviewAchievementSmokeTest`
- QA 산출물 저장: `Builds/QA/v0.3.0/achievements`
- 릴리즈 빌드 생성: `Logs/build_windows_achievements_status_stable_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_achievements_status_stable_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 성과 기록 스모크 테스트: `Logs/runtime_achievement_smoke_status_stable_v030.log`, `unlockedCount=7`, `achievementCatalogCount=8`, 화면 캡처 생성
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_achievements_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- Steamworks content 성과 기록 스모크 테스트: `Logs/runtime_achievement_smoke_steamworks_v030.log`, `unlockedCount=7`, `achievementScreenActive=true`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,141,539 bytes
- 릴리즈 SHA256: `306139999191F0D7BF4FAF97AD2108B3706274FD912431EEF30C466194605226`
- Steamworks content manifest: 151 files, 158,546,117 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,152,783 bytes
- Steamworks 준비 폴더 SHA256: `E03089D5A6F1B199066DCD66F4C831C82857C9AD5F1F4835CB72ED94DAB5F9F6`

### 2026-05-28 성과 해금 토스트/Steam 업적 후보 자료

- 성과가 새로 해금될 때 우측 상단에 `성과 해금` 토스트가 짧게 표시되도록 UI 피드백 추가
- `-careReviewAchievementSmokeTest`가 성과 기록 화면뿐 아니라 해금 토스트 캡처도 생성하도록 확장
- Steamworks `store_page` 폴더에 업적 후보 입력 자료 자동 생성: `ACHIEVEMENT_CANDIDATES_KO.md`, `ACHIEVEMENT_CANDIDATES.csv`
- Steam 제출 전 자체점검 보고서 자동 생성: `Builds/Steamworks/v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`
- QA 산출물 갱신: `Builds/QA/v0.3.0/achievements`
- 릴리즈 빌드 생성: `Logs/build_windows_achievement_toast_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_achievement_toast_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- 릴리즈 성과/토스트 스모크 테스트: `Logs/runtime_achievement_toast_smoke_v030.log`, `toastScreenshotCaptured=true`, `unlockedCount=7`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_achievement_toast_v030.log`, `completed=true`, `caseCount=40`, `logCount=40`
- Steamworks content 성과/토스트 스모크 테스트: `Logs/runtime_achievement_toast_steamworks_v030.log`, `toastScreenshotCaptured=true`, `achievementScreenActive=true`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 73,142,695 bytes
- 릴리즈 SHA256: `D0CAF154CCDB78D0787E2191F757974E372214A4AB0C263F0176A93049701A4E`
- Steamworks content manifest: 151 files, 158,549,273 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 73,157,814 bytes
- Steamworks 준비 폴더 SHA256: `2623BCC243111818CDA00C010FF473EDF234835DA751607260AC493898ABCBFB`

### 2026-05-28 메인 메뉴 키아트 톤 통일

- Steam 상점 배경 자산을 게임 리소스로 편입: `Assets/Resources/Art/menu_keyart_background.png`
- 메인 메뉴가 키아트 기반 야간 심사실 배경을 우선 사용하고, 없을 때 기존 심사실 배경으로 fallback되도록 연결
- Unity 빌드 생성기가 새 메뉴 키아트 텍스처를 import/할당하고 릴리즈 README/manifest에 기록하도록 수정
- 상점 스크린샷 7장 재생성: `Logs/runtime_capture_store_screenshots_menu_keyart_v030.log`, `Builds/Marketing/v0.3.0/screenshots`
- 상점 스크린샷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_menu_keyart.png`
- 저해상도 UI 재검증: `Logs/runtime_low_resolution_menu_keyart_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result_menu_keyart.json`, 21장 캡처 생성
- 릴리즈 빌드 생성: `Logs/build_windows_menu_keyart_manifest_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_menu_keyart_manifest_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_menu_keyart_manifest_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,463,237 bytes
- 릴리즈 SHA256: `471DC3337EAFE0B342AAE905BA2F4447935B44F62C2E96BDBF0565A236872395`
- Steamworks content manifest: 151 files, 162,044,480 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,478,361 bytes
- Steamworks 준비 폴더 SHA256: `637AD56611838A69E3DC96195A324488EAF7BA56FE23B477465E446B0B46B46D`

### 2026-05-28 선택 슬롯 삭제 흐름

- 메인 메뉴 저장 슬롯 행 오른쪽에 `삭제` 버튼 추가
- 저장 파일이 있는 슬롯에서 한 번 누르면 `삭제 확인` 상태로 바뀌고, 같은 슬롯에서 한 번 더 눌러야 실제 파일을 삭제하도록 2단계 확인 흐름 구현
- 저장 파일이 없는 슬롯에서는 삭제 버튼이 비활성화되고, 슬롯을 바꾸면 삭제 확인 상태가 초기화되도록 처리
- `X` 단축키로 선택 슬롯 삭제 흐름을 실행하도록 추가
- 자동 검증 인자 추가: `-careReviewSaveSlotDeleteSmokeTest`
- 세이브 삭제 스모크 테스트: `Logs/runtime_save_slot_delete_v030.log`, 슬롯 3 임시 저장 생성, 삭제 확인 상태, 실제 삭제, 기존 저장 백업/복구 흐름 검증
- QA 결과 저장: `Builds/QA/v0.3.0/care_review_save_slot_delete_smoke_result.json`
- 상점 스크린샷 7장 재생성: `Logs/runtime_capture_store_screenshots_save_slot_delete_v030.log`, `Builds/Marketing/v0.3.0/screenshots`
- 상점 스크린샷 컨택트 시트 생성: `Builds/Marketing/v0.3.0/screenshots/store_screenshots_contact_sheet_save_slot_delete.png`
- 저해상도 UI 재검증: `Logs/runtime_low_resolution_save_slot_delete_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result_save_slot_delete.json`, 21장 캡처 생성
- 릴리즈 빌드 생성: `Logs/build_windows_save_slot_delete_v030.log`, `Build Successful`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_save_slot_delete_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_save_slot_delete_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steam 제출 전 자체점검 보고서에 세이브 슬롯 삭제 QA 증거 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,464,667 bytes
- 릴리즈 SHA256: `AD829BA1E60C93D5D898A601B6A0BD94A019789BA3249A33A2B6F26CCBED28AA`
- Steamworks content manifest: 151 files, 162,048,305 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,479,851 bytes
- Steamworks 준비 폴더 SHA256: `D2A0331FDDEE651592044136E821D42B34BD2A958C3D222CDF305865C6A20631`

### 2026-05-28 플레이테스트 세션 메타데이터

- 플레이테스트 패킷과 플레이 로그에 익명 세션 ID, 캠페인 시작 시각, 총 플레이 시간, 사례별 판단 순서/시각/경과 시간을 추가
- 설문 Markdown에 세션 ID, 플레이 시간, 익명 테스터 코드, 테스트 기기/해상도, 개인정보 미기재 확인 항목을 추가
- HTML 분석 대시보드 상단에 세션 ID와 플레이 시간을 표시해 CSV/JSON/설문 파일을 한 회차로 묶어 볼 수 있도록 보강
- 플레이테스트 패킷 스모크 테스트 검증 항목에 `sessionId`, `totalPlaySeconds`, CSV `session_id`/`elapsed_seconds`, 대시보드 세션 ID 표시 확인을 추가
- 릴리즈 빌드 생성: `Logs/build_windows_playtest_session_metadata_v030_retry.log`, `Build Successful`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_session_metadata_v030.log`, `completed=true`, 세션 ID/플레이 시간/CSV 세션 컬럼/HTML 대시보드 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_playtest_session_metadata_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_playtest_session_metadata_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_session_metadata_v030.log`, `completed=true`
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, 플레이 로그/사건 로그/세션 요약/설문 Markdown/HTML 대시보드 포함
- Steam 제출 전 자체점검 보고서에 플레이테스트 세션 메타데이터 QA 증거 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,465,983 bytes
- 릴리즈 SHA256: `FD53564AB42279CDEE3B9C89A9B4066D2F6E95108FBE066CA09E186D2F73EFDB`
- Steamworks content manifest: 151 files, 162,051,983 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,481,220 bytes
- Steamworks 준비 폴더 SHA256: `7BC26B0DBE3300D7691F4AB075545A3D83CFEBFA82D9EAEB2CB10DB6943FFB93`

### 2026-05-28 플레이테스트 세션별 원본 보관

- 로그 저장 시 고정 파일명을 바로 덮어쓰지 않고 `playtest_sessions/<sessionId>` 폴더에 회차별 원본 패킷을 먼저 저장하도록 변경
- 로그 폴더 루트에는 기존 호환성을 위한 최신 사본을 유지해 자동 검증과 수동 확인 흐름을 함께 지원
- 설문 Markdown과 세션 요약 JSON에 세션별 원본 폴더와 최신 사본 폴더 경로를 기록
- 플레이테스트 패킷 스모크 테스트에 세션별 원본 폴더 생성, `sessionDirectoryPath`, `sample_session_archive` 검증 항목 추가
- 릴리즈 빌드 생성: `Logs/build_windows_playtest_session_archive_v030.log`, `Build Successful`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_session_archive_v030.log`, `completed=true`, `sessionArchiveFileCount=1`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_playtest_session_archive_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_playtest_session_archive_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_session_archive_v030.log`, `completed=true`
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, 최신 사본 7종과 `sample_session_archive` 포함
- Steam 제출 전 자체점검 보고서에 플레이테스트 샘플 세션 원본 QA 증거 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,466,642 bytes
- 릴리즈 SHA256: `8D95BB73B1B9A7EA73E3563A779F8C4D0A975E62C2713D58C1CF22AA52AF396E`
- Steamworks content manifest: 151 files, 162,053,627 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,481,909 bytes
- Steamworks 준비 폴더 SHA256: `2E47C0AF58DC1F7CA9B53F2D748A68FD057603CD1FBD519CF06DCDD47F7426C3`

### 2026-05-28 플레이테스트 다중 세션 집계

- `playtest_sessions` 폴더 전체를 읽어 여러 테스트 회차를 집계하는 export 추가
- 생성 파일: `care_review_playtest_sessions_index.csv`, `care_review_playtest_aggregate.json`, `care_review_playtest_aggregate.md`
- 집계 내용: 세션 수, 완료 캠페인 수, 총 판단 로그, 평균 플레이 시간, 평균 권장 판단 일치율, 평균 최종 지표, 운영 기준 분포, 엔딩 분포, 우선 확인 지점
- 자동 검증 인자 추가: `-careReviewPlaytestAggregateSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_playtest_aggregate_v030.log`, `Build Successful`
- 릴리즈 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_v030.log`, `completed=true`, `sessionCount=6`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_playtest_aggregate_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_playtest_aggregate_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_steamworks_v030.log`, `completed=true`, `sessionCount=10`
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, 최신 사본, 세션 샘플 원본, 다중 세션 집계 CSV/JSON/Markdown, 집계 스모크 결과 포함
- Steam 제출 전 자체점검 보고서에 집계 QA 증거 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,469,938 bytes
- 릴리즈 SHA256: `58E76237C7F6B61B6FBB0C8A9C4B1FDBAF2C2AF1C68A87C4F99EABDB8CC78840`
- Steamworks content manifest: 151 files, 162,063,576 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,485,238 bytes
- Steamworks 준비 폴더 SHA256: `6CBE29433C08A29B052C5670C8F619C37A7E91774B87ED3267472A2A8716DFB8`

### 2026-05-28 플레이테스트 패킷 경로 비식별화

- 공유용 플레이테스트 피드백 Markdown, 세션 요약 JSON, HTML 대시보드, 다중 세션 집계 CSV/JSON/Markdown에 로컬 사용자 절대경로를 쓰지 않도록 수정
- 패킷 내부 경로 표기는 `playtest_sessions/<sessionId>/파일명` 상대경로로 통일하고, 로그 폴더 루트 최신 사본은 `.`로 기록
- 기존 세션 요약을 집계할 때도 `C:/Users`, `AppData`, `LocalLow`가 들어간 예전 경로값은 세션 ID 기반 상대경로로 대체
- 플레이테스트 패킷 스모크 테스트에 로컬 사용자 절대경로 미포함 검증 항목 추가
- 집계 스모크 테스트에 집계 CSV/JSON/Markdown 로컬 사용자 절대경로 미포함 검증 항목 추가
- 릴리즈 빌드 생성: `Logs/build_windows_path_privacy_docs_v030.log`, `Build Successful`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_path_privacy_v030.log`, `completed=true`, `feedbackHasNoLocalAbsolutePath=true`, `summaryHasNoLocalAbsolutePath=true`, `dashboardHasNoLocalAbsolutePath=true`
- 릴리즈 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_path_privacy_v030.log`, `completed=true`, `sessionCount=13`, 집계 CSV/JSON/Markdown 경로 비식별 검증 통과
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_path_privacy_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_path_privacy_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, 최신 사본, `playtest_sessions/<sessionId>` 샘플 3회차, 다중 세션 집계 CSV/JSON/Markdown, 경로 비식별 스모크 결과 포함
- QA 패킷 경로 스캔: `C:/Users`, `AppData`, `LocalLow` 결과 없음
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,470,554 bytes
- 릴리즈 SHA256: `CAECD063AE79C6228F1A8D010FF0B72AA214F92C4F932D29E763B1387DCA899A`
- Steamworks content manifest: 151 files, 162,065,332 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,485,868 bytes
- Steamworks 준비 폴더 SHA256: `714FCEF445C3DC41B405AB01AAB3AAF72EA39F3BA2B646D93A1A36DAFF9A868C`

### 2026-05-28 결정 감사 대시보드

- 최종 리포트 하단에 `결정 감사` 버튼 추가
- 결정 감사 대시보드는 1-5일차별 판단 수, 지원/추가조사/지연 수, 집행 예산, 위험 증가, 권장 일치율을 막대형으로 표시
- 고압력 대표 사례 큐를 추가해 권장 불일치, 고위험 지연, 고비용 지원, 민원/누락 증가가 큰 사례를 우선 검토할 수 있도록 구성
- 결정 감사 화면 안에 `요약` 버튼을 두어 기본 최종 리포트 대시보드로 돌아갈 수 있게 처리
- 새 자동 검증 인자 추가: `-careReviewDecisionAuditSmokeTest`
- 저해상도 UI QA에 `decision_audit` 화면을 추가해 3종 해상도 x 8개 화면 = 24장 캡처로 확장
- 릴리즈 빌드 생성: `Logs/build_windows_decision_audit_package_v030.log`, `Build Successful`
- 릴리즈 결정 감사 스모크 테스트: `Logs/runtime_decision_audit_final2_v030.log`, `completed=true`, 40개 사례, 5일차 행/막대/고압력 사례 큐 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_decision_audit_final2_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 저해상도 UI 검증: `Logs/runtime_low_resolution_decision_audit_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui`, `screenshotCount=24`, `1280x720_08_audit.png`, `1600x900_08_audit.png`, `1920x1080_08_audit.png` 생성
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_decision_audit_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 결정 감사 스모크 테스트: `Logs/runtime_decision_audit_steamworks_v030.log`, `completed=true`
- Steam 제출 전 자체점검 보고서에 결정 감사 스모크/QA 결과와 24장 저해상도 UI QA 기준 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,473,265 bytes
- 릴리즈 SHA256: `F321805A0A7D8817BE444F2B7A075713B4FB37292304A595918677EFD4784EDB`
- Steamworks content manifest: 151 files, 162,074,308 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,496,775 bytes
- Steamworks 준비 폴더 SHA256: `99EAF58ADD80604AFFD615AAF929753047E66216312B2B45527236F0C0F50D30`

### 2026-05-28 결정 감사 export

- 플레이테스트 세션 요약 JSON에 `decisionAuditDays`, `decisionAuditCases` 추가
- HTML 분석 대시보드에 `결정 감사` 섹션을 추가해 일차별 지출/위험 증가/권장 일치율 표와 고압력 대표 사례 표를 표시
- 플레이테스트 패킷 스모크 테스트에 결정 감사 JSON 필드와 HTML 문구 검증 추가
- 릴리즈 빌드 생성: `Logs/build_windows_decision_audit_exports_final_v030.log`, `Build Successful`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_decision_audit_exports_v030.log`, `completed=true`, `summaryHasDecisionAuditDays=true`, `summaryHasDecisionAuditCases=true`, `dashboardMentionsDecisionAudit=true`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_decision_audit_exports_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_decision_audit_exports_v030.log`, `completed=true`, `sessionCount=23`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_decision_audit_exports_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_decision_audit_exports_v030.log`, `completed=true`
- Steamworks content 루트 결정 감사 스모크 테스트: `Logs/runtime_decision_audit_steamworks_exports_v030.log`, `completed=true`
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, 최신 사본 11종과 `playtest_sessions/<sessionId>` 샘플 3회차 포함
- QA 패킷 경로 스캔: `C:/Users`, `AppData`, `LocalLow` 결과 없음
- Steam 제출 전 자체점검 보고서 갱신: 결정 감사 export 스모크 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,474,515 bytes
- 릴리즈 SHA256: `3F26FF80E88FD710933A6E109EABFC9011BA709D80ACC8BDB45C9C872533A0F7`
- Steamworks content manifest: 151 files, 162,078,549 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,498,065 bytes
- Steamworks 준비 폴더 SHA256: `01F32DC0E7DB76C20661901D5F212EA80EDDEE89807A16ED8C28DB2B9EF79CC9`

### 2026-05-28 심사 중 결정 기록 오버레이

- 심사 화면 상단에 `기록` 버튼 추가
- L 키로 최근 심사 기록을 열고 Esc 또는 L 키로 닫을 수 있게 처리
- 기록 오버레이는 최근 12건의 사례 ID, 일차, 판단/권장 판단, 권장 일치 여부, 예산 변화, 위험 증가, 감사 플래그를 표시
- 판단 전 빈 상태에서는 현재 검토 사례의 ID, 가족 유형, 긴급도, 서류 강도, 형평성, 권장 판단을 표시
- 새 자동 검증 인자 추가: `-careReviewDecisionHistorySmokeTest`
- 저해상도 UI QA에 `decision_history` 화면을 추가해 3종 해상도 x 9개 화면 = 27장 캡처로 확장
- 릴리즈 빌드 생성: `Logs/build_windows_decision_history_final_v030.log`, `Build Successful`
- 릴리즈 심사 기록 스모크 테스트: `Logs/runtime_decision_history_final_v030.log`, `completed=true`, 빈 상태/판단 후 상태/닫기 흐름 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_decision_history_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 저해상도 UI 검증: `Logs/runtime_low_resolution_decision_history_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui`, `screenshotCount=27`, `1280x720_04_history.png`, `1600x900_04_history.png`, `1920x1080_04_history.png` 생성
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_decision_history_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 심사 기록 스모크 테스트: `Logs/runtime_decision_history_steamworks_v030.log`, `completed=true`
- Steam 제출 전 자체점검 보고서 갱신: 심사 기록 스모크/QA 결과와 27장 저해상도 UI QA 기준 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,476,610 bytes
- 릴리즈 SHA256: `98B0A0626ADBF7E6F634DD67A6C6EC5484E64E2DE9C05605E6A3A6621566B916`
- Steamworks content manifest: 151 files, 162,085,502 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,500,337 bytes
- Steamworks 준비 폴더 SHA256: `3479EB0052DDE558A7F3E96863D64D634CBE5CFED29B8563AB82904D0BCB96D6`

### 2026-05-28 권장 판단 비교 피드백

- 판단 직후 지표 변화 패널에 권장 판단 대비 예산, 안정, 위험 차이를 표시
- 기존 `Decide` 계산을 `DecisionPreview` 기반으로 정리해 실제 선택과 권장 선택이 같은 산식으로 비교되도록 개선
- 새 자동 검증 인자 추가: `-careReviewDecisionComparisonSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_decision_comparison_final_v030.log`, `Build Successful`
- 릴리즈 권장 판단 비교 스모크 테스트: `Logs/runtime_decision_comparison_final_v030.log`, `completed=true`, 선택/권장 판단 비교 문구와 예산·위험 문구 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_decision_comparison_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 그래픽 저해상도 UI 검증: `Logs/runtime_low_resolution_decision_comparison_final_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui`, `screenshotCount=27`, `1280x720_03_feedback.png` 비검은 화면 픽셀 샘플 확인
- 상점 스크린샷 재생성: `Logs/runtime_store_screenshots_decision_comparison_graphical_v030.log`, `Builds/Marketing/v0.3.0/screenshots`, 7장 그래픽 캡처와 `03_decision_feedback.png` 비검은 화면 확인
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_decision_comparison_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 권장 판단 비교 스모크 테스트: `Logs/runtime_decision_comparison_steamworks_v030.log`, `completed=true`
- Steam 제출 전 자체점검 보고서 갱신: Steamworks content 스모크 로그, 권장 판단 비교 스모크 로그, 권장 판단 비교 QA 결과 통과
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,477,745 bytes
- 릴리즈 SHA256: `3DD0CB85ECCEC001B312A2848CE8F8C0FF359FBF075CFF65C92A57A88E0D5D50`
- Steamworks content manifest: 151 files, 162,088,892 bytes
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,501,645 bytes
- Steamworks 준비 폴더 SHA256: `84835DCA9B54AE7EC5714A29AEC927532872B6F24489F05CB0D0FD0FF2D2A705`

### 2026-05-28 다음 캠페인 목표 추천

- 캠페인 종료 후 예산 초과, 고비용 지원, 고위험 지연, 권장 불일치, 높은 성과 여부를 기준으로 다음 회차 운영 기준과 구체 목표를 추천하도록 추가
- 최종 리포트 로그 안내 영역에 `다음 캠페인 목표`, 추천 기준, 도전 목표, 추천 근거를 표시
- 플레이테스트 세션 요약 JSON에 `nextCampaignMandateId`, `nextCampaignMandateName`, `nextCampaignChallenge`, `nextCampaignReason` 필드를 추가
- 설문 Markdown과 HTML 분석 대시보드에 다음 캠페인 목표 섹션을 추가하고, 다중 세션 집계 CSV/Markdown에도 다음 목표 컬럼과 요약을 포함
- 최신 사본 복사 중 파일 잠금이 있어도 export 전체가 실패하지 않도록 플레이테스트 패킷 최신 사본 복사 예외 처리를 보강
- 릴리즈 빌드 생성: `Logs/build_windows_next_campaign_objective_docs_final_v030.log`, `Build Successful`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_next_campaign_objective_docs_final_v030.log`, `completed=true`, 다음 캠페인 목표 JSON/Markdown/HTML 검증 통과
- 릴리즈 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_next_campaign_objective_docs_final_v030.log`, `completed=true`, `sessionCount=44`, 다음 목표 CSV/Markdown 검증 통과
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_next_campaign_objective_docs_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 그래픽 저해상도 UI 검증: `Logs/runtime_low_resolution_next_campaign_objective_docs_final_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui`, 27장 캡처, `1280x720_06_report.png` 샘플 고유 색상 779개
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, Steamworks content 검증 후 다중 세션 집계 `sessionCount=49`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,489,035 bytes
- 릴리즈 SHA256: `8B41B28CC8245CCCA7F5C914F3AEF373112BCD279C20AEF2EB9E2A5CBC9AFB58`
- Steamworks content manifest: 151 files, 162,093,156 bytes
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_next_campaign_objective_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_next_campaign_objective_v030.log`, `completed=true`
- Steamworks content 루트 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_steamworks_next_campaign_objective_v030.log`, `completed=true`, `sessionCount=49`
- Steam 제출 전 자체점검 보고서 갱신: 다음 캠페인 목표 스모크 로그, 패킷 QA 필드, 집계 CSV/Markdown 필드 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,505,717 bytes
- Steamworks 준비 폴더 SHA256: `D75D7CDB8A867D6CD255EB2B7849C95874CD3AF48735AE0C2F67AB0AD5D8761D`

### 2026-05-28 추천 심사 즉시 재시작

- 최종 리포트 하단의 `다시 심사` 버튼을 `추천 심사` 버튼으로 바꾸고, 다음 캠페인 목표가 추천한 운영 기준명을 버튼에 함께 표시
- `추천 심사` 버튼과 R 키가 추천된 운영 기준을 적용한 뒤 예산/사례/로그를 초기화하고 새 캠페인 튜토리얼로 진입하도록 연결
- 자동 검증 인자 추가: `-careReviewRecommendedReplaySmokeTest`
- 검증 종료 후 PlayerPrefs의 운영 기준을 원래 값으로 복구해 다른 자동 QA가 특정 기준에 묶이지 않도록 보정
- 릴리즈 빌드 생성: `Logs/build_windows_recommended_replay_final_v030.log`, `Build Successful`
- 릴리즈 추천 심사 재시작 스모크 테스트: `Logs/runtime_recommended_replay_final_v030.log`, `completed=true`, 추천 기준 `긴축 감사`, 시작 예산 950만원, 튜토리얼 복귀 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_recommended_replay_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_recommended_replay_final_v030.log`, `completed=true`
- 릴리즈 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_recommended_replay_final_v030.log`, `completed=true`, `sessionCount=53`
- 그래픽 저해상도 UI 검증: `Logs/runtime_low_resolution_recommended_replay_final_v030.log`, `Builds/QA/v0.3.0/low_resolution_ui`, 27장 캡처, `1280x720_06_report.png` 샘플 고유 색상 779개
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, Steamworks content 검증 후 다중 세션 집계 `sessionCount=57`
- 추천 심사 QA 결과 보관: `Builds/QA/v0.3.0/care_review_recommended_replay_smoke_result.json`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,490,272 bytes
- 릴리즈 SHA256: `33E932645935F44AC24F036EEF8DC390A1F92725804F5CE14C26A766AF8C18A2`
- Steamworks content manifest: 151 files, 162,097,099 bytes
- Steamworks content 루트 추천 심사 재시작 스모크 테스트: `Logs/runtime_recommended_replay_steamworks_v030.log`, `completed=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_recommended_replay_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_recommended_replay_v030.log`, `completed=true`
- Steamworks content 루트 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_steamworks_recommended_replay_v030.log`, `completed=true`, `sessionCount=57`
- Steam 제출 전 자체점검 보고서 갱신: 추천 심사 재시작 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,507,104 bytes
- Steamworks 준비 폴더 SHA256: `A19490E98FDD866CCB89587B8ED49A11E8196B99EEAD311C55A11B256421FE01`

### 2026-05-28 심사 기준표 오버레이

- 심사 화면 상단에 `기준표` 버튼을 추가하고, P 키로 현재 사례의 판단 기준표를 열고 닫을 수 있도록 연결
- 기준표에는 운영 기준, 남은 예산, 현재 사례 압박도, 권장 판단, 핵심 위험 신호, 보강 서류, 다섯 선택지의 예상 예산·안정·형평·위험 변화와 후폭풍 제목을 표시
- 판단별 예상 변화는 실제 `DecisionPreview` 산식을 재사용해, 플레이어가 버튼을 누르기 전에 권장 판단과 다른 선택의 비용을 비교할 수 있게 구성
- 새 자동 검증 인자 추가: `-careReviewPolicyHandbookSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_policy_handbook_docs_final_v030.log`, `Build Successful`
- 릴리즈 심사 기준표 스모크 테스트: `Logs/runtime_policy_handbook_final2_v030.log`, `completed=true`, 운영 기준/권장 판단/현재 사례 근거/다섯 선택지 예상 변화 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_policy_handbook_final2_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 심사 기준표 스모크 테스트: `Logs/runtime_policy_handbook_steamworks_v030.log`, `completed=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_policy_handbook_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steam 제출 전 자체점검 보고서 갱신: 심사 기준표 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,482,339 bytes
- 릴리즈 SHA256: `C69F9FE624B23BECC2BB5E4E8870005D1756C7F680663DD7FBEF72ACA21F9290`
- Steamworks content manifest: 151 files, 162,104,045 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,506,791 bytes
- Steamworks 준비 폴더 SHA256: `448164775D52F11E853435C23432BEEBF3E0935957EF2F697A65FDC629BE229C`

### 2026-05-28 최종 리포트 운영 등급/점수

- 최종 리포트에 `운영 등급` 카드 추가: 예산, 안정, 형평, 누락 위험, 민원 위험, 권장 판단 일치율을 100점 기준 점수와 S/A/B/C/D 등급, 배지, 근거 문장으로 압축
- 최종 리포트 요약과 분석 코멘트에 운영 등급을 함께 표시해 플레이어가 회차 성과를 즉시 비교할 수 있도록 개선
- JSON 로그, 플레이테스트 세션 요약, 설문 Markdown, HTML 분석 대시보드, 다중 세션 집계 CSV/JSON/Markdown에 `campaignScore`, `campaignGrade`, `campaignBadge`, `campaignGradeReason`, 평균 운영 점수 export 추가
- 기존 플레이테스트 세션 요약에 등급 필드가 없을 때 최종 지표와 운영 기준으로 등급을 재계산하는 호환 fallback 추가
- 새 자동 검증 인자 추가: `-careReviewCampaignGradeSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_campaign_grade_fallback_v030.log`, `Build Successful`
- 릴리즈 운영 등급 스모크 테스트: `Logs/runtime_campaign_grade_final_v030.log`, `completed=true`, `grade=B`, `score=73`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_campaign_grade_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_campaign_grade_final_v030.log`, `completed=true`, 운영 등급 JSON/Markdown/HTML export 확인
- 릴리즈 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_campaign_grade_final_v030.log`, `completed=true`, `sessionCount=69`, 평균 운영 점수 `75.1점`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_campaign_grade_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 운영 등급 스모크 테스트: `Logs/runtime_campaign_grade_steamworks_v030.log`, `completed=true`, `grade=B`, `score=73`
- Steamworks content 루트 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_campaign_grade_v030.log`, `completed=true`
- Steamworks content 루트 플레이테스트 집계 스모크 테스트: `Logs/runtime_playtest_aggregate_steamworks_campaign_grade_v030.log`, `completed=true`, `sessionCount=73`
- Steam 제출 전 자체점검 보고서 갱신: 운영 등급 로그, 플레이테스트 운영 등급 export, 집계 운영 점수 항목 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- QA 패킷 갱신: `Builds/QA/v0.3.0/playtest_packet`, 다중 세션 집계 `sessionCount=73`, 평균 운영 점수 `75.1점`
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,494,517 bytes
- 릴리즈 SHA256: `89FFE2C35609185A71AA60955797D8165F7D66382D4739B7A5F6A354349FA46C`
- Steamworks content manifest: 151 files, 162,111,011 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,511,694 bytes
- Steamworks 준비 폴더 SHA256: `14FDB074590206B8698F63ECE2D1EC7667A16682B2827A91F69A5886DA750AB9`

### 2026-05-28 사례 자료실

- 메인 메뉴에 `사례 자료` 버튼과 V 단축키를 추가해 캠페인 시작 전에도 40개 합성 사례를 훑을 수 있도록 구성
- 사례 자료실은 8건씩 5쪽으로 구성하고, 각 사례의 일차, 사례 ID/이름, 가족 유형, 권장 판단, 압박도, 승인 비용을 표 형태로 표시
- 오른쪽 상세 패널에는 쪽 대표 사례의 신청 요약, 요청, 핵심 위험 신호, 서류/누락 보강 사항, 후속 메모를 표시
- 좌우 이동 버튼과 방향키/D/A 이동, N 새 캠페인, Esc/M 메인 메뉴 복귀 동선을 추가
- 새 자동 검증 인자 추가: `-careReviewCaseArchiveSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_case_archive_final_v030.log`, `Build Successful`
- 릴리즈 사례 자료실 스모크 테스트: `Logs/runtime_case_archive_final_v030.log`, `completed=true`, `caseCount=40`, `pageCount=5`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_case_archive_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 사례 자료실 스모크 테스트: `Logs/runtime_case_archive_steamworks_v030.log`, `completed=true`, `caseCount=40`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_case_archive_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steam 제출 전 자체점검 보고서 갱신: 사례 자료실 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,496,707 bytes
- 릴리즈 SHA256: `8B2BFD4D32F4FEFBDD035D3CB4A85BE905E3975C8C9EE6769C33CD539084D12E`
- Steamworks content manifest: 151 files, 162,118,956 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,514,066 bytes
- Steamworks 준비 폴더 SHA256: `38E224C622D9801026C882BC669BBCAC00F0A1A41BAFD5FBCD68D84696BE7967`

### 2026-05-28 메인 메뉴 운영 기준 선택 카드

- 메인 메뉴 왼쪽 문서 영역에 현재 운영 기준, 시작 예산, 기준 효과를 보여주는 카드 추가
- `운영 기준` 버튼과 D 단축키를 메인 메뉴에 연결해 새 캠페인 전에 균형 심사/지원 확대/긴축 감사 기준을 바로 순환 선택할 수 있도록 개선
- 메뉴 상태 문구에 D 운영 기준, V 사례 자료 단축키를 명시하고, 기준 변경 시 새 캠페인 적용 안내를 표시
- 새 자동 검증 인자 추가: `-careReviewMainMenuMandateSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_main_menu_mandate_v030.log`, `Build Successful`
- 릴리즈 메인 메뉴 운영 기준 스모크 테스트: `Logs/runtime_main_menu_mandate_final_v030.log`, `completed=true`, 현재 기준 카드/시작 예산/D 키 안내/기준 변경 저장 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_main_menu_mandate_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 상점 스크린샷 갱신: `Builds/Marketing/v0.3.0/screenshots/01_main_menu.png`, `1920x1080`, 그래픽 모드 캡처에서 비검은 화면 픽셀 확인
- Steamworks content 루트 메인 메뉴 운영 기준 스모크 테스트: `Logs/runtime_main_menu_mandate_steamworks_v030.log`, `completed=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_main_menu_mandate_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steam 제출 전 자체점검 보고서 갱신: 메인 메뉴 운영 기준 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,497,655 bytes
- 릴리즈 SHA256: `5740CC8B658EEE05BFB9F77F446539B1A03628D319D85FF291E5EB6B9AD6FDD2`
- Steamworks content manifest: 151 files, 162,122,346 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,515,156 bytes
- Steamworks 준비 폴더 SHA256: `FC27A8EB8B644165D01720BCBF2AA5F84F8F43F1F33191ADB4176E05C89E2F5B`

### 2026-05-28 인게임 구조화 플레이테스트 설문

- 최종 리포트에 `테스터 설문` 버튼과 F 단축키를 추가해 회차 직후 피드백을 바로 입력할 수 있도록 구성
- 설문 항목은 전체 난이도 적절성, 판단 기준 명확성, 결과 납득도, UI 가독성, 10달러 가치감 5점 척도와 난이도 높음/UI 보강 필요/사례 설명 부족/다시 플레이 의향 빠른 체크로 구성
- 설문 저장 시 `care_review_in_game_feedback.json`과 `care_review_in_game_feedback.md`를 세션 폴더와 최신 사본으로 저장하고, 외부 공유용 파일에 로컬 사용자 절대경로가 들어가지 않도록 검증
- 새 자동 검증 인자 추가: `-careReviewPlaytestSurveySmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_playtest_survey_v030.log`, `Build Successful`
- 릴리즈 인게임 설문 스모크 테스트: `Logs/runtime_playtest_survey_final_v030.log`, `completed=true`, 5점 척도/빠른 체크/JSON/Markdown/리포트 복귀 확인
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_survey_final_v030.log`, `completed=true`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_playtest_survey_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_playtest_survey_smoke_result.json`, `care_review_in_game_feedback_sample.json`, `care_review_in_game_feedback_sample.md`
- Steamworks content 루트 인게임 설문 스모크 테스트: `Logs/runtime_playtest_survey_steamworks_v030.log`, `completed=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_playtest_survey_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steam 제출 전 자체점검 보고서 갱신: 인게임 설문 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,501,596 bytes
- 릴리즈 SHA256: `9A5EE2FF84C4FB95FC9842B912E4D559F0DAD08DD70B94E379A7034C8A314996`
- Steamworks content manifest: 151 files, 162,134,987 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,519,408 bytes
- Steamworks 준비 폴더 SHA256: `83A5D4751EA8E911D467654260FFFB07F7F59A5E46DCF30FBB5516B36959432B`
- 플레이테스터 배포 패킷 작성: `Builds/Playtest/v0.3.0`, 실행 zip/안내문/요청 문구/회수 체크리스트/세션 인덱스 템플릿 포함
- 플레이테스트 배포 zip 생성: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,318,394 bytes
- 플레이테스트 배포 zip SHA256: `1FE0F1A8E77A8FB8A17A9A7A7C0C4682EB3B45698EE19050117CB9EB8745B879`

### 2026-05-28 운영 기준 시작 브리핑

- 새 캠페인 튜토리얼 첫 장에 선택한 운영 기준의 시작 예산, 다음 날 예산 재배정, 압박 의도, 판단 전략을 설명하는 브리핑 추가
- `긴축 감사`는 고난도 반복 플레이 기준이며 권장 판단만 따라도 예산 초과가 날 수 있다는 점, 고위험 사례 우선과 조건부 승인/보류/추가조사 혼합이 필요하다는 점을 명시
- 새 자동 검증 인자 추가: `-careReviewCampaignMandateBriefingSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_campaign_mandate_briefing_v030.log`, `Build Successful`
- 릴리즈 운영 기준 시작 브리핑 스모크 테스트: `Logs/runtime_campaign_mandate_briefing_final_v030.log`, `completed=true`, 긴축 감사/시작 예산 950만원/고난도 안내/튜토리얼 연결 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_campaign_mandate_briefing_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 추천 심사 재시작 스모크 테스트: `Logs/runtime_recommended_replay_campaign_mandate_briefing_final_v030.log`, `completed=true`, 추천 기준 튜토리얼 진입 유지 확인
- Steamworks content 루트 운영 기준 시작 브리핑 스모크 테스트: `Logs/runtime_campaign_mandate_briefing_steamworks_v030.log`, `completed=true`
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_campaign_mandate_briefing_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 운영 기준 밸런스 QA 문서 갱신: 긴축 감사 불공정 체감 완화용 초반 안내 보강 완료 기록
- Steam 제출 전 자체점검 보고서 갱신: 운영 기준 시작 브리핑 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,503,007 bytes
- 릴리즈 SHA256: `9F4CE6192EEAA3AF88ED9E2FB6DF7AE241AFB8D6342E5398B443A2A58705E172`
- Steamworks content manifest: 151 files, 162,139,388 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,521,100 bytes
- Steamworks 준비 폴더 SHA256: `00165681CB253A4C455801BCC642B493CC16F7559898B80267BCB58899B92762`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,319,885 bytes
- 플레이테스트 배포 zip SHA256: `065D2C0D8C042F5DC220A6ED19410FE10AD0749E89E6D82B89FE783E0F84AD0D`

### 2026-05-28 환경 진단 export

- 설정 화면 하단에 `환경 진단` 버튼과 B 단축키를 추가해 테스터 PC의 CPU/GPU/RAM, 그래픽 장치, 화면 설정, 저사양/FPS 제한 상태, 현재 설정 화면 FPS 샘플을 저장하도록 구성
- 저장 파일은 `playtest_sessions/<sessionId>/care_review_system_diagnostic.json`과 `care_review_system_diagnostic.md`이며, 로그 폴더 최신 사본도 함께 생성
- 공유용 진단 파일에는 `playtest_sessions/<sessionId>/파일명` 상대경로만 기록하고 `C:/Users`, `AppData`, `LocalLow` 같은 로컬 사용자 절대경로가 포함되지 않도록 스모크 테스트에서 검증
- 새 자동 검증 인자 추가: `-careReviewSystemDiagnosticSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_system_diagnostic_v030.log`, `Build Successful`
- 릴리즈 환경 진단 스모크 테스트: `Logs/runtime_system_diagnostic_final_v030.log`, `completed=true`, p95 약 17.07ms, JSON/Markdown/경로 비식별화 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_system_diagnostic_final_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 루트 환경 진단 스모크 테스트: `Logs/runtime_system_diagnostic_steamworks_v030.log`, `completed=true`, p95 약 16.99ms
- Steamworks content 루트 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_system_diagnostic_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_system_diagnostic_smoke_result.json`, `care_review_system_diagnostic_sample.json`, `care_review_system_diagnostic_sample.md`
- Steam 제출 전 자체점검 보고서 갱신: 환경 진단 스모크 로그와 QA 결과 통과, 실제 AppID/DepotID/SteamCMD/외부 QA만 ACTION REQUIRED로 유지
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,506,285 bytes
- 릴리즈 SHA256: `9D4E10D438B354EF26AAD07516A24787E26C183F08559100F24FA2F67E246399`
- Steamworks content manifest: 151 files, 162,148,438 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,524,680 bytes
- Steamworks 준비 폴더 SHA256: `E7A29D41F9619A0FD2404072AD91B4406D807422C0F7D4524AD85A4790654C0B`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,323,431 bytes
- 플레이테스트 배포 zip SHA256: `CBBD48396327DD91A095B7C4867C71936F4E19D932A9FCB47CCA24AE95B068D5`

### 2026-05-28 플레이테스트 회수 감사 도구

- Unity 메뉴 `Care Review Office/Audit Playtest Collection`과 배치 메서드 `CareReviewProjectBuilder.AuditPlaytestCollection` 추가
- 외부 테스터에게 받은 `playtest_sessions/<sessionId>` 폴더를 `Builds/Playtest/CollectedSessions` 아래에 모으면 필수 파일, 35건 이상 판단 로그, 세션 요약, 인게임 설문, 환경 진단, HTML 대시보드, 로컬 절대경로 미포함 여부를 세션별로 점검
- 감사 산출물 생성: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_collection_audit_summary.json`, `.csv`, `.md`
- 현재 QA 샘플 보관소 기준 감사 실행: `Logs/audit_playtest_collection_v030.log`, `sessions=73`, `complete=0`, 플레이 로그 35건 이상 세션 73개, 완전 회수 기준 미달로 실제 사람 플레이테스트 필요 상태 명시
- `Builds/Playtest/CollectedSessions/README_KO.txt` 추가: 외부 세션 폴더 복사 위치와 감사 실행 방법 안내
- 플레이테스트 안내/회수 체크리스트 문서 갱신: 회수 후 감사 도구 실행, complete 세션 수 확인 절차 추가
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,506,387 bytes
- 릴리즈 SHA256: `2EB7C6076B33A66600487DF0D732E1DD0A9259A0404FE0A04FA215AE7FA3168B`
- Steamworks content manifest: 151 files, 162,148,819 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,524,813 bytes
- Steamworks 준비 폴더 SHA256: `61866C7F93B1BE1116ACA6931BDCC0827F0BC6B0EA4A144D5D5F9507256569AD`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,324,290 bytes
- 플레이테스트 배포 zip SHA256: `E3D2A33A3F3110A16BCEE27E6D83B9ECCC787634F8A00B9DB8ACDAC8DE06D66F`

### 2026-05-28 캠페인 기록 화면

- 메인 메뉴에 `캠페인 기록` 화면을 추가해 완료한 회차의 운영 기준, 등급, 엔딩, 권장 판단 일치율, 최종 예산/안정/형평/누락/민원 지표, 다음 캠페인 목표를 최근 12회까지 저장
- 최종 리포트를 열 때 세션 ID와 캠페인 시작 시각을 기준으로 중복 저장을 방지하고 같은 회차를 다시 열면 기존 기록을 갱신하도록 처리
- 새 자동 검증 인자 추가: `-careReviewCareerRecordSmokeTest`
- Windows 빌드 캠페인 기록 스모크 테스트: `Logs/runtime_career_record_smoke_v030.log`, `completed=true`, `recordCount=1`, 등급 B, 엔딩 `불 켜진 창`, 다음 목표 저장 확인
- Steamworks content 루트 캠페인 기록 스모크 테스트: `Logs/runtime_career_record_steamworks_v030.log`, `completed=true`
- QA 보관 사본: `Builds/QA/v0.3.0/care_review_career_record_smoke_result.json`, `Builds/QA/v0.3.0/career_records/care_review_career_records.png`
- 릴리즈/Steamworks README와 자체점검 보고서에 캠페인 기록 화면과 스모크 로그 체크 항목 반영
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_release_career_record_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_career_record_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,499,882 bytes
- 릴리즈 SHA256: `60DBC47B0EC95DCF649DAFB18C43E507EB38CEF398D30EB6AECF3FF57EE098DF`
- Steamworks content manifest: 151 files, 162,158,848 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,525,936 bytes
- Steamworks 준비 폴더 SHA256: `E439CC7BEB587030E41214A4CCC184975AD4BC420FB9427C9841C0922791EA80`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,325,897 bytes
- 플레이테스트 배포 zip SHA256: `0DD32F9ACE67773554E3A60902788D7414480CEE745F08C9016DEA59AEB02358`

### 2026-05-28 후속 연락함

- 심사 화면 상단에 `연락함` 버튼과 F 단축키를 추가해 판단 후 가족 연락, 민원, 감사 요청, 안전 확인 메모를 플레이 중 바로 되읽을 수 있도록 구성
- 후속 연락함은 빈 상태에서 현재 사례와 권장 판단을 안내하고, 판단 후에는 최근 연락, 지표 영향, 권장 일치 여부, 우선 확인 사례를 정리
- 새 자동 검증 인자 추가: `-careReviewFollowUpInboxSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_follow_up_inbox_v030.log`, `Build Successful`
- 릴리즈 후속 연락함 스모크 테스트: `Logs/runtime_follow_up_inbox_v030.log`, `completed=true`, 빈 상태/판단 후 연락·영향·우선 확인/닫기 흐름 확인
- Steamworks content 루트 후속 연락함 스모크 테스트: `Logs/runtime_follow_up_inbox_steamworks_v030.log`, `completed=true`
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_follow_up_inbox_smoke_result.json`
- 릴리즈/Steamworks README와 자체점검 보고서에 후속 연락함 화면과 스모크 로그 체크 항목 반영
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_follow_up_inbox_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_follow_up_inbox_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,502,164 bytes
- 릴리즈 SHA256: `B6B8077F98AD4B6D7E9D522D2AB7BFDF4CFC99253969B0252D610D9AA6691BEF`
- Steamworks content manifest: 151 files, 162,166,800 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,528,417 bytes
- Steamworks 준비 폴더 SHA256: `BF1DCEDED9AB408B8F4CF019B5A7015134066BB1B68375E8B80EBCB2373248AC`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,328,704 bytes
- 플레이테스트 배포 zip SHA256: `00A1269E896E3C0FF72186E9923A9417962AFC31B6E68C4A2F7C4E84F26BA9E1`

### 2026-05-28 판단 근거 선택

- 심사 화면 상단에 `근거` 버튼과 Q 단축키를 추가해 균형 검토, 위험 신호 우선, 형평성 우선, 서류 완성도 우선, 예산 방어 우선 중 현재 판단 근거를 고를 수 있도록 구성
- 선택된 판단 근거를 `DecisionLog`, 저장 파일, 플레이 로그 CSV의 `decision_rationale_id`, `decision_rationale_label`, `decision_rationale_description` 컬럼, 심사 기록, 후속 연락함, 최종 리포트 미리보기 행에 반영
- 새 자동 검증 인자 추가: `-careReviewDecisionRationaleSmokeTest`
- 릴리즈 빌드 생성: `Logs/build_windows_decision_rationale_v030.log`, `Build Successful`
- 릴리즈 판단 근거 스모크 테스트: `Logs/runtime_decision_rationale_v030.log`, `completed=true`, 버튼/지표/로그/CSV/심사 기록/후속 연락함 반영 확인
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_decision_rationale_v030.log`, `cases=40`, `logs=40`, `highestDay=5`, 엔딩 `불 켜진 창`
- Steamworks content 루트 판단 근거 스모크 테스트: `Logs/runtime_decision_rationale_steamworks_v030.log`, `completed=true`
- Steamworks content 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_decision_rationale_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_decision_rationale_smoke_result.json`
- 릴리즈/Steamworks README, 자체점검 보고서, 상점 자료, 플레이테스트 안내 문서에 판단 근거 선택과 QA 증거 반영
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,504,143 bytes
- 릴리즈 SHA256: `91B668D35AE017F554EE635E8C2DC042E8F97299D0F08AFFDC2D3B330E1DB510`
- Steamworks content manifest: 151 files, 162,173,253 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,530,563 bytes
- Steamworks 준비 폴더 SHA256: `AB11C7D73BFD80981787D481D3DC7BCA99103CD569B9AFE51D424D86A17BA1DA`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,330,264 bytes
- 플레이테스트 배포 zip SHA256: `6174C9904CB22EE75D2A152B30B8DAE2FE1DF5DEA60028742269797AF4102C32`

### 2026-05-28 판단 근거 분석 대시보드

- 최종 리포트의 분석 코멘트에 `판단 근거 분포`를 추가해 균형/위험/형평/서류/예산 근거별 건수와 최다 근거, 지원/추가조사/권장 일치율을 표시
- 플레이 로그 JSON과 플레이테스트 세션 요약 JSON에 `decisionRationaleSummaries`, `topDecisionRationaleId`, `topDecisionRationaleName`, `topDecisionRationaleCount`를 추가
- HTML 분석 대시보드에 `판단 근거 분포` 섹션을 추가해 `decision_rationale_id` 기준 근거별 건수, 지원/추가조사/지연, 권장 일치율, 위험 증가를 확인할 수 있도록 구성
- 다중 세션 집계 CSV/Markdown에 최다 판단 근거 컬럼과 문구를 추가해 실제 플레이테스트 회차별 판단 기준 차이를 비교 가능하게 보강
- 새 자동 검증 인자 추가: `-careReviewDecisionRationaleAnalyticsSmokeTest`
- 릴리즈 판단 근거 분석 스모크 테스트: `Logs/runtime_rationale_analytics_final_v030.log`, `completed=true`, 최종 리포트/세션 요약/HTML 대시보드 근거 분포 반영 확인
- Steamworks content 판단 근거 분석 스모크 테스트: `Logs/runtime_rationale_analytics_steamworks_v030.log`, `completed=true`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_rationale_analytics_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_rationale_analytics_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_decision_rationale_analytics_smoke_result.json`
- 플레이테스트 패킷 판단 근거 분석 검증: `Logs/runtime_playtest_packet_rationale_analytics_v030.log`, `summaryHasRationaleAnalytics=true`, `feedbackMentionsRationaleAnalytics=true`, `dashboardMentionsRationaleAnalytics=true`
- 플레이테스트 집계 판단 근거 검증: `Logs/runtime_playtest_aggregate_rationale_analytics_v030.log`, `csvHasRationaleColumns=true`, `markdownMentionsRationale=true`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,516,528 bytes
- 릴리즈 SHA256: `74D921F2120FDBE7B1443C88681F5CCD8F1C906E7990F8456F59B59C64C3C4F5`
- Steamworks content manifest: 151 files, 162,181,279 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,535,631 bytes
- Steamworks 준비 폴더 SHA256: `4A0C709EB3FCBDFD5B3882B3AAC10EC458B107B91AFE865517B9A718D732A17E`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,334,714 bytes
- 플레이테스트 배포 zip SHA256: `6488D4CFE6AA4ABBA8F0E4BDBC6FDFD7DA72356DA25B90E12054AFDDE2DF466F`

### 2026-05-28 캠페인 챌린지 계약

- 운영 기준별 반복 플레이 목표를 `캠페인 챌린지`로 정의: 균형 심사 `근거 일치 계약`, 지원 확대 `위험 방어 계약`, 긴축 감사 `예산 방어 계약`
- 메인 메뉴 운영 기준 카드와 시작 브리핑에 챌린지 이름/목표를 표시해 새 회차의 목적을 명확히 함
- 최종 리포트에 챌린지 성공/미달, 진행 지표, 챌린지 점수를 표시하고 분석 코멘트에 `캠페인 챌린지` 블록을 추가
- 플레이 로그 JSON, 플레이테스트 세션 요약 JSON, 피드백 Markdown, HTML 분석 대시보드에 `campaignChallengeId`, `campaignChallengeSucceeded`, `campaignChallengeProgress`, `campaignChallengeScore`를 export
- 다중 세션 집계 CSV/Markdown/JSON에 캠페인 챌린지 컬럼, 평균 챌린지 점수, 성공 회차 수를 추가
- 새 자동 검증 인자 추가: `-careReviewCampaignChallengeSmokeTest`
- 릴리즈 캠페인 챌린지 스모크 테스트: `Logs/runtime_campaign_challenge_v030.log`, `completed=true`, 메뉴/최종 리포트/로그 JSON/세션 요약/HTML 대시보드 반영 확인
- Steamworks content 캠페인 챌린지 스모크 테스트: `Logs/runtime_campaign_challenge_steamworks_v030.log`, `completed=true`
- 플레이테스트 패킷 챌린지 검증: `Logs/runtime_playtest_packet_campaign_challenge_v030.log`, `summaryHasCampaignChallenge=true`, `feedbackMentionsCampaignChallenge=true`, `dashboardMentionsCampaignChallenge=true`
- 플레이테스트 집계 챌린지 검증: `Logs/runtime_playtest_aggregate_campaign_challenge_v030.log`, `csvHasChallengeColumns=true`, `markdownMentionsChallenge=true`
- 릴리즈 실행 스모크 테스트: `Logs/runtime_smoke_campaign_challenge_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- Steamworks content 실행 스모크 테스트: `Logs/runtime_smoke_steamworks_campaign_challenge_v030.log`, `cases=40`, `logs=40`, `highestDay=5`
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_campaign_challenge_smoke_result.json`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,519,120 bytes
- 릴리즈 SHA256: `CD473AD1BE7C48255DE1777D94A868655355DB94D2B8B89646160D30E161864C`
- Steamworks content manifest: 151 files, 162,191,456 bytes
- Steamworks `store_page` 문구 사본 갱신: `STORE_PAGE_METADATA_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,538,568 bytes
- Steamworks 준비 폴더 SHA256: `C6340D036DAC7C001A0DCB4579DFBC9EC685FB739FDCDF29AF309F6785FD5EDD`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,337,695 bytes
- 플레이테스트 배포 zip SHA256: `08C008E41178B880000F1A340229D8D2A74D843C0BBE0F8B684043D5B10E29FB`

### 2026-05-28 릴리즈 후보 감사

- Unity Editor 메뉴와 배치 메서드 `CareReviewProjectBuilder.AuditReleaseCandidate` 추가
- 감사 산출물 생성: `Builds/QA/v0.3.0/release_candidate/care_review_release_candidate_audit.json`, `.csv`, `.md`
- 점검 범위: 릴리즈 zip/Steamworks zip/플레이테스트 kit zip 해시 일치, Steamworks content 실행 파일, README/manifest 최신 기능 반영, 상점 문서 사본 동기화, 스크린샷/캡슐/트레일러 자산, 핵심 QA JSON, 프리플라이트 로컬 미해결 항목
- 릴리즈/Steamworks README와 manifest, 자체점검 보고서에 릴리즈 후보 감사 항목과 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md` 반영
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_package_sync_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `24/24`, 로컬 미해결 `0`, 외부 필수 항목 `8`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,519,228 bytes
- 릴리즈 SHA256: `2B594E863F55C7923E345F7C39C535442279F82D2B5D73FC70334445BAD87E18`
- Steamworks content manifest: 151 files, 162,191,744 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,539,386 bytes
- Steamworks 준비 폴더 SHA256: `AAAA2DE8D257DDCF42CBF332E375509ED873803969BB9F91109FC58BC1273EFC`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,337,769 bytes
- 플레이테스트 배포 zip SHA256: `A60E50106E2D72E10631B50ADAE5B0ACED3FAC2C5C75571E5D9A010F9C927882`
- 남은 외부 필수 항목: 실제 사람 플레이테스트 5명/10명 회수, 실제 AppID/DepotID 교체, SteamCMD preview run, Steamworks Store Presence/Achievements 입력, 외부 저사양 PC 검증

### 2026-05-28 사례 자료실 필터 큐

- 사례 자료실 하단에 `필터: 전체` 버튼과 F 단축키를 추가
- 필터 큐: 전체, 고위험, 서류보강, 소득예외, 고비용, 추가조사
- 페이지 계산, 요약 문구, 목록, 대표 사례 상세를 필터된 목록 기준으로 갱신
- `-careReviewCaseArchiveSmokeTest`에 필터 전환, 페이지 리셋, 필터 큐 목록/상세 표시 검증 추가
- Steamworks 준비 과정에서 `Docs/Steam_상점페이지_자료.md`와 `Docs/Steam_상점페이지_제출안.md`를 `store_page`로 자동 동기화하도록 보강
- Windows 빌드 로그: `Logs/build_windows_case_archive_filter_v030.log`, `Build Finished, Result: Success`
- 릴리즈 사례 자료실 스모크 테스트: `Logs/runtime_case_archive_filter_v030.log`, `completed=true`, `filterLabel=고위험`, `filteredCaseCount=25`
- Steamworks content 사례 자료실 스모크 테스트: `Logs/runtime_case_archive_steamworks_v030.log`, `completed=true`, 필터 큐 검증 통과
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_case_archive_smoke_result.json`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_case_archive_filter_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `24/24`, 로컬 미해결 `0`, 외부 필수 항목 `8`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,520,029 bytes
- 릴리즈 SHA256: `027A008A4A18E2603653804E836B0BFE5B3EA7AECD282BC8D89C588D82CA983B`
- Steamworks content manifest: 151 files, 162,193,841 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,540,269 bytes
- Steamworks 준비 폴더 SHA256: `AF34AC3F8EF0D5FC7D20AD5A7F081D744927A020F2286AFAABA6F3AD46132946`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,338,654 bytes
- 플레이테스트 배포 zip SHA256: `A87E026CAEB9C25A28CF323E44AE5E96A83C6FCA5FB2C579CFB409128E8DEDFD`

### 2026-05-28 재검토 큐 export

- 기존 고압력 사례 큐를 `재검토 큐`로 확장해 각 사례의 재검토 이유, 사례 자료실 권장 필터, 다음 회차 실험 질문을 함께 표시
- 세션 요약 JSON의 고압력 사례 export에 `reviewReason`, `nextReviewPrompt`, `archiveFilter` 필드 추가
- 플레이테스트 설문 Markdown에 `자동 재검토 큐` 섹션을 추가해 테스터 인터뷰 질문으로 바로 사용할 수 있게 구성
- HTML 분석 대시보드의 재검토 큐 표에 사례, 자료실 필터, 판단/권장, 재검토 이유, 재검토 질문 컬럼 추가
- 릴리즈 빌드 로그: `Logs/build_windows_review_queue_v030.log`, `Build Finished, Result: Success`
- 릴리즈 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_review_queue_v030.log`, `completed=true`, `summaryHasReviewQueueGuidance=true`, `feedbackMentionsReviewQueueGuidance=true`, `dashboardMentionsReviewQueueGuidance=true`
- Steamworks content 플레이테스트 패킷 스모크 테스트: `Logs/runtime_playtest_packet_steamworks_review_queue_v030.log`, `completed=true`
- QA 보관 사본: `Builds/QA/v0.3.0/playtest_packet/care_review_playtest_packet_smoke_result.json`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_review_queue_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `24/24`, 로컬 미해결 `0`, 외부 필수 항목 `8`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,521,083 bytes
- 릴리즈 SHA256: `1BEFE5A17CE7230C8366F0186FF13F972B9780C39E2D4367F98AE87A32402778`
- Steamworks content manifest: 151 files, 162,197,503 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,541,480 bytes
- Steamworks 준비 폴더 SHA256: `657BB11B7EB9D07C99292EDDDA58DB0480743935311AC6867FFACB57A88B67AF`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,339,796 bytes
- 플레이테스트 배포 zip SHA256: `5DFE7EF7BBAF0EFFF7B5BC2AED3FD1A6616EF442C4114B240FF977793CB9A8DA`

### 2026-05-28 운영 기준 튜닝 권고 리포트

- `-careReviewBalanceQa`를 확장해 기존 3종 운영 기준 x 7개 성향 CSV/JSON 외에 운영 기준별 튜닝 권고 JSON/Markdown/HTML을 함께 생성
- 새 산출물: `Builds/QA/v0.3.0/care_review_balance_tuning_report.json`, `.md`, `.html`, `care_review_balance_tuning_smoke_result.json`
- 리포트 내용: 운영 기준별 stable/strained/high_pressure 분포, 권장 경로 상태, 평균 예산/누락 위험/민원, 최고 압박 성향, 조정 우선순위, 상용화 판정
- 최신 자동 판정: 21회 자동 플레이, stable 6회, strained 1회, high_pressure 14회
- 상용화 판정: 자동 밸런스 기준 판매 후보 구조 통과, 실제 사람 플레이테스트로 체감 난이도와 가격 가치감 확인 필요
- 조정 우선순위: `긴축 감사 / 전부 승인 스트레스 테스트` 고난도 압박 상한 1건. 현재는 의도된 스트레스 테스트로 보고 실제 플레이에서 불공정 피드백이 반복될 때만 비용 계수 완화 후보로 둠
- 릴리즈 빌드 로그: `Logs/build_windows_balance_tuning_report_v030.log`, `Build Finished, Result: Success`
- 밸런스 튜닝 실행 로그: `Logs/runtime_balance_tuning_report_v030.log`, `completed=true`, `runCount=21`, `mandateRecommendationCount=3`, `hasReadableExports=true`
- 릴리즈 README/manifest, Steam 제출 전 자체점검, 릴리즈 후보 감사 조건에 밸런스 튜닝 리포트 QA를 반영
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,526,281 bytes
- 릴리즈 SHA256: `854547B73F725757464DBBB542A93E73EF57BDF02C53202692F3DB08AE0764F9`
- Steamworks content manifest: 151 files, 162,211,445 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,546,722 bytes
- Steamworks 준비 폴더 SHA256: `26B6F9BB897892601A893A5A49E6098811F42CC261BFF286F9556495BA6C8B48`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,344,327 bytes
- 플레이테스트 배포 zip SHA256: `3310D077637719722DFAC353C6D167B7E05C70A442822C11C58CC65E68FBF84C`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_balance_tuning_report_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `25/25`, 로컬 미해결 `0`, 외부 필수 항목 `8`

### 2026-05-28 10달러 상용화 트리아지 리포트

- 플레이테스트 회수 감사 `CareReviewProjectBuilder.AuditPlaytestCollection`에 상용화 트리아지 산출물 추가
- 새 산출물: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage.json`, `.csv`, `.md`, `.html`, `care_review_playtest_commercial_triage_smoke_result.json`
- 리포트 내용: 실제 사람 완전 회수 수, 설문 세션 수, 평균 난이도/판단 기준 명확성/결과 납득도/UI 가독성/10달러 가치감, 재플레이 의향, 판매 후보 판정, 조치 우선순위
- 현재 판정: 실제 사람 완전 회수 0건, 설문 세션 0건이므로 10달러 판매 후보 판단 보류
- 현재 조치 우선순위: 실제 사람 완전 회수 5명 이상, 판매 후보 근거 10명 이상, 설문 저장 누락 방지
- 회수 감사 로그: `Logs/audit_playtest_collection_commercial_triage_v030.log`, `completed=true`, `hasTriageOutputs=true`, `hasReadinessStatus=true`
- 릴리즈 README/manifest, Steam 제출 전 자체점검, 릴리즈 후보 감사 조건에 10달러 상용화 트리아지 리포트 QA를 반영
- Steamworks AppID/DepotID 치환 스크립트 추가: `Builds/Steamworks/v0.3.0/scripts/configure_steamworks_ids.ps1`, DryRun 검증 통과
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,526,322 bytes
- 릴리즈 SHA256: `9A6026DA5340AD352E66FE73E9F73B7172E3CB09DB8F9338652CF236F12F6410`
- Steamworks content manifest: 151 files, 162,211,577 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,547,930 bytes
- Steamworks 준비 폴더 SHA256: `FF88045B59CADDE7EAAF327B3855D79468F4F806B50F48AD626A4AE5138B3950`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,344,476 bytes
- 플레이테스트 배포 zip SHA256: `FAC1EE055818FF0D3F9B9D163A4CF7FAB1A0F49A74FE4AEF81C6410341B29F40`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_configure_ids_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `27/27`, 로컬 미해결 `0`, 외부 필수 항목 `8`

### 2026-05-28 지원 번들 export

- 설정 화면에 `지원 번들` 버튼과 U 단축키를 추가해 최신 로그, 세션 원본, 인게임 설문, 환경 진단, 저장 파일, manifest를 `support_bundles/<bundleId>` 폴더로 묶게 함
- 런타임 검증 로그: `Logs/runtime_support_bundle_v030.log`, `completed=true`
- QA 결과: `Builds/QA/v0.3.0/support_bundle/care_review_support_bundle_smoke_result.json`, 파일 28개, 최신 사본 13개, 세션 원본 10개, 저장 파일 3개, 로그/요약/HTML/환경 진단/설문 포함, manifest와 포함 파일 로컬 절대경로 미포함
- 릴리즈 README/manifest, 플레이테스트 패킷 안내문, Steam 제출 전 자체점검, 릴리즈 후보 감사 조건에 지원 번들 QA를 반영
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,529,499 bytes
- 릴리즈 SHA256: `E5024CFCD2B53B71BD6BD7ED6E2B7DB106E47FF8CD7A090EC5BB127972C70DD3`
- Steamworks content manifest: 151 files, 162,220,705 bytes
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,551,140 bytes
- Steamworks 준비 폴더 SHA256: `CC87D301ADD48EFB2A283410D21BEE955820DBA44E91BB9B449735F1EC748ED3`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,347,999 bytes
- 플레이테스트 배포 zip SHA256: `013F9E2B248E0DCCA92F51041516090207F17CF680C55F003BEA678909A8027E`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_support_bundle_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `28/28`, 로컬 미해결 `0`, 외부 필수 항목 `8`

### 2026-05-28 상용 콘텐츠 감사 export

- `-careReviewContentAuditSmokeTest` 실행 인자를 추가해 40개 사례의 일차 분포, 가족 유형, 권장 판단 5종, 비용/긴급도/형평성/서류 범위, 후속 메모와 엔딩 태그 완비 여부를 CSV/JSON/Markdown으로 검증
- 감사 산출물: `Builds/QA/v0.3.0/content_audit/care_review_content_audit.json`, `.csv`, `.md`, `care_review_content_audit_smoke_result.json`
- 콘텐츠 감사 결과: `completed=true`, `caseCount=40`, `highestDay=5`, `daysWithEightCases=5`, `familyTypeCount=40`, `recommendedDecisionTypeCount=5`, `passesCommercialContentGate=true`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_content_audit_v030.log`
- 콘텐츠 감사 런타임 로그: `Logs/runtime_content_audit_v030.log`
- Steamworks 준비 로그: `Logs/prepare_steamworks_content_audit_v030.log`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,533,388 bytes
- 릴리즈 SHA256: `D8F521330CD1DC1EFFB743DF68E0995549474479850E4253B73ABD32C393D6C1`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,555,068 bytes
- Steamworks 준비 폴더 SHA256: `C8E80754B79ABEAE489448CCF8F895E8CD56FA560CFCE86DEC8794415B3A6169`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,352,260 bytes
- 플레이테스트 배포 zip SHA256: `311D7A0D4C67C8E84B5DFBFCE8D092B59B8A4AF47262901A0AB7A05A3B5FDD4B`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_content_audit_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `29/29`, 로컬 미해결 `0`, 외부 필수 항목 `8`

### 2026-05-28 외부 검증 핸드오프 패킷

- `CareReviewProjectBuilder.BuildExternalValidationHandoff` 메뉴/배치 경로를 추가해 실제 사람 플레이테스트, SteamCMD preview, 비공개 브랜치 설치 QA, 저사양 PC 검증을 한 패킷으로 정리
- 새 산출물: `Builds/Handoff/v0.3.0/EXTERNAL_RELEASE_HANDOFF_KO.md`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`, `TESTER_RECRUITMENT_BATCH_KO.md`, `LOW_SPEC_PC_QA_CARD_KO.md`, `STEAM_PRIVATE_BRANCH_QA_CARD_KO.md`
- Steamworks 제출 폴더에도 외부 검증 핸드오프와 게이트 트래커를 복사하고, Steam 제출 전 자체점검에서 로컬 통과 항목으로 확인
- 외부 게이트를 10개로 명확화: 실제 사람 5명/10명 회수, AppID/DepotID 교체, SteamCMD preview, 비공개 브랜치, Steam 클라이언트 설치/재설치 QA, Store Presence, Achievements, 저사양 PC 검증
- Steamworks 준비 로그: `Logs/prepare_steamworks_external_handoff_v030_retry.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_external_handoff_final_package_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `30/30`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,561,670 bytes
- Steamworks 준비 폴더 SHA256: `E5861072B08A42EB4BCC41193DB16A559CD8E65CFB18CA326148766E9B38B31D`
- 외부 검증 핸드오프 zip 생성: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,270 bytes
- 외부 검증 핸드오프 SHA256: `44C9F6780C5A9833A97CB9EA1E626BA40B69354E0AB63080F005F14E5FE6DB37`

### 2026-05-28 개인정보/데이터 처리 고지

- Steamworks 제출 폴더용 개인정보 및 데이터 처리 고지 문서 추가: `Docs/Steam_개인정보_데이터_처리_고지.md`
- Steamworks `store_page` 복사본: `Builds/Steamworks/v0.3.0/store_page/PRIVACY_AND_DATA_NOTICE_KO.md`
- 고지 내용: 실제 개인정보 미수집, 합성 사례, 로컬에 생성되는 플레이 로그/설문/HTML 대시보드/환경 진단/지원 번들, 실제 판단 비대체 문구
- Steam 제출 전 자체점검과 릴리즈 후보 감사에 개인정보/데이터 고지 사본 동기화 검증 추가
- Steamworks 준비 로그: `Logs/prepare_steamworks_privacy_notice_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_privacy_notice_package_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `31/31`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,563,722 bytes
- Steamworks 준비 폴더 SHA256: `985220F0020D7B160E4AAE9351D8BF3F19E509253F565C2768F5087D30287D47`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,269 bytes
- 외부 검증 핸드오프 SHA256: `7EEBE76EBF3182EDB95E08763E62566088FD2DBD5E43A5195D350222ADE796AB`

### 2026-05-28 인게임 데이터 처리 고지 보강

- 크레딧/고지 본문에 로컬 저장, 서버 자동 업로드 없음, 환경 진단 CPU/GPU/RAM·FPS 샘플, 지원 번들 직접 생성/전달 범위를 추가
- 설정 상태, 로그 저장 완료, 환경 진단 완료, 지원 번들 완료 문구에 로컬 저장 전용과 공유 전 개인정보 확인 문구 추가
- 크레딧/고지 스모크 테스트 결과 항목 확장: `completed`, `mentionsNoAutomaticUpload`, `mentionsSystemDiagnosticData`, `mentionsSupportBundleData`, `filesHaveNoLocalAbsolutePath`
- 인게임 데이터 처리 고지 QA를 Steam 제출 전 자체점검과 릴리즈 후보 감사에 추가
- Windows 릴리즈 빌드 로그: `Logs/build_windows_privacy_notice_ingame_pathsafe_v030.log`
- 크레딧/고지 런타임 검증: `Logs/runtime_credits_privacy_notice_pathsafe_v030.log`, `Builds/QA/v0.3.0/care_review_credits_smoke_result.json`, `completed=true`, `filesHaveNoLocalAbsolutePath=true`
- Steamworks 준비 로그: `Logs/prepare_steamworks_privacy_notice_pathsafe_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_privacy_notice_pathsafe_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `32/32`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,533,860 bytes
- 릴리즈 SHA256: `CA423D0543F0EEC0A0FDDC4C30DB75FB49AEE9D8B9B33077AC1C03153B9E588A`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,564,235 bytes
- Steamworks 준비 폴더 SHA256: `DE270C5A07A2FA060B9F8507482DFD0C94C957670172CAA120160A2757E665A7`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,267 bytes
- 외부 검증 핸드오프 SHA256: `28D591B6F995CFE7006C3D7E2A1D0F6336B72E56837D7D30667BDBF738BACECD`

### 2026-05-28 로컬 데이터 삭제 기능

- 설정 화면에 `데이터 삭제` 버튼과 O 단축키를 추가해 저장 슬롯, 로그, 플레이테스트 세션 원본, 지원 번들, 성과/엔딩/캠페인 기록을 2단계 확인 후 삭제하도록 구성
- 삭제 범위는 `Application.persistentDataPath` 아래 게임 생성 파일과 지정된 생성 폴더로 제한하고, 무관 파일은 보존하도록 안전장치 추가
- 개인정보/데이터 처리 고지와 플레이테스트 안내에 로컬 데이터 삭제 흐름 반영
- 런타임 검증: `Logs/runtime_local_data_delete_v030.log`, `completed=true`
- QA 결과: `Builds/QA/v0.3.0/care_review_local_data_delete_smoke_result.json`, `confirmationArmed=true`, `managedFilesDeleted=true`, `managedDirectoriesDeleted=true`, `unrelatedFilePreserved=true`, `filesHaveNoLocalAbsolutePath=true`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_local_data_delete_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_local_data_delete_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_local_data_delete_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `33/33`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip 재생성: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,536,261 bytes
- 릴리즈 SHA256: `E5362A02904F07907DCC9853CA3054DFA9E8EACE784AC827CAFC41EC7B7F268E`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,566,858 bytes
- Steamworks 준비 폴더 SHA256: `DFED1B4C05F92FEC04D8AFE2FED36D48916227CE24318C2A3D2E828DAEDCD625`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,355,745 bytes
- 플레이테스트 배포 zip SHA256: `6174DA1521916A78EEF3EE0B69029AD95EEA35879D31250E99A58BB7DB532722`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,266 bytes
- 외부 검증 핸드오프 SHA256: `0FD0FD78293D8CF7A422C134A774D97F00BC33870066D815AEE68ADFF9753CF1`

### 2026-05-28 첫 실행 데이터/윤리 고지 및 최종 패키지 정렬

- 최초 실행 시 합성 사례, 실제 개인정보 미사용, 로컬 저장, 자동 업로드 없음, 지원 번들, 로컬 데이터 삭제, 실제 판단 비대체를 확인하는 데이터/윤리 고지 오버레이 추가
- 첫 실행 고지 스모크 테스트 추가: `-careReviewFirstRunNoticeSmokeTest`
- 첫 실행 고지 런타임 검증: `Logs/runtime_first_run_notice_v030.log`, `Builds/QA/v0.3.0/care_review_first_run_notice_smoke_result.json`, `completed=true`, `noticeActiveBeforeAccept=true`, `preferenceSaved=true`, `noticeHiddenAfterAccept=true`, `menuVisibleAfterAccept=true`, `mentionsNoAutomaticUpload=true`, `mentionsLocalDataDelete=true`, `mentionsNotAdvice=true`
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_first_run_notice_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_first_run_notice_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_first_run_notice_final_v030.log`
- 플레이테스트 패킷 내부 `README_KO.txt`와 `COLLECTION_CHECKLIST_KO.md`의 릴리즈 zip SHA를 최신 값으로 정렬
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_first_run_notice_final2_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `34/34`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,537,882 bytes
- 릴리즈 SHA256: `534619B35E0089801A8128CDBA4BAC3F73F6ECC514A0F83B677E2770283F8105`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,568,657 bytes
- Steamworks 준비 폴더 SHA256: `9DAD6B92E286C5692316532389A3A80E7D8E000B5139BE366AA4191E56B086B9`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,357,883 bytes
- 플레이테스트 배포 zip SHA256: `63E6C98A847E2C683D0A244181588DE1FEDDFAF63CA02087BD5453E7E524538D`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,268 bytes
- 외부 검증 핸드오프 SHA256: `5781499A9C4CEB2E0A54394135A7988C40AD8FB1A7D28956F947F10499582E9C`

### 2026-05-28 데이터 소스 무결성 QA

- 런타임 인자 `-careReviewDataSourceSmokeTest`를 추가해 사례 데이터와 에이전트 성향이 외부 JSON 리소스에서 정상 로드되는지 검증
- 검증 대상: `Assets/Resources/Data/cases_day1~5.json`, `Assets/Resources/Data/agent_personas.json`, 런타임 사례 목록, embedded fallback 사용 여부, 로컬 절대경로 노출 여부
- 데이터 소스 런타임 검증: `Logs/runtime_data_source_integrity_v030.log`, `Builds/QA/v0.3.0/care_review_data_source_smoke_result.json`, `completed=true`
- 데이터 소스 감사 결과: `Builds/QA/v0.3.0/care_review_data_source_audit.json`, `Builds/QA/v0.3.0/care_review_data_source_audit.md`, `caseFileCount=5`, `externalCaseCount=40`, `runtimeCaseCount=40`, `personaCount=10`, `casesLoadedFromExternalJson=true`, `embeddedFallbackUsed=false`, `passesDataSourceGate=true`, `filesHaveNoLocalAbsolutePath=true`
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_data_source_integrity_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_data_source_integrity_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_data_source_integrity_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_data_source_integrity_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `35/35`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,540,766 bytes
- 릴리즈 SHA256: `08DC1746F4363A89B3EE012787E3AFF92D089632D2E5972BBD569C58DF6012C0`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,571,589 bytes
- Steamworks 준비 폴더 SHA256: `9AC9F85DE195F02376EF090C64108DB9EE4E8EF36E9F38E41ED61350064EF3E5`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,360,144 bytes
- 플레이테스트 배포 zip SHA256: `F46C0C772B90277651CB0A4F47C55C572981C79173B60E8AE5E36080C5EAD01F`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,271 bytes
- 외부 검증 핸드오프 SHA256: `F0EA82D4604490B55FDFDEE81A4A7C9794542C3910B2E7D5E5A93AE4EA712A33`

### 2026-05-28 Steam 마케팅 자산 감사 QA

- Unity 에디터 메뉴/배치 메서드 `Care Review Office/Audit Steam Marketing Assets`와 `CareReviewProjectBuilder.AuditSteamMarketingAssets` 추가
- 감사 대상: 상점 스크린샷 7장, Steam 캡슐/라이브러리 자산 9장, 트레일러 프레임 12장, Steam 업로드 후보 트레일러, 그래픽 자산 zip, 트레일러 자산 zip, 텍스트 manifest의 로컬 절대경로 노출 여부
- `steam_assets_manifest.txt`의 생성 원본 사용자 로컬 경로와 `trailer_sequence_v030.txt`의 절대 경로를 상대/비식별 경로로 정리
- Steam 그래픽 자산 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_steam_graphic_assets_v0.3.0.zip`, 16,969,400 bytes
- Steam 그래픽 자산 zip SHA256: `7DFF65E9201A712A5E19DFC6AD5EEEC305A14D6C6CA81977CB6BC986AD162745`
- 트레일러 자산 zip 재생성: `Builds/Marketing/v0.3.0/care_review_office_trailer_assets_v0.3.0.zip`, 72,297,278 bytes
- 트레일러 자산 zip SHA256: `A39FC963273A07EE1E8DD775AAE80144AD58697AAC7C46B8A0387A1E77B2D8AE`
- 마케팅 자산 감사 실행 로그: `Logs/audit_marketing_assets_repacked_v030.log`
- 마케팅 자산 QA 결과: `Builds/QA/v0.3.0/marketing_assets/care_review_marketing_asset_smoke_result.json`, `completed=true`, `passesMarketingAssetGate=true`, `screenshotCount=7`, `validScreenshotCount=7`, `capsuleAssetCount=9`, `validCapsuleAssetCount=9`, `trailerFrameCount=12`, `validTrailerFrameCount=12`, `filesHaveNoLocalAbsolutePath=true`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_marketing_assets_final2_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `36/36`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,569,388 bytes
- Steamworks 준비 폴더 SHA256: `CD7BCB0077B48A944FBF1BFA87A91EB5C780E9D909183BEFFC95EA00396F802C`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,185 bytes
- 외부 검증 핸드오프 SHA256: `3A1E350D216D7A41C64A20619CCFBEB8E690766F32A3EFFAC585869344A50707`

### 2026-05-28 저장 백업/복구 QA

- 저장 포맷 버전 상수 `SaveDataVersion=2` 추가
- 저장 시 기존 기본 저장을 `.bak`으로 백업하고 임시 파일을 거쳐 기본 저장을 교체하도록 저장 안정성 강화
- 로드 시 기본 저장이 없거나 손상되면 `.bak` 백업을 검증해 복구하고 기본 저장 파일을 다시 복원하도록 처리
- 선택 슬롯 삭제 시 기본 저장과 `.bak` 백업을 함께 삭제하도록 정리
- 로컬 데이터 삭제 스모크 테스트가 `.bak` 저장 백업도 게임 생성 파일로 삭제하는지 검증하도록 확장
- 저장 복구 스모크 테스트 추가: `-careReviewSaveRecoverySmokeTest`
- 저장 복구 런타임 검증: `Logs/runtime_save_recovery_v030.log`, `Builds/QA/v0.3.0/care_review_save_recovery_smoke_result.json`, `completed=true`, `firstSaveWritten=true`, `backupCreated=true`, `secondSaveWritten=true`, `corruptedPrimaryRejected=true`, `recoveredFromBackup=true`, `primaryRestored=true`, `backupPreserved=true`, `versionCurrent=true`, `filesHaveNoLocalAbsolutePath=true`
- 세이브 슬롯 삭제 재검증: `Logs/runtime_save_slot_delete_v030.log`, `saveBackupGenerated=true`, `saveBackupDeleted=true`
- 로컬 데이터 삭제 재검증: `Logs/runtime_local_data_delete_v030.log`, `managedFilesDeleted=true`, `filesDeleted=4`
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_save_recovery_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_save_recovery_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_save_recovery_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_save_recovery_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `37/37`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,532,565 bytes
- 릴리즈 SHA256: `36627BBE62482BF2EAD2F8277436C2689D59B9BFAE8ABA101F69D1E37AC800A0`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,571,118 bytes
- Steamworks 준비 폴더 SHA256: `B6F074A932BED2E88B2F48EA6D3057BDCD8676A142469153218C0278747D3E31`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,360,245 bytes
- 플레이테스트 배포 zip SHA256: `3053A6C87B00E5B7739D9BC4230E2F2C3F1A12D9C777AC295B369C7BE3860C1A`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,182 bytes
- 외부 검증 핸드오프 SHA256: `1439BC069B7A76036F162E336D3C7EDCA8ABC675DC9ED5349BFD91906CE8EADE`

### 2026-05-28 런타임 이슈 로그 및 지원 번들 보강

- `Application.logMessageReceived` 기반으로 Warning/Error/Exception을 최대 30건까지 JSON/Markdown으로 기록하는 런타임 이슈 로그를 추가
- 메시지와 스택에서 `C:/Users`, `AppData`, `LocalLow`, `Application.persistentDataPath`를 익명화해 외부 공유 시 로컬 절대경로가 노출되지 않도록 처리
- 지원 번들 export가 `care_review_runtime_issues.json`/`.md`를 포함하고 manifest에 `hasRuntimeIssues`를 기록하도록 확장
- 런타임 이슈 로그 스모크 테스트 추가: `-careReviewRuntimeIssueSmokeTest`
- 런타임 이슈 검증: `Logs/runtime_issue_log_v030.log`, `Builds/QA/v0.3.0/care_review_runtime_issue_smoke_result.json`, `completed=true`, `hasJson=true`, `hasMarkdown=true`, `messageSanitized=true`, `stackSanitized=true`, `supportBundleHasRuntimeIssues=true`, `filesHaveNoLocalAbsolutePath=true`
- 지원 번들 재검증: `Logs/runtime_support_bundle_v030.log`, `Builds/QA/v0.3.0/support_bundle/care_review_support_bundle_smoke_result.json`, 파일 31개, 최신 사본 15개, 세션 원본 10개, 저장 파일 4개, 런타임 이슈 로그 포함
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_runtime_issue_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_runtime_issue_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_runtime_issue_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_runtime_issue_after_final_zip_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `38/38`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,535,457 bytes
- 릴리즈 SHA256: `4753E536B4D4D20D33833BC56238F15AEFF886F5CF70ADAACE7BE5620404FD95`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,574,045 bytes
- Steamworks 준비 폴더 SHA256: `B70A6260D24A101AD726D031254B57D7CECA33C514DC3D115E9B04CA4C14A43D`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,363,259 bytes
- 플레이테스트 배포 zip SHA256: `CBA867A09D89F2A1643333302DC5CD99D734B41C2066237AC4738A65093E2399`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,185 bytes
- 외부 검증 핸드오프 SHA256: `0C8CD0A82EFE0667713D491575F277D816F1987B919FB9C3E520C583BDE4B117`

### 2026-05-28 컨트롤러 단축 입력 QA

- 키보드 단축키를 유지하면서 별도 컨트롤러 입력 경로를 추가해 A/B/X/Y/LB/RB/View/Menu 버튼으로 확인, 뒤로, 다섯 판단, 기록, 저장, 기준 전환을 보조
- 설정 화면 상태 안내에 컨트롤러 기본 매핑을 추가하고 릴리즈 README/manifest에 컨트롤러 단축 입력과 검증 인자를 반영
- 컨트롤러 단축 입력 스모크 테스트 추가: `-careReviewControllerShortcutSmokeTest`
- 컨트롤러 검증: `Logs/runtime_controller_shortcut_v030.log`, `Builds/QA/v0.3.0/care_review_controller_shortcut_smoke_result.json`, `completed=true`, `settingsMentionsController=true`, `guideMentionsDecisionSet=true`, `submitPathCreatesDecision=true`, `nextPathAvailable=true`, `filesHaveNoLocalAbsolutePath=true`
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_controller_shortcut_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_controller_shortcut_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_controller_shortcut_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/audit_release_candidate_controller_shortcut_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `39/39`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,536,808 bytes
- 릴리즈 SHA256: `FBEE59F8CC4EA32CDB0FE2CDC74D88D1723A3566D65F81DD950281DFFAF496A5`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,575,437 bytes
- Steamworks 준비 폴더 SHA256: `3D820A8ED8250A06D69BA3B6D88CE20A179E90250DE43742392E2F6BA2FF97C3`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,364,837 bytes
- 플레이테스트 배포 zip SHA256: `7402980B24F9E3EF0FB28DDC3820589EA686CE877C4986BB1DC58DA14D4599DA`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,184 bytes
- 외부 검증 핸드오프 SHA256: `11E1512299C3BA6A79B44678769A8DA33D8B4AED80B29B233CA85C08C999405E`

### 2026-05-28 컨트롤러 포커스 하이라이트 QA

- 모든 텍스트 버튼과 심사 도장 버튼에 컨트롤러 선택 외곽선을 추가하고, 화면 전환 시 현재 활성 화면의 첫 조작 버튼을 기본 선택하도록 보강
- 기본 선택 대상 검증: 설정 `큰 글자 전환`, 메인 메뉴 `새 캠페인`, 심사 화면 `메뉴`, 심사 기록 오버레이 `로그 저장`
- 컨트롤러 포커스 이동 스모크 테스트 추가: `-careReviewFocusNavigationSmokeTest`
- 포커스 검증: `Logs/runtime_focus_navigation_v030.log`, `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `completed=true`, `settingsHasSelection=true`, `menuHasSelection=true`, `reviewHasSelection=true`, `overlayHasSelection=true`, `settingsHasFocusHighlight=true`, `menuHasFocusHighlight=true`, `reviewHasFocusHighlight=true`, `overlayHasFocusHighlight=true`, `selectionStaysInsideActiveRoot=true`, `filesHaveNoLocalAbsolutePath=true`
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_focus_navigation_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_focus_navigation_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_focus_navigation_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/release_candidate_audit_focus_navigation_package_hash_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `40/40`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,548,641 bytes
- 릴리즈 SHA256: `1CBDBBA105F393C04221010AEADCA32BE411A5AA7E6A05122E1311FDF0420E22`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,579,924 bytes
- Steamworks 준비 폴더 SHA256: `66418CDC46754009A853F48F928D637BA7F59CE4B8089BCB036C6FE302D4505E`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,367,702 bytes
- 플레이테스트 배포 zip SHA256: `BF55D55D8E11EFC5FFD7854B177F3FBAE13E7BA3A1C0A7D37900C84BB97160F8`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,267 bytes
- 외부 검증 핸드오프 SHA256: `2B8BCAB7BCAB37EF598A417DC9A76024AC219417AD8379C95E85B45679779D99`

### 2026-05-28 플레이테스트 회수 준비 체크 QA

- 최종 리포트의 `테스터 설문` 화면에 `회수 준비` 상태 줄을 추가해 판단 35건 이상, 인게임 설문, 로그 패킷, 환경 진단, 로컬 절대경로 미포함 여부를 즉시 확인할 수 있게 보강
- 설문 저장/로그 저장 이후 상태 문구가 `설문 OK`, `로그 OK`, `환경 진단 필요/환경 OK`, `회수 완료`로 바뀌도록 구성해 외부 테스터가 누락 파일을 줄일 수 있게 함
- 플레이테스트 회수 준비 스모크 테스트 추가: `-careReviewPlaytestReadinessSmokeTest`
- 회수 준비 검증: `Logs/runtime_playtest_readiness_v030.log`, `Builds/QA/v0.3.0/care_review_playtest_readiness_smoke_result.json`, `completed=true`, `beforeShowsMissingFiles=true`, `afterReadyForCollection=true`, `hasMinimumDecisionCount=true`, `hasSurveyFiles=true`, `hasPlaytestPacketFiles=true`, `hasDiagnosticFiles=true`, `filesHaveNoLocalAbsolutePath=true`
- 인게임 설문 재검증: `Logs/runtime_playtest_survey_steamworks_v030.log`, `Builds/QA/v0.3.0/care_review_playtest_survey_smoke_result.json`, `completed=true`
- 전체 실행 스모크 재검증: `Logs/runtime_smoke_playtest_readiness_v030.log`, `Builds/QA/v0.3.0/care_review_smoke_result.json`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`
- Windows 릴리즈 빌드 로그: `Logs/build_windows_playtest_readiness_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_playtest_readiness_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/release_candidate_audit_playtest_readiness_package_hash_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `41/41`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,550,617 bytes
- 릴리즈 SHA256: `CBBA28C64EBCCF8086100A5F72E80A16709BBCC721F408A0594635373BE6140A`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,581,930 bytes
- Steamworks 준비 폴더 SHA256: `50630C4D5F5703F047CFBE08E72238338AD4F9CFBA8583C94D9A9FBDD85B7C7D`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,370,617 bytes
- 플레이테스트 배포 zip SHA256: `E2EED1AD26FEF201A4830AABD98BF9C7FB1F419F7F67B8CD24F7D7C30DFFECA6`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,265 bytes
- 외부 검증 핸드오프 SHA256: `C529AA000D1DA7E63C62F3864E891674863B6CCDD57B35BCCA4B90EE1E6FD83A`

### 2026-05-28 지원 번들 기반 플레이테스트 회수 감사

- `CareReviewProjectBuilder.AuditPlaytestCollection`이 `Builds/Playtest/CollectedSessions`의 외부 회수 세션, `Builds/QA/v0.3.0/playtest_packet/playtest_sessions`의 QA 샘플, `Builds/QA/v0.3.0/support_bundle`의 QA 지원 번들을 함께 점검하도록 보강
- 지원 번들 행에 `receivedViaSupportBundle`, `supportBundleName`, `hasSupportBundleManifest`, `supportBundleHasRuntimeIssues`, `supportBundleFilesHaveNoLocalAbsolutePath`를 기록하고, 번들 기반 세션은 manifest/런타임 이슈 로그/경로 비식별화까지 완전 회수 조건에 포함
- 실제 사람 플레이테스트 기준은 `externalCompleteSessionCount`로 따로 계산해 QA 샘플이나 QA 지원 번들이 5명/10명 회수 기준을 대신 충족하지 않도록 분리
- 회수 감사 실행 로그: `Logs/audit_playtest_collection_support_bundle_v030.log`, `sessions=77`, `complete=1`
- 회수 감사 결과: `supportBundleSessionCount=2`, `supportBundleManifestCount=2`, `supportBundleRuntimeIssueCount=1`, `completeSessionCount=1`, `externalCompleteSessionCount=0`, `readyForBalanceTuning=false`, `readyForCommercialTuning=false`
- 플레이테스트 QA 패킷, Steamworks 업로드 준비, 릴리즈 패키징 체크리스트, 플레이테스트 회수 inbox 안내에 `support_bundles/<bundleId>` 회수와 manifest/런타임 이슈 로그 확인 기준 반영
- Windows 릴리즈 빌드 로그: `Logs/build_windows_support_bundle_collection_v030.log`, `Build Finished, Result: Success`
- Steamworks 준비 로그: `Logs/prepare_steamworks_support_bundle_collection_v030.log`
- 릴리즈 후보 감사 실행 로그: `Logs/release_candidate_audit_support_bundle_collection_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `41/41`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,550,632 bytes
- 릴리즈 SHA256: `DD08FA8883D5624241616893A06E22EDE26B2D4A4C148626D71B66295EDF22FC`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,581,967 bytes
- Steamworks 준비 폴더 SHA256: `4AD5B54B51EFC31F6A5D2A8E1F21FDFEFC54D7F0615564B1134DE783EEB1A430`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,371,007 bytes
- 플레이테스트 배포 zip SHA256: `2335EC6E8CA39C1181AB3F8C730347DD77EFE864711973AC8B9272C1AE6BBDD2`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 6,289 bytes
- 외부 검증 핸드오프 SHA256: `D48601976AD3F46E1D26FDAB0CBF69D2782693F330AAA8E75EE49C18A835A222`

### 2026-05-28 외부 릴리즈 게이트 증거 감사

- Unity 메뉴/배치 메서드 `CareReviewProjectBuilder.AuditExternalReleaseGates` 추가
- 새 산출물: `Builds/QA/v0.3.0/external_gate_audit/care_review_external_gate_audit_summary.json`, `.csv`, `.md`, `care_review_external_gate_audit_smoke_result.json`
- 외부 증거 폴더 추가: `Builds/Handoff/v0.3.0/Evidence/README_KO.md`, `Builds/Handoff/v0.3.0/Evidence/_templates/<GATE_ID>.md`
- 게이트 범위: 실제 사람 플레이테스트 5명/10명, 실제 AppID/DepotID 치환, SteamCMD preview, Steam 비공개 브랜치 실행, Steam 클라이언트 설치/재설치, Store Presence, Steam 업적 후보 입력, 실제 저사양 PC 검증
- 자동 판정 대상: `playtest_collection_audit_summary.json`의 `externalCompleteSessionCount`, AppID/DepotID placeholder 제거 여부, `Builds/Steamworks/v0.3.0/output`의 SteamCMD preview 성공 로그
- 수동 증거 대상: `Evidence/<GATE_ID>.md`에서 `status: passed`와 필수 키워드/증거 경로를 확인
- 외부 게이트 감사 실행 로그: `Logs/audit_external_release_gates_v030.log`, `passed=0/10`, `pendingGateCount=10`, `steamPublicReleaseReady=false`
- 릴리즈 후보 감사 연결: `Logs/release_candidate_audit_external_gate_evidence_package_hash_v030.log`, 로컬 체크 `42/42`, 외부 필수 항목 `10`, Steam 공개 출시는 계속 `not ready`
- Steam 제출 전 자체점검 문서의 매 실행 시각 줄을 고정 생성 기준 문구로 바꿔 감사 재실행만으로 Steamworks 패키지 내용이 불필요하게 달라지지 않도록 정리
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,582,044 bytes
- Steamworks 준비 폴더 SHA256: `327D5544ADFAFFDC7B1FC2ECF572C31CE51DC9726EBFF33AB313AB5E7F115965`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 12,536 bytes
- 외부 검증 핸드오프 SHA256: `8C9F109AF842012EB194ABC0444562415E3A9D19E5B5F92ED659FD89470D1784`

### 2026-05-28 선택지 미리보기 및 패키지 해시 동기화

- 심사 화면의 다섯 판단 도장 위에 선택지 미리보기 줄을 추가해 `승인/조건부 승인/보류/추가조사/거절`의 즉시 예산 변화와 위험 변화를 선택 전에 비교할 수 있게 보강
- 권장 판단과 기존 권장 판단 호환 규칙에 맞는 선택지를 하이라이트해 초반 판단 기준 이해도를 높이고, 결정 직후 권장 판단 비교 피드백으로 이어지도록 구성
- 선택지 미리보기 스모크 테스트 추가: `-careReviewDecisionPreviewSmokeTest`
- 선택지 미리보기 검증: `Logs/runtime_decision_preview_v030.log`, `Builds/QA/v0.3.0/care_review_decision_preview_smoke_result.json`, `completed=true`, `previewCount=5`, `everyPreviewMentionsBudget=true`, `everyPreviewMentionsRisk=true`, `recommendedHighlighted=true`
- 플레이테스트 패킷 내부 `README_KO.txt`와 `COLLECTION_CHECKLIST_KO.md`의 릴리즈 실행 zip SHA256을 최신 값으로 동기화
- 릴리즈 후보 감사 실행 로그: `Logs/release_candidate_audit_package_hash_sync_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `43/43`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,551,877 bytes
- 릴리즈 SHA256: `9392399536BFA73BEE6D451B99EA3BBEB5044807F7E5731DF2F8FDB0C2ACF560`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,372,434 bytes
- 플레이테스트 배포 zip SHA256: `5EC438FA98A350FF634DA6DE6EB1332808A58BFB205E4ABE48DB166DC3DA5A91`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,583,327 bytes
- Steamworks 준비 폴더 SHA256: `84183C71566311739E72743C2F9AB974CB8A30F241C442B09366D6BBD371FFDD`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 12,538 bytes
- 외부 검증 핸드오프 SHA256: `BB683A88429302E2472ADF02223CAEF6D6A2423E75870DD1FC93E69DEA4956DF`

### 2026-05-28 플레이테스트 설문 가치감 집계 연결

- 플레이테스트 세션 집계가 각 `playtest_sessions/<sessionId>` 폴더의 `care_review_in_game_feedback.json`을 함께 읽어 세션별 설문 결과를 CSV/JSON/Markdown 집계에 합치도록 보강
- 새 집계 컬럼: `has_survey_ratings`, `difficulty_rating`, `decision_clarity_rating`, `result_fairness_rating`, `ui_readability_rating`, `price_value_rating`, `difficulty_too_high`, `ui_needs_work`, `case_explanation_needed`, `replay_intent`
- Markdown 집계에 `설문/가격 가치감` 섹션을 추가해 설문 회수 세션 수, 평균 난이도/명확성/납득도/UI/10달러 가치감, 다시 플레이 의향, 낮은 가치감/명확성/UI 보강 필요 신호를 표시
- 플레이테스트 집계 스모크 테스트 보강: `Logs/runtime_playtest_aggregate_survey_value_retry_v030.log`
- QA 결과: `Builds/QA/v0.3.0/playtest_packet/care_review_playtest_aggregate_smoke_result.json`, `completed=true`, `surveySessionCount=5`, `csvHasSurveyColumns=true`, `jsonHasSurveyAverages=true`, `markdownMentionsSurvey=true`
- 릴리즈 후보 감사 실행 로그: `Logs/release_candidate_audit_playtest_survey_aggregate_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `43/43`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,553,224 bytes
- 릴리즈 SHA256: `D03381487ECD89B2565B9079A6A6208B674A5EB89D73E4E88A6D677B7162A74E`
- 플레이테스트 배포 zip 갱신: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,373,768 bytes
- 플레이테스트 배포 zip SHA256: `FC03BAB15476FFC2B79533ACE7D593238C0766C7A1FF3835C12DEB132455D420`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,584,675 bytes
- Steamworks 준비 폴더 SHA256: `8DE4E2591BB994C1D1BD7889E5149A006C3FACAE049C08B6615A96B828B1B904`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 12,538 bytes
- 외부 검증 핸드오프 SHA256: `9A3D48DFA3D66085DA6DEB983E3957E3721A0952E2EB4B395959A3FE8109BC52`

### 2026-05-28 배포 패킷 무결성 QA

- Unity 메뉴/배치 메서드 `CareReviewProjectBuilder.AuditDistributionIntegrity` 추가
- 새 산출물: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `.csv`, `.md`, `care_review_distribution_integrity_smoke_result.json`
- 검증 범위: 릴리즈 zip, 플레이테스트 kit zip, Steamworks zip, 외부 검증 handoff zip의 SHA256 기록 일치, 플레이테스트 내부 실행 zip/안내문 SHA 동기화, Steamworks/handoff 문서와 사람이 보는 업로드 문서의 최신 해시 반영
- 배포 패킷 무결성 감사 실행 로그: `Logs/audit_distribution_integrity_final_v030.log`
- 배포 패킷 무결성 감사 결과: `completed=true`, `allPassed=true`, `checkCount=13`, `passedCheckCount=13`
- 릴리즈 후보 감사 연결 로그: `Logs/release_candidate_audit_distribution_integrity_final_v030.log`
- 감사 결과: `localReleaseCandidateReady=true`, `steamPublicReleaseReady=false`, 로컬 체크 `44/44`, 로컬 미해결 `0`, 외부 필수 항목 `10`
- 릴리즈 zip: `Builds/Release/CareReviewOffice_Windows_v0.3.0.zip`, 75,553,224 bytes
- 릴리즈 SHA256: `D03381487ECD89B2565B9079A6A6208B674A5EB89D73E4E88A6D677B7162A74E`
- 플레이테스트 배포 zip: `Builds/Playtest/CareReviewOffice_PlaytestKit_v0.3.0.zip`, 75,373,768 bytes
- 플레이테스트 배포 zip SHA256: `FC03BAB15476FFC2B79533ACE7D593238C0766C7A1FF3835C12DEB132455D420`
- Steamworks 준비 폴더 zip 재생성: `Builds/Steamworks/CareReviewOffice_Steamworks_v0.3.0.zip`, 75,584,674 bytes
- Steamworks 준비 폴더 SHA256: `4B6561B364E5DBC208C3DEFDE02A6D217C9DA4CB0FCB5EA33C72B32116B7E557`
- 외부 검증 핸드오프 zip 갱신: `Builds/Handoff/CareReviewOffice_ExternalValidationHandoff_v0.3.0.zip`, 12,537 bytes
- 외부 검증 핸드오프 SHA256: `1DC11E44C0EC8CCABA45B1081382A6CFE39055BA0A23DE08A3C8FF798B7B7C1B`

### 2026-05-29 버튼/튜토리얼/UI 정리 2차 반복

- 서브에이전트 2차 리뷰에서 지적된 `모든 버튼이 같은 크롬으로 보여 역할 구분이 약함`, `첫 사례 안내 하이라이트가 내용을 덮음`, `최종 리포트 하단 액션이 같은 무게로 쌓임`, `첫 실행 고지 클릭 차단 누락`, `저해상도 QA가 무조건 통과` 문제를 반영
- 텍스트 버튼에 `Primary/Secondary/Utility/Analysis/Export/Danger` 역할을 부여하고, 주 행동만 좌측 액센트를 강하게 표시하도록 변경
- 메인 메뉴는 `새 캠페인`만 주 행동으로 남기고 `이어하기`는 보조 행동으로 낮춤
- 최종 리포트 하단에 액션 레일과 주 행동 도크를 추가하고 `추천 심사 시작: <운영 기준>`을 하나의 긴 주 버튼으로 정리
- 첫 사례 안내는 입력 차단은 유지하되 카드 위치를 도장 영역 위로 올리고 하이라이트 면 채도를 낮춰 신청서 읽기를 덜 방해하도록 조정
- 첫 실행 데이터/윤리 고지의 배경 dim을 실제 raycast 차단 이미지로 바꿔 메뉴 클릭이 뒤로 통과하지 않도록 수정
- `-careReviewDecisionPreviewSmokeTest`를 자동화 실행 인자 목록에 추가해 첫 실행 고지/오토세이브 상태와 분리
- 저해상도 UI QA를 27장 캡처에서 33장 캡처로 확장하고, 첫 실행 고지/첫 사례 가이드 포함, 스크린샷 누락, 버튼 글자 넘침, 화면 밖 버튼 수를 JSON에서 판정하도록 보강
- 신규 QA 결과: `Builds/QA/v0.3.0/care_review_ui_cleanup_smoke_result.json`, `completed=true`, `buttonRoleHierarchyApplied=true`, `menuPrimaryCount=1`, `reportPrimaryCount=1`, `utilityAccentCount=0`
- 첫 실행 고지 QA 결과: `Builds/QA/v0.3.0/care_review_first_run_notice_smoke_result.json`, `noticeBlocksUnderlyingInput=true`
- 저해상도 UI QA 결과: `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`
- 검증 로그: `Logs/build_windows_ui_cleanup_v036.log`, `Logs/runtime_ui_cleanup_smoke_v036.log`, `Logs/runtime_low_resolution_ui_cleanup_v036.log`, `Logs/runtime_first_run_notice_ui_cleanup_v036.log`, `Logs/runtime_decision_preview_ui_cleanup_v036.log`
- 상점 스크린샷 7장을 최신 UI로 재캡처해 `Builds/Marketing/v0.3.0/screenshots`에 동기화

### 2026-05-29 이미지 생성 기반 버튼/패널 UI 키트 적용

- Steam 출시작 UI 기준 비교: `Papers, Please`는 심사대/서류/도장 자체가 조작 UI가 되고, `Death and Taxes`는 책상 위 문서와 권한 있는 버튼 질감이 세계관을 만든다. `Strange Horticulture`와 `Orwell`은 조사/기록 게임답게 패널, 탭, 문서 표면을 일반 사각형보다 강하게 사용한다.
- 현재 빌드의 약점이던 단색 `Image` 버튼을 이미지 생성 기반 금속/문서/에나멜 플레이트로 교체했다.
- 생성 원본: `Assets/Resources/Art/ui_chrome_sheet_generated_source.png`
- 프로젝트 적용 자산: `ui_button_primary_generated.png`, `ui_button_secondary_generated.png`, `ui_button_utility_generated.png`, `ui_button_danger_generated.png`, `ui_button_analysis_generated.png`, `ui_action_rail_generated.png`, `ui_panel_paper_generated.png`, `ui_panel_modal_generated.png`, `ui_hotkey_badge_generated.png`, `ui_button_tab_generated.png`
- 모든 텍스트 버튼은 역할별 생성 스프라이트를 9-slice 방식으로 사용하고, 심사 도장의 핫키 배지/라벨 배지도 생성 자산으로 교체했다.
- 주요 종이 패널, 헤더, 액션 레일, 카드에는 생성 자산 프레임을 오버레이해 색상 사각형 느낌을 줄였다.
- 생성 UI 적용 QA: `Builds/QA/v0.3.0/care_review_ui_cleanup_smoke_result.json`, `completed=true`, `generatedUiChromeApplied=true`, `generatedButtonChromeCount=54`, `generatedPanelChromeCount=16`
- 저해상도 UI QA: `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`
- 포커스 QA: `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `completed=true`
- 선택지 미리보기 QA: `Builds/QA/v0.3.0/care_review_decision_preview_smoke_result.json`, `completed=true`
- 검증 로그: `Logs/build_windows_generated_ui_v001.log`, `Logs/runtime_ui_cleanup_generated_ui_v001.log`, `Logs/runtime_low_resolution_generated_ui_v002.log`, `Logs/runtime_focus_navigation_generated_ui_v001.log`, `Logs/runtime_decision_preview_generated_ui_v001.log`
- 상점 스크린샷 7장과 저해상도 QA 스크린샷 33장을 생성 UI 적용 후 재캡처해 동기화했다.

### 2026-05-29 가독성/텍스트 박스/튜토리얼 암막 정리

- 전체 `TextMeshProUGUI` 기본 보정값을 올려 일반 본문은 2pt, 작은 보조문은 1pt씩 더 크게 보이도록 조정했다.
- 텍스트 박스에도 생성 UI 크롬을 덧씌워 종이 문서, 모달, 어두운 보조 패널이 단색 사각형처럼 보이지 않게 정리했다.
- 메인 메뉴의 주 행동은 `새 캠페인 시작` 하나로 고정하고, `기록 보기`, 설정, 종료, 슬롯/삭제를 같은 레일 안에 재배치해 첫 화면에서 해야 할 일을 더 분명히 했다.
- 심사 화면 상단의 `도움말` 상시 버튼을 걷어내고 `메뉴`, `기록`, `연락`, `근거`, `기준표`, `저장`만 남겼다. 하단 선택지 미리보기는 도장 위의 긴 비교 스트립으로 키워 예산/위험 변화를 바로 읽게 했다.
- 최종 리포트 하단은 `추천 심사 시작`을 주 행동으로 두고, 메인 메뉴/로그 저장/결정 감사/에이전트 분석은 보조 행동으로 정리했다.
- 첫 사례 튜토리얼은 4개의 반투명 검정 마스크로 화면을 덮고, 현재 단계에서 봐야 하는 신청서/서류/지표/판정 영역만 구멍처럼 남기는 스포트라이트 방식으로 바꿨다.
- 신규 QA 결과: `Builds/QA/v0.3.0/care_review_ui_cleanup_smoke_result.json`, `completed=true`, `firstGuideUsesSpotlightMask=true`, `firstGuideSpotlightMaskCount=4`, `generatedTextBoxChromeCount=36`, `menuPrimaryCount=1`, `reportPrimaryCount=1`, `reportDenseTextReadable=true`, `reportDenseTextMinimumFontSize=14`
- 저해상도 UI QA 결과: `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`
- 추가 검증 로그: `Logs/build_windows_readability_layout_v004.log`, `Logs/runtime_ui_cleanup_readability_layout_v004.log`, `Logs/runtime_focus_navigation_readability_layout_v004.log`, `Logs/runtime_decision_preview_readability_layout_v004.log`, `Logs/runtime_low_resolution_readability_layout_v004_windowed.log`
- 최신 상점 스크린샷 7장과 첫 사례 가이드 캡처를 `Builds/Marketing/v0.3.0/screenshots`에 재동기화했다.

### 2026-05-31 에이전트 실험실 10인 확장

- 사용자의 현재 목표를 `제출 정리`가 아니라 `Steam에서 20달러 이상으로 팔 수 있을 정도의 게임 퀄리티` 확장으로 재정렬했다.
- `Assets/Resources/Data/agent_personas.json`의 가상 플레이어 에이전트를 5종에서 10종으로 확장했다.
- 신규 성향: 민원 회피형, 아동 안전형, 절차 우선형, 회복 가능성형, 권고 추종형.
- 임베디드 fallback 페르소나도 같은 10종으로 맞춰 JSON 로딩 실패 시에도 분석 폭이 줄지 않도록 했다.
- 에이전트 분석 대시보드를 5행 단일열에서 10명 표시용 2열 레이아웃으로 개편했다.
- 10명 에이전트가 같은 사례를 어떻게 다르게 판단했는지 자동 집계하는 `논쟁 사례 큐`를 추가했다. 대시보드에는 상위 3건, 에이전트 JSON export에는 상위 5건 요약을 저장한다.
- 대시보드 요약 문구가 실제 에이전트 수를 표시하도록 수정하고, QA/릴리즈 후보 감사 기대값을 `personaCount=10`으로 갱신했다.
- 빌드 로그: `Logs/build_agent_disagreement_export.log`, `Build Finished, Result: Success`.
- 데이터 소스 스모크: `Logs/runtime_data_source_disagreement_export.log`, `completed=true`, `personaCount=10`, `passesDataSourceGate=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_disagreement_export.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- UI 정리 스모크: `Logs/runtime_ui_cleanup_disagreement_export.log`, `completed=true`, `reportDenseTextReadable=true`, `reportDenseTextMinimumFontSize=14`.
- 에이전트 시뮬레이션 CSV/JSON은 10명 x 40건, 총 400행으로 재생성됐다.
- 에이전트 JSON export에서 `disagreementBrief`가 `논쟁 사례 큐`를 포함하는 것을 확인했다.

### 2026-05-31 에이전트 판단 이유/플레이어 성향 매칭

- 10인 에이전트 실험실을 단순 자동 플레이 결과표에서 설명 가능한 분석 기능으로 확장했다.
- 각 에이전트 판단 로그에 `decisionReason`을 추가해 긴급 위험, 형평성 필요, 증빙 불확실성, 예산 압박 중 어떤 신호가 판단을 밀었는지 한국어 문장으로 남긴다.
- 각 에이전트 판단 로그에 `matchedPlayerDecision`을 추가해 같은 사례에서 플레이어와 같은 선택을 했는지 CSV/JSON으로 추적한다.
- 에이전트 실행 요약에 `플레이어 성향 매칭`을 추가해 플레이어의 전체 판단과 가장 가까운 가상 심사관 상위 3명을 보여준다.
- 대시보드 각 에이전트 행의 보조 문구를 `플레이어 n/40 · 잔여 예산`으로 바꿔 성향 비교를 화면에서 바로 읽게 했다.
- 에이전트 CSV 컬럼을 `matched_player_decision`, `decision_reason`까지 확장했다.
- 에이전트 JSON export에 `playerSimilarityBrief`를 추가했다.
- 빌드 로그: `Logs/build_agent_reason_similarity_textfix.log`, `Build Finished, Result: Success`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_agent_reason_similarity_textfix.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- UI 정리 스모크: `Logs/runtime_ui_cleanup_agent_reason_similarity_textfix.log`, `completed=true`, `reportDenseTextReadable=true`, `reportDenseTextMinimumFontSize=14`.
- 검증된 에이전트 CSV: 10명 x 40건, 총 400행, 신규 컬럼 `matched_player_decision`, `decision_reason` 포함.
- 검증된 에이전트 JSON: `playerSimilarityBrief`, `matchedPlayerDecision`, `decisionReason` 포함.

### 2026-05-31 Paperlogy 폰트와 논쟁 사례 재검토 연결

- 게임 기본 UI 폰트를 기존 Malgun fallback 중심 구성에서 `Paperlogy-6SemiBold`로 교체했다.
- 폰트 파일은 `Assets/Resources/Fonts/Paperlogy-6SemiBold.ttf`에 포함했다. 빌드 시 PC 설치 폰트에 의존하지 않는다.
- 런타임 fallback도 `Resources.Load<Font>("Fonts/Paperlogy-6SemiBold")`를 먼저 시도하도록 바꿨다.
- 폰트 출처/라이선스는 `Docs/THIRD_PARTY_FONTS.md`에 정리했다. Paperlogy 1.001, SIL Open Font License 기준이다.
- `-careReviewUiCleanupSmokeTest`에 `paperlogyFontApplied`와 `activeFontName` 검증을 추가했다.
- 에이전트 대시보드에 `논쟁 사례 열기` 버튼을 추가했다.
- 논쟁 사례 큐의 상위 사례 ID를 저장하고, 버튼을 누르면 사례 자료실이 해당 사례를 `포커스 사례`로 바로 열도록 연결했다.
- 사례 자료실 목록은 포커스 사례에 `▶` 표시를 붙이고, 상단 상태줄에는 `포커스 <caseId>`를 표시한다.
- 새 자동 검증 인자 `-careReviewAgentCaseReviewSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_paperlogy_font_and_agent_case_review.log`, `Build Finished, Result: Success`.
- UI 정리 스모크: `Logs/runtime_ui_cleanup_paperlogy.log`, `completed=true`, `paperlogyFontApplied=true`, `activeFontName=Paperlogy-6SemiBold`.
- 에이전트 논쟁 사례 재검토 스모크: `Logs/runtime_agent_case_review_paperlogy.log`, `completed=true`, `archiveFocused=true`, `focusedCaseId=B-022`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_paperlogy.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 에이전트 논쟁 상세 메모

- 에이전트 시뮬레이션의 최신 판단 로그를 런타임에 보관해 사례 자료실 상세 패널에서 재사용하도록 했다.
- 논쟁 사례 포커스 상세에 `에이전트 논쟁` 섹션을 추가했다. 판단 분포, 권장 판단, 에이전트별 판단/권장 일치/플레이어 일치/판단 이유를 최대 4명까지 표시한다.
- `-careReviewAgentCaseReviewSmokeTest`의 완료 조건을 강화해 상세 패널의 `에이전트 논쟁`, `판단 이유`, `분포:` 표시까지 검증한다.
- 릴리즈 후보 감사의 에이전트 논쟁 사례 재검토 QA도 `detailMentionsAgentDebate=true`, `detailMentionsDecisionDistribution=true`를 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_agent_case_debate_notes.log`, `Build Finished, Result: Success`.
- 에이전트 논쟁 사례 재검토 스모크: `Logs/runtime_agent_case_debate_notes.log`, `completed=true`, `archiveFocused=true`, `focusedCaseId=B-022`, `detailMentionsAgentDebate=true`, `detailMentionsDecisionDistribution=true`.
- UI 정리 스모크: `Logs/runtime_ui_cleanup_agent_case_debate_notes.log`, `completed=true`, `paperlogyFontApplied=true`, `activeFontName=Paperlogy-6SemiBold`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_agent_case_debate_notes.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 추가조사 자료 해금

- `추가조사` 선택이 단순 지표 변화에 그치지 않도록 사례별 조사 메모를 해금하는 흐름을 추가했다.
- 조사 메모는 사례의 긴급도, 서류 강도, 소득 예외, 형평 필요, 비용 압박을 바탕으로 생성되며 `다음 판단` 권고와 지연 위험을 함께 적는다.
- 판단 직후 피드백에는 `조사 메모 해금` 문구가 뜨고, 후속 연락함의 해당 로그에는 `조사 메모:` 줄이 붙는다.
- 사례 자료실 상세에는 이미 플레이 중 조사한 사례에 한해 `해금된 추가조사 메모` 섹션이 표시된다.
- 플레이 로그 CSV/JSON에는 `investigationFinding`/`investigation_finding`이 남아, 플레이테스트 분석에서 추가조사 선택의 실질적 보상을 추적할 수 있다.
- 새 자동 검증 인자 `-careReviewInvestigationDossierSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_investigation_dossier_unlock.log`, `Build Finished, Result: Success`.
- 추가조사 자료 해금 스모크: `Logs/runtime_investigation_dossier_unlock.log`, `completed=true`, `caseId=D-018`, `logHasFinding=true`, `feedbackMentionsFinding=true`, `inboxMentionsFinding=true`, `archiveMentionsFinding=true`, `csvHasFindingColumn=true`, `csvHasFindingText=true`.
- 후속 연락함 회귀 스모크: `Logs/runtime_follow_up_inbox_after_investigation_dossier.log`, `completed=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_investigation_dossier.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 에이전트 성향 캠페인 기록

- 에이전트 분석 결과가 일회성 대시보드에 머물지 않도록, 가장 가까운 가상 심사관 성향을 최근 캠페인 기록에 저장하도록 연결했다.
- 캠페인 기록의 마지막 회차 세부에 `플레이어 성향`, 에이전트 일치율, 성향 메모를 표시한다.
- 에이전트 대시보드 하단 저장 경로 영역에도 `캠페인 기록 성향`을 표시해 분석 실행 직후 기록 반영 여부를 알 수 있게 했다.
- 새 자동 검증 인자 `-careReviewAgentCareerProfileSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `에이전트 성향 캠페인 기록 QA`를 추가해 기록 저장, 캠페인 기록 화면 표시, 대시보드 표시를 확인한다.
- 빌드 로그: `Logs/build_agent_career_profile.log`, `Build Finished, Result: Success`.
- 에이전트 성향 캠페인 기록 스모크: `Logs/runtime_agent_career_profile.log`, `completed=true`, `closestAgentPersonaName=민원 회피형`, `closestAgentMatchCount=14`, `closestAgentComparableCount=40`.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_agent_profile_regression_rerun.log`, `completed=true`, `recordHasAgentProfile=true`, `bodyMentionsAgentProfile=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_agent_career_profile.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 에이전트 성향 추천 심사

- 에이전트 대시보드에 `성향 목표 적용` 버튼을 추가했다.
- 에이전트 분석으로 가장 가까운 심사관 성향을 찾으면, 그 성향을 반전/보정하는 다음 회차 목표를 자동 생성한다.
- 지연/거절 성향은 지원 확대 기준의 고위험 지연 축소 목표, 즉시 지원 성향은 긴축 감사 기준의 고비용 승인 절제 목표, 추가조사 성향은 균형 심사 기준의 조사 후 결정 종결 목표로 연결한다.
- `성향 목표 적용`을 누르면 최종 리포트의 `추천 심사` 버튼이 해당 운영 기준으로 바뀌고, 버튼을 누르면 새 회차가 그 기준으로 시작된다.
- 새 자동 검증 인자 `-careReviewAgentReplayObjectiveSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `에이전트 성향 추천 심사 QA`를 추가했다.
- 빌드 로그: `Logs/build_agent_replay_objective.log`, `Build Finished, Result: Success`.
- 에이전트 성향 추천 심사 스모크: `Logs/runtime_agent_replay_objective.log`, `completed=true`, `objectivePersona=민원 회피형`, `expectedMandateName=균형 심사`, `pendingObjectiveApplied=true`, `startUsesAgentMandate=true`.
- 에이전트 성향 기록 회귀 스모크: `Logs/runtime_agent_career_profile_after_replay_objective.log`, `completed=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_agent_replay_objective.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 다음 날 운영 브리핑

- 날짜 전환 화면의 본문에 `다음 날 운영 브리핑` 섹션을 추가했다.
- 다음 날 접수 건수, 평균 압박, 고위험/서류보강/소득예외/고비용/조사권장 건수를 표시한다.
- 현재 예산, 민원, 누락 위험, 안정도, 형평성 지표를 바탕으로 `위험 예보`를 생성한다.
- 다음 날 사례 구성에 맞춰 `운영 초점`을 제안한다. 예를 들어 서류보강 사례가 많으면 대체 증빙과 조사 메모 해금을 우선하라고 안내한다.
- 새 자동 검증 인자 `-careReviewDayBriefingForecastSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `다음 날 운영 브리핑 QA`를 추가했다.
- 빌드 로그: `Logs/build_day_briefing_forecast.log`, `Build Finished, Result: Success`.
- 다음 날 운영 브리핑 스모크: `Logs/runtime_day_briefing_forecast.log`, `completed=true`, `bodyMentionsOperationsBriefing=true`, `bodyMentionsNextQueue=true`, `bodyMentionsForecast=true`, `bodyMentionsFocus=true`.
- 사건 카드 회귀 스모크: `Logs/runtime_incident_card_after_day_briefing.log`, `completed=true`, `incidentTypeCount=6`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_day_briefing_forecast.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 심사 화면 운영 초점

- 날짜 전환 브리핑에서 제시한 운영 초점이 심사 화면에서도 유지되도록 오른쪽 기준표에 `오늘 운영 초점` 섹션을 추가했다.
- 오늘 접수 건수, 평균 압박, 고위험/서류/고비용 건수와 당일 운영 초점을 표시한다.
- 좌측 사례 스냅샷은 3줄 구성으로 확장하고 `사례 플래그`를 추가했다. 고위험 우선, 서류보강, 소득예외, 고비용, 조사권장, 표준 검토 중 하나를 표시한다.
- 새 자동 검증 인자 `-careReviewOperationalFocusSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `심사 화면 운영 초점 QA`를 추가했다.
- 빌드 로그: `Logs/build_operational_focus.log`, `Build Finished, Result: Success`.
- 심사 화면 운영 초점 스모크: `Logs/runtime_operational_focus.log`, `completed=true`, `regulationMentionsFocus=true`, `snapshotMentionsCaseFlag=true`, `nextDayFocusStillVisible=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_operational_focus.log`, `completed=true`, `reportDenseTextReadable=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_operational_focus.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.

### 2026-05-31 심사 화면 일일 진행 추적

- 심사 화면의 `오늘 운영 초점`에 `오늘 진행 n/8` 라인을 추가했다.
- 진행 라인은 현재 일차 처리 건수, 남은 신청서 수, 남은 고위험 사례, 남은 서류보강 사례, 해금된 조사 메모 수를 표시한다.
- 판단 직후에도 오른쪽 기준표를 즉시 갱신해, 다음 사례 버튼을 누르기 전부터 `0/8 -> 1/8` 변화를 볼 수 있다.
- 다음 날로 넘어가면 새 일차 기준으로 `오늘 진행 0/8`이 다시 표시된다.
- 새 자동 검증 인자 `-careReviewDailyProgressSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `심사 화면 일일 진행 추적 QA`를 추가했다.
- 빌드 로그: `Logs/build_daily_progress_tracker.log`, `Build Finished, Result: Success`.
- 심사 화면 일일 진행 추적 스모크: `Logs/runtime_daily_progress_tracker.log`, `completed=true`, `initialProgressVisible=true`, `afterDecisionProgressUpdated=true`, `nextCaseProgressPersists=true`, `nextDayProgressReset=true`.
- 심사 화면 운영 초점 회귀 스모크: `Logs/runtime_operational_focus_daily_progress_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_daily_progress_tracker.log`, `completed=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_daily_progress_tracker.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_daily_progress_tracker.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `심사 화면 일일 진행 추적 QA passed=true`.

### 2026-05-31 사례 기반 반복 목표 심사

- 사례 자료실 상세 패널에 `반복 목표 제안` 섹션을 추가했다.
- 포커스 사례나 현재 쪽 대표 사례의 압박, 긴급도, 서류 취약, 소득 예외, 고비용 여부를 읽어 다음 회차 운영 기준과 도전 목표를 만든다.
- 고위험 사례는 `지원 확대`, 고비용/소득 예외 사례는 `긴축 감사`, 서류보강/추가조사 권장 사례는 `균형 심사` 목표로 연결한다.
- 사례 자료실 하단에 `목표 심사` 버튼을 추가했다. R 키 또는 컨트롤러 Submit으로 해당 사례 기반 목표를 적용하고 새 캠페인 브리핑을 바로 연다.
- 새 자동 검증 인자 `-careReviewCaseReplayObjectiveSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `사례 기반 반복 목표 심사 QA`를 추가했다.
- 빌드 로그: `Logs/build_case_replay_objective_second.log`, `Build Finished, Result: Success`.
- 사례 기반 반복 목표 심사 스모크: `Logs/runtime_case_replay_objective.log`, `completed=true`, `focusedCaseId=B-022`, `expectedMandateName=긴축 감사`, `startUsesCaseObjective=true`.
- 사례 자료실 회귀 스모크: `Logs/runtime_case_archive_case_replay_regression.log`, `completed=true`.
- 에이전트 논쟁 사례 회귀 스모크: `Logs/runtime_agent_case_review_case_replay_regression.log`, `completed=true`.
- 에이전트 성향 추천 회귀 스모크: `Logs/runtime_agent_replay_objective_case_replay_regression.log`, `completed=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_case_replay_objective.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_case_replay_objective.log`, `completed=true`, `paperlogyFontApplied=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_case_replay_objective.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `사례 기반 반복 목표 심사 QA passed=true`.

### 2026-05-31 추가조사 후속 반영

- `추가조사`로 해금된 조사 메모가 다음 날 전환 때 실제 후속 처리로 반영되도록 했다.
- 조사 메모 1건마다 후속 처리비가 발생하지만, 안정/형평이 소폭 오르고 누락 위험과 민원 위험이 낮아진다. 추가조사는 즉시 해결이 아니라 다음 날 위험 완화로 보상되는 선택지가 된다.
- 날짜 전환 브리핑의 전날 후폭풍 아래에 `조사 후속` 라인을 추가했다. 해금 메모 수, 대상 사례 ID, 예산/안정/형평/누락/민원 보정치를 표시한다.
- 후속 연락함 요약에도 누적 `조사 메모` 수를 표시해 조사 선택의 결과물을 화면 상단에서 바로 확인할 수 있게 했다.
- 새 자동 검증 인자 `-careReviewInvestigationFollowUpSmokeTest`를 추가했다.
- 릴리즈 후보 감사에 `추가조사 후속 반영 QA`를 추가했다.
- 빌드 로그: `Logs/build_investigation_follow_up_second.log`, `Build Finished, Result: Success`.
- 추가조사 후속 반영 스모크: `Logs/runtime_investigation_follow_up.log`, `completed=true`, `investigatedCaseId=D-018`, `briefingMentionsFollowUp=true`, `metricsReflectFollowUp=true`.
- 추가조사 자료 해금 회귀 스모크: `Logs/runtime_investigation_dossier_follow_up_regression.log`, `completed=true`.
- 다음 날 브리핑 회귀 스모크: `Logs/runtime_day_briefing_investigation_follow_up_regression.log`, `completed=true`.
- 후속 연락함 회귀 스모크: `Logs/runtime_follow_up_inbox_investigation_follow_up_regression.log`, `completed=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_investigation_follow_up.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_investigation_follow_up.log`, `completed=true`, `paperlogyFontApplied=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_investigation_follow_up.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `추가조사 후속 반영 QA passed=true`.

### 2026-05-31 장기 진행 보상 확장

- Steam 업적 후보를 8개에서 10개로 확장했다.
- 신규 후보 `CARE_CASE_OBJECTIVE_REPLAY`는 사례 자료실의 `목표 심사`로 시작한 캠페인을 완료하면 해금된다.
- 신규 후보 `CARE_INVESTIGATION_FOLLOW_UP`은 해금된 조사 메모가 다음 날 위험 완화로 실제 반영된 캠페인을 완료하면 해금된다.
- 성과 기록 화면 레이아웃을 10개 카드가 들어가도록 2열 5행 밀도로 조정했다.
- 캠페인 기록 마지막 회차 세부에 `사례 목표`와 `조사 후속` 건수를 표시한다.
- Steamworks 업적 후보 CSV/Markdown과 외부 게이트 문구를 10개 API Name 기준으로 갱신했다.
- 새 자동 검증 인자 `-careReviewLongTermProgressionSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_long_term_progression.log`, `Build Finished, Result: Success`.
- 장기 진행 보상 스모크: `Logs/runtime_long_term_progression.log`, `completed=true`, `caseObjectiveAchievementUnlocked=true`, `investigationFollowUpAchievementUnlocked=true`, `recordHasCaseObjective=true`, `recordHasInvestigationFollowUp=true`, `achievementCatalogExpanded=true`.
- 성과 기록 회귀 스모크: `Logs/runtime_achievement_long_term_regression.log`, `completed=true`, `achievementCatalogCount=10`, `hasInvestigationFollowUp=true`.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_long_term_regression.log`, `completed=true`, `bodyMentionsLongTermRewards=true`.
- 사례 목표 회귀 스모크: `Logs/runtime_case_replay_long_term_regression.log`, `completed=true`.
- 추가조사 후속 회귀 스모크: `Logs/runtime_investigation_follow_up_long_term_regression.log`, `completed=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_long_term_progression.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_long_term_progression.log`, `completed=true`, `paperlogyFontApplied=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_long_term_progression.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `장기 진행 보상 QA passed=true`.

### 2026-05-31 조사 후속 엔딩 에필로그

- 조사 후속이 단순 일차 브리핑 보상에 그치지 않도록, 최종 엔딩 카드의 `후속 에필로그`에 이번 회차에서 실제 반영된 조사 메모 건수를 추가로 표시한다.
- 추천 판단 경로 기준으로 8건의 조사 후속이 누적되면 엔딩 에필로그에 `조사 후속 기록` 문장이 붙고, 추가조사를 다음 심사의 근거 자료로 남겼다는 회차별 후속 서사를 보여준다.
- 로그 저장 JSON의 `endingEpilogue`에도 같은 동적 에필로그를 기록해 플레이테스트 회수 시 최종 리포트 화면과 export 데이터가 어긋나지 않게 했다.
- 새 자동 검증 인자 `-careReviewInvestigationEpilogueSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_investigation_epilogue.log`, `Build Finished, Result: Success`.
- 조사 후속 엔딩 에필로그 스모크: `Logs/runtime_investigation_epilogue.log`, `completed=true`, `investigationFollowUpCount=8`, `epilogueMentionsFollowUp=true`, `reportMentionsFollowUp=true`, `exportMentionsFollowUp=true`.
- 추가조사 후속 회귀 스모크: `Logs/runtime_investigation_follow_up_epilogue_regression.log`, `completed=true`.
- 장기 진행 보상 회귀 스모크: `Logs/runtime_long_term_progression_epilogue_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_investigation_epilogue.log`, `completed=true`, `reportDenseTextReadable=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_investigation_epilogue.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_investigation_epilogue.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `조사 후속 엔딩 에필로그 QA passed=true`.

### 2026-05-31 장기 성과 추천 목표 개인화

- 최종 리포트의 다음 캠페인 목표가 단순 지표 압박뿐 아니라 미해금 성과 상태를 읽어 추천되도록 했다.
- 예산 설명 완료, 누락 위험 방어, 형평성 우선, 근거 중심 심사, 조사 후속 처리, 운영 기준 실험처럼 추천 심사 버튼으로 실제 추적 가능한 성과를 다음 목표 후보로 우선한다.
- 캠페인 기록 마지막 회차 세부에 `개인화 추천`과 `장기 추천` 줄을 추가해 왜 다음 목표가 선택됐는지, 아직 남은 장기 성과가 무엇인지 바로 보이게 했다.
- 메인 메뉴 상태줄에도 `장기 추천`을 추가해 완료 회차 기록을 열지 않아도 다음에 노릴 목표가 보인다.
- 캠페인 기록 JSON에는 `nextCampaignReason`을 저장해 장기 추천 근거가 회차 기록에 남는다.
- 새 자동 검증 인자 `-careReviewPersonalizedRecommendationSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_personalized_recommendation.log`, `Build Finished, Result: Success`.
- 장기 성과 추천 목표 스모크: `Logs/runtime_personalized_recommendation.log`, `completed=true`, `objectiveTargetsBudgetAchievement=true`, `reportMentionsPersonalizedReason=true`, `careerMentionsPersonalizedRecommendation=true`, `menuMentionsLongTermRecommendation=true`, `recordHasPersonalizedReason=true`.
- 추천 심사 회귀 스모크: `Logs/runtime_recommended_replay_personalized_regression.log`, `completed=true`, `mandateApplied=true`, `budgetResetForMandate=true`.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_personalized_regression.log`, `completed=true`, `bodyMentionsLongTermRewards=true`.
- 장기 진행 보상 회귀 스모크: `Logs/runtime_long_term_progression_personalized_regression.log`, `completed=true`.
- 성과 기록 회귀 스모크: `Logs/runtime_achievement_personalized_regression.log`, `completed=true`, `achievementCatalogCount=10`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_personalized_recommendation.log`, `completed=true`, `reportDenseTextReadable=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_personalized_recommendation.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_personalized_recommendation.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `장기 성과 추천 목표 QA passed=true`.

### 2026-05-31 상위 반복 챌린지

- 사례 목표 또는 미해금 성과 목표로 시작한 회차를 `반복 목표` 완료로 기록한다.
- 반복 목표가 2회 이상 누적되면 `상위 배지: 반복 목표 전문가`가 해금되고, 4회/6회 상위 단계로 이어지는 고난도 챌린지 진행도가 표시된다.
- 최종 리포트의 캠페인 챌린지 영역에는 `상위 챌린지` 라인을 추가해 현재 반복 목표 누적과 상위 배지를 보여준다.
- 캠페인 기록 마지막 회차 세부에는 `반복 목표`, `상위 배지`, `고난도 챌린지` 진행을 저장/표시한다.
- 메인 메뉴의 `장기 추천`도 상위 배지 해금 상태를 반영해, 반복 목표를 이미 2회 이상 끝낸 플레이어에게 다음 상위 단계를 안내한다.
- 캠페인 기록 JSON에는 `startedFromAchievementObjective`, `achievementObjectiveTitle`, `replayObjectiveCompletionCount`, `advancedReplayChallengeUnlocked`, `advancedReplayChallengeBadge`, `advancedReplayChallengeProgress`를 저장한다.
- 새 자동 검증 인자 `-careReviewAdvancedReplayChallengeSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_advanced_replay_challenge.log`, `Build Finished, Result: Success`.
- 상위 반복 챌린지 스모크: `Logs/runtime_advanced_replay_challenge.log`, `completed=true`, `recordCount=2`, `recordHasAdvancedBadge=true`, `reportMentionsAdvancedChallenge=true`, `careerMentionsAdvancedBadge=true`, `menuMentionsAdvancedBadge=true`.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_advanced_replay_regression.log`, `completed=true`, `bodyMentionsLongTermRewards=true`.
- 장기 진행 보상 회귀 스모크: `Logs/runtime_long_term_progression_advanced_replay_regression.log`, `completed=true`.
- 개인화 추천 회귀 스모크: `Logs/runtime_personalized_recommendation_advanced_replay_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_advanced_replay_challenge.log`, `completed=true`, `reportDenseTextReadable=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_advanced_replay_challenge.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_advanced_replay_challenge.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `상위 반복 챌린지 QA passed=true`.

### 2026-05-31 조사 후속 엔딩 필터

- 엔딩 기록 화면에 `후속 보기` 필터를 추가해 커리어 기록에서 조사 후속 6건 이상을 남긴 엔딩만 빠르게 찾을 수 있게 했다.
- 각 엔딩 카드는 커리어 기록의 `investigationFollowUpCount`를 읽어 `조사 후속 배지: n건`과 운영 기준, 등급, 완료일을 표시한다.
- 필터가 켜진 상태에서 조건을 만족하지 않는 엔딩은 `후속 많은 회차 없음` 상태로 흐리게 표시해 재도전 목표가 분명하게 보이게 했다.
- 키보드 `F`, 컨트롤러 `X/West`로 후속 필터를 전환할 수 있고, 기존 `기준 전환`, `새 캠페인`, `메인 메뉴` 흐름은 유지했다.
- 새 자동 검증 인자 `-careReviewEndingInvestigationFilterSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_ending_investigation_filter.log`, `Build Finished, Result: Success`.
- 조사 후속 엔딩 필터 스모크: `Logs/runtime_ending_investigation_filter.log`, `completed=true`, `recordInvestigationFollowUpCount=8`, `highlightedEndingCount=1`, `cardMentionsFollowUpBadge=true`, `filterActive=true`, `filteredCardsMarkEmptySlots=true`.
- 엔딩 기록 회귀 스모크: `Logs/runtime_ending_gallery_investigation_filter_regression.log`, `galleryActive=true`, 후속 필터 상태 표시 확인.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_investigation_filter_regression.log`, `completed=true`, `bodyMentionsLongTermRewards=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_investigation_filter.log`, `completed=true`, `reportDenseTextReadable=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_ending_investigation_filter.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_ending_investigation_filter.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `조사 후속 엔딩 필터 QA passed=true`.

### 2026-05-31 메인 메뉴 목표 사례 연결

- 장기 추천이 `사례 재심사 목표`를 가리킬 때 메인 메뉴에서 바로 사례 자료실 포커스로 들어갈 수 있도록 `목표 사례` 버튼을 추가했다.
- 버튼은 미해금 상태에서는 `목표 사례`, 해금 후에는 `추천 사례`로 표시되어 같은 기능을 장기 반복 후보 탐색에도 유지한다.
- 추천 대상은 에이전트 논쟁 사례가 있으면 그 사례를 우선하고, 없으면 압박도, 추가조사 권장, 서류 취약, 소득 예외, 고비용 점수를 합산해 대표 재심사 후보를 고른다.
- 사례 자료실 진입 시 `장기 추천 포커스` 상태줄, 포커스 마커, 반복 목표 제안, `목표 심사` 적용까지 한 화면에서 이어진다.
- 메인 메뉴 단축키 `B`를 추가해 `V 사례 자료`와 별도로 목표 사례 포커스를 바로 열 수 있게 했다.
- 새 자동 검증 인자 `-careReviewMainMenuCaseObjectiveSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_main_menu_case_objective_rerun.log`, `Build Finished, Result: Success`.
- 메인 메뉴 목표 사례 스모크: `Logs/runtime_main_menu_case_objective.log`, `completed=true`, `focusedCaseId=AN-447`, `menuMentionsCaseObjective=true`, `buttonMentionsObjective=true`, `archiveFocused=true`, `pendingObjectiveApplied=true`.
- 사례 자료실 회귀 스모크: `Logs/runtime_case_archive_main_menu_case_objective_regression.log`, `completed=true`, `caseCount=40`.
- 사례 기반 반복 목표 회귀 스모크: `Logs/runtime_case_replay_main_menu_case_objective_regression.log`, `completed=true`, `pendingObjectiveApplied=true`, `startUsesCaseObjective=true`.
- 메인 메뉴 운영 기준 회귀 스모크: `Logs/runtime_main_menu_mandate_case_objective_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_main_menu_case_objective.log`, `completed=true`, `buttonRoleHierarchyApplied=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_main_menu_case_objective.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_main_menu_case_objective.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_main_menu_case_objective_final.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `메인 메뉴 목표 사례 연결 QA passed=true`.

### 2026-05-31 상위 반복 챌린지 단계 장식

- 반복 목표 완료 누적 4회/6회에 따라 상위 단계 카드와 장식 문구를 분리했다.
- 2회는 `동색 반복 목표 인장`, 4회는 `은색 챌린지 카드`, 6회는 `금색 엔딩 장식`으로 표시하고, 6회 달성 시 `상위 배지: 반복 목표 설계자`와 `상위 단계 3`이 열린다.
- 캠페인 기록 JSON에 `advancedReplayChallengeTier`, `advancedReplayChallengeDecoration`을 추가해 회차별 상위 단계와 장식 상태가 저장된다.
- 최종 리포트, 캠페인 기록, 엔딩 기록 카드가 같은 상위 단계 정보를 읽도록 연결했다.
- 엔딩 기록 상태줄에는 `상위 장식: n`을 표시하고, 조건을 만족한 엔딩 카드에는 `반복 장식` 줄로 장식명, 반복 목표 완료 수, 운영 기준, 등급, 완료일을 보여준다.
- 경력 기록 중복 판정이 시작시각만 같은 빠른 재시작 기록을 덮어쓰지 않도록 세션 ID 우선 판정으로 보강했고, 캠페인 시작시각은 밀리초까지 저장한다.
- 새 자동 검증 인자 `-careReviewAdvancedReplayTierSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_advanced_replay_tier_fix.log`, `Build Finished, Result: Success`.
- 상위 반복 챌린지 단계 장식 스모크: `Logs/runtime_advanced_replay_tier_fix_clean.log`, `completed=true`, `replayObjectiveCompletionCount=6`, `advancedReplayChallengeTier=상위 단계 3`, `advancedReplayChallengeDecoration=금색 엔딩 장식`, `endingGalleryMentionsDecoration=true`.
- 상위 반복 챌린지 회귀 스모크: `Logs/runtime_advanced_replay_challenge_tier_fix_clean.log`, `completed=true`, `recordCount=2`, `recordHasAdvancedBadge=true`.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_advanced_replay_tier_fix_clean.log`, `completed=true`.
- 엔딩 기록 회귀 스모크: `Logs/runtime_ending_gallery_advanced_replay_tier_fix.log`, `galleryActive=true`, 상태줄 `상위 장식` 표시 확인.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_advanced_replay_tier_fix.log`, `completed=true`, `paperlogyFontApplied=true`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_advanced_replay_tier_fix.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_advanced_replay_tier_smoke_result.json`, `Builds/QA/v0.3.0/care_review_advanced_replay_challenge_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_advanced_replay_tier.log`, `localReleaseCandidateReady=true`, `localBlockerCount=0`, `상위 반복 챌린지 단계 장식 QA passed=true`.

### 2026-05-31 엔딩 기록 캠페인 연결

- 엔딩 기록 카드에 `관련 기록` 버튼을 추가했다.
- 조사 후속 배지가 붙은 엔딩은 `후속 기록`, 상위 반복 장식이 붙은 엔딩은 `장식 기록`, 두 조건을 모두 만족하면 `후속+장식` 버튼으로 표시한다.
- 버튼을 누르면 캠페인 기록 화면으로 이동하고, 관련 회차 행에 `▶` 포커스 마커를 붙인다.
- 캠페인 기록 본문은 포커스 진입 시 `관련 엔딩 기록 포커스`와 `선택 회차 세부`를 표시해 엔딩 카드에서 어떤 회차로 이동했는지 바로 알 수 있게 했다.
- 관련 기록 선택은 같은 엔딩의 커리어 기록 중 조사 후속 건수, 반복 목표 단계, 점수, 완료일을 기준으로 가장 강한 회차를 고른다.
- 상위 반복 챌린지 단계 장식 스모크에도 `endingGalleryDecorationLinkAvailable=true` 검증을 추가해 금색 엔딩 장식에서 캠페인 기록으로 이어지는 경로를 같이 확인한다.
- 새 자동 검증 인자 `-careReviewEndingCareerLinkSmokeTest`를 추가했다.
- 빌드 로그: `Logs/build_ending_career_link_final.log`, `Build Finished, Result: Success`.
- 엔딩 기록 캠페인 연결 스모크: `Logs/runtime_ending_career_link_final.log`, `completed=true`, `linkedRecordFound=true`, `buttonActive=true`, `careerRecordActive=true`, `careerShowsFocusedRecord=true`, `careerShowsFollowUpDetail=true`, `tableMarksFocusedRecord=true`.
- 상위 반복 단계 장식 회귀 스모크: `Logs/runtime_advanced_replay_tier_ending_link.log`, `completed=true`, `endingGalleryDecorationLinkAvailable=true`.
- 조사 후속 엔딩 필터 회귀 스모크: `Logs/runtime_ending_filter_career_link_regression.log`, `completed=true`.
- 엔딩 기록 회귀 스모크: `Logs/runtime_ending_gallery_career_link_regression.log`, `galleryActive=true`.
- 캠페인 기록 회귀 스모크: `Logs/runtime_career_record_ending_link_clean.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_ending_career_link.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_ending_career_link.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_ending_career_link.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_ending_career_link_smoke_result.json`, `Builds/QA/v0.3.0/care_review_advanced_replay_tier_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_ending_career_link.log`, `checkCount=61`, `passedCheckCount=61`, `localBlockerCount=0`, `엔딩 기록 캠페인 연결 QA passed=true`.

### 2026-05-31 메인 메뉴 목표 사례 미리보기

- 메인 메뉴의 `목표 사례` 버튼에 현재 추천 사례 ID를 직접 표시하도록 바꿨다.
- 버튼 아래 힌트 문구에 추천 기준을 표시한다. 예: `고압력/추가조사 권장/서류 취약/고비용`.
- 메인 메뉴 상태줄에도 `목표 사례: AN-447 · 고압력/추가조사 권장/서류 취약/고비용`처럼 추천 사례와 기준을 한 줄로 노출한다.
- 사례 자료실로 진입한 뒤에도 같은 추천 기준을 `장기 추천 포커스` 상태줄에 유지해, 버튼에서 본 이유와 실제 포커스 이유가 어긋나지 않게 했다.
- 추천 기준은 에이전트 논쟁 사례가 있으면 우선 사용하고, 없으면 압박도, 추가조사 권장, 서류 취약, 소득 예외, 고비용 조건을 조합한다.
- 메인 메뉴 상태 박스 높이를 늘려 추천 사례 줄이 추가되어도 단축키/빌드 정보가 밀리지 않게 했다.
- 빌드 로그: `Logs/build_main_menu_case_preview_final.log`, `Build Finished, Result: Success`.
- 메인 메뉴 목표 사례 스모크: `Logs/runtime_main_menu_case_preview_final.log`, `completed=true`, `focusedCaseId=AN-447`, `expectedReason=고압력/추가조사 권장/서류 취약/고비용`, `buttonText=목표 AN-447`, `hintText=고압력/추가조사 권장/서류 취약/고비용`.
- 사례 기반 반복 목표 회귀 스모크: `Logs/runtime_case_replay_main_menu_case_preview_regression.log`, `completed=true`.
- 메인 메뉴 운영 기준 회귀 스모크: `Logs/runtime_main_menu_mandate_case_preview_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_main_menu_case_preview.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_main_menu_case_preview.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_main_menu_case_preview.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_main_menu_case_objective_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_main_menu_case_preview.log`, `checkCount=62`, `passedCheckCount=62`, `localBlockerCount=0`, `메인 메뉴 목표 사례 연결 QA passed=true`.

### 2026-05-31 캠페인 기록 상세 패널

- 캠페인 기록 화면에 별도 `선택 회차 상세` 패널을 추가했다.
- 캠페인 완료 시 고압력/불일치/조사 메모 가중치로 대표 사례를 골라 `representativeCaseId`, `representativeCaseReason`, `representativeCaseNextStep`에 저장한다.
- 조사 메모가 있는 회차는 대표 조사 메모 사례와 내용을 `investigationMemoCaseId`, `investigationMemo`에 저장한다.
- 상세 패널에는 대표 사례, 다음 비교 포인트, 조사 메모, 회차 해석을 표시한다.
- 엔딩 기록에서 관련 캠페인 기록으로 들어온 경우 상세 패널 제목이 `선택 회차 상세 · 엔딩 기록에서 연결됨`으로 바뀌어 이동 맥락이 유지된다.
- 기존 캠페인 기록 표는 유지하되 본문 영역을 줄이고 하단 상세 패널을 분리해 회차 비교와 단일 회차 분석을 동시에 볼 수 있게 했다.
- 빌드 로그: `Logs/build_career_record_detail.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_detail.log`, `completed=true`, `recordHasDetailSummary=true`, `detailMentionsRepresentativeCase=true`, `detailMentionsInvestigationMemo=true`, `detailMentionsSummary=true`, 대표 사례 `AG-349`, 조사 메모 사례 `AN-447`.
- 엔딩 기록 캠페인 연결 회귀 스모크: `Logs/runtime_ending_career_link_detail.log`, `completed=true`, `careerDetailShowsRepresentativeCase=true`, `careerDetailShowsInvestigationMemo=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_career_record_detail.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_career_record_detail.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_career_record_detail.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_career_record_smoke_result.json`, `Builds/QA/v0.3.0/care_review_ending_career_link_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_detail.log`, `checkCount=63`, `passedCheckCount=63`, `localBlockerCount=0`, `캠페인 기록 상세 패널 QA passed=true`.

### 2026-05-31 캠페인 기록 사례 바로 열기

- 캠페인 기록 하단 버튼 줄을 `대표 사례`, `조사 사례`, `성과 기록`, `새 캠페인`, `메인 메뉴` 5개 행동으로 재배치했다.
- `대표 사례` 버튼은 선택/최근 회차의 `representativeCaseId`를 사례 자료실 포커스로 바로 연다.
- `조사 사례` 버튼은 대표 조사 메모가 있는 경우 `investigationMemoCaseId`를 사례 자료실 포커스로 바로 연다.
- 사례 자료실 상태줄에는 `캠페인 기록 포커스: 대표 사례 ...` 또는 `캠페인 기록 포커스: 조사 메모 ...`를 붙여 어떤 기록에서 들어왔는지 유지한다.
- 캠페인 기록 스모크가 두 버튼 활성화, 대표 사례 포커스 이동, 조사 메모 사례 포커스 이동을 함께 검증하도록 보강했다.
- 릴리즈 후보 감사의 `캠페인 기록 상세 패널 QA`가 `representativeCaseButtonActive`, `investigationMemoButtonActive`, `representativeArchiveFocused`, `investigationArchiveFocused`까지 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_career_record_case_links.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_case_links.log`, `completed=true`, `representativeCaseButtonActive=true`, `investigationMemoButtonActive=true`, `representativeArchiveFocused=true`, `investigationArchiveFocused=true`, 대표 사례 `AG-349`, 조사 메모 사례 `AN-447`.
- 엔딩 기록 캠페인 연결 회귀 스모크: `Logs/runtime_ending_career_link_case_links.log`, `completed=true`, `careerDetailShowsRepresentativeCase=true`, `careerDetailShowsInvestigationMemo=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_career_record_case_links.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_career_record_case_links.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_career_record_case_links.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_career_record_smoke_result.json`, `Builds/QA/v0.3.0/care_review_ending_career_link_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_case_links.log`, `checkCount=63`, `passedCheckCount=63`, `localBlockerCount=0`, `캠페인 기록 상세 패널 QA passed=true`.

### 2026-05-31 조사 메모 후속 타임라인

- 캠페인 기록에 `investigationMemoTimeline`을 추가해 대표 조사 메모의 해금 시점, 다음 날 후속 반영, 최종 지표를 저장한다.
- 타임라인은 `D5 #40 조사 해금`, `D6 후속 반영`, `최종 지표` 3단으로 요약된다.
- 캠페인 기록 상세 패널에는 `조사 타임라인: 후속 반영/최종 지표 저장` 라인을 표시한다.
- 캠페인 기록에서 `조사 사례`로 사례 자료실에 들어가면 해당 사례 상세에 `캠페인 기록 타임라인` 블록을 추가로 보여준다.
- 캠페인 기록 스모크가 `recordHasInvestigationTimeline`, `detailMentionsInvestigationTimeline`, `investigationArchiveMentionsTimeline`을 검증하도록 강화됐다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 캠페인 기록 QA도 조사 타임라인 필드를 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_investigation_timeline_fix_retry2.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_investigation_timeline_career_record_fix.log`, `completed=true`, `recordHasInvestigationTimeline=true`, `detailMentionsInvestigationTimeline=true`, `investigationArchiveMentionsTimeline=true`, 조사 메모 사례 `AN-447`.
- 엔딩 기록 캠페인 연결 회귀 스모크: `Logs/runtime_ending_career_link_investigation_timeline.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_investigation_timeline.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_investigation_timeline.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_investigation_timeline.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_career_record_smoke_result.json`, `Builds/QA/v0.3.0/care_review_ending_career_link_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_investigation_timeline.log`, `checkCount=63`, `passedCheckCount=63`, `localBlockerCount=0`, `캠페인 기록 상세 패널 QA passed=true`.

### 2026-05-31 직전 성향 기반 목표 사례 추천

- 메인 메뉴 `목표 사례` 추천 점수에 최근 캠페인 기록의 판단 성향을 반영한다.
- 직전 회차가 지원 과다, 조사 과다, 지연/거절 과다, 권장 불일치 중 어디에 가까운지 계산해 사례 추천 점수를 보정한다.
- 추천 사유에 `직전 지원 성향 보정`, `직전 조사 성향 보정`, `직전 지연/거절 보정`, `직전 권장 불일치 보정`을 표시한다.
- 메인 메뉴 상태줄, 목표 사례 버튼 힌트, 사례 자료실의 `장기 추천 포커스` 상태줄이 같은 직전 성향 사유를 공유한다.
- 메인 메뉴 목표 사례 스모크가 직전 지원 성향 커리어 기록을 주입하고 `expectedUsesRecentTendency=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 `메인 메뉴 목표 사례 연결 QA`가 직전 성향 보정 필드를 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_recent_tendency_case_objective.log`, `Build Finished, Result: Success`.
- 메인 메뉴 목표 사례 스모크: `Logs/runtime_recent_tendency_case_objective.log`, `completed=true`, `focusedCaseId=AN-447`, `expectedUsesRecentTendency=true`, `expectedReason=직전 지원 성향 보정/고압력/추가조사 권장/서류 취약/고비용`.
- 사례 기반 반복 목표 회귀 스모크: `Logs/runtime_case_replay_recent_tendency_regression.log`, `completed=true`.
- 메인 메뉴 운영 기준 회귀 스모크: `Logs/runtime_main_menu_mandate_recent_tendency_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_recent_tendency.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_recent_tendency.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_recent_tendency.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_main_menu_case_objective_smoke_result.json`, `Builds/QA/v0.3.0/care_review_case_replay_objective_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_recent_tendency.log`, `checkCount=63`, `passedCheckCount=63`, `localBlockerCount=0`, `메인 메뉴 목표 사례 연결 QA passed=true`.

### 2026-05-31 누적 캠페인 성향 그래프

- 메인 메뉴 상태 박스에 최근 최대 6회 커리어 기록을 집계한 `누적 성향` 텍스트 그래프를 추가했다.
- 그래프는 지원/조사/지연·거절 비율을 5칸 막대로 표시하고, 평균 권장 판단 일치율을 함께 보여준다.
- 목표 사례 추천 점수에 직전 회차뿐 아니라 누적 캠페인 성향 보정도 더한다.
- 추천 사유에 `누적 지원 성향`, `누적 조사 성향`, `누적 지연/거절 성향`, `누적 권장 불일치`를 표시할 수 있게 했다.
- 메인 메뉴 목표 사례 QA가 `menuMentionsCumulativeGraph=true`, `expectedUsesCumulativeTendency=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사의 메인 메뉴 목표 사례 QA도 누적 성향 그래프/사유 필드를 요구하도록 갱신했다.
- 릴리즈 후보 감사 중 프리플라이트가 이전 감사 결과를 읽어 자기 자신을 실패시키는 순환 항목은 로컬 미해결 항목에서 제외하도록 정리했다.
- 빌드 로그: `Logs/build_cumulative_tendency_graph.log`, `Build Finished, Result: Success`.
- 메인 메뉴 목표 사례 스모크: `Logs/runtime_cumulative_tendency_graph.log`, `completed=true`, `menuMentionsCumulativeGraph=true`, `expectedUsesCumulativeTendency=true`, `expectedReason=누적 지원 성향/직전 지원 성향 보정/고압력/추가조사 권장/서류 취약/고비용`.
- 사례 기반 반복 목표 회귀 스모크: `Logs/runtime_case_replay_cumulative_tendency_regression.log`, `completed=true`.
- 메인 메뉴 운영 기준 회귀 스모크: `Logs/runtime_main_menu_mandate_cumulative_tendency_regression.log`, `completed=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_cumulative_tendency.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_cumulative_tendency.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_cumulative_tendency.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_main_menu_case_objective_smoke_result.json`, `Builds/QA/v0.3.0/care_review_case_replay_objective_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_cumulative_tendency_selfcheck_fix.log`, `checkCount=63`, `passedCheckCount=63`, `localBlockerCount=0`, `메인 메뉴 목표 사례 연결 QA passed=true`.

### 2026-05-31 운영 기준 카드 반복 장식 연결

- 메인 메뉴 운영 기준 카드에 `반복 장식` 줄을 추가했다.
- 반복 목표 회차가 없으면 `목표 심사 완료 후 챌린지 카드 해금`으로 표시한다.
- 반복 목표 누적 2/4/6회에 따라 `상위 단계 1/2/3`과 `동색 반복 목표 인장`/`은색 챌린지 카드`/`금색 엔딩 장식`을 캠페인 시작 전 카드에 보여준다.
- 운영 기준을 바꿔도 같은 반복 장식 상태가 유지되도록 카드 갱신 로직을 연결했다.
- 메인 메뉴 운영 기준 스모크가 6회 반복 목표 기록을 주입하고 `cardMentionsAdvancedReplayDecoration`, `changedCardKeepsAdvancedReplayDecoration`을 검증하도록 보강했다.
- 릴리즈 후보 감사에 `메인 메뉴 운영 기준 반복 장식 QA`를 추가했다.
- 빌드 로그: `Logs/build_mandate_replay_decoration_card.log`, `Build Finished, Result: Success`.
- 메인 메뉴 운영 기준 스모크: `Logs/runtime_mandate_replay_decoration_card.log`, `completed=true`, `cardMentionsAdvancedReplayDecoration=true`, `changedCardKeepsAdvancedReplayDecoration=true`.
- 상위 반복 단계 장식 회귀 스모크: `Logs/runtime_advanced_replay_tier_mandate_card.log`, `completed=true`, `advancedReplayChallengeTier=상위 단계 3`, `advancedReplayChallengeDecoration=금색 엔딩 장식`.
- 메인 메뉴 목표 사례 회귀 스모크: `Logs/runtime_case_objective_mandate_card_regression.log`, `completed=true`, `menuMentionsCumulativeGraph=true`.
- UI 정리 회귀 스모크: `Logs/runtime_ui_cleanup_mandate_replay_decoration_card.log`, `completed=true`, `paperlogyFontApplied=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_mandate_replay_decoration_card.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 전체 실행 스모크: `Logs/runtime_full_smoke_mandate_replay_decoration_card.log`, `completed=true`, `caseCount=40`, `logCount=40`, `highestDay=5`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_main_menu_mandate_smoke_result.json`, `Builds/QA/v0.3.0/care_review_advanced_replay_tier_smoke_result.json`, `Builds/QA/v0.3.0/low_resolution_ui/care_review_low_resolution_ui_smoke_result.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_mandate_replay_decoration_card.log`, `checkCount=64`, `passedCheckCount=64`, `localBlockerCount=0`, `메인 메뉴 운영 기준 반복 장식 QA passed=true`.

### 2026-05-31 업적 후보 반복 장식 연결

- `사례 재심사 목표` 로컬 성과 카드에 반복 목표 2/4/6회 장식 진행도를 표시하도록 확장했다.
- 반복 목표 기록이 없을 때도 성과 카드가 `동색/은색/금색` 장식 계획을 보여주고, 6회 누적 시 `상위 단계 3 · 금색 엔딩 장식`을 표시한다.
- Steamworks 업적 후보 CSV/Markdown의 `CARE_CASE_OBJECTIVE_REPLAY` 설명과 트리거에 반복 목표 2/4/6회 장식 단계를 반영했다.
- Steam 상점 페이지 설명/제출안에 목표 심사/성과 목표 반복 플레이가 동색 인장, 은색 챌린지 카드, 금색 엔딩 장식으로 이어진다는 문구를 추가했다.
- 릴리즈 후보 감사에 `Steam 업적 후보 반복 장식 반영`, `성과 기록 반복 장식 QA`를 추가했고, 상위 반복 챌린지 단계 장식 QA가 성과 카드/카탈로그 연결까지 요구하도록 보강했다.
- 빌드 로그: `Logs/build_achievement_replay_decoration.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_replay_decoration_qa.log`, `Care Review Office Steamworks depot prepared`.
- 성과 기록 스모크: `Logs/runtime_achievement_replay_decoration.log`, `completed=true`, `achievementCardMentionsReplayTierPlan=true`, `achievementCatalogMentionsReplayTierPlan=true`.
- 상위 반복 단계 장식 스모크: `Logs/runtime_advanced_replay_tier_achievement_card.log`, `completed=true`, `achievementCardMentionsAdvancedReplayDecoration=true`, `achievementCatalogMentionsAdvancedReplayTiers=true`, `advancedReplayChallengeTier=상위 단계 3`, `advancedReplayChallengeDecoration=금색 엔딩 장식`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_achievement_replay_decoration.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_achievement_smoke_result.json`, `Builds/QA/v0.3.0/care_review_advanced_replay_tier_smoke_result.json`, `Builds/QA/v0.3.0/achievements/care_review_achievements_replay_decoration.png`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_replay_decoration_final.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`, `Steam 업적 후보 반복 장식 반영 passed=true`, `성과 기록 반복 장식 QA passed=true`.

### 2026-05-31 캠페인 기록 장기 추세 패널

- 캠페인 기록 본문 상단에 `장기 추세 패널`을 추가했다.
- 기존 메인 메뉴 누적 성향 그래프 계산을 리스트 기반 헬퍼로 분리해 캠페인 기록 화면에서도 재사용한다.
- 장기 추세 패널은 최근 기록의 누적 지원/조사/지연 성향, 평균 권장 일치율, 평균 점수, 최고 등급, 반복 목표 단계/장식을 한 줄로 표시한다.
- 캠페인 기록 스모크가 `bodyMentionsLongTermTrend=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 캠페인 기록 QA 조건에 장기 추세 패널 검증을 추가했다.
- Steam 상점 페이지 자료/제출안에도 장기 추세 패널 설명을 추가했다.
- 빌드 로그: `Logs/build_career_record_long_trend.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_long_trend.log`, `completed=true`, `bodyMentionsLongTermTrend=true`, `recordHasDetailSummary=true`, `detailMentionsInvestigationTimeline=true`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_career_record_smoke_result.json`, `Builds/QA/v0.3.0/career_records/care_review_career_record_smoke_result_long_trend.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_long_trend_final.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`, `캠페인 기록 상세 패널 QA passed=true`.

### 2026-05-31 성과 반복 기록 바로가기

- 성과 기록 화면 하단에 `반복 기록` 버튼을 추가했다.
- 반복 목표 기록이 없으면 버튼을 비활성화하고, 기록이 있으면 가장 높은 반복 목표 누적 회차를 찾아 `반복 n회`로 표시한다.
- 버튼을 누르면 해당 커리어 기록으로 이동하고, 캠페인 기록 본문에 `성과 반복 기록: 상위 단계 n · 장식명` 포커스 맥락과 `▶` 행 마커를 표시한다.
- 상위 반복 단계 장식 스모크가 `achievementReplayRecordButtonActive=true`, `achievementReplayRecordOpensCareer=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 상위 반복 챌린지 단계 장식 QA 조건도 성과 화면 바로가기까지 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_achievement_replay_record_link.log`, `Build Finished, Result: Success`.
- 상위 반복 단계 장식 스모크: `Logs/runtime_advanced_replay_tier_achievement_record_link.log`, `completed=true`, `achievementReplayRecordButtonActive=true`, `achievementReplayRecordOpensCareer=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_achievement_record_link.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_advanced_replay_tier_smoke_result.json`, `Builds/QA/v0.3.0/achievements/care_review_advanced_replay_tier_smoke_result_achievement_record_link.json`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_record_link.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`, `상위 반복 챌린지 단계 장식 QA passed=true`.

### 2026-05-31 마케팅 반복 장식 장면 보강

- 상점 스크린샷 `06_ending_gallery.png`에 반복 장식 콜아웃을 추가해 `상위 단계 3 · 금색 엔딩 장식 · 반복 목표 6회` 보상 구조가 보이도록 했다.
- 트레일러 프레임 `trailer_012_agent_analysis.png`에 성과 반복 기록 콜아웃을 추가해 `반복 6회`, `금색 엔딩 장식`, 캠페인 기록 바로가기, 장기 추세 연결을 마지막 프레임에서 보여준다.
- 런타임 캡처 manifest도 `replay decoration`, `achievement replay decoration` 키워드를 남기도록 갱신했다.
- 마케팅 자산 감사의 스크린샷/트레일러 프레임 manifest 조건을 강화해 반복 장식 장면 설명이 빠지면 실패하도록 했다.
- 빌드 로그: `Logs/build_marketing_replay_decoration.log`, `Build Finished, Result: Success`.
- 상점 스크린샷 캡처 로그: `Logs/runtime_capture_store_replay_decoration_window.log`, 7장 캡처 완료.
- 트레일러 프레임 캡처 로그: `Logs/runtime_capture_trailer_replay_decoration.log`, 12장 캡처 완료.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_replay_decoration.log`, `checkCount=36`, `passedCheckCount=36`, `passesMarketingAssetGate=true`, `validScreenshotCount=7`, `validTrailerFrameCount=12`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_marketing_replay_decoration.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`, `Steam 마케팅 자산 감사 QA passed=true`.

### 2026-05-31 캠페인 기록 기준별 추세 요약

- 캠페인 기록 본문 상단의 장기 추세 패널 아래에 `기준별 추세` 요약 줄을 추가했다.
- 최근 캠페인 기록을 균형/지원/긴축 운영 기준별로 나눠 회차 수, 평균 점수, 평균 권장 일치율, 반복 목표 회차를 한 줄에 표시한다.
- 기록이 없는 운영 기준도 `0회`로 표시해 플레이어가 아직 비어 있는 반복 플레이 축을 바로 파악할 수 있게 했다.
- 캠페인 기록 스모크가 `bodyMentionsMandateTrend=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 캠페인 기록 QA 조건에 기준별 추세 검증을 추가했다.
- 빌드 로그: `Logs/build_career_record_mandate_trend.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_mandate_trend.log`, `completed=true`, `bodyMentionsLongTermTrend=true`, `bodyMentionsMandateTrend=true`, `recordHasDetailSummary=true`, `detailMentionsInvestigationTimeline=true`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/career_records/care_review_career_record_smoke_result_mandate_trend.json`, `Builds/QA/v0.3.0/career_records/care_review_career_records_mandate_trend.png`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_mandate_trend.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_mandate_trend.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`.

### 2026-05-31 성과 반복 보상 이력 패널

- 성과 기록 화면 하단 카드와 버튼 사이에 `반복 보상 이력` 패널을 추가했다.
- 현재 반복 목표 완료 횟수, 현재 상위 단계/장식, 2회 동색 인장, 4회 은색 카드, 6회 금색 엔딩 장식의 해금/대기 상태를 한 줄에 표시한다.
- 반복 기록이 없는 상태에서도 2/4/6회 보상 계획과 다음 보상 회차가 보이도록 구성했다.
- 성과 기록 스모크에 `achievementReplayRewardPanelMentionsTierPlan=true`를 추가했다.
- 상위 반복 단계 장식 스모크에 `achievementReplayRewardPanelMentionsGoldHistory=true`를 추가해 6회 완료 시 별도 패널이 금색 장식 이력을 표시하는지 검증한다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 성과/상위 반복 QA 조건도 보상 이력 패널 필드까지 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_achievement_reward_history_panel.log`, 반환 코드 0, 새 컴파일 오류 없음.
- 성과 기록 스모크: `Logs/runtime_achievement_reward_history_panel.log`, `completed=true`, `achievementReplayRewardPanelMentionsTierPlan=true`.
- 상위 반복 단계 장식 스모크: `Logs/runtime_advanced_replay_tier_reward_history_panel.log`, `completed=true`, `achievementReplayRewardPanelMentionsGoldHistory=true`, `advancedReplayChallengeTier=상위 단계 3`, `advancedReplayChallengeDecoration=금색 엔딩 장식`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_achievement_reward_history_panel.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/achievements/care_review_achievement_smoke_result_reward_history_panel.json`, `Builds/QA/v0.3.0/achievements/care_review_advanced_replay_tier_smoke_result_reward_history_panel.json`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_reward_history_panel.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_reward_history_panel.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`.

### 2026-05-31 캠페인 기록 운영 기준 필터

- 캠페인 기록 헤더에 `전체`, `균형`, `지원`, `긴축` 필터 버튼을 추가했다.
- 선택한 운영 기준에 맞춰 최근 기록 표, 장기 추세 패널, 기준별 추세, 상세 패널, 대표/조사 사례 버튼이 같은 기록 집합을 보도록 연결했다.
- 선택 기준에 기록이 없으면 빈 상태 문구와 전체 기준별 추세를 함께 표시한다.
- 캠페인 기록 스모크가 `mandateFilterButtonsActive=true`, `bodyMentionsMandateFilter=true`, `mandateFilterAppliesToRecord=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 캠페인 기록 QA 조건도 운영 기준 필터 필드까지 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_career_record_mandate_filter_final.log`, 반환 코드 0, 새 컴파일 오류 없음.
- 캠페인 기록 스모크: `Logs/runtime_career_record_mandate_filter_final_rerun.log`, `completed=true`, `activeMandateFilter=긴축 감사`, `mandateFilterAppliesToRecord=true`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/career_records/care_review_career_record_smoke_result_mandate_filter.json`, `Builds/QA/v0.3.0/career_records/care_review_career_records_mandate_filter.png`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_mandate_filter.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_mandate_filter.log`, `checkCount=66`, `passedCheckCount=66`, `localBlockerCount=0`.

### 2026-05-31 플레이테스트 반복 가치감 설문 연결

- 인게임 플레이테스트 설문 5점 척도에 `반복 보상/장기 기록 가치감` 항목을 추가했다.
- 설문 Markdown에 성과 반복 보상, 캠페인 기록 장기 추세, 운영 기준별 기록 필터가 다시 플레이할 이유로 느껴졌는지 확인하는 문구를 추가했다.
- 설문 JSON에는 `replayRewardValueRating` 필드를 저장한다.
- 다중 세션 집계 CSV에 `replay_reward_value_rating` 컬럼을 추가하고, JSON/Markdown 집계에 평균 반복 보상/장기 기록 가치감과 낮은 반복 가치감 신호를 표시한다.
- 기존 설문 파일은 새 필드가 없을 수 있으므로 집계 시 `replayRewardValueRating`이 0이면 기존 `priceValueRating`으로 보정해 과거 QA 샘플도 깨지지 않게 했다.
- 인게임 설문 스모크가 `jsonHasReplayRewardValueRating=true`, `markdownMentionsReplayRewardValue=true`를 검증하도록 보강했다.
- 플레이테스트 집계 스모크가 `replay_reward_value_rating`, `averageReplayRewardValueRating`, `평균 반복 보상/장기 기록 가치감`을 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_playtest_replay_value_survey.log`, `Build Finished, Result: Success`.
- 인게임 설문 스모크: `Logs/runtime_playtest_survey_replay_value.log`, `completed=true`, `jsonHasReplayRewardValueRating=true`, `markdownMentionsReplayRewardValue=true`.
- 플레이테스트 집계 스모크: `Logs/runtime_playtest_aggregate_replay_value.log`, `completed=true`, `sessionCount=169`, `surveySessionCount=7`, `csvHasSurveyColumns=true`, `jsonHasSurveyAverages=true`, `markdownMentionsSurvey=true`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/playtest_packet/care_review_playtest_survey_smoke_result_replay_value.json`, `Builds/QA/v0.3.0/playtest_packet/care_review_in_game_feedback_replay_value_sample.md`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_playtest_replay_value_survey.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_replay_value_survey.log`, `checkCount=67`, `passedCheckCount=67`, `localBlockerCount=0`, `인게임 플레이테스트 설문 QA passed=true`.

### 2026-05-31 성과 반복 단계 기록 버튼

- 성과 기록 화면의 `반복 보상 이력` 패널에 `2회`, `4회`, `6회` 단계별 기록 버튼을 추가했다.
- 각 버튼은 해당 보상 단계가 해금되기 전에는 대기 상태로 비활성화되고, 해금 후에는 관련 캠페인 기록을 직접 연다.
- 6회 버튼은 `성과 반복 보상 6회: 금색 엔딩 장식` 포커스 맥락으로 캠페인 기록을 열고, 관련 회차에 `▶` 마커를 표시한다.
- 상위 반복 단계 장식 스모크가 `achievementReplayTierRecordButtonsActive=true`, `achievementReplayTierRecordButtonOpensCareer=true`를 검증하도록 보강했다.
- 릴리즈 후보 감사와 Steam 제출 프리플라이트의 상위 반복 챌린지 단계 장식 QA 조건도 단계별 기록 버튼까지 요구하도록 갱신했다.
- 빌드 로그: `Logs/build_achievement_tier_record_buttons.log`, `Build Finished, Result: Success`.
- 상위 반복 단계 장식 스모크: `Logs/runtime_advanced_replay_tier_record_buttons_rerun.log`, `completed=true`, `achievementReplayTierRecordButtonsActive=true`, `achievementReplayTierRecordButtonOpensCareer=true`.
- 성과 기록 회귀 스모크: `Logs/runtime_achievement_tier_record_buttons.log`, `completed=true`, `achievementReplayRewardPanelMentionsTierPlan=true`.
- 저해상도 UI 회귀 스모크: `Logs/runtime_low_resolution_achievement_tier_record_buttons.log`, `completed=true`, `screenshotCount=33`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/achievements/care_review_advanced_replay_tier_smoke_result_tier_record_buttons.json`, `Builds/QA/v0.3.0/achievements/care_review_achievements_tier_record_buttons.png`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_tier_record_buttons.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_tier_record_buttons.log`, `checkCount=67`, `passedCheckCount=67`, `localBlockerCount=0`.

### 2026-05-31 마케팅 캠페인 기록 필터 장면

- 상점 스크린샷 세트에 `08_career_record_filter.png`를 추가해 캠페인 기록 운영 기준 필터, 기준별 추세, 장기 추세 패널을 첫눈에 보이게 했다.
- 트레일러 프레임 세트에 `trailer_013_career_record_filter.png`를 추가하고 manifest의 의도 런타임을 `49 seconds`로 갱신했다.
- 런타임 캡처 manifest와 마케팅 자산 감사가 `career record mandate filter`, `long-term trend`, `13 45-49s career record mandate filter` 토큰을 요구하도록 강화했다.
- 마케팅 감사 게이트와 Steam 제출 프리플라이트의 기준 수량을 상점 스크린샷 8장, 트레일러 프레임 13장으로 갱신했다.
- 새 이미지 검수: `Builds/Marketing/v0.3.0/screenshots/08_career_record_filter.png`, `Builds/Marketing/v0.3.0/trailer_frames/trailer_013_career_record_filter.png`, 둘 다 `1920x1080`, 비검은 화면 확인.
- 빌드 로그: `Logs/build_marketing_career_filter_gate.log`, `Build Finished, Result: Success`.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_career_filter_gate.log`, `checkCount=38`, `passedCheckCount=38`, `passesMarketingAssetGate=true`, `validScreenshotCount=8`, `validTrailerFrameCount=13`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/marketing_assets/audit_marketing_assets_career_filter.log`, `Builds/QA/v0.3.0/marketing_assets/care_review_marketing_asset_smoke_result.json`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_marketing_career_filter.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_marketing_career_filter.log`, `checkCount=67`, `passedCheckCount=67`, `localBlockerCount=0`, `Steam 마케팅 자산 감사 QA passed=true`.

### 2026-05-31 반복 가치감 상용화 트리아지 반영

- 10달러 상용화 트리아지 리포트가 설문 `replayRewardValueRating`을 읽어 `averageReplayRewardValueRating`으로 집계하도록 확장했다.
- 기존 QA 설문처럼 새 필드가 없는 세션은 `priceValueRating`으로 보정해 과거 샘플도 계속 트리아지에 포함되게 했다.
- 평균 반복 보상/장기 기록 가치감이 4점 미만이면 조치 우선순위에 `반복 보상/장기 기록 가치감` high 항목을 별도로 추가한다.
- 트리아지 JSON/CSV/Markdown/HTML에 `replayRewardValueRating`, `replay_reward_value`, `평균 반복 보상/장기 기록 가치감`, `반복 가치` 열을 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사의 10달러 상용화 트리아지 조건이 `hasReplayRewardValuePriority=true`와 Markdown의 반복 가치감 우선순위를 요구하도록 강화됐다.
- 회수 감사 로그: `Logs/audit_playtest_collection_replay_value_triage.log`, `sessions=77`, `complete=1`.
- 트리아지 스모크: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_smoke_result.json`, `completed=true`, `averageReplayRewardValueRating=3.0`, `hasReplayRewardValuePriority=true`, `actionCount=7`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/playtest_collection_audit/audit_playtest_collection_replay_value_triage.log`.

### 2026-05-31 성과 반복 단계 버튼 포커스 QA

- 컨트롤러 포커스 이동 스모크가 성과 기록 화면까지 열고 반복 보상 단계 버튼 `2회`, `4회`, `6회`를 직접 선택 대상으로 검증하도록 확장했다.
- 스모크 내부에서 반복 보상 6회 커리어 기록을 시드한 뒤 `achievementReplayTierRecordButtons` 3개를 EventSystem 선택 대상으로 잡아 활성 루트 포함 여부와 포커스 외곽선을 확인한다.
- QA 결과에 `achievementHasSelection`, `achievementHasFocusHighlight`, `achievementTierRecordButtonsFocusable`, `achievementTierRecordSelectionIsTierButton`, `achievementSelected` 필드를 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사의 컨트롤러 포커스 이동 QA 조건이 성과 반복 단계 버튼 포커스 필드를 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_focus_navigation_tier_record_buttons.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_navigation_tier_record_buttons.log`, `completed=true`, `achievementTierRecordButtonsFocusable=true`, `achievementTierRecordSelectionIsTierButton=true`, `achievementSelected=2회`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `Builds/QA/v0.3.0/runtime_focus_navigation_tier_record_buttons.log`.

### 2026-05-31 상점 스크린샷 캡션 보강

- `Docs/Steam_상점페이지_자료.md`의 스크린샷 구성안에 8번째 `캠페인 기록 필터` 장면을 추가했다.
- `Docs/Steam_상점페이지_제출안.md`의 스크린샷 업로드 순서를 8장 기준으로 갱신하고 각 이미지별 상점 캡션 역할을 붙였다.
- `08_career_record_filter.png`를 최종 리포트 직후 5번째 업로드 후보로 배치해 운영 기준 필터, 기준별 장기 추세, 반복 보상 연결을 상점에서 먼저 보여주게 했다.
- 릴리즈 후보 감사의 상점 메타데이터/제출안 사본 동기화 조건이 `08_career_record_filter.png`, `캠페인 기록 필터`, `최종 리포트 직후` 토큰을 요구하도록 강화됐다.

### 2026-05-31 트리아지 담당 화면별 체크리스트

- 10달러 상용화 트리아지 액션에 `ownerScreen` 필드를 추가해 각 보강 항목이 어느 화면/문서 담당인지 바로 보이게 했다.
- 반복 보상/장기 기록 가치감 액션은 `성과 기록 / 캠페인 기록 / 상점 페이지`로 배정했다.
- 트리아지 Markdown/HTML에 `담당 화면별 체크리스트` 섹션을 추가했다.
- 트리아지 JSON은 각 action에 `ownerScreen`을 저장하고, 스모크는 `hasSurfaceActionChecklist=true`를 검증한다.
- 회수 감사 로그: `Logs/audit_playtest_collection_surface_action_checklist.log`, `sessions=77`, `complete=1`.
- 트리아지 스모크: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_smoke_result.json`, `completed=true`, `hasReplayRewardValuePriority=true`, `hasSurfaceActionChecklist=true`, `actionCount=7`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/playtest_collection_audit/audit_playtest_collection_surface_action_checklist.log`.

### 2026-05-31 엔딩/캠페인 기록 필터 포커스 QA

- 컨트롤러 포커스 이동 스모크가 엔딩 기록의 캠페인 기록 연결 버튼과 캠페인 기록 화면의 운영 기준 필터 버튼까지 검증하도록 확장했다.
- 스모크 시드 기록의 엔딩 ID를 실제 카탈로그 ID `paperwork_night`와 맞춰 엔딩 기록 카드의 `장식 기록` 버튼이 활성화되게 했다.
- QA 결과에 `endingGalleryHasSelection`, `endingGalleryRecordButtonsFocusable`, `endingGalleryRecordSelectionIsRecordButton`, `careerRecordMandateFilterButtonsFocusable`, `careerRecordMandateFilterSelectionIsFilterButton` 필드를 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사의 컨트롤러 포커스 이동 QA 조건이 엔딩 기록/캠페인 기록 필터 포커스 필드를 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_focus_navigation_ending_career_filters_retry.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_navigation_ending_career_filters.log`, `completed=true`, `endingGalleryRecordButtonsFocusable=true`, `endingGalleryRecordButtonFocusCount=1`, `careerRecordMandateFilterButtonsFocusable=true`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `Builds/QA/v0.3.0/runtime_focus_navigation_ending_career_filters.log`.

### 2026-05-31 트리아지 담당 화면 CSV

- 10달러 상용화 트리아지에서 담당 화면별 조치 목록을 별도 CSV `care_review_playtest_commercial_triage_actions.csv`로 내보내도록 추가했다.
- CSV 열은 `priority,area,owner_screen,evidence,recommendation`으로 구성해 QA/작업표에 바로 붙일 수 있게 했다.
- 스모크 결과에 `hasSurfaceActionChecklistCsv=true`를 추가하고, Steam 제출 프리플라이트와 릴리즈 후보 감사가 CSV의 `owner_screen`, `반복 보상/장기 기록 가치감`, `성과 기록 / 캠페인 기록 / 상점 페이지` 토큰을 요구하도록 강화했다.
- 회수 감사 로그: `Logs/audit_playtest_collection_surface_action_csv.log`, `sessions=77`, `complete=1`.
- 트리아지 스모크: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_smoke_result.json`, `completed=true`, `hasSurfaceActionChecklistCsv=true`, `actionCount=7`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/playtest_collection_audit/audit_playtest_collection_surface_action_csv.log`.

### 2026-05-31 트레일러 리마스터 작업표

- `Docs/트레일러_리마스터_작업표.md`를 추가해 49초 프레임 구성안과 실제 45.000초 Steam 업로드 후보의 차이를 별도 작업으로 분리했다.
- 작업표는 현재 업로드 후보 MP4를 유지하되, 다음 리마스터에서 13개 프레임을 45초 타임라인에 재배치하고 `trailer_013_career_record_filter.png`를 `41-45s` 마지막 구간에 두도록 정리한다.
- `PrepareSteamworksDepot`가 작업표를 `store_page/TRAILER_REMASTER_WORK_ORDER_KO.md`로 복사하도록 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사가 작업표 사본, `45.000s`, `49초`, `trailer_013_career_record_filter.png`, `41-45s` 토큰을 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_trailer_remaster_work_order.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_trailer_remaster_work_order.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_remaster_work_order.log`, `checkCount=68`, `passedCheckCount=68`, `localBlockerCount=0`.

### 2026-05-31 후속 연락함/사례 자료실 포커스 QA

- 컨트롤러 포커스 이동 스모크가 후속 연락함의 `심사 기록`, `로그 저장`, `닫기` 버튼과 사례 자료실의 `필터`, `이전`, `다음`, `목표 심사`, `새 캠페인`, `메인 메뉴` 버튼을 직접 검증하도록 확장했다.
- 후속 연락함 액션 버튼과 사례 자료실 하단 조작 버튼을 배열 필드로 보관해 포커스 QA에서 명시 대상으로 잡을 수 있게 했다.
- QA 결과에 `followUpInboxActionButtonsFocusable`, `followUpInboxSelectionIsActionButton`, `caseArchiveNavigationButtonsFocusable`, `caseArchiveSelectionIsNavigationButton` 필드를 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사의 컨트롤러 포커스 이동 QA 조건이 후속 연락함/사례 자료실 필터 큐 포커스 필드를 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_focus_navigation_inbox_archive_filters.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_navigation_inbox_archive_filters.log`, `completed=true`, `followUpInboxActionButtonsFocusable=true`, `caseArchiveNavigationButtonsFocusable=true`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `Builds/QA/v0.3.0/runtime_focus_navigation_inbox_archive_filters.log`.

### 2026-05-31 외부 handoff 트리아지 작업표

- 외부 검증 handoff 패킷에 `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`를 포함하도록 추가했다.
- 파일 내용은 `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_actions.csv`의 스냅샷이며, Steamworks 루트에도 함께 복사된다.
- `EXTERNAL_RELEASE_HANDOFF_KO.md`의 증거 위치와 `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `HUMAN_10_COMMERCIAL` 항목이 actions CSV를 참조하도록 갱신했다.
- 모집 운영안에 회수 담당자가 `owner_screen` 열 기준으로 10달러 가치감/반복 보상/UI/난이도 보강 항목을 담당 화면별 작업표에 옮기도록 안내했다.
- 빌드 로그: `Logs/build_external_handoff_triage_actions.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_external_handoff_triage_actions.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_handoff_triage_actions.log`, `checkCount=68`, `passedCheckCount=68`, `localBlockerCount=0`.

### 2026-05-31 트레일러 45초 리마스터 리컷

- `Builds/Marketing/v0.3.0/trailer/render_trailer_remaster_45s.ps1`를 추가해 리마스터 작업표의 13개 프레임/45초 재배치안을 실제 ffmpeg 리컷으로 실행할 수 있게 했다.
- 스크립트가 `trailer_sequence_remaster_45s.txt`, `care_review_office_trailer_steam_upload_v0.3.0_remaster.mp4`, `trailer_steam_upload_remaster_contact_sheet.png`, `trailer_steam_upload_remaster_probe.json`을 생성한다.
- 43초 샘플 `trailer_remaster_43s_check.png`로 마지막 `trailer_013_career_record_filter.png` 장면이 41-45초 구간에 노출되는지 확인했다.
- 리컷 산출물 규격: `45.000s`, H.264, `1920x1080`, `30fps`, AAC stereo.
- 블랙 프레임 점검: `Logs/ffmpeg_trailer_steam_upload_remaster_blackdetect.log`, `black_start` 없음.
- 빌드 로그: `Logs/build_trailer_remaster_ffmpeg_script.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_trailer_remaster_ffmpeg_script.log`, `Care Review Office Steamworks depot prepared`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_remaster_ffmpeg_script.log`, `checkCount=69`, `passedCheckCount=69`, `localBlockerCount=0`.

### 2026-05-31 플레이테스트 설문/지원 번들 포커스 QA

- 컨트롤러 포커스 이동 스모크가 설정 화면의 `지원 번들` 버튼과 플레이테스트 설문의 평점 +/- 버튼, 빠른 체크 버튼, 하단 액션 버튼을 직접 검증하도록 확장했다.
- 설문 UI의 12개 평점 버튼, 4개 체크 버튼, 3개 액션 버튼을 배열 필드로 보관해 EventSystem 선택 대상으로 순회할 수 있게 했다.
- QA 결과에 `settingsSupportBundleButtonFocusable`, `playtestSurveyRatingButtonsFocusable`, `playtestSurveyFlagButtonsFocusable`, `playtestSurveyActionButtonsFocusable`, `playtestSurveySelectionIsActionButton` 필드를 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사의 컨트롤러 포커스 이동 QA 조건이 설문/지원 번들 포커스 필드를 요구하도록 강화됐다.
- 빌드 로그: `Logs/build_focus_navigation_survey_support_bundle.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_navigation_survey_support_bundle.log`, `completed=true`, `settingsSupportBundleButtonFocusable=true`, `playtestSurveyRatingButtonFocusCount=12`, `playtestSurveyFlagButtonFocusCount=4`, `playtestSurveyActionButtonFocusCount=3`.
- QA 보관 사본 갱신: `Builds/QA/v0.3.0/care_review_focus_navigation_smoke_result.json`, `Builds/QA/v0.3.0/runtime_focus_navigation_survey_support_bundle.log`.

### 2026-05-31 handoff actions CSV 배포 무결성 감사

- 외부 검증 handoff zip 생성 경로를 갱신해 `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`가 `v0.3.0/PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`로 포함되도록 했다.
- `BuildDistributionIntegrityAudit`가 handoff 폴더의 actions CSV와 handoff zip 내부 CSV를 각각 별도 체크로 검증하도록 강화했다.
- 배포 무결성 스모크 결과에 `hasHandoffTriageActionsCsv`와 `handoffZipContainsTriageActionsCsv` 필드를 추가했고, 릴리즈 후보 감사가 두 필드를 요구하도록 갱신했다.
- handoff zip 새 SHA256: `E44C019AA23AAB09F434B387DFDF283A6C0B8A5F51874670661A80D21EFB67AE`, 크기 `13,623 bytes`.
- 배포 무결성 감사: `Logs/audit_release_candidate_handoff_actions_zip_doc_gate.log` 실행 중 생성, `completed=true`, `allPassed=true`, `checkCount=15`, `passedCheckCount=15`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_actions_zip_doc_gate.log`, `checkCount=69`, `passedCheckCount=69`, `localBlockerCount=0`.

### 2026-05-31 트레일러 리마스터 승격 기준

- 마케팅 감사가 `care_review_office_trailer_steam_upload_v0.3.0_remaster.mp4`를 공식 업로드 후보와 분리된 리마스터 후보로 검증하도록 확장했다.
- `Builds/Marketing/v0.3.0/trailer/trailer_remaster_promotion_gate.md`를 생성해 `promotion_decision: not_promoted`, 현재 업로드 후보, 리마스터 후보, 승격 조건을 명시했다.
- 현재 공식 업로드 후보는 46,239,809 bytes 고비트레이트 MP4이며, 리마스터 후보는 4,426,307 bytes 검증 후보로 유지한다.
- 마케팅 스모크 결과에 `trailerRemasterCandidateReady=true`, `hasTrailerRemasterPromotionGate=true`, `trailerRemasterPromotedAsSteamUpload=false`를 추가했다.
- 마케팅 감사: `Logs/audit_marketing_assets_trailer_remaster_promotion_gate.log`, `passesMarketingAssetGate=true`, `checkCount=40`, `passedCheckCount=40`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_trailer_remaster_promotion_gate.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_remaster_promotion_gate.log`, `checkCount=70`, `passedCheckCount=70`, `localBlockerCount=0`.

### 2026-05-31 캠페인 기록 성장 비교

- 캠페인 기록 화면의 장기 추세/기준별 추세 아래에 `성장 비교` 행을 추가했다.
- 선택 회차 기준으로 직전 기록 대비 점수, 권장 판단 일치율, 잔여 예산, 위험 지표 변화를 계산하고, 이전 최고 점수 대비 차이와 다음 개선 초점을 함께 표시한다.
- 단일 기록만 있을 때는 다음 완료 회차부터 비교가 열린다는 안내를 보여 기존 저장 데이터와 호환되도록 했다.
- 커리어 기록 스모크에 과거 기준 기록을 시드해 실제 2회 기록 상태에서 비교 행을 검증하도록 확장했다.
- 빌드: `Logs/build_career_growth_comparison_retry.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_career_growth_comparison_smoke_retry.log`, `completed=true`, `recordCount=2`, `hasBaselineRecord=true`, `bodyMentionsGrowthComparison=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_growth_comparison.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 비교 마케팅 캡처 반영

- 자동화 실행 시 그래픽 캡처 창이 포커스를 잃어도 진행되도록 `Application.runInBackground=true`를 자동화 인자 실행에 적용했다.
- 상점 스크린샷 manifest의 `08_career_record_filter.png` 설명에 `growth comparison`을 추가했다.
- 트레일러 프레임 manifest의 13번째 장면 설명도 `career record mandate filter, long-term trend, and growth comparison`으로 갱신했다.
- 마케팅 감사가 상점 스크린샷 manifest와 트레일러 프레임 manifest에서 `growth comparison` 토큰을 요구하도록 강화했다.
- Steam 상점 자료/제출안은 `08_career_record_filter.png`를 운영 기준 필터, 장기 추세, 직전/이전 최고 대비 성장 비교 장면으로 설명한다.
- 캡처 검증: `Logs/runtime_store_screenshots_growth_comparison_retry.log`, `08_career_record_filter.png` 1,785,871 bytes, manifest 422 bytes.
- 트레일러 프레임 검증: `Logs/runtime_trailer_frames_growth_comparison.log`, `trailer_013_career_record_filter.png` 1,786,200 bytes, manifest 594 bytes.
- 마케팅 감사: `Logs/audit_marketing_assets_growth_comparison.log`, `passesMarketingAssetGate=true`, `checkCount=44`, `passedCheckCount=44`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_comparison_marketing.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_comparison_marketing.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 메인 메뉴 최근 성장 프롬프트

- 메인 메뉴 상태줄에 `최근 성장` 요약을 추가해 새 캠페인 시작 전 직전 회차 대비 점수, 권장 일치율, 위험 변화, 개선 초점을 바로 확인할 수 있게 했다.
- 완료 기록이 2회 미만이면 다음 완료 회차부터 성장 비교가 열린다는 안내를 표시한다.
- 메인 메뉴 목표 사례 스모크가 2개 캠페인 기록을 시드하고 `menuMentionsGrowthPrompt=true`를 검증하도록 확장했다.
- 빌드: `Logs/build_main_menu_growth_prompt.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_main_menu_growth_prompt.log`, `completed=true`, `menuMentionsGrowthPrompt=true`, `menuStatus`에 `최근 성장: 직전 대비 점수 +21점 · 권장 +18p · 위험 -12p · 판단 품질 상승` 노출.

### 2026-05-31 성장 심사 재도전 목표

- 메인 메뉴에 `성장 심사` 버튼과 `Y` 단축키를 추가했다.
- 완료 기록 2회 이상일 때 직전 회차 대비 점수/권장/위험/예산 변화를 읽어 권장 회복, 위험 회복, 예산 회복, 상승 유지 중 하나의 다음 회차 목표를 만든다.
- 성장 목표는 기존 추천 심사 흐름을 사용해 바로 튜토리얼/새 회차로 진입하며, 선택된 운영 기준과 챌린지가 캠페인 시작 상태에 저장된다.
- 성장 목표로 시작한 회차는 캠페인 기록의 마지막 회차 세부에 `성장 목표`와 `성장 근거`로 남는다.
- 메인 메뉴 목표 사례 스모크를 확장해 버튼 준비, 추천 심사 시작, 한 회차 완료 후 캠페인 기록 저장까지 검증한다.
- 빌드: `Logs/build_growth_objective_record.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_objective_record.log`, `completed=true`, `growthObjectiveButtonReady=true`, `growthObjectiveStartsRecommendedCampaign=true`, `growthObjectiveRecordSaved=true`, `careerRecordMentionsGrowthObjective=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_objective_replay.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_objective_replay.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 심사 시작 브리핑

- 성장 심사로 새 회차를 시작하면 첫 운영 기준 브리핑에 `성장 심사 목표` 섹션을 추가해 목표와 직전 회차 대비 근거를 보여준다.
- 브리핑 체크리스트에도 `성장 목표와 직전 회차 대비 개선 기준`을 추가해 플레이어가 이번 회차의 개선 기준을 시작 전에 확인하게 했다.
- 메인 메뉴 목표 사례 스모크가 성장 심사 버튼, 브리핑, 한 회차 완료, 캠페인 기록 저장을 모두 검증하도록 확장됐다.
- 빌드: `Logs/build_growth_objective_briefing.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_objective_briefing.log`, `completed=true`, `growthBriefingMentionsObjective=true`, `growthObjectiveRecordSaved=true`, `careerRecordMentionsGrowthObjective=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_objective_briefing.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_objective_briefing.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 심사 진행도 HUD

- 성장 심사로 시작한 회차에서는 심사 화면 오른쪽 기준표에 `성장 목표 진행` 블록을 표시한다.
- 진행도는 목표 문구, 처리 수, 현재 권장 판단 일치율, 위험 합계, 남은 예산을 실시간으로 보여준다.
- 판단 후에도 기준표가 갱신되므로 플레이어가 성장 목표를 보며 다음 사례 판단을 조정할 수 있다.
- 메인 메뉴 목표 사례 스모크가 성장 심사 시작 직후 기준표의 `성장 목표 진행` 문구와 `처리 0/40` 초기 상태를 검증하도록 확장됐다.
- 빌드: `Logs/build_growth_objective_review_hud.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_objective_review_hud.log`, `completed=true`, `growthReviewHudMentionsObjective=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_objective_review_hud.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_objective_review_hud.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 심사 결과 판정

- 성장 심사 완료 시 직전 캠페인 기록을 기준선으로 삼아 목표별 성공/미달을 계산하도록 했다.
- `권장 판단 일치율`, `위험 지표 낮추기`, `예산 손실 줄이기`, `판단 품질 유지` 목표를 각각 다른 판정식으로 처리한다.
- 최종 리포트 요약/분석/다음 목표 영역에 `성장 목표 판정`을 추가했고, 캠페인 기록 마지막 회차 세부에는 `성장 판정`과 `성장 해석`을 저장한다.
- 빌드: `Logs/build_growth_objective_result.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_objective_result.log`, `completed=true`, `reportMentionsGrowthObjectiveResult=true`, `growthObjectiveResultSaved=true`, `careerRecordMentionsGrowthObjectiveResult=true`.
- QA 보관 사본: `Builds/QA/v0.3.0/care_review_main_menu_case_objective_smoke_result.json`, `growthRecordProgress=권장 100%/62% · 직전 53%`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_objective_result.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_objective_result_qa_body.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 후속 추천 목표

- 성장 목표 성공/미달 판정이 다음 회차 추천 목표를 다시 쓰도록 연결했다.
- 성공 시에는 `성장 후속` 목표를 만들어 권장 회복 후 지원 확대, 위험 안정 후 지원 폭 확장, 예산 회복 후 판단 품질 회복처럼 다음 실험을 넓힌다.
- 미달 시에는 `성장 보정` 목표를 만들어 같은 약점을 더 좁은 기준으로 재도전하게 했다.
- 메인 메뉴 목표 사례 스모크가 최종 리포트 `다음 목표`, 캠페인 기록 `다음 기준`, 저장된 `nextCampaignChallenge`에 `성장 후속`이 남는지 검증한다.
- 빌드: `Logs/build_growth_follow_up_objective.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_follow_up_objective.log`, `completed=true`, `reportMentionsGrowthFollowUpObjective=true`, `growthFollowUpObjectiveSaved=true`, `careerRecordMentionsGrowthFollowUpObjective=true`.
- QA 보관 사본: `Builds/QA/v0.3.0/care_review_main_menu_case_objective_smoke_result.json`, `growthFollowUpChallenge=성장 후속: 권장 80% 유지하며 고위험 대응 폭 확장`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_objective.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_objective.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 후속 노출 강화

- 최종 리포트 이후 메인 메뉴 상태줄에 `추천 대기` 행을 추가해 보류 중인 다음 회차 목표와 근거를 바로 보여준다.
- 추천 심사 버튼은 성장 결과 기반 목표일 때 `성장 후속 시작` 또는 `성장 보정 시작`으로 바뀐다.
- 메인 메뉴 목표 사례 스모크가 `menuMentionsGrowthFollowUpObjective=true`, `recommendationButtonMentionsGrowthFollowUp=true`를 검증한다.
- 상점 스크린샷/트레일러 프레임의 캠페인 기록 시드에 `성장 목표`, `성장 판정`, `성장 후속` 다음 목표를 넣고 manifest 설명에 `growth follow-up objective`를 추가했다.
- 빌드: `Logs/build_growth_follow_up_visibility.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_follow_up_visibility.log`, `completed=true`, `추천 대기`, `성장 후속 시작: 지원 확대`.
- 그래픽 캡처: `Logs/runtime_store_screenshots_growth_follow_up_visibility_visible.log`, `Logs/runtime_trailer_frames_growth_follow_up_visibility_visible.log`, `08_career_record_filter.png` 1,786,461 bytes, `trailer_013_career_record_filter.png` 1,786,471 bytes.
- 마케팅 감사: `Logs/audit_marketing_assets_growth_follow_up_visibility_visible.log`, `passesMarketingAssetGate=true`, `checkCount=44`, `passedCheckCount=44`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_visibility.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_visibility.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 후속 브리핑/HUD

- `성장 후속 시작` 또는 `성장 보정 시작`으로 추천 심사를 시작하면 해당 회차 상태에 성장 후속 목표/근거를 저장하도록 했다.
- 시작 브리핑에는 `성장 후속 목표` 섹션을 추가해 직전 성장 판정의 성공/미달 결과가 다음 운영 기준 실험으로 이어진다는 점을 보여준다.
- 튜토리얼 체크리스트에는 `성장 후속 목표와 다음 운영 기준 실험`을 추가했다.
- 심사 화면 기준표에는 `성장 후속 진행` 블록을 표시해 처리 수, 권장 판단 일치율, 위험 합계, 예산을 실시간 추적한다.
- 빌드: `Logs/build_growth_follow_up_briefing_hud.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_follow_up_briefing_hud.log`, `completed=true`, `growthFollowUpStartsRecommendedCampaign=true`, `growthFollowUpBriefingMentionsObjective=true`, `growthFollowUpReviewHudMentionsObjective=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_briefing_hud.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_briefing_hud.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 후속 완료 기록

- 성장 후속/보정 목표로 시작한 회차가 완료되면 캠페인 기록에 `성장 후속 목표`와 `성장 후속 근거`를 저장하도록 했다.
- `CareerRecord`에 성장 후속 시작 여부, 제목, 챌린지, 근거 필드를 추가했다.
- 메인 메뉴 목표 사례 스모크가 성장 목표 회차 완료 뒤 성장 후속 회차까지 한 번 더 완료하고, 최신 캠페인 기록에 후속 목표가 남는지 검증한다.
- 빌드: `Logs/build_growth_follow_up_completion_record.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_growth_follow_up_completion_record.log`, `completed=true`, `growthFollowUpRecordSaved=true`, `careerRecordMentionsGrowthFollowUpCompletion=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_completion_record.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_completion_record.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 캠페인 기록 성장 필터

- 캠페인 기록 화면의 운영 기준 필터에 `성장`과 `후속` 버튼을 추가했다.
- `성장` 필터는 성장 목표로 시작했거나 성장 목표/판정 기록이 남은 회차만 보여준다.
- `후속` 필터는 성장 후속/보정 목표로 시작했거나 성장 후속 근거가 남은 회차만 보여준다.
- 커리어 기록 스모크의 기준 기록에 성장 목표, 성장 판정, 성장 후속 목표/근거를 시드하고 필터 본문/상태/적용 기록을 검증하도록 확장했다.
- 필터 검증 뒤 전체 기록으로 되돌려 대표 사례/조사 메모 아카이브 바로 열기 검증이 현재 회차를 계속 대상으로 잡도록 했다.
- 빌드: `Logs/build_career_growth_filters_fix.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_career_growth_filters_fix.log`, `completed=true`, `bodyMentionsGrowthFilter=true`, `growthFilterAppliesToRecord=true`, `bodyMentionsGrowthFollowUpFilter=true`, `growthFollowUpFilterAppliesToRecord=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_growth_filters_fix.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_growth_filters_fix.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 캠페인 기록 성장 필터 포커스 QA

- 컨트롤러 포커스 이동 스모크가 캠페인 기록 기준 필터 6개 전체를 순회하도록 확장했다.
- 기존 `전체/균형/지원/긴축` 4개뿐 아니라 새 `성장/후속` 필터도 `EventSystem` 선택, 활성 루트 포함, 포커스 외곽선 표시 검증 대상에 포함된다.
- 결과 JSON에 `careerRecordMandateFilterButtonFocusCount`를 추가하고 6개 이상을 완료 조건으로 요구한다.
- 릴리즈 manifest에는 `career record growth filter focus navigation`, `career record growth follow-up filter focus navigation` 토큰을 추가했다.
- 빌드: `Logs/build_focus_growth_filter_buttons.log`, `Build Finished, Result: Success`.
- 포커스 스모크: `Logs/runtime_focus_growth_filter_buttons.log`, `completed=true`, `careerRecordMandateFilterButtonsFocusable=true`, `careerRecordMandateFilterButtonFocusCount=6`, `careerRecordMandateFilterSelectionIsFilterButton=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_focus_growth_filter_buttons.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_focus_growth_filter_buttons.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 캠페인 기록 필터 카운트 배지

- 캠페인 기록 기준 필터 버튼 라벨에 현재 필터별 기록 수를 표시하도록 했다.
- 예: `전체 2`, `긴축 1`, `성장 1`, `후속 1`처럼 저장된 회차 분포를 버튼에서 바로 확인할 수 있다.
- 성장/후속 필터는 같은 기록이라도 성장 목표와 성장 후속 목표 양쪽에 걸칠 수 있으므로 각각의 관점별 개수를 별도로 계산한다.
- 커리어 기록 스모크가 `mandateFilterButtonsMentionRecordCounts=true`를 요구하도록 확장했다.
- 빌드: `Logs/build_career_filter_count_badges.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_career_filter_count_badges.log`, `completed=true`, `mandateFilterButtonsMentionRecordCounts=true`.
- 포커스 스모크 재확인: `Logs/runtime_focus_filter_count_badges.log`, `completed=true`, `careerRecordMandateFilterButtonFocusCount=6`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_filter_count_badges.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_filter_count_badges.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 캠페인 기록 성장 목표 누적 요약

- 캠페인 기록 상단에 `성장 목표 요약` 행을 추가했다.
- 이 행은 성장 목표 회차 수, 성공/미달 수, 성장 후속/보정 회차 수, 최근 성장 판정, 최근 후속 목표를 한 줄로 요약한다.
- 기록이 없을 때는 성장 심사 완료 후 성공/미달/후속 흐름이 누적된다는 안내를 표시한다.
- 커리어 기록 스모크가 `bodyMentionsGrowthObjectiveSummary=true`를 요구하도록 확장했다.
- 릴리즈 manifest에 `career record growth objective summary` 토큰을 추가했다.
- 빌드: `Logs/build_career_growth_summary.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_career_growth_summary.log`, `completed=true`, `bodyMentionsGrowthObjectiveSummary=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_growth_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_growth_summary.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 메인 메뉴 성장 누적 요약

- 메인 메뉴 상태줄에 `성장 누적` 행을 추가했다.
- 캠페인 기록의 `성장 목표 요약`과 같은 데이터를 메인 메뉴용으로 축약해, 새 회차 시작 전 성장 목표 성공/미달/후속 누적 상태를 바로 확인할 수 있다.
- 완료 기록은 있지만 성장 목표 기록이 아직 없을 때는 `성장 목표 기록 없음` 안내를 보여준다.
- 메인 메뉴 목표 사례 스모크가 `menuMentionsGrowthObjectiveSummary=true`를 요구하도록 확장했다.
- 릴리즈 manifest에 `main menu growth objective summary` 토큰을 추가했다.
- 빌드: `Logs/build_menu_growth_summary.log`, `Build Finished, Result: Success`.
- 런타임 스모크: `Logs/runtime_menu_growth_summary.log`, `completed=true`, `menuMentionsGrowthObjectiveSummary=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_menu_growth_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_menu_growth_summary.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 루프 Steam 업적 후보

- Steam 업적 후보/로컬 성과 기록을 10개에서 12개로 확장했다.
- 새 성과 후보:
  - `CARE_GROWTH_OBJECTIVE_SUCCESS` / `성장 목표 달성`: 최근 성장 기반 심사 목표를 성공 판정으로 완료.
  - `CARE_GROWTH_FOLLOW_UP_COMPLETE` / `성장 후속 실험`: 성장 후속 또는 성장 보정 목표로 시작한 캠페인 완료.
- `EvaluateReportAchievements`가 성장 목표 결과와 성장 후속 시작 여부를 받아 두 성과를 자동 해금한다.
- 성과 기록 화면은 12개 카드가 들어가도록 카드 높이/행 간격을 조정했다.
- Steamworks 업적 후보 CSV/Markdown과 외부 게이트 증거 템플릿을 12개 API 기준으로 갱신했다.
- 빌드: `Logs/build_growth_achievements.log`, `Build Finished, Result: Success`.
- 성과 스모크: `Logs/runtime_achievement_growth_catalog.log`, `completed=true`, `achievementCatalogCount=12`, `achievementCardsMentionGrowthAchievements=true`, `achievementCatalogIncludesGrowthAchievements=true`.
- 성장 루프 스모크: `Logs/runtime_growth_achievement_unlocks.log`, `completed=true`, `growthObjectiveAchievementUnlocked=true`, `growthFollowUpAchievementUnlocked=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_achievements.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_achievements.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성장 성과 기록 바로가기

- 성과 기록 화면 하단에 `성장 기록`과 `후속 기록` 버튼을 추가했다.
- `성장 기록`은 가장 좋은 성장 목표 기록을 찾아 캠페인 기록의 `성장 심사` 필터와 해당 회차 포커스로 바로 연다.
- `후속 기록`은 성장 후속/보정 완료 기록을 찾아 캠페인 기록의 `성장 후속` 필터와 해당 회차 포커스로 바로 연다.
- 관련 기록이 없으면 성과 화면 상태 문구로 성장 심사 또는 성장 후속 회차 완료가 필요하다고 안내한다.
- 메인 메뉴 목표 사례 스모크가 두 버튼 활성화와 캠페인 기록 이동을 검증하도록 확장했다.
- 빌드: `Logs/build_achievement_growth_record_links.log`, `Build Finished, Result: Success`.
- 성장 루프 스모크: `Logs/runtime_achievement_growth_record_links.log`, `completed=true`, `achievementGrowthRecordButtonsActive=true`, `achievementGrowthRecordOpensCareer=true`, `achievementGrowthFollowUpRecordOpensCareer=true`.
- 성과 화면 스모크 재확인: `Logs/runtime_achievement_growth_record_links_catalog.log`, `completed=true`, `achievementCatalogCount=12`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_growth_record_links.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_growth_record_links.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성장 성과 버튼 포커스 QA

- 컨트롤러 포커스 이동 스모크가 성과 기록 화면의 `성장 기록`과 `후속 기록` 버튼까지 순회하도록 확장했다.
- 마케팅/QA용 반복 기록 시드의 6회차 기록에 성장 후속 필드도 넣어, 두 버튼이 모두 활성 상태로 포커스 검증에 들어가도록 했다.
- 결과 JSON에 `achievementGrowthRecordButtonsFocusable`, `achievementGrowthRecordSelectionIsGrowthButton`를 추가했다.
- 릴리즈 manifest에 `achievement growth record focus navigation` 토큰을 추가했다.
- 빌드: `Logs/build_focus_achievement_growth_record_buttons.log`, `Build Finished, Result: Success`.
- 포커스 스모크: `Logs/runtime_focus_achievement_growth_record_buttons.log`, `completed=true`, `achievementGrowthRecordButtonsFocusable=true`, `achievementGrowthRecordSelectionIsGrowthButton=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_focus_achievement_growth_record_buttons.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_focus_achievement_growth_record_buttons.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 설문 회수 화면 저해상도 QA

- 플레이테스트 설문 상태 문구를 키보드/패드 조작으로 분리했다.
- 새 기본 문구: `키보드: F/Esc 리포트 · S 설문 저장 · E 로그 저장 · B 환경 진단`, `패드: A 선택 · B 리포트 · X 설문 저장 · Menu 로그 저장/지원 번들`.
- 저해상도 UI 스모크에 `playtest_survey` 화면을 추가해 3개 해상도 기준 캡처 수를 33장에서 36장으로 확장했다.
- 결과 JSON에 `playtestSurveyGuideMentionsKeyboard=true`, `playtestSurveyGuideMentionsController=true`를 추가했다.
- 런타임 스모크: `Logs/runtime_low_resolution_playtest_survey_guide.log`, `completed=true`, `screenshotCount=36`, `expectedScreenshotCount=36`, `invalidScreenshotCount=0`.
- QA 보관 사본: `Builds/QA/v0.3.0/low_resolution_ui/1280x720_06b_playtest_survey.png`, `1600x900_06b_playtest_survey.png`, `1920x1080_06b_playtest_survey.png`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_low_resolution_playtest_survey_guide.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_low_resolution_playtest_survey_guide.log`, `checkCount=70`, `passedCheckCount=70`, `localBlockerCount=0`.

### 2026-05-31 지원 번들 외부 handoff 참조

- 지원 번들 manifest JSON/Markdown에 외부 검증 handoff actions CSV와 handoff zip/hash 참조를 추가했다.
- 새 manifest 필드: `triageActionsCsvReferencePath`, `triageActionsCsvReferenceAvailable`, `externalHandoffZipReferencePath`, `externalHandoffHashReferencePath`, `externalHandoffHashReferenceAvailable`, `externalHandoffZipSha256`.
- 모든 경로는 `Builds/...` 상대 경로로만 기록해 지원 번들 로컬 절대경로 미포함 검증을 유지한다.
- 지원 번들 스모크: `Logs/runtime_support_bundle_external_handoff_reference.log`, `completed=true`, `manifestHasTriageActionsReference=true`, `manifestHasExternalHandoffHashReference=true`.
- QA 보관 사본: `Builds/QA/v0.3.0/support_bundle/care_review_support_bundle_20260531101913_CR-20260531101911-4C7D3C`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_support_bundle_external_handoff_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_support_bundle_external_handoff_reference.log`, `checkCount=70`, `passedCheckCount=70`, `localBlockerCount=0`.

### 2026-05-31 리마스터 업로드 후보 재인코딩

- `Builds/Marketing/v0.3.0/trailer/encode_trailer_remaster_upload_candidate.ps1`를 추가했다.
- 스크립트는 검증된 45초 리마스터 컷을 12Mbps CBR H.264/AAC 업로드 후보 `care_review_office_trailer_steam_upload_v0.3.0_remaster_upload.mp4`로 재인코딩한다.
- 산출물: `care_review_office_trailer_steam_upload_v0.3.0_remaster_upload.mp4` 67,267,146 bytes, `trailer_steam_upload_remaster_upload_probe.json`, `trailer_steam_upload_remaster_upload_contact_sheet.png`.
- 블랙 프레임 점검: `Logs/ffmpeg_trailer_steam_upload_remaster_upload_blackdetect.log`, `black_start` 없음.
- 마케팅 스모크 결과에 `trailerRemasterUploadCandidateBytes=67267146`, `trailerRemasterUploadCandidateReady=true`를 추가했다.
- 마케팅 감사: `Logs/audit_marketing_assets_trailer_remaster_upload_encode.log`, `passesMarketingAssetGate=true`, `checkCount=42`, `passedCheckCount=42`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_trailer_remaster_upload_encode.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_remaster_upload_encode.log`, `checkCount=70`, `passedCheckCount=70`, `localBlockerCount=0`.

### 2026-05-31 설문 화면 Steam 상점 QA 후보 캡처

- 상점 스크린샷 자동 캡처에 `09_playtest_survey.png`를 추가해 최종 리포트 직후 플레이테스트 설문 회수 준비 화면을 별도 후보 이미지로 남기도록 했다.
- `store_screenshots_manifest.txt`에 `09_playtest_survey.png - optional store QA candidate / playtest collection readiness` 설명을 추가했다.
- 마케팅 자산 감사가 공식 상점 스크린샷 8장과 후보 스크린샷 1장을 분리 집계하도록 `storeCandidateScreenshotCount`, `validStoreCandidateScreenshotCount`를 추가했다.
- Steam 상점 자료/제출안 문서에는 후보 이미지를 실제 업로드 8장과 분리해 내부 QA 비교용으로 기록했다.
- 캡처 검증: `Logs/runtime_store_candidate_playtest_survey_player.log`, `09_playtest_survey.png` `1920x1080`, 1,813,992 bytes, 실제 설문 모달/키보드·패드 안내 노출 확인.
- 마케팅 감사: `Logs/audit_marketing_assets_store_candidate_playtest_survey.log`, `passesMarketingAssetGate=true`, `checkCount=43`, `passedCheckCount=43`, `storeCandidateScreenshotCount=1`, `validStoreCandidateScreenshotCount=1`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_candidate_playtest_survey.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_playtest_survey.log`, `checkCount=70`, `passedCheckCount=70`, `localBlockerCount=0`.

### 2026-05-31 지원 번들 handoff SHA 회수 감사 열

- 플레이테스트 회수 감사가 지원 번들 manifest의 `triageActionsCsvReferencePath`, `externalHandoffHashReferencePath`, `externalHandoffZipSha256`를 세션 row로 끌어오도록 했다.
- `care_review_playtest_collection_audit.csv`에 `support_bundle_external_handoff_zip_sha256`, `support_bundle_has_external_handoff_hash` 열을 추가했다.
- 10달러 상용화 트리아지 CSV와 actions CSV에도 지원 번들 manifest handoff SHA를 노출해 회수 로그, 트리아지 조치, 외부 handoff 패킷을 한 줄에서 대조할 수 있게 했다.
- 회수 감사 결과: `Logs/audit_playtest_collection_handoff_sha_columns_final.log`, `sessionCount=78`, `completeSessionCount=2`, `supportBundleExternalHandoffHashCount=1`.
- 트리아지 smoke: `Builds/QA/v0.3.0/playtest_collection_audit/care_review_playtest_commercial_triage_smoke_result.json`, `hasHandoffShaColumn=true`, `hasHandoffShaInActionCsv=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_collection_handoff_sha_columns_final.log`, `checkCount=70`, `passedCheckCount=70`, `localBlockerCount=0`.

### 2026-05-31 트레일러 리마스터 업로드 switch

- `Builds/Marketing/v0.3.0/trailer/trailer_remaster_upload_switch.md`를 자동 생성해 리마스터 업로드 후보를 공식 Steam 업로드 후보로 바꾸는 절차를 분리했다.
- switch 기본값은 `current_selection: current_upload`, `switch_state: ready_not_applied`로 유지해 현재 공식 업로드 후보를 즉시 바꾸지 않는다.
- 문서에는 `candidate_file`, `rollback_file`, 후보 검증 상태, 현재/후보 SHA256, 전환 후 재감사 절차를 기록했다.
- 마케팅 smoke에 `hasTrailerRemasterUploadSwitch=true`를 추가했다.
- 마케팅 감사: `Logs/audit_marketing_assets_trailer_remaster_upload_switch_retry.log`, `passesMarketingAssetGate=true`, `checkCount=44`, `passedCheckCount=44`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_remaster_upload_switch.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-06-01 트레일러 업로드 선택 manifest

- Steamworks store_page 패키징에 `TRAILER_UPLOAD_SELECTION_KO.md` 자동 생성을 추가했다.
- manifest는 `trailer_remaster_upload_switch.md`의 `current_selection`을 읽어 `selected_file`, `selected_sha256`, `candidate_file`, `rollback_file`, `submission_selected_file_match`, `ready_for_steam_store_upload`을 기록한다.
- 현재 선택은 `current_upload`이며 `selected_file: care_review_office_trailer_steam_upload_v0.3.0.mp4`, `submission_selected_file_match: yes`, `ready_for_steam_store_upload: yes`다.
- `remaster_upload_candidate`로 전환할 경우 리마스터 후보 검증 통과와 상점 제출안 파일명 동기화가 함께 필요하도록 프리플라이트/릴리즈 감사 조건에 묶었다.
- 빌드: `Logs/build_trailer_upload_selection_manifest.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_trailer_upload_selection_manifest.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_upload_selection_manifest.log`, `checkCount=76`, `passedCheckCount=76`, `localBlockerCount=0`.

### 2026-06-01 트레일러 업로드 선택 회귀 QA

- `BuildTrailerUploadSelectionManifest`를 파일 읽기 wrapper와 switch/제출안 입력 overload로 분리해 선택 manifest의 실패/복구 경로를 같은 생성기로 검증하도록 했다.
- 회귀 산출물 `Builds/QA/v0.3.0/store_page/care_review_trailer_upload_selection_regression.json`는 5개 시나리오를 검증한다.
- 검증 분기: 현재 업로드 유지 통과, 리마스터 후보 선택 후 제출안 파일명 불일치 차단, 리마스터 후보/제출안 동기화 통과, 후보 검증 실패 차단, `current_upload` 롤백 복구 통과.
- 빌드: `Logs/build_trailer_upload_selection_regression_fix.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_trailer_upload_selection_regression.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_trailer_upload_selection_regression.log`, `checkCount=78`, `passedCheckCount=78`, `localBlockerCount=0`.

### 2026-05-31 외부 게이트 handoff SHA 템플릿 연결

- 외부 게이트 증거 템플릿의 `HUMAN_5_PLAYTEST`와 `HUMAN_10_COMMERCIAL`에 handoff SHA 대조 섹션을 추가했다.
- `HUMAN_5_PLAYTEST`는 `care_review_playtest_collection_audit.csv`의 `support_bundle_external_handoff_zip_sha256`, `support_bundle_has_external_handoff_hash` 열을 확인하도록 안내한다.
- `HUMAN_10_COMMERCIAL`은 `care_review_playtest_commercial_triage_actions.csv`의 `support_bundle_manifest_handoff_zip_sha256`, `owner_screen` 열과 `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`를 대조하도록 안내한다.
- 외부 게이트 smoke에 `hasPlaytestHandoffShaTemplateLinks=true`를 추가했다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_handoff_sha_templates.log`, `gateCount=10`, `pendingGateCount=10`, `hasPlaytestHandoffShaTemplateLinks=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_handoff_sha_templates.log`, `checkCount=71`, `passedCheckCount=71`, `localBlockerCount=0`.

### 2026-05-31 성장 성과 진행 패널

- 성과 기록 하단 `반복 보상 이력` 패널에 성장 성과 진행 상태를 추가했다.
- 잠금 전에는 `성장 성과: 목표 대기/후속 대기`, 성장 목표와 후속 목표 해금 후에는 `성장 성과: 목표 달성/후속 완료`로 표시한다.
- 성과 스모크에 `achievementReplayRewardPanelMentionsGrowthProgress`를 추가하고, 메인 메뉴 성장 루프 스모크에 `achievementGrowthRewardPanelMentionsUnlocked`를 추가했다.
- 릴리즈 manifest에 `achievement growth progress panel` 토큰을 추가하고 릴리즈 감사가 새 QA 필드를 요구하도록 갱신했다.
- 빌드: `Logs/build_achievement_growth_progress_panel.log`, `Build Finished, Result: Success`.
- 성과 스모크: `Logs/runtime_achievement_growth_progress_panel.log`, `completed=true`, `achievementReplayRewardPanelMentionsGrowthProgress=true`.
- 성장 루프 스모크: `Logs/runtime_menu_growth_progress_panel.log`, `completed=true`, `growthObjectiveAchievementUnlocked=true`, `growthFollowUpAchievementUnlocked=true`, `achievementGrowthRewardPanelMentionsUnlocked=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_growth_progress_panel.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_growth_progress_panel.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성장 성과 카드 진행 문구

- `성장 목표 달성` 성과 카드에 연결 기록 기준의 `성장 기록: 성공/미달 · 점수 · 진행 요약` 문구를 추가했다.
- `성장 후속 실험` 성과 카드에 연결 기록 기준의 `후속 기록: 완료 · 점수 · 목표 요약` 문구를 추가했다.
- 기록이 아직 없을 때도 `성장 목표 성공 회차 대기`, `성장 후속 완료 회차 대기`로 다음 행동을 명확히 표시한다.
- 성과 스모크에 `achievementCardsMentionGrowthProgress`를 추가했고, 릴리즈 manifest에 `achievement growth progress cards` 토큰을 추가했다.
- 빌드: `Logs/build_achievement_growth_progress_cards.log`, `Build Finished, Result: Success`.
- 성과 스모크: `Logs/runtime_achievement_growth_progress_cards.log`, `completed=true`, `achievementCardsMentionGrowthProgress=true`, `achievementReplayRewardPanelMentionsGrowthProgress=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_growth_progress_cards.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_growth_progress_cards.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성과 다음 목표 로드맵

- 성과 기록 상단 상태 줄을 2줄로 확장해 현재 해금 수와 다음 성과 목표를 함께 보여주도록 했다.
- 새 문구 형식: `다음 성과 목표: 성장 목표 달성 · 추천 행동: 메인 메뉴 성장 심사 목표를 성공 판정으로 완료`.
- 모든 성과가 해금된 경우에도 `다음 성과 목표: 전체 완료 · 추천 행동: 운영 기준별 기록과 성장 후속 기록 계속 확장`으로 장기 플레이 방향을 유지한다.
- 성과 스모크에 `achievementStatusMentionsNextGoalRoadmap`를 추가했고, 릴리즈 manifest에 `achievement next goal roadmap` 토큰을 추가했다.
- 빌드: `Logs/build_achievement_next_goal_roadmap.log`, `Build Finished, Result: Success`.
- 성과 스모크: `Logs/runtime_achievement_next_goal_roadmap.log`, `completed=true`, `achievementStatusMentionsNextGoalRoadmap=true`, `statusText`에 `다음 성과 목표`와 `추천 행동` 포함.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_next_goal_roadmap.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_next_goal_roadmap.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성과 다음 목표 실행 버튼

- 성과 기록 헤더 우측에 다음 미해금 성과로 바로 이동하는 `목표 실행` 버튼을 추가했다.
- 버튼 라벨은 다음 목표에 맞춰 `로그 내보내기`, `에이전트 실행`, `목표 사례`, `성장 심사`, `후속 심사`, `기록 보기` 등으로 바뀐다.
- 실행 동작은 기존 게임 흐름과 연결된다: 로그 export, 에이전트 분석, 목표 사례 자료실 포커스, 성장 심사 시작, 성장 후속 심사 시작, 일반 목표 캠페인 시작.
- 성과 스모크에 `achievementNextGoalButtonReady`와 `achievementNextGoalButtonLabel`을 추가했고, 릴리즈 manifest에 `achievement next goal action button` 토큰을 추가했다.
- 빌드: `Logs/build_achievement_next_goal_action_button.log`, `Build Finished, Result: Success`.
- 성과 스모크: `Logs/runtime_achievement_next_goal_action_button.log`, `completed=true`, `achievementNextGoalButtonReady=true`, `achievementNextGoalButtonLabel=성장 심사`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_next_goal_action_button.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_next_goal_action_button.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성과 다음 목표 버튼 포커스 QA

- 컨트롤러 포커스 스모크에 성과 기록 `목표 실행` 버튼을 추가했다.
- 새 검증 필드: `achievementNextGoalButtonFocusable`, `achievementNextGoalSelectionIsActionButton`.
- 릴리즈 manifest에 `achievement next goal focus navigation` 토큰을 추가했다.
- 빌드: `Logs/build_achievement_next_goal_focus.log`, `Build Finished, Result: Success`.
- 포커스 스모크: `Logs/runtime_focus_achievement_next_goal.log`, `completed=true`, `achievementNextGoalButtonFocusable=true`, `achievementNextGoalSelectionIsActionButton=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_next_goal_focus.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_next_goal_focus.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성과 다음 목표 실행 스모크

- 성과 스모크가 `목표 실행` 버튼을 실제로 호출하고, 버튼 라벨에 맞는 화면/캠페인 흐름이 열렸는지 검증하도록 했다.
- 새 검증 필드: `achievementNextGoalButtonExecutesAction`.
- 현재 검증 경로는 `achievementNextGoalButtonLabel=성장 심사`에서 성장 목표 캠페인 튜토리얼이 열리고 `currentCampaignStartedFromGrowthObjective=true`가 되는 흐름이다.
- 릴리즈 manifest에는 `achievement next goal action smoke` 증거 줄을 추가했다.
- 빌드: `Logs/build_achievement_next_goal_action_smoke.log`, `Build Finished, Result: Success`.
- 성과 스모크: `Logs/runtime_achievement_next_goal_action_smoke.log`, `completed=true`, `achievementNextGoalButtonReady=true`, `achievementNextGoalButtonExecutesAction=true`, `achievementNextGoalButtonLabel=성장 심사`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_next_goal_action_smoke.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_next_goal_action_smoke.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 성과 다음 목표 상점 후보 캡처

- 상점 스크린샷 자동 캡처에 `10_achievement_next_goal.png`를 추가했다.
- 해당 이미지는 성과 기록, 다음 성과 목표, `성장 심사` 목표 실행 버튼, 반복/성장 보상 진행을 한 장에서 검수하는 내부 QA 후보 스크린샷이다.
- 공식 업로드 8장 구성은 유지하고, 상점 후보 스크린샷 집계를 1장에서 2장으로 확장했다.
- `store_screenshots_manifest.txt`, `Docs/Steam_상점페이지_자료.md`, `Docs/Steam_상점페이지_제출안.md`에 후보 이미지를 반영했다.
- 캡처 검증: `Logs/runtime_store_candidate_achievement_next_goal_windowed.log`, `10_achievement_next_goal.png` `1920x1080`, 1,761,657 bytes.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_achievement_next_goal_candidate.log`, `passesMarketingAssetGate=true`, `checkCount=45`, `passedCheckCount=45`, `storeCandidateScreenshotCount=2`, `validStoreCandidateScreenshotCount=2`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_next_goal_candidate.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_next_goal_candidate.log`, `checkCount=72`, `passedCheckCount=72`, `localBlockerCount=0`.

### 2026-05-31 상점 후보 스크린샷 Steamworks 사본

- `PrepareSteamworksDepot`가 `store_page/screenshot_candidates`를 새로 만들고 후보 스크린샷 2장을 복사하도록 추가했다.
- 사본 대상은 `09_playtest_survey.png`, `10_achievement_next_goal.png`, 원본 캡처 manifest다.
- `store_page/SCREENSHOT_CANDIDATES_KO.md`를 생성해 공식 8장과 후보 2장의 용도 차이, 승격 기준, 비교 검토 위치를 명시한다.
- Steam 제출 전 자체 점검과 릴리즈 후보 감사가 Steamworks 사본 2장의 존재, 1920x1080 규격, 후보 manifest 토큰을 확인하도록 강화했다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_screenshot_candidates_copy_fix.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_candidates_copy_fix.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-05-31 성장 후속 목표 메인 메뉴 버튼

- 메인 메뉴에 `후속 심사` 버튼을 추가했다.
- 성장 목표 성공 후 `성장 후속` 또는 `성장 보정` 추천 목표가 대기 중이면 버튼이 활성화되고, 힌트에 후속 운영 기준과 초점이 표시된다.
- H 단축키로도 같은 후속 목표를 바로 시작할 수 있게 했다.
- 메인 메뉴 상태 줄은 성장 후속 추천 대기 상태에서 `후속 심사 버튼/H 바로 시작`을 함께 보여준다.
- 메인 메뉴 목표 사례 스모크에 `menuMentionsGrowthFollowUpShortcut`, `menuGrowthFollowUpObjectiveButtonReady`, `growthFollowUpButtonText`, `growthFollowUpHintText`를 추가했다.
- 빌드: `Logs/build_growth_follow_up_menu_button.log`, `Build Finished, Result: Success`.
- 스모크: `Logs/runtime_growth_follow_up_menu_button.log`, `completed=true`, `menuMentionsGrowthFollowUpShortcut=true`, `menuGrowthFollowUpObjectiveButtonReady=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_menu_button.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_menu_button.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-05-31 성장 후속 메인 메뉴 상점 후보 캡처

- 상점 스크린샷 자동 캡처에 `11_growth_follow_up_menu.png`를 추가했다.
- 해당 이미지는 성장 후속 추천 대기, `후속 심사` 버튼, H 단축키, 후속 운영 기준 힌트를 한 화면에서 검수하는 내부 QA 후보 스크린샷이다.
- 공식 업로드 8장 구성은 유지하고, 상점 후보 스크린샷 집계를 2장에서 3장으로 확장했다.
- `store_screenshots_manifest.txt`, `Docs/Steam_상점페이지_자료.md`, `Docs/Steam_상점페이지_제출안.md`에 후보 이미지를 반영했다.
- 캡처 검증: `Logs/runtime_store_candidate_growth_follow_up_menu_windowed.log`, `11_growth_follow_up_menu.png` `1920x1080`, 2,006,681 bytes.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_growth_follow_up_menu_candidate.log`, `passesMarketingAssetGate=true`, `checkCount=46`, `passedCheckCount=46`, `storeCandidateScreenshotCount=3`, `validStoreCandidateScreenshotCount=3`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_menu_candidate.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_menu_candidate.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-06-01 성장 후속 메인 메뉴 포커스 QA

- 컨트롤러 포커스 스모크에 성장 후속 추천 대기 상태를 직접 만들고 `후속 심사` 버튼을 선택 대상으로 검증하는 경로를 추가했다.
- 새 검증 필드: `menuGrowthFollowUpButtonFocusable`, `menuGrowthFollowUpSelectionIsActionButton`, `menuGrowthFollowUpSelected`.
- 릴리즈 manifest에 `growth follow-up menu focus navigation` 증거 줄을 추가했다.
- 빌드: `Logs/build_growth_follow_up_menu_focus.log`, `Build Finished, Result: Success`.
- 포커스 스모크: `Logs/runtime_focus_growth_follow_up_menu.log`, `completed=true`, `menuGrowthFollowUpButtonFocusable=true`, `menuGrowthFollowUpSelectionIsActionButton=true`, `menuGrowthFollowUpSelected=후속 심사`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_growth_follow_up_menu_focus.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_growth_follow_up_menu_focus.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 목표 재시작

- 캠페인 기록 하단에 선택 회차의 다음 목표를 바로 적용하는 `목표 재시작` 버튼을 추가했다.
- 다음 목표가 `성장 후속`이면 `후속 심사`, `성장 보정`이면 `보정 심사`, `성장 목표`이면 `성장 심사`로 버튼 라벨이 바뀐다.
- 버튼 실행 시 선택 회차의 `nextCampaignMandateId`, `nextCampaignChallenge`, `nextCampaignReason`을 추천 목표로 적용하고 기존 추천 심사 시작 흐름으로 진입한다.
- 캠페인 기록 스모크가 성장 보정 기록에서 `보정 심사` 버튼을 누르고 성장 보정 튜토리얼이 열리는지 검증하도록 확장했다.
- 빌드: `Logs/build_career_record_next_objective_restart.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_next_objective_restart.log`, `completed=true`, `careerRecordNextObjectiveButtonActive=true`, `careerRecordNextObjectiveStartsCampaign=true`, `careerRecordNextObjectiveButtonLabel=보정 심사`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_next_objective_restart.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_next_objective_restart.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 목표 재시작 포커스 QA

- 컨트롤러 포커스 스모크가 캠페인 기록의 성장 후속 필터 상태에서 `목표 재시작` 버튼을 직접 선택 대상으로 검증하도록 확장했다.
- 새 검증 필드: `careerRecordNextObjectiveButtonFocusable`, `careerRecordNextObjectiveSelectionIsActionButton`, `careerRecordNextObjectiveSelected`.
- 릴리즈 manifest에 `career record next objective focus navigation` 증거 줄을 추가했다.
- 빌드: `Logs/build_career_record_next_objective_focus.log`, `Build Finished, Result: Success`.
- 포커스 스모크: `Logs/runtime_focus_career_record_next_objective.log`, `completed=true`, `careerRecordNextObjectiveButtonFocusable=true`, `careerRecordNextObjectiveSelectionIsActionButton=true`, `careerRecordNextObjectiveSelected=목표 재시작`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_next_objective_focus.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_next_objective_focus.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 목표 재시작 상점 후보 캡처

- 상점 스크린샷 자동 캡처에 `12_career_record_next_objective.png`를 추가했다.
- 해당 이미지는 캠페인 기록의 성장 후속 필터, 목표 재시작 버튼, 포커스 하이라이트를 한 화면에서 검수하는 내부 QA 후보 스크린샷이다.
- 공식 업로드 8장 구성은 유지하고, 상점 후보 스크린샷 집계를 3장에서 4장으로 확장했다.
- `store_screenshots_manifest.txt`, `Docs/Steam_상점페이지_자료.md`, `Docs/Steam_상점페이지_제출안.md`, Steamworks `SCREENSHOT_CANDIDATES_KO.md`에 후보 이미지를 반영했다.
- 캡처 검증: `Logs/runtime_store_candidate_career_record_next_objective_windowed.log`, `12_career_record_next_objective.png` `1920x1080`, 1,768,444 bytes.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_career_record_next_objective_candidate.log`, `passesMarketingAssetGate=true`, `checkCount=47`, `passedCheckCount=47`, `storeCandidateScreenshotCount=4`, `validStoreCandidateScreenshotCount=4`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_next_objective_candidate.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_next_objective_candidate.log`, `checkCount=74`, `passedCheckCount=74`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 스크린샷 승격 기준표

- Steamworks store_page 패키징에 `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md` 자동 생성을 추가했다.
- 후보 4장의 승격 우선순위를 `12_career_record_next_objective.png`, `10_achievement_next_goal.png`, `11_growth_follow_up_menu.png`, `09_playtest_survey.png` 순으로 기록한다.
- 프리플라이트와 릴리즈 후보 감사가 승격 기준표의 존재, 12번 후보, 공식 8장 유지 규칙, 권장 후보 토큰을 확인하도록 강화했다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_candidate_decision_matrix.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_candidate_decision_matrix.log`, `checkCount=75`, `passedCheckCount=75`, `localBlockerCount=0`.

### 2026-06-01 후보 스크린샷 승격 기준표 피드백 연동

- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`가 `care_review_playtest_aggregate.json`의 설문 회수 수, 10달러 가치감, 반복 보상/장기 기록 가치감, UI 가독성, 재플레이 의향을 읽어 자동 판정을 쓰도록 확장했다.
- 현재 집계 신호는 설문 회수 `7/169`, 10달러 가치감 `3.9/5`, 반복 보상 가치감 `3.7/5`, UI 가독성 `3.6/5`, 재플레이 의향 `4/7 (57.1%)`다.
- 이 신호를 기준으로 `12_career_record_next_objective.png`는 1차 승격 후보 유지, `10_achievement_next_goal.png`는 보조 후보 유지로 자동 판정된다.
- 빌드: `Logs/build_candidate_decision_matrix_feedback_float_fix.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_candidate_decision_matrix_feedback_float_fix.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_candidate_decision_matrix_feedback.log`, `checkCount=75`, `passedCheckCount=75`, `localBlockerCount=0`.

### 2026-06-01 후보 스크린샷 외부 회수 신뢰도 분리

- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`가 QA 포함 집계와 실제 외부 플레이테스터 완전 회수 신호를 분리해 표시하도록 확장했다.
- 새 `외부 회수 신뢰도` 섹션은 `care_review_playtest_commercial_triage.json`와 `care_review_playtest_collection_audit_summary.json`에서 실제 사람 완전 회수 세션 `0/5`, 상용 최소 `10`, 외부 설문 회수 `0`, 트리아지 evidenceScope `qa_or_incomplete_survey_sessions`를 읽는다.
- 현재 후보 순위는 유지하지만 판정 범위는 `QA 샘플 기반 임시 판정`으로 표시한다. 공식 승격 확정은 외부 완전 회수 기준 충족 후 결정하도록 적용 원칙과 릴리즈 감사 토큰에 고정했다.
- 빌드: `Logs/build_candidate_decision_matrix_external_confidence.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_candidate_decision_matrix_external_confidence.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_candidate_decision_matrix_external_confidence.log`, `checkCount=75`, `passedCheckCount=75`, `localBlockerCount=0`.

### 2026-06-01 후보 스크린샷 기준표 회귀 QA

- `BuildStorePageScreenshotCandidateDecisionMatrix`를 파일 읽기 wrapper와 JSON 입력 overload로 분리해 동일 생성기로 샘플 시나리오 회귀 검증을 수행하도록 했다.
- 회귀 산출물 `Builds/QA/v0.3.0/store_page/care_review_screenshot_candidate_decision_matrix_regression.json`는 3개 시나리오를 검증한다.
- 검증 분기: 실제 외부 완전 회수 0명은 `QA 샘플 기반 임시 판정`, 5명은 `외부 회수 기반 균형 판정`, 10명은 `외부 회수 기반 상용화 판정`.
- 현재 QA 포함 집계 시나리오에서도 `12_career_record_next_objective.png`의 1차 승격 후보 유지 문구가 보존되는지 확인한다.
- 빌드: `Logs/build_screenshot_candidate_matrix_regression.log`, `Build Finished, Result: Success`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_candidate_matrix_regression.log`, `checkCount=77`, `passedCheckCount=77`, `localBlockerCount=0`.

### 2026-06-01 상점 스크린샷 업로드 선택 manifest

- Steamworks store_page 패키징에 `SCREENSHOT_UPLOAD_SELECTION_KO.md` 자동 생성을 추가했다.
- manifest는 현재 공식 8장, 후보 4장, 외부 완전 회수 수, 추천 최소 회수 수, 승격 상태, 교체 대상, 제출안 갱신 필요 여부를 기록한다.
- 현재 실제 데이터에서는 외부 완전 회수 `0/5`라 `promotion_status: not_promoted`, `selected_upload_set: current_official_8`, `submission_update_required: no`로 공식 8장 유지 상태다.
- 외부 완전 회수 5명 이상과 반복/UI 신호 기준을 충족하면 `12_career_record_next_objective.png`를 `01_main_menu.png` 대신 넣는 `promoted_candidate_set`을 제안한다.
- 회귀 산출물 `Builds/QA/v0.3.0/store_page/care_review_screenshot_upload_selection_regression.json`는 외부 회수 0명/5명/10명 시나리오를 검증한다.
- 검증 분기: 0명은 현재 공식 8장 유지, 5명은 제출안 갱신 필요 승격 후보, 10명은 상용화 판단용 승격 후보.
- 빌드: `Logs/build_screenshot_upload_selection_manifest.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_screenshot_upload_selection_manifest.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_upload_selection_manifest.log`, `checkCount=80`, `passedCheckCount=80`, `localBlockerCount=0`.

### 2026-06-01 상점 스크린샷 업로드 적용/롤백 QA

- Steamworks store_page 패키징에 `SCREENSHOT_UPLOAD_APPLICATION_KO.md` 자동 생성을 추가했다.
- 적용 manifest는 `SCREENSHOT_UPLOAD_SELECTION_KO.md`의 선택값과 `STORE_PAGE_SUBMISSION_DRAFT_KO.md`의 공식 8장 구간이 일치하는지 검사한다.
- 검사 범위는 `## 11. 스크린샷 업로드 순서`부터 `### QA 후보 스크린샷` 전까지로 제한해, 후보 섹션의 12번 이미지를 공식 업로드 적용으로 오인하지 않게 했다.
- 현재 제출안은 `current_official_order_matches: yes`, `submission_matches_selected_set: yes`, `rollback_matches_current_set: yes`, `ready_for_store_presence_upload: yes`다.
- 회귀 산출물 `Builds/QA/v0.3.0/store_page/care_review_screenshot_upload_application_regression.json`는 현재 8장 일치, 승격 후보 선택 후 제출안 미반영 차단, 승격 제출안 반영 통과, 롤백 미반영 차단, 롤백 반영 통과를 검증한다.
- 빌드: `Logs/build_screenshot_upload_application_regression_fix.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_screenshot_upload_application_regression.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_upload_application_regression.log`, `checkCount=82`, `passedCheckCount=82`, `localBlockerCount=0`.

### 2026-06-01 Store Presence 통합 선택 manifest

- Steamworks store_page 패키징에 `STORE_PRESENCE_SELECTION_KO.md` 자동 생성을 추가했다.
- 통합 manifest는 `SCREENSHOT_UPLOAD_APPLICATION_KO.md`, `TRAILER_UPLOAD_SELECTION_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md`를 함께 읽어 Store Presence 수동 입력 직전의 스크린샷/트레일러 조합 일관성을 검사한다.
- 현재 제출안은 `screenshot_selected_upload_set: current_official_8`, `screenshot_application_ready: yes`, `trailer_selected_file: care_review_office_trailer_steam_upload_v0.3.0.mp4`, `trailer_ready: yes`, `store_presence_needs_submission_update: no`, `store_presence_ready_for_manual_input: yes`다.
- 회귀 산출물 `Builds/QA/v0.3.0/store_page/care_review_store_presence_selection_regression.json`는 현재 제출안 통과, 스크린샷 승격 미반영 차단, 리마스터 트레일러 미반영 차단, 둘 다 반영된 조합 통과, 롤백 통과를 검증한다.
- 빌드: `Logs/build_store_presence_selection_manifest.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_selection_manifest_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_selection_manifest_docs.log`, `checkCount=84`, `passedCheckCount=84`, `localBlockerCount=0`.

### 2026-06-01 Store Value 포지셔닝 manifest

- Steamworks store_page 패키징에 `STORE_VALUE_POSITIONING_KO.md` 자동 생성을 추가했다.
- 실제 상점 가격 기준은 `USD 9.99`로 유지하면서, 사용자가 요구한 20달러급 품질 목표를 `quality_benchmark_usd: 20.00` 내부 검증 기준으로 분리했다.
- 현재 manifest는 40개 사례/5일 캠페인, 3종 운영 기준 반복 구조, HTML/CSV/JSON 분석 export, 큰 글자/고대비/키보드 접근성, 스크린샷/트레일러/캡슐 자산, 합성 사례/실제 개인정보 미사용/로컬 처리 투명성 6개 가치 축을 통과로 잡는다.
- 가격 가치감 신호는 `average_price_value_rating: 3.9`이며, `no_twenty_dollar_price_claim: yes`, `twenty_dollar_quality_benchmark_ready: yes`, `actual_price_change_ready: no_requires_external_validation`로 기록한다.
- 회귀 산출물 `Builds/QA/v0.3.0/store_page/care_review_store_value_positioning_regression.json`는 충분한 가치 문구 통과, 얇은 상점 문구 차단, `USD 19.99` 가격 주장 차단, 낮은 가격 가치감 신호 차단을 검증한다.
- 빌드: `Logs/build_store_value_positioning_manifest.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_value_positioning_manifest_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_value_positioning_manifest_docs.log`, `checkCount=86`, `passedCheckCount=86`, `localBlockerCount=0`.

### 2026-06-01 항소/이의제기 검토 루프

- 고위험 판단 불일치, 긴급 사례 지연, 서류 약점, 민원 증가를 합산하는 항소 검토 점수를 추가했다.
- 후속 연락함은 이의제기 검토 건수와 사례별 상태/점수/보정 조치를 표시한다.
- 사례 자료실 상세에는 해당 사례의 최고 항소 점수 판단 로그를 기준으로 `이의제기 검토`와 `보정 조치`를 표시한다.
- 최종 리포트 요약/분석 코멘트/다음 목표 패널에 항소 검토 건수, 최고 점수 사례, 보정 조치를 표시한다.
- 캠페인 기록에는 회차별 항소 검토 건수, 최고 점수, 대표 사례, 보정 조치를 저장하고 상단의 `이의제기 누적` 행에 누적한다.
- 결정 감사 플래그, 재검토 사유, JSON export, CSV export에 `appeal_review_score`, `appeal_review_status`, `appeal_review_remedy` 계열 정보를 추가했다.
- 새 스모크 `-careReviewAppealReviewSmokeTest`가 고위험 불일치 판단을 만든 뒤 후속 연락함, 사례 자료실, CSV export 컬럼을 검증한다.
- 빌드: `Logs/build_appeal_review_release_builder.log`, `Build Finished, Result: Success`.
- 스모크: `Logs/runtime_appeal_review_smoke_isolation.log`, `completed=true`, `appealScore=105`, `appealStatus=즉시 재검토`, `logCreatesAppeal=true`, `inboxMentionsAppeal=true`, `archiveMentionsAppeal=true`, `reportMentionsAppeal=true`, `careerRecordStoresAppeal=true`, `careerRecordMentionsAppeal=true`, `csvHasAppealColumns=true`.
- 캠페인 기록 회귀: `Logs/runtime_career_record_appeal_summary_isolated.log`, `completed=true`, `bodyMentionsAppealReviewSummary=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_review_report_career.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_review_report_career.log`, `checkCount=89`, `passedCheckCount=89`, `localBlockerCount=0`.

### 2026-06-01 결정 감사 이의제기 우선순위 큐

- 결정 감사 대시보드의 고압력 대표 사례 큐가 기존 압박 점수에 항소/이의제기 점수를 반영해 정렬하도록 변경했다.
- 큐 상단에 `이의제기 우선순위` 요약, 최고 점수 사례, 보정 조치를 표시하고, 개별 사례 행에도 항소 보정 상태와 점수를 붙였다.
- 결정 감사 스모크가 고위험 비거절 권장 사례 `C-031`을 거절해 항소 사례를 만든 뒤 큐가 이를 표시하는지 검증한다.
- 릴리즈 README/manifest, Steam 제출 프리플라이트, 릴리즈 후보 감사가 결정 감사 이의제기 우선순위 반영을 필수 조건으로 요구하도록 강화했다.
- 빌드: `Logs/build_decision_audit_appeal_priority_audit.log`, `Build Finished, Result: Success`.
- 결정 감사 스모크: `Logs/runtime_decision_audit_appeal_priority_audit.log`, `completed=true`, `queueMentionsAppealPriority=true`, `appealCaseId=C-031`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_audit_appeal_priority.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_audit_appeal_priority.log`, `checkCount=92`, `passedCheckCount=92`, `localBlockerCount=0`.

### 2026-06-01 사례 자료실 이의제기 필터 큐

- 사례 자료실 필터에 `이의제기` 큐를 추가해 항소/이의제기 점수 35점 이상인 사례만 모아 볼 수 있게 했다.
- 자료실 요약 행에는 현재 캠페인에서 발생한 이의제기 검토 건수를 표시하고, 상세 패널에는 기존 이의제기 상태/점수/보정 조치를 그대로 노출한다.
- 이의제기 필터에서 목표 심사를 적용하면 `D1 C-031형 이의제기 보정 재심사`처럼 보정 맥락이 담긴 반복 목표가 생성되도록 확장했다.
- 이의제기 보정 목표 회차를 완료하면 캠페인 기록 세부에 `이의제기 보정 목표 완료` 배지가 저장/표시되도록 확장했다.
- 성과 기록 상단과 반복 보상 패널, 캠페인 기록 장기 추세 패널에 `보정 목표 n회` 누적 요약을 표시하도록 확장했다.
- Steam 업적 후보에 `CARE_APPEAL_REMEDY_OBJECTIVE` / `이의제기 보정 설계자`를 추가하고, 이의제기 보정 목표 회차 완료 시 해금되도록 연결했다.
- 사례 자료실 스모크가 `C-031` 항소 사례를 만든 뒤 이의제기 필터 큐, 보정 조치 표시, 보정 목표 심사 적용, 캠페인 기록 배지 저장, 성과 기록 누적 요약을 검증하도록 확장했다.
- 릴리즈 README/manifest, Steam 제출 프리플라이트, 릴리즈 후보 감사가 사례 자료실 이의제기 필터 반영을 필수 조건으로 요구하도록 강화했다.
- 빌드: `Logs/build_appeal_remedy_steam_achievement.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_appeal_remedy_steam_achievement_case_archive.log`, `completed=true`, `appealFilterCycled=true`, `appealFilterMentionsCase=true`, `appealFilterMentionsRemedy=true`, `appealObjectiveChallengeMentionsRemedy=true`, `appealObjectiveStatusMentionsRemedy=true`, `appealObjectiveRecordStoresBadge=true`, `appealRemedyAchievementUnlocked=true`, `careerBodyMentionsAppealObjectiveBadge=true`, `careerTrendMentionsAppealObjective=true`, `achievementStatusMentionsAppealObjective=true`, `achievementReplayRewardMentionsAppealObjective=true`, `appealCaseId=C-031`.
- 성과 기록 스모크: `Logs/runtime_achievement_appeal_remedy_catalog.log`, `completed=true`, `achievementCatalogCount=13`, `achievementCardsMentionAppealRemedy=true`, `achievementCatalogIncludesAppealRemedyAchievement=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_steam_achievement.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_steam_achievement.log`, `checkCount=96`, `passedCheckCount=96`, `localBlockerCount=0`.

### 2026-06-01 이의제기 보정 성과 기록 바로가기

- 성과 기록 하단에 `보정 기록` 버튼을 추가해 `CARE_APPEAL_REMEDY_OBJECTIVE` 완료 회차의 캠페인 기록으로 바로 들어가게 했다.
- 13개 성과 카드가 하단 반복 보상 패널과 겹치지 않도록 성과 카드 높이/간격을 조정했다.
- 캠페인 기록 기준 필터에 `보정`을 추가해 이의제기 보정 목표 완료 회차만 별도로 좁혀 볼 수 있게 했다.
- 캠페인 기록 하단에 `보정 사례` 버튼을 추가해 보정 목표 완료 회차에서 원 이의제기 사례 `C-031`로 다시 들어가게 했다.
- 보정 목표가 대기 중이면 메인 메뉴 추천 버튼이 `보정 심사 시작: 지원 확대`처럼 일반 추천과 구분되는 라벨로 표시되게 했다.
- 보정 목표 회차 시작 브리핑에 `이의제기 보정 목표` 섹션을 추가하고, 심사 화면 기준표에 `이의제기 보정 진행` HUD를 추가해 원 사례와 고위험 지연 초점을 회차 중 계속 확인할 수 있게 했다.
- 보정 목표 회차 완료 시 권장 일치율, 고위험 지연, 누락 위험 기준으로 성공/미달을 판정하고 최종 리포트/캠페인 기록에 `보정 목표 판정`, `보정 판정`, `보정 해석`으로 저장하도록 확장했다.
- 보정 목표 회차 완료 후 성공/미달 판정에 따라 다음 추천 목표가 `이의제기 보정 재도전` 또는 `이의제기 보정 후속`으로 이어지도록 확장했다.
- 보정 목표 미달 최종 리포트의 다음 목표 영역에 `보정 재도전 CTA`를 추가해 추천 심사 버튼으로 재도전 목표를 바로 시작하라고 안내하도록 확장했다.
- 메인 메뉴 `후속 심사` 버튼이 보정 목표 대기 상태에서는 `보정 심사`로 바뀌고, 힌트/상태 줄에 재도전 고위험 지연 초점과 H 단축키를 노출하도록 확장했다.
- 메인 메뉴 상태줄에 `보정 누적` 요약을 추가해 보정 목표 완료 횟수, 성공률, 원 사례, 다음 재도전/후속 목표를 바로 확인할 수 있게 했다.
- 컨트롤러/키보드 포커스 스모크가 보정 목표 대기 상태의 메인 메뉴 `보정 심사` 버튼도 직접 선택 가능한 액션으로 검증하도록 확장했다.
- 보정 재도전/후속 추천 목표를 바로 시작해도 이의제기 보정 목표 브리핑과 심사 화면 HUD가 유지되도록 확장했다.
- 캠페인 기록의 `보정 심사` 버튼으로 보정 재도전 목표를 시작해도 원 사례와 미달 근거가 다음 회차 브리핑/HUD에 전달되도록 확장했다.
- 캠페인 기록 본문에 `보정 목표 요약`을 추가해 완료 횟수, 성공률, 최근 성공/미달, 다음 보정 과제를 누적 표시하도록 확장했다.
- 캠페인 기록 상세 패널에 `보정 액션 플랜`을 추가해 보정 성공/재도전 상태, 원 사례, 진행 수치, 다음 보정 목표, 미달 원인을 한 줄로 연결했다.
- 사례 자료실 상세 패널에 `보정 이력`을 추가해 원 사례의 보정 목표 완료 횟수, 성공률, 최근 성공/미달, 다음 보정 목표를 상시 표시하도록 확장했다.
- 보정 목표 회차 완료 후 최종 리포트에 `보정 사례` 버튼을 추가해 원 이의제기 사례 `C-031` 자료실과 최종 리포트 보정 타임라인으로 바로 돌아갈 수 있게 했다.
- 컨트롤러/키보드 포커스 이동 스모크가 최종 리포트 `보정 사례` 버튼을 직접 선택 가능한 액션으로 검증하도록 확장했다.
- 사례 자료실 스모크가 `보정 기록` 버튼 활성화와 캠페인 기록 이동을 검증하도록 확장했다.
- 컨트롤러 포커스 이동 스모크가 `보정 기록` 버튼을 직접 선택 대상으로 잡는지 검증하도록 확장했다.
- 캠페인 기록/포커스 스모크가 `보정` 필터, `보정 사례` 버튼, 7개 필터 포커스 순회를 검증하도록 확장했다.
- 릴리즈 README/manifest, Steam 제출 프리플라이트, 릴리즈 후보 감사가 `appeal remedy achievement record link`와 `appeal remedy achievement record focus navigation` 증거를 요구하도록 강화했다.
- 빌드: `Logs/build_career_appeal_remedy_case_link_fix.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_appeal_remedy_record_link_case_archive.log`, `completed=true`, `achievementAppealRemedyRecordButtonActive=true`, `achievementAppealRemedyRecordOpensCareer=true`, `appealCaseId=C-031`.
- 보정 목표 추천 버튼/브리핑/HUD 스모크: `Logs/runtime_case_archive_appeal_remedy_recommended_button.log`, `completed=true`, `appealObjectiveRecommendedButtonMentionsRemedy=true`, `appealObjectiveRecommendedButtonText=보정 심사 시작: 지원 확대`, `appealBriefingMentionsRemedyObjective=true`, `appealReviewHudMentionsRemedyObjective=true`.
- 보정 목표 성공/미달 판정 스모크: `Logs/runtime_case_archive_appeal_remedy_result_verdict.log`, `completed=true`, `reportMentionsAppealRemedyObjectiveResult=true`, `appealObjectiveRecordStoresResult=true`, `careerBodyMentionsAppealObjectiveResult=true`, `appealObjectiveResultProgress=권장 100%/70% · 고위험 지연 7/3 · 누락 13/30 · 위험 55`.
- 보정 결과 기반 다음 목표 스모크: `Logs/runtime_case_archive_appeal_remedy_next_objective.log`, `completed=true`, `appealRemedyNextObjectiveAdaptsToResult=true`, `careerBodyMentionsAppealRemedyNextObjective=true`, `appealRemedyNextObjectiveChallenge=이의제기 보정 재도전: 고위험 지연 3건 이하, 누락 위험 30 이하`.
- 최종 리포트 보정 재도전 CTA 스모크: `Logs/runtime_case_archive_report_appeal_remedy_retry_cta.log`, `completed=true`, `reportMentionsAppealRemedyRetryCta=true`.
- 메인 메뉴 보정 후속 버튼 스모크: `Logs/runtime_case_archive_appeal_remedy_menu_follow_up_button.log`, `completed=true`, `appealRemedyMenuFollowUpButtonReady=true`, `appealRemedyMenuStatusMentionsFollowUpButton=true`, `appealRemedyMenuFollowUpButtonText=보정 심사`, `appealRemedyMenuFollowUpHintText=지원 확대 · 재도전 · 고위험 지연`.
- 메인 메뉴 보정 목표 누적 요약 스모크: `Logs/runtime_case_archive_menu_appeal_remedy_summary.log`, `completed=true`, `appealRemedyMenuMentionsObjectiveSummary=true`.
- 메인 메뉴 보정 후속 버튼 포커스 스모크: `Logs/runtime_focus_appeal_remedy_menu_follow_up_focus.log`, `completed=true`, `menuAppealRemedyFollowUpButtonFocusable=true`, `menuAppealRemedyFollowUpSelectionIsActionButton=true`.
- 캠페인 기록 보정 다음 목표 시작 스모크: `Logs/runtime_case_archive_career_appeal_remedy_next_objective_restart.log`, `completed=true`, `appealRemedyCareerNextObjectiveButtonMentionsRemedy=true`, `appealRemedyCareerNextObjectiveStartsRetryBriefing=true`, `appealRemedyCareerNextObjectiveHudMentionsRetry=true`.
- 캠페인 기록 보정 목표 성공률 요약 스모크: `Logs/runtime_career_appeal_remedy_objective_summary.log`, `completed=true`, `bodyMentionsAppealRemedyObjectiveSummary=true`.
- 캠페인 기록 보정 액션 플랜 스모크: `Logs/runtime_career_appeal_remedy_action_plan.log`, `completed=true`, `detailMentionsAppealRemedyActionPlan=true`.
- 사례 자료실 보정 이력 스모크: `Logs/runtime_case_archive_appeal_remedy_history.log`, `completed=true`, `caseArchiveMentionsAppealRemedyHistory=true`.
- 최종 리포트 보정 사례 스모크: `Logs/runtime_case_archive_report_appeal_remedy_case_link.log`, `completed=true`, `reportAppealRemedyCaseButtonActive=true`, `reportAppealRemedyArchiveFocused=true`, `reportAppealRemedyArchiveMentionsTimeline=true`.
- 최종 리포트 보정 사례 포커스 스모크: `Logs/runtime_focus_report_appeal_remedy_case_link.log`, `completed=true`, `reportAppealRemedyCaseButtonFocusable=true`, `reportAppealRemedyCaseSelectionIsButton=true`.
- 캠페인 기록 스모크: `Logs/runtime_career_appeal_remedy_case_link_fix.log`, `completed=true`, `bodyMentionsAppealRemedyFilter=true`, `appealRemedyFilterAppliesToRecord=true`, `appealRemedyCaseButtonActive=true`, `appealRemedyArchiveFocused=true`.
- 포커스 이동 스모크: `Logs/runtime_focus_career_appeal_remedy_case_link_fix.log`, `completed=true`, `achievementAppealRemedyRecordButtonFocusable=true`, `careerRecordAppealRemedyCaseButtonFocusable=true`, `careerRecordMandateFilterButtonFocusCount=7`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_menu_appeal_remedy_summary.log`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_case_archive_appeal_remedy_history.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_case_archive_appeal_remedy_history.log`, `checkCount=96`, `passedCheckCount=96`, `localBlockerCount=0`.

### 2026-06-01 사례 자료실 보정 이력 상점 후보

- 사례 자료실 상세 패널의 `보정 이력` 섹션을 상단으로 올려 원 이의제기 사례, 완료 횟수, 성공률, 최근 미달, 다음 보정 목표가 첫 화면에서 보이도록 조정했다.
- 상점 스크린샷 자동 캡처에 `13_case_archive_appeal_remedy_history.png`를 추가했다.
- Steamworks 후보 스크린샷 패키징을 5장 기준으로 확장하고 `SCREENSHOT_CANDIDATES_KO.md`, `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`, `SCREENSHOT_UPLOAD_SELECTION_KO.md`, 상점 메타데이터/제출안에 보정 이력 후보를 반영했다.
- 캡처 검증: `Logs/runtime_store_candidate_appeal_remedy_history_visible.log`, `13_case_archive_appeal_remedy_history.png` `1920x1080`, 1,851,779 bytes.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_history_candidate.log`, `completed=true`, `caseArchiveMentionsAppealRemedyHistory=true`.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_appeal_remedy_history_candidate.log`, `passesMarketingAssetGate=true`, `checkCount=48`, `passedCheckCount=48`, `storeCandidateScreenshotCount=5`, `validStoreCandidateScreenshotCount=5`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_history_candidate.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_history_candidate.log`, `checkCount=96`, `passedCheckCount=96`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 스크린샷 A/B 판정

- Steamworks store_page 패키징에 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`를 자동 생성하도록 추가했다.
- 기본 후보는 `12_career_record_next_objective.png`, 비교 후보는 `13_case_archive_appeal_remedy_history.png`로 고정하고, 외부 A/B 피드백 전에는 기본 후보를 유지하도록 했다.
- A/B 회귀 QA가 외부 피드백 없음, 캠페인 기록 목표 재시작 선호, 보정 이력 선호 3개 시나리오를 검증한다.
- 회귀 QA: `Builds/QA/v0.3.0/store_page/care_review_screenshot_candidate_ab_test_regression.json`, `completed=true`, `noFeedbackKeepsDefault=true`, `careerPreferenceKeepsDefault=true`, `appealPreferencePromotesHistory=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_screenshot_candidate_ab_test_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_candidate_ab_test_docs.log`, `checkCount=98`, `passedCheckCount=98`, `localBlockerCount=0`.

### 2026-06-01 사례 자료실 판단 비교표

- 사례 자료실 상세 패널 상단에 `판단 비교` 섹션을 추가했다.
- 승인/조건부/보류/추가조사/거절의 예산, 안정, 형평, 위험, 후폭풍 차이를 `BuildDecisionPreview` 결과로 나란히 표시하고 권장 판단에는 `[권장]`을 붙인다.
- 사례 자료실 스모크가 상세 텍스트에서 `판단 비교`, `[권장]`, `예산`, `위험`, `후폭풍`을 검증하도록 확장했다.
- 스모크 결과를 `Application.persistentDataPath`와 `Builds/QA/v0.3.0/care_review_case_archive_smoke_result.json` 양쪽에 기록해 릴리즈 감사 입력이 stale 상태로 남지 않게 했다.
- 빌드: `Logs/build_case_archive_decision_comparison_mirror.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_decision_comparison_mirror.log`, `completed=true`, `caseArchiveMentionsDecisionComparison=true`, `caseArchiveMentionsAppealRemedyHistory=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_case_archive_decision_comparison.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_case_archive_decision_comparison.log`, `checkCount=98`, `passedCheckCount=98`, `localBlockerCount=0`.

### 2026-06-01 사례 자료실 판단 비교 연습

- 사례 자료실 하단에 `비교 연습` 버튼을 추가했다.
- 버튼 라벨은 현재 대표/포커스 사례의 권장 판단을 반영해 `조건부 승인 연습`처럼 표시된다.
- `비교 연습`을 누르면 현재 사례의 판단 비교표에서 권장 판단의 예산, 안정, 형평, 위험, 후폭풍을 이유로 묶은 `판단 비교 연습` 다음 목표를 만들고 바로 새 캠페인으로 진입한다.
- 비교 연습 목표는 승인/조건부/추가조사 계열이면 `지원 확대`, 거절이면 `긴축 감사`, 보류면 `균형 심사` 운영 기준으로 매핑한다.
- 사례 자료실 스모크가 버튼 준비와 목표 생성을 검증하고, 포커스 스모크가 하단 7개 버튼 전체를 순회하도록 확장했다.
- 빌드: `Logs/build_case_archive_decision_practice_focus.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_decision_practice_focus_build.log`, `completed=true`, `caseArchiveDecisionPracticeButtonReady=true`, `caseArchiveDecisionPracticeCreatesObjective=true`, `caseArchiveDecisionPracticeButtonText=조건부 승인 연습`.
- 포커스 스모크: `Logs/runtime_focus_case_archive_decision_practice.log`, `completed=true`, `caseArchiveNavigationButtonsFocusable=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_case_archive_decision_practice_focus.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_case_archive_decision_practice_focus.log`, `checkCount=98`, `passedCheckCount=98`, `localBlockerCount=0`.

### 2026-06-01 판단 비교 연습 리포트/기록 배지

- `판단 비교 연습` 회차를 시작하면 추천 버튼이 `비교 연습 시작: <운영 기준>`으로 바뀌고, 시작 브리핑에 기준 사례/목표/근거를 표시한다.
- 최종 리포트 요약 카드에는 `비교 연습 완료`, 분석 코멘트에는 `판단 비교 연습 완료`, 로그 경로 패널에는 `비교 연습 완료: <사례>` 행을 남긴다.
- 캠페인 기록에는 `판단 비교 연습 완료` 배지, 기준 사례, 연습 목표, 연습 근거를 저장하고 본문/상세 패널에 다시 표시한다.
- 전용 스모크 `-careReviewDecisionPracticeSmokeTest`를 추가해 버튼 준비, 목표 적용, 브리핑, 리포트, 캠페인 기록 저장/표시를 한 번에 검증한다.
- 빌드: `Logs/build_decision_practice_record_badge.log`, `Build Finished, Result: Success`.
- 판단 비교 연습 스모크: `Logs/runtime_decision_practice_record_badge.log`, `completed=true`, `buttonReady=true`, `objectiveReady=true`, `briefingMentionsPractice=true`, `reportMentionsPractice=true`, `careerRecordStoresPractice=true`, `careerMentionsPractice=true`, `recommendedButtonLabel=비교 연습 시작: 지원 확대`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_practice_record_badge.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_practice_record_badge.log`, `checkCount=99`, `passedCheckCount=99`, `localBlockerCount=0`.

### 2026-06-01 판단 비교 연습 성과/업적 후보 연결

- 판단 비교 연습 완료 회차가 `decision_practice_objective` 로컬 성과와 `CARE_DECISION_PRACTICE_OBJECTIVE` Steam 업적 후보를 해금하도록 연결했다.
- 성과 기록 상태줄과 반복 보상 패널에 `비교 연습 n회` 누적 요약을 추가했다.
- 성과 기록 하단에 `비교 기록` 버튼을 추가해 판단 비교 연습 완료 회차의 캠페인 기록으로 바로 이동하게 했다.
- 캠페인 기록 필터에 `비교`를 추가하고 본문에 `판단 비교 연습 요약`을 표시한다.
- 성과 카탈로그는 14개 후보가 됐고 Steamworks `ACHIEVEMENT_CANDIDATES_KO.md/.csv`도 `CARE_DECISION_PRACTICE_OBJECTIVE`를 포함한다.
- 포커스 이동 스모크가 `비교 기록` 버튼과 캠페인 기록 필터 8개를 검증하도록 확장했다.
- 빌드: `Logs/build_decision_practice_achievement_focus_gate.log`, `Build Finished, Result: Success`.
- 판단 비교 연습 스모크: `Logs/runtime_decision_practice_achievement_reward_final.log`, `completed=true`, `decisionPracticeAchievementUnlocked=true`, `achievementDecisionPracticeRecordButtonActive=true`, `achievementDecisionPracticeRecordOpensCareer=true`.
- 성과 기록 스모크: `Logs/runtime_achievement_decision_practice_catalog_final.log`, `completed=true`, `achievementCatalogCount=14`, `achievementCardsMentionDecisionPractice=true`, `achievementCatalogIncludesDecisionPracticeAchievement=true`, `achievementReplayRewardPanelMentionsDecisionPractice=true`.
- 포커스 이동 스모크: `Logs/runtime_focus_decision_practice_achievement_button_rerun.log`, `completed=true`, `achievementDecisionPracticeRecordButtonFocusable=true`, `careerRecordMandateFilterButtonFocusCount=8`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_decision_practice_achievement_reward.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_practice_achievement_reward.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_practice_achievement_reward.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 결정 감사 보정 전/후 그래프

- 결정 감사 대시보드의 이의제기 우선순위 요약 아래에 `보정 전/후 그래프` 행을 추가했다.
- 큐의 이의제기 고득점 사례 행에도 예산/위험/안정 전후 변화를 작은 막대(`▁->█`)와 증감 수치로 표시한다.
- 결정 감사 스모크가 `queueMentionsAppealBeforeAfterGraph=true`를 검증하도록 확장했다.
- README/manifest, Steam 제출 프리플라이트, 릴리즈 후보 감사가 `보정 전/후 그래프`와 `decision audit appeal before-after graph`를 요구하도록 강화했다.
- 빌드: `Logs/build_decision_audit_before_after_graph.log`, `Build Finished, Result: Success`.
- 결정 감사 스모크: `Logs/runtime_decision_audit_before_after_graph.log`, `completed=true`, `queueMentionsAppealPriority=true`, `queueMentionsAppealBeforeAfterGraph=true`, `appealCaseId=C-031`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_audit_before_after_graph.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_audit_before_after_graph.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 플레이테스트 패킷 HTML 보정 전/후 export

- 결정 감사 보정 전/후 그래프를 플레이테스트 패킷 세션 요약 JSON, 설문 Markdown, HTML 분석 대시보드에도 노출했다.
- `DecisionAuditPressureCaseExport`에 `beforeAfterGraph`, `queuePriorityScore`, 예산/위험/안정 전후 수치를 추가했다.
- HTML 분석 대시보드의 `주의 사례 큐`와 `고압력 대표 사례` 표에 `보정 전/후` 열을 추가했다.
- 플레이테스트 패킷 스모크가 `summaryHasDecisionAuditBeforeAfterGraph`, `summaryHasDecisionAuditBeforeAfterMetrics`, `feedbackMentionsDecisionAuditBeforeAfterGraph`, `dashboardMentionsDecisionAuditBeforeAfterGraph`를 검증하도록 확장했다.
- 스모크가 최신 플레이테스트 패킷 파일과 결과 JSON을 `Builds/QA/v0.3.0/playtest_packet`에 직접 미러링한다.
- 빌드: `Logs/build_playtest_packet_decision_audit_before_after_mirror.log`, `Build Finished, Result: Success`.
- 플레이테스트 패킷 스모크: `Logs/runtime_playtest_packet_decision_audit_before_after_mirror.log`, `completed=true`, `summaryHasDecisionAuditBeforeAfterGraph=true`, `summaryHasDecisionAuditBeforeAfterMetrics=true`, `feedbackMentionsDecisionAuditBeforeAfterGraph=true`, `dashboardMentionsDecisionAuditBeforeAfterGraph=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_playtest_packet_decision_audit_before_after.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_packet_decision_audit_before_after.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 동일 사례 회고 패널

- 캠페인 기록 상세에 `동일 사례 회고` 라인을 추가했다.
- 대표 사례 판단/권장 판단/일치 여부/압박 점수/보정 전후 그래프를 `CareerRecord`에 저장한다.
- 같은 대표 사례가 이전 캠페인 기록에도 있으면 판단 변화, 점수/권장 일치/위험 변화, 목표 재도전 결과를 한 줄로 비교한다.
- 캠페인 기록 필터 버튼 갱신 로직에 판단 비교 연습 필터를 포함해 8개 필터 상태를 안정화했다.
- 캠페인 기록 스모크가 `bodyMentionsRepresentativeRetrospective`, `detailMentionsRepresentativeRetrospective`, `recordHasRepresentativeDecisionSnapshot`을 검증하도록 확장했다.
- 빌드: `Logs/build_career_record_representative_retrospective.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_representative_retrospective.log`, `completed=true`, `bodyMentionsRepresentativeRetrospective=true`, `detailMentionsRepresentativeRetrospective=true`, `recordHasRepresentativeDecisionSnapshot=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_representative_retrospective.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_representative_retrospective.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 판단 비교 연습 2/4/6회 보상 단계

- 판단 비교 연습 완료 횟수를 성과 기록 상태줄, 반복 보상 패널, 캠페인 기록 `판단 비교 연습 요약`에 단계형 보상으로 표시한다.
- 2회 `비교 노트 인장`, 4회 `분기 카드 프레임`, 6회 `판단 훈련 명패` 문구를 해금/대기 상태로 구분한다.
- 성과 기록 스모크가 최고 단계 해금 상태를 검증하고, 판단 비교 연습 회귀 스모크가 1회 상태의 대기 문구를 검증한다.
- 빌드: `Logs/build_decision_practice_reward_tiers.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_decision_practice_reward_tiers.log`, `completed=true`, `achievementReplayRewardPanelMentionsDecisionPracticeTiers=true`.
- 판단 비교 연습 회귀 스모크: `Logs/runtime_decision_practice_reward_tiers_regression.log`, `completed=true`, `achievementReplayRewardMentionsPractice=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_practice_reward_tiers.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_practice_reward_tiers.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 플레이테스트 집계 이의제기/보정 그래프 유형 triage

- 플레이테스트 세션 집계가 각 세션 요약의 `decisionAuditCases`를 읽어 보정 전/후 그래프가 있는 이의제기 후보를 유형별로 묶는다.
- CSV에는 세션별 상위 보정 그래프 사례 열을, JSON에는 `appealRemedyGraphTriage` 목록을, Markdown에는 `이의제기/보정 그래프 유형 triage` 섹션을 추가했다.
- aggregate 스모크가 집계 산출물과 결과 JSON을 `Builds/QA/v0.3.0/playtest_packet`에 직접 미러링한다.
- 빌드: `Logs/build_playtest_appeal_remedy_graph_triage_mirror.log`, `Build Finished, Result: Success`.
- 플레이테스트 집계 스모크: `Logs/runtime_playtest_appeal_remedy_graph_triage_mirror.log`, `completed=true`, `csvHasAppealRemedyGraphTriageColumns=true`, `jsonHasAppealRemedyGraphTriage=true`, `markdownMentionsAppealRemedyGraphTriage=true`.
- 집계 결과: `appealRemedyGraphCaseCount=35`, `서류보강 28건/7세션`, `고위험 7건/7세션`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_playtest_appeal_remedy_graph_triage.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_appeal_remedy_graph_triage.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 동일 사례 회고 마케팅 노출

- 마케팅 캡처용 캠페인 기록 시드에 대표 사례 판단 변화와 보정 전후 그래프 스냅샷을 넣어 `동일 사례 회고`가 상점 후보/트레일러 프레임에 노출되도록 했다.
- 상점 스크린샷 manifest와 트레일러 프레임 manifest에 `representative retrospective` 설명을 추가했다.
- `Docs/Steam_상점페이지_자료.md`, `Docs/Steam_상점페이지_제출안.md`, `Docs/트레일러_리마스터_작업표.md`도 동일 사례 회고 후보 설명으로 갱신했다.
- 상점 캡처: `Logs/runtime_store_candidate_representative_retrospective_visible.log`, `12_career_record_next_objective.png`, `1920x1080`, 1,789,110 bytes.
- 트레일러 프레임 캡처: `Logs/runtime_trailer_frames_representative_retrospective_visible.log`, `trailer_013_career_record_filter.png`, `1920x1080`, 1,797,766 bytes.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_representative_retrospective.log`, `passesMarketingAssetGate=true`, `checkCount=48`, `passedCheckCount=48`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_marketing_representative_retrospective.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_marketing_representative_retrospective.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 판단 비교 연습 단계별 성과 기록 바로가기

- 성과 기록 보상 패널 오른쪽에 판단 비교 연습 2/4/6회 단계별 기록 버튼을 추가했다.
- 각 버튼은 캠페인 기록의 `비교` 필터를 적용하고 해당 단계에 처음 도달한 회차를 `성과 판단 비교 n회` 포커스로 연다.
- 반복 목표 단계 버튼은 윗줄, 판단 비교 단계 버튼은 아랫줄로 정리해 기존 성과 기록 하단 버튼 행과 충돌하지 않게 배치했다.
- 성과 기록 스모크가 단계별 버튼 활성화와 캠페인 기록 이동을 검증하고, 포커스 이동 스모크가 3개 버튼의 컨트롤러 선택 가능 상태를 검증한다.
- 빌드: `Logs/build_decision_practice_tier_record_links.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_decision_practice_tier_record_links.log`, `completed=true`, `achievementDecisionPracticeTierRecordButtonsActive=true`, `achievementDecisionPracticeTierRecordButtonOpensCareer=true`.
- 그래픽 모드 캡처: `Logs/runtime_achievement_decision_practice_tier_record_links_visible.log`, `care_review_achievements.png`, 1,775,682 bytes.
- 포커스 이동 스모크: `Logs/runtime_focus_navigation_decision_practice_tier_record_links.log`, `completed=true`, `achievementDecisionPracticeTierRecordButtonsFocusable=true`, `achievementDecisionPracticeTierRecordSelectionIsButton=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_practice_tier_record_links.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_practice_tier_record_links.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 사례 자료실 보정 그래프 triage 추천 목표 연결

- 사례 자료실이 플레이테스트 집계 JSON의 `appealRemedyGraphTriage` 최상위 항목을 읽어 `보정 그래프 triage 추천` 라인으로 표시한다.
- 추천 유형에 해당하는 필터로 이동하면 top case가 자동 포커스되고, `목표 심사`가 `이의제기 보정 triage 재심사` 목표를 생성한다.
- 현재 QA 집계 기준 추천은 `서류보강` 28건/7세션, top case `AG-349`이며 목표 문구는 `D5 AG-349형 이의제기 보정 triage 재심사`다.
- 사례 자료실 스모크가 추천 존재, top case 포커스, 보정 목표 생성, 적용 상태 문구를 검증한다.
- 빌드: `Logs/build_case_archive_appeal_remedy_graph_triage_objective.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_graph_triage_objective.log`, `completed=true`, `appealRemedyGraphTriageRecommendationAvailable=true`, `appealRemedyGraphTriageFocusesRecommendedCase=true`, `appealRemedyGraphTriageCreatesRemedyObjective=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_case_archive_appeal_remedy_graph_triage_objective.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_case_archive_appeal_remedy_graph_triage_objective.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 캠페인 기록 요약 캡처

- `12_career_record_next_objective.png` 캡처 직전에만 캠페인 기록 요약 모드를 켜서 본문/상세 패널을 상점 후보용 핵심 정보 중심으로 압축했다.
- 요약 본문은 장기 추세, 성장 비교, 짧은 동일 사례 회고, 핵심 완료 회차 4줄, 다음 목표/추천 근거를 우선 표시한다.
- 상세 패널은 목표 재시작, 추천 근거, 다음 비교, 사례 링크만 남겨 하단 텍스트 과밀을 줄였다.
- 캠페인 기록 헤더의 `캠페인 기록` 제목을 필터 버튼과 분리해 상단 겹침을 제거했다.
- 상점 스크린샷 manifest와 마케팅 감사 토큰에 `compact retrospective summary`를 추가했다.
- 빌드: `Logs/build_store_candidate_compact_header_fix.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_store_candidate_compact_header_fix.log`, `completed=true`, `bodyMentionsRepresentativeRetrospective=true`, `growthFollowUpFilterAppliesToRecord=true`, `careerRecordNextObjectiveStartsCampaign=true`.
- 상점 캡처: `Logs/runtime_store_candidate_compact_header_fix_visible.log`, `Builds/Marketing/v0.3.0/screenshots/12_career_record_next_objective.png`, `1920x1080`, 1,759,065 bytes.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_store_candidate_compact_career_record.log`, `passesMarketingAssetGate=true`, `checkCount=48`, `passedCheckCount=48`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_candidate_compact_career_record.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_compact_career_record.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 판단 비교 보상 상세 라인

- 판단 비교 연습 완료 회차의 캠페인 기록 상세에 `비교 보상 단계` 요약을 추가했다.
- 선택 회차 기준 누적 판단 비교 완료 횟수를 계산해 `비교 보상 2회`, `비교 보상 4회`, `비교 보상 6회`를 별도 줄로 표시한다.
- 각 줄은 `비교 노트 인장`, `분기 카드 프레임`, `판단 훈련 명패`와 해금/남은 횟수 상태를 함께 보여준다.
- 판단 비교 스모크와 릴리즈 감사가 `careerDetailMentionsPracticeRewardLines=true`를 요구하도록 강화했다.
- 빌드: `Logs/build_decision_practice_reward_detail_lines.log`, `Build Finished, Result: Success`.
- 판단 비교 스모크: `Logs/runtime_decision_practice_reward_detail_lines.log`, `completed=true`, `careerDetailMentionsPracticeRewardLines=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_decision_practice_reward_detail_lines.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_practice_reward_detail_lines.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 메인 메뉴 보정 triage 추천 버튼

- 사례 자료실의 플레이테스트 보정 그래프 triage 추천을 메인 메뉴 후속/보정 버튼에도 연결했다.
- pending 목표가 없어도 triage 최상위 추천이 있으면 버튼 라벨을 `보정 추천`으로 켜고, 힌트에 `서류보강 · AG-349`처럼 유형/top case를 표시한다.
- 메인 메뉴 상태줄에는 `보정 triage 추천` 라인으로 추천 유형, 사례/세션 수, top case, 바로 시작 안내를 표시한다.
- 버튼 실행 시 해당 top case를 `이의제기 보정 triage 재심사` 목표로 만들어 추천 심사를 시작한다.
- 사례 자료실 스모크와 릴리즈 감사가 `appealRemedyGraphTriageMenuButtonReady=true`, `appealRemedyGraphTriageMenuStatusMentionsRecommendation=true`를 요구하도록 강화했다.
- 빌드: `Logs/build_main_menu_appeal_remedy_graph_triage_recommendation_retry.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_main_menu_appeal_remedy_graph_triage_recommendation.log`, `completed=true`, `appealRemedyGraphTriageMenuButtonText=보정 추천`, `appealRemedyGraphTriageMenuHintText=서류보강 · AG-349`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_main_menu_appeal_remedy_graph_triage_recommendation.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_main_menu_appeal_remedy_graph_triage_recommendation.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 필터 2줄 카운트 라벨

- 캠페인 기록 상단 기준 필터 버튼을 `전체\n2`, `성장\n1`처럼 라벨/카운트 2줄 구조로 바꿨다.
- 버튼 크기를 `80x44`로 키우고 텍스트 line spacing/중앙 정렬을 고정해 Paperlogy에서 가로 압축이 덜 보이게 했다.
- 캠페인 기록 스모크의 필터 카운트 검증도 한 줄 문자열 대신 라벨/숫자 포함 검증으로 갱신했다.
- 빌드: `Logs/build_career_record_filter_multiline_labels_retry.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_filter_multiline_labels_retry.log`, `completed=true`, `mandateFilterButtonsMentionRecordCounts=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_career_record_filter_multiline_labels.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 그래픽 모드 캡처: `Logs/runtime_career_record_filter_multiline_labels_visible.log`, `care_review_career_records.png`, 1,787,195 bytes.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_filter_multiline_labels.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_filter_multiline_labels.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 사례 자료실 triage 추천 문구 통일

- 사례 자료실 보정 그래프 triage 추천, 메인 메뉴 상태줄, `보정 추천` 버튼 힌트가 같은 `보정 triage: <유형> · <caseId> · <건수>/<세션>` 요약을 쓰도록 통일했다.
- 현재 QA 집계 기준 추천은 `보정 triage: 서류보강 · AG-349 · 28건/7세션`으로 표시된다.
- 사례 자료실 추천 라인은 같은 요약 뒤에 보정 전/후 그래프와 필터 이동 안내를 붙이고, 메인 메뉴 버튼 힌트는 같은 요약을 축약 표시한다.
- 사례 자료실 스모크와 릴리즈 감사가 `appealRemedyGraphTriageUsesUnifiedSummary=true`와 `appeal-remedy graph triage shared summary` manifest 토큰을 요구하도록 강화했다.
- 빌드: `Logs/build_appeal_remedy_graph_triage_shared_summary.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_graph_triage_shared_summary.log`, `completed=true`, `appealRemedyGraphTriageUsesUnifiedSummary=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_graph_triage_shared_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_graph_triage_shared_summary.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 보정 브리핑 원 사례 빠른 링크

- 이의제기 보정 목표 브리핑 1단계에 `원 사례` 버튼을 추가했다.
- 버튼을 누르면 현재 보정 목표의 원 사례를 사례 자료실에서 포커스하고, 상태줄에 `브리핑 원 사례` 출처를 표시한다.
- 튜토리얼 하단 버튼 배치를 3개 슬롯으로 조정하고, 보정 목표 브리핑이 아닐 때는 원 사례 버튼을 숨긴다.
- 사례 자료실 스모크가 `appealBriefingCaseArchiveQuickLinkActive=true`, `appealBriefingCaseArchiveQuickLinkOpensCase=true`를 요구하도록 강화했다.
- 저해상도 UI 스모크로 변경된 브리핑 버튼 배치의 텍스트 넘침/화면 밖 버튼 0건을 확인했다.
- 빌드: `Logs/build_appeal_remedy_briefing_case_archive_quick_link.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_briefing_case_archive_quick_link.log`, `completed=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_appeal_remedy_briefing_quick_link.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_briefing_case_archive_quick_link.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_briefing_case_archive_quick_link.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 상세 줄바꿈 강화

- 캠페인 기록 상세/상점 후보 상세 텍스트에 전용 폭 기준 줄바꿈을 적용했다.
- 공백, `·`, `/`, `:`, 쉼표를 우선 분리 지점으로 사용하고, bullet 후속 줄은 들여쓰기를 유지한다.
- 캠페인 기록 스모크가 상세 패널 최대 표시 폭을 검사해 `careerDetailUsesAggressiveLineWrap=true`를 요구하도록 강화했다.
- 릴리즈 manifest와 릴리즈 후보 감사에 `career record detail aggressive line wrap` 토큰을 추가했다.
- 빌드: `Logs/build_career_record_detail_aggressive_line_wrap.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_detail_aggressive_line_wrap.log`, `completed=true`, `careerDetailMaxDisplayLineWidth=63.4`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_detail_aggressive_line_wrap.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_detail_aggressive_line_wrap.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 성과 기록 보정 triage 다음 목표

- 성과 기록의 다음 잠긴 성과가 `이의제기 보정 설계자`일 때 플레이테스트 보정 triage 최상위 추천을 로드맵에 표시한다.
- 현재 QA 집계 기준 추천 행동은 `보정 triage: 서류보강 · AG-349 · 28건/7세션`이다.
- 성과 기록 상단 다음 목표 버튼은 `보정 추천`으로 바뀌고, 실행 시 추천 사례를 사례 자료실에서 포커스한다.
- 성과 기록 스모크와 릴리즈 감사가 `achievementNextGoalMentionsAppealTriage=true`를 요구하도록 강화했다.
- 빌드: `Logs/build_achievement_appeal_remedy_triage_next_goal.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_appeal_remedy_triage_next_goal.log`, `completed=true`, `achievementNextGoalButtonLabel=보정 추천`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_appeal_remedy_triage_next_goal.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_appeal_remedy_triage_next_goal.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 보정 브리핑 원 사례 버튼 포커스 QA

- 이의제기 보정 목표 브리핑의 `원 사례` 버튼을 컨트롤러 포커스 이동 스모크의 명시 검증 대상으로 추가했다.
- 스모크는 보정 목표 브리핑 1단계를 열고 `원 사례` 버튼이 활성 루트 안에서 선택 가능하며 포커스 하이라이트가 보이는지 확인한다.
- 결과 JSON에 `tutorialHasSelection`, `tutorialHasFocusHighlight`, `tutorialCaseArchiveButtonFocusable`, `tutorialCaseArchiveSelectionIsButton`, `tutorialCaseArchiveSelected`를 추가했다.
- 릴리즈 manifest와 릴리즈 후보 감사가 `appeal remedy briefing case archive quick link focus navigation`과 새 포커스 필드를 요구하도록 강화했다.
- 빌드: `Logs/build_appeal_remedy_briefing_case_archive_focus_navigation.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_navigation_appeal_remedy_briefing_case_archive.log`, `completed=true`, `tutorialCaseArchiveSelected=원 사례`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_briefing_case_archive_focus_navigation_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_briefing_case_archive_focus_navigation_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 캠페인 기록 상세 줄바꿈 시각 검수

- 상점 후보 `12_career_record_next_objective.png`의 원본 manifest에 `detail aggressive line wrap visual check` 토큰을 추가했다.
- Steamworks `SCREENSHOT_CANDIDATES_KO.md`의 12번 후보 판정 기준에 상세 줄바꿈 상태를 명시했다.
- 마케팅 자산 감사에 `storeCandidateCareerRecordDetailWrapVisualChecked` 필드를 추가해 12번 후보 PNG와 원본 manifest 토큰을 함께 검증한다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사가 새 마케팅 smoke 필드와 `career record store candidate detail line wrap visual check` manifest 토큰을 요구하도록 강화했다.
- 빌드: `Logs/build_store_candidate_detail_wrap_visual_check.log`, `Build Finished, Result: Success`.
- 상점 캡처 실행: `Logs/runtime_store_candidate_detail_wrap_visual_check.log`, persistentDataPath manifest에 새 토큰 생성 확인.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_store_candidate_detail_wrap_visual_check.log`, `passesMarketingAssetGate=true`, `storeCandidateCareerRecordDetailWrapVisualChecked=true`, `checks=48/48`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_candidate_detail_wrap_visual_check_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_detail_wrap_visual_check_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 성과 기록 보정 추천 포커스 라벨 QA

- 컨트롤러 포커스 이동 스모크가 성과 기록의 다음 목표 버튼을 보정 triage 상태로 시드한 뒤 `보정 추천` 라벨을 별도 검증한다.
- 결과 JSON에 `achievementNextGoalButtonLabelIsAppealTriage`, `achievementNextGoalButtonLabel`, `achievementNextGoalSelected`를 추가했다.
- 완료 조건, Steam 제출 프리플라이트, 릴리즈 후보 감사가 새 라벨 필드를 요구한다.
- 릴리즈 manifest에 `achievement appeal-remedy triage focus label` 토큰을 추가했다.
- 빌드: `Logs/build_achievement_appeal_remedy_triage_focus_label.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_achievement_appeal_remedy_triage_label.log`, `completed=true`, `achievementNextGoalButtonLabelIsAppealTriage=true`, `achievementNextGoalButtonLabel=보정 추천`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_appeal_remedy_triage_focus_label_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_appeal_remedy_triage_focus_label_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 보정 triage 후보 목록 공유

- 보정 triage 공통 요약에 상위 후보 2~3개 목록을 추가했다.
- 현재 집계 기준 후보는 `후보 2개: 서류보강 AG-349, 고위험 W-207`로 표시된다.
- 사례 자료실 추천 라인, 메인 메뉴 보정 추천 상태줄, 성과 기록 보정 추천 문구가 같은 후보 목록을 공유한다.
- 사례 자료실 스모크와 릴리즈 감사가 `appealRemedyGraphTriageMentionsCandidateList=true`를 요구한다.
- 릴리즈 manifest에 `appeal-remedy graph triage candidate list` 토큰을 추가했다.
- 빌드: `Logs/build_appeal_remedy_graph_triage_candidate_list_retry.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_graph_triage_candidate_list_retry.log`, `completed=true`, `appealRemedyGraphTriageMentionsCandidateList=true`.
- 성과 기록 스모크: `Logs/runtime_achievement_appeal_remedy_graph_triage_candidate_list.log`, `completed=true`, `achievementNextGoalButtonLabel=보정 추천`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_graph_triage_candidate_list_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_graph_triage_candidate_list_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 보정 triage 후보별 열기/시작 액션

- 사례 자료실에 보정 triage 후보를 순환하는 `후보 2개` 버튼과 현재 후보로 브리핑을 여는 `후보 시작` 버튼을 추가했다.
- 후보 열기는 다음 triage 후보로 필터/페이지/포커스를 자동 이동한다.
- 후보 시작은 현재 포커스된 후보를 `이의제기 보정 triage 재심사` 목표로 적용하고 보정 목표 브리핑을 바로 연다.
- 사례 자료실 스모크가 후보 버튼 활성, 다음 후보 `W-207` 포커스, 후보 시작 브리핑 진입을 검증한다.
- 컨트롤러 포커스 이동 스모크가 두 후보 버튼의 선택 가능 상태를 검증한다.
- 저해상도 UI 스모크로 새 버튼의 텍스트 넘침/화면 밖 배치 0건을 확인했다.
- 빌드: `Logs/build_appeal_remedy_graph_triage_candidate_actions_focus.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_graph_triage_candidate_actions_focus.log`, `completed=true`, `appealRemedyGraphTriageCandidateButtonStartsObjective=true`.
- 포커스 이동 스모크: `Logs/runtime_focus_appeal_remedy_graph_triage_candidate_actions.log`, `completed=true`, `caseArchiveTriageCandidateButtonsFocusable=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_appeal_remedy_graph_triage_candidate_actions.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_graph_triage_candidate_actions_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_graph_triage_candidate_actions_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 보정 triage 공유 후보 선택 상태

- 보정 triage 후보 선택 인덱스를 메인 메뉴, 사례 자료실, 성과 기록이 공유하도록 확장했다.
- 메인 메뉴와 성과 기록 상단에 `후보 1/2` 전환 버튼을 추가해 `AG-349`와 `W-207` 후보를 같은 순서로 바꿀 수 있다.
- 공유 후보가 `W-207`이면 메인 메뉴 `보정 추천` 시작과 성과 기록 다음 목표 실행도 `W-207` 사례 자료실/보정 목표로 이어진다.
- 사례 자료실/성과 기록/포커스 스모크가 각각 `appealRemedyGraphTriageMenuCandidateCycleSelectsNext=true`, `achievementNextGoalUsesSharedAppealTriageCandidate=true`, `menuAppealRemedyTriageCandidateButtonFocusable=true`를 검증한다.
- 빌드: `Logs/build_appeal_remedy_graph_triage_shared_candidate_state.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_appeal_remedy_graph_triage_shared_candidate_state.log`, `completed=true`.
- 성과 기록 스모크: `Logs/runtime_achievement_appeal_remedy_graph_triage_shared_candidate_state.log`, `completed=true`.
- 포커스 이동 스모크: `Logs/runtime_focus_appeal_remedy_graph_triage_shared_candidate_state.log`, `completed=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_appeal_remedy_graph_triage_shared_candidate_state.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.

### 2026-06-01 캠페인 기록 보정 triage 후보 결과

- 이의제기 보정 triage 후보 목표 완료 회차가 캠페인 기록에 후보 라벨과 후보별 결과 요약을 저장하도록 확장했다.
- 캠페인 기록 상세/본문/상점 후보 상세에 `보정 후보 결과: <라벨> · <caseId> · <성공/미달>` 라인을 표시한다.
- 사례 자료실 스모크가 `W-207` 후보 목표를 시작해 회차 완료 후 `appealRemedyGraphTriageCandidateResultSaved=true`, `careerDetailMentionsAppealTriageCandidateResult=true`를 검증한다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사가 같은 결과 필드를 요구하도록 강화했다.
- 빌드: `Logs/build_career_record_appeal_remedy_triage_candidate_result.log`, `Build Finished, Result: Success`.
- 사례 자료실 스모크: `Logs/runtime_case_archive_career_record_appeal_remedy_triage_candidate_result.log`, `completed=true`, `appealRemedyGraphTriageCandidateRecordLabel=고위험`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_career_record_appeal_remedy_triage_candidate_result.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_appeal_remedy_triage_candidate_result_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_appeal_remedy_triage_candidate_result_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 보정 triage 후보 저장/복원

- 메인 메뉴/성과 기록의 보정 triage 후보 선택 인덱스를 슬롯별 PlayerPrefs에 저장해 슬롯 전환 뒤에도 선택 후보가 유지되게 했다.
- 세션 save JSON에도 `appealRemedyGraphTriageCandidateIndex`를 포함해 이어하기와 백업 복구 흐름에서 같은 후보로 복원한다.
- 저장 복구 스모크가 첫 저장, 두 번째 저장, 손상 primary 복구, 슬롯 preference 복원까지 `firstSaveStoresAppealTriageCandidate`, `secondSaveStoresAppealTriageCandidate`, `restoredAppealTriageCandidate`, `slotPreferenceRestoredAppealTriageCandidate`로 검증한다.
- 사례 자료실 스모크는 테스트 시작 시 후보 preference를 격리하고 종료 시 원래 값을 복원해 기존 AG-349 기준 추천 검증과 새 저장 기능이 충돌하지 않게 했다.
- 빌드: `Logs/build_appeal_remedy_triage_candidate_save_restore_smoke_isolation.log`, `Build Finished, Result: Success`.
- 저장 복구 스모크: `Logs/runtime_save_recovery_appeal_remedy_triage_candidate_restore_mirror.log`, `completed=true`, `restoredAppealTriageCandidateIndex=1`.
- 사례 자료실 회귀 스모크: `Logs/runtime_case_archive_appeal_remedy_triage_candidate_save_restore_isolated_fixed.log`, `completed=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_appeal_remedy_triage_candidate_save_restore_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_appeal_remedy_triage_candidate_save_restore_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 성과 기록 보정 triage 후보 결과 진행도

- 보정 업적 카드 진행 문구에 최신 보정 triage 후보 라벨, caseId, 성공/미달, 후보 기록/성공 수를 표시한다.
- 성과 기록 상단 상태줄에는 짧은 `보정 후보 고위험 W-207 미달` 요약을 추가해 다음 목표를 보기 전에도 후보별 진행 상태가 보이게 했다.
- 반복 보상 패널에도 같은 후보 결과 요약을 넣어 보정 목표, 판단 비교, 성장 성과가 한 줄에서 함께 읽히도록 했다.
- 성과 기록 스모크가 `achievementCardMentionsAppealTriageResult`, `achievementStatusMentionsAppealTriageResult`, `achievementReplayRewardPanelMentionsAppealTriageResult`를 검증한다.
- 빌드: `Logs/build_achievement_appeal_remedy_triage_result_progress_validation_fix.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_appeal_remedy_triage_result_progress_validation_fix.log`, `completed=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_appeal_remedy_triage_result_progress_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_appeal_remedy_triage_result_progress_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 성과 기록 보정 triage 후보 기록 링크

- 성과 기록의 보정 기록 버튼이 후보 결과가 있는 기록을 찾으면 `보정 후보` 라벨로 바뀌게 했다.
- 버튼 실행 시 최신 후보 결과가 포함된 캠페인 기록 상세로 바로 이동하고, 상세/본문의 `보정 후보 결과` 라인을 검증한다.
- 성과 기록 스모크가 `achievementAppealRemedyRecordButtonMentionsTriageResult=true`, `achievementAppealRemedyRecordOpensTriageResult=true`, `achievementAppealRemedyRecordButtonLabel=보정 후보`를 검증한다.
- 빌드: `Logs/build_achievement_appeal_remedy_triage_record_link.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_appeal_remedy_triage_record_link.log`, `completed=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_achievement_appeal_remedy_triage_record_link_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_appeal_remedy_triage_record_link_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 보정 triage 후보 필터

- 캠페인 기록 상단 필터에 `후보` 버튼을 추가해 이의제기 보정 완료 기록 중 후보 결과 라벨이 저장된 회차만 따로 모을 수 있게 했다.
- 새 필터의 본문/상태/상세 패널은 `기준 필터: 보정 후보`, `보정 후보 결과`, 후보 라벨, caseId를 함께 표시한다.
- 캠페인 기록 스모크가 9개 필터 버튼, 후보 필터 카운트, 후보 상세 라인을 검증하도록 확장했다.
- 컨트롤러 포커스 이동 감사 기준을 `careerRecordMandateFilterButtonFocusCount=9`로 갱신했다.
- 빌드: `Logs/build_career_record_appeal_triage_filter.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_appeal_triage_filter.log`, `completed=true`, `bodyMentionsAppealTriageFilter=true`, `appealTriageFilterAppliesToRecord=true`, `appealTriageFilteredDetailMentionsCandidateResult=true`.
- 포커스 이동 스모크: `Logs/runtime_focus_career_record_appeal_triage_filter.log`, `completed=true`, `careerRecordMandateFilterButtonFocusCount=9`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_career_record_appeal_triage_filter.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_appeal_triage_filter_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_appeal_triage_filter_docs.log`, `checkCount=100`, `passedCheckCount=100`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 캡처 그래픽 동기화 명령

- `Builds/Marketing/v0.3.0/scripts/capture_store_candidate_screenshots_graphics_sync.ps1`를 생성해 플레이어 빌드를 1920x1080 그래픽 모드로 실행하고 `-careReviewCaptureStoreScreenshots` 결과를 후보 스크린샷 폴더에 동기화하게 했다.
- 스크립트는 런타임 로그의 `CARE_REVIEW_STORE_SCREENSHOTS_DONE path=`를 파싱해 실제 persistent capture 경로를 찾고, 09~13 후보 PNG를 Marketing/Steamworks 후보 폴더에 함께 복사한다.
- Steamworks store_page에도 같은 스크립트와 `STORE_CANDIDATE_CAPTURE_SYNC_MANIFEST.md`를 복사해 상점 입력 직전 재캡처 절차가 패키지 안에 남게 했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사가 `-careReviewCaptureStoreScreenshots`, 1920x1080, 후보 5장, `screenshot_candidates` 동기화 토큰을 요구하도록 강화했다.
- 빌드: `Logs/build_store_candidate_capture_sync_command.log`, `Build Finished, Result: Success`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_candidate_capture_sync_command.log`.
- 스크립트 문법 검증: PowerShell parser `POWERSHELL_PARSE_OK`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_capture_sync_command.log`, `checkCount=101`, `passedCheckCount=101`, `localBlockerCount=0`.

### 2026-06-01 상점/트레일러 보정 후보 회차 장면

- 상점 스크린샷 `08_career_record_filter.png`와 트레일러 프레임 `trailer_013_career_record_filter.png`가 `보정 후보` 필터 장면을 캡처하도록 바꿨다.
- 런타임 캡처 manifest에는 `career record appeal triage candidate filter`, `candidate play record`, `보정 후보 결과` 토큰을 남겨 후보별 회차 결과가 마케팅 장면에 반영됐는지 확인한다.
- 상점 후보 동기화 명령은 후보 09~13뿐 아니라 공식 08번 스크린샷도 Marketing 공식 스크린샷 폴더에 갱신한다.
- 상점 자료/제출안과 트레일러 리마스터 작업표도 `보정 후보 필터`, `후보별 회차 결과` 설명으로 갱신했다.
- 빌드: `Logs/build_store_trailer_appeal_triage_candidate_capture_final.log`, `Build Finished, Result: Success`.
- 상점 그래픽 캡처: `Logs/runtime_store_screenshots_appeal_triage_candidate_capture.log`, `08_career_record_filter.png` manifest에 후보 필터 토큰 확인.
- 동기화 명령 실행: `Logs/runtime_store_candidate_graphics_capture_sync.log`, `Builds/Marketing/v0.3.0/screenshots/08_career_record_filter.png` 갱신.
- 트레일러 프레임 캡처: `Logs/runtime_trailer_frames_appeal_triage_candidate_capture.log`, `trailer_013_career_record_filter.png` manifest에 후보 필터 토큰 확인.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_appeal_triage_candidate_capture.log`, `passesMarketingAssetGate=true`, `checks=48/48`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_trailer_appeal_triage_candidate_capture_docs.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_trailer_appeal_triage_candidate_capture_docs.log`, `checkCount=101`, `passedCheckCount=101`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 보정 후보 큐 복귀

- 캠페인 기록에서 보정 후보 결과가 저장된 회차를 보면 기존 `보정 사례` 버튼이 `후보 큐`로 바뀐다.
- `후보 큐` 실행 시 사례 자료실을 열고 후보 라벨에 맞는 필터/포커스 상태로 돌아가며, 상태줄에 `캠페인 기록 포커스: 보정 후보 큐`를 표시한다.
- 캠페인 기록 스모크가 `appealTriageQueueButtonLabel=true`, `appealRemedyCaseButtonLabel=후보 큐`, `appealRemedyArchiveStatusMentionsCareer=true`를 검증한다.
- 빌드: `Logs/build_career_record_appeal_triage_queue_link.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_appeal_triage_queue_link.log`, `completed=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_career_record_appeal_triage_queue_link.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_career_record_appeal_triage_queue_link.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_appeal_triage_queue_link.log`, `checkCount=101`, `passedCheckCount=101`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 캡처 SHA manifest

- 상점 후보 캡처 동기화 명령이 `store_candidate_capture_sync_hashes.sha256`을 생성하도록 확장했다.
- 해시 manifest에는 공식 갱신 대상 `08_career_record_filter.png`와 후보 5장 `09`~`13` PNG의 SHA256이 함께 기록된다.
- Steamworks 후보 폴더에는 `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256` 이름으로 복사해 상점 입력 직전 캡처 세트 무결성을 확인할 수 있게 했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사가 해시 manifest와 주요 파일명을 요구하도록 강화했다.
- 동기화 명령 실행: `Logs/runtime_store_candidate_graphics_capture_sync.log`, `Builds/Marketing/v0.3.0/screenshots/store_candidate_capture_sync_hashes.sha256` 생성.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_candidate_capture_hash_manifest.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_capture_hash_manifest.log`, `checkCount=102`, `passedCheckCount=102`, `localBlockerCount=0`.

### 2026-06-01 상점 후보 판정표 보정 후보 QA 증거

- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`에 `후보 결과 QA 증거` 섹션을 추가했다.
- 판정표가 캠페인 기록 후보 필터 스모크의 `bodyMentionsAppealTriageFilter`, `appealTriageFilterAppliesToRecord`, `appealTriageQueueButtonLabel`을 참조한다.
- 성과 기록 후보 진행도 스모크의 `achievementCardMentionsAppealTriageResult`, `achievementStatusMentionsAppealTriageResult`, `achievementReplayRewardPanelMentionsAppealTriageResult`도 후보 판정 근거로 연결했다.
- 상점 후보 캡처 무결성 증거로 `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`를 명시했다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_screenshot_candidate_triage_evidence.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_candidate_triage_evidence.log`, `checkCount=102`, `passedCheckCount=102`, `localBlockerCount=0`.

### 2026-06-01 보정 후보 큐 역방향 기록 링크

- 사례 자료실에 캠페인 기록에서 들어온 경우에만 표시되는 `후보 기록` 버튼을 추가했다.
- 역방향 링크는 회차 `sessionId`, 시작 시각, 원 source label, 복귀 필터를 저장해 후보 큐에서 다시 캠페인 기록 `보정 후보` 필터의 해당 회차 상세로 돌아간다.
- 캠페인 기록 스모크가 `appealTriageQueueReturnButtonActive=true`, `appealTriageQueueReturnButtonLabel=true`, `appealTriageQueueReturnOpensCareerRecord=true`를 검증한다.
- 빌드: `Logs/build_case_archive_appeal_triage_queue_return.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_appeal_triage_queue_return.log`, `completed=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_case_archive_appeal_triage_queue_return.log`, `completed=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_case_archive_appeal_triage_queue_return.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_case_archive_appeal_triage_queue_return.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.

### 2026-06-01 외부 handoff 상점 후보 SHA manifest

- 외부 검증 handoff 패킷에 `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`을 추가했다.
- 같은 SHA manifest를 `Builds/Handoff/v0.3.0`, `Builds/Steamworks/v0.3.0`, handoff zip 내부 `v0.3.0/`에 복사해 상점 후보 캡처 세트 무결성을 외부 검수 자료에도 남긴다.
- handoff README와 `EXTERNAL_RELEASE_HANDOFF_KO.md`가 상점 후보 캡처 SHA manifest 위치를 안내한다.
- 배포 무결성 스모크가 `hasHandoffStoreCandidateHashManifest=true`, `handoffZipContainsStoreCandidateHashManifest=true`를 검증한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_handoff_store_candidate_hash_manifest.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_store_candidate_hash_manifest.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `allPassed=true`, `checkCount=17`, `passedCheckCount=17`.

### 2026-06-01 트리아지 action CSV 담당 화면 증거 열

- `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`에 `owner_screen_evidence` 열을 추가했다.
- 반복 보상/장기 기록 가치감 액션은 담당 화면 증거로 캠페인 기록 보정 후보 복귀 스모크, 성과 기록 보정 후보 표시 스모크, 상점 후보 SHA manifest를 함께 가리킨다.
- action CSV와 외부 handoff 사본/zip이 `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`, `보정 후보 결과`를 포함하도록 했다.
- 플레이테스트 회수 감사: `Logs/audit_playtest_collection_owner_screen_evidence.log`, `sessions=78`, `complete=2`, `hasAppealTriageOwnerScreenEvidence=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_owner_screen_evidence.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_owner_screen_evidence.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `allPassed=true`, `hasHandoffTriageActionsCsv=true`, `handoffZipContainsTriageActionsCsv=true`.

### 2026-06-01 보정 후보 기록 복귀 포커스 QA

- 컨트롤러 포커스 이동 스모크가 사례 자료실의 `후보 기록` 역방향 버튼을 직접 검증하도록 확장했다.
- 스모크는 캠페인 기록의 `후보 큐` 버튼으로 사례 자료실을 연 뒤 `후보 기록` 버튼 포커스, 선택 상태, 캠페인 기록 `보정 후보` 필터 복귀를 확인한다.
- 새 검증 필드는 `caseArchiveCareerRecordReturnButtonFocusable`, `caseArchiveCareerRecordReturnSelectionIsButton`, `caseArchiveCareerRecordReturnOpensCareerRecord`다.
- 빌드: `Logs/build_focus_case_archive_career_record_return.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_case_archive_career_record_return.log`, `completed=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_focus_case_archive_career_record_return.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_focus_case_archive_career_record_return.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.

### 2026-06-01 Store Presence SHA 체크카드

- 외부 handoff와 Steamworks 루트에 `STORE_PRESENCE_QA_CARD_KO.md`를 추가했다.
- 체크카드는 `STORE_PRESENCE_SELECTION_KO.md` 준비 상태, 공식 스크린샷 적용 manifest, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`의 08/12/13 PNG 해시 확인을 Store Presence 입력 절차에 묶는다.
- 외부 게이트 증거 템플릿 `Evidence/_templates/STORE_PRESENCE.md`도 필수 키워드에 `SHA`를 추가해 후보 캡처 무결성 확인 없이 Store Presence 게이트가 닫히지 않게 했다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_sha_card.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_sha_card.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `allPassed=true`, `checkCount=19`, `passedCheckCount=19`.

### 2026-06-01 트리아지 리포트 담당 화면 증거 표

- `care_review_playtest_commercial_triage.md`와 `.html`의 조치 우선순위/담당 화면별 체크리스트에 `담당 화면 증거` 열을 추가했다.
- 반복 보상/장기 기록 가치감 액션은 리포트 표에서도 `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`를 같이 보여준다.
- 플레이테스트 회수 감사: `Logs/audit_playtest_collection_owner_screen_evidence_reports.log`, `markdownHasOwnerScreenEvidence=true`, `htmlHasOwnerScreenEvidence=true`.
- Steamworks depot 갱신: `Logs/prepare_steamworks_owner_screen_evidence_reports.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_owner_screen_evidence_reports.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.

### 2026-06-01 Store Presence 선택 manifest 보정 후보 QA 증거

- `STORE_PRESENCE_SELECTION_KO.md`에 `store_candidate_hash_manifest`, `store_candidate_hash_ready`, `appeal_triage_qa_evidence` 필드를 추가했다.
- Store Presence 수동 입력 준비 상태는 `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`와 보정 후보 QA 증거가 연결되어야 `yes`가 되도록 했다.
- 보정 후보 QA 증거는 `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `보정 후보 결과`를 기록한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_appeal_triage_evidence.log`.
- Store Presence 선택 회귀: `Builds/QA/v0.3.0/store_page/care_review_store_presence_selection_regression.json`, `completed=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_appeal_triage_evidence.log`, `checkCount=103`, `passedCheckCount=103`, `localBlockerCount=0`.

### 2026-06-01 Store Presence 후보 스크린샷 A/B 증거 템플릿

- 외부 게이트 증거 템플릿 `Evidence/_templates/STORE_PRESENCE.md`에 후보 스크린샷 A/B 판정 섹션을 추가했다.
- 템플릿과 QA 카드는 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`, `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`, `SCREENSHOT_UPLOAD_SELECTION_KO.md`, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`를 Store Presence 입력 증거로 함께 요구한다.
- 증거 노트 필수 확인 필드는 `selected_upload_set`, `promoted_candidate`, `replacement_target`, `external_feedback_count`, `rollback_decision`이다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_ab_evidence_template.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_ab_evidence_template.log`, `checkCount=104`, `passedCheckCount=104`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `allPassed=true`, `checkCount=19`, `passedCheckCount=19`.

### 2026-06-01 외부 게이트 감사 트리아지 담당 화면 증거

- 외부 게이트 감사 Markdown `care_review_external_gate_audit.md`에 `트리아지 담당 화면 증거` 섹션을 추가했다.
- 섹션은 `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`, `owner_screen`, `owner_screen_evidence`, `성과 기록 / 캠페인 기록 / 상점 페이지`, `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`, `보정 후보 결과`를 한 눈에 보여준다.
- 외부 게이트 스모크 JSON에 `hasTriageOwnerScreenEvidenceMarkdownSummary` 필드를 추가했고, 릴리즈 후보 감사가 이 필드의 `true`를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_triage_owner_screen_summary.log`, `hasTriageOwnerScreenEvidenceMarkdownSummary=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_triage_owner_screen_summary.log`, `checkCount=104`, `passedCheckCount=104`, `localBlockerCount=0`.

### 2026-06-01 상점 제출안 보정 후보 결과 수동 확인 단계

- `Docs/Steam_상점페이지_제출안.md`의 출시 준비 순서에 `보정 후보 결과 확인` 단계를 추가했다.
- 새 단계는 Store Presence 수동 입력 직후 `STORE_PRESENCE_SELECTION_KO.md`의 `appeal_triage_qa_evidence`, `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `보정 후보 결과`와 `STORE_PRESENCE_QA_CARD_KO.md` 연결을 대조한다.
- Steamworks 제출안 사본 `Builds/Steamworks/v0.3.0/store_page/STORE_PAGE_SUBMISSION_DRAFT_KO.md`도 같은 순서를 포함한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_submission_appeal_triage_manual_step.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_submission_appeal_triage_manual_step.log`, `checkCount=104`, `passedCheckCount=104`, `localBlockerCount=0`.

### 2026-06-01 Store Presence 선택 manifest A/B 판정 요약

- `STORE_PRESENCE_SELECTION_KO.md`가 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`의 A/B 판정 결과를 함께 요약하도록 했다.
- 새 필드는 `screenshot_ab_test_source`, `screenshot_ab_test_ready`, `screenshot_ab_default_candidate`, `screenshot_ab_comparison_candidate`, `screenshot_ab_recommended_candidate`, `screenshot_ab_recommendation_reason`이다.
- Store Presence 선택 회귀에 `abSummaryReady`를 추가해 현재 기본 후보 `12_career_record_next_objective.png` 유지 상태가 manifest에 기록되는지 검증한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_ab_selection_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_ab_selection_summary.log`, `checkCount=104`, `passedCheckCount=104`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 감사 CSV 담당 화면 증거

- 외부 게이트 감사 CSV `care_review_external_gate_audit.csv`에 `owner_screen_evidence_summary` 열을 추가했다.
- `HUMAN_10_COMMERCIAL` 행은 `owner_screen=성과 기록 / 캠페인 기록 / 상점 페이지`, `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`, `보정 후보 결과`를 요약한다.
- 외부 게이트 스모크 JSON에 `hasTriageOwnerScreenEvidenceCsvSummary` 필드를 추가했고, 릴리즈 후보 감사가 이 필드의 `true`를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_triage_owner_screen_csv_summary.log`, `hasTriageOwnerScreenEvidenceCsvSummary=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_triage_owner_screen_csv_summary.log`, `checkCount=104`, `passedCheckCount=104`, `localBlockerCount=0`.

### 2026-06-01 Steam 제출 전 자체점검 보정 후보 결과 항목

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`에 `상점 보정 후보 결과 수동 확인 단계` 체크를 별도로 추가했다.
- 체크는 `STORE_PAGE_SUBMISSION_DRAFT_KO.md`의 `보정 후보 결과 확인`, `appeal_triage_qa_evidence`, `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `STORE_PRESENCE_QA_CARD_KO.md`를 요구한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 보정 후보 결과 항목`을 추가했다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_preflight_appeal_triage_manual_check.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_appeal_triage_manual_check.log`, `checkCount=105`, `passedCheckCount=105`, `localBlockerCount=0`.

### 2026-06-01 Store Presence QA 카드 A/B 추천 후보 일치

- `STORE_PRESENCE_QA_CARD_KO.md`의 준비 단계에 `A/B 추천 후보 일치` 체크를 추가했다.
- 이 체크는 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`의 `recommended_candidate`와 `STORE_PRESENCE_SELECTION_KO.md`의 `screenshot_ab_recommended_candidate`가 모두 `12_career_record_next_objective.png`인지 대조한다.
- handoff 폴더, Steamworks 루트, handoff zip의 QA 카드 무결성 조건도 `recommended_candidate`, `screenshot_ab_recommended_candidate`, `A/B 추천 후보 일치`를 요구한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_qa_card_ab_match.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_qa_card_ab_match.log`, `checkCount=106`, `passedCheckCount=106`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=19`, `passedCheckCount=19`.

### 2026-06-01 외부 게이트 감사 JSON 담당 화면 증거

- 외부 게이트 감사 JSON `care_review_external_gate_audit_summary.json`의 행 데이터에 `ownerScreenEvidenceSummary`가 들어간다.
- `HUMAN_10_COMMERCIAL` 행은 `owner_screen=성과 기록 / 캠페인 기록 / 상점 페이지`, `appealTriageQueueReturnOpensCareerRecord=true`, `achievementCardMentionsAppealTriageResult=true`, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256`, `보정 후보 결과`를 포함한다.
- 외부 게이트 스모크 JSON에 `hasTriageOwnerScreenEvidenceJsonSummary` 필드를 추가했고, 릴리즈 후보 감사가 이 필드의 `true`를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_triage_owner_screen_json_summary.log`, `hasTriageOwnerScreenEvidenceJsonSummary=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_triage_owner_screen_json_summary.log`, `checkCount=106`, `passedCheckCount=106`, `localBlockerCount=0`.

### 2026-06-01 릴리즈 후보 감사 Store Presence 증거 묶음

- 릴리즈 후보 감사 Markdown `care_review_release_candidate_audit.md`에 `보정 후보 / Store Presence 증거 묶음` 섹션을 추가했다.
- 섹션은 `상점 Store Presence 통합 선택 manifest`, `상점 Store Presence 통합 선택 회귀`, `Store Presence QA 카드 A/B 추천 후보 일치 체크`, `Steam 제출 전 자체점검 보정 후보 결과 항목`, `외부 게이트 증거 감사 산출물`, `외부 검증 핸드오프 패킷`을 별도 표로 요약한다.
- 이 묶음은 Store Presence 수동 입력 전에 `보정 후보 결과`, A/B 추천 후보, handoff 카드, 외부 게이트 감사가 같은 후보 근거를 가리키는지 빠르게 확인하기 위한 섹션이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_evidence_bundle_markdown.log`, `checkCount=106`, `passedCheckCount=106`, `localBlockerCount=0`.

### 2026-06-01 Store Presence QA 카드 보정 후보 자체점검 일치

- `STORE_PRESENCE_QA_CARD_KO.md`에 `보정 후보 결과 / 자체점검 일치` 체크를 추가했다.
- 체크는 `STORE_PAGE_SUBMISSION_DRAFT_KO.md`의 `보정 후보 결과 확인`, `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `상점 보정 후보 결과 수동 확인 단계`, `STORE_PRESENCE_SELECTION_KO.md`의 `appeal_triage_qa_evidence`가 같은 Store Presence 검수 흐름인지 확인한다.
- handoff 폴더, Steamworks 루트, handoff zip의 QA 카드 무결성 조건도 이 체크 문구를 요구한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_store_presence_qa_card_triage_preflight_match.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_qa_card_triage_preflight_match.log`, `checkCount=107`, `passedCheckCount=107`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=19`, `passedCheckCount=19`.

### 2026-06-01 외부 handoff README Store Presence 증거 순서

- 외부 handoff README `README_KO.txt`에 `Store Presence/A-B/보정 후보 증거 작성 순서`를 추가했다.
- 순서는 `STORE_PRESENCE_QA_CARD_KO.md` 확인, A/B 추천 후보 일치 확인, 보정 후보 결과/자체점검 일치 대조, `STORE_CANDIDATE_CAPTURE_SYNC_HASHES.sha256` 후보 캡처 해시 확인, `Evidence/STORE_PRESENCE.md` 증거 기록이다.
- handoff 폴더, Steamworks 루트, handoff zip 내부 README가 같은 순서를 포함하도록 배포 무결성 감사를 강화했다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_handoff_readme_store_presence_evidence_order.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_readme_store_presence_evidence_order.log`, `checkCount=108`, `passedCheckCount=108`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=21`, `passedCheckCount=21`.

### 2026-06-01 릴리즈 후보 감사 JSON Store Presence 증거 묶음

- 릴리즈 후보 감사 JSON `care_review_release_candidate_audit.json`에 `storePresenceEvidenceBundle` 객체를 추가했다.
- 객체는 Store Presence/보정 후보 증거 체크를 `checkCount`, `passedCheckCount`, `allPassed`, 개별 label/evidence로 구조화한다.
- 현재 묶음은 Store Presence 선택 manifest/회귀, QA 카드 A/B 추천 후보 일치, 제출 전 자체점검 보정 후보 항목, QA 카드 보정 후보 자체점검 일치, 외부 게이트 감사, 외부 handoff 패킷, handoff README 증거 순서, 외부 게이트 Store Presence README 역참조 템플릿을 포함한다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_readme_template_link.log`, `checkCount=110`, `passedCheckCount=110`, `localBlockerCount=0`, `storePresenceEvidenceBundle.allPassed=true`, `storePresenceEvidenceBundle.checkCount=9`.

### 2026-06-01 Steamworks README Store Presence 검수 순서

- `README_STEAMWORKS_KR.txt`에 `Store Presence 검수 순서`를 추가했다.
- 순서는 `STORE_PRESENCE_QA_CARD_KO.md`에서 A/B 추천 후보 일치와 보정 후보 결과/자체점검 일치를 먼저 확인하고, `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `상점 보정 후보 결과 수동 확인 단계` 체크 뒤 Store Presence 입력으로 넘어가도록 안내한다.
- 이어서 `store_page/STORE_PRESENCE_SELECTION_KO.md`의 `store_presence_ready_for_manual_input: yes`, `screenshot_ab_recommended_candidate`, `appeal_triage_qa_evidence`와 외부 handoff `README_KO.txt`의 증거 작성 순서를 대조한다.
- Steamworks depot 갱신: `Logs/prepare_steamworks_readme_store_presence_preflight_order.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_steamworks_readme_store_presence_preflight_order.log`, `checkCount=109`, `passedCheckCount=109`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 Store Presence README 역참조 템플릿

- 외부 게이트 증거 템플릿 `Evidence/_templates/STORE_PRESENCE.md`에 `README_KO.txt`의 `Store Presence/A-B/보정 후보 증거 작성 순서` 역참조를 추가했다.
- 템플릿은 `STORE_PRESENCE_QA_CARD_KO.md`의 `A/B 추천 후보 일치`, `보정 후보 결과 / 자체점검 일치`를 선확인하고, 실제 증거를 `Evidence/STORE_PRESENCE.md`에 남기도록 안내한다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceReadmeEvidenceOrderTemplateLink`를 추가했고, 릴리즈 후보 감사와 배포 무결성이 handoff 폴더/zip 내부 템플릿 역참조를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_store_presence_readme_template_link.log`, `hasStorePresenceReadmeEvidenceOrderTemplateLink=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_readme_template_link.log`, `checkCount=110`, `passedCheckCount=110`, `localBlockerCount=0`, `storePresenceEvidenceBundle.checkCount=9`, `storePresenceEvidenceBundle.allPassed=true`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=23`, `passedCheckCount=23`.

### 2026-06-01 릴리즈 후보 감사 CSV Store Presence 증거 묶음

- 릴리즈 후보 감사 CSV `care_review_release_candidate_audit.csv`에 `store_presence_bundle_member`, `store_presence_bundle_summary` 열을 추가했다.
- Store Presence/보정 후보 증거 묶음에 속한 체크는 CSV 행에서 `store_presence_bundle_member=true`로 표시된다.
- CSV 마지막에는 `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY` 행을 추가해 `checkCount=9; passedCheckCount=9; allPassed=true`를 한 줄로 확인할 수 있게 했다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 CSV Store Presence 증거 묶음` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_bundle_csv_summary.log`, `checkCount=111`, `passedCheckCount=111`, `localBlockerCount=0`.

### 2026-06-01 Steamworks 릴리즈 후보 감사 노트 Store Presence 증거 묶음

- Steamworks 루트 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`에 `보정 후보 / Store Presence 증거 묶음` 섹션을 추가했다.
- 노트는 JSON `storePresenceEvidenceBundle`, CSV `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, handoff `README_KO.txt`의 Store Presence/A-B/보정 후보 증거 작성 순서를 함께 요약한다.
- 릴리즈 후보 감사에 `Steamworks 릴리즈 후보 감사 노트 Store Presence 증거 묶음` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_bundle_audit_note.log`, `checkCount=112`, `passedCheckCount=112`, `localBlockerCount=0`.

### 2026-06-01 Steam 제출 전 자체점검 Store Presence 증거 묶음 항목

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 외부 검증 핸드오프 섹션에 `외부 검증 Store Presence 증거 묶음 요약` 체크를 추가했다.
- 체크는 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `care_review_release_candidate_audit.csv`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 함께 요구한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 Store Presence 증거 묶음 항목` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_store_presence_bundle_summary.log`, `checkCount=113`, `passedCheckCount=113`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 Store Presence 증거 예시 노트

- 외부 게이트 증거 폴더에 `STORE_PRESENCE_EXAMPLE.md`를 추가했다.
- 예시 노트는 `status: example_not_evidence`와 `통과 증거가 아니다`를 명시해 실제 게이트 통과 파일 `STORE_PRESENCE.md`와 구분한다.
- 예시는 handoff README 순서, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, QA 카드 선확인, `selected_upload_set`, `promoted_candidate`, Steamworks URL/화면 캡처 기록 위치를 보여준다.
- 릴리즈 후보 감사에 `외부 게이트 Store Presence 증거 예시 노트` 체크를 추가했고, 배포 무결성은 handoff 폴더/zip 내부 예시 노트를 검증한다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_evidence_example.log`, `checkCount=114`, `passedCheckCount=114`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=25`, `passedCheckCount=25`.

### 2026-06-01 외부 handoff Store Presence 증거 묶음 표

- 외부 handoff 문서 `EXTERNAL_RELEASE_HANDOFF_KO.md`에 `Store Presence 증거 묶음` 표를 추가했다.
- 표는 `checkCount=9`, `passedCheckCount=9`, `allPassed=true`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `Evidence/STORE_PRESENCE_EXAMPLE.md`를 한 화면에 보여준다.
- handoff 폴더, Steamworks 사본, handoff zip 내부 `EXTERNAL_RELEASE_HANDOFF_KO.md`가 같은 섹션을 포함하도록 배포 무결성 감사를 강화했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_store_presence_bundle_table.log`, `checkCount=115`, `passedCheckCount=115`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=27`, `passedCheckCount=27`.

### 2026-06-01 외부 게이트 감사 Markdown Store Presence 증거 묶음

- 외부 게이트 감사 Markdown `care_review_external_gate_audit.md`에 `Store Presence 증거 묶음` 섹션을 추가했다.
- 섹션은 외부 handoff 문서와 같은 9개 Store Presence 증거 체크, `checkCount=9`, `passedCheckCount=9`, `allPassed=true`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 보여준다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceEvidenceBundleMarkdownSummary`를 추가했고 릴리즈 후보 감사가 이 필드를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_store_presence_bundle_markdown_summary.log`, `hasStorePresenceEvidenceBundleMarkdownSummary=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_store_presence_bundle_markdown_summary.log`, `checkCount=115`, `passedCheckCount=115`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 Evidence README Store Presence 예시 링크

- 외부 게이트 증거 README `Evidence/README_KO.md`에 `Store Presence 증거 작성` 섹션을 추가했다.
- 섹션은 `STORE_PRESENCE_EXAMPLE.md`, 실제 증거 파일 `STORE_PRESENCE.md`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `selected_upload_set`, `promoted_candidate`를 직접 안내한다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceExampleReadmeLink`를 추가했고, 릴리즈 후보 감사가 외부 게이트 산출물 조건에서 이 필드를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_store_presence_example_readme_link.log`, `hasStorePresenceExampleReadmeLink=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_example_readme_link.log`, `checkCount=115`, `passedCheckCount=115`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=29`, `passedCheckCount=29`.

### 2026-06-01 외부 게이트 감사 CSV/JSON Store Presence 증거 묶음

- 외부 게이트 감사 CSV에 `store_presence_evidence_bundle_summary` 열을 추가했다.
- 외부 게이트 감사 JSON에 `storePresenceEvidenceBundleSummary` 필드를 추가했다.
- 두 요약은 `checkCount=9; passedCheckCount=9; allPassed=true; csv=STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY; example=STORE_PRESENCE_EXAMPLE.md`를 기록한다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceEvidenceBundleCsvSummary`, `hasStorePresenceEvidenceBundleJsonSummary`를 추가했고, 릴리즈 후보 감사가 두 필드를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_store_presence_bundle_csv_json_summary.log`, `hasStorePresenceEvidenceBundleCsvSummary=true`, `hasStorePresenceEvidenceBundleJsonSummary=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_store_presence_bundle_csv_json_summary.log`, `checkCount=115`, `passedCheckCount=115`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 Store Presence 실제 증거 초안

- 외부 게이트 증거 생성기에 `STORE_PRESENCE.md` 실제 증거 초안을 추가했다.
- 초안은 `status: draft_not_evidence`, Steamworks URL/화면 캡처, `STORE_PRESENCE_EXAMPLE.md`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `selected_upload_set`, `promoted_candidate`, A/B 판정, 보정 후보 결과/자체점검 일치 TODO를 포함한다.
- 이미 작성 중인 실제 증거 파일은 덮어쓰지 않고, 초안 상태 파일만 다시 생성한다.
- 외부 게이트 감사에서 `STORE_PRESENCE` 행은 `statusPassed=false`, `requiredTokensPresent=true`, `pending_external`로 남는다. 즉 초안은 작성 편의용이고 실제 Steamworks 입력 증거 통과 처리는 아니다.
- 외부 게이트 감사: `Logs/audit_external_gate_store_presence_draft_note.log`, `hasStorePresenceDraftEvidenceNote=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_draft_note.log`, `checkCount=116`, `passedCheckCount=116`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=31`, `passedCheckCount=31`.

### 2026-06-01 Steam 제출 전 자체점검 최상단 Store Presence 증거 묶음 요약

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 상단에 `최상단 판정 요약` 섹션을 추가했다.
- 요약은 로컬 릴리즈 후보 상태, Steam 공개 출시 외부 액션 상태, `Store Presence 증거 묶음`의 `checkCount=9`, `passedCheckCount=9`, `allPassed=true`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 먼저 보여준다.
- 같은 섹션에서 실제 Store Presence 입력 증거는 `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`로 표시해 증거 묶음 준비와 실제 Steamworks 입력 완료를 혼동하지 않게 했다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 최상단 Store Presence 증거 묶음 요약` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_store_presence_top_summary.log`, `checkCount=117`, `passedCheckCount=117`, `localBlockerCount=0`.

### 2026-06-01 Steamworks README 첫 섹션 Store Presence 증거 묶음 요약

- `README_STEAMWORKS_KR.txt` 첫 섹션에 `Store Presence 증거 묶음 상태`를 추가했다.
- README를 열자마자 `allPassed`, `checkCount=9`, `passedCheckCount=9`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 확인할 수 있다.
- 실제 입력 증거는 같은 섹션에서 `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`로 표시해 Steamworks 웹 입력이 아직 외부 작업임을 분리했다.
- Steamworks README 재생성: `Logs/prepare_steamworks_readme_store_presence_top_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_steamworks_readme_store_presence_top_summary.log`, `checkCount=118`, `passedCheckCount=118`, `localBlockerCount=0`.

### 2026-06-01 Steamworks README Store Presence 증거 초안/예시 검수 순서

- `README_STEAMWORKS_KR.txt`의 `Store Presence 검수 순서`에 외부 게이트 증거 노트 대조 단계를 추가했다.
- 순서는 `Evidence/STORE_PRESENCE_EXAMPLE.md`의 `status: example_not_evidence` 예시와 `Evidence/STORE_PRESENCE.md`의 `status: draft_not_evidence` 초안을 먼저 대조한다.
- 실제 Steamworks URL/화면 캡처를 초안에 채운 뒤 마지막에만 status 값을 passed로 바꾸도록 README에 명시했다.
- Steamworks README 재생성: `Logs/prepare_steamworks_readme_store_presence_draft_example_order.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_steamworks_readme_store_presence_draft_example_order.log`, `checkCount=119`, `passedCheckCount=119`, `localBlockerCount=0`.

### 2026-06-01 외부 handoff README Store Presence 초안 첫 확인 항목

- 외부 handoff `README_KO.txt` 첫 부분에 `첫 확인 항목` 섹션을 추가했다.
- 섹션은 Store Presence 증거 초안 `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`, 예시 노트 `Evidence/STORE_PRESENCE_EXAMPLE.md`, `status: example_not_evidence`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 먼저 보여준다.
- handoff 폴더, Steamworks 사본, handoff zip 내부 `README_KO.txt`까지 같은 섹션을 포함하도록 배포 무결성 감사를 강화했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_readme_store_presence_draft_first_check.log`, `checkCount=120`, `passedCheckCount=120`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=33`, `passedCheckCount=33`.

### 2026-06-01 Steamworks upload manifest Store Presence 증거 초안 상태

- `STEAMWORKS_UPLOAD_MANIFEST.txt`에 Store Presence 증거 묶음과 실제 증거 초안 상태를 추가했다.
- manifest는 `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `checkCount=9`, `passedCheckCount=9`, `allPassed=true`를 기록한다.
- 실제 증거 초안은 `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`, `pending_external`, 예시 `Evidence/STORE_PRESENCE_EXAMPLE.md`로 표시한다.
- Steamworks manifest 재생성: `Logs/prepare_steamworks_upload_manifest_store_presence_draft_status.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_store_presence_draft_status.log`, `checkCount=121`, `passedCheckCount=121`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 tracker CSV Store Presence 증거 초안 힌트

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`에 `evidence_hint` 열을 추가했다.
- `STORE_PRESENCE` 행은 `draft=Evidence/STORE_PRESENCE.md`, `draft_status=status: draft_not_evidence`, `example=Evidence/STORE_PRESENCE_EXAMPLE.md`, `bundle=STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `actual_status=pending_external`를 별도 힌트로 기록한다.
- handoff 폴더, Steamworks 사본, handoff zip 내부 tracker CSV가 같은 힌트를 포함하도록 릴리즈 감사와 배포 무결성 감사를 강화했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_tracker_store_presence_draft_hint.log`, `checkCount=122`, `passedCheckCount=122`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=35`, `passedCheckCount=35`.

### 2026-06-01 릴리즈 후보 감사 Markdown Store Presence 증거 초안 상태

- 릴리즈 후보 감사 Markdown `care_review_release_candidate_audit.md` 최신 판정 아래에 `Store Presence 실제 증거 초안 상태` 섹션을 추가했다.
- 섹션은 `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`, `pending_external`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `evidence_hint`, `actual_status=pending_external`를 요약한다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 Markdown Store Presence 증거 초안 상태` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_markdown_store_presence_draft_status.log`, `checkCount=123`, `passedCheckCount=123`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 감사 Markdown Store Presence Draft 표 열

- 외부 게이트 감사 Markdown `care_review_external_gate_audit.md`의 `게이트별 판정` 표에 `Store Presence Draft` 열을 추가했다.
- `STORE_PRESENCE` 행은 `draft=Evidence/STORE_PRESENCE.md`, `draft_status=status: draft_not_evidence`, `example=Evidence/STORE_PRESENCE_EXAMPLE.md`, `bundle=STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `actual_status=pending_external`를 표 안에서 직접 보여준다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceDraftStatusMarkdownTable`을 추가했고, 릴리즈 후보 감사의 외부 게이트 산출물 조건이 이 필드를 요구한다.
- 외부 게이트 감사: `Logs/audit_external_gate_markdown_store_presence_draft_status_table.log`, `hasStorePresenceDraftStatusMarkdownTable=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_markdown_store_presence_draft_status_table.log`, `checkCount=123`, `passedCheckCount=123`, `localBlockerCount=0`.

### 2026-06-01 Steam 제출 전 자체점검 Store Presence 증거 초안 상태 항목

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 핸드오프` 섹션에 `외부 검증 Store Presence 증거 초안 상태` 체크를 별도로 추가했다.
- 이 체크는 외부 handoff README의 `첫 확인 항목`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `evidence_hint`, Steamworks README의 `Store Presence 증거 묶음 상태`를 함께 대조한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 Store Presence 증거 초안 상태 항목` 체크를 추가해 `status: draft_not_evidence`, `pending_external`, `Evidence/STORE_PRESENCE.md`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`가 제출 전 자체점검에 노출되는지 검증한다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_store_presence_draft_status_external_section.log`, `checkCount=124`, `passedCheckCount=124`, `localBlockerCount=0`.

### 2026-06-01 외부 handoff 문서 Store Presence 증거 초안 최상단 요약

- `EXTERNAL_RELEASE_HANDOFF_KO.md` 최상단에 `Store Presence 증거 초안 상태` 섹션을 추가했다.
- 섹션은 `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `status: example_not_evidence`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 먼저 보여준다.
- handoff 폴더, Steamworks 사본, handoff zip 내부 `EXTERNAL_RELEASE_HANDOFF_KO.md`가 같은 최상단 요약을 포함하도록 릴리즈 감사와 배포 무결성 감사를 강화했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_store_presence_draft_top_summary.log`, `checkCount=125`, `passedCheckCount=125`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=37`, `passedCheckCount=37`.

### 2026-06-01 외부 게이트 감사 CSV/JSON Store Presence Draft row 필드

- 외부 게이트 감사 CSV에 `store_presence_draft_status_summary` 열을 추가했다.
- 외부 게이트 감사 JSON은 기존 row의 `storePresenceDraftStatusSummary`를 스모크와 릴리즈 감사 조건으로 직접 검증하게 했다.
- `STORE_PRESENCE` row는 `draft=Evidence/STORE_PRESENCE.md`, `draft_status=status: draft_not_evidence`, `example=Evidence/STORE_PRESENCE_EXAMPLE.md`, `bundle=STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`, `actual_status=pending_external`를 CSV/JSON 모두에 기록한다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceDraftStatusCsvRow`, `hasStorePresenceDraftStatusJsonRow`를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_draft_status_csv_json_row.log`, `checkCount=126`, `passedCheckCount=126`, `localBlockerCount=0`.

### 2026-06-01 Steamworks 릴리즈 후보 감사 노트 Store Presence 증거 초안 상태

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`에 `Store Presence 실제 증거 초안 상태` 섹션을 추가했다.
- 섹션은 `pending_external`, `Evidence/STORE_PRESENCE.md`, `status: draft_not_evidence`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `status: example_not_evidence`, `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY`를 증거 묶음과 분리해 보여준다.
- 같은 섹션에서 외부 게이트 row 필드 `storePresenceDraftStatusSummary`, `store_presence_draft_status_summary`, `actual_status=pending_external`도 대조한다.
- 릴리즈 후보 감사에 `Steamworks 릴리즈 후보 감사 노트 Store Presence 증거 초안 상태` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_note_store_presence_draft_status.log`, `checkCount=127`, `passedCheckCount=127`, `localBlockerCount=0`.

### 2026-06-01 Steam 제출 전 자체점검 최상단 Store Presence 외부 액션 연결

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약에 `Store Presence 외부 액션 연결` 줄을 추가했다.
- 이 줄은 `STORE_PRESENCE`, `externalActionCount=10`, `actual_status=pending_external`, `storePresenceDraftStatusSummary`, `store_presence_draft_status_summary`, `draft=Evidence/STORE_PRESENCE.md`, `draft_status=status: draft_not_evidence`를 한 줄로 묶는다.
- Steam 공개 출시가 `not_ready_external_actions`인 이유와 Store Presence 실제 입력 증거가 초안 상태인 이유를 첫 화면에서 바로 연결한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 최상단 Store Presence 외부 액션 연결` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_store_presence_external_action_link.log`, `checkCount=128`, `passedCheckCount=128`, `localBlockerCount=0`.

### 2026-06-01 Steamworks 업로드 준비 문서 Store Presence Draft 독립 체크

- `Docs/Steamworks_업로드_준비.md`에 `Store Presence Draft 독립 체크` 섹션을 추가했다.
- 섹션은 증거 묶음 준비, 실제 입력 증거 `pending_external`, 초안 `Evidence/STORE_PRESENCE.md`/`status: draft_not_evidence`, 예시 `Evidence/STORE_PRESENCE_EXAMPLE.md`, 외부 게이트 row 필드, 제출 전 자체점검 연결을 분리해서 보여준다.
- 릴리즈 후보 감사에 `Steamworks 업로드 준비 문서 Store Presence Draft 독립 체크`를 추가했고, 배포 무결성의 사람용 업로드 문서 확인도 이 섹션을 요구한다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_steamworks_upload_doc_store_presence_draft_check.log`, `checkCount=129`, `passedCheckCount=129`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=37`, `passedCheckCount=37`.

### 2026-06-01 플레이테스트 QA 패킷 Store Presence Draft 독립 체크

- `Docs/플레이테스트_QA_패킷.md`에 `Store Presence Draft 독립 체크` 섹션을 추가했다.
- 이 섹션은 실제 사람 플레이테스트 회수 자료와 Store Presence 실제 입력 증거를 분리한다고 명시한다.
- 증거 묶음 준비, 실제 입력 증거 `pending_external`, 초안 `Evidence/STORE_PRESENCE.md`/`status: draft_not_evidence`, 외부 게이트 row 필드, 제출 전 자체점검 연결을 플레이테스트 배포 패킷에서도 확인한다.
- 릴리즈 후보 감사에 `플레이테스트 QA 패킷 Store Presence Draft 독립 체크`를 추가했고, 배포 무결성의 사람용 업로드 문서 확인도 이 섹션을 요구한다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_packet_store_presence_draft_check.log`, `checkCount=130`, `passedCheckCount=130`, `localBlockerCount=0`.
- 배포 무결성 감사: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=37`, `passedCheckCount=37`.

### 2026-06-01 Steamworks/외부 README Store Presence Draft 상호참조

- `README_STEAMWORKS_KR.txt`의 첫 `Store Presence 증거 묶음 상태` 섹션에 `handoff 첫 확인 대조` 줄을 추가했다.
- 외부 handoff `README_KO.txt`의 `첫 확인 항목`에는 `Steamworks README 첫 섹션 대조` 줄을 추가했다.
- 양쪽 README가 `Store Presence 증거 초안`, `status: draft_not_evidence`, `Store Presence 증거 묶음 상태`, `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약을 서로 가리킨다.
- Steamworks README 재생성: `Logs/prepare_steamworks_readme_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_store_presence_draft_cross_reference.log`, `checkCount=131`, `passedCheckCount=131`, `localBlockerCount=0`.

### 2026-06-01 Steamworks upload manifest/업로드 준비 문서 Store Presence Draft 상호참조

- `STEAMWORKS_UPLOAD_MANIFEST.txt`에 `Store Presence upload doc cross-check` 줄을 추가했다.
- `Docs/Steamworks_업로드_준비.md`의 `Store Presence Draft 독립 체크`에는 `upload manifest 상호참조` 항목을 추가했다.
- manifest와 사람용 업로드 준비 문서가 `Store Presence evidence draft`, `Store Presence Draft 독립 체크`, `actual_status=pending_external`를 서로 가리킨다.
- Steamworks manifest 재생성: `Logs/prepare_steamworks_upload_manifest_store_presence_doc_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_store_presence_doc_cross_reference.log`, `checkCount=132`, `passedCheckCount=132`, `localBlockerCount=0`.

### 2026-06-01 릴리즈 후보 감사 Markdown/Steamworks 노트 Store Presence Draft 상호참조

- 릴리즈 후보 감사 Markdown `care_review_release_candidate_audit.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 `Steamworks 감사 노트 상호참조` 줄을 추가했다.
- Steamworks 릴리즈 후보 감사 노트 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 같은 섹션에는 `릴리즈 후보 감사 Markdown 상호참조` 줄을 추가했다.
- 양쪽 문서가 `storePresenceDraftStatusSummary`, `tracker 힌트`, `status: draft_not_evidence`, `pending_external` 흐름을 서로 대조한다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 Markdown/Steamworks 노트 Store Presence Draft 상호참조` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_markdown_note_store_presence_draft_cross_reference.log`, `checkCount=133`, `passedCheckCount=133`, `localBlockerCount=0`.

### 2026-06-01 외부 게이트 tracker/감사 CSV JSON Store Presence Draft 상호참조

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `STORE_PRESENCE` evidence_hint에 외부 게이트 감사 CSV/JSON 역참조를 추가했다.
- tracker row는 `audit_csv=care_review_external_gate_audit.csv`, `audit_json=care_review_external_gate_audit_summary.json`, `audit_field=store_presence_draft_status_summary/storePresenceDraftStatusSummary`를 기록한다.
- 외부 게이트 감사 CSV/JSON의 `STORE_PRESENCE` row는 `tracker=EXTERNAL_RELEASE_GATE_TRACKER.csv`, `tracker_field=evidence_hint`를 기록해 tracker와 되돌아 대조된다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceDraftStatusTrackerAuditCrossReference`를 추가했다.
- 외부 게이트 감사: `Logs/audit_external_gate_tracker_audit_store_presence_draft_cross_reference.log`, `hasStorePresenceDraftStatusTrackerAuditCrossReference=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_tracker_audit_store_presence_draft_cross_reference.log`, `checkCount=134`, `passedCheckCount=134`, `localBlockerCount=0`.

### 2026-06-01 Steam 제출 전 자체점검/upload manifest Store Presence Draft 상호참조

- `STEAMWORKS_UPLOAD_MANIFEST.txt`에 `Store Presence preflight cross-check` 줄을 추가했다.
- upload manifest는 `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `외부 검증 Store Presence 증거 초안 상태`, `외부 검증 Store Presence 증거 초안/upload manifest 상호참조`를 직접 가리킨다.
- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 핸드오프` 섹션에는 `외부 검증 Store Presence 증거 초안/upload manifest 상호참조` 체크를 추가했다.
- Steamworks depot 재생성: `Logs/prepare_steamworks_preflight_upload_manifest_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_upload_manifest_store_presence_draft_cross_reference.log`, `checkCount=135`, `passedCheckCount=135`, `localBlockerCount=0`.

### 2026-06-01 Steamworks 업로드 준비/플레이테스트 QA 패킷 Store Presence Draft 상호참조

- `Docs/Steamworks_업로드_준비.md`의 `Store Presence Draft 독립 체크`에 `플레이테스트 QA 패킷 상호참조` 줄을 추가했다.
- `Docs/플레이테스트_QA_패킷.md`의 같은 섹션에는 `Steamworks 업로드 준비 문서 상호참조` 줄을 추가했다.
- 업로드 절차 문서와 플레이테스트 회수 문서가 Store Presence 실제 입력 증거와 플레이테스트 회수 자료를 분리한다는 조건을 서로 확인한다.
- 릴리즈 후보 감사에 `Steamworks 업로드 준비/플레이테스트 QA 패킷 Store Presence Draft 상호참조` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_doc_playtest_packet_store_presence_draft_cross_reference.log`, `checkCount=136`, `passedCheckCount=136`, `localBlockerCount=0`.

### 2026-06-01 Steamworks README/외부 handoff 최상단 Store Presence Draft 상호참조

- `README_STEAMWORKS_KR.txt` 첫 `Store Presence 증거 묶음 상태` 섹션에 `handoff 최상단 요약 대조` 줄을 추가했다.
- `EXTERNAL_RELEASE_HANDOFF_KO.md` 최상단 `Store Presence 증거 초안 상태` 섹션에는 `Steamworks README 첫 섹션 상호참조` 줄을 추가했다.
- Steamworks README, handoff 폴더 사본, Steamworks handoff 사본이 `pending_external`, `Store Presence 증거 초안 상태`, `Store Presence 증거 묶음 상태`를 서로 확인한다.
- Steamworks depot 재생성: `Logs/prepare_steamworks_readme_handoff_top_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_handoff_top_store_presence_draft_cross_reference.log`, `checkCount=137`, `passedCheckCount=137`, `localBlockerCount=0`.

### 2026-06-01 Steam 제출 전 자체점검 최상단/외부 게이트 스모크 Store Presence Draft 상호참조

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약에 `Store Presence 외부 게이트 스모크 상호참조` 줄을 추가했다.
- 이 줄은 `care_review_external_gate_audit_smoke_result.json`, `storePresencePreflightTopCrossReference`, `hasStorePresenceDraftStatusTrackerAuditCrossReference`를 첫 화면에서 직접 가리킨다.
- 외부 게이트 감사 스모크 JSON에는 `storePresencePreflightTopCrossReference`를 추가해 `STEAM_SUBMISSION_PREFLIGHT_KO.md; Store Presence 외부 액션 연결; externalActionCount=10`을 기록한다.
- 외부 게이트 감사: `Logs/audit_external_gate_preflight_top_store_presence_draft_cross_reference.log`.
- Steamworks depot 재생성: `Logs/prepare_steamworks_preflight_top_external_gate_smoke_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_top_external_gate_smoke_store_presence_draft_cross_reference.log`, `checkCount=138`, `passedCheckCount=138`, `localBlockerCount=0`.

### 2026-06-01 Steamworks 감사 노트/외부 게이트 스모크 Store Presence Draft 상호참조

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 `외부 게이트 스모크 상호참조` 줄을 추가했다.
- 이 줄은 `care_review_external_gate_audit_smoke_result.json`, `storePresenceAuditNoteCrossReference`, `hasStorePresenceDraftStatusJsonRow`를 감사 노트에서 직접 가리킨다.
- 외부 게이트 감사 스모크 JSON에는 `storePresenceAuditNoteCrossReference`를 추가해 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md; Store Presence 실제 증거 초안 상태; storePresenceDraftStatusSummary`를 기록한다.
- 외부 게이트 감사: `Logs/audit_external_gate_audit_note_store_presence_draft_cross_reference.log`.
- Steamworks depot 재생성: `Logs/prepare_steamworks_audit_note_external_gate_smoke_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_audit_note_external_gate_smoke_store_presence_draft_cross_reference.log`, `checkCount=139`, `passedCheckCount=139`, `localBlockerCount=0`.

### 2026-06-01 릴리즈 후보 감사 CSV/Steam 제출 전 자체점검 Store Presence Draft 상호참조

- 릴리즈 후보 감사 CSV의 `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY` row에 `preflight=STEAM_SUBMISSION_PREFLIGHT_KO.md`와 `preflight_check=외부 검증 Store Presence 증거 묶음 요약`을 추가했다.
- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 핸드오프` 섹션에는 `외부 검증 Store Presence release_candidate CSV 상호참조` 체크를 추가했다.
- CSV summary row와 제출 전 자체점검이 `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY` 준비 상태를 서로 확인한다.
- Steamworks depot 재생성: `Logs/prepare_steamworks_csv_preflight_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_csv_preflight_store_presence_draft_cross_reference.log`, `checkCount=140`, `passedCheckCount=140`, `localBlockerCount=0`.

### 2026-06-01 릴리즈 후보 감사 JSON/Steamworks upload manifest Store Presence Draft 상호참조

- 릴리즈 후보 감사 JSON의 `storePresenceEvidenceBundle` 객체에 `uploadManifestCrossReference` 필드를 추가했다.
- 이 필드는 `STEAMWORKS_UPLOAD_MANIFEST.txt; Store Presence release candidate JSON cross-check; Store Presence evidence bundle`를 기록한다.
- `STEAMWORKS_UPLOAD_MANIFEST.txt`에는 `Store Presence release candidate JSON cross-check` 줄을 추가해 `care_review_release_candidate_audit.json`, `storePresenceEvidenceBundle`, `uploadManifestCrossReference`를 역참조한다.
- Steamworks depot 재생성: `Logs/prepare_steamworks_json_upload_manifest_store_presence_draft_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_json_upload_manifest_store_presence_draft_cross_reference.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-01 캠페인 기록 액션 힌트 라인

- 캠페인 기록 하단 버튼 줄 위에 선택 회차 기준의 `액션 안내` 라인을 추가했다.
- 최근 회차에서는 `대표 AG-349 · 조사 AN-447 · 보정 없음 · 다음 목표 재시작`처럼 짧은 버튼이 실제로 어디로 이어지는지 먼저 보여 준다.
- 보정 목표 회차에서는 `보정 후보 C-031 · 다음 목표 보정 심사`까지 표시해 `후보 큐` 버튼과 다음 목표 재시작 의미를 더 명확히 했다.
- 캠페인 기록 스모크에 `careerRecordActionHintSummarizesButtons` 검증과 힌트 원문 JSON 출력을 추가했다.
- Windows 빌드 갱신: `Logs/build_windows_career_record_action_hint.log`, `Build Finished, Result: Success`.
- 캠페인 기록 스모크: `Logs/runtime_career_record_action_hint.log`, `completed=true`, `careerRecordActionHintSummarizesButtons=true`, `careerDetailUsesAggressiveLineWrap=true`, `careerDetailMaxDisplayLineWidth=63.7`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_action_hint.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-01 저해상도 캠페인 기록 액션 힌트 시각 QA

- 저해상도 UI 스모크에 캠페인 기록 화면 `career_record` 캡처를 추가했다.
- 1280x720, 1600x900, 1920x1080 각각 `10_career_record.png`를 생성해 캠페인 기록 하단 액션 힌트가 실제 화면에서 보이는지 확인한다.
- 스모크 결과 JSON에 `careerRecordActionHintReadable`과 `careerRecordActionHintMaxDisplayLineWidth`를 추가했다.
- QA 결과는 `screenshotCount=39`, `careerRecordActionHintReadable=true`, `careerRecordActionHintMaxDisplayLineWidth=57.1`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Windows 빌드 갱신: `Logs/build_low_resolution_career_record_action_hint.log`, `Build Finished, Result: Success`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_career_record_action_hint.log`, `completed=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_low_resolution_career_record_action_hint.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-01 성과 기록 보상 패널 기록 이동 힌트

- 성과 기록의 반복 보상 패널 앞부분에 `기록 이동: 하단 기록/2·4·6회 버튼은 캠페인 기록 필터로 이동` 문구를 추가했다.
- 반복/성장/후속/보정/비교 기록 버튼과 2/4/6회 단계 버튼이 캠페인 기록 필터로 이어진다는 점을 성과 화면에서 바로 설명한다.
- 성과 스모크에 `achievementReplayRewardPanelMentionsRecordLinkHint` 검증을 추가했다.
- Windows 빌드 갱신: `Logs/build_achievement_record_link_hint.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_record_link_hint.log`, `completed=true`, `achievementReplayRewardPanelMentionsRecordLinkHint=true`, `achievementCatalogCount=14`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_record_link_hint.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-01 저해상도 성과 기록 이동 힌트 시각 QA

- 성과 기록의 기록 이동 안내를 긴 반복 보상 문장 안에서 별도 짧은 힌트 라인으로 분리했다.
- `achievementRecordLinkHintReadable`, `achievementRecordLinkHintMaxDisplayLineWidth`를 성과 스모크와 저해상도 UI 스모크 결과에 추가했다.
- 저해상도 UI 스모크가 `achievements` 화면을 1280x720/1600x900/1920x1080에서 추가 캡처하도록 확장했다.
- Windows 빌드 갱신: `Logs/build_low_resolution_achievement_record_link_hint.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_record_link_hint_visible.log`, `completed=true`, `achievementRecordLinkHintReadable=true`, `achievementRecordLinkHintMaxDisplayLineWidth=49.4`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_achievement_record_link_hint.log`, `completed=true`, `screenshotCount=42`, `screen=achievements` 3장, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_low_resolution_achievement_record_link_hint.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-02 상점 후보 UI 힌트 manifest 연결

- 상점 후보 캡처 manifest가 `10_achievement_next_goal.png`의 성과 기록 이동 힌트와 `08/12` 캠페인 기록 액션 힌트 판독성 증거를 직접 기록하도록 확장했다.
- `STORE_CANDIDATE_CAPTURE_SYNC_MANIFEST.md`에 `achievement record link hint visual check`, `career record action hint visual check` 필수 QA 토큰을 추가했다.
- 마케팅 자산 감사에 `storeCandidateUiHintVisualChecked`를 추가해 상점 후보 이미지 manifest가 인게임 힌트 판독성 QA와 연결되는지 검증한다.
- Windows 빌드 갱신: `Logs/build_store_candidate_ui_hint_manifest.log`, `Build Finished, Result: Success`.
- 캡처 동기화: `Logs/runtime_store_candidate_graphics_capture_sync.log`, `CARE_REVIEW_STORE_SCREENSHOTS_DONE`, Marketing/Steamworks source manifest와 SHA manifest 갱신.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_store_candidate_ui_hint_manifest.log`, `48/48`, `storeCandidateUiHintVisualChecked=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_ui_hint_manifest.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-02 성과 화면 장기 루프 상태줄

- 성과 기록 상태줄에 `성과 루프: 목표 실행 -> 캠페인 기록 -> 2/4/6 보상 누적`을 추가했다.
- 다음 성과 목표가 단발 버튼이 아니라 캠페인 기록과 반복 보상 단계로 이어진다는 점을 성과 화면 상단에서 바로 읽을 수 있게 했다.
- 성과 스모크에 `achievementStatusMentionsRewardLoop`를 추가했고, 릴리즈 감사의 성과 기록 반복 장식 QA도 이 필드를 요구한다.
- 상점 후보 manifest의 `10_achievement_next_goal.png` 설명에 `achievement reward loop summary`를 추가했다.
- Windows 빌드 갱신: `Logs/build_achievement_reward_loop_status.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_reward_loop_status.log`, `completed=true`, `achievementStatusMentionsRewardLoop=true`.
- 캡처 동기화: `Logs/write_store_candidate_capture_sync_reward_loop_wait.log`, `Logs/runtime_store_candidate_graphics_capture_sync.log`, `achievement reward loop summary`.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_achievement_reward_loop_status.log`, `checkCount=48`, `passedCheckCount=48`, `storeCandidateUiHintVisualChecked=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_reward_loop_status.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-02 성과 해금 토스트 기록 루프 안내

- 성과 해금 토스트 본문에 `성과 기록에서 다음 목표와 기록 보상 확인` 안내를 추가했다.
- 첫 해금 순간에 플레이어가 성과 기록 화면으로 이동해 다음 목표와 장기 보상 구조를 확인해야 한다는 연결을 놓치지 않게 했다.
- 토스트 본문 영역을 3줄 안내에 맞춰 12pt/58px로 조정했다.
- 성과 스모크에 `achievementToastMentionsRecordLoop`와 `achievementToastBody` 검증을 추가했고, 릴리즈 감사의 성과 기록 반복 장식 QA도 이 필드를 요구한다.
- Windows 빌드 갱신: `Logs/build_achievement_toast_record_loop.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_toast_record_loop.log`, `completed=true`, `achievementToastMentionsRecordLoop=true`.
- 그래픽 성과 스모크: `Logs/runtime_achievement_toast_record_loop_visual.log`, `completed=true`, `toastScreenshotCaptured=true`, `screenshotCaptured=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_toast_record_loop.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-02 플레이테스트 상용화 보강 체크리스트

- 인게임 플레이테스트 설문 화면 오른쪽에 `상용화 보강 체크` 패널을 추가했다.
- 패널은 성과 기록의 다음 목표/2·4·6 보상, 캠페인 기록의 필터/장기 추세/액션 안내, 상점 후보 10/12번 장면, `다시 할 이유` 질문을 한 화면에서 묶어 보여준다.
- 플레이테스트 준비 스모크에 `commercialChecklistMentionsSurfaceActions`, `commercialChecklistReadable`, `commercialChecklistMaxDisplayLineWidth`를 추가했다.
- 저해상도 UI 스모크도 플레이테스트 설문 화면에서 `playtestSurveyCommercialChecklistReadable`과 최대 표시 폭을 검증한다.
- Windows 빌드 갱신: `Logs/build_playtest_commercial_checklist_mirror.log`, `Build Finished, Result: Success`.
- 플레이테스트 준비 스모크: `Logs/runtime_playtest_commercial_checklist_mirror.log`, `completed=true`, `commercialChecklistMentionsSurfaceActions=true`, `commercialChecklistReadable=true`, `commercialChecklistMaxDisplayLineWidth=30.2`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_playtest_commercial_checklist.log`, `completed=true`, `screenshotCount=42`, `playtestSurveyCommercialChecklistReadable=true`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_commercial_checklist.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-02 성과 장기 루프 포커스 순서

- 성과 기록 화면의 컨트롤러 내비게이션을 명시 순서로 고정했다.
- 상단은 `후보 전환 <-> 목표 실행`을 유지하면서 아래 방향 이동이 각각 `보정 기록`, `반복 기록`으로 이어지게 했다.
- 하단 기록 버튼군은 `반복 기록 -> 성장 기록 -> 후속 기록 -> 보정 기록 -> 비교 기록` 순서로 좌우 이동한다.
- 2/4/6 단계 버튼도 좌우 순서를 명시하고, 아래 방향이 관련 기록 버튼으로 돌아가게 했다.
- 포커스 스모크에 `achievementTopActionNavigationMatchesRewardLoop`, `achievementRecordButtonFocusOrderMatchesRewardLoop`, `achievementTierButtonFocusOrderMatchesRewardLoop`, `achievementLongLoopFocusOrder`를 추가했다.
- Windows 빌드 갱신: `Logs/build_achievement_long_loop_focus_order.log`, `Build Finished, Result: Success`.
- 포커스 이동 스모크: `Logs/runtime_focus_achievement_long_loop_order.log`, `completed=true`, `achievementTopActionNavigationMatchesRewardLoop=true`, `achievementRecordButtonFocusOrderMatchesRewardLoop=true`, `achievementTierButtonFocusOrderMatchesRewardLoop=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_long_loop_focus_order.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 다음 개발 단위

### 2026-06-02 성과 토스트 UI 캡처 증거

- 기존 성과 토스트 PNG 캡처가 배치 그래픽 환경에서 검은 프레임으로 저장될 수 있어, 별도 UI 캡처 산출물을 추가했다.
- 토스트 루트 활성 상태, 패널/띠/제목/본문 알파, Rect 위치/크기, 본문 텍스트, 최대 표시 폭을 JSON/Markdown으로 저장한다.
- 성과 스모크에 `achievementToastUiCaptureReady`, `achievementToastUiCaptureReadable`, `toastUiCaptureCaptured`를 추가했다.
- 릴리즈 감사는 `Builds/QA/v0.3.0/achievement_toast/care_review_achievement_toast_ui_capture.json`의 `ready/readable/rootActive/alphaReady`와 토스트 본문을 직접 요구한다.
- Windows 빌드 갱신: `Logs/build_achievement_toast_ui_capture.log`, `Build Finished, Result: Success`.
- 성과 기록 스모크: `Logs/runtime_achievement_toast_ui_capture.log`, `completed=true`, `achievementToastUiCaptureReady=true`, `achievementToastUiCaptureReadable=true`, `bodyMaxDisplayLineWidth=32.5`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_toast_ui_capture.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 다음 개발 단위

### 2026-06-02 트리아지 actions CSV 인게임 체크리스트 증거 연결

- 플레이테스트 설문 화면의 `상용화 보강 체크` 결과를 10달러 상용화 트리아지 actions CSV의 `owner_screen_evidence`에 직접 연결했다.
- 반복 보상/장기 기록 가치감 행이 `care_review_playtest_readiness_smoke_result.json: commercialChecklistMentionsSurfaceActions=true, commercialChecklistReadable=true`를 증거로 포함한다.
- 트리아지 JSON action에도 `ownerScreenEvidence` 필드를 추가해 CSV와 JSON이 같은 증거 문구를 갖게 했다.
- 트리아지 스모크에 `hasReadinessChecklistEvidence`를 추가하고, Markdown/HTML/Steamworks/handoff/zip 복사본까지 같은 증거를 요구하도록 강화했다.
- 회수 감사 재생성: `Logs/audit_playtest_collection_readiness_checklist_evidence.log`, `hasReadinessChecklistEvidence=true`, `hasAppealTriageOwnerScreenEvidence=true`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readiness_checklist_evidence.log`, `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv` 3개 경로와 handoff zip 내부에 `commercialChecklistReadable=true` 반영.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readiness_checklist_triage_actions.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`, 배포 무결성 `37/37`.

### 2026-06-02 상점 후보 성과-캠페인 루프 캡션

- 상점 후보 manifest의 `10_achievement_next_goal.png`와 `12_career_record_next_objective.png` 설명을 성과 기록의 목표 실행, 캠페인 기록 목표 재시작, 2/4/6 보상 누적이 같은 성과-캠페인 루프임을 드러내도록 보강했다.
- 상점 후보 승격 기준표의 `후보 결과 QA 증거`에 `성과-캠페인 루프 증거` 항목을 추가했다.
- 승격 기준표가 `achievementStatusMentionsRewardLoop`, `achievementRecordLinkHintReadable`, `achievementTopActionNavigationMatchesRewardLoop`, `achievementRecordButtonFocusOrderMatchesRewardLoop`, `careerRecordActionHintReadable`를 루프 증거로 직접 가리킨다.
- `Docs/Steam_상점페이지_제출안.md`의 QA 후보 스크린샷 설명도 `목표 실행 -> 캠페인 기록 -> 2/4/6 보상 누적`과 성과 기록 보상 누적 왕복 루프로 갱신했다.
- Steamworks 재생성: `Logs/prepare_steamworks_store_candidate_reward_loop_caption_fix.log`, `SCREENSHOT_CANDIDATES_KO.md`, `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`, `STORE_PAGE_SUBMISSION_DRAFT_KO.md` 동기화.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_reward_loop_caption_fix.log`, `checkCount=141`, `passedCheckCount=141`, `localBlockerCount=0`.

### 2026-06-02 성과 토스트 UI 캡처 handoff 증거 연결

- 성과 토스트 UI 캡처 Markdown을 외부 handoff 루트와 Steamworks 루트에 `ACHIEVEMENT_TOAST_UI_CAPTURE.md`로 복사하도록 연결했다.
- Store Presence QA 카드에 `ACHIEVEMENT_TOAST_UI_CAPTURE.md`, `ready: true`, `readable: true`, `성과 기록에서 다음 목표와 기록 보상 확인` 확인 단계를 추가했다.
- 외부 handoff README, `Evidence/STORE_PRESENCE.md`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `Evidence/README_KO.md`, Store Presence 템플릿이 모두 토스트 UI 캡처를 증거 노트 작성 전 확인하도록 갱신됐다.
- 배포 무결성 감사가 handoff 폴더와 handoff zip 내부 `v0.3.0/ACHIEVEMENT_TOAST_UI_CAPTURE.md` 포함 여부를 별도 검증한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_achievement_toast_handoff_evidence.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_toast_handoff_evidence.log`, `checkCount=142`, `passedCheckCount=142`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=39`, `passedCheckCount=39`.

### 2026-06-02 플레이테스트 패킷 인게임 체크리스트 안내 순서

- 플레이테스트 kit 안내문 3종에 최종 리포트 `테스터 설문` 화면의 `상용화 보강 체크` 패널 확인 순서를 추가했다.
- `README_KO.txt`, `PLAYTESTER_GUIDE_KO.md`, `COLLECTION_CHECKLIST_KO.md`가 성과 기록, 캠페인 기록, 상점 후보, 다시 할 이유 항목을 확인하라고 안내한다.
- 회수 체크리스트와 QA 패킷 문서가 `commercialChecklistMentionsSurfaceActions=true`, `commercialChecklistReadable=true` 스모크 증거를 직접 가리키도록 보강했다.
- 플레이테스트 kit zip을 갱신하고 SHA를 `C9A4F5E2C8429760BC2180BAB6AB8B3C85FE98895BA73D5A8CB4C7303B4ED0EB`로 정렬했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_packet_commercial_checklist_guide_fix.log`, `checkCount=142`, `passedCheckCount=142`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=41`, `passedCheckCount=41`.

### 2026-06-02 상점 후보 A/B 성과-캠페인 루프 이해도 질문

- `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`에 `성과-캠페인 루프 이해도 질문` 섹션을 추가했다.
- 질문은 `10_achievement_next_goal.png`와 `12_career_record_next_objective.png` 중 목표 실행 -> 캠페인 기록 -> 2/4/6 보상 누적 흐름이 더 빨리 이해되는 후보를 묻는다.
- 선택지는 `10_achievement_next_goal.png`, `12_career_record_next_objective.png`, `둘 다 이해됨`, `둘 다 불명확`으로 정리했다.
- 실제 플레이테스터 코멘트에 성과 기록, 캠페인 기록, 다음 목표 재시작, 보상 누적 중 2개 이상이 함께 언급되면 `루프 이해 코멘트`로 집계하는 기준을 추가했다.
- Steamworks 재생성: `Logs/prepare_steamworks_screenshot_ab_reward_loop_question.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_screenshot_ab_reward_loop_question.log`, `checkCount=142`, `passedCheckCount=142`, `localBlockerCount=0`.

### 2026-06-02 Store Presence 성과 토스트 UI 캡처 요약

- 외부 게이트 Store Presence 증거 묶음 요약이 성과 토스트 UI 캡처 JSON을 직접 요약하도록 보강했다.
- `care_review_external_gate_audit_summary.json`의 `storePresenceEvidenceBundleSummary`와 외부 게이트 CSV에는 `toastUiCaptureReady=true`, `toastUiCaptureReadable=true`, `toastUiCaptureBody=성과 기록에서 다음 목표와 기록 보상 확인`, `toastUiCaptureMaxLineWidth=32.5`가 함께 기록된다.
- 외부 게이트 감사 Markdown과 `EXTERNAL_RELEASE_HANDOFF_KO.md`에는 `성과 토스트 UI 캡처 요약` 줄을 추가해 Store Presence 실제 입력 전에 확인할 증거를 사람이 바로 볼 수 있게 했다.
- 외부 게이트 스모크 JSON에 `hasStorePresenceToastUiCaptureEvidenceSummary=true`를 추가했고, 릴리즈 후보 감사와 배포 무결성 감사가 handoff 폴더/zip 내부 요약 토큰까지 검증한다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_store_presence_toast_summary.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_toast_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_toast_summary.log`, `checkCount=142`, `passedCheckCount=142`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=41`, `passedCheckCount=41`.

### 2026-06-02 플레이테스트 집계 상용화 보강 체크 응답 요약

- 플레이테스트 세션 집계 Markdown에 `상용화 보강 체크 응답 요약` 섹션을 추가했다.
- 섹션은 최종 리포트 설문 화면의 체크 패널 기준인 `성과 기록 / 캠페인 기록 / 상점 후보 / 다시 할 이유`를 그대로 사용한다.
- 현재 QA 집계는 반복 보상/장기 기록 가치감 4점 이상 `10/16`세션, 10달러 가치감 4점 이상 `10/16`세션, 재플레이 의향 `10/16`세션, 후속 보강 필요 `6`세션으로 요약된다.
- `care_review_playtest_aggregate.json`에는 `commercialChecklistSurveyCount`, `commercialChecklistPriceValuePositiveCount`, `commercialChecklistReplayRewardPositiveCount`, `commercialChecklistReplayIntentPositiveCount`, `commercialChecklistFollowUpCount`, `commercialChecklistAggregateSummaryReady` 필드를 추가했다.
- 플레이테스트 집계 스모크는 `jsonHasCommercialChecklistAggregateSummary=true`, `markdownMentionsCommercialChecklistSummary=true`를 요구한다.
- Windows 빌드 갱신: `Logs/build_playtest_aggregate_commercial_checklist_summary.log`, `Build Finished, Result: Success`.
- 집계 스모크: `Logs/runtime_playtest_aggregate_commercial_checklist_summary.log`, `completed=true`, `sessionCount=209`, `surveySessionCount=16`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_playtest_aggregate_commercial_checklist_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_aggregate_commercial_checklist_summary.log`, `checkCount=142`, `passedCheckCount=142`, `localBlockerCount=0`.

### 2026-06-02 플레이테스트 요청/회수 인덱스 상점 후보 A/B 질문 컬럼

- 플레이테스트 요청 문구에 상점 후보 스크린샷 A/B 질문을 추가했다.
- 질문은 `10_achievement_next_goal.png`와 `12_career_record_next_objective.png` 중 `목표 실행 -> 캠페인 기록 -> 2/4/6 보상 누적` 흐름이 더 빨리 이해되는 쪽을 묻는다.
- `PLAYTEST_SESSION_INDEX_TEMPLATE.csv`에 `screenshot_ab_loop_question_id`, `screenshot_ab_loop_question_text`, `screenshot_ab_loop_preferred_candidate`, `screenshot_ab_loop_understanding_comment` 컬럼을 추가했다.
- 런타임 집계 CSV `care_review_playtest_sessions_index.csv`에도 같은 컬럼을 추가하고, 기존 세션에는 `reward_loop_understanding` 질문과 `not_collected` 기본값을 기록한다.
- 집계 스모크는 `csvHasScreenshotAbLoopQuestionColumns=true`를 요구한다.
- 플레이테스트 kit zip을 `75,374,601 bytes`, SHA256 `9C51E0F2475B7377D30EC7B21B7F9D856889CE730275A69551F996ED0EF72CF0`로 갱신했다.
- Windows 빌드 갱신: `Logs/build_playtest_screenshot_ab_loop_question_index.log`, `Build Finished, Result: Success`.
- 집계 스모크: `Logs/runtime_playtest_screenshot_ab_loop_question_index.log`, `completed=true`, `csvHasScreenshotAbLoopQuestionColumns=true`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_playtest_screenshot_ab_loop_question_index.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_screenshot_ab_loop_question_index.log`, `checkCount=142`, `passedCheckCount=142`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store Presence QA 카드 성과-캠페인 루프 A/B 질문 회수 체크

- `STORE_PRESENCE_QA_CARD_KO.md`에 `성과-캠페인 루프 A/B 질문 회수 체크` 단계를 추가했다.
- 체크는 `PLAYTEST_REQUEST_TEMPLATE_KO.md`, `PLAYTEST_SESSION_INDEX_TEMPLATE.csv`, `care_review_playtest_sessions_index.csv`가 같은 `screenshot_ab_loop_*` 축으로 연결되어 있는지 확인한다.
- 집계 스모크의 `csvHasScreenshotAbLoopQuestionColumns=true`를 QA 카드와 릴리즈 후보 감사에서 직접 대조한다.
- handoff 폴더, Steamworks 폴더, handoff zip 내부 Store Presence QA 카드가 모두 `screenshot_ab_loop_question_id`와 회수 체크 문구를 포함하도록 배포 무결성 조건을 보강했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_qa_card_ab_loop_collection_check.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_qa_card_ab_loop_collection_check.log`, `checkCount=143`, `passedCheckCount=143`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 플레이테스트 회수 감사 상용화 보강 체크 응답 요약 대조

- 플레이테스트 회수 감사 JSON/CSV/Markdown에 `상용화 보강 체크 응답 요약 대조` 항목을 추가했다.
- 회수 감사가 `care_review_playtest_aggregate.json`, `care_review_playtest_aggregate.md`, `care_review_playtest_aggregate_smoke_result.json`을 직접 대조해 `commercialChecklistAggregateSummaryCrossCheckReady=true`를 기록한다.
- 대조 항목은 회수 감사 설문 3세션과 집계 설문 18세션의 커버리지를 비교하고 `commercialChecklistAggregateCoversCollectionSurveys=true`를 기록한다.
- 반복 보상/장기 기록 가치감 4점 이상 `12/18`, 10달러 가치감 4점 이상 `12/18`, 재플레이 의향 `12/18`, 후속 보강 필요 `6`세션을 회수 감사에도 노출했다.
- 회수 감사 CSV에는 `commercial_checklist_aggregate_cross_check_ready`, `commercial_checklist_aggregate_covers_collection_surveys`, `commercial_checklist_aggregate_*_count` 열을 추가했다.
- 플레이테스트 회수 감사 재생성: `Logs/audit_playtest_collection_commercial_checklist_aggregate_cross_check.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_playtest_collection_commercial_checklist_aggregate_cross_check.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_collection_commercial_checklist_aggregate_cross_check.log`, `checkCount=144`, `passedCheckCount=144`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 플레이테스트 회수 감사 성과-캠페인 루프 A/B 응답 집계

- 플레이테스트 회수 감사 JSON/CSV/Markdown에 `성과-캠페인 루프 A/B 응답 집계` 항목을 추가했다.
- 회수 감사가 `care_review_playtest_sessions_index.csv`의 `screenshot_ab_loop_question_id`, `screenshot_ab_loop_preferred_candidate`, `screenshot_ab_loop_understanding_comment` 열을 직접 읽는다.
- 현재 집계는 질문 ID 행 `211`건, 응답 회수 `0`건, `not_collected` `211`건으로 실제 외부 회수 전 상태를 명확히 표시한다.
- 선호 후보 카운트는 `10_achievement_next_goal.png` `0`건, `12_career_record_next_objective.png` `0`건, 둘 다 이해됨 `0`건, 둘 다 불명확 `0`건이며 이해 코멘트도 `0`건이다.
- 회수 감사 CSV에는 `screenshot_ab_loop_aggregate_summary_ready`, `screenshot_ab_loop_question_id_count`, `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_*_preference_count` 열을 추가했다.
- 플레이테스트 회수 감사 재생성: `Logs/audit_playtest_collection_screenshot_ab_loop_response_summary.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_playtest_collection_screenshot_ab_loop_response_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_collection_screenshot_ab_loop_response_summary.log`, `checkCount=145`, `passedCheckCount=145`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store 후보 A/B 판정 manifest 성과-캠페인 루프 회수 집계 연결

- `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`가 회수 감사의 `screenshotAbLoop*` 집계 수치를 직접 읽도록 연결했다.
- manifest 상단에 `screenshot_ab_loop_summary_ready: yes`, `screenshot_ab_loop_question_rows: 211`, `screenshot_ab_loop_response_count: 0`, `screenshot_ab_loop_not_collected_count: 214`을 기록한다.
- 선호 후보 카운트와 이해 코멘트 카운트를 함께 기록해 `10_achievement_next_goal.png`와 `12_career_record_next_objective.png` 중 어느 후보가 성과-캠페인 루프를 더 빨리 설명하는지 외부 회수 후 바로 판정할 수 있게 했다.
- 현재 상태는 `screenshot_ab_loop_collection_status: waiting_for_screenshot_ab_loop_responses`로, 공식 후보 교체 전 외부 응답 회수가 필요하다는 보류 사유를 manifest 자체에 남긴다.
- Steamworks 재생성: `Logs/prepare_steamworks_store_candidate_ab_loop_response_counts.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_ab_loop_response_counts.log`, `checkCount=145`, `passedCheckCount=145`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store Presence QA 카드 A/B 응답 회수 수치

- `STORE_PRESENCE_QA_CARD_KO.md`가 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`의 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status`를 직접 요약하도록 연결했다.
- 현재 QA 카드는 `screenshot_ab_loop_response_count: 0`, `screenshot_ab_loop_not_collected_count: 214`, `screenshot_ab_loop_collection_status: waiting_for_screenshot_ab_loop_responses`를 Store Presence 입력 전 확인 항목으로 보여준다.
- 통과 기준에는 `A/B 응답 회수 수치와 승격 보류 사유`가 `waiting_for_screenshot_ab_loop_responses` 상태인지 확인하는 문장을 추가했다.
- handoff 폴더와 handoff zip 내부 Store Presence QA 카드 무결성 조건도 같은 응답 수치 토큰을 요구한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_qa_card_ab_loop_response_counts.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_qa_card_ab_loop_response_counts.log`, `checkCount=146`, `passedCheckCount=146`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 handoff tracker 성과-캠페인 루프 A/B 응답 회수 힌트

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `HUMAN_10_COMMERCIAL` 행이 `care_review_playtest_collection_audit_summary.json`을 evidence target에 포함하도록 보강했다.
- `next_action`에는 가격 가치감, 재플레이 의향과 함께 `screenshot_ab_loop_response_count`를 확인하라는 문구를 추가했다.
- `evidence_hint`에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`를 기록한다.
- handoff 폴더, Steamworks 폴더, handoff zip 내부 tracker 무결성 조건도 같은 A/B 회수 힌트를 요구한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_external_gate_tracker_ab_loop_response_hint.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_tracker_ab_loop_response_hint.log`, `checkCount=147`, `passedCheckCount=147`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 게이트 감사 성과-캠페인 루프 A/B 응답 회수 힌트 상호참조

- 외부 게이트 감사 CSV/JSON/Markdown이 `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `screenshot_ab_loop_response_count` 힌트를 대조하도록 보강했다.
- `HUMAN_10_COMMERCIAL` row에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`, `tracker=EXTERNAL_RELEASE_GATE_TRACKER.csv`, `tracker_field=evidence_hint`가 기록된다.
- 외부 게이트 감사 Markdown에는 `성과-캠페인 루프 A/B 응답 회수 힌트` 섹션을 추가했다.
- 외부 게이트 스모크에 `hasScreenshotAbLoopResponseTrackerAuditCrossReference=true`를 추가했고 릴리즈 후보 감사가 이를 요구한다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_ab_loop_response_tracker_cross_reference.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_external_gate_ab_loop_response_tracker_cross_reference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_ab_loop_response_tracker_cross_reference.log`, `checkCount=148`, `passedCheckCount=148`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steam 제출 전 자체점검 최상단 A/B 응답 회수 보류 상태

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `최상단 판정 요약`에 `성과-캠페인 루프 A/B 응답 회수 보류` 줄을 추가했다.
- 최상단에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- Store Presence 외부 게이트 스모크 상호참조 줄도 `hasScreenshotAbLoopResponseTrackerAuditCrossReference`를 함께 표시한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 최상단 성과-캠페인 루프 A/B 응답 회수 보류 상태` 체크를 추가했다.
- Steamworks 재생성: `Logs/prepare_steamworks_preflight_top_ab_loop_response_status.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_top_ab_loop_response_status.log`, `checkCount=149`, `passedCheckCount=149`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store Presence 증거 템플릿 A/B 응답 회수 입력란

- `Evidence/_templates/STORE_PRESENCE.md`에 A/B 응답 회수 수치 입력란을 추가했다.
- 템플릿의 확인 필드에는 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status`가 들어간다.
- `Evidence/STORE_PRESENCE_EXAMPLE.md`는 현재 보류 상태 예시로 `screenshot_ab_loop_response_count: 0`, `screenshot_ab_loop_not_collected_count: 214`, `screenshot_ab_loop_collection_status: waiting_for_screenshot_ab_loop_responses`를 보여준다.
- 실제 증거 초안 `Evidence/STORE_PRESENCE.md`에도 같은 3개 입력란을 `TODO` 상태로 생성해 Steamworks 입력 시 누락되지 않게 했다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_store_presence_template_ab_loop_response_fields.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_template_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_template_ab_loop_response_fields.log`, `checkCount=150`, `passedCheckCount=150`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks README 첫 확인 A/B 응답 회수 보류 상태

- `README_STEAMWORKS_KR.txt` 첫 섹션 `Store Presence 증거 묶음 상태`에 A/B 응답 회수 보류 줄을 추가했다.
- 첫 확인 항목에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- Steam 제출 전 자체점검의 최상단 보류 상태와 Steamworks README 첫 섹션을 릴리즈 후보 감사가 함께 대조한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readme_ab_loop_response_status.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_ab_loop_response_status.log`, `checkCount=151`, `passedCheckCount=151`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks 업로드 준비 문서 A/B 응답 회수 보류 상태

- `Docs/Steamworks_업로드_준비.md`의 `Store Presence Draft 독립 체크`에 A/B 응답 회수 보류 항목을 추가했다.
- 문서에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 실제 Steamworks URL/화면 캡처와 A/B 응답 회수 수치를 `Evidence/STORE_PRESENCE.md`에 채우기 전까지 `STORE_PRESENCE` 외부 게이트를 `pending_external`로 유지한다고 명시했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_doc_ab_loop_response_status.log`, `checkCount=152`, `passedCheckCount=152`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 handoff Store Presence 초안 상태 A/B 응답 회수 입력란

- `EXTERNAL_RELEASE_HANDOFF_KO.md` 최상단 `Store Presence 증거 초안 상태` 섹션에 A/B 응답 회수 입력란 요약을 추가했다.
- handoff 폴더와 Steamworks 폴더 양쪽 문서가 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`를 표시한다.
- handoff zip 내부 `v0.3.0/EXTERNAL_RELEASE_HANDOFF_KO.md` 무결성 체크도 같은 응답 회수 입력란 토큰을 요구한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_handoff_top_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_top_ab_loop_response_fields.log`, `checkCount=153`, `passedCheckCount=153`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store Presence 증거 묶음 표 A/B 응답 회수 입력란 멤버

- Store Presence 증거 묶음에 `Store Presence A/B 응답 회수 입력란` 멤버를 추가해 묶음 기준을 `checkCount=10`, `passedCheckCount=10`, `allPassed=true`로 올렸다.
- `EXTERNAL_RELEASE_HANDOFF_KO.md`의 `Store Presence 증거 묶음` 표에는 `Evidence/STORE_PRESENCE.md`를 근거로 하는 A/B 응답 회수 입력란 행이 표시된다.
- 릴리즈 후보 감사 JSON/CSV, Steamworks README, upload manifest, Steam 제출 전 자체점검, 업로드 준비 문서, 플레이테스트 QA 패킷의 Store Presence 묶음 카운트를 10/10으로 정렬했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_bundle_ab_loop_response_member.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_bundle_ab_loop_response_member_second_pass.log`, `checkCount=153`, `passedCheckCount=153`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 플레이테스트 QA 패킷 A/B 응답 회수 보류 상태

- `Docs/플레이테스트_QA_패킷.md`의 `Store Presence Draft 독립 체크`에 A/B 응답 회수 보류 항목을 추가했다.
- QA 패킷 문서는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`를 표시한다.
- 실제 사람 플레이테스트를 회수해도 Steamworks URL/화면 캡처와 A/B 응답 회수 수치를 `Evidence/STORE_PRESENCE.md`에 채우기 전까지 `STORE_PRESENCE` 외부 게이트가 `pending_external`임을 명시했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_packet_ab_loop_response_status.log`, `checkCount=154`, `passedCheckCount=154`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steam 제출 전 자체점검 Store Presence 증거 초안 A/B 응답 회수 입력란

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 Store Presence 증거 초안 상태` 행에 A/B 응답 회수 입력란 토큰을 직접 노출했다.
- 자체점검 행은 `README_KO.txt + EXTERNAL_RELEASE_GATE_TRACKER.csv + README_STEAMWORKS_KR.txt` 증거 묶음 옆에 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`를 표시한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 Store Presence 증거 초안 A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_draft_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_draft_ab_loop_response_fields_retry.log`, `checkCount=155`, `passedCheckCount=155`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 handoff README 첫 확인 A/B 응답 회수 입력란

- `Builds/Handoff/v0.3.0/README_KO.txt`와 `Builds/Steamworks/v0.3.0/README_KO.txt`의 `첫 확인 항목`에 `Store Presence A/B 응답 회수 입력란` 줄을 추가했다.
- 첫 확인 항목에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 프리플라이트의 `외부 검증 Store Presence 증거 초안 상태` 판정도 README의 A/B 응답 회수 입력란을 함께 요구한다.
- 릴리즈 후보 감사에 `외부 handoff README 첫 확인 A/B 응답 회수 입력란` 체크를 추가했고, 배포 무결성은 handoff zip 내부 `v0.3.0/README_KO.txt`까지 같은 필드를 요구한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_handoff_readme_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_readme_ab_loop_response_fields.log`, `checkCount=156`, `passedCheckCount=156`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks upload manifest Store Presence A/B 응답 회수 입력란

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence evidence draft` 줄에 A/B 응답 회수 입력란 토큰을 추가했다.
- manifest draft 항목에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 릴리즈 후보 감사에 `Steamworks upload manifest Store Presence A/B 응답 회수 입력란` 체크를 추가했다.
- Steam 제출 전 자체점검/upload manifest 상호참조도 manifest의 A/B 응답 회수 필드를 함께 대조한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_upload_manifest_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_ab_loop_response_fields.log`, `checkCount=157`, `passedCheckCount=157`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 게이트 tracker STORE_PRESENCE A/B 응답 회수 입력란 힌트

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `STORE_PRESENCE` row `evidence_hint`에 A/B 응답 회수 입력란 토큰을 추가했다.
- `STORE_PRESENCE` row에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 외부 게이트 감사 CSV/JSON의 `storePresenceDraftStatusSummary`도 같은 A/B 응답 회수 필드를 포함한다.
- 릴리즈 후보 감사에 `외부 게이트 tracker STORE_PRESENCE A/B 응답 회수 입력란 힌트` 체크를 추가했고, 배포 무결성은 handoff zip 내부 tracker까지 같은 필드를 요구한다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_store_presence_tracker_ab_loop_response_fields.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_tracker_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_tracker_ab_loop_response_fields.log`, `checkCount=158`, `passedCheckCount=158`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 릴리즈 후보 감사 노트 Store Presence A/B 응답 회수 입력란

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 A/B 응답 회수 입력란 줄을 추가했다.
- 감사 노트에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 릴리즈 후보 감사에 `Steamworks 릴리즈 후보 감사 노트 Store Presence A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_audit_note_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_audit_note_ab_loop_response_fields.log`, `checkCount=159`, `passedCheckCount=159`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 릴리즈 후보 감사 Markdown Store Presence A/B 응답 회수 입력란

- `care_review_release_candidate_audit.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 A/B 응답 회수 입력란 줄을 추가했다.
- Markdown 감사 리포트에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 Markdown Store Presence A/B 응답 회수 입력란` 체크를 추가했다.
- 첫 감사는 Markdown 파일 쓰기 전 파일 기반 검사를 읽어 `159/160`으로 실패했기 때문에 생성 함수 결과를 직접 검사하도록 수정했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_markdown_ab_loop_response_fields_retry.log`, `checkCount=160`, `passedCheckCount=160`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steam 제출 전 자체점검 최상단 Store Presence 외부 액션 A/B 응답 회수 입력란

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 `Store Presence 외부 액션 연결` 줄에 A/B 응답 회수 입력란 토큰을 추가했다.
- 외부 액션 연결 줄에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 최상단 Store Presence 외부 액션 A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_external_action_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_external_action_ab_loop_response_fields.log`, `checkCount=161`, `passedCheckCount=161`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 게이트 스모크 Store Presence 감사 노트 A/B 응답 회수 입력란 상호참조

- `care_review_external_gate_audit_smoke_result.json`의 `storePresenceAuditNoteCrossReference`에 A/B 응답 회수 입력란 토큰을 추가했다.
- 스모크 JSON 상호참조에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 외부 게이트 스모크 상호참조 줄도 `screenshot_ab_loop_response_count=0`을 직접 가리킨다.
- 릴리즈 후보 감사에 `외부 게이트 스모크 Store Presence 감사 노트 A/B 응답 회수 입력란 상호참조` 체크를 추가했다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_smoke_audit_note_ab_loop_response_fields.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_smoke_audit_note_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_smoke_audit_note_ab_loop_response_fields.log`, `checkCount=162`, `passedCheckCount=162`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks README Store Presence 검수 순서 A/B 응답 회수 입력란

- `README_STEAMWORKS_KR.txt`의 `Store Presence 검수 순서`에 A/B 응답 회수 입력란 확인 단계를 추가했다.
- 검수 순서 6번은 `Evidence/STORE_PRESENCE.md`의 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status` 입력란을 확인하도록 안내한다.
- 릴리즈 후보 감사에 `Steamworks README Store Presence 검수 순서 A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readme_order_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_order_ab_loop_response_fields.log`, `checkCount=163`, `passedCheckCount=163`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store Presence QA 카드 A/B 응답 회수 수치/초안 입력란 상호참조

- `STORE_PRESENCE_QA_CARD_KO.md`의 `A/B 응답 회수 수치` 항목이 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md` 수치를 확인한 뒤 `Evidence/STORE_PRESENCE.md` 입력란으로 옮기도록 보강했다.
- QA 카드는 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status` 세 필드를 Store Presence 초안 입력란과 직접 연결한다.
- 통과 기준도 A/B 응답 회수 수치가 `Evidence/STORE_PRESENCE.md` 입력란에 같은 축으로 기록되어야 한다고 명시했다.
- 릴리즈 후보 감사에 `Store Presence QA 카드 A/B 응답 회수 수치/초안 입력란 상호참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_qa_card_ab_loop_draft_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_qa_card_ab_loop_draft_fields.log`, `checkCount=164`, `passedCheckCount=164`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Evidence README Store Presence A/B 응답 회수 입력란 안내

- `Evidence/README_KO.md`의 `Store Presence 증거 작성` 섹션에 `A/B 응답 회수 확인 단계`를 추가했다.
- 안내는 `STORE_PRESENCE_QA_CARD_KO.md`의 `A/B 응답 회수 수치`와 `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`의 `screenshot_ab_loop_*` 수치를 확인한 뒤 `STORE_PRESENCE.md` 입력란에 옮기도록 명시한다.
- 릴리즈 후보 감사에 `외부 게이트 Evidence README Store Presence A/B 응답 회수 입력란 안내` 체크를 추가했고, handoff zip 내부 Evidence README도 같은 안내를 요구한다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_evidence_readme_ab_loop_response_fields.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_evidence_readme_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_evidence_readme_ab_loop_response_fields.log`, `checkCount=165`, `passedCheckCount=165`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks upload manifest upload doc cross-check A/B 응답 회수 입력란

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence upload doc cross-check` 줄에 A/B 응답 회수 입력란 토큰을 추가했다.
- upload doc cross-check 줄에는 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시된다.
- 릴리즈 후보 감사에 `Steamworks upload manifest upload doc cross-check A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_upload_doc_crosscheck_ab_loop_response_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_doc_crosscheck_ab_loop_response_fields.log`, `checkCount=166`, `passedCheckCount=166`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 handoff Store Presence 증거 묶음 표 A/B 응답 회수 입력란 통과 조건

- `EXTERNAL_RELEASE_HANDOFF_KO.md`의 `Store Presence 증거 묶음` 표에서 `Store Presence A/B 응답 회수 입력란` 행의 evidence 칸을 `Evidence/STORE_PRESENCE.md`와 세 입력란으로 확장했다.
- 표 통과 조건은 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status`를 handoff 문서와 Steamworks 복사본 양쪽에서 확인한다.
- 릴리즈 후보 감사에 `외부 handoff Store Presence 증거 묶음 표 A/B 응답 회수 입력란 통과 조건` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_handoff_bundle_ab_loop_pass_condition.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_bundle_ab_loop_pass_condition.log`, `checkCount=167`, `passedCheckCount=167`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks README 첫 섹션 대조 순서 A/B 응답 회수 입력란

- `README_STEAMWORKS_KR.txt` 첫 섹션의 `대조 순서` 줄에 `STORE_PRESENCE_QA_CARD_KO.md`, `store_page/SCREENSHOT_CANDIDATE_AB_TEST_KO.md`, `Evidence/STORE_PRESENCE.md`를 추가했다.
- 같은 줄에서 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status` 입력란을 직접 대조하도록 명시했다.
- 릴리즈 후보 감사에 `Steamworks README 첫 섹션 대조 순서 A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readme_crosscheck_ab_loop_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_crosscheck_ab_loop_fields.log`, `checkCount=168`, `passedCheckCount=168`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 릴리즈 후보 감사 JSON Store Presence evidence bundle A/B memberSummary

- `care_review_release_candidate_audit.json`의 `storePresenceEvidenceBundle.checks[]`에 `memberSummary` 필드를 추가했다.
- `외부 handoff 문서 Store Presence A/B 응답 회수 입력란 요약` 멤버는 `Evidence/STORE_PRESENCE.md`, `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status`를 한 줄 요약으로 제공한다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 JSON Store Presence evidence bundle A/B 응답 회수 입력란 memberSummary` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_json_bundle_member_ab_loop_summary.log`, `checkCount=169`, `passedCheckCount=169`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steam 제출 전 자체점검 외부 handoff README 증거 순서 A/B 입력란

- `README_KO.txt`의 `Store Presence/A-B/보정 후보 증거 작성 순서` 6번에 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status`를 직접 추가했다.
- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 핸드오프 README 증거 순서` evidence 문자열도 세 입력란을 표시한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 외부 handoff README 증거 순서 A/B 응답 회수 입력란` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_handoff_readme_order_ab_loop_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_handoff_readme_order_ab_loop_fields.log`, `checkCount=170`, `passedCheckCount=170`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Store Presence evidence bundle summary A/B 응답 회수 입력란

- `BuildExternalGateStorePresenceEvidenceBundleSummary()`가 만드는 `STORE_PRESENCE_EVIDENCE_BUNDLE_SUMMARY` 요약 문자열에 `abLoopInputFields`와 `abLoopInputValues`를 추가했다.
- 외부 게이트 감사 CSV/JSON의 `store_presence_evidence_bundle_summary` / `storePresenceEvidenceBundleSummary`에 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_not_collected_count`, `screenshot_ab_loop_collection_status`가 반복 노출된다.
- 릴리즈 후보 감사에 `외부 게이트 Store Presence evidence bundle summary A/B 응답 회수 입력란` 체크를 추가했다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_bundle_summary_ab_loop_fields.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_bundle_summary_ab_loop_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_bundle_summary_ab_loop_fields.log`, `checkCount=171`, `passedCheckCount=171`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 게이트 감사 CSV Store Presence row A/B evidence summary

- 외부 게이트 감사 `STORE_PRESENCE` row의 `evidenceSummary`에 `ab_loop_inputs` 요약을 추가했다.
- CSV/JSON 모두 `STORE_PRESENCE` 행에서 `screenshot_ab_loop_response_count=0`, `screenshot_ab_loop_not_collected_count=214`, `screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`를 직접 확인할 수 있다.
- 릴리즈 후보 감사에 `외부 게이트 감사 CSV Store Presence row A/B 응답 회수 입력란 evidence summary` 체크를 추가했다.
- 외부 게이트 감사 재생성: `Logs/audit_external_gate_store_presence_row_ab_loop_evidence_summary.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_row_ab_loop_evidence_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_row_ab_loop_evidence_summary.log`, `checkCount=172`, `passedCheckCount=172`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks upload manifest Store Presence evidence bundle memberSummary 상호참조

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence evidence bundle` 줄에 `release_candidate_json=care_review_release_candidate_audit.json`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`, `abLoopInputFields=...`를 추가했다.
- `Store Presence release candidate JSON cross-check` 줄도 `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 직접 가리킨다.
- 릴리즈 후보 감사에 `Steamworks upload manifest Store Presence evidence bundle memberSummary 상호참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_upload_manifest_member_summary_ab_loop.log`.
- 첫 릴리즈 감사 로그 `Logs/audit_release_candidate_upload_manifest_member_summary_ab_loop.log`는 스크립트 리컴파일 뒤 감사 메서드 실행 전 종료되어, 재시도 로그를 기준으로 확인했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_member_summary_ab_loop_retry.log`, `checkCount=173`, `passedCheckCount=173`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 릴리즈 후보 감사 Markdown Store Presence 증거 묶음 summary A/B 입력란

- `care_review_release_candidate_audit.md`의 `보정 후보 / Store Presence 증거 묶음` 섹션에 `evidence bundle summary A/B 입력란` 줄을 추가했다.
- Markdown 섹션에서 `abLoopInputFields=screenshot_ab_loop_response_count,screenshot_ab_loop_not_collected_count,screenshot_ab_loop_collection_status`와 `abLoopInputValues=...waiting_for_screenshot_ab_loop_responses`를 확인할 수 있다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 Markdown Store Presence 증거 묶음 summary A/B 입력란` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_markdown_bundle_summary_ab_loop_fields.log`, `checkCount=174`, `passedCheckCount=174`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 게이트 감사 Markdown Store Presence row A/B evidence summary

- `care_review_external_gate_audit.md`의 `STORE_PRESENCE` row에 `ab_loop_inputs=screenshot_ab_loop_response_count=0,screenshot_ab_loop_not_collected_count=214,screenshot_ab_loop_collection_status=waiting_for_screenshot_ab_loop_responses`가 표시되는지 릴리즈 후보 감사로 고정했다.
- 이 체크는 CSV/JSON뿐 아니라 사람이 읽는 외부 게이트 Markdown 표에서도 Store Presence A/B 응답 회수 입력란을 확인하게 한다.
- 릴리즈 후보 감사에 `외부 게이트 감사 Markdown Store Presence row A/B 응답 회수 입력란 evidence summary` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_markdown_row_ab_loop.log`, `checkCount=175`, `passedCheckCount=175`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steam 제출 전 자체점검 Store Presence 증거 묶음 memberSummary 상호참조

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 Store Presence 증거 묶음 요약` 항목이 `STEAMWORKS_UPLOAD_MANIFEST.txt`와 `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 함께 표시하도록 보강했다.
- 이 자체점검 항목은 릴리즈 후보 감사 노트, 릴리즈 후보 CSV, upload manifest의 memberSummary 상호참조를 한 번에 검증한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 Store Presence 증거 묶음 upload manifest memberSummary 상호참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_bundle_member_summary.log`.
- 첫 릴리즈 감사 로그 `Logs/audit_release_candidate_preflight_bundle_member_summary.log`는 스크립트 리컴파일 뒤 새 체크가 반영되지 않아 재시도했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_bundle_member_summary_retry.log`, `checkCount=176`, `passedCheckCount=176`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks README Store Presence 증거 묶음 memberSummary 상호참조

- `README_STEAMWORKS_KR.txt` 첫 섹션 `Store Presence 증거 묶음 상태`에 `upload manifest memberSummary 대조` 줄을 추가했다.
- README에서 `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence bundle`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 직접 확인할 수 있다.
- 릴리즈 후보 감사에 `Steamworks README Store Presence 증거 묶음 upload manifest memberSummary 상호참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readme_member_summary_crosscheck.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_member_summary_crosscheck.log`, `checkCount=177`, `passedCheckCount=177`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 handoff Store Presence 증거 묶음 표 memberSummary 상호참조

- `EXTERNAL_RELEASE_HANDOFF_KO.md`의 `Store Presence 증거 묶음` 표에서 `Store Presence A/B 응답 회수 입력란` evidence 칸에 `care_review_release_candidate_audit.json memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 추가했다.
- handoff 폴더 문서, Steamworks 복사본, handoff zip 내부 문서가 모두 같은 memberSummary 상호참조와 세 A/B 응답 회수 입력란을 포함해야 통과한다.
- 릴리즈 후보 감사에 `외부 handoff Store Presence 증거 묶음 표 release candidate JSON memberSummary 상호참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_handoff_bundle_member_summary_crosscheck.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_bundle_member_summary_crosscheck.log`, `checkCount=178`, `passedCheckCount=178`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 릴리즈 후보 감사 노트 Store Presence 증거 묶음 memberSummary 상호참조

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 `보정 후보 / Store Presence 증거 묶음` 섹션에 `JSON memberSummary`와 `upload manifest 상호참조` 줄을 추가했다.
- 감사 노트에서 `care_review_release_candidate_audit.json`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`, `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence bundle`을 직접 확인할 수 있다.
- 릴리즈 후보 감사에 `Steamworks 릴리즈 후보 감사 노트 Store Presence 증거 묶음 memberSummary 상호참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_audit_note_member_summary_crosscheck.log`.
- 첫 두 릴리즈 감사 로그 `Logs/audit_release_candidate_audit_note_member_summary_crosscheck.log`, `Logs/audit_release_candidate_audit_note_member_summary_crosscheck_retry.log`는 스크립트 리컴파일/리로드만 수행해 감사 JSON이 갱신되지 않았다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_audit_note_member_summary_crosscheck_retry2.log`, `checkCount=179`, `passedCheckCount=179`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steamworks upload manifest Store Presence evidence draft memberSummary 역참조

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence evidence draft` 줄에 `README_STEAMWORKS_KR.txt upload manifest memberSummary 대조`, `STEAM_SUBMISSION_PREFLIGHT_KO.md 외부 검증 Store Presence 증거 묶음 요약`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 추가했다.
- upload manifest draft 줄은 이제 `Evidence/STORE_PRESENCE.md` 초안 상태, A/B 응답 회수 입력란, README/자체점검 memberSummary 대조를 한 줄에서 확인한다.
- 릴리즈 후보 감사에 `Steamworks upload manifest Store Presence evidence draft README/preflight memberSummary 역참조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_upload_manifest_draft_member_summary_backref.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_draft_member_summary_backref.log`, `checkCount=180`, `passedCheckCount=180`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 게이트 Evidence README Store Presence memberSummary 확인 단계

- `Evidence/README_KO.md`의 `Store Presence 증거 작성` 섹션에 `release candidate JSON memberSummary 확인` 단계를 추가했다.
- handoff Evidence README에서 `care_review_release_candidate_audit.json`, `storePresenceEvidenceBundle`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 직접 확인한 뒤 `STORE_PRESENCE.md` 입력란으로 옮기도록 고정했다.
- 릴리즈 후보 감사에 `외부 게이트 Evidence README Store Presence memberSummary 확인 단계` 체크를 추가했고, handoff zip 내부 `v0.3.0/Evidence/README_KO.md`도 같은 키워드를 포함해야 배포 무결성이 통과한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_evidence_readme_member_summary_crosscheck.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_evidence_readme_member_summary_crosscheck.log`, `checkCount=181`, `passedCheckCount=181`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 Steam 제출 전 자체점검 Store Presence 초안/upload manifest README memberSummary 대조

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 Store Presence 증거 초안/upload manifest 상호참조` 항목 detail에 `README_STEAMWORKS_KR.txt memberSummary 대조`를 추가했다.
- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence preflight cross-check` 줄도 `README_STEAMWORKS_KR.txt upload manifest memberSummary 대조`와 `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 함께 포함한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 Store Presence 증거 초안/upload manifest README memberSummary 대조 항목` 체크를 추가해 preflight, upload manifest, Steamworks README의 세 산출물이 같은 memberSummary 기준을 공유하는지 검증한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_draft_readme_member_summary_crosscheck.log`.
- 첫 릴리즈 감사 로그 `Logs/audit_release_candidate_preflight_draft_readme_member_summary_crosscheck.log`는 스크립트 리컴파일 뒤 감사 JSON을 갱신하지 않았고, `Logs/audit_release_candidate_preflight_draft_readme_member_summary_crosscheck_retry.log`에서 강화된 기존 체크를 확인했다.
- 별도 릴리즈 감사 체크 추가 후 최종 감사: `Logs/audit_release_candidate_preflight_draft_readme_member_summary_crosscheck_retry2.log`, `checkCount=182`, `passedCheckCount=182`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=43`, `passedCheckCount=43`.

### 2026-06-02 외부 handoff README 첫 확인 release candidate JSON memberSummary 확인

- `README_KO.txt`의 `첫 확인 항목`에 `release candidate JSON memberSummary 확인` 줄을 추가했다.
- handoff README와 Steamworks 복사본에서 `care_review_release_candidate_audit.json`, `storePresenceEvidenceBundle`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 직접 확인할 수 있다.
- 릴리즈 후보 감사에 `외부 handoff README 첫 확인 release candidate JSON memberSummary 확인` 체크를 추가했다.
- 배포 무결성에도 handoff 폴더와 handoff zip 내부 `v0.3.0/README_KO.txt`의 memberSummary 확인 체크를 각각 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_handoff_readme_member_summary_first_check.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_readme_member_summary_first_check.log`, `checkCount=183`, `passedCheckCount=183`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 Store Presence QA 카드 A/B 응답 회수 수치 memberSummary 확인

- `STORE_PRESENCE_QA_CARD_KO.md`의 `A/B 응답 회수 수치` 단계에 `release candidate JSON memberSummary 확인`을 추가했다.
- QA 카드에서 `care_review_release_candidate_audit.json`, `storePresenceEvidenceBundle`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 확인한 뒤 `Evidence/STORE_PRESENCE.md`의 세 A/B 응답 회수 입력란과 같은 축으로 기록하도록 보강했다.
- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 Store Presence QA 카드` 항목도 같은 memberSummary 확인 문자열을 요구한다.
- 릴리즈 후보 감사에 `Store Presence QA 카드 A/B 응답 회수 수치 release candidate JSON memberSummary 확인` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_qa_card_ab_loop_member_summary_crosscheck.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_qa_card_ab_loop_member_summary_crosscheck.log`, `checkCount=184`, `passedCheckCount=184`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 Steamworks 업로드 준비 문서 Store Presence Draft memberSummary 대조

- `Docs/Steamworks_업로드_준비.md`의 `Store Presence Draft 독립 체크` 섹션에서 `upload manifest 상호참조`를 `upload manifest memberSummary 상호참조`로 확장했다.
- 해당 줄은 이제 `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence upload doc cross-check`, `Store Presence evidence draft`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 함께 확인한다.
- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence upload doc cross-check` 줄에도 `upload manifest memberSummary 상호참조`와 `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 추가했다.
- 릴리즈 후보 감사에 `Steamworks 업로드 준비 문서 Store Presence Draft upload manifest memberSummary 대조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_upload_doc_member_summary_crosscheck.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_doc_member_summary_crosscheck.log`, `checkCount=185`, `passedCheckCount=185`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 플레이테스트 QA 패킷 Store Presence Draft memberSummary 대조

- `Docs/플레이테스트_QA_패킷.md`의 `Store Presence Draft 독립 체크` 섹션에서 Steamworks 업로드 준비 문서 상호참조 줄을 `memberSummary` 대조로 확장했다.
- 플레이테스트 QA 패킷은 이제 `Docs/Steamworks_업로드_준비.md`, `upload manifest memberSummary 상호참조`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 함께 확인한다.
- 릴리즈 후보 감사에 `플레이테스트 QA 패킷 Store Presence Draft upload manifest memberSummary 대조` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_packet_member_summary_crosscheck.log`, `checkCount=186`, `passedCheckCount=186`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 Store Presence 실제 증거 초안 통과 전 memberSummary 확인

- `Evidence/STORE_PRESENCE.md` 초안의 `통과 전 확인` 섹션에 `release candidate JSON memberSummary 확인` 줄을 추가했다.
- 실제 Store Presence 증거 입력 담당자가 초안 파일만 열어도 `care_review_release_candidate_audit.json`, `storePresenceEvidenceBundle`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 확인할 수 있다.
- 릴리즈 후보 감사에 `외부 게이트 Store Presence 실제 증거 초안 release candidate JSON memberSummary 확인` 체크를 추가했다.
- handoff zip 내부 `v0.3.0/Evidence/STORE_PRESENCE.md`도 같은 memberSummary 확인 줄을 포함해야 배포 무결성이 통과한다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_presence_draft_member_summary_check.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_draft_member_summary_check.log`, `checkCount=187`, `passedCheckCount=187`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 외부 게이트 tracker Store Presence memberSummary evidence_hint

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `STORE_PRESENCE` row `evidence_hint`에 `release_candidate_json=care_review_release_candidate_audit.json`과 `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 추가했다.
- 외부 게이트 감사 CSV/JSON/Markdown의 `store_presence_draft_status_summary` / `storePresenceDraftStatusSummary`도 같은 memberSummary 대조를 포함하도록 보강했다.
- 릴리즈 후보 감사에 `외부 게이트 tracker Store Presence evidence_hint release candidate JSON memberSummary 확인` 체크를 추가했다.
- 외부 게이트 감사: `Logs/audit_external_gate_tracker_member_summary_hint_retry.log`.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_tracker_member_summary_hint_retry.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_tracker_member_summary_hint_retry.log`, `checkCount=188`, `passedCheckCount=188`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 외부 게이트 감사 Store Presence row evidence summary upload manifest memberSummary 대조

- `care_review_external_gate_audit.csv/json/md`의 `STORE_PRESENCE` row `evidence_summary`에 `upload_manifest=STEAMWORKS_UPLOAD_MANIFEST.txt`와 `upload_manifest_memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 추가했다.
- 이로써 외부 게이트 감사 row 자체가 `Evidence/STORE_PRESENCE.md`, A/B 응답 회수 입력란, Steamworks upload manifest memberSummary 대조를 한 줄에서 확인한다.
- 릴리즈 후보 감사에 `외부 게이트 감사 Store Presence row evidence summary upload manifest memberSummary 대조` 체크를 추가했다.
- 외부 게이트 감사: `Logs/audit_external_gate_row_evidence_summary_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_row_evidence_summary_member_summary.log`, `checkCount=189`, `passedCheckCount=189`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 Steamworks README Store Presence 검수 순서 실제 증거 초안 memberSummary 확인

- `README_STEAMWORKS_KR.txt`의 `Store Presence 검수 순서`에 `Evidence/STORE_PRESENCE.md` 실제 증거 초안의 `release candidate JSON memberSummary 확인` 단계를 추가했다.
- Steamworks 업로드 담당자가 A/B 응답 회수 입력란을 채우기 전에 `care_review_release_candidate_audit.json`과 `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 먼저 대조한다.
- 릴리즈 후보 감사에 `Steamworks README Store Presence 검수 순서 실제 증거 초안 memberSummary 확인` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readme_store_presence_order_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_store_presence_order_member_summary.log`, `checkCount=190`, `passedCheckCount=190`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 Steam 제출 전 자체점검 최상단 Store Presence 외부 액션 memberSummary 확인

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `최상단 판정 요약` 안 `Store Presence 외부 액션 연결` 줄에 `release candidate JSON memberSummary 확인`을 추가했다.
- 최상단 외부 액션 줄에서 `STORE_PRESENCE`, `actual_status=pending_external`, `draft=Evidence/STORE_PRESENCE.md`, A/B 응답 회수 입력란과 `care_review_release_candidate_audit.json`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 한 번에 대조한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 최상단 Store Presence 외부 액션 release candidate JSON memberSummary 확인` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_external_action_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_external_action_member_summary.log`, `checkCount=191`, `passedCheckCount=191`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 릴리즈 후보 감사 Markdown Store Presence 초안 upload manifest memberSummary 대조

- `care_review_release_candidate_audit.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 `upload manifest memberSummary 대조` 줄을 추가했다.
- Steamworks 감사 노트 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 같은 섹션도 `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Store Presence evidence draft`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 직접 대조한다.
- 릴리즈 후보 감사에 `릴리즈 후보 감사 Markdown Store Presence 실제 증거 초안 상태 upload manifest memberSummary 대조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_release_markdown_draft_upload_manifest_member_summary.log`.
- 첫 릴리즈 감사 로그 `Logs/audit_release_candidate_markdown_draft_upload_manifest_member_summary.log`는 스크립트 리로드 뒤 감사 산출물을 갱신하지 않았고, 재실행 로그 `Logs/audit_release_candidate_markdown_draft_upload_manifest_member_summary_retry.log`에서 최종 통과를 확인했다.
- 릴리즈 후보 감사: `checkCount=192`, `passedCheckCount=192`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 Steamworks README 첫 섹션 tracker memberSummary 대조

- `README_STEAMWORKS_KR.txt` 첫 섹션의 `대조 순서`에 `EXTERNAL_RELEASE_GATE_TRACKER.csv`를 추가했다.
- 같은 줄에서 `evidence_hint`, `release_candidate_json=care_review_release_candidate_audit.json`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 직접 확인하도록 했다.
- 릴리즈 후보 감사에 `Steamworks README 첫 섹션 대조 순서 external gate tracker memberSummary 확인` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_readme_first_section_tracker_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_first_section_tracker_member_summary.log`, `checkCount=193`, `passedCheckCount=193`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=45`, `passedCheckCount=45`.

### 2026-06-02 외부 handoff README 첫 확인 preflight 최상단 외부 액션 memberSummary 대조

- `README_KO.txt`의 `첫 확인 항목`에 `preflight 최상단 외부 액션 memberSummary 대조` 줄을 추가했다.
- handoff README와 Steamworks 복사본에서 `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `Store Presence 외부 액션 연결`, `release candidate JSON memberSummary 확인`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 바로 대조한다.
- 릴리즈 후보 감사에 `외부 handoff README 첫 확인 preflight 최상단 외부 액션 memberSummary 대조` 체크를 추가했다.
- 배포 무결성에도 handoff 폴더와 handoff zip 내부 `v0.3.0/README_KO.txt` 체크를 각각 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_handoff_readme_preflight_top_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_readme_preflight_top_member_summary.log`, `checkCount=194`, `passedCheckCount=194`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_handoff_readme_preflight_top_member_summary.log`, `checkCount=47`, `passedCheckCount=47`.

### 2026-06-02 preflight Store Presence 초안 상태 audit Markdown memberSummary 대조

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `외부 검증 Store Presence 증거 초안 상태` detail에 `care_review_release_candidate_audit.md upload manifest memberSummary 대조`를 추가했다.
- 해당 preflight 체크는 이제 `README_KO.txt`, `EXTERNAL_RELEASE_GATE_TRACKER.csv`, `README_STEAMWORKS_KR.txt`와 함께 릴리즈 후보 감사 Markdown의 `Store Presence 실제 증거 초안 상태`, `upload manifest memberSummary 대조`, `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`를 대조한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 Store Presence 증거 초안 상태 audit Markdown memberSummary 대조` 체크를 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_preflight_draft_status_audit_markdown_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_draft_status_audit_markdown_member_summary.log`, `checkCount=195`, `passedCheckCount=195`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.json`, `checkCount=47`, `passedCheckCount=47`.

### 2026-06-02 결정 감사 다음 회차 코칭 패널

- 결정 감사 대시보드에 `다음 회차 코칭` 패널을 추가해 핵심 패턴, 추천 운영, 실행 규칙, 보정 큐, 검증 질문을 한 번에 보여주도록 했다.
- 코칭은 긴급 지연, 고비용 지원, 권장 판단 불일치, 이의제기 큐를 기준으로 다음 회차 운영 기준과 점검 규칙을 제안한다.
- 결정 감사 스모크에 `coachingMentionsNextRunStrategy=true` 검증과 `coachingPreview` JSON 출력을 추가했다.
- 런타임 스모크: `Logs/runtime_decision_audit_coaching.log`, `completed=true`, `coachingMentionsNextRunStrategy=true`, `coachingPreview=다음 회차 코칭 / 핵심 패턴 / 추천 운영 / 실행 규칙 / 검증 질문`.
- Windows 릴리즈 패키지 재생성: `Logs/build_windows_release_decision_audit_coaching_docs.log`.
- Steamworks depot 재생성: `Logs/prepare_steamworks_decision_audit_coaching_docs.log`.
- 릴리즈 후보 감사에 `결정 감사 다음 회차 코칭 QA` 체크를 추가하고 README/manifest/preflight가 `다음 회차 코칭`, `decision audit next-run coaching`, `decision audit coaching smoke`를 요구하도록 강화했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_audit_coaching.log`, `checkCount=196`, `passedCheckCount=196`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_smoke_result.json`, `checkCount=47`, `passedCheckCount=47`.

### 2026-06-02 플레이테스트 패킷 결정 감사 코칭 export

- 플레이테스트 패킷 export에 `decisionAuditCoaching` JSON 객체를 추가해 핵심 패턴, 긴급 지연/고비용 지원/권장 불일치 수, 추천 운영, 실행 규칙, 이의제기 큐 대표 사례, 검증 질문을 함께 저장하도록 했다.
- 테스터 설문 Markdown에는 `결정 감사 다음 회차 코칭` 섹션을 추가했고, HTML 분석 대시보드에는 `다음 회차 코칭` 카드를 추가해 플레이테스터 회수 자료만 열어도 다음 회차 운영 가설을 볼 수 있게 했다.
- 플레이테스트 패킷 스모크에 `summaryHasDecisionAuditCoaching=true`, `feedbackMentionsDecisionAuditCoaching=true`, `dashboardMentionsDecisionAuditCoaching=true` 검증을 추가했다.
- 런타임 스모크: `Logs/runtime_playtest_packet_decision_audit_coaching.log`, `completed=true`, `summaryHasDecisionAuditCoaching=true`, `feedbackMentionsDecisionAuditCoaching=true`, `dashboardMentionsDecisionAuditCoaching=true`.
- Windows 빌드/릴리즈 패키지/Steamworks depot 재생성: `Logs/build_windows_playtest_packet_decision_audit_coaching.log`, `Logs/build_windows_release_playtest_packet_decision_audit_coaching.log`, `Logs/prepare_steamworks_playtest_packet_decision_audit_coaching.log`.
- 릴리즈 zip 재생성 누락을 막기 위해 릴리즈 패키징 단계에서 `CareReviewOffice_Windows_v0.3.0.zip`과 SHA256을 매번 다시 쓰도록 보강했다. 최신 릴리즈 zip SHA256은 `31AF9A6E9A7BD4BF38512CD194A27E07052560B0C3A075F3C6578E6BF5377785`이다.
- 플레이테스트 kit 문서와 zip SHA도 최신 릴리즈 zip에 맞춰 동기화했다. 최신 플레이테스트 kit SHA256은 `8E7FEEEFB7766D81D945F12F9A8FD9DD44868E0AF17B050F40328AD5406597C1`이다.
- 최종 배포 무결성: `Logs/audit_distribution_integrity_final_playtest_packet_coaching.log`, `checkCount=47`, `passedCheckCount=47`.
- 최종 릴리즈 후보 감사: `Logs/audit_release_candidate_final_playtest_packet_coaching.log`, `checkCount=197`, `passedCheckCount=197`, `localBlockerCount=0`.

### 2026-06-02 캠페인 기록 결정 감사 코칭 요약

- 완료 회차 저장 시 결정 감사 코칭 요약을 `CareerRecord`에 함께 저장하도록 했다. 저장 필드는 핵심 패턴, 불일치/고위험 지연/고비용 지원 수, 추천 운영, 실행 규칙, 검증 질문, 보정 대표 사례, 요약 라인을 포함한다.
- 캠페인 기록 본문과 선택 회차 상세에 `결정 감사 코칭` 줄을 추가해 다음 회차 재시작 전에 어떤 운영 기준과 실행 규칙을 따라야 하는지 바로 보이게 했다.
- 캠페인 기록 스모크에 `recordHasDecisionAuditCoaching=true`, `bodyMentionsDecisionAuditCoaching=true`, `detailMentionsDecisionAuditCoaching=true` 검증을 추가했다.
- 런타임 스모크: `Logs/runtime_career_record_decision_audit_coaching.log`, `completed=true`, `decisionAuditCoachingSummaryLine=고비용 지원 · 추천 운영 긴축 감사`, `decisionAuditCoachingRecommendedMandateName=긴축 감사`.
- Windows 빌드/릴리즈 패키지/Steamworks depot 재생성: `Logs/build_windows_career_record_decision_audit_coaching.log`, `Logs/build_windows_release_career_record_decision_audit_coaching.log`, `Logs/prepare_steamworks_career_record_decision_audit_coaching.log`, `Logs/prepare_steamworks_after_playtest_sync_career_record_coaching.log`.
- 최신 릴리즈 zip SHA256은 `31AF9A6E9A7BD4BF38512CD194A27E07052560B0C3A075F3C6578E6BF5377785`, 플레이테스트 kit SHA256은 `8E7FEEEFB7766D81D945F12F9A8FD9DD44868E0AF17B050F40328AD5406597C1`, Steamworks zip SHA256은 `4B6561B364E5DBC208C3DEFDE02A6D217C9DA4CB0FCB5EA33C72B32116B7E557`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_career_record_decision_audit_coaching.log`, `checkCount=47`, `passedCheckCount=47`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_record_decision_audit_coaching.log`, `checkCount=197`, `passedCheckCount=197`, `localBlockerCount=0`.

### 2026-06-02 사례 자료실 결정 감사 코칭 사례 버튼

- 사례 자료실 상단 보조 액션에 `코칭 사례` 버튼을 추가했다. 최신 캠페인 기록의 결정 감사 코칭 보정 사례가 있으면 해당 사례로 바로 포커스하고, 없으면 고압력 대표 사례로 fallback한다.
- 버튼 이동 시 사례 자료실 상태줄에 `결정 감사 코칭 포커스`와 코칭 요약을 표시하고, `기록 복귀` 버튼으로 해당 캠페인 기록 상세로 돌아갈 수 있게 했다.
- 캠페인 기록 스모크에 `caseArchiveDecisionAuditCoachingButtonActive=true`, `caseArchiveDecisionAuditCoachingButtonOpensCase=true`, `caseArchiveDecisionAuditCoachingCaseId` 검증을 추가했다.
- 런타임 스모크: `Logs/runtime_case_archive_decision_audit_coaching_case_button_fix.log`, `completed=true`, `caseArchiveDecisionAuditCoachingButtonLabel=코칭 W-207`, `caseArchiveDecisionAuditCoachingButtonOpensCase=true`.
- Windows 빌드/릴리즈 패키지/Steamworks depot 재생성: `Logs/build_windows_case_archive_decision_audit_coaching_case_button_fix.log`, `Logs/build_windows_release_case_archive_decision_audit_coaching_case_button.log`, `Logs/prepare_steamworks_case_archive_decision_audit_coaching_case_button.log`.
- 최신 릴리즈 zip SHA256은 `31AF9A6E9A7BD4BF38512CD194A27E07052560B0C3A075F3C6578E6BF5377785`, 플레이테스트 kit SHA256은 `8E7FEEEFB7766D81D945F12F9A8FD9DD44868E0AF17B050F40328AD5406597C1`, Steamworks zip SHA256은 `4B6561B364E5DBC208C3DEFDE02A6D217C9DA4CB0FCB5EA33C72B32116B7E557`이다.

### 2026-06-02 플레이테스트 집계 결정 감사 코칭 패턴 분포

- 플레이테스트 세션 집계가 각 세션 요약의 `decisionAuditCoaching`을 읽어 코칭 패턴, 추천 운영, 검증 사례, 불일치/고위험 지연/고비용 지원 수를 CSV 세션 행에 포함하도록 했다.
- 집계 JSON에는 `decisionAuditCoachingSessionCount`, `decisionAuditCoachingPatternCounts`, `decisionAuditCoachingMandateCounts`, `decisionAuditCoachingAppealQueueSessionCount`를 추가했다.
- 집계 Markdown에는 `결정 감사 코칭 패턴 분포` 섹션을 추가해 코칭 생성 세션 수, 누적 압박 수, 패턴 분포, 추천 운영 분포, 세션별 검증 사례를 바로 볼 수 있게 했다.
- 플레이테스트 집계 스모크: `Logs/runtime_playtest_aggregate_decision_audit_coaching_pattern.log`, `completed=true`, `csvHasDecisionAuditCoachingColumns=true`, `jsonHasDecisionAuditCoachingPatternDistribution=true`, `markdownMentionsDecisionAuditCoachingPatternDistribution=true`, `decisionAuditCoachingSessionCount=3`.
- Windows 빌드/릴리즈 패키지/Steamworks depot 재생성: `Logs/build_playtest_aggregate_decision_audit_coaching_pattern.log`, `Logs/build_windows_release_playtest_aggregate_decision_audit_coaching_pattern.log`, `Logs/prepare_steamworks_playtest_aggregate_decision_audit_coaching_pattern.log`, `Logs/prepare_steamworks_after_playtest_sync_playtest_aggregate_decision_audit_coaching_pattern.log`.
- 최신 릴리즈 zip SHA256은 `31AF9A6E9A7BD4BF38512CD194A27E07052560B0C3A075F3C6578E6BF5377785`, 플레이테스트 kit SHA256은 `8E7FEEEFB7766D81D945F12F9A8FD9DD44868E0AF17B050F40328AD5406597C1`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_final_playtest_aggregate_decision_audit_coaching_pattern.log`, `checkCount=47`, `passedCheckCount=47`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_final_playtest_aggregate_decision_audit_coaching_pattern.log`, `checkCount=197`, `passedCheckCount=197`, `localBlockerCount=0`.

### 2026-06-02 캠페인 기록/사례 자료실 코칭 왕복 힌트

- 캠페인 기록 액션 안내에 `코칭 W-207↔기록` 같은 짧은 왕복 표식을 추가해 결정 감사 코칭 추천 사례가 어느 사례 자료실 포커스로 이어지는지 바로 보이게 했다.
- 캠페인 기록 상세에는 `코칭 왕복` 줄을 추가해 `코칭 사례 → 사례 자료실 → 기록 복귀` 경로와 추천 운영/검증 질문 재확인 목적을 설명한다.
- 사례 자료실 코칭 사례 포커스 상태줄과 타임라인에는 `기록 복귀로 캠페인 기록 왕복`, `코칭 왕복 힌트`를 표시해 자료실에서 다시 해당 완료 회차로 돌아갈 수 있음을 명시했다.
- 캠페인 기록 스모크: `Logs/runtime_career_record_coaching_round_trip_hint.log`, `completed=true`, `detailMentionsCoachingRoundTrip=true`, `careerRecordActionHintMentionsCoachingRoundTrip=true`, `caseArchiveDecisionAuditCoachingStatusMentionsRoundTrip=true`, `caseArchiveDecisionAuditCoachingTimelineMentionsRoundTrip=true`, `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`.
- Windows 빌드/릴리즈 패키지: `Logs/build_career_record_coaching_round_trip_hint.log`, `Logs/build_windows_release_career_record_coaching_round_trip_hint.log`.
- 최신 릴리즈 zip SHA256은 `31AF9A6E9A7BD4BF38512CD194A27E07052560B0C3A075F3C6578E6BF5377785`, 플레이테스트 kit SHA256은 `8E7FEEEFB7766D81D945F12F9A8FD9DD44868E0AF17B050F40328AD5406597C1`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_final_career_record_coaching_round_trip_hint.log`, `checkCount=47`, `passedCheckCount=47`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_final_career_record_coaching_round_trip_hint.log`, `checkCount=197`, `passedCheckCount=197`, `localBlockerCount=0`.

### 2026-06-02 Store 후보 스크린샷 결정 감사 코칭 포커스 예정 manifest

- 상점 후보 스크린샷 manifest에 `다음 캡처 후보` 섹션을 추가하고 `14_case_archive_decision_audit_coaching_focus.png`를 예정 후보로 등록했다.
- 예정 후보의 승격 기준은 사례 자료실 `코칭 W-207` 버튼, `기록 복귀`, `결정 감사 코칭 포커스`, `코칭 왕복 힌트`가 한 화면에서 읽히는지 확인한 뒤 실제 후보 파일 세트로 캡처하는 흐름으로 잡았다.
- Steamworks upload manifest와 Steam 상점페이지 제출안/자료 문서에도 14번을 planned 후보로 반영해, 현재 후보 파일 5장 감사와 다음 캡처 계획이 충돌하지 않게 했다.
- Steamworks depot 재생성: `Logs/prepare_steamworks_store_candidate_coaching_focus_manifest_final.log`.
- 배포 무결성: `Logs/audit_distribution_integrity_final_store_candidate_coaching_focus_manifest_final.log`, `checkCount=47`, `passedCheckCount=47`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_final_store_candidate_coaching_focus_manifest_final.log`, `checkCount=197`, `passedCheckCount=197`, `localBlockerCount=0`.

### 2026-06-02 Store/QA handoff 결정 감사 코칭 패턴 분포 연결

- 외부 handoff README 첫 확인 항목에 `결정 감사 코칭 패턴 분포 Store/QA handoff`를 추가해 Store Presence 검수자가 플레이테스트 집계의 코칭 분포를 먼저 보게 했다.
- `EXTERNAL_RELEASE_HANDOFF_KO.md`와 `STORE_PRESENCE_QA_CARD_KO.md`에 `decisionAuditCoachingSessionCount=3/214`, `decisionAuditCoachingPatternCounts=고비용 지원`, `decisionAuditCoachingMandateCounts=긴축 감사` 요약을 연결했다.
- Steamworks 사본과 handoff zip 내부 문서도 같은 Store/QA handoff 요약을 포함하도록 배포 무결성 조건을 보강했다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence Draft 독립 체크에도 같은 코칭 분포 확인 항목을 추가했다.
- Steamworks/handoff 재생성: `Logs/prepare_steamworks_store_qa_handoff_decision_audit_coaching_distribution_final.log`.
- handoff zip SHA256: `E0ED1B3683E3F4DF72BA92297CE956EC981FC2039C2BC395D84CFF56B47372BF`.
- 배포 무결성: `Logs/audit_distribution_integrity_final_store_qa_handoff_decision_audit_coaching_distribution_final.log`, `checkCount=49`, `passedCheckCount=49`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_final_store_qa_handoff_decision_audit_coaching_distribution_final.log`, `checkCount=198`, `passedCheckCount=198`, `localBlockerCount=0`.

### 2026-06-02 Store 후보 스크린샷 결정 감사 코칭 포커스 실제 캡처 세트

- 런타임 상점 스크린샷 캡처에 `14_case_archive_decision_audit_coaching_focus.png`를 추가했다. 마케팅용 캠페인 기록 seed가 `decisionAuditCoachingAppealCaseId=W-207`을 포함해 사례 자료실 `코칭 W-207` 버튼과 `기록 복귀` 왕복을 안정적으로 캡처한다.
- Steamworks 후보 스크린샷 세트를 5장에서 6장으로 승격하고 `SCREENSHOT_CANDIDATES_KO.md`, 캡처 동기화 manifest, SHA manifest, Store Presence QA 카드, 외부 handoff 무결성 검사에서 14번 후보를 필수 확인 항목으로 연결했다.
- Steam 상점페이지 제출안/자료 문서는 14번을 예정 후보가 아니라 실제 QA 후보로 기록하도록 갱신했다.
- `W-207`을 사례 자료실에서 직접 열 수 있는 보조 사례로 등록하고, 결정 감사 코칭 사례 선택은 실제 `decisionAuditCoachingAppealCaseId`를 먼저 찾은 뒤에만 대표 사례 fallback을 쓰도록 고쳤다.
- 최종 14번 캡처는 `코칭 W-207`, `기록 복귀`, `결정 감사 코칭 포커스`, `코칭 왕복 힌트`가 같은 화면에 보이도록 상태줄을 짧게 재배치했다.
- Windows 빌드/상점 후보 캡처/Steamworks/handoff 재생성: `Logs/build_windows_release_store_candidate_decision_audit_coaching_capture_set_short_hint.log`, `Logs/runtime_store_candidate_graphics_capture_sync.log`, `Logs/prepare_steamworks_store_candidate_decision_audit_coaching_capture_set_hash_sync.log`, `Logs/build_external_handoff_store_candidate_decision_audit_coaching_capture_set_hash_sync.log`.
- 최신 릴리즈 zip SHA256은 `0794998EAAEE916DAC55DDEA17366A3330141FF56E9ABB2F2502706AB8A526A2`, 플레이테스트 kit SHA256은 `C5B1A754DD01FC8F273FF702F6EFC95935283DC29198C7270219499B1610AA71`, handoff zip SHA256은 `80378B3320D47074CC4FFF60E5465DAAF133BCD21FBBA50DF9AE73F1AD76F009`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_final_store_candidate_decision_audit_coaching_capture_set_final.log`, `checkCount=49`, `passedCheckCount=49`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_final_store_candidate_decision_audit_coaching_capture_set_final.log`, `checkCount=198`, `passedCheckCount=198`, `localBlockerCount=0`.

### 2026-06-02 캠페인 기록/사례 자료실 코칭 왕복 첫 사용 안내

- 캠페인 기록 액션 안내에 `첫 코칭 안내`를 추가하고, 캠페인 기록 상세에는 `첫 사용 안내` 줄을 추가해 코칭 사례에서 압박 패턴을 본 뒤 기록 복귀로 추천 운영/검증 질문을 다시 점검하는 목적을 명시했다.
- 사례 자료실 코칭 포커스 상태줄과 타임라인에는 `첫 사용 안내`, `코칭 왕복 힌트`, `캠페인 기록 왕복`, `기록 복귀`를 함께 남겨 첫 진입 시 이동 경로가 끊기지 않게 했다.
- 14번 상점 후보 스크린샷을 재캡처해 `결정 감사 코칭 포커스: W-207 · 첫 사용 안내 · 코칭 왕복 힌트 · 기록 복귀`가 실제 후보 이미지에서 보이도록 맞췄다.
- 캠페인 기록 스모크: `Logs/runtime_career_record_coaching_first_use_hint_capture_readable.log`, `completed=true`, `detailMentionsCoachingFirstUseHint=true`, `careerRecordActionHintMentionsCoachingFirstUse=true`, `caseArchiveDecisionAuditCoachingStatusMentionsFirstUse=true`, `caseArchiveDecisionAuditCoachingTimelineMentionsFirstUse=true`.
- Windows 빌드/상점 후보 캡처/Steamworks/handoff 재생성: `Logs/build_windows_release_coaching_first_use_hint_capture_readable.log`, `Logs/runtime_store_candidate_graphics_capture_sync.log`, `Logs/prepare_steamworks_coaching_first_use_hint_capture_readable.log`, `Logs/build_external_handoff_coaching_first_use_hint_capture_readable.log`.
- 최신 릴리즈 zip SHA256은 `056F0E3DFBAB4B2DD5B9BAA9685026A405B3DA1B833DBFB9F2AE108254A287C5`, 플레이테스트 kit SHA256은 `1787163D25D189EA9EF7F76A346FB46361C06BDF9D0E3F5EB284AB7A58B46292`, Steamworks zip SHA256은 `5693722AD5A474174305B001708DC09FA5B6EC824376E25FF049B86FF449F853`, handoff zip SHA256은 `42E9A663718845C05DD1AF36686ED148EEB9A5A2C45DE576235C0565E5BAF8F7`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_coaching_first_use_hint_capture_readable.log`, `checkCount=49`, `passedCheckCount=49`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_coaching_first_use_hint_capture_readable.log`, `checkCount=198`, `passedCheckCount=198`, `localBlockerCount=0`.

### 2026-06-02 성과 기록 코칭 첫 사용 보상 패널 연결

- 성과 기록 하단 기록 이동 힌트에 `코칭 W-207 첫 안내`를 추가해 성과 기록의 다음 목표/2·4·6 보상 루프에서도 결정 감사 코칭 사례가 캠페인 기록으로 돌아가는 흐름임을 보여주게 했다.
- 반복 보상 이력 패널에는 `코칭 첫 안내 W-207→기록` 세그먼트를 추가해 보정 후보/비교 연습/성장 성과와 같은 장기 보상 줄에서 코칭 사례 확인을 함께 읽을 수 있게 했다.
- 10번 상점 후보 스크린샷을 재캡처해 성과 기록 화면 하단에 `코칭 W-207 첫 안내`가 보이도록 동기화했다.
- 성과 기록 스모크: `Logs/runtime_achievement_coaching_first_use_reward_panel_visible.log`, `completed=true`, `achievementReplayRewardPanelMentionsDecisionAuditCoachingFirstUse=true`, `achievementRecordLinkHintReadable=true`, `achievementRecordLinkHintMaxDisplayLineWidth=57.3`.
- Windows 빌드/상점 후보 캡처/Steamworks/handoff 재생성: `Logs/build_windows_release_achievement_coaching_first_use_reward_panel_visible.log`, `Logs/runtime_store_candidate_graphics_capture_sync.log`, `Logs/prepare_steamworks_achievement_coaching_first_use_reward_panel_visible.log`, `Logs/build_external_handoff_achievement_coaching_first_use_reward_panel_visible.log`.
- 최신 릴리즈 zip SHA256은 `FBDAB2B471E3381D53F9E062512CF6FE1D0067CD1DE94EFEFCA1CB81C6F67C12`, 플레이테스트 kit SHA256은 `5F9050DEC93822670D8A53F3E4065D3F68CF07B46F31C3AB0B63F3F9A29C26D8`, Steamworks zip SHA256은 `7DC9B0CF2334CC1E6D73467F0743B594F944637584E67ABBBE5F713D9E9A8D81`, handoff zip SHA256은 `A7FFD9A3BDB5D949E5651534F3CDA77A744887204EE270B42EBCC07C0E3F0C44`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_achievement_coaching_first_use_reward_panel_visible.log`, `checkCount=49`, `passedCheckCount=49`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_coaching_first_use_reward_panel_visible.log`, `checkCount=198`, `passedCheckCount=198`, `localBlockerCount=0`.

### 2026-06-02 저해상도 성과 기록 코칭 첫 사용 안내 QA

- 저해상도 UI 스모크가 성과 기록 화면의 `코칭 W-207 첫 안내` 연결을 직접 검증하도록 `achievementRecordLinkHintMentionsCoachingFirstUse`를 추가했다.
- 캠페인 기록 하단 액션 안내는 저해상도에서 넘치지 않도록 `대표/조사/보정 없음/다음 목표/코칭 W-207↔기록/첫코칭` 형태로 압축했다.
- 커리어 기록 스모크: `Logs/runtime_career_record_compact_separators.log`, `completed=true`, `careerRecordActionHintMentionsCoachingFirstUse=true`.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_achievement_coaching_first_use_compact_separators.log`, `completed=true`, `screenshotCount=42`, `careerRecordActionHintReadable=true`, `careerRecordActionHintMaxDisplayLineWidth=66.8`, `achievementRecordLinkHintReadable=true`, `achievementRecordLinkHintMentionsCoachingFirstUse=true`, `achievementRecordLinkHintMaxDisplayLineWidth=57.3`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Windows 빌드/Steamworks/handoff 재생성: `Logs/build_windows_release_low_resolution_achievement_coaching_first_use_compact_separators.log`, `Logs/prepare_steamworks_low_resolution_achievement_coaching_first_use_compact_separators.log`, `Logs/build_external_handoff_low_resolution_achievement_coaching_first_use_compact_separators.log`.
- 최신 릴리즈 zip SHA256은 `9E382425D98A49412EBD9FE3CDCFC994BE8697C7C05153EB768F921C08476B9D`, 플레이테스트 kit SHA256은 `F69B5ED1598CD38CDB8F176460D17A2A166521C9C99A9475AF99F6C3D979FCAA`, Steamworks zip SHA256은 `E7596F83AF88CA898B3C2FF196F2DC0A74A9B894DAB0FFA2F820E25E25A551A4`, handoff zip SHA256은 `6B69D6E841FA12210A422F5E40E5413A8933FFDB22B99583217E43036C2733E7`이다.

### 2026-06-02 컨트롤러 포커스 코칭 첫 사용 왕복 QA

- 컨트롤러 포커스 이동 스모크가 성과 기록의 `코칭 W-207 첫 안내` 힌트와 반복 기록 버튼의 캠페인 기록 진입을 직접 검증하도록 확장됐다.
- 사례 자료실에서는 `코칭 W-207` 버튼을 패드 포커스 대상으로 잡고, 첫 사용 안내/코칭 왕복 힌트가 붙은 사례 상세로 들어간 뒤 `기록 복귀` 버튼 포커스로 같은 캠페인 기록 상세로 돌아오는지 확인한다.
- 포커스 스모크: `Logs/runtime_focus_coaching_first_use_round_trip.log`, `completed=true`, `achievementRecordLinkHintMentionsCoachingFirstUse=true`, `achievementCoachingRecordButtonOpensCareerRecord=true`, `caseArchiveDecisionAuditCoachingButtonFocusable=true`, `caseArchiveDecisionAuditCoachingButtonOpensFirstUseCase=true`, `caseArchiveDecisionAuditCoachingReturnButtonFocusable=true`, `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`.
- Windows 빌드/Steamworks/handoff 재생성: `Logs/build_windows_release_focus_coaching_first_use_round_trip.log`, `Logs/prepare_steamworks_focus_coaching_first_use_round_trip_hash_sync.log`, `Logs/build_external_handoff_focus_coaching_first_use_round_trip_hash_sync.log`.
- 최신 릴리즈 zip SHA256은 `72939B52F5A97D99564442453E0F3D3944FD27ADF4197B69095D0593E8CE7924`, 플레이테스트 kit SHA256은 `39C7EF9846B90112B8C9770F2D419CC6B11B6AAF1516A0024531075BE223945D`, Steamworks zip SHA256은 `7634797BFA34896D0BF9EF5B155CFDE1E25CC89E23E83E295D0FE23B9AD7DF20`, handoff zip SHA256은 `7B8D3EFBCA85A3AD2DE80685D43C667866D3E3774B2C35D71C7F84E5FE94972B`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_focus_coaching_first_use_round_trip_hash_sync.log`, `checkCount=49`, `passedCheckCount=49`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_focus_coaching_first_use_round_trip.log`, `checkCount=198`, `passedCheckCount=198`, `localBlockerCount=0`.

### 다음 개발 단위

### 2026-06-02 상점 후보 결정 감사 코칭 증거 묶음 QA

- Steam 마케팅 자산 감사 기준을 후보 스크린샷 5장 고정에서 실제 후보 파일 배열 6장 기준으로 바꿨다.
- 14번 `case_archive_decision_audit_coaching_focus.png`가 해시 manifest, 후보 manifest, 승격 기준표, Store Presence 선택 manifest에서 같은 `코칭 W-207` 첫 사용 왕복 증거로 잡히도록 연결했다.
- 마케팅 자산 감사: `Logs/audit_marketing_assets_coaching_candidate_evidence.log`, `completed=true`, `storeCandidateScreenshotCount=6`, `validStoreCandidateScreenshotCount=6`, `storeCandidateDecisionAuditCoachingFocusVisualChecked=true`, `checkCount=49`, `passedCheckCount=49`.
- Steamworks 재생성: `Logs/prepare_steamworks_coaching_candidate_marketing_evidence.log`.
- 최신 릴리즈 zip SHA256은 `72939B52F5A97D99564442453E0F3D3944FD27ADF4197B69095D0593E8CE7924`, 플레이테스트 kit SHA256은 `39C7EF9846B90112B8C9770F2D419CC6B11B6AAF1516A0024531075BE223945D`, Steamworks zip SHA256은 `C0FED9D9070F08A2499995F4FB1AD2B378DCA5E07CE2B796AE9E767B3F0C6259`, handoff zip SHA256은 `7B8D3EFBCA85A3AD2DE80685D43C667866D3E3774B2C35D71C7F84E5FE94972B`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_coaching_candidate_marketing_evidence.log`, `checkCount=49`, `passedCheckCount=49`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_coaching_candidate_marketing_evidence.log`, `checkCount=198`, `passedCheckCount=198`, `localBlockerCount=0`.

### 다음 개발 단위

### 2026-06-02 Store Presence 14번 코칭 후보 handoff 노출 QA

- Store Presence QA 카드 준비 절차에 `결정 감사 코칭 보조 후보` 단계를 추가해 `STORE_PRESENCE_SELECTION_KO.md`의 `decision_audit_coaching_candidate_evidence`가 14번 후보와 `코칭 W-207` 왕복 증거를 가리키는지 확인하게 했다.
- 외부 handoff `README_KO.txt`의 첫 확인 항목과 Store Presence 증거 작성 순서, Steamworks `README_STEAMWORKS_KR.txt`의 검수 순서에 `caseArchiveDecisionAuditCoachingButtonOpensFirstUseCase=true`와 `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`를 직접 노출했다.
- Steamworks zip 내부 `README_STEAMWORKS_KR.txt`, `README_KO.txt`, `STORE_PRESENCE_QA_CARD_KO.md`, `store_page/STORE_PRESENCE_SELECTION_KO.md`와 handoff zip 내부 README/QA 카드가 같은 14번 후보 키를 포함하는지 확인했다.
- 최신 릴리즈 zip SHA256은 `72939B52F5A97D99564442453E0F3D3944FD27ADF4197B69095D0593E8CE7924`, 플레이테스트 kit SHA256은 `39C7EF9846B90112B8C9770F2D419CC6B11B6AAF1516A0024531075BE223945D`, Steamworks zip SHA256은 `4E7A591A8563C9C68A24AD6C5E02623F0D0433FC772428C05B08483FAE179E5B`, handoff zip SHA256은 `68F5EE7D32505C4C7BB1089C940A5551AFCAAF87D154689B377D847C63F75C87`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_coaching_candidate_exposure.log`, `checkCount=53`, `passedCheckCount=53`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_coaching_candidate_exposure_retry.log`, `checkCount=199`, `passedCheckCount=199`, `localBlockerCount=0`.

### 다음 개발 단위

### 2026-06-02 Store Presence 실제 증거 초안 14번 코칭 후보 입력란 QA

- `Builds/Handoff/v0.3.0/Evidence/STORE_PRESENCE.md`에 `decision_audit_coaching_candidate_evidence`, `decision_audit_coaching_candidate_file`, `decision_audit_coaching_candidate_case`, `decision_audit_coaching_candidate_round_trip` 입력란을 추가했다.
- `STORE_PRESENCE_EXAMPLE.md`, `Evidence/_templates/STORE_PRESENCE.md`, `Evidence/README_KO.md`에도 같은 입력란과 기준값 `14_case_archive_decision_audit_coaching_focus.png`, `코칭 W-207`, `caseArchiveDecisionAuditCoachingButtonOpensFirstUseCase=true`, `caseArchiveDecisionAuditCoachingReturnOpensCareerRecord=true`를 넣었다.
- 실제 Store Presence 외부 게이트 통과 조건도 `decision_audit_coaching_candidate_evidence`, 14번 파일명, `코칭 W-207`이 없으면 통과하지 않도록 강화했다.
- 최신 릴리즈 zip SHA256은 `72939B52F5A97D99564442453E0F3D3944FD27ADF4197B69095D0593E8CE7924`, 플레이테스트 kit SHA256은 `39C7EF9846B90112B8C9770F2D419CC6B11B6AAF1516A0024531075BE223945D`, Steamworks zip SHA256은 `260B82781B326D729C70E6A1FC885B4F91F0B5AA3D8B904CA692B494128C04C5`, handoff zip SHA256은 `AB96C5644B32A38EA6C7A54D4CB8694AFE0B99F149E6968675630B5813206EC6`이다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_evidence_coaching_candidate_fields.log`, `completed=true`, `gateCount=10`, `pendingGateCount=10`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_evidence_coaching_candidate_fields.log`, `checkCount=55`, `passedCheckCount=55`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_evidence_coaching_candidate_fields.log`, `checkCount=200`, `passedCheckCount=200`, `localBlockerCount=0`.

### 2026-06-02 Store Presence 작성 완료 전 자체점검 표 QA

- Evidence README와 Store Presence QA 카드에 `STORE_PRESENCE.md 작성 완료 전 자체점검` 표를 추가했다.
- 자체점검 행은 `Steamworks URL/화면 캡처`, `SHA 확인`, `공식/승격 후보`, `14번 코칭 후보`, `토스트 UI 캡처`, `A/B 응답 회수`를 기준으로 잡아 수동 입력자가 실제 Store Presence 작성 전 빠뜨린 항목을 바로 확인하게 했다.
- handoff zip SHA256은 `8F3DFD5A0040C2ADADD4FF5BD64C446584AA62A58CBB443833B15BD40194CCF8`, Steamworks zip SHA256은 `6BF872946369DAE40093888236C66408C83B8FF1080426B582C9B22A5BB2FD87`이다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_completion_checklist.log`, `completed=true`, `gateCount=10`, `pendingGateCount=10`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_checklist.log`, `checkCount=59`, `passedCheckCount=59`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_checklist.log`, `checkCount=202`, `passedCheckCount=202`, `localBlockerCount=0`.

### 2026-06-02 Store Presence 실제 증거 초안 자체점검 TODO QA

- `STORE_PRESENCE.md`에 `작성 완료 전 자체점검 TODO` 섹션을 추가해 `Steamworks URL/화면 캡처`, `SHA 확인`, `공식/승격 후보`, `14번 코칭 후보`, `토스트 UI 캡처`, `A/B 응답 회수` 체크행을 실제 입력란 바로 위에 배치했다.
- `STORE_PRESENCE_EXAMPLE.md`에는 같은 항목의 완료 예시를 추가해 초안 체크행과 실제 작성 예시가 한 문서 묶음에서 왕복되도록 했다.
- handoff zip SHA256은 `72EAEF87F26E274C564A3A26F4C3EF3C7254E8099049B3C42BA8742A102D61F6`, Steamworks zip SHA256은 `F1DD5EDA4B0072B19E03C8E650B1965495E7FD4D5666287087026780BB430CFB`이다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_draft_completion_todo.log`, `gateCount=10`, `pendingGateCount=10`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_draft_completion_todo_final.log`, `checkCount=61`, `passedCheckCount=61`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_draft_completion_todo_final.log`, `checkCount=203`, `passedCheckCount=203`, `localBlockerCount=0`.

### 2026-06-02 Store Presence 자체점검 TODO tracker/README 요약 QA

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `STORE_PRESENCE` `evidence_hint`에 `completion_todo=작성 완료 전 자체점검 TODO`와 `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`를 추가했다.
- `README_STEAMWORKS_KR.txt`의 Store Presence 증거 묶음 상태와 검수 순서에도 같은 TODO 요약을 노출해, 외부 입력자가 Steamworks 폴더 첫 화면에서 미완료 체크행을 바로 찾을 수 있게 했다.
- handoff zip SHA256은 `710AAFCDEE536D3BB54B05A8B313E49C736A736637C6AE180D39CBCE19B055C0`, Steamworks zip SHA256은 `96BC5EC492608DD656075E546191480AECAF7C22850C1DEEF0DA98C0BB96B8F7`이다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_completion_todo_tracker_summary.log`, `gateCount=10`, `pendingGateCount=10`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_tracker_summary_final2.log`, `checkCount=63`, `passedCheckCount=63`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_tracker_summary_final2.log`, `checkCount=205`, `passedCheckCount=205`, `localBlockerCount=0`.

### 2026-06-02 Steam 제출 전 자체점검 Store Presence TODO 요약 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 외부 검증 핸드오프 섹션에 `외부 검증 Store Presence 자체점검 TODO 요약` 체크를 추가했다.
- 체크 증거는 `README_STEAMWORKS_KR.txt + EXTERNAL_RELEASE_GATE_TRACKER.csv + Evidence/STORE_PRESENCE.md completion_todo=작성 완료 전 자체점검 TODO`로 잡아 README/tracker/preflight가 같은 미완료 체크행을 가리키게 했다.
- handoff zip SHA256은 `226773D85EC6C10D064CB23DFF76F321AAE5087F7A7971D1BB9A8AD776C06225`, Steamworks zip SHA256은 `F34CD137185BD949E64498893B6AB6C238210AEBFA0529A957E35EC37E76337C`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_preflight_summary.log`, `checkCount=64`, `passedCheckCount=64`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_preflight_summary.log`, `checkCount=206`, `passedCheckCount=206`, `localBlockerCount=0`.

### 2026-06-02 릴리즈 후보 감사 Store Presence TODO 요약 QA

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 `자체점검 TODO 요약`을 추가했다.
- 릴리즈 후보 Markdown `care_review_release_candidate_audit.md`에도 같은 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`를 표시하도록 했다.
- handoff zip SHA256은 `773FF247153A0BD78C0CEB42866E0E2DC4AD1B6D29F49C634CE1BB8D57E828EE`, Steamworks zip SHA256은 `20BE255CB47E0501B838D2F1FC82E72D979976167E67635EE2750455FD7749E5`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_release_note_summary.log`, `checkCount=64`, `passedCheckCount=64`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_release_note_summary.log`, `checkCount=207`, `passedCheckCount=207`, `localBlockerCount=0`.

### 2026-06-02 Steamworks upload manifest Store Presence TODO 요약 QA

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence evidence draft` 줄에 `completion_todo=작성 완료 전 자체점검 TODO`를 추가했다.
- 같은 줄에 `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`를 넣어 upload manifest, 감사 노트, preflight가 같은 미완료 행을 참조하게 했다.
- handoff zip SHA256은 `77889227CF0B58F85360E2636BD5C054E7CA6D6B9D03D37B15F60B882CE95A74`, Steamworks zip SHA256은 `0DBBB4366594DF51D4E8E6DE00EC295A8993FF88D45C68FD67D9B1BEA605A106`이다.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_upload_manifest_summary.log`, `checkCount=65`, `passedCheckCount=65`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_upload_manifest_summary.log`, `checkCount=208`, `passedCheckCount=208`, `localBlockerCount=0`.

### 2026-06-02 Store Presence TODO 요약 문서 필수 조건 QA

- 릴리즈 후보 감사에 Steamworks 업로드 준비 문서용 `Store Presence TODO 요약 필수 조건` 체크를 추가했다.
- 플레이테스트 QA 패킷에도 같은 필수 조건 체크를 추가해 `실제 증거 초안 자체점검 TODO`, `tracker/README 자체점검 TODO 요약`, `제출 전 자체점검 TODO 요약`, `릴리즈 감사 노트 TODO 요약`, `upload manifest TODO 요약` 중 하나라도 문서에서 빠지면 실패하게 했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_docs_required_final.log`, `checkCount=210`, `passedCheckCount=210`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_docs_required_final.log`, `checkCount=65`, `passedCheckCount=65`.

### 2026-06-02 외부 게이트 감사 Store Presence row TODO evidence summary QA

- 외부 게이트 감사 `STORE_PRESENCE` row의 `evidence_summary`에 `completion_todo=작성 완료 전 자체점검 TODO`를 추가했다.
- CSV, summary JSON, Markdown row에서 `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`를 확인하도록 릴리즈 후보 감사를 강화했다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_completion_todo_row_summary.log`, `gateCount=10`, `pendingGateCount=10`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_row_summary.log`, `checkCount=211`, `passedCheckCount=211`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_row_summary.log`, `checkCount=65`, `passedCheckCount=65`.

### 2026-06-02 외부 게이트 스모크 Store Presence TODO evidence summary 상호참조 QA

- 외부 게이트 스모크 JSON에 `hasStorePresenceCompletionTodoEvidenceSummary=true`를 추가했다.
- `storePresenceCompletionTodoCrossReference`는 `EXTERNAL_RELEASE_GATE_TRACKER.csv; care_review_external_gate_audit.csv; STEAM_SUBMISSION_PREFLIGHT_KO.md; completion_todo=작성 완료 전 자체점검 TODO`를 기록한다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_completion_todo_smoke_summary.log`, `gateCount=10`, `pendingGateCount=10`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_smoke_summary.log`, `checkCount=212`, `passedCheckCount=212`, `localBlockerCount=0`.

### 2026-06-02 Steam 제출 전 자체점검 최상단 Store Presence TODO 요약 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 `최상단 판정 요약`에 `Store Presence 자체점검 TODO 요약` 줄을 추가했다.
- 최상단에서 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `Evidence/STORE_PRESENCE.md`, `외부 검증 Store Presence 자체점검 TODO 요약`을 바로 확인한다.
- Steamworks zip SHA256은 `16F5B9B318E77B3C4CE4D499CA574580A8108C6EF30EDA8EAFB2B725CA62AF64`, handoff zip SHA256은 `F2016DC752D6C8F610DD5924DC909921FE44BCC237DB5C7962065D99F17C3A4D`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_preflight_top_summary.log`, `checkCount=213`, `passedCheckCount=213`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_preflight_top_summary_final.log`, `checkCount=66`, `passedCheckCount=66`.

### 2026-06-02 Steamworks README 첫 섹션 Store Presence TODO 요약 QA

- `README_STEAMWORKS_KR.txt`의 `Store Presence 증거 묶음 상태` 첫 섹션에 `제출 전 TODO 첫 확인` 줄을 추가했다.
- README 첫 화면에서 `completion_todo=작성 완료 전 자체점검 TODO`, `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `최상단 판정 요약`, `Store Presence 자체점검 TODO 요약`을 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `Steamworks README 첫 섹션 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `F7F15F1EC6E75AF3646F5949314BDEFB38A5CBB69F58F8F0A83D7380E24B6484`, handoff zip SHA256은 `E95D4AE7D155CDF4D34DEC58DF401102693393550AFA997E01ED93DCED27FE5D`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_readme_top_summary.log`, `checkCount=214`, `passedCheckCount=214`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_readme_top_summary_final.log`, `checkCount=67`, `passedCheckCount=67`.

### 2026-06-02 외부 handoff README 첫 확인 Store Presence TODO 요약 QA

- `README_KO.txt`의 `첫 확인 항목`에 `handoff TODO 첫 확인` 줄을 추가했다.
- handoff README 첫 화면에서 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `Evidence/STORE_PRESENCE.md`, `README_STEAMWORKS_KR.txt`, `제출 전 TODO 첫 확인`을 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `handoff README 첫 확인 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `72935FBFE7AD7BC707818DD4F020B9E7CD22F9FB813A48DB20F75E9051A318CC`, handoff zip SHA256은 `AAB77DAA1F3631AA9848620AFCAA8D620A298850F92C9B1B8B908A28E7A1F886`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_handoff_readme_first_check.log`, `checkCount=215`, `passedCheckCount=215`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_handoff_readme_first_check_final.log`, `checkCount=69`, `passedCheckCount=69`.

### 2026-06-02 외부 handoff 문서 Store Presence TODO 최상단 요약 QA

- `EXTERNAL_RELEASE_HANDOFF_KO.md`의 `Store Presence 증거 초안 상태` 섹션에 `자체점검 TODO 요약` 줄을 추가했다.
- handoff 본문 첫 Store Presence 섹션에서 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `README_KO.txt`, `handoff TODO 첫 확인`, `README_STEAMWORKS_KR.txt`, `제출 전 TODO 첫 확인`을 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `handoff 문서 최상단 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `338A4918CDF10916361CE586DC14AA16F4FCA4E20716F0A7B4FAFB43977438BA`, handoff zip SHA256은 `2E6D4C6C4331B9D414BF3B9E4A7C8E7A5450EC190EC92C8E66ABE0E4AC778A68`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_handoff_doc_top_summary.log`, `checkCount=216`, `passedCheckCount=216`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_handoff_doc_top_summary_final.log`, `checkCount=71`, `passedCheckCount=71`.

### 2026-06-02 Store Presence QA 카드 첫 섹션 TODO 요약 QA

- `STORE_PRESENCE_QA_CARD_KO.md`의 `준비` 섹션 첫 줄에 `자체점검 TODO 요약`을 추가했다.
- QA 카드만 열어도 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `EXTERNAL_RELEASE_HANDOFF_KO.md`, `README_KO.txt`, `handoff TODO 첫 확인`을 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `QA 카드 첫 섹션 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `9B66D3F178109C7A087435211B3C38070C1E31933E7E8D6B6D299EC27C74D105`, handoff zip SHA256은 `816B851201EDC414EC7DC6CBDC60CFBF3D69CC4F4014D37AE2219DAB16402A13`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_qa_card_top_summary.log`, `checkCount=217`, `passedCheckCount=217`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_qa_card_top_summary_final.log`, `checkCount=73`, `passedCheckCount=73`.

### 2026-06-02 Evidence README Store Presence TODO 요약 QA

- `Evidence/README_KO.md`의 `Store Presence 증거 작성` 첫 섹션에 `자체점검 TODO 요약`을 추가했다.
- 증거 폴더 진입점에서 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `STORE_PRESENCE_QA_CARD_KO.md`, `STORE_PRESENCE.md`, `작성 완료 전 자체점검 TODO`를 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `Evidence README 첫 섹션 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `FCD28E03367E2EB11E4261DF17DFF5E1850D25571A4C0C2D1A09C198A098CD36`, handoff zip SHA256은 `F0EAD57D1FD5BAB2665C200429C3E72D63E473511238970498DA54232BCF685F`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_evidence_readme_summary.log`, `checkCount=218`, `passedCheckCount=218`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_evidence_readme_summary_final.log`, `checkCount=75`, `passedCheckCount=75`.

### 2026-06-02 Store Presence 초안 통과 전 TODO 요약 QA

- `Evidence/STORE_PRESENCE.md`의 `통과 전 확인` 섹션에 `자체점검 TODO 요약`을 추가했다.
- 실제 초안 파일 첫 확인에서 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `Evidence/README_KO.md`, `STORE_PRESENCE_QA_CARD_KO.md`를 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `STORE_PRESENCE.md 통과 전 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `217CEF5AC74B27AB664457D58666E6FE41D19E52AA1CBD3F1995616BE336D044`, handoff zip SHA256은 `4A7D6BDF303648A90110D4A47DA0C207603AF78D0ABD0689CCB1B794AEB0678F`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_store_presence_draft_prepass_summary.log`, `checkCount=219`, `passedCheckCount=219`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_store_presence_draft_prepass_summary_final.log`, `checkCount=77`, `passedCheckCount=77`.

### 2026-06-02 Store Presence 예시 통과 전 TODO 요약 QA

- `Evidence/STORE_PRESENCE_EXAMPLE.md`의 `작성 순서`에 `자체점검 TODO 요약 예시` 줄을 추가했다.
- 예시 파일에서도 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `STORE_PRESENCE.md`, `통과 전 확인`, `Evidence/README_KO.md`를 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `STORE_PRESENCE_EXAMPLE.md TODO 예시 요약`을 추가했다.
- Steamworks zip SHA256은 `79E03D63616F76DD708EC78E3D41C5ACF44698B4ED1A29BC651B43090EC88759`, handoff zip SHA256은 `FB08AC9B1B36B4CF5D57743F33824C3071A4E15020EF5893AC8E1C8CA4591326`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_store_presence_example_summary.log`, `checkCount=220`, `passedCheckCount=220`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_store_presence_example_summary_final.log`, `checkCount=79`, `passedCheckCount=79`.

### 2026-06-02 Store Presence 템플릿 TODO 요약 QA

- `Evidence/_templates/STORE_PRESENCE.md`의 `후보 스크린샷 A/B 판정` 섹션에 `자체점검 TODO 요약 템플릿` 줄을 추가했다.
- 템플릿에서도 `completion_todo=작성 완료 전 자체점검 TODO`, `completion_todo_items=Steamworks URL/화면 캡처|SHA 확인|14번 코칭 후보|A/B 응답 회수`, `Evidence/STORE_PRESENCE.md`, `통과 전 확인`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `자체점검 TODO 요약 예시`를 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `STORE_PRESENCE 템플릿 TODO 요약`을 추가했다.
- Steamworks zip SHA256은 `8B810461E3BF8E4D4CEC28DB7B345FD3FDB23C76659D95A77CF1C557A997D99F`, handoff zip SHA256은 `606858675659CB2182E6D1658DDB63973FA63AEA59A52C8B70DFEDE76247469F`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_completion_todo_store_presence_template_summary.log`, `checkCount=221`, `passedCheckCount=221`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_completion_todo_store_presence_template_summary_final.log`, `checkCount=81`, `passedCheckCount=81`.

### 2026-06-02 외부 게이트 스모크 Store Presence 템플릿 TODO 요약 QA

- `care_review_external_gate_audit_smoke_result.json`에 `hasStorePresenceTemplateCompletionTodoSummary=true`를 추가했다.
- 이 필드는 `Evidence/_templates/STORE_PRESENCE.md`의 `자체점검 TODO 요약 템플릿`과 기존 `hasStorePresenceCompletionTodoEvidenceSummary=true`가 모두 맞을 때 true가 된다.
- 외부 게이트 감사 스모크: `Logs/audit_external_release_gates_store_presence_template_completion_todo_smoke.log`, `gateCount=10`, `pendingGateCount=10`.
- Steamworks zip SHA256은 `9FCDFCFB1714D1373EC8273DDDDD474BCC4CF862D09A97051A4B232D01AFCA39`, handoff zip SHA256은 `C3B10C673A4A94409C8CAE5707928A8EDD529CED3D8CD16CF6E9F361B9801723`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_template_completion_todo_smoke.log`, `checkCount=222`, `passedCheckCount=222`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_template_completion_todo_smoke_final.log`, `checkCount=81`, `passedCheckCount=81`.

### 2026-06-02 릴리즈 후보 감사 Markdown Store Presence 템플릿 TODO 최상단 요약 QA

- `care_review_release_candidate_audit.md`의 `Store Presence 실제 증거 초안 상태` 최상단에 `증거 템플릿` 줄을 추가했다.
- 릴리즈 후보 감사 Markdown 첫 Store Presence 섹션에서 `Evidence/_templates/STORE_PRESENCE.md`, `자체점검 TODO 요약 템플릿`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `Evidence/STORE_PRESENCE.md`를 한 번에 대조한다.
- Steamworks zip SHA256은 `38A560E72B2EF89100AC2B399589345F6D5B1B004DD0481017A17BC88936FD5F`, handoff zip SHA256은 `68EBCBC523616D0CAC9A43CDF4EDE55BE8270AEF804F6BC3956169691282D2E4`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_markdown_template_todo_top_summary.log`, `checkCount=223`, `passedCheckCount=223`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_markdown_template_todo_top_summary_final.log`, `checkCount=81`, `passedCheckCount=81`.

### 2026-06-02 Steamworks 릴리즈 후보 감사 노트 Store Presence 템플릿 TODO 최상단 요약 QA

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 `Store Presence 실제 증거 초안 상태` 섹션에 `증거 템플릿` 줄을 추가했다.
- Steamworks 감사 노트에서도 `Evidence/_templates/STORE_PRESENCE.md`, `자체점검 TODO 요약 템플릿`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `Evidence/STORE_PRESENCE.md`를 한 번에 대조한다.
- Steamworks zip SHA256은 `3DB044A075875CB08ECD417D0E84C68FC41F15A827BC49C3A2E08704C97C330A`, handoff zip SHA256은 `D8F147A56F307DA07FF84A0C80359A03DAE65E4189D7C0C0DF90E28EDB168132`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_note_template_todo_top_summary.log`, `checkCount=224`, `passedCheckCount=224`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_note_template_todo_top_summary_final.log`, `checkCount=81`, `passedCheckCount=81`.

### 2026-06-02 Steam 제출 프리플라이트 Store Presence 감사 노트 템플릿 TODO 역참조 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 외부 검증 섹션에 `외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조` 체크를 추가했다.
- 체크 증거는 `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `Evidence/_templates/STORE_PRESENCE.md`, `자체점검 TODO 요약 템플릿`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `Evidence/STORE_PRESENCE.md`를 같은 역참조 줄로 묶는다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `감사 노트 템플릿 TODO 역참조`를 추가했다.
- Steamworks zip SHA256은 `5EA41BBB965F95D8C76C9DFEDF7EA2D75E0C013BEFBB2ACE78BD8F2E0F11F739`, handoff zip SHA256은 `AC682B3D3FD4BE515D97845D1E4D16311FC95070FE69D12F1FF0499FC0189A50`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_preflight_note_template_todo_backref.log`, `checkCount=225`, `passedCheckCount=225`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_preflight_note_template_todo_backref_final.log`, `checkCount=82`, `passedCheckCount=82`.

### 2026-06-02 Steamworks README Store Presence 감사 노트 템플릿 TODO 역참조 QA

- `README_STEAMWORKS_KR.txt` 첫 섹션 `Store Presence 증거 묶음 상태`에 `감사 노트 템플릿 TODO 역참조` 줄을 추가했다.
- README 첫 화면에서 `STEAM_SUBMISSION_PREFLIGHT_KO.md`, `외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`, `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `자체점검 TODO 요약 템플릿`을 바로 대조한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `Steamworks README 감사 노트 템플릿 TODO 역참조`를 추가했다.
- Steamworks zip SHA256은 `DDC4D7DBFFFEE81711885E95DB508166040740DAAE60ABF40F556633416DA865`, handoff zip SHA256은 `28FA33457B3AEDD211F0819AE73DCEEFB967EB562A6756A77647B5026B403FE0`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_readme_note_template_todo_backref.log`, `checkCount=226`, `passedCheckCount=226`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_readme_note_template_todo_backref_final.log`, `checkCount=83`, `passedCheckCount=83`.

### 2026-06-02 Steamworks upload manifest Store Presence 감사 노트 템플릿 TODO 역참조 QA

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence evidence draft` 줄에 README/프리플라이트/감사 노트 템플릿 TODO 역참조를 추가했다.
- manifest에서 `README_STEAMWORKS_KR.txt 감사 노트 템플릿 TODO 역참조`, `STEAM_SUBMISSION_PREFLIGHT_KO.md 외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`, `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`, `자체점검 TODO 요약 템플릿`을 바로 확인한다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence TODO 필수 조건에도 `upload manifest 감사 노트 템플릿 TODO 역참조`를 추가했다.
- Steamworks zip SHA256은 `83C5CC811061CCEA8F697271E4DDCB6D047E83CF37D4F2E85178AD2D9C3F5F37`, handoff zip SHA256은 `B362F3C2721781E78DFEAE29C07C9976112A7B1A4BDFF0F9A2C0D5CD7138EF34`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_upload_manifest_note_template_todo_backref.log`, `checkCount=227`, `passedCheckCount=227`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_upload_manifest_note_template_todo_backref_final.log`, `checkCount=84`, `passedCheckCount=84`.

### 2026-06-02 외부 게이트 스모크 Store Presence upload manifest 감사 노트 템플릿 TODO 역참조 QA

- `care_review_external_gate_audit_smoke_result.json`에 `hasStorePresenceUploadManifestNoteTemplateTodoBackReference=true`를 추가했다.
- `storePresenceUploadManifestNoteTemplateTodoCrossReference`는 `STEAMWORKS_UPLOAD_MANIFEST.txt; Store Presence evidence draft; README_STEAMWORKS_KR.txt 감사 노트 템플릿 TODO 역참조; STEAM_SUBMISSION_PREFLIGHT_KO.md 외부 검증 Store Presence 감사 노트 템플릿 TODO 요약 역참조`를 기록한다.
- 외부 게이트 스모크: `Logs/audit_external_release_gates_store_presence_upload_manifest_note_template_todo_smoke.log`, `gateCount=10`, `pendingGateCount=10`.
- Steamworks zip SHA256은 `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff zip SHA256은 `27DEC1DEF8BFB6404452A1360914F08D413CDAAF0C4647232D787597C664C222`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_external_smoke_upload_manifest_note_template_todo_backref.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_external_smoke_upload_manifest_note_template_todo_backref_final.log`, `checkCount=84`, `passedCheckCount=84`.

### 다음 개발 단위

1. 인게임 장기 보상/캠페인 기록 루프의 사용 빈도를 높일 수 있도록 보상 화면 진입 동선을 추가 개선한다.

### 2026-06-02 Paperlogy 인게임 텍스트 폰트 커버리지 QA

- 게임 빌더가 씬의 `koreanFont`에 `Assets/Resources/Fonts/Paperlogy-6SemiBold.ttf`를 지정하고, 런타임도 `Resources.Load<Font>("Fonts/Paperlogy-6SemiBold")`를 우선 로드하는 상태를 확인했다.
- `RunUiCleanupSmokeTest`에 `paperlogyTextFontCoverageApplied`, `paperlogyTextComponentCount`, `paperlogyTextMismatchCount`를 추가해 메뉴/심사/리포트/기록/튜토리얼/오버레이 `Text` 컴포넌트 전체의 폰트 적용을 직접 센다.
- 런타임 UI 정리 스모크: `Logs/runtime_ui_cleanup_paperlogy_text_font_coverage.log`, `completed=true`, `paperlogyFontApplied=true`, `paperlogyTextFontCoverageApplied=true`, `paperlogyTextComponentCount=394`, `paperlogyTextMismatchCount=0`.
- Windows 빌드/패키지/Steamworks/플레이테스트 키트를 새 QA 기준으로 갱신했다. release zip SHA256은 `7CEEF96DE2DD990354986B565FBB86F3F072C01C32D22455B16FD73EF81CEEA4`, playtest kit SHA256은 `EB6A3B45B49C10D6A631DD99BE5AA99154D5C599B350D6F2C68B231985DD156E`.
- Steamworks zip SHA256은 `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff zip SHA256은 `12D49605EB94B3727BDAA0DA565102A9D3F4FFA96CC7833BB826DC7709F8F317`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_paperlogy_text_font_coverage_final.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_paperlogy_text_font_coverage_after_release_audit_sync.log`, `checkCount=84`, `passedCheckCount=84`.

### 2026-06-02 메인 메뉴 성과 기록 진입 동선 QA

- 메인 메뉴 버튼 레일에 `성과 보기` 버튼을 추가해 캠페인 기록을 거치지 않고 성과 기록/다음 목표/반복 기록 루프에 바로 들어갈 수 있게 했다.
- 메뉴 저장 슬롯/설정/종료 버튼 위치를 함께 조정해 새 버튼이 레일 안에 들어가도록 정리했다.
- 컨트롤러 포커스 스모크에 `menuAchievementButtonFocusable`, `menuAchievementSelectionIsButton`, `menuAchievementButtonOpensAchievements`를 추가하고, 릴리즈 후보 감사/Steam 제출 프리플라이트도 새 필드를 요구하도록 강화했다.
- 런타임 포커스 스모크: `Logs/runtime_focus_navigation_menu_achievement_entry.log`, `completed=true`, `menuAchievementButtonFocusable=true`, `menuAchievementButtonOpensAchievements=true`.
- release zip SHA256은 `E87C6AF09D8FBBCA1CF53C9C4B11FDAFD4C8E0EAFD1BCA4B6902974E23B848D7`, playtest kit SHA256은 `CD04A6965B10621EA70BD48A3FE4A6D05959C56831E71909852F9AD38B7277DC`.
- Steamworks zip SHA256은 `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff zip SHA256은 `E86EAE27F091B83096082D74ECE362057EACC2879B90E417FAE39DB71B8CE662`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_menu_achievement_entry.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_menu_achievement_entry.log`, `checkCount=84`, `passedCheckCount=84`.

### 2026-06-02 성과 기록 메뉴 진입 힌트 QA

- 성과 기록 하단의 기록 이동 힌트에 `메뉴 성과` 진입 경로를 추가해 메인 메뉴의 새 `성과 보기` 버튼과 반복 보상/캠페인 기록 필터 흐름이 같은 문구로 연결되게 했다.
- 성과 기록 스모크가 `achievementRecordLinkHintMentionsMenuEntry=true`를 요구하도록 강화하고, 힌트 판독성 기준을 Paperlogy 적용 후 실제 표시 폭에 맞춰 재검증했다.
- 성과 기록 스모크: `Logs/runtime_achievement_menu_entry_hint.log`, `completed=true`, `achievementRecordLinkHintReadable=true`, `achievementRecordLinkHintMentionsMenuEntry=true`, `achievementRecordLinkHintMaxDisplayLineWidth=66.1`.
- Windows 빌드/릴리즈 패키지/Steamworks depot/플레이테스트 키트/외부 handoff를 새 힌트 QA 기준으로 동기화했다. release zip SHA256은 `1673E95BA37E3007663AD6730478C143EB6E29BDB5631B04F82A832DA3D43CC0`, playtest kit SHA256은 `1DEA75F06FECF8442EB7DF9779CAE74B0FDAABD2BBAE2D23D2C9EC11BC6381B7`이다.
- Steamworks zip SHA256은 `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff zip SHA256은 `C153C1F00024257F9E792818489DE76BB51723213E77C4A41A6EF68BF59A772D`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_menu_entry_hint.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_achievement_menu_entry_hint.log`, `checkCount=84`, `passedCheckCount=84`.

### 2026-06-02 메인 메뉴 성과 배지 QA

- 메인 메뉴 상태 박스에 `성과 배지: 10/14 · 다음 성과 사례 재심사 목표 · 반복 0/6 · A/성과 보기` 형식의 짧은 성과 요약을 추가해 성과 기록 진입 이유를 메뉴 첫 화면에서 바로 보이게 했다.
- 메인 메뉴 목표 사례 스모크가 `menuMentionsAchievementBadge=true`, `menuAchievementBadgeMentionsReplayProgress=true`를 요구하도록 강화하고, Steam 제출 프리플라이트와 릴리즈 후보 감사에도 같은 필드를 연결했다.
- 메인 메뉴 스모크: `Logs/runtime_main_menu_achievement_badge_player.log`, `completed=true`, `menuMentionsAchievementBadge=true`, `menuAchievementBadgeMentionsReplayProgress=true`.
- Windows 빌드/릴리즈 패키지/Steamworks depot/플레이테스트 키트/외부 handoff를 새 QA 기준으로 동기화했다. release zip SHA256은 `4D6BBC65B29E4428898D14555B8469E042F76CB8C0BB94342332D371F5AA6D63`, playtest kit SHA256은 `FDC3BFC593641174F338944BC7E6028938B1EBCC4773B9D58633224D11AC50E0`이다.
- Steamworks zip SHA256은 `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff zip SHA256은 `8BC9E214635F8DB07B81E4185894617256C91317DCB51C6131D82D19704DE6B6`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_main_menu_achievement_badge.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_main_menu_achievement_badge_final.log`, `checkCount=84`, `passedCheckCount=84`.

### 2026-06-02 저해상도 메인 메뉴 성과 배지 QA

- 저해상도 UI 스모크에 메인 메뉴 성과 배지 판독성 검사를 추가해 1280/1600/1920 해상도 캡처에서 `성과 배지`, `다음 성과`, `반복`, `A/성과 보기`가 유지되는지 확인한다.
- 성과 기록 이동 힌트의 저해상도 기준도 `메뉴 성과` 포함과 `achievementRecordLinkHintMentionsMenuEntry=true`로 맞추고, Paperlogy 적용 후 실제 줄 폭 기준을 `<=72`로 정렬했다.
- 저해상도 UI 스모크: `Logs/runtime_low_resolution_main_menu_achievement_badge_player.log`, `completed=true`, `screenshotCount=42`, `mainMenuAchievementBadgeReadable=true`, `mainMenuAchievementBadgeMaxDisplayLineWidth=62.3`, `achievementRecordLinkHintMentionsMenuEntry=true`, `achievementRecordLinkHintMaxDisplayLineWidth=66.1`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`.
- Windows 빌드/릴리즈 패키지/Steamworks depot/플레이테스트 키트/외부 handoff를 새 저해상도 QA 기준으로 동기화했다. release zip SHA256은 `46DA7D5031B9824B74D6DD3E68ECED9FA673B5A776D36C230DB95054835F585F`, playtest kit SHA256은 `523453339BBC0FC90EC7B1935B1F8C74E42587362616FD71AED879E1A3F131C9`이다.
- Steamworks zip SHA256은 `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff zip SHA256은 `CC1168EB5E8C398378FA12B4BFA7330180DA37A44BE4B2D524DD5B3C4114B6E3`이다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_low_resolution_main_menu_achievement_badge.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_low_resolution_main_menu_achievement_badge.log`, `checkCount=84`, `passedCheckCount=84`.

### 2026-06-02 트리아지 담당 화면 성과 배지 증거 QA

- 플레이테스트 상용화 트리아지의 `반복 보상/장기 기록 가치감` 담당 화면 증거에 메인 메뉴 성과 배지와 저해상도 성과 배지 QA를 연결했다.
- `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`, Markdown, HTML, 외부 게이트 감사가 `menuMentionsAchievementBadge=true`, `mainMenuAchievementBadgeReadable=true`, `commercialChecklistMentionsSurfaceActions=true`, `commercialChecklistReadable=true`를 함께 요구한다.
- Store Presence A/B 회수 감사 수치가 현재 회수 산출물 기준 `screenshot_ab_loop_not_collected_count=214`로 바뀐 상태를 반영해 QA 카드, 프리플라이트, release candidate audit, handoff tracker, 외부 게이트 감사 기준을 정렬했다.
- 빌드: `Logs/build_triage_owner_screen_achievement_badge_evidence.log`, `Logs/build_store_presence_ab_loop_colon_alignment.log`.
- 플레이테스트 회수/외부 게이트 감사: `Logs/audit_playtest_collection_triage_achievement_badge_owner_evidence.log`, `Logs/audit_external_gate_store_presence_ab_loop_count_alignment.log`.
- Steamworks/handoff sync: `Logs/prepare_steamworks_store_presence_ab_loop_final_sync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_ab_loop_final_sync.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_after_release_store_presence_ab_loop_final_sync.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `46DA7D5031B9824B74D6DD3E68ECED9FA673B5A776D36C230DB95054835F585F`, playtest kit `523453339BBC0FC90EC7B1935B1F8C74E42587362616FD71AED879E1A3F131C9`, Steamworks `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff `E3A730A8BDA93B91AE5E240AA9A4467D1E1A09AB48AE24201972547A8A923948`.

### 2026-06-02 Store Candidate 메인 메뉴 성과 배지 매트릭스 QA

- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`에 `메인 메뉴 성과 배지 증거` 섹션을 추가해 `menuMentionsAchievementBadge=true`, `mainMenuAchievementBadgeReadable=true`를 Store Presence 후보 평가에도 연결했다.
- `01_main_menu.png`를 공식 기준 화면 행으로 추가하고, 메인 메뉴 성과 배지/다음 성과 목표/`A/성과 보기`가 유지되는 동안 공식 8장 기준 화면으로 남기도록 판정 규칙을 보강했다.
- Steam 제출 릴리즈 감사의 `상점 후보 스크린샷 승격 기준표`가 `01_main_menu.png`, `메인 메뉴 성과 배지`, `menuMentionsAchievementBadge=true`, `mainMenuAchievementBadgeReadable=true`를 요구하도록 강화했다.
- 빌드: `Logs/build_store_candidate_main_menu_badge_matrix.log`.
- Steamworks/handoff sync: `Logs/prepare_steamworks_store_candidate_main_menu_badge_matrix.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_main_menu_badge_matrix.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_candidate_main_menu_badge_matrix.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `46DA7D5031B9824B74D6DD3E68ECED9FA673B5A776D36C230DB95054835F585F`, playtest kit `523453339BBC0FC90EC7B1935B1F8C74E42587362616FD71AED879E1A3F131C9`, Steamworks `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff `E3A730A8BDA93B91AE5E240AA9A4467D1E1A09AB48AE24201972547A8A923948`.

### 2026-06-02 메인 메뉴 성과 목표 힌트 QA

- 메인 메뉴 `성과 보기` 버튼 아래에 `성과 보기 목표: 사례 재심사 목표 · 목표 사례` 형식의 짧은 다음 목표 힌트를 추가해, 성과 기록으로 들어가면 무엇을 해야 하는지 버튼 바로 아래에서 읽히게 했다.
- 메인 메뉴 목표 사례 스모크가 `menuAchievementHintMentionsNextGoalAction=true`, `menuAchievementHintText=성과 보기 목표: 사례 재심사 목표 · 목표 사례`를 요구하도록 강화했다.
- 저해상도 UI 스모크가 `mainMenuAchievementHintReadable=true`, `mainMenuAchievementHintMaxDisplayLineWidth=38.8`, `buttonTextOverflowCount=0`, `offscreenButtonCount=0`을 확인하도록 강화했다.
- 빌드/스모크: `Logs/build_main_menu_achievement_next_goal_hint_lowres_fix.log`, `Logs/runtime_main_menu_achievement_next_goal_hint_fix_player.log`, `Logs/runtime_low_resolution_main_menu_achievement_next_goal_hint_fix_player.log`.
- Steamworks/handoff sync: `Logs/prepare_steamworks_main_menu_achievement_next_goal_hint.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_main_menu_achievement_next_goal_hint.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_main_menu_achievement_next_goal_hint.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `CEDDBDAFFD7F442DC2CDA699671DC86977E6FBB36665554CABEBDF50624610AF`, playtest kit `C6C7ED79F49A1FE9D0721CC845AF5EC39095DD689FB8305EE78C1F40EF8FE61C`, Steamworks `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff `B86F665C3699FAAF31F244CB95F4889355EA488CB6BF80383EE0B012F7CE012D`.

### 2026-06-02 Store Candidate 메인 메뉴 기준 화면 A/B 질문 QA

- `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`에 `main_menu_baseline_candidate: 01_main_menu.png`, `main_menu_baseline_question_id: main_menu_loop_entry`, `메인 메뉴 기준 화면 이해도 질문`을 추가했다.
- 플레이테스트 요청서와 `PLAYTEST_SESSION_INDEX_TEMPLATE.csv`에 `main_menu_loop_entry` 행을 추가해 `01_main_menu.png`와 `12_career_record_next_objective.png` 중 메인 메뉴 성과 보기/다음 목표 힌트가 장기 반복 루프 진입점으로 더 빨리 이해되는지 회수할 수 있게 했다.
- 플레이테스트 집계 스모크가 `csvHasMainMenuAbBaselineQuestion=true`를 요구하고, 회수 감사 수치를 `screenshot_ab_loop_not_collected_count=221`, `decisionAuditCoachingSessionCount=10/221`로 정렬했다.
- 빌드/스모크/회수 감사: `Logs/build_store_candidate_main_menu_ab_question_count_sync.log`, `Logs/runtime_store_candidate_main_menu_ab_question_aggregate.log`, `Logs/audit_playtest_collection_store_candidate_main_menu_ab_question.log`.
- Steamworks/handoff sync: `Logs/prepare_steamworks_store_candidate_main_menu_ab_question_final_sync.log`.
- 외부 게이트 감사: `Logs/audit_external_gate_store_candidate_main_menu_ab_question.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_main_menu_ab_question.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 최신 SHA256: release `E7EA91B54F1213AB301ED9A496ACA90C17414954B06EDBA6E20C895E60AC3197`, playtest kit `86CC0711EEF3FF270584EFD120673E514FD1F4DFF6339C62588755E9C0E17B96`, Steamworks `340692289D344F8324BCF45B95794DB43EDDCBB1E5909654976586382816BF42`, handoff `7806DF7928C376966EE45E10195C80EC94084925EBB8440DE0E816A5D775EB4E`.

### 2026-06-02 Store Candidate 성과/기록 다음 목표 문구 일치 QA

- `achievement_career_copy_alignment` 질문을 Store Candidate A/B 회수 흐름에 추가해 메인 메뉴 `성과 보기 목표` 힌트와 캠페인 기록 `다음 목표`/`목표 재시작` 문구가 같은 장기 반복 행동으로 읽히는지 확인하게 했다.
- 메인 메뉴 목표 사례 스모크가 `menuAchievementHintCareerNextGoalCopyAligned=true`, `careerActionHintAfterGrowth`, `careerNextObjectiveButtonAfterGrowth`를 요구하고, 플레이테스트 집계 스모크가 `csvHasAchievementCareerCopyAlignmentQuestion=true`를 요구하도록 강화했다.
- 플레이테스트 요청서/세션 인덱스/회수 체크리스트, Store Presence QA 카드, Steam 제출 프리플라이트, 외부 handoff/Steamworks 사본, 배포 무결성 감사 기준을 `screenshot_ab_loop_not_collected_count=221`, `decisionAuditCoachingSessionCount=10/221` 기준으로 정렬했다.
- 빌드/스모크/회수 감사: `Logs/build_achievement_career_copy_alignment.log`, `Logs/runtime_achievement_career_copy_alignment_main_menu.log`, `Logs/runtime_achievement_career_copy_alignment_aggregate.log`, `Logs/audit_playtest_collection_achievement_career_copy_alignment.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_achievement_career_copy_alignment_final_retry.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_achievement_career_copy_alignment_final.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `28E3C64F8B2836F272C384377BCDD627181ECF4A8DB291F9B118F0D06DEFD3D7`, playtest kit `62CB28A2AE091FE38C30357EDFDF0803CA305C72AA60BDEB2E8853800FC34C82`, Steamworks `07EB17B0B31A17AB4492AA5E2FF5BEB37B6F9DACD47D7EDF96E6A89566251DA2`, handoff `90770A7E5EEE611B6400F54D09304C856E14594F1245BE663D1EC5D055622744`.

### 2026-06-02 저해상도 Store Candidate 성과/기록 문구 일치 QA

- 저해상도 UI 스모크에 `lowResolutionStoreCandidateCopyAlignmentReadable`을 추가해 메인 메뉴 `성과 보기 목표`, 캠페인 기록 `액션 안내`의 `다음 목표`, 성과 기록 `기록 이동`의 `캠페인 기록 필터` 문구가 1280/1600/1920 캡처 세트에서 함께 읽히는지 검증하게 했다.
- 스모크 JSON에 `lowResolutionStoreCandidateCopyAlignmentSample`을 추가해 실제 확인된 세 문구를 한 줄 증거로 남긴다.
- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`의 `성과-캠페인 루프 증거`와 Steam 제출 프리플라이트/릴리즈 후보 감사의 저해상도 UI QA 체크가 `lowResolutionStoreCandidateCopyAlignmentReadable=true`를 요구하도록 강화했다.
- 빌드/스모크: `Logs/build_low_resolution_store_candidate_copy_alignment.log`, `Logs/runtime_low_resolution_store_candidate_copy_alignment.log`, `completed=true`, `screenshotCount=42`, `lowResolutionStoreCandidateCopyAlignmentReadable=true`.
- Steamworks/handoff sync: `Logs/prepare_steamworks_low_resolution_store_candidate_copy_alignment.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_low_resolution_store_candidate_copy_alignment_final.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_low_resolution_store_candidate_copy_alignment.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `8F2AE90A582E1FE59E9E162CE833740440D525CD6BFD21F794059FD1AB7B727A`, playtest kit `1DF7DF28F08A3FF8824B37EC966CD7BD8908E38D1C6B67BB828AED28BD4435B3`, Steamworks `C8D4BFE1068649C7B5AECE51A2A5C86B1285228A0B2288AD52664EE9E262B0B6`, handoff `0ACCD4D6AABB7F9ED36D07002BB83D685EA593EB80F476F3E89C2DC46DFF4F79`.

### 2026-06-02 반복 가치감 트리아지 설문 축별 작업표 QA

- 10달러 상용화 트리아지의 낮은 `반복 보상/장기 기록 가치감` 응답을 하나의 넓은 항목으로만 두지 않고, `반복 가치 세부: 성과 기록 보상`, `반복 가치 세부: 캠페인 기록 다음 목표`, `반복 가치 세부: 상점 후보 루프 이해` 3개 조치 행으로 세분화했다.
- 각 조치 행에 담당 화면과 증거 범위를 붙였다. 성과 기록 행은 `achievementReplayRewardPanelMentionsRecordLinkHint=true`, 캠페인 기록 행은 `careerRecordActionHintReadable=true`와 `lowResolutionStoreCandidateCopyAlignmentReadable=true`, 상점 후보 행은 `achievement_career_copy_alignment`, `main_menu_loop_entry`, `screenshot_ab_loop_question_id`를 근거로 삼는다.
- 플레이테스트 상용화 트리아지 스모크 JSON에 `hasReplayRewardQuestionBreakdown=true`를 추가하고, Steam 제출 프리플라이트/릴리즈 후보 감사/외부 handoff/배포 무결성 감사가 새 3개 행을 요구하도록 강화했다.
- 빌드/회수 감사: `Logs/build_replay_reward_triage_question_breakdown_rerun.log`, `Logs/audit_playtest_collection_replay_reward_triage_question_breakdown.log`, `actionCount=10`, `hasReplayRewardQuestionBreakdown=true`.
- Steamworks/handoff sync: `Logs/prepare_steamworks_replay_reward_triage_question_breakdown_final_sync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_replay_reward_triage_question_breakdown.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_replay_reward_triage_question_breakdown.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `8F2AE90A582E1FE59E9E162CE833740440D525CD6BFD21F794059FD1AB7B727A`, playtest kit `1DF7DF28F08A3FF8824B37EC966CD7BD8908E38D1C6B67BB828AED28BD4435B3`, Steamworks `C8D4BFE1068649C7B5AECE51A2A5C86B1285228A0B2288AD52664EE9E262B0B6`, handoff `0ACCD4D6AABB7F9ED36D07002BB83D685EA593EB80F476F3E89C2DC46DFF4F79`.

### 2026-06-02 외부 5명 이후 Store Candidate 승격 판정 요약 QA

- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`에 `외부 5명 이후 승격 판정 요약` 섹션과 `post_external_collection_promotion_summary` 행을 추가했다.
- 요약 행은 실제 사람 완전 회수, `screenshot_ab_loop_response_count`, `screenshot_ab_loop_understanding_comment_count`를 함께 보고 `waiting_for_external_5_and_ab_loop_responses` 또는 승격 검토 상태를 판정한다.
- 질문 연결을 `main_menu_loop_entry`, `achievement_career_copy_alignment`, `reward_loop_understanding`으로 명시해 메인 메뉴 기준 화면 유지, 성과/기록 문구 일치, 성과-캠페인 보상 루프 이해도를 한 줄에서 대조하게 했다.
- 승격 기준표 회귀 스모크에 `postExternalPromotionSummaryReady=true`를 추가하고, Steam 제출 프리플라이트/릴리즈 후보 감사가 새 요약 행 토큰을 요구하도록 강화했다.
- 빌드/Steamworks sync: `Logs/build_store_candidate_post_external_promotion_summary.log`, `Logs/prepare_steamworks_store_candidate_post_external_promotion_summary_final_sync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_post_external_promotion_summary.log`, `checkCount=228`, `passedCheckCount=228`, `localBlockerCount=0`, `postExternalPromotionSummaryReady=true`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_candidate_post_external_promotion_summary.log`, `checkCount=84`, `passedCheckCount=84`.
- 최신 SHA256: release `A4F6980D2D176A3AFD33C38D2DE5E838E34C97BF97FFB2164AC626EBF11F0AB4`, playtest kit `E935BF3B8B5B7109F9A5D2768CAC49DC89C1793ED8E2CDA4E6A1AE4C075F2149`, Steamworks `9E44B22852D4F7FB65F55617A266A4649D9261C3479DBA8A0AF9EBA37EB17D84`, handoff `6EAD39038A5BD113AD3FB8CE6B7A2A4062CB2091BEB31984CF522026BB308620`.

### 2026-06-02 Store Presence A/B TODO 매핑 QA

- `STORE_PRESENCE_QA_CARD_KO.md`, `Evidence/README_KO.md`, `Evidence/STORE_PRESENCE.md`, `Evidence/STORE_PRESENCE_EXAMPLE.md`에 `Store Presence A/B TODO 매핑` 표를 추가했다.
- 매핑 표는 `store_presence_ab_todo_mapping` 행에서 `post_external_collection_promotion_summary`를 `A/B 판정`, `selected_upload_set`, `promoted_candidate` 입력란과 직접 연결한다.
- `main_menu_loop_entry`, `achievement_career_copy_alignment`, `reward_loop_understanding` 질문 축을 `screenshot_ab_loop_response_count`, `screenshot_ab_loop_understanding_comment_count`, `screenshot_ab_loop_collection_status` 입력란으로 나눠 Store Presence 초안 TODO가 질문 결과를 바로 받도록 했다.
- Steam 제출 프리플라이트, 릴리즈 후보 감사, 배포 무결성 감사에 `Store Presence A/B TODO 직접 매핑` 검사를 추가했다.
- 빌드/Steamworks sync: `Logs/build_store_presence_ab_todo_mapping_rerun.log`, `Logs/prepare_steamworks_store_presence_ab_todo_mapping_final_sync.log`, `Logs/prepare_steamworks_store_presence_ab_todo_mapping_note_sync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_ab_todo_mapping_done.log`, `checkCount=229`, `passedCheckCount=229`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_ab_todo_mapping_done.log`, `checkCount=85`, `passedCheckCount=85`.
- 최신 SHA256: release `718FF33FAADC837A5ADCCF5AEBF49DD44BDD70BFD19A3E4DBE20AAD863A9735E`, playtest kit `1DA4BD1A8A0309E5A5716E156A933C73F4D9F0D39CB88BB913766B7652B8B25D`, Steamworks `151ED99F7B4173D0A6B6D34A52AA524897BA060057F0DDCA741293DA001701D7`, handoff `CDC7AC35C2770BE6E5440AD5A50FA0E5660B40367F876BB01A0DE29140F19BE3`.

### 2026-06-02 상점 후보 트리아지 우선순위 배지 QA

- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`에 `트리아지 세부 행별 우선순위 배지` 섹션을 추가했다.
- 핵심 후보는 `triage_priority_badge_reward_loop_candidate` / `P0_WAIT_EXTERNAL_AB`로 표시하고, `post_external_collection_promotion_summary`, `reward_loop_understanding`, `screenshot_ab_loop_understanding_comment_count`와 직접 연결했다.
- 메인 메뉴 기준 화면은 `triage_priority_badge_main_menu_baseline` / `P1_BASELINE_GUARD`, 성과-캠페인 문구 일치는 `triage_priority_badge_copy_alignment` / `P1_COPY_ALIGNMENT_COLLECT`로 분리했다.
- 보조 후보 행도 `P2_REWARD_RECORD_COPY`, `P2_APPEAL_REMEDY_LOOP`, `P3_DECISION_COACHING_DEPTH`로 표시해 A/B 회수 전후의 Store Presence 의사결정 우선순위를 읽기 쉽게 만들었다.
- 승격 기준표 회귀 스모크에 `triagePriorityBadgeReady=true`를 추가하고, Steam 제출 프리플라이트/릴리즈 후보 감사/배포 무결성 감사가 새 배지 행과 Steamworks zip 내부 문서를 요구하도록 강화했다.
- 빌드/Steamworks sync: `Logs/build_store_candidate_triage_priority_badge_rerun.log`, `Logs/prepare_steamworks_store_candidate_triage_priority_badge_finalsync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_candidate_triage_priority_badge_done.log`, `checkCount=230`, `passedCheckCount=230`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_candidate_triage_priority_badge_final.log`, `checkCount=86`, `passedCheckCount=86`.
- 최신 SHA256: release `BE503E2772B2340523B032C111B5D1411EF27B0B89FE5E5545C6A14B85D124B3`, playtest kit `EBD6C2556C7E771CEDA6FA6663D3A7582937F7DDABDB8FB29E963CF279AA3113`, Steamworks `B7F37156CFD8DCC37B508D640F0D578D0837CAD2362FE3CA6754DF77C8554948`, handoff `A5EC1980D8A3AF700FD4C30DA945F558544C41BF967F151BFA1D1FD064FEE479`.

### 2026-06-02 Store Presence 이해 코멘트 수 README/manifest 요약 QA

- `README_STEAMWORKS_KR.txt` 첫 섹션의 A/B 응답 회수 보류 줄에 `screenshot_ab_loop_understanding_comment_count=0`를 추가했다.
- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `abLoopInputFields`에 `screenshot_ab_loop_understanding_comment_count`를 포함하고, evidence draft/upload doc cross-check 줄에도 같은 현재값을 넣었다.
- Steam 제출 프리플라이트에 `Steamworks README/manifest A/B 이해 코멘트 수 요약` 체크를 추가했다.
- 릴리즈 후보 감사와 배포 무결성 감사가 README/manifest/사람용 문서에서 `screenshot_ab_loop_understanding_comment_count=0`를 요구하도록 강화했다.
- 사람용 문서 `Docs/Steamworks_업로드_준비.md`, `Docs/플레이테스트_QA_패킷.md`의 Store Presence Draft 독립 체크에도 이해 코멘트 수를 반영했다.
- 빌드/Steamworks sync: `Logs/build_store_presence_understanding_comment_summary.log`, `Logs/prepare_steamworks_store_presence_understanding_comment_summary_finalsync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_understanding_comment_summary_done.log`, `checkCount=230`, `passedCheckCount=230`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_understanding_comment_summary_done.log`, `checkCount=87`, `passedCheckCount=87`.
- 최신 SHA256: release `B6373D7B5398E7556108EAA17AA51E8F848AB6271667510D6651C190366F98F1`, playtest kit `D4E2D8F7E75F720A209BAE9A224AD0430985AB00E36ACAEF003B4CEA9705EDD0`, Steamworks `F95C92BB62DBA72167A58B1566F816D09986863E552D6BF40272C42B93C9B732`, handoff `4EFABE9A6AEE98F4CD1024C10A440973D9C979C3D2C5EC873597A29E9D0BF9CB`.

### 2026-06-02 Store Presence 승격 요약 대조 QA

- `STORE_PRESENCE_QA_CARD_KO.md`에 `외부 5명 이후 승격 요약 대조` 섹션을 추가했다.
- 새 섹션은 `post_external_collection_promotion_summary`를 `selected_upload_set`, `promoted_candidate` 입력란과 바로 연결한다.
- `triage_priority_badge_reward_loop_candidate` / `P0_WAIT_EXTERNAL_AB`를 같은 표에 배치해 외부 5명/A-B 5건 전에는 승격 보류 상태임을 수동 검수자가 먼저 보게 했다.
- `screenshot_ab_loop_response_count`, `screenshot_ab_loop_understanding_comment_count`, `screenshot_ab_loop_collection_status` 현재값을 같은 표에서 확인하고 `Evidence/STORE_PRESENCE.md` 입력란으로 옮기도록 정리했다.
- Steam 제출 프리플라이트, 릴리즈 후보 감사, 배포 무결성 감사에 `post_external_collection_promotion_summary` 대조 섹션 검사를 추가했다.
- 빌드/Steamworks sync: `Logs/build_store_presence_post_external_summary_crosscheck.log`, `Logs/prepare_steamworks_store_presence_post_external_summary_crosscheck_finalsync.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_post_external_summary_crosscheck.log`, `checkCount=230`, `passedCheckCount=230`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_post_external_summary_crosscheck.log`, `checkCount=88`, `passedCheckCount=88`.
- 최신 SHA256: release `6E45947EABA6E2011C6277E3ECE09B851B4EC9BB9AEB7065250C6822F1E0E23F`, playtest kit `9B9864D51089201416DE07143644B173C3311BD3CF29117D3829BA000F109B83`, Steamworks `18B1F13D64EA41EC45867BA786E430927E9C4F625A16FA603F60608B2119F25B`, handoff `EA95258490482F6BE5A9ED5AEF8AB27F692EB74C8EFE351BA9A6B93728981641`.

### 2026-06-02 Store Presence Evidence 우선순위 배지 역참조 QA

- `Evidence/README_KO.md`, `Evidence/STORE_PRESENCE.md`, `Evidence/STORE_PRESENCE_EXAMPLE.md`에 `Store Presence 후보 우선순위 배지 역참조` 표를 추가했다.
- `store_presence_priority_badge_backreference` 행으로 `triage_priority_badge_reward_loop_candidate` / `P0_WAIT_EXTERNAL_AB`를 `selected_upload_set`, `promoted_candidate`, `A/B 판정` 입력란과 직접 연결했다.
- `store_presence_main_menu_baseline_backreference`, `store_presence_copy_alignment_backreference` 행을 추가해 메인 메뉴 기준 화면과 성과-캠페인 문구 일치 검증도 Evidence 작성 단계에서 보이게 했다.
- Evidence 작성 완료 전 자체점검의 `공식/승격 후보` 입력란에 `store_presence_priority_badge_backreference`를 포함했다.
- Steam 제출 프리플라이트, 릴리즈 후보 감사, 배포 무결성 감사에 Evidence 우선순위 배지 역참조 검사를 추가했다.
- 빌드/Steamworks sync: `Logs/build_store_presence_priority_badge_backreference.log`, `Logs/prepare_steamworks_store_presence_priority_badge_backreference.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_priority_badge_backreference.log`, `checkCount=232`, `passedCheckCount=232`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_priority_badge_backreference.log`, `checkCount=89`, `passedCheckCount=89`.
- 최신 SHA256: release `21D1C7B7527EC52CFAEC50FEE9EB40A1906D7CD83E4214B66CC9348A5C4F6CED`, playtest kit `C0039E005CC22CB949010DD8511DA287CE9072CC529EF8130B9A944AC5DD27C2`, Steamworks `CF2AB48848071EA84D51E8B834FEFFF5F5F9B862E28574BF50AB5B8859220D85`, handoff `C4CFAA607F8480CA77EE2AA8C0888F06B5AF3730BC5FE1BC4DDDFFDFAF6FC418`.

### 2026-06-02 Playtest 회수 인덱스 우선순위 배지 컬럼 QA

- `PLAYTEST_SESSION_INDEX_TEMPLATE.csv`에 `triage_priority_badge_id`, `triage_priority_badge_status`, `triage_priority_badge_evidence` 컬럼을 추가했다.
- 샘플 행은 `triage_priority_badge_reward_loop_candidate` / `P0_WAIT_EXTERNAL_AB` / `post_external_collection_promotion_summary`, `triage_priority_badge_main_menu_baseline` / `P1_BASELINE_GUARD` / `main_menu_loop_entry`, `triage_priority_badge_copy_alignment` / `P1_COPY_ALIGNMENT_COLLECT` / `achievement_career_copy_alignment`로 분리했다.
- `PLAYTEST_REQUEST_TEMPLATE_KO.md`와 `COLLECTION_CHECKLIST_KO.md`에 우선순위 배지별 질문 회수 목적과 수동 기록 지시를 추가했다.
- 런타임 플레이테스트 집계 CSV에도 같은 `triage_priority_badge_*` 컬럼을 추가하고, 집계 스모크 JSON에 `csvHasTriagePriorityBadgeColumns`, `csvHasRewardLoopPriorityBadge`, `csvHasMainMenuPriorityBadge`, `csvHasCopyAlignmentPriorityBadge`를 추가했다.
- `STORE_PRESENCE_QA_CARD_KO.md`와 릴리즈/배포 감사가 Playtest 요청서, 수동 CSV 템플릿, 자동 집계 CSV의 우선순위 배지 컬럼을 함께 확인하도록 강화했다.
- 빌드/집계/Steamworks sync: `Logs/build_playtest_triage_priority_badge_columns.log`, `Logs/runtime_playtest_aggregate_triage_priority_badge_columns.log`, `Logs/prepare_steamworks_playtest_triage_priority_badge_columns.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_playtest_triage_priority_badge_columns.log`, `checkCount=232`, `passedCheckCount=232`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_playtest_triage_priority_badge_columns.log`, `checkCount=89`, `passedCheckCount=89`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `92F3F7D2D03B31A7D5E3BA121AAA58BC13566602FCC3A3340991D9CD82BC0335`, handoff `3618D7CB6D1CF186688C00D84CC6A5F40916173698FBCFAE7052DBFFBD494AD7`.

### 2026-06-02 Store Presence Evidence bundle memberSummary 우선순위 배지 요약 QA

- `storePresenceEvidenceBundle.checks.memberSummary`의 A/B 응답 회수 입력란 요약에 `priority_badges=...` 필드를 추가했다.
- 새 요약은 `store_presence_priority_badge_backreference:triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `store_presence_main_menu_baseline_backreference:triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`, `store_presence_copy_alignment_backreference:triage_priority_badge_copy_alignment/P1_COPY_ALIGNMENT_COLLECT`를 한 줄에 담는다.
- 릴리즈 후보 감사의 `ReleaseCandidateStorePresenceEvidenceBundleAbLoopSummaryReady` 검사가 새 `priority_badges` 문자열을 요구하도록 강화했다.
- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`의 JSON memberSummary 설명에도 `store_presence_priority_badge_backreference`, `triage_priority_badge_reward_loop_candidate`, `P0_WAIT_EXTERNAL_AB`를 포함했다.
- Steamworks sync: `Logs/prepare_steamworks_member_summary_priority_badge.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_member_summary_priority_badge.log`, `checkCount=232`, `passedCheckCount=232`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_member_summary_priority_badge.log`, `checkCount=89`, `passedCheckCount=89`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `11DFB2D1EB9A9DC08FBF632AA7FB416ACA66164E4FE62EF63C9C18745E90D579`, handoff `3618D7CB6D1CF186688C00D84CC6A5F40916173698FBCFAE7052DBFFBD494AD7`.

### 2026-06-02 EXTERNAL_RELEASE_HANDOFF Store Presence 우선순위 배지 회수 컬럼 QA

- `EXTERNAL_RELEASE_HANDOFF_KO.md`의 `Store Presence 증거 묶음` 섹션에 `우선순위 배지 수동 회수 컬럼` 요약 줄을 추가했다.
- 새 요약은 `triage_priority_badge_id`, `triage_priority_badge_status`, `triage_priority_badge_evidence`와 `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`, `triage_priority_badge_copy_alignment/P1_COPY_ALIGNMENT_COLLECT`를 함께 보여준다.
- 릴리즈 후보 감사에 `외부 handoff Store Presence 증거 묶음 우선순위 배지 회수 컬럼` 체크를 추가했다.
- 배포 무결성 감사에 handoff 폴더 문서와 handoff zip 문서의 우선순위 배지 회수 컬럼 체크를 각각 추가했다.
- `Docs/Steamworks_업로드_준비.md`, `Docs/플레이테스트_QA_패킷.md`의 Steamworks/handoff zip 크기와 SHA를 최신 패키지로 동기화했다.
- Steamworks sync: `Logs/prepare_steamworks_handoff_priority_badge_columns_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_priority_badge_columns_summary_final.log`, `checkCount=233`, `passedCheckCount=233`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_handoff_priority_badge_columns_summary_final.log`, `checkCount=91`, `passedCheckCount=91`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `CF4DF49AA7E7AE97ED7B410A7B21A095F87EBE7FBDDA5859701BD4519F2A0B3C`, handoff `1A9590ADAEDCF139068C5BD658647043CF3CC76F79F99D138C3283F67056121F`.

### 2026-06-02 Playtest 상용화 actions 우선순위 배지 owner_screen QA

- `PLAYTEST_COMMERCIAL_TRIAGE_ACTIONS.csv`에 우선순위 배지별 owner_screen 행 3개를 추가했다.
- 새 행은 `우선순위 배지: 상점 후보 루프 이해`, `우선순위 배지: 메인 메뉴 기준 화면`, `우선순위 배지: 성과-캠페인 문구 일치`로 분리된다.
- 각 행의 evidence는 `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`, `triage_priority_badge_copy_alignment/P1_COPY_ALIGNMENT_COLLECT`를 담당 화면과 직접 연결한다.
- `BuildPlaytestCommercialTriageSmokeJson`에 `hasPriorityBadgeOwnerScreenActions=true` 검사를 추가하고, CSV/Markdown/HTML 모두 새 배지 행을 요구하도록 강화했다.
- release/distribution 감사의 트리아지 actions CSV 체크가 새 배지 행을 요구하도록 확장했다.
- 회수 감사 이후 `screenshot_ab_loop_not_collected_count`가 변동될 수 있어 tracker 관련 검사는 숫자 고정 대신 필드와 상태 토큰을 확인하도록 보정했다.
- 플레이테스트 회수 감사: `Logs/audit_playtest_collection_priority_badge_owner_screen_actions.log`, `hasPriorityBadgeOwnerScreenActions=true`, `actionCount=13`.
- Steamworks sync: `Logs/prepare_steamworks_priority_badge_owner_screen_actions.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_priority_badge_owner_screen_actions_fixed.log`, `checkCount=233`, `passedCheckCount=233`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_priority_badge_owner_screen_actions_fixed.log`, `checkCount=91`, `passedCheckCount=91`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `CD22AD1640C22874C8DDD00C425FAB27DA5263B561292855D6553E6453621CA0`, handoff `7E361D671C813A6275E40AAD1532E53E9A46D66E5786FA5B060D4017BE48B077`.

### 2026-06-02 Steamworks upload manifest priority badge memberSummary QA

- `STEAMWORKS_UPLOAD_MANIFEST.txt`의 `Store Presence evidence bundle` 줄에 `priority_badges=store_presence_priority_badge_backreference` 요약을 추가했다.
- 새 요약은 `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`, `triage_priority_badge_copy_alignment/P1_COPY_ALIGNMENT_COLLECT`를 release candidate JSON `memberSummary=storePresenceEvidenceBundle.checks.memberSummary`와 같은 줄에서 대조한다.
- Steam 제출 프리플라이트의 `외부 검증 Store Presence 증거 묶음 요약` 체크가 manifest priority badge 토큰을 요구하도록 강화했다.
- 릴리즈 후보 감사의 README/manifest memberSummary 상호참조, manifest 증거 초안 상태, manifest evidence bundle memberSummary 체크가 같은 priority badge 요약을 요구하도록 강화했다.
- 배포 무결성 감사에 `Steamworks upload manifest Store Presence priority badge memberSummary 요약` 체크를 추가했다.
- `Docs/Steamworks_업로드_준비.md`, `Docs/플레이테스트_QA_패킷.md`도 priority badge manifest 요약과 최신 Steamworks zip SHA로 갱신했다.
- Steamworks sync: `Logs/prepare_steamworks_manifest_priority_badge_member_summary.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_manifest_priority_badge_member_summary.log`, `checkCount=233`, `passedCheckCount=233`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_manifest_priority_badge_member_summary.log`, `checkCount=92`, `passedCheckCount=92`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `B3799C5329C8313C78B38859569FD246AE7DB4FFC5C6E3EC699D749735F3BEE9`, handoff `7E361D671C813A6275E40AAD1532E53E9A46D66E5786FA5B060D4017BE48B077`.

### 2026-06-02 Store Presence QA 카드 우선순위 배지 회수 후 처리 상태 QA

- `STORE_PRESENCE_QA_CARD_KO.md`에 `우선순위 배지 외부 회수 후 처리 상태` 표를 추가했다.
- 표는 `priority_badge_id`, `after_collection_status`, `manual_update_target`, `completion_gate`, `next_action`으로 나뉜다.
- `triage_priority_badge_reward_loop_candidate`는 `P0_WAIT_EXTERNAL_AB`, `external_5_and_ab_loop_5_and_understanding_5`, `selected_upload_set/promoted_candidate/post_external_collection_promotion_summary`로 회수 후 승격 검토 조건을 분리한다.
- `triage_priority_badge_main_menu_baseline`은 `P1_BASELINE_GUARD`, `main_menu_loop_entry_response_collected`, `01_main_menu.png` 기준 화면 유지/교체 판단으로 분리한다.
- `triage_priority_badge_copy_alignment`는 `P1_COPY_ALIGNMENT_COLLECT`, `copy_alignment_comment_collected`, `achievement_career_copy_alignment` 문구 일치 수동 기록으로 분리한다.
- Steam 제출 프리플라이트, 릴리즈 후보 감사, 배포 무결성 감사가 새 QA 카드 표를 요구하도록 강화했다.
- Steamworks sync: `Logs/prepare_steamworks_priority_badge_after_collection_status.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_priority_badge_after_collection_status_final.log`, `checkCount=234`, `passedCheckCount=234`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_priority_badge_after_collection_status_final.log`, `checkCount=93`, `passedCheckCount=93`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `CD3918E55F776B1DA1250DD044D8114517E7AB5218C6D8C0276F7B721609A2AE`, handoff `0D6CD21262B9C2336F63F3C35771AF84D565D99C6EFD494BAE66DC2F1BD2222D`.

### 2026-06-02 HUMAN_10 tracker action CSV 우선순위 배지 owner_screen 힌트 QA

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `HUMAN_10_COMMERCIAL` 행 `evidence_hint`에 `action_csv_priority_badge_owner_screen` 요약을 추가했다.
- 요약은 `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB->상점 페이지 / Store Candidate`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD->메인 메뉴 / Store Presence 기준 화면`, `triage_priority_badge_copy_alignment/P1_COPY_ALIGNMENT_COLLECT->성과 기록 / 캠페인 기록`을 한 줄로 연결한다.
- Steam 제출 프리플라이트의 `외부 검증 게이트 트래커` 체크가 새 owner_screen 힌트를 요구하도록 강화했다.
- 릴리즈 후보 감사의 외부 handoff 문서/게이트 tracker 체크가 새 owner_screen 힌트를 요구하도록 강화했다.
- 배포 무결성 감사에 `handoff tracker HUMAN_10 action CSV 우선순위 배지 owner_screen 힌트` 체크를 추가했다.
- Steamworks sync: `Logs/prepare_steamworks_human10_priority_badge_owner_screen_hint.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_human10_priority_badge_owner_screen_hint_final.log`, `checkCount=234`, `passedCheckCount=234`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_human10_priority_badge_owner_screen_hint_final.log`, `checkCount=94`, `passedCheckCount=94`.
- 최신 SHA256: release `B8124CE2E93EC006E3354B72DCB99392C1E4836DFFD64047428020B2C481AA17`, playtest kit `22B558A379BF079598FD173C43E07643A7CFC7F5FDFAD14ED733ED253A6C8588`, Steamworks `0B68AF8CCC997588BB19BD083DF34D30625847ECFD92CBACD8413CADA42DDABF`, handoff `6580E6C635C8B9CA532B0695BC5286317B4F1D66B2EDB510A1965856E92FE154`.

### 2026-06-02 Paperlogy 릴리즈 manifest 커버리지 재감사 QA

- `RELEASE_MANIFEST.txt` 생성 내용에 `UI font: Paperlogy-6SemiBold` 줄을 추가하고 `Assets/Resources/Fonts/Paperlogy-6SemiBold.ttf`, `paperlogyFontApplied=true`, `paperlogyTextFontCoverageApplied=true`, `paperlogyTextMismatchCount=0`, `Docs/THIRD_PARTY_FONTS.md`를 한 줄에서 대조하도록 했다.
- 릴리즈 후보 감사에 `Paperlogy 폰트 릴리즈 산출물 QA` 체크를 추가해 font asset, README_KR, RELEASE_MANIFEST, THIRD_PARTY_FONTS, UI cleanup smoke JSON을 함께 요구하도록 강화했다.
- 배포 무결성 감사에 `Steamworks content Paperlogy 폰트 커버리지 산출물` 체크를 추가했다.
- 런타임 UI 정리 스모크: `Logs/runtime_ui_cleanup_paperlogy_release_manifest_reaudit.log`, `paperlogyFontApplied=true`, `paperlogyTextFontCoverageApplied=true`, `paperlogyTextComponentCount=394`, `paperlogyTextMismatchCount=0`, `activeFontName=Paperlogy-6SemiBold`.
- 패키징/Steamworks sync: `Logs/package_current_windows_paperlogy_release_manifest_reaudit.log`, `Logs/prepare_steamworks_paperlogy_release_manifest_reaudit_final.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_paperlogy_release_manifest_reaudit_final.log`, `checkCount=235`, `passedCheckCount=235`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_paperlogy_release_manifest_reaudit_after_release_sync.log`, `checkCount=95`, `passedCheckCount=95`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `E8A5608F4117A3768746C40D4EEE812294334AA0650F9A989D23627A92EC8669`, handoff `EBC06BB7177C348220689B2B4EF54FC4F8599AE38D21FE1BEB78CA79418CBE8E`.

### 2026-06-02 Store Presence 증거 초안 우선순위 배지 회수 후 입력란 QA

- `Evidence/STORE_PRESENCE.md`, `Evidence/README_KO.md`, `Evidence/STORE_PRESENCE_EXAMPLE.md`, `Evidence/_templates/STORE_PRESENCE.md`에 `Store Presence 우선순위 배지 회수 후 입력란` 표를 추가했다.
- 새 표는 `store_presence_priority_badge_after_collection_input`, `store_presence_main_menu_baseline_after_collection_input`, `store_presence_copy_alignment_after_collection_input`을 `after_collection_status`, `manual_update_target`, `completion_gate`와 직접 연결한다.
- 초안 입력란은 `after_collection_status_reward_loop_candidate`, `manual_update_target_reward_loop_candidate`, `completion_gate_reward_loop_candidate`, `after_collection_status_main_menu_baseline`, `completion_gate_main_menu_baseline`, `after_collection_status_copy_alignment`, `completion_gate_copy_alignment`로 분리했다.
- Steam 제출 프리플라이트, 릴리즈 후보 감사, 배포 무결성 감사가 새 evidence 입력란과 handoff zip 내부 포함 여부를 요구하도록 강화했다.
- Steamworks sync: `Logs/prepare_steamworks_store_presence_after_collection_input_fields.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_after_collection_input_fields.log`, `checkCount=236`, `passedCheckCount=236`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_after_collection_input_fields.log`, `checkCount=96`, `passedCheckCount=96`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `38F23BCFB749FC8FA56FD11339B3CFC66CC96092A90668685ED382F6F193E7A7`, handoff `1C917DF2518D78A561632336621BA85E34873FD3014BBB5B42C2E3E485CC3062`.

### 2026-06-02 외부 게이트 감사 HUMAN_10 우선순위 배지 owner_screen 별도 필드 QA

- `care_review_external_gate_audit.csv`, `care_review_external_gate_audit_summary.json`, `care_review_external_gate_audit.md`에 HUMAN_10 우선순위 배지 owner_screen 요약 필드를 별도로 추가했다.
- 새 CSV 필드는 `priority_badge_owner_screen_summary`, JSON 필드는 `priorityBadgeOwnerScreenSummary`, Markdown 표 컬럼은 `Priority Badge Owner Screen`이다.
- HUMAN_10 요약은 `action_csv_priority_badge_owner_screen`과 `triage_priority_badge_reward_loop_candidate/P0_WAIT_EXTERNAL_AB`, `triage_priority_badge_main_menu_baseline/P1_BASELINE_GUARD`, `triage_priority_badge_copy_alignment/P1_COPY_ALIGNMENT_COLLECT`의 담당 화면을 직접 연결한다.
- 기존 Store Presence Draft Markdown 검증은 새 표 컬럼을 포함한 헤더도 허용하도록 보정해 `hasStorePresenceDraftStatusMarkdownTable=true`를 유지했다.
- Steamworks sync: `Logs/prepare_steamworks_priority_badge_owner_screen_summary_field_fixed.log`.
- 외부 게이트 감사: `Logs/audit_external_release_gates_priority_badge_owner_screen_summary_field_fixed.log`, `hasPriorityBadgeOwnerScreenMarkdownSummary=true`, `hasPriorityBadgeOwnerScreenCsvSummary=true`, `hasPriorityBadgeOwnerScreenJsonSummary=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_priority_badge_owner_screen_summary_field_final.log`, `checkCount=237`, `passedCheckCount=237`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_priority_badge_owner_screen_summary_field.log`, `checkCount=97`, `passedCheckCount=97`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `38F23BCFB749FC8FA56FD11339B3CFC66CC96092A90668685ED382F6F193E7A7`, handoff `EE2DB8B088A238F096D0B7472E73430BC54A316451DA31CAF740DC8BA4546D1B`.

### 2026-06-02 Steamworks upload manifest Paperlogy 폰트/라이선스 증거 QA

- `STEAMWORKS_UPLOAD_MANIFEST.txt`에 `Paperlogy font evidence` 줄을 추가했다.
- 새 줄은 `font=Paperlogy-6SemiBold`, `Assets/Resources/Fonts/Paperlogy-6SemiBold.ttf`, `content_windows/RELEASE_MANIFEST.txt`, `content_windows/README_KR.txt`, `Docs/THIRD_PARTY_FONTS.md`, `care_review_ui_cleanup_smoke_result.json`을 한 줄에서 대조한다.
- 릴리즈 후보 감사에 `Steamworks upload manifest Paperlogy 폰트/라이선스 증거` 체크를 추가했다.
- 배포 무결성 감사에도 같은 upload manifest Paperlogy evidence 체크를 추가했다.
- 사람용 업로드 문서와 플레이테스트 QA 패킷이 `Paperlogy upload manifest evidence`와 최신 Steamworks zip SHA를 요구하도록 강화했다.
- Steamworks sync: `Logs/prepare_steamworks_paperlogy_upload_manifest_evidence.log`.
- 배포 무결성: `Logs/audit_distribution_integrity_paperlogy_upload_manifest_evidence_after_docs.log`, `checkCount=98`, `passedCheckCount=98`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_paperlogy_upload_manifest_evidence_final.log`, `checkCount=238`, `passedCheckCount=238`, `localBlockerCount=0`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `671870F30CBC8C3C35B66FEEA13AC8DD451C58682AAC3CA7FAFD6966B009C7F6`, handoff `B2182DD59784D5EB31464447843EB40BECE15577C93F8A263FB7EA1215942416`.

### 2026-06-02 Store Presence tracker 우선순위 배지 회수 후 입력란 힌트 QA

- `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `STORE_PRESENCE` 행 `evidence_hint`에 `after_collection_inputs`와 `after_collection_fields` 축약 힌트를 추가했다.
- 힌트는 `store_presence_priority_badge_after_collection_input`, `store_presence_main_menu_baseline_after_collection_input`, `store_presence_copy_alignment_after_collection_input`을 실제 `Evidence/STORE_PRESENCE.md` 입력란과 연결한다.
- 연결 입력란은 `after_collection_status_reward_loop_candidate`, `manual_update_target_reward_loop_candidate`, `completion_gate_reward_loop_candidate`, `after_collection_status_main_menu_baseline`, `completion_gate_main_menu_baseline`, `after_collection_status_copy_alignment`, `completion_gate_copy_alignment`이다.
- Steam 제출 프리플라이트의 `외부 검증 게이트 트래커` 체크가 새 tracker 힌트를 요구하도록 강화했다.
- 릴리즈 후보 감사에 `외부 게이트 tracker Store Presence 우선순위 배지 회수 후 입력란 evidence_hint` 체크를 추가했다.
- 배포 무결성 감사에 handoff folder/zip tracker after_collection 입력란 체크와 사람용 문서 힌트 체크를 추가했다.
- Steamworks sync: `Logs/prepare_steamworks_store_presence_tracker_after_collection_input_hint.log`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_tracker_after_collection_input_hint_after_docs.log`, `checkCount=100`, `passedCheckCount=100`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_tracker_after_collection_input_hint_final.log`, `checkCount=239`, `passedCheckCount=239`, `localBlockerCount=0`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `423346F6DC05DA26B534AF75DCA2F9F2C19B888BFF67A8FE9852632D11BF3259`, handoff `B4B61A59B276F837DCFF4DA9A66A72CA5EF5DCFB602E6F6C82895C03A05CB1F3`.

### 2026-06-02 외부 게이트 smoke Handoff zip SHA 상호참조 QA

- `care_review_external_gate_audit_smoke_result.json`에 `handoffZipPath`, `handoffZipSha256`, `handoffZipBytes`, `handoffZipHashFileMatches` 필드를 추가했다.
- 릴리즈 감사 마지막 Handoff zip 생성 뒤 외부 게이트 감사를 다시 생성하도록 순서를 보정해 smoke JSON이 최종 zip hash를 가리키게 했다.
- 배포 무결성 감사 시작 시에도 외부 게이트 감사를 현재 Handoff zip 기준으로 갱신하도록 보정했다.
- 릴리즈 후보 감사와 배포 무결성 감사에 `외부 게이트 스모크 handoff zip SHA 상호참조` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_smoke_handoff_zip_sha_final_sync.log`, `checkCount=240`, `passedCheckCount=240`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_external_gate_smoke_handoff_zip_sha_after_docs.log`, `checkCount=101`, `passedCheckCount=101`.
- smoke JSON 대조: `handoffZipSha256=8820963176751AA963994104D2012A1E0C6273BC519CFECFB3F76EEA4C04826C`, `handoffZipBytes=32972`, `handoffZipHashFileMatches=true`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `423346F6DC05DA26B534AF75DCA2F9F2C19B888BFF67A8FE9852632D11BF3259`, handoff `8820963176751AA963994104D2012A1E0C6273BC519CFECFB3F76EEA4C04826C`.

### 2026-06-02 Steam 제출 프리플라이트 Paperlogy manifest evidence 역참조 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md`의 로컬 빌드/Depot 구조 섹션에 `Steamworks upload manifest Paperlogy 폰트 evidence 역참조` 체크를 추가했다.
- 체크는 `STEAMWORKS_UPLOAD_MANIFEST.txt`, `content_windows/RELEASE_MANIFEST.txt`, `content_windows/README_KR.txt`, `Docs/THIRD_PARTY_FONTS.md`, `care_review_ui_cleanup_smoke_result.json`, `paperlogyTextMismatchCount=0`을 함께 대조한다.
- 릴리즈 후보 감사에 `Steam 제출 프리플라이트 Paperlogy manifest evidence 역참조` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더 문서와 zip 내부 `v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`의 Paperlogy evidence 역참조를 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서/플레이테스트 QA 패킷에 새 역참조와 최신 SHA를 반영했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_paperlogy_evidence_backreference_final_sync.log`, `checkCount=242`, `passedCheckCount=242`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_preflight_paperlogy_evidence_backreference_final_docs.log`, `checkCount=102`, `passedCheckCount=102`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `82D3978EF6943068C225E1746B497C69288E7ADE34E0970FB6D6D7A651EC57C4`, handoff `CC8CD3DD6D79DFC9B7CE9B3F3A16E4780599CA767EFADA0E10FACE7EBDED0493`.

### 2026-06-02 외부 게이트 감사 Store Presence after_collection_inputs 별도 필드 QA

- 외부 게이트 감사 row에 `storePresenceAfterCollectionInputSummary` 필드를 추가했다.
- CSV에는 `store_presence_after_collection_input_summary` 컬럼을 추가하고, Markdown 게이트 표에는 `After Collection Inputs` 컬럼을 추가했다.
- Markdown에 `Store Presence 우선순위 배지 회수 후 입력란 감사 필드` 섹션을 추가해 `EXTERNAL_RELEASE_GATE_TRACKER.csv`의 `after_collection_inputs`와 `after_collection_fields`를 바로 볼 수 있게 했다.
- smoke JSON에 `hasStorePresenceAfterCollectionInputMarkdownSummary`, `hasStorePresenceAfterCollectionInputCsvSummary`, `hasStorePresenceAfterCollectionInputJsonSummary` 플래그를 추가했다.
- 릴리즈 후보 감사와 배포 무결성 감사에 `외부 게이트 감사 Store Presence after_collection_inputs 별도 필드` 체크를 추가했다.
- 사람용 업로드 문서와 플레이테스트 QA 패킷이 `store_presence_after_collection_input_summary`와 `storePresenceAfterCollectionInputSummary`를 요구하도록 강화했다.
- 외부 게이트 감사: `Logs/audit_external_release_gates_store_presence_after_collection_input_summary_field.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_presence_after_collection_input_summary_field_final.log`, `checkCount=243`, `passedCheckCount=243`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_presence_after_collection_input_summary_field_final_docs.log`, `checkCount=103`, `passedCheckCount=103`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `82D3978EF6943068C225E1746B497C69288E7ADE34E0970FB6D6D7A651EC57C4`, handoff `443C58C71D6608638A7685FF35978D1FD4742150D605AEE87DFC78293B69FFD0`.

### 2026-06-02 외부 게이트 smoke handoffZipSha256 사람용 감사 항목 QA

- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷에 `외부 게이트 smoke handoffZipSha256 사람용 감사 항목`을 추가했다.
- 항목은 `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256=443C58C71D6608638A7685FF35978D1FD4742150D605AEE87DFC78293B69FFD0`, `handoffZipBytes=32971`, `handoffZipHashFileMatches=true`를 직접 명시한다.
- 배포 무결성 감사에 `사람용 문서 외부 게이트 smoke handoffZipSha256 별도 감사 항목` 체크를 추가했다.
- 배포 무결성: `Logs/audit_distribution_integrity_handoff_zip_sha_human_doc_field_rerun.log`, `checkCount=104`, `passedCheckCount=104`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_handoff_zip_sha_human_doc_field.log`, `checkCount=243`, `passedCheckCount=243`, `localBlockerCount=0`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `82D3978EF6943068C225E1746B497C69288E7ADE34E0970FB6D6D7A651EC57C4`, handoff `443C58C71D6608638A7685FF35978D1FD4742150D605AEE87DFC78293B69FFD0`.

### 2026-06-02 Steam 제출 프리플라이트 최상단 Paperlogy evidence 요약 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약에 `Paperlogy 폰트 evidence` 줄을 추가했다.
- 최상단 줄은 `Paperlogy font evidence`, `STEAMWORKS_UPLOAD_MANIFEST.txt`, `content_windows/RELEASE_MANIFEST.txt`, `content_windows/README_KR.txt`, `Docs/THIRD_PARTY_FONTS.md`, `care_review_ui_cleanup_smoke_result.json`, `paperlogyTextMismatchCount=0`을 바로 노출한다.
- 릴리즈 후보 감사에 `Steam 제출 프리플라이트 최상단 Paperlogy manifest evidence 요약` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`의 최상단 Paperlogy 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서/플레이테스트 QA 패킷의 Steamworks zip SHA와 handoff smoke SHA를 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_preflight_top_paperlogy_manifest_evidence_rerun2.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_top_paperlogy_manifest_evidence_final.log`, `checkCount=244`, `passedCheckCount=244`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_preflight_top_paperlogy_manifest_evidence_final_docs_sync.log`, `checkCount=105`, `passedCheckCount=105`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `46A8D2CB9BE2DD9E2F74EE2B7504AB176C00BA1DD18BBD6D681659E84846B4DA`, handoff `A632269CFC9344CF86294B5EBAB8E8137CB6BAD5434E0E17B73A50F64FB3D9C3`.

### 2026-06-02 릴리즈 후보 감사 노트 Store Presence after_collection 입력란 QA

- `RELEASE_CANDIDATE_AUDIT_NOTE_KO.md`에 `Store Presence 우선순위 배지 회수 후 입력란` 별도 소제목을 추가했다.
- 소제목은 `storePresenceAfterCollectionInputSummary`, `store_presence_after_collection_input_summary`, `after_collection_inputs=store_presence_priority_badge_after_collection_input`, `after_collection_status_reward_loop_candidate`, `completion_gate_main_menu_baseline`, `completion_gate_copy_alignment`를 한 번에 노출한다.
- 릴리즈 후보 감사에 `Steamworks 릴리즈 후보 감사 노트 Store Presence after_collection 입력란` 체크를 추가했다.
- 배포 무결성 감사에 같은 감사 노트 after_collection 입력란 체크를 추가했다.
- 릴리즈 감사의 `배포 패킷 무결성 QA`가 최종 handoff zip 생성 뒤 다시 계산되도록 보정하고, 사람용 문서의 handoff zip SHA/bytes를 현재 zip 기준으로 동기화하도록 했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_after_collection_final_handoff_hash_stability_retry.log`, `checkCount=245`, `passedCheckCount=245`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_after_collection_final_handoff_hash_drift.log`, `checkCount=106`, `passedCheckCount=106`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `46A8D2CB9BE2DD9E2F74EE2B7504AB176C00BA1DD18BBD6D681659E84846B4DA`, handoff `B43996971F8738C71A9C358A2960FD1F1B81D54603D2EC7A2564E8691C9622EA`.

### 2026-06-02 외부 게이트 smoke Steamworks zip SHA 상호참조 QA

- `care_review_external_gate_audit_smoke_result.json`에 `steamworksZipPath`, `steamworksZipSha256`, `steamworksZipBytes`, `steamworksZipHashFileMatches` 필드를 추가했다.
- handoff zip SHA와 Steamworks zip SHA를 같은 smoke JSON에서 나란히 대조할 수 있게 했다.
- 릴리즈 후보 감사에 `외부 게이트 스모크 Steamworks zip SHA 상호참조` 체크를 추가했다.
- 배포 무결성 감사에 같은 smoke JSON Steamworks zip SHA 체크와 `사람용 문서 외부 게이트 smoke Steamworks zip SHA 별도 감사 항목` 체크를 추가했다.
- 사람용 업로드 문서와 플레이테스트 QA 패킷에 Steamworks zip SHA/bytes/hash-file-match 항목을 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_external_gate_smoke_steamworks_zip_sha_retry.log`, `checkCount=246`, `passedCheckCount=246`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.csv`, `checkCount=108`, `passedCheckCount=108`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `46A8D2CB9BE2DD9E2F74EE2B7504AB176C00BA1DD18BBD6D681659E84846B4DA`, handoff `BAFF0BBBFACE20741831903D74D55BF5B49B10E697097DC5683ED41E89A55E4B`.

### 2026-06-02 Steamworks README 첫 섹션 Paperlogy evidence 요약 QA

- `README_STEAMWORKS_KR.txt` 첫 섹션 `Store Presence 증거 묶음 상태`에 `Paperlogy 폰트 evidence` 줄을 추가했다.
- 줄은 `Paperlogy font evidence`, `STEAMWORKS_UPLOAD_MANIFEST.txt`, `content_windows/RELEASE_MANIFEST.txt`, `content_windows/README_KR.txt`, `Docs/THIRD_PARTY_FONTS.md`, `care_review_ui_cleanup_smoke_result.json`, `paperlogyTextMismatchCount=0`을 노출한다.
- 릴리즈 후보 감사에 `Steamworks README 첫 섹션 Paperlogy manifest evidence 요약` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/README_STEAMWORKS_KR.txt`의 Paperlogy evidence 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서의 백업 zip 크기/SHA 및 smoke Steamworks zip SHA 항목을 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_readme_top_paperlogy_evidence.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_steamworks_readme_top_paperlogy_evidence_docs_sync_retry.log`, `checkCount=247`, `passedCheckCount=247`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.csv`, `checkCount=109`, `passedCheckCount=109`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `DD7993423F5C35557A6BD54FCC9C1DE2196C1EEAF4104F6845D328E86CE911AA`, handoff `BAFF0BBBFACE20741831903D74D55BF5B49B10E697097DC5683ED41E89A55E4B`.

### 2026-06-02 Steam 제출 프리플라이트 최상단 Store Presence after_collection 입력란 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약에 `Store Presence after_collection 입력란` 줄을 추가했다.
- 줄은 `storePresenceAfterCollectionInputSummary`, `store_presence_after_collection_input_summary`, `after_collection_inputs=store_presence_priority_badge_after_collection_input`, `after_collection_status_reward_loop_candidate`, `completion_gate_main_menu_baseline`, `completion_gate_copy_alignment`를 바로 노출한다.
- 릴리즈 후보 감사에 `Steam 제출 전 자체점검 최상단 Store Presence after_collection 입력란` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`의 최상단 after_collection 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서의 백업 zip 크기/SHA 및 smoke Steamworks zip SHA 항목을 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_preflight_top_after_collection_inputs_retry.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_top_after_collection_inputs_retry.log`, `checkCount=248`, `passedCheckCount=248`, `localBlockerCount=0`.
- 배포 무결성: `Builds/QA/v0.3.0/distribution_integrity/care_review_distribution_integrity_audit.csv`, `checkCount=110`, `passedCheckCount=110`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `4F8340B47EF706F589454945E0111B4E8E71D49326F0693F33E67713087ABB0E`, handoff `58403DD9E502629F3F088F187B33B7DFE2B83E940B4D2DB9BFDF696C5C407F81`.

### 2026-06-02 Steamworks README 첫 섹션 외부 게이트 smoke zip SHA 요약 QA

- `README_STEAMWORKS_KR.txt` 첫 섹션 `Store Presence 증거 묶음 상태`에 `외부 게이트 smoke zip SHA` 줄을 추가했다.
- 줄은 `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256`, `handoffZipBytes`, `handoffZipHashFileMatches=true`, `steamworksZipSha256`, `steamworksZipBytes`, `steamworksZipHashFileMatches=true`를 노출한다.
- 릴리즈 후보 감사에 `Steamworks README 첫 섹션 외부 게이트 smoke zip SHA 요약` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/README_STEAMWORKS_KR.txt`의 같은 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 외부 게이트 smoke JSON의 Steamworks/Handoff zip SHA를 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_readme_smoke_zip_sha_rerun.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_readme_smoke_zip_sha_final.log`, `checkCount=249`, `passedCheckCount=249`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_readme_smoke_zip_sha.log`, `checkCount=111`, `passedCheckCount=111`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `58896148351A3BEB7DA3D3BFAB90718B26C6F5C0E43F97F04C81E772A591ED88`, handoff `C2BD74118AB0B9469D35B7B5EFAC15EC371460C69DE4D4084BD881A89C91F00F`.

### 2026-06-02 Steamworks upload manifest README Paperlogy 최상단 요약 역참조 QA

- `STEAMWORKS_UPLOAD_MANIFEST.txt`에 `Paperlogy README top cross-check` 줄을 추가했다.
- 줄은 `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `Paperlogy 폰트 evidence`, `Paperlogy font evidence`, `paperlogyTextMismatchCount=0`을 노출한다.
- 릴리즈 후보 감사에 `Steamworks upload manifest README Paperlogy 최상단 요약 역참조` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/STEAMWORKS_UPLOAD_MANIFEST.txt`의 같은 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서의 백업 zip 크기/SHA 및 smoke Steamworks zip SHA 항목을 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_upload_manifest_readme_paperlogy_backref_rerun.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_readme_paperlogy_backref_final.log`, `checkCount=250`, `passedCheckCount=250`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_upload_manifest_readme_paperlogy_backref.log`, `checkCount=112`, `passedCheckCount=112`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `D5AF69ED4394A7D6773CC31135EB791500C4391C9C37ED3EA9D4E2FAFA3F821E`, handoff `70AD666FA977961D190FEA11FE0874D06F73360349627F4747A91E76FDA40A95`.

### 2026-06-02 Steam 제출 프리플라이트 최상단 외부 게이트 smoke zip SHA 요약 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약에 `외부 게이트 smoke zip SHA` 줄을 추가했다.
- 줄은 `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256`, `handoffZipBytes`, `handoffZipHashFileMatches=true`, `steamworksZipSha256`, `steamworksZipBytes`, `steamworksZipHashFileMatches=true`를 노출한다.
- 릴리즈 후보 감사에 `Steam 제출 프리플라이트 최상단 외부 게이트 smoke zip SHA 요약` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`의 최상단 smoke zip SHA 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서의 백업 zip 크기/SHA 및 smoke Steamworks/Handoff zip SHA 항목을 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_preflight_top_smoke_zip_sha_rerun.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_top_smoke_zip_sha_final.log`, `checkCount=251`, `passedCheckCount=251`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_preflight_top_smoke_zip_sha.log`, `checkCount=113`, `passedCheckCount=113`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `9CD81FFE23BC4FA44597A03AFF1F737AFC4FE0DB616921856941C302EA609C78`, handoff `F6691E3C0BD01D17A6FACE502156A5F5C12FD30608D62F38CD879F4639199C2E`.

### 2026-06-02 사람용 문서 README 첫 섹션 smoke zip SHA 요약 QA

- `Docs/Steamworks_업로드_준비.md`와 `Docs/플레이테스트_QA_패킷.md`에 `README 첫 섹션 smoke zip SHA 요약 사람용 감사 항목` 줄을 추가했다.
- 줄은 `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `외부 게이트 smoke zip SHA`, `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256`, `handoffZipBytes`, `steamworksZipSha256`, `steamworksZipBytes`를 노출한다.
- `SyncHumanDocsReadmeSmokeZipSha()`가 Steamworks/Handoff zip 해시와 크기를 현재 산출물 기준으로 동기화한다.
- 릴리즈 후보 감사와 배포 무결성 감사에 `사람용 문서 README 첫 섹션 smoke zip SHA 요약 별도 감사 항목` 체크를 추가했다.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_human_doc_readme_smoke_zip_sha_final.log`, `checkCount=252`, `passedCheckCount=252`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_human_doc_readme_smoke_zip_sha.log`, `checkCount=114`, `passedCheckCount=114`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `9CD81FFE23BC4FA44597A03AFF1F737AFC4FE0DB616921856941C302EA609C78`, handoff `DACA0BD1081EFD04081329D26AC915C65F6613583C0CB3516840F2BEE9D4D61B`.

### 2026-06-02 Steamworks upload manifest README smoke zip SHA 최상단 요약 역참조 QA

- `STEAMWORKS_UPLOAD_MANIFEST.txt`에 `README smoke zip SHA top cross-check` 줄을 추가했다.
- 줄은 `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `외부 게이트 smoke zip SHA`, `care_review_external_gate_audit_smoke_result.json`, `handoffZipSha256`, `handoffZipBytes`, `steamworksZipSha256`, `steamworksZipBytes`를 노출한다.
- 릴리즈 후보 감사에 `Steamworks upload manifest README smoke zip SHA 최상단 요약 역참조` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/STEAMWORKS_UPLOAD_MANIFEST.txt`의 같은 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 사람용 업로드 문서의 백업 zip 크기/SHA 및 smoke Steamworks/Handoff zip SHA 항목을 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_upload_manifest_readme_smoke_zip_sha_rerun.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_upload_manifest_readme_smoke_zip_sha_final.log`, `checkCount=253`, `passedCheckCount=253`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_upload_manifest_readme_smoke_zip_sha.log`, `checkCount=115`, `passedCheckCount=115`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `598B15F78CDC40C21089677E4CB5D654F1F2E9FFF27F79D0DF4932951E0C7957`, handoff `600D06D8FF6F604BF845A8C7DDCEFA2EF2C50E0349C204C1D77D67F54889C673`.

### 2026-06-02 Steam 제출 프리플라이트 최상단 upload manifest Paperlogy README 역참조 QA

- `STEAM_SUBMISSION_PREFLIGHT_KO.md` 최상단 판정 요약에 `upload manifest Paperlogy README top cross-check` 줄을 추가했다.
- 줄은 `STEAMWORKS_UPLOAD_MANIFEST.txt`, `Paperlogy README top cross-check`, `README_STEAMWORKS_KR.txt`, `Store Presence 증거 묶음 상태`, `Paperlogy 폰트 evidence`, `paperlogyTextMismatchCount=0`을 노출한다.
- `PreflightTopUploadManifestPaperlogyReadmeBackReferenceReady()`와 `SteamworksZipPreflightTopUploadManifestPaperlogyReadmeBackReferenceReady()`를 추가했다.
- 릴리즈 후보 감사에 `Steam 제출 프리플라이트 최상단 upload manifest Paperlogy README 역참조` 체크를 추가했다.
- 배포 무결성 감사는 Steamworks 폴더와 zip 내부 `v0.3.0/STEAM_SUBMISSION_PREFLIGHT_KO.md`의 같은 줄을 모두 확인한다.
- Steamworks zip을 재압축하고 외부 게이트 smoke JSON의 Steamworks/Handoff zip SHA를 최신 값으로 동기화했다.
- Steamworks 패키징: `Logs/prepare_steamworks_preflight_top_upload_manifest_paperlogy_readme_rerun.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_preflight_top_upload_manifest_paperlogy_readme_final.log`, `checkCount=254`, `passedCheckCount=254`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_preflight_top_upload_manifest_paperlogy_readme.log`, `checkCount=116`, `passedCheckCount=116`.
- 최신 SHA256: release `2B459453DB46A13BD5038370BF6C816937173CF5304D8E7F8F2576EE61EBD7A2`, playtest kit `18149CF0664205E7E1AA1D22E70E41B6FE2E1E2E1A7CBCF4AD366CC872B172DF`, Steamworks `51EBDB91824E0F260FBCB70DEEF396D052C6997803DDA183FCE6C963F8B786D3`, handoff `E0AF00EBDBB64EF19059E770023D94A2D5A48F97306F6D28E72F9FBC7EBA0F49`.

### 2026-06-02 메인 메뉴 추천 회차 브리핑 QA

- 메인 메뉴에 `추천 회차 브리핑` 카드를 추가했다.
- 카드는 현재 운영 기준 또는 대기 중인 추천 목표에 맞춰 `목표`, `위험`, `보상`, `근거`를 표시한다.
- 운영 기준을 `지원 확대`로 바꾸면 예산 소진 위험, 후속 연락 성과, 형평 보상을 즉시 갱신한다.
- `RunMainMenuMandateSmokeTest()`가 `briefingMentionsRecommendation`, `briefingMentionsStandardReward`, `changedBriefingUpdated`를 검증하고 QA 폴더에 결과를 mirror하도록 보정했다.
- 릴리즈 manifest와 Steamworks content README에 `main menu recommended campaign briefing` / `메인 메뉴 추천 회차 브리핑` 설명을 추가했다.
- 플레이테스트 kit의 실행 zip/SHA/안내문을 새 release zip 기준으로 동기화했다.
- Windows 릴리즈 빌드: `Logs/build_windows_menu_campaign_briefing_mirror_rerun.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_main_menu_campaign_briefing_mirror_v030.log`, `completed=true`.
- Steamworks 패키징: `Logs/prepare_steamworks_menu_campaign_briefing_playtest_sync_rerun.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_menu_campaign_briefing_final2.log`, `checkCount=254`, `passedCheckCount=254`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_menu_campaign_briefing_final2_rerun.log`, `checkCount=116`, `passedCheckCount=116`.
- 최신 SHA256: release `E24DC1463A367480E605C480147EF7C1EEF0ABE22C79AF303A5D4ADE04186C7D`, playtest kit `9BFCB8B910EF3355C099D50EA3F0F7338053CAE7F831F9EC8DBB7A711F9581CB`, Steamworks `2FA23113E5C8B0550B64075E4BAAD73AB5A96CF8A374ED8DB52BFAB6A2D977B7`, handoff `896F148CC729F3A4D8779CF748B5E9D9F021005C389D1F871D08D3C252BF71F2`.

### 2026-06-02 메인 메뉴 추천 회차 직전 약점 QA

- `추천 회차 브리핑` 카드에 `직전 약점` 줄을 추가했다.
- 직전 캠페인 기록의 권장 일치율, 예산, 안정, 형평, 누락 위험, 민원, 챌린지 점수를 비교해 가장 약한 축 1개를 표시한다.
- 기록이 없으면 첫 회차 기준선 확보 안내를 표시하고, 기록이 안정권이면 새 목표 보상 극대화 안내를 표시한다.
- `RunMainMenuMandateSmokeTest()`가 `briefingMentionsPreviousWeakness`, `changedBriefingKeepsPreviousWeakness`를 검증하도록 확장했다.
- 릴리즈 manifest/README와 릴리즈 후보 감사의 메인 메뉴 운영 기준 QA 조건에 직전 약점 항목을 추가했다.
- Windows 릴리즈 빌드: `Logs/build_windows_menu_briefing_weakness.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_main_menu_briefing_weakness_v030.log`, `completed=true`.
- Steamworks 패키징: `Logs/prepare_steamworks_menu_briefing_weakness.log`.
- 외부 검증 handoff: `Logs/build_handoff_menu_briefing_weakness.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_menu_briefing_weakness.log`, `checkCount=253`, `passedCheckCount=253`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_menu_briefing_weakness_rerun.log`, `checkCount=116`, `passedCheckCount=116`.
- 최신 SHA256: release `E24DC1463A367480E605C480147EF7C1EEF0ABE22C79AF303A5D4ADE04186C7D`, playtest kit `9BFCB8B910EF3355C099D50EA3F0F7338053CAE7F831F9EC8DBB7A711F9581CB`, Steamworks `2FA23113E5C8B0550B64075E4BAAD73AB5A96CF8A374ED8DB52BFAB6A2D977B7`, handoff `896F148CC729F3A4D8779CF748B5E9D9F021005C389D1F871D08D3C252BF71F2`.

### 2026-06-02 메인 메뉴 추천 회차 브리핑/직전 약점 상점 A/B 질문 QA

- Store Presence 후보 검증에 `menu_campaign_briefing_weakness` 질문 ID를 추가했다.
- `SCREENSHOT_CANDIDATE_AB_TEST_KO.md`에 `01_main_menu.png`의 추천 회차 브리핑과 `직전 약점` 줄이 다음 목표, 위험, 보상 이유를 이해시키는지 묻는 섹션을 추가했다.
- 플레이테스트 요청서와 세션 인덱스 템플릿에 같은 질문을 넣고, 집계 smoke에 `csvHasMenuBriefingWeaknessQuestion=true`를 추가했다.
- Store Presence QA 카드, decision matrix, A/B TODO mapping, commercial triage owner screen 증거가 `menu_campaign_briefing_weakness`, `briefingMentionsPreviousWeakness=true`, `changedBriefingKeepsPreviousWeakness=true`를 함께 대조한다.
- 배포 무결성 감사에서 사람용 문서의 release/playtest/Steamworks/handoff SHA 동기화를 보강했다.
- Windows 릴리즈 빌드: `Logs/build_windows_store_ab_menu_briefing_weakness.log`, `Build Successful`.
- 플레이테스트 집계 QA: `Logs/runtime_playtest_aggregate_menu_briefing_weakness_v030.log`, `completed=true`, `csvHasMenuBriefingWeaknessQuestion=true`.
- Steamworks 패키징: `Logs/prepare_steamworks_store_ab_menu_briefing_weakness.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_ab_menu_briefing_weakness.log`, `checkCount=253`, `passedCheckCount=253`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_ab_menu_briefing_weakness_after_release.log`, `checkCount=116`, `passedCheckCount=116`.
- 최신 SHA256: release `90782DDEAA1EA2BFFE0CAADCDAB3450BEA948AD5AB20DCA1334BEDD48B33DA53`, playtest kit `503F4CC5F0C3ED16A86F67103A067E41A653B0F3DFE0B1DB8658FA2E481C59CA`, Steamworks `6A247E5AD92D3BAA39423975EF4F670F377A7DAD1AA70FC7209BC24165EA483C`, handoff `16DC6329D14C8851B5BCFB433F42DCCAB11528C3D86B40065FBB23E2BF7469E0`.

### 2026-06-02 캠페인 기록 브리핑 회고 QA

- 캠페인 기록 본문과 선택 회차 상세에 `브리핑 회고` 줄을 추가했다.
- 줄은 메인 메뉴 추천 회차 브리핑의 `예고 위험`과 `예고 보상`을 완료 회차의 `실제 결과`와 대조한다.
- 운영 기준별 결과 문구는 지원 확대, 긴축 감사, 균형 기준에 맞춰 형평/안정/위험/예산/권장 일치/챌린지 상태를 다르게 요약한다.
- `RunCareerRecordSmokeTest()`에 `bodyMentionsBriefingRetrospective=true`, `detailMentionsBriefingRetrospective=true` 검증을 추가했다.
- Steam 제출 프리플라이트와 릴리즈 후보 감사의 캠페인 기록 상세 패널 QA 조건에 새 필드를 반영했다.
- Windows 릴리즈 빌드: `Logs/build_windows_career_briefing_retrospective_final.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_career_record_briefing_retrospective_final_v030.log`, `completed=true`.
- Steamworks 패키징: `Logs/prepare_steamworks_career_briefing_retrospective.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_career_briefing_retrospective.log`, `checkCount=253`, `passedCheckCount=253`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_career_briefing_retrospective_final.log`, `checkCount=116`, `passedCheckCount=116`.
- 최신 SHA256: release `D95B526979784E1AFD8980BB3679D1E67F71726436707376412E3ECE334B0B50`, playtest kit `48C2186BEB94D219827A2E634D658B1837516146397A9AE09A5AB4D92B9D6C29`, Steamworks `30810A30EAE037D4337DDCE65C9B6D506BA07DFE56BD615070536D8A4279E68E`, handoff `A68DDCF24648532A33557E46BF4CB762B21ACAC168E0AD0EF0E3CD57186E6FA3`.

### 2026-06-02 메인 메뉴 직전 약점 코칭 용어 정렬 QA

- 메인 메뉴 `추천 회차 브리핑`의 `직전 약점` 줄이 직전 캠페인 기록의 `결정 감사 코칭` 패턴을 우선 사용하도록 바꿨다.
- 직전 기록에 코칭 패턴이 있으면 `코칭 패턴 고위험 지연 · 추천 운영 지원 확대 · 검증 질문 위험 증가/권장 일치`처럼 캠페인 기록 상세와 같은 용어를 쓴다.
- 코칭 패턴이 없는 기록은 기존 약점 산출 fallback을 유지한다.
- `RunMainMenuMandateSmokeTest()`에 `briefingUsesCoachingWeaknessTerms=true`, `changedBriefingKeepsCoachingWeaknessTerms=true` 검증을 추가했다.
- 플레이테스트 집계 CSV와 세션 인덱스 템플릿, Store Presence QA 카드, decision matrix, 릴리즈 후보 감사가 새 코칭 evidence 토큰을 대조한다.
- Windows 릴리즈 빌드: `Logs/build_windows_menu_coaching_weakness.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_main_menu_mandate_menu_coaching_weakness_v030.log`, `completed=true`.
- 플레이테스트 집계 QA: `Logs/runtime_playtest_aggregate_menu_coaching_weakness_v030.log`, `completed=true`, `csvHasMenuBriefingWeaknessQuestion=true`.
- Steamworks 패키징: `Logs/prepare_steamworks_menu_coaching_weakness.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_menu_coaching_weakness.log`, `checkCount=253`, `passedCheckCount=253`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_menu_coaching_weakness_final.log`, `checkCount=116`, `passedCheckCount=116`.
- 최신 SHA256: release `24B33EB621D78423CD6D5B2D0598E7C8FB127C0BBFC3BE340A73C047D40F322D`, playtest kit `C024BA1A4C8A4AF1A5448673AF4F21164AD33BEF1718053A8C098A4651A83AEC`, Steamworks `97E4B4DF4A147737C668CD12C893844213646ADF6913D0366371D7DB09C32F52`, handoff `D0B3EDADE613ED00D8AC11D41F42A9240F14D72281C979456191B338960E1E9E`.

### 2026-06-02 브리핑 회고 Store Presence 후보 근거 연결 QA

- `12_career_record_next_objective.png` 후보 설명에 캠페인 기록 `브리핑 회고`의 예고 위험/보상 대비 실제 결과를 판정 기준으로 추가했다.
- `RunCareerRecordSmokeTest()`에 `storeCandidateMentionsBriefingRetrospective=true` 검증을 추가했다.
- `SCREENSHOT_CANDIDATE_DECISION_MATRIX_KO.md`의 copy-alignment 배지와 12번 후보 권장 판정에 `브리핑 회고 상점 후보 근거`를 연결했다.
- `STORE_PRESENCE_QA_CARD_KO.md`가 `storeCandidateMentionsBriefingRetrospective=true`, `브리핑 회고`, `예고 위험`, `실제 결과`, `12_career_record_next_objective.png`를 Store Presence 입력 전 확인하도록 보강했다.
- 배포 무결성 감사는 handoff 폴더와 zip 내부 QA 카드의 같은 브리핑 회고 근거를 확인한다.
- Windows 릴리즈 빌드: `Logs/build_windows_store_briefing_retrospective_evidence.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_career_record_store_briefing_retrospective_evidence_v030.log`, `completed=true`, `storeCandidateMentionsBriefingRetrospective=true`.
- Steamworks 패키징: `Logs/prepare_steamworks_store_briefing_retrospective_evidence_fix.log`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_store_briefing_retrospective_evidence_fix.log`, `checkCount=254`, `passedCheckCount=254`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_store_briefing_retrospective_evidence_final.log`, `checkCount=118`, `passedCheckCount=118`.
- 최신 SHA256: release `7A2E57454D81171BF4CBD559A18A6CA53B93DAC751C81F7186423C010CD2BE11`, playtest kit `ECEBD6B72D33C01F3C2B1B900725C85FE550AE22D7170C52B4AA334277BF5EF6`, Steamworks `3A6B3667B333B4710461DAC41836CB5894F19C8DD61388A98375A8ED2245AE81`, handoff `1E440CBF726FF4DD24DB985C8ED454D725E1AAA9FB291E0CFB79140EFB508D3D`.

### 2026-06-03 메인 메뉴 직전 약점 보정 초점 가독성 QA

- 메인 메뉴 `추천 회차 브리핑` 카드의 약점 줄을 `직전 약점 · 보정 초점`으로 바꿨다.
- 브리핑 카드 배경 알파와 텍스트 외곽선을 보강해 첫 실제 회차 진입 직후에도 약점 캡션이 더 선명하게 보이도록 했다.
- 결정 감사 코칭 약점 문구는 `코칭 패턴`, `추천 운영`, `검증 질문 위험 증가`가 말줄임표 없이 남도록 압축했다.
- `RunMainMenuMandateSmokeTest()`에 `briefingWeaknessFocusCaptionReadable=true`, `briefingContrastEffectApplied=true`, `changedBriefingKeepsWeaknessFocusCaption=true` 검증을 추가했다.
- 저해상도 UI QA에 `mainMenuBriefingWeaknessFocusReadable=true`와 표시폭 샘플을 추가했고, 720p 기준 폭은 `53.9`로 통과했다.
- 플레이테스트 요청서, 세션 인덱스 템플릿, 자동 집계 CSV, Store Presence QA 카드, decision matrix가 `직전 약점 · 보정 초점`과 새 evidence 필드를 대조한다.
- Windows 릴리즈 빌드: `Logs/build_windows_menu_weakness_focus_caption_compact.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_main_menu_mandate_weakness_focus_caption_compact_v030.log`, `completed=true`.
- 저해상도 UI QA: `Logs/runtime_low_resolution_ui_weakness_focus_caption_compact_retry2_v030.log`, `completed=true`, `mainMenuBriefingWeaknessFocusReadable=true`.
- 플레이테스트 집계 QA: `Logs/runtime_playtest_aggregate_weakness_focus_caption_v030.log`, `completed=true`, `csvHasMenuBriefingWeaknessQuestion=true`.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_weakness_focus_caption_steamzip_final.log`, `checkCount=254`, `passedCheckCount=254`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_weakness_focus_caption_steamzip.log`, `checkCount=118`, `passedCheckCount=118`.
- 최신 SHA256: release `7F1378B96CFEFA065F054367E42334CC1A860E6002C8CF1E47011B55BDA4138A`, playtest kit `33AA044ABD61E37B90354E2BDF50CBE45ECE0EA67BD0AFA37FA8EFED79C9E515`, Steamworks `BC2C75A8AD0DC5CD13D1FE6879BB6B18751BF8754F81F5D5288FC6D643A15E7D`, handoff `EAEFADAD3D92084CDCB49ECEA1365FDD9817160E683CB10FEAC10B9906A4CBDD`.

### 2026-06-03 결정 감사 코칭 패턴별 다음 목표/버튼 라벨 QA

- 결정 감사 코칭 본문에 `다음 목표`와 `버튼 라벨` 줄을 추가했다.
- 코칭 패턴별 목표는 `고위험 지연 3건 이하`, `고비용 지원 3건 이하`, `권장 불일치 5건 이하`, `이의제기 보정 사례 1건 재심사`로 분리된다.
- 최종 리포트의 다음 회차 추천 목표가 결정 감사 코칭 패턴을 우선 반영하고, 추천 재시작 버튼은 `코칭 고비용 시작: 긴축 감사`처럼 패턴과 운영 기준을 함께 표시한다.
- `care_review_decision_audit_smoke_result.json`에 `coachingMentionsPatternSpecificNextObjective=true`, `care_review_recommended_replay_smoke_result.json`에 `recommendationUsesDecisionAuditCoachingLabel=true`가 기록된다.
- Steam 제출 preflight와 릴리즈 후보 감사가 새 코칭 목표/버튼 라벨 QA를 필수 조건으로 확인한다.
- Windows 릴리즈 빌드: `Logs/build_windows_decision_audit_coaching_objective_label.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_decision_audit_coaching_objective_label_v030.log` 통과, `Logs/runtime_recommended_replay_decision_audit_coaching_objective_label_v030.log` 통과.
- 플레이테스트 패킷/집계 QA: `Logs/runtime_playtest_packet_decision_audit_coaching_objective_label_v030.log` 통과, `Logs/runtime_playtest_aggregate_decision_audit_coaching_objective_label_v030.log` 통과.
- 릴리즈 후보 감사: `Logs/audit_release_candidate_decision_audit_coaching_objective_label_retry.log`, `checkCount=255`, `passedCheckCount=255`, `localBlockerCount=0`.
- 배포 무결성: `Logs/audit_distribution_integrity_decision_audit_coaching_objective_label_final.log`, `checkCount=118`, `passedCheckCount=118`.
- 최신 SHA256: release `D85DF8AE7E08E0EC9C9365EF8F908D595BCD370DC1C8D79A12CAE709E0AF6D47`, playtest kit `46A70C531C5293764E2FCA61F766E2099FFD51F25A46BDF43F66016111917063`, Steamworks `E47773804586B2D475CF9721473CAC81A16207D899FB2F859A75764F87859C50`, handoff `55797C0962555BA9AC66E121CA97D3632902EF69BBA58B36EE86CB883525F34C`.

### 2026-06-03 결정 감사 코칭 진행 HUD QA

- 추천 회차가 결정 감사 코칭 목표에서 시작되면 캠페인 상태에 코칭 패턴, 목표, 사유를 저장한다.
- 회차 브리핑에 `결정 감사 코칭 목표`를 추가하고, 심사 기준 패널에 `결정 감사 코칭 진행` HUD를 표시한다.
- HUD는 `처리 0/40`에서 첫 판단 후 `처리 1/40`로 갱신되며, 고비용 지원/고위험 지연/권장 불일치/이의제기 보정 집중 지표를 패턴별로 보여준다.
- `care_review_decision_audit_coaching_hud_smoke_result.json`에 `coachingStateApplied=true`, `briefingMentionsCoachingObjective=true`, `reviewHudMentionsCoachingObjective=true`, `reviewHudUpdatesAfterDecision=true`가 기록된다.
- Steam 제출 preflight와 릴리즈 후보 감사가 새 코칭 HUD QA를 필수 조건으로 확인한다.
- Windows 릴리즈 빌드: `Logs/build_windows_decision_audit_coaching_hud_manifest.log`, `Build Successful`.
- 런타임 QA: `Logs/runtime_decision_audit_coaching_hud_final_v030.log` 통과.
- Steamworks 패키징: `Logs/prepare_steamworks_decision_audit_coaching_hud.log`.
- 외부 검증 handoff: `Logs/build_handoff_decision_audit_coaching_hud.log`.
- 최신 SHA256: release `7CE61894F3A69E48A924B993465D8CED36A629F4BBB7D0D64D31E68DD74EA58D`, playtest kit `AB70BF761DD44BFA87EAC43F3A878BFCCFC3BA0167BCF55A472F429F87FA56EB`, Steamworks `6C4BAA9C124BC4A42E1A86AFF6CD48AE6F21D9CEDFA863DB18469821E75D0CCF`, handoff `CDD4F22D9536FE941E7E54D03769A14D48826F2281F85B6043EB06478D455C6D`.

### 2026-06-03 Store Presence 브리핑 회고 후보 입력란 분리 QA

- Store Presence 증거 초안에서 12번 상점 후보의 브리핑 회고 근거를 `briefing_retrospective_candidate_*` 별도 입력란으로 분리했다.
- 증거 초안, 예시 노트, 템플릿, Evidence README, handoff README, QA 카드가 `briefing_retrospective_candidate_evidence`, `briefing_retrospective_candidate_file`, `briefing_retrospective_candidate_terms`, `briefing_retrospective_candidate_smoke`를 같은 필드로 대조한다.
- `12_career_record_next_objective.png`, `care_review_career_record_smoke_result.json`, `storeCandidateMentionsBriefingRetrospective=true`, `브리핑 회고|예고 위험|실제 결과`를 Store Presence 증거 묶음 11번째 체크로 승격했다.
- Steamworks 업로드 준비 문서와 플레이테스트 QA 패킷의 Store Presence Draft 독립 체크/TODO 요약에 `브리핑 회고 후보`를 추가했다.
- 프리플라이트 최상단 Store Presence 증거 묶음 판정도 `checkCount=11`, `passedCheckCount=11`, `allPassed=true`를 기준으로 수정했다.
- 검증 로그: `Logs/compile_store_presence_briefing_retrospective_fields.log` 오류 없음, `Logs/prepare_steamworks_store_presence_briefing_retrospective_fields_final_sync_retry.log` preflight `localBlockerCount=0`, `Logs/audit_release_candidate_store_presence_briefing_retrospective_fields_final_pass.log` 257/257 통과, `Logs/audit_distribution_integrity_store_presence_briefing_retrospective_fields_final.log` 120/120 통과.
- 최신 SHA256: release `7CE61894F3A69E48A924B993465D8CED36A629F4BBB7D0D64D31E68DD74EA58D`, playtest kit `AB70BF761DD44BFA87EAC43F3A878BFCCFC3BA0167BCF55A472F429F87FA56EB`, Steamworks `6C4BAA9C124BC4A42E1A86AFF6CD48AE6F21D9CEDFA863DB18469821E75D0CCF`, handoff `F19F961BE1EA901094992F044BB99212B46967C7198E8D9DD3CE475E031C29A3`.











