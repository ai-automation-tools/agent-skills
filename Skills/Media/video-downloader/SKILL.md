---
name: video-downloader
description: >-
  Download YouTube videos with customizable quality and format options. Use
  this skill when the user asks to download, save, or grab YouTube videos.
  Supports various quality settings (best, 1080p, 720p, 480p, 360p), multiple
  formats (mp4, webm, mkv), and audio-only downloads as MP3. Hardened for
  Windows: platform-aware output directory, UTF-8 console output, automatic
  JS-runtime detection, and cookie extraction for 403-blocked downloads.
---

# YouTube Video Downloader

Download YouTube videos with full control over quality and format settings.

## Quick Start

```bash
python scripts/download_video.py "https://www.youtube.com/watch?v=VIDEO_ID"
```

Downloads in best available quality as MP4. Output goes to `/mnt/user-data/outputs`
when that sandbox path exists, otherwise to `~/Downloads`.

## Options

| Flag | Values | Default | Purpose |
|:--|:--|:--|:--|
| `-q`, `--quality` | `best`, `1080p`, `720p`, `480p`, `360p`, `worst` | `best` | Video resolution cap |
| `-f`, `--format` | `mp4`, `webm`, `mkv` | `mp4` | Output container (video only) |
| `-a`, `--audio-only` | flag | off | Extract audio as MP3 |
| `-o`, `--output` | path | platform default | Output directory (created if missing) |
| `-c`, `--cookies-from-browser` | `chrome`, `firefox`, `edge`, … | none | Pull YouTube cookies from a browser |

## Examples

```bash
# 1080p MP4
python scripts/download_video.py "URL" -q 1080p

# Audio only as MP3
python scripts/download_video.py "URL" -a

# Custom directory, WebM
python scripts/download_video.py "URL" -q 720p -f webm -o "D:/Media/clips"
```

## Requirements

- **yt-dlp** — auto-installed if missing.
- **ffmpeg** — required to merge separate video and audio streams. Without it,
  only single-stream formats work.
- **A JavaScript runtime** — current yt-dlp needs one to solve YouTube's JS
  challenges. The script auto-detects `deno`, `node`, or `bun` on PATH and
  passes `--js-runtimes` accordingly. Without one, formats are missing and
  downloads may fail partway.

## Troubleshooting

### `HTTP Error 403: Forbidden` partway through a download

Almost always a **stale yt-dlp**. When the extractor falls behind, yt-dlp drops
to a fallback client (e.g. `android vr`) whose media URLs YouTube kills mid-stream —
producing a 403 at a consistent byte offset that survives retries.

```bash
yt-dlp -U          # self-update; check the version actually changed
```

If it persists after updating, try cookies from a logged-in browser:

```bash
python scripts/download_video.py "URL" -c firefox
```

> **Chrome caveat:** Chrome 127+ uses app-bound encryption, so cookie extraction
> fails with `Failed to decrypt with DPAPI`
> ([yt-dlp#10927](https://github.com/yt-dlp/yt-dlp/issues/10927)). Use Firefox,
> or export a `cookies.txt` with a browser extension.

### Resumed download 403s immediately

A stale `.part` file holds an expired media URL. Delete the partials and restart:

```bash
rm "<output-dir>"/*.part
```

### Garbled output or a `UnicodeEncodeError` crash

The script reconfigures stdout to UTF-8 on import, so this should not occur. If
you see it in a derived copy, that copy predates the fix.

## Notes

- Playlists are skipped by default (`--no-playlist`); only the single video downloads.
- Filenames are generated from the video title.
- Retries default to 10 for both whole files and fragments.
- Higher qualities mean larger files — a 10-minute 1080p AV1 video runs ~150–170 MB.

## Provenance

Derived from the upstream `video-downloader` skill in
[`awesome-claude-skills`](https://github.com/anthropics/awesome-claude-skills),
with Windows/robustness fixes applied here:

- Output directory falls back to `~/Downloads` — upstream hardcodes the
  sandbox-only path `/mnt/user-data/outputs`, which does not exist locally.
- `sys.stdout.reconfigure(encoding="utf-8")` — the status emoji crashed on
  cp1252 consoles, masking the real yt-dlp error behind a `UnicodeEncodeError`.
- Error handler surfaces the exit code and yt-dlp's stderr instead of only the
  exception repr.
- Auto-detects and passes a JS runtime.
- Adds `--retries` / `--fragment-retries` and `-c/--cookies-from-browser`.
- Creates the output directory if it does not exist.

These fixes are **not** upstream. Re-syncing the upstream clone will not
overwrite this copy, but it will not deliver them either.
