#!/usr/bin/env bash
set -euo pipefail

MODE="package"
APP_NAME="OrchestratorConsole"
BUNDLE_NAME="Orchestrator Console"
BUNDLE_ID="cz.antstudio.OrchestratorConsole"
MIN_SYSTEM_VERSION="14.0"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/apps/orchestrator-console"
DIST_DIR="$APP_DIR/dist"
APP_BUNDLE="$DIST_DIR/$BUNDLE_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_BINARY="$APP_MACOS/$APP_NAME"
INFO_PLIST="$APP_CONTENTS/Info.plist"
PKG_INFO="$APP_CONTENTS/PkgInfo"
APP_ICON="$APP_DIR/Sources/OrchestratorConsole/Resources/AppIcon.icns"
DMG_STAGING="$DIST_DIR/dmg-staging"
SWIFTPM_CACHE="$APP_DIR/.build/swiftpm-cache"
CLANG_CACHE="$APP_DIR/.build/module-cache"

usage() {
  cat >&2 <<USAGE
usage: $0 [--package-only|--install]

Builds Orchestrator Console locally as a .app bundle, installer PKG, and drag-to-Applications DMG.

Options:
  --package-only   Build the .app and DMG only (default).
  --install        Build the .app and DMG, then copy the app to /Applications.

Environment:
  ORCHESTRATOR_CONSOLE_VERSION  Version written to Info.plist and local artifact names.
  CODE_SIGN_IDENTITY            Optional Developer ID Application identity for codesign.
  INSTALLER_SIGN_IDENTITY       Optional Developer ID Installer identity for pkgbuild.
  REQUIRE_SIGNING               Set to 1 to fail unless Developer ID signing identities are present.
  NOTARIZE                      Set to 1 to notarize and staple the app, PKG, and DMG.
  APPLE_ID                      Apple ID used by xcrun notarytool when NOTARIZE=1.
  APPLE_TEAM_ID                 Apple Developer Team ID used by xcrun notarytool when NOTARIZE=1.
  APPLE_APP_SPECIFIC_PASSWORD   App-specific password used by xcrun notarytool when NOTARIZE=1.
USAGE
}

case "${1:---package-only}" in
  --package-only|package)
    MODE="package"
    ;;
  --install|install)
    MODE="install"
    ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    usage
    exit 2
    ;;
esac

version_from_git() {
  local tag
  tag="$(git -C "$ROOT_DIR" describe --tags --abbrev=0 2>/dev/null || true)"
  if [[ -n "$tag" ]]; then
    printf "%s" "${tag#v}"
  else
    printf "0.1.0"
  fi
}

VERSION="${ORCHESTRATOR_CONSOLE_VERSION:-$(version_from_git)}"
DMG_NAME="Orchestrator-Console-$VERSION.dmg"
DMG_PATH="$DIST_DIR/$DMG_NAME"
PKG_NAME="Orchestrator-Console-$VERSION.pkg"
PKG_PATH="$DIST_DIR/$PKG_NAME"
APP_NOTARY_ZIP="$DIST_DIR/Orchestrator-Console-$VERSION-app-notary.zip"
REQUIRE_SIGNING="${REQUIRE_SIGNING:-0}"
NOTARIZE="${NOTARIZE:-0}"

command -v swift >/dev/null
command -v hdiutil >/dev/null
command -v pkgbuild >/dev/null

if [[ "$NOTARIZE" == "1" ]]; then
  command -v xcrun >/dev/null
fi

fail() {
  echo "error: $*" >&2
  exit 1
}

if [[ "$REQUIRE_SIGNING" == "1" || "$NOTARIZE" == "1" ]]; then
  [[ -n "${CODE_SIGN_IDENTITY:-}" ]] || fail "CODE_SIGN_IDENTITY is required for distributable builds."
  [[ -n "${INSTALLER_SIGN_IDENTITY:-}" ]] || fail "INSTALLER_SIGN_IDENTITY is required for distributable builds."
fi

if [[ "$NOTARIZE" == "1" ]]; then
  [[ -n "${APPLE_ID:-}" ]] || fail "APPLE_ID is required when NOTARIZE=1."
  [[ -n "${APPLE_TEAM_ID:-}" ]] || fail "APPLE_TEAM_ID is required when NOTARIZE=1."
  [[ -n "${APPLE_APP_SPECIFIC_PASSWORD:-}" ]] || fail "APPLE_APP_SPECIFIC_PASSWORD is required when NOTARIZE=1."
fi

notarytool_submit() {
  local artifact="$1"
  xcrun notarytool submit "$artifact" \
    --apple-id "$APPLE_ID" \
    --team-id "$APPLE_TEAM_ID" \
    --password "$APPLE_APP_SPECIFIC_PASSWORD" \
    --wait
}

