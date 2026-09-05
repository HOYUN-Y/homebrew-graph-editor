cask "graph-editor" do
  version "0.1.0"
  sha256 "a90371de646d8373ac43d3a445e0f211b56f56e78f2f9cd436109ecf71f4a6d0"

  url "https://github.com/HOYUN-Y/homebrew-graph-editor/releases/download/v#{version}/graph-editor-#{version}-arm64.dmg"
  name "Graph Editor"
  desc "문서·도식·표·코드를 한 곳에서 쓰는 편집기"
  homepage "https://editor.devprofessional.xyz"

  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "Graph Editor.app"

  # 앱은 ad-hoc 서명이라 Developer ID 가 없다. quarantine 이 붙으면 Gatekeeper 가 막으므로
  # 설치할 때 --no-quarantine 을 붙인다. 자세한 내용은 README 참고.

  zap trash: [
    "~/Library/Application Support/desktop-shell",
    "~/Library/Preferences/xyz.devprofessional.editor.plist",
    "~/Library/Saved Application State/xyz.devprofessional.editor.savedState",
  ]
end
