import json
import os
import sys

CAUTION_TOKENS = 300_000
WARN_TOKENS = 400_000
TAIL_BYTES = 2_000_000

LIGHT_BLUE = "\033[38;5;117m"
ORANGE = "\033[38;5;208m"
RED = "\033[38;5;196m"
RESET = "\033[0m"


def context_tokens_from_usage(usage):
    return (
        usage.get("input_tokens", 0)
        + usage.get("cache_read_input_tokens", 0)
        + usage.get("cache_creation_input_tokens", 0)
    )


def read_tail_lines(path, max_bytes):
    size = os.path.getsize(path)
    with open(path, "rb") as transcript:
        transcript.seek(max(0, size - max_bytes))
        chunk = transcript.read()
    lines = chunk.decode("utf-8", errors="replace").splitlines()
    return lines if size <= max_bytes else lines[1:]


def latest_main_thread_usage(transcript_path):
    if not transcript_path or not os.path.exists(transcript_path):
        return None
    for line in reversed(read_tail_lines(transcript_path, TAIL_BYTES)):
        try:
            entry = json.loads(line)
        except json.JSONDecodeError:
            continue
        if entry.get("type") != "assistant" or entry.get("isSidechain"):
            continue
        usage = entry.get("message", {}).get("usage")
        if usage:
            return usage
    return None


def format_tokens(count):
    if count >= 1_000_000:
        return f"{count / 1_000_000:.1f}M".replace(".0M", "M")
    return f"{round(count / 1000)}k"


def main():
    status = json.load(sys.stdin)
    model = status.get("model", {})
    model_name = model.get("display_name") or model.get("id", "")
    window_size = 1_000_000 if "1m" in model.get("id", "").lower() else 200_000

    usage = latest_main_thread_usage(status.get("transcript_path"))
    if usage is None:
        sys.stdout.write(f"{model_name} {LIGHT_BLUE}--{RESET}")
        return

    used = context_tokens_from_usage(usage)
    context = f"{format_tokens(used)} / {format_tokens(window_size)}"
    if used >= WARN_TOKENS:
        sys.stdout.write(f"{model_name} {RED}{context}  past {format_tokens(WARN_TOKENS)}: save + /compact{RESET}")
    elif used >= CAUTION_TOKENS:
        sys.stdout.write(f"{model_name} {ORANGE}{context}  approaching {format_tokens(WARN_TOKENS)}{RESET}")
    else:
        sys.stdout.write(f"{model_name} {LIGHT_BLUE}{context}{RESET}")


if __name__ == "__main__":
    main()
