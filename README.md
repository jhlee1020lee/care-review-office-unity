# Care Review Office Unity

`돌봄지원 심사소` Unity 프로젝트 소스 저장소입니다.

플레이어는 돌봄지원 신청 사례를 검토하고, 예산·안정·형평·누락 위험·민원 지표를 고려해 승인, 조건부 승인, 보류, 추가조사, 거절을 결정합니다. 캠페인 종료 후에는 심사 기록, 최종 리포트, 판단 비교, 판단 복기, 성과 기록을 확인할 수 있습니다.

## Project

- Unity: `6000.4.5f1`
- Target: Windows 64-bit
- Main scene: `Assets/Scenes/CareReviewOffice.unity`
- Main runtime script: `Assets/Scripts/CareReviewGame.cs`
- Editor build helper: `Assets/Editor/CareReviewProjectBuilder.cs`

## Source Layout

- `Assets/`: Unity scenes, scripts, resources, art, fonts, audio
- `Packages/`: Unity package manifest and lock file
- `ProjectSettings/`: Unity project settings
- `Docs/`: AI 활용 기록, QA, 출시 준비 문서
- `Tools/`: local utility scripts

Generated or local-only folders are ignored by git:

- `Library/`
- `Builds/`
- `Logs/`
- `Backups/`
- `UserSettings/`
- `CareReviewOffice_Final_Submission/`

## Audio Assets

The project includes internally synthesized WAV assets under `Assets/Resources/Audio`.

- BGM: 5 office-tone loops in `Assets/Resources/Audio/Bgm`
- SFX: 20 UI, paper, stamp, incident, save, report, toast, and error cues in `Assets/Resources/Audio/Sfx`
- Generator: `Tools/generate_care_review_audio.py`

No external copyrighted music or sample libraries are used for these WAV files.

To regenerate the audio assets:

```powershell
python Tools\generate_care_review_audio.py
```

## Build

From Unity:

1. Open this project in Unity `6000.4.5f1`.
2. Use menu `Care Review Office > Build Windows Release Package`, or call the editor method below.

From PowerShell:

```powershell
& 'C:\Program Files\Unity\Hub\Editor\6000.4.5f1\Editor\Unity.exe' `
  -batchmode -quit `
  -projectPath . `
  -executeMethod CareReviewProjectBuilder.BuildWindows `
  -logFile Logs\build_windows.log
```

The generated Windows player is written under `Builds/Windows`, which is intentionally not tracked by git.

For player distribution, use the generated release zip under `Builds/Release` and extract it as a whole folder. Do not copy or run only `CareReviewOffice.exe`; the player must stay beside `CareReviewOffice_Data`, `MonoBleedingEdge`, `D3D12`, `UnityPlayer.dll`, `dstorage.dll`, and `dstoragecore.dll`.

## Developer QA

The release player under `Builds/Windows` is intended for normal play and does not include `-careReview...` automation commands. Runtime checks use the separate QA tools build under `Builds/Windows_QA`:

```powershell
& 'C:\Program Files\Unity\Hub\Editor\6000.4.5f1\Editor\Unity.exe' `
  -batchmode -quit `
  -projectPath . `
  -executeMethod CareReviewProjectBuilder.BuildWindowsQaTools `
  -logFile Logs\build_windows_qa_tools.log

.\Builds\Windows_QA\CareReviewOffice.exe -batchmode -nographics -logFile Logs\runtime_smoke.log -careReviewSmokeTest
.\Builds\Windows_QA\CareReviewOffice.exe -batchmode -nographics -logFile Logs\runtime_audio_smoke.log -careReviewAudioSmokeTest
.\Builds\Windows_QA\CareReviewOffice.exe -logFile Logs\runtime_low_resolution.log -careReviewLowResolutionSmokeTest
```

Recent audio validation confirmed:

- `loadedBgmCount=5`
- `loadedSfxCount=20`
- `screenBgmKeysExpected=true`
- `zeroVolumeSfxPlayed=false`
- `zeroVolumeMusicMuted=true`

## Backup Notes

This repository tracks the Unity project source. Local build output, runtime logs, Unity cache data, and final submission packages are excluded to keep the repository manageable.

For a one-file local backup, use a zip containing:

- `.gitignore`
- `Assets/`
- `Packages/`
- `ProjectSettings/`
- `Docs/`
- `Tools/`
