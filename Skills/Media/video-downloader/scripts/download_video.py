#!/usr/bin/env python3
"""
YouTube Video Downloader
Downloads videos from YouTube with customizable quality and format options.
"""

import argparse
import sys
import subprocess
import json
import os
import shutil
from pathlib import Path

# Windows consoles default to cp1252 and choke on the status emoji below.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# /mnt/user-data/outputs only exists in the sandbox; fall back to ~/Downloads locally.
if os.path.isdir("/mnt/user-data/outputs"):
    DEFAULT_OUTPUT = "/mnt/user-data/outputs"   # sandbox
else:
    DEFAULT_OUTPUT = str(Path.home() / "Downloads")

# yt-dlp needs a JS runtime for YouTube now; use whichever is on PATH.
JS_RUNTIME = next((r for r in ("deno", "node", "bun") if shutil.which(r)), None)


def check_yt_dlp():
    """Check if yt-dlp is installed, install if not."""
    try:
        subprocess.run(["yt-dlp", "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("yt-dlp not found. Installing...")
        subprocess.run([sys.executable, "-m", "pip", "install", "--break-system-packages", "yt-dlp"], check=True)


def base_cmd(cookies_from_browser=None):
    """yt-dlp invocation with the flags YouTube currently requires."""
    cmd = ["yt-dlp"]
    if JS_RUNTIME:
        cmd += ["--js-runtimes", JS_RUNTIME]
    if cookies_from_browser:
        cmd += ["--cookies-from-browser", cookies_from_browser]
    return cmd


def get_video_info(url, cookies_from_browser=None):
    """Get information about the video without downloading."""
    result = subprocess.run(
        base_cmd(cookies_from_browser) + ["--dump-json", "--no-playlist", url],
        capture_output=True,
        text=True,
        check=True
    )
    return json.loads(result.stdout)


def download_video(url, output_path=DEFAULT_OUTPUT, quality="best", format_type="mp4", audio_only=False, cookies_from_browser=None):
    """
    Download a YouTube video.
    
    Args:
        url: YouTube video URL
        output_path: Directory to save the video
        quality: Quality setting (best, 1080p, 720p, 480p, 360p, worst)
        format_type: Output format (mp4, webm, mkv, etc.)
        audio_only: Download only audio (mp3)
        cookies_from_browser: Browser to pull YouTube cookies from (e.g. "chrome")
    """
    check_yt_dlp()

    os.makedirs(output_path, exist_ok=True)

    # Build command
    cmd = base_cmd(cookies_from_browser)
    
    if audio_only:
        cmd.extend([
            "-x",  # Extract audio
            "--audio-format", "mp3",
            "--audio-quality", "0",  # Best quality
        ])
    else:
        # Video quality settings
        if quality == "best":
            format_string = "bestvideo+bestaudio/best"
        elif quality == "worst":
            format_string = "worstvideo+worstaudio/worst"
        else:
            # Specific resolution (e.g., 1080p, 720p)
            height = quality.replace("p", "")
            format_string = f"bestvideo[height<={height}]+bestaudio/best[height<={height}]"
        
        cmd.extend([
            "-f", format_string,
            "--merge-output-format", format_type,
        ])
    
    # Output template
    cmd.extend([
        "-o", f"{output_path}/%(title)s.%(ext)s",
        "--no-playlist",  # Don't download playlists by default
        "--retries", "10",
        "--fragment-retries", "10",
    ])
    
    cmd.append(url)
    
    print(f"Downloading from: {url}")
    print(f"Quality: {quality}")
    print(f"Format: {'mp3 (audio only)' if audio_only else format_type}")
    print(f"Output: {output_path}\n")
    
    try:
        # Get video info first
        info = get_video_info(url, cookies_from_browser)
        print(f"Title: {info.get('title', 'Unknown')}")
        print(f"Duration: {info.get('duration', 0) // 60}:{info.get('duration', 0) % 60:02d}")
        print(f"Uploader: {info.get('uploader', 'Unknown')}\n")
        
        # Download the video
        subprocess.run(cmd, check=True)
        print(f"\n✅ Download complete!")
        return True
    except subprocess.CalledProcessError as e:
        stderr = e.stderr.strip() if isinstance(getattr(e, "stderr", None), str) else ""
        print(f"\n❌ Error downloading video (exit {e.returncode})")
        if stderr:
            print(stderr)
        return False
    except Exception as e:
        print(f"\n❌ Error: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Download YouTube videos with customizable quality and format"
    )
    parser.add_argument("url", help="YouTube video URL")
    parser.add_argument(
        "-o", "--output",
        default=DEFAULT_OUTPUT,
        help=f"Output directory (default: {DEFAULT_OUTPUT})"
    )
    parser.add_argument(
        "-q", "--quality",
        default="best",
        choices=["best", "1080p", "720p", "480p", "360p", "worst"],
        help="Video quality (default: best)"
    )
    parser.add_argument(
        "-f", "--format",
        default="mp4",
        choices=["mp4", "webm", "mkv"],
        help="Video format (default: mp4)"
    )
    parser.add_argument(
        "-a", "--audio-only",
        action="store_true",
        help="Download only audio as MP3"
    )
    parser.add_argument(
        "-c", "--cookies-from-browser",
        help="Pull YouTube cookies from a browser (chrome, firefox, edge, ...). Needed when YouTube 403s an anonymous download."
    )
    
    args = parser.parse_args()
    
    success = download_video(
        url=args.url,
        output_path=args.output,
        quality=args.quality,
        format_type=args.format,
        audio_only=args.audio_only,
        cookies_from_browser=args.cookies_from_browser
    )
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()