sign_path() {
  local identity="$1"
  local path="$2"
  local args=(--force --deep --options runtime --sign "$identity")

  if [[ "$identity" != "-" ]]; then
    args+=(--timestamp)
  fi

  codesign "${args[@]}" "$path"
}

cd "$APP_DIR"
mkdir -p "$SWIFTPM_CACHE" "$CLANG_CACHE"
export CLANG_MODULE_CACHE_PATH="$CLANG_CACHE"
swift build -c release --cache-path "$SWIFTPM_CACHE"
BUILD_DIR="$(swift build -c release --cache-path "$SWIFTPM_CACHE" --show-bin-path)"
BUILD_BINARY="$BUILD_DIR/$APP_NAME"
RESOURCE_BUNDLE="$BUILD_DIR/OrchestratorConsole_OrchestratorConsole.bundle"

rm -rf "$APP_BUNDLE" "$DMG_STAGING" "$DMG_PATH" "$PKG_PATH" "$APP_NOTARY_ZIP"
mkdir -p "$APP_MACOS" "$APP_RESOURCES"
cp "$BUILD_BINARY" "$APP_BINARY"
chmod +x "$APP_BINARY"

if [[ -d "$RESOURCE_BUNDLE" ]]; then
  cp -R "$RESOURCE_BUNDLE" "$APP_RESOURCES/"
fi

if [[ -f "$APP_ICON" ]]; then
  cp "$APP_ICON" "$APP_RESOURCES/AppIcon.icns"
fi

cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$BUNDLE_NAME</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>$VERSION</string>
  <key>CFBundleVersion</key>
  <string>$VERSION</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST

printf "APPL????" >"$PKG_INFO"
touch "$APP_BUNDLE"

if [[ -n "${CODE_SIGN_IDENTITY:-}" ]]; then
  sign_path "$CODE_SIGN_IDENTITY" "$APP_BUNDLE"
else
  sign_path "-" "$APP_BUNDLE"
fi

codesign --verify --deep --strict --verbose=2 "$APP_BUNDLE"

if [[ "$NOTARIZE" == "1" ]]; then
  ditto -c -k --keepParent "$APP_BUNDLE" "$APP_NOTARY_ZIP"
  notarytool_submit "$APP_NOTARY_ZIP"
  xcrun stapler staple "$APP_BUNDLE"
  xcrun stapler validate "$APP_BUNDLE"
  spctl --assess --type execute --verbose=4 "$APP_BUNDLE"
  rm -f "$APP_NOTARY_ZIP"
fi

if [[ -n "${INSTALLER_SIGN_IDENTITY:-}" ]]; then
  pkgbuild --component "$APP_BUNDLE" --install-location /Applications --sign "$INSTALLER_SIGN_IDENTITY" "$PKG_PATH"
else
  pkgbuild --component "$APP_BUNDLE" --install-location /Applications "$PKG_PATH"
fi

if [[ "$NOTARIZE" == "1" ]]; then
  notarytool_submit "$PKG_PATH"
  xcrun stapler staple "$PKG_PATH"
  xcrun stapler validate "$PKG_PATH"
  spctl --assess --type install --verbose=4 "$PKG_PATH"
fi

mkdir -p "$DMG_STAGING"
ditto "$APP_BUNDLE" "$DMG_STAGING/$BUNDLE_NAME.app"
ln -s /Applications "$DMG_STAGING/Applications"
hdiutil create -volname "$BUNDLE_NAME" -srcfolder "$DMG_STAGING" -ov -format UDZO "$DMG_PATH"
rm -rf "$DMG_STAGING"

if [[ -n "${CODE_SIGN_IDENTITY:-}" ]]; then
  codesign --force --timestamp --sign "$CODE_SIGN_IDENTITY" "$DMG_PATH"
fi

if [[ "$NOTARIZE" == "1" ]]; then
  notarytool_submit "$DMG_PATH"
  xcrun stapler staple "$DMG_PATH"
  xcrun stapler validate "$DMG_PATH"
  spctl --assess --type open --verbose=4 "$DMG_PATH"
fi

if [[ "$MODE" == "install" ]]; then
  INSTALL_TARGET="/Applications/$BUNDLE_NAME.app"
  rm -rf "$INSTALL_TARGET"
  ditto "$APP_BUNDLE" "$INSTALL_TARGET"
  echo "Installed $BUNDLE_NAME to $INSTALL_TARGET"
fi

echo "App bundle: $APP_BUNDLE"
echo "PKG: $PKG_PATH"
echo "DMG: $DMG_PATH"
