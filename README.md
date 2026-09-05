# homebrew-graph-editor

[graph editor](https://editor.devprofessional.xyz) 데스크톱 앱의 Homebrew tap.

## 설치

```bash
brew install --cask --no-quarantine HOYUN-Y/graph-editor/graph-editor
```

```bash
brew upgrade --cask graph-editor          # 업데이트
brew uninstall --zap --cask graph-editor  # 제거 (로그인 세션까지 정리)
```

## `--no-quarantine` 이 왜 필요한가

앱은 **ad-hoc 서명**이다. Apple Silicon 이 arm64 바이너리에 요구하는 최소 조건은 만족하지만
Developer ID 서명·공증은 하지 않았다. brew 가 내려받은 파일에는 `com.apple.quarantine` 이 붙고,
Gatekeeper 는 Developer ID 가 아닌 앱을 차단한다.

`--no-quarantine` 을 빼면 첫 실행에서 `시스템 설정 → 개인정보 보호 및 보안 → 확인 없이 열기` 를
한 번 거쳐야 한다. macOS 15(Sequoia)부터 우클릭 → 열기 우회가 제거됐다.

서명을 붙이려면 Apple Developer Program(연 $99)이 필요하다. 사용자가 GitHub 계정 allowlist 로
닫혀 있는 동안에는 값이 없다고 판단해 미루고 있다.

## 이 앱이 무엇인가

배포된 웹 앱을 감싸는 Electron 창이다. 로컬 DB 도 로컬 서버도 쓰지 않고
`https://editor.devprofessional.xyz` 에 접속하므로,
**앱 기능 업데이트는 이 tap 을 거치지 않는다** — 서버에 배포하면 앱을 다시 켜는 순간 최신이다.

이 tap 으로 배포하는 것은 셸 자체(창·새 창 정책·Electron 버전·아이콘)의 변경뿐이다.

## 요구사항

- macOS 15(Sequoia) 이상
- Apple Silicon (arm64). Intel Mac 은 지원하지 않는다.

## 릴리스 만들기 (관리자용)

소스는 별도 private 저장소의 `spikes/desktop-shell/` 에 있다.

```bash
cd <graph_editor>/spikes/desktop-shell
nvm use 22
npm run dist
shasum -a 256 dist/graph-editor-<version>-arm64.dmg
gh release create v<version> dist/*.dmg --repo HOYUN-Y/homebrew-graph-editor
```

그 뒤 `Casks/graph-editor.rb` 의 `version` 과 `sha256` 을 갱신해 커밋·푸시한다.
