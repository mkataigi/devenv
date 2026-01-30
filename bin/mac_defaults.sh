#!/bin/sh

# base
defaults write NSGlobalDomain AppleLanguages -array-add ja-JP
defaults write NSGlobalDomain AppleLocale -string ja_JP

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation left

# スクリーンセーバー起動時にパスワードロックする
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5

# ホットコーナー：左上 → ディスプレイをスリープ
defaults write com.apple.dock wvous-tl-corner -int 10
defaults write com.apple.dock wvous-tl-modifier -int 0

# メニューバー
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm"

# Finder
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder AppleShowAllFiles TRUE
defaults write com.apple.finder FXPreferredViewStyle clmv
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder QLEnableTextSelection -bool true
chflags nohidden ~/Library

# Keyboard Mouse
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# ネットワークフォルダに.DS_Storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# ファイルを開く際の警告ダイアログを無効にする
defaults write com.apple.LaunchServices LSQuarantine -bool false
# 印刷ダイアログを詳細設定で表示
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -boolean true
# 外部ディスプレイでアンチエイリアスを有効にする
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -boolean true

# スクリーンショット
defaults write com.apple.screencapture type jpg
defaults write com.apple.screencapture location ~/Pictures/

# shortcut key
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>18</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>19</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>20</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 121 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>21</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 122 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>22</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 123 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>23</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 124 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>24</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 125 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>25</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 126 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>26</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

# CTRL <=> Tab
vid=$(ioreg -r -n 'Apple Internal Keyboard / Trackpad' | grep -E 'idVendor' | head -n 1 | awk '{ print $4 }')
pid=$(ioreg -r -n 'Apple Internal Keyboard / Trackpad' | grep -E 'idProduct' | head -n 1 | awk '{ print $4 }')
keyboard_id=${vid}-${pid}-0
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboard_id} -array-add '
<dict>
  <key>HIDKeyboardModifierMappingDst</key>
  <integer>30064771300</integer>
  <key>HIDKeyboardModifierMappingSrc</key>
  <integer>30064771129</integer>
</dict>
'
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboard_id} -array-add '
<dict>
  <key>HIDKeyboardModifierMappingDst</key>
  <integer>30064771129</integer>
  <key>HIDKeyboardModifierMappingSrc</key>
  <integer>30064771296</integer>
</dict>
'
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboard_id} -array-add '
<dict>
  <key>HIDKeyboardModifierMappingDst</key>
  <integer>30064771129</integer>
  <key>HIDKeyboardModifierMappingSrc</key>
  <integer>30064771300</integer>
</dict>
'

# reload
killall Dock
killall Finder
killall SystemUIServer
