cask "graph-editor" do
  version "0.2.0"
  sha256 "0c11b68fdd4db511b9bf3eb243028545f06b163decba50accc8dce25de3793ba"

  url "https://github.com/HOYUN-Y/homebrew-graph-editor/releases/download/v#{version}/graph-editor-#{version}-arm64.dmg"
  name "Graph Editor"
  desc "문서·도식·표·코드를 한 곳에서 쓰는 편집기"
  homepage "https://editor.devprofessional.xyz/"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Graph Editor.app"

  # 이 앱은 ad-hoc 서명이라 Developer ID 가 없다. brew 가 내려받은 파일에는 quarantine 이 붙고
  # Gatekeeper 는 Developer ID 가 아닌 앱을 거부한다(`spctl -a` → rejected).
  #
  # Homebrew 6 에서 `--no-quarantine` 플래그가 없어졌으므로 설치 직후 여기서 직접 떼어 낸다.
  # 사용자가 매번 플래그를 기억하지 않아도 되고, 시스템 설정 우회 절차도 필요 없다.
  # Developer ID 서명·공증을 도입하면(PLAN O8) 이 블록을 지운다.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Graph Editor.app"]
  end

  # 실행 중인 앱은 brew 가 교체하지 못한다. 이게 없으면 `brew upgrade` 전에 사용자가 손으로
  # 앱을 꺼야 하고, 안 끄면 업그레이드가 그냥 실패한다. brew 가 대신 종료하게 맡긴다.
  # (upgrade 는 구버전 uninstall 을 먼저 하므로 이 stanza 가 그때 걸린다.)
  uninstall quit: "xyz.devprofessional.editor"

  zap trash: [
    "~/Library/Application Support/desktop-shell",
    "~/Library/Preferences/xyz.devprofessional.editor.plist",
    "~/Library/Saved Application State/xyz.devprofessional.editor.savedState",
  ]
end
