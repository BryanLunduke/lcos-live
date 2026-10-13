# 0.9.4: Realtek USB Wi-Fi (LCOS #138)

- Kernel: LLK 7.2.6-lcos22 (PR #18, 1f5d4e60, tag 7.2.6-lcos22) adds `RTW89_8852CU`,
  `RTW89_8852BU`, `RTW89_8851BU`, `RTW89_8922AU` (USB Wi-Fi 6/6E/7, incl. TP-Link 35bc:0101/0102
  RTL8852CU) and `RTW88_8814AE` (PCIe), all =m. RTW88 SDIO variants stay off. 955 modules.
- Firmware: the drivers request the newest format and fall back to older ones. firmware-realtek
  20250410-2 (excalibur) has a usable file for every chip; 20260810-1~bpo13+1 (excalibur-backports)
  has the newest (rtw8852c_fw-2, rtw8852b_fw-2, rtw8851b_fw-1, rtw8922a_fw-4).
- Pin: firmware-realtek added to the backports pin (Pin-Priority 990) in
  config/archives/lcos-amd-backports.pref.{chroot,binary} and the copy lcos-base 0.9.4-2 ships in
  /etc/apt/preferences.d, so ISO builds and upgraders both get 20260810-1~bpo13+1.
- Check (2026-10-13, against the lcos-live-093-04 package state + Devuan excalibur/-security/
  -updates/-backports + LCOS overlay): candidate 20260810-1~bpo13+1 at 990; `apt-get -s install`
  of all pinned firmware and `dist-upgrade` = only firmware-realtek upgraded, nothing removed or
  broken; real `dpkg -i` in an overlay of the 093-04 chroot: installs cleanly next to
  firmware-misc-nonfree/firmware-linux-nonfree/firmware-amd-graphics 20260810-1~bpo13+1, `dpkg -C` clean.
  The backports deb only Conflicts/Replaces firmware-realtek-rtl8723cs-bt (not on LCOS).
- Not tested: real adapters (needs hardware).
