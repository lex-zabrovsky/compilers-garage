#!/usr/bin/env bash
#
# generate-index.sh — regenerate the volatile post lists in:
#   - demo/index.md        (the "Latest Posts" bullets, newest N)
#   - demo/blog-index.md   (the full archive grouped by year/month)
#
# Lists are emitted between HTML-comment markers in those files, which keeps
# the surrounding hand-written prose untouched. Pandoc passes HTML comments
# through to the rendered HTML, so the markers are invisible on the page.
#
# Source of truth for each post:
#   date  <- the leading YYYY-MM-DD prefix of the filename
#   title <- the `title:` field in the post's YAML frontmatter
#
# Run by `make` before pandoc. Idempotent: running twice yields the same output.
#
# Note: no `pipefail` on purpose. This script uses early-exit pipeline consumers
# (awk `exit` after the first title match, truncating to the top-N posts), and
# under `pipefail` the SIGPIPE those deliver to the upstream stage would be
# misreported as a failure. `-u` still guards against unset variables.
set -eu

# --- config ---------------------------------------------------------------
POSTS_DIR="demo/_posts"
INDEX_MD="demo/index.md"
BLOG_INDEX_MD="demo/blog-index.md"
LATEST_N=4                       # how many posts to show on the home page

# Resolve paths relative to the project root (this script may be invoked via
# `bash scripts/generate-index.sh` from the Makefile).
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POSTS_DIR="$ROOT/$POSTS_DIR"
INDEX_MD="$ROOT/$INDEX_MD"
BLOG_INDEX_MD="$ROOT/$BLOG_INDEX_MD"

# --- helpers --------------------------------------------------------------

# Extract the frontmatter title from a post. Handles both quoted and unquoted
# YAML values:   title: "Foo Bar"   or   title: Foo Bar
get_title() {
  # Grab the first `title:` line in the frontmatter (everything up to the
  # closing `---`), strip the key, and trim surrounding quotes/whitespace.
  sed -n '/^---$/,/^---$/p' "$1" \
    | awk -F': ' '/^title:/ {sub(/^title:[[:space:]]*/, ""); print; exit}' \
    | sed -e 's/^"//' -e 's/"$//' -e 's/^'"'"'//' -e 's/'"'"'$//' \
    | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# Format an ISO date (YYYY-MM-DD) as "Month D, YYYY" (no leading zero on day).
# Uses GNU date (coreutils), which the Nix shell / Alpine build env provide.
format_date() {
  date -d "$1" +'%B %-d, %Y'
}

# Read all posts into a tab-separated TSV stream on stdout, one post per line:
#   ISO_DATE <TAB> SORT_KEY <TAB> URL <TAB> DISPLAY_DATE <TAB> TITLE
# SORT_KEY = ISO_DATE (YYYY-MM-DD), used for descending sort.
collect_posts() {
  local f base iso disp title
  shopt -s nullglob
  for f in "$POSTS_DIR"/*.md; do
    base="$(basename "$f" .md)"
    # filename must start with YYYY-MM-DD; skip silently if it doesn't
    if [[ ! "$base" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})- ]]; then
      echo "generate-index: skipping (bad filename date): $f" >&2
      continue
    fi
    iso="${BASH_REMATCH[1]}"
    disp="$(format_date "$iso")"
    title="$(get_title "$f")"
    if [[ -z "$title" ]]; then
      echo "generate-index: no title found in $f" >&2
      title="(untitled)"
    fi
    printf '%s\t%s\t%s\t%s\t%s\n' "$iso" "$iso" "$base.html" "$disp" "$title"
  done
  shopt -u nullglob
}

# Replace the region between <!-- BEGIN $marker --> and <!-- END $marker -->
# in $file with the contents of stdin. Everything outside the markers is
# preserved verbatim. If the markers are missing, the file is left unchanged
# and a warning is printed.
replace_between() {
  local marker="$1" file="$2" tmp
  tmp="$(mktemp)"
  cat >"$tmp"
  # awk: print lines as-is; when we see BEGIN, stop printing and slurp the new
  # content, then skip original lines until END. After END, resume printing.
  awk -v marker="$marker" -v newfile="$tmp" '
    BEGIN { state = "copy" }
    state == "copy" {
      print
      if ($0 ~ "<!-- BEGIN " marker " -->") {
        while ((getline line < newfile) > 0) print line
        close(newfile)
        state = "skip"
      }
      next
    }
    state == "skip" {
      if ($0 ~ "<!-- END " marker " -->") {
        print
        state = "copy"
      }
      next
    }
  ' "$file" >"$file.tmp" && mv "$file.tmp" "$file"
  rm -f "$tmp"
}

# --- build the home page "Latest Posts" list ------------------------------
generate_latest() {
  # `sed -n "1,Np"` (rather than `head -n N`) so the upstream is fully drained
  # — with `set -o pipefail`, an early-closing `head` would deliver SIGPIPE to
  # `sort` and fail the pipeline.
  collect_posts \
    | sort -t$'\t' -k2,2 -r \
    | sed -n "1,${LATEST_N}p" \
    | while IFS=$'\t' read -r _ _ url disp title; do
        printf -- '- [%s](%s) - %s\n' "$title" "$url" "$disp"
      done
}

# --- build the full archive grouped by year/month -------------------------
generate_archive() {
  local prev_year="" prev_month=""
  # sort by ISO date descending — year and month groups then fall out naturally
  collect_posts | sort -t$'\t' -k2,2 -r | while IFS=$'\t' read -r iso _ url disp title; do
    local year="${iso%%-*}"          # YYYY
    local rest="${iso#*-}"           # MM-DD
    local month="${rest%%-*}"        # MM

    if [[ "$year" != "$prev_year" ]]; then
      printf '\n## %s\n' "$year"
      prev_year="$year"
      prev_month=""
    fi
    if [[ "$month" != "$prev_month" ]]; then
      printf '\n### %s\n' "$(date -d "$iso" +'%B')"
      prev_month="$month"
    fi
    printf -- '- [%s](%s) - %s\n' "$title" "$url" "$disp"
  done
}

# --- main -----------------------------------------------------------------
main() {
  if [[ ! -d "$POSTS_DIR" ]]; then
    echo "generate-index: posts dir not found: $POSTS_DIR" >&2
    exit 1
  fi
  if [[ ! -f "$INDEX_MD" ]]; then
    echo "generate-index: index not found: $INDEX_MD" >&2
    exit 1
  fi

  # Home page list first — feed it through a temp file so we only touch the
  # source if generation actually succeeded.
  local latest_tmp archive_tmp
  latest_tmp="$(mktemp)"
  archive_tmp="$(mktemp)"
  generate_latest  >"$latest_tmp"
  generate_archive >"$archive_tmp"

  # Sanity: if no posts at all, leave the files untouched rather than emitting
  # an empty list.
  if [[ ! -s "$latest_tmp" ]]; then
    echo "generate-index: no posts found; leaving indexes unchanged" >&2
    rm -f "$latest_tmp" "$archive_tmp"
    return 0
  fi

  cat "$latest_tmp"  | replace_between "latest-posts" "$INDEX_MD"
  cat "$archive_tmp" | replace_between "all-posts"    "$BLOG_INDEX_MD"

  rm -f "$latest_tmp" "$archive_tmp"
}

main "$@"
