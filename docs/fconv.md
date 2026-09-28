# fconv

Media and document converter. Script: `scripts/.local/bin/fconv` (v1.2.5), stowed to `~/.local/bin/fconv`. Wraps ffmpeg and LibreOffice.

## Requirements

| Tool | Needed for |
| --- | --- |
| ffmpeg, ffprobe | all media. Checked at start |
| bc | Discord size mode. Checked at start |
| LibreOffice (`soffice` or `libreoffice`) | documents only |

Package names: see `docs/packages.md`, scripts package.

## Usage

```bash
fconv <input> [format | output-file] [options]
```

| Example | Result |
| --- | --- |
| `fconv slides.pptx pdf` | `slides.pdf` |
| `fconv image.png webp` | `image.webp` |
| `fconv clip.mp4 song.mp3` | audio extracted to `song.mp3` |
| `fconv clip.mov out.mp4 --discord` | H.264 sized for 10 MB |
| `fconv clip.mkv out.mp4 -d -s 25` | H.264 sized for 25 MB |
| `fconv clip.mp4 out.mp4 -r 1280x720 -a 192` | scaled and padded to 1280x720, 192 kbps audio |
| `fconv clip.mp4 gif` | GIF with generated palette |

## Options

| Flag | Argument | Default | Effect |
| --- | --- | --- | --- |
| `-d`, `--discord` | none | off | compute video bitrate from target size and duration |
| `-s`, `--size` | MB | 10 | target size for `--discord` |
| `-b`, `--bitrate` | kbps | none | fixed video bitrate. Overrides `--discord` |
| `-a`, `--audio` | kbps | 128 | audio bitrate |
| `-r`, `--res` | WxH | source size | scale to fit, pad to exact size |
| `-o`, `--output` | file | `<name>.<format>` | output path |
| `-h`, `--help` | none | none | usage |

## Formats

| Output | Engine | Codec |
| --- | --- | --- |
| mp4, mkv, mov, webm | ffmpeg | libx264 CRF 23 preset fast, AAC audio, yuv420p |
| gif | ffmpeg | palettegen + paletteuse |
| mp3 | ffmpeg | libmp3lame |
| ogg | ffmpeg | libvorbis |
| m4a | ffmpeg | aac |
| wav | ffmpeg | pcm_s16le |
| png, jpg, jpeg, webp | ffmpeg | default, libwebp for webp |
| pdf, docx, doc, ppt, pptx, odt | LibreOffice headless | n/a |

## Behavior

| Case | Result |
| --- | --- |
| Output path equals input path | writes `<name>_converted.<format>` |
| Discord bitrate below 150 kbps | clamped to 150 kbps |
| Output format not in the table | exits with `Unsupported format` |
| Unknown option | exits with `Unknown option` |
| Output file missing after run | exits with `Conversion failed.` |
