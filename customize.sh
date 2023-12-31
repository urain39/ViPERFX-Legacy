CONFIG_FILE="/system/etc/audio_effects.conf"
VENDOR_CONFIG_FILE="/system/vendor/etc/audio_effects.conf"
AUDIO_POLICY_FILE="/system/etc/audio_policy.conf"


make_copy() {
  local d="$MODPATH${1%/*}"
  mkdir -p "$d"
  cp -p "$1" "$d"
  echo "$MODPATH$1"
}


CONFIG_FILE="$(make_copy "$CONFIG_FILE")"
VENDOR_CONFIG_FILE="$(make_copy "$VENDOR_CONFIG_FILE")"
AUDIO_POLICY_FILE="$(make_copy "$AUDIO_POLICY_FILE")"


sed -i \
  -e '/v4a_fx {/,/}/d' \
  -e '/v4a_standard_fx {/,/}/d' \
  -e 's/^libraries {/libraries {\n  v4a_fx {\n    path \/system\/lib\/soundfx\/libv4a_fx_ics.so\n  }/g' \
  -e 's/^effects {/effects {\n  v4a_standard_fx {\n    library v4a_fx\n    uuid 41d3c987-e6cf-11e3-a88a-11aba5d5c51b\n  }/g' \
  "$CONFIG_FILE" "$VENDOR_CONFIG_FILE"
sed -i '/deep_buffer {/,/}/d' "$AUDIO_POLICY_FILE"
