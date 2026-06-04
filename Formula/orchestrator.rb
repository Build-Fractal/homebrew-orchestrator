# packaging/homebrew/orchestrator.rb.tmpl
#
# Homebrew formula template for @build-fractal/orchestrator.
# Rendered by packaging/homebrew/render-formula.sh at release time
# via .github/workflows/release.yml § homebrew-publish.
#
# Substitution tokens (replaced verbatim by render-formula.sh):
#   0.9.7   -- semver string, e.g. 1.0.0
#   https://github.com/Build-Fractal/orchestrator/releases/download/v0.9.7/build-fractal-orchestrator-0.9.7.tgz       -- https URL of the npm pack tarball published
#                    on the GitHub release (D007: re-use the P05-
#                    signed @build-fractal/orchestrator tarball
#                    rather than a separate brew-tarball; single
#                    source-of-truth for cross-channel byte-
#                    equivalence per CON-5).
#   e2a2e2a2593c38777da3a2d4c1e046acbe9ecbd81907c62323262d95eac61392    -- 64-hex-char SHA-256 of the tarball, sourced
#                    from the SHA256SUMS file in the GitHub release
#                    (P05 T03 publishes this).
#
# FR-9: no formula-specific install logic. def install does
# filesystem staging only; per-project skill registration via
# M025's manifest is deferred to /orchestrator-init.

class Orchestrator < Formula
  desc "Autonomous multi-phase software-engineering orchestrator"
  homepage "https://github.com/Build-Fractal/orchestrator"
  url "https://github.com/Build-Fractal/orchestrator/releases/download/v0.9.7/build-fractal-orchestrator-0.9.7.tgz"
  version "0.9.7"
  sha256 "e2a2e2a2593c38777da3a2d4c1e046acbe9ecbd81907c62323262d95eac61392"
  license "MIT"

  def install
    # The npm pack tarball extracts into a top-level "package/"
    # directory per npm's tarball convention. Stage its contents
    # (NOT the wrapping "package/" dir) into the formula prefix.
    prefix.install Dir["package/*"]

    # Wire bin/orchestrator onto PATH via Homebrew's bin symlink.
    bin.install_symlink prefix/"bin/orchestrator"
  end

  test do
    # Acceptance: formula installs, binary is on PATH, --version
    # matches the formula's version field. SC-9 smoke.
    assert_match version.to_s, shell_output("#{bin}/orchestrator --version")
  end
end
