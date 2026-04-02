#!/usr/bin/env bash

set -e

show_help() {
  cat <<EOF
sync remote with ipod. simple wrapper around rsync command

Options:
  -h, --help Show this help message
  // below are positional args actually.. need to fix this output
  -f, --from The music library location
  -t, --to   The local ipod mount

Usage:
  sync-ipod user@servername:/mnt/remote-user/share/media/music/ /media/local-user/ipod-name/iPod_Control/Music/
EOF
}

if [[ $# -eq 0 ]]; then
  show_help
  exit 0
fi

FROM=""
TO=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      FROM=$1
      TO=$2
      shift
      ;;
  esac
  shift
done

# modify window should help with timestamp jitter
# run with --dry-run first to see if its still changing everything or not
rsync -avh --no-perms --no-owner --no-group --delete --modify-window=1 $FROM $TO
