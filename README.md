# homebrew-graph-editor

[graph editor](https://editor.devprofessional.xyz) 데스크톱 앱의 Homebrew tap.

## 설치

```bash
brew install --cask HOYUN-Y/graph-editor/graph-editor
```

```bash
brew upgrade --cask graph-editor          # 업데이트
brew uninstall --zap --cask graph-editor  # 제거 (로그인 세션까지 정리)
```

별도 플래그가 필요 없다. 아래 이유로 cask 가 알아서 처리한다.

## quarantine 처리

앱은 **ad-hoc 서명**이다. Apple Silicon 이 arm64 바이너리에 요구하는 최소 조건은 만족하지만
Developer ID 서명·공증은 하지 않았다. 그래서 brew 가 내려받은 파일에 `com.apple.quarantine` 이
붙으면 Gatekeeper 가 거부한다(`spctl -a` → `rejected`). macOS 15(Sequoia)부터는 우클릭 → 열기
우회도 제거돼서, 사용자가 `시스템 설정 → 개인정보 보호 및 보안 → 확인 없이 열기` 를 거쳐야 한다.

예전에는 `brew install --cask --no-quarantine` 으로 피했지만 **Homebrew 6 에서 그 플래그가
없어졌다.** 그래서 이 cask 는 `postflight` 에서 설치 직후 quarantine 속성을 직접 떼어 낸다.
사용자가 플래그를 기억할 필요도, 시스템 설정을 열 필요도 없다.

Developer ID 서명·공증을 도입하면 이 처리는 필요 없어진다. 연 $99 가 들고, 사용자가 GitHub 계정
allowlist 로 닫혀 있는 동안에는 값이 없다고 판단해 미루고 있다.

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
gh release create v<version> dist/graph-editor-<version>-arm64.dmg --repo HOYUN-Y/homebrew-graph-editor
```

`dist/*.dmg` 로 올리지 않는다 — `dist/` 에 이전 버전 dmg 가 남아 있으면 구버전까지 같이 릴리스에
붙는다. 파일명을 명시하거나 빌드 전에 `rm -f dist/*.dmg` 로 비운다.

그 뒤 `Casks/graph-editor.rb` 의 `version` 과 `sha256` 을 갱신해 커밋·푸시한다.
