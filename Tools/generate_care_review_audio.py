#!/usr/bin/env python3
"""Generate deterministic WAV audio assets for Care Review Office.

The assets are synthetic, dry office-tone loops and UI cues. No external
samples are used.
"""

from __future__ import annotations

import math
import struct
import wave
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
AUDIO_ROOT = ROOT / "Assets" / "Resources" / "Audio"
BGM_ROOT = AUDIO_ROOT / "Bgm"
SFX_ROOT = AUDIO_ROOT / "Sfx"
SR = 44100


BGM_SPECS = {
    "menu_office_night": (24.0, 61, 46.0, 0.026, 0.014),
    "review_paperwork_loop": (24.0, 73, 53.0, 0.032, 0.020),
    "policy_pressure_loop": (24.0, 89, 41.0, 0.040, 0.026),
    "report_afterhours_loop": (24.0, 107, 49.0, 0.028, 0.018),
    "ending_quiet_room": (28.0, 131, 36.0, 0.022, 0.010),
}

SFX_NAMES = [
    "ui_click",
    "ui_back",
    "page_turn",
    "paper_slide",
    "policy_book_open",
    "stamp_approve",
    "stamp_conditional",
    "stamp_hold",
    "stamp_investigate",
    "stamp_reject",
    "decision_feedback",
    "briefing_alert",
    "incident_minor",
    "incident_major",
    "incident_critical",
    "report_ready",
    "save_confirm",
    "analysis_open",
    "toast_unlock",
    "error_denied",
]


class Rng:
    def __init__(self, seed: int) -> None:
        self.state = seed & 0xFFFFFFFF

    def next(self) -> float:
        self.state = (1664525 * self.state + 1013904223) & 0xFFFFFFFF
        return ((self.state >> 8) / 0xFFFFFF) * 2.0 - 1.0


def clamp(value: float) -> float:
    return max(-0.98, min(0.98, value))


def smoothstep(edge0: float, edge1: float, x: float) -> float:
    if edge0 == edge1:
        return 1.0
    x = max(0.0, min(1.0, (x - edge0) / (edge1 - edge0)))
    return x * x * (3.0 - 2.0 * x)


def hit_env(t: float, duration: float, attack: float = 0.004, release: float = 0.08) -> float:
    a = smoothstep(0.0, attack, t)
    r = 1.0 - smoothstep(max(attack, duration - release), duration, t)
    return a * r


def write_wav(path: Path, samples: list[tuple[float, ...]], channels: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "wb") as wav:
        wav.setnchannels(channels)
        wav.setsampwidth(2)
        wav.setframerate(SR)
        frames = bytearray()
        for frame in samples:
            for value in frame:
                frames.extend(struct.pack("<h", int(clamp(value) * 32767)))
        wav.writeframes(frames)


def looping_noise(seed: int, table_size: int = 2048) -> list[float]:
    rng = Rng(seed)
    return [rng.next() for _ in range(table_size)]


def noise_at(table: list[float], phase: float) -> float:
    size = len(table)
    x = phase % size
    i = int(x)
    frac = x - i
    return table[i] * (1.0 - frac) + table[(i + 1) % size] * frac


def make_bgm(name: str, duration: float, seed: int, base: float, drone_gain: float, paper_gain: float) -> None:
    count = int(SR * duration)
    noise_table = looping_noise(seed)
    samples: list[tuple[float, float]] = []
    for i in range(count):
        t = i / SR
        loop = i / count
        office_hum = 0.012 * math.sin(2.0 * math.pi * 60.0 * t) + 0.006 * math.sin(2.0 * math.pi * 120.0 * t)
        fluorescent = 0.006 * math.sin(2.0 * math.pi * 247.0 * t) * (0.62 + 0.38 * math.sin(2.0 * math.pi * 0.125 * t))
        drone = drone_gain * (
            0.65 * math.sin(2.0 * math.pi * base * t)
            + 0.28 * math.sin(2.0 * math.pi * (base * 1.5) * t + 0.7)
            + 0.17 * math.sin(2.0 * math.pi * (base * 2.0) * t + 1.8)
        )
        pulse = 0.5 + 0.5 * math.sin(2.0 * math.pi * 0.25 * t + seed * 0.03)
        paper = paper_gain * noise_at(noise_table, loop * len(noise_table)) * (0.25 + 0.75 * pulse * pulse)
        small_clock = 0.0025 * math.sin(2.0 * math.pi * 2.0 * t)
        fade = smoothstep(0.0, 1.0, t) * (1.0 - smoothstep(duration - 1.0, duration, t))
        value = (office_hum + fluorescent + drone + paper + small_clock) * fade
        pan = 0.018 * math.sin(2.0 * math.pi * 0.125 * t)
        samples.append((value * (1.0 - pan), value * (1.0 + pan)))
    write_wav(BGM_ROOT / f"{name}.wav", samples, 2)


def make_noise_sweep(duration: float, seed: int, amp: float, start_hz: float, end_hz: float) -> list[float]:
    count = int(SR * duration)
    rng = Rng(seed)
    data: list[float] = []
    phase = 0.0
    for i in range(count):
        t = i / SR
        ratio = i / max(1, count - 1)
        hz = start_hz + (end_hz - start_hz) * ratio
        phase += hz / SR
        paper = math.sin(2.0 * math.pi * phase)
        noise = rng.next()
        data.append((paper * 0.36 + noise * 0.64) * amp * hit_env(t, duration, 0.002, duration * 0.58))
    return data


def tone(duration: float, parts: list[tuple[float, float]], attack: float = 0.004, release: float = 0.08) -> list[float]:
    count = int(SR * duration)
    data: list[float] = []
    for i in range(count):
        t = i / SR
        value = 0.0
        for hz, gain in parts:
            value += gain * math.sin(2.0 * math.pi * hz * t)
        data.append(value * hit_env(t, duration, attack, release))
    return data


def stamp(duration: float, seed: int, low: float, snap_gain: float) -> list[float]:
    count = int(SR * duration)
    rng = Rng(seed)
    data: list[float] = []
    for i in range(count):
        t = i / SR
        thud = 0.22 * math.sin(2.0 * math.pi * low * t) * math.exp(-t * 14.0)
        wood = 0.10 * math.sin(2.0 * math.pi * low * 2.0 * t + 0.4) * math.exp(-t * 20.0)
        snap = rng.next() * snap_gain * math.exp(-t * 55.0)
        data.append((thud + wood + snap) * hit_env(t, duration, 0.0015, duration * 0.7))
    return data


def sfx_data(name: str) -> list[float]:
    if name == "ui_click":
        return tone(0.070, [(920.0, 0.10), (1430.0, 0.06)], 0.001, 0.040)
    if name == "ui_back":
        return tone(0.095, [(620.0, 0.08), (360.0, 0.05)], 0.001, 0.060)
    if name == "page_turn":
        return make_noise_sweep(0.220, 211, 0.105, 1350.0, 420.0)
    if name == "paper_slide":
        return make_noise_sweep(0.280, 223, 0.082, 520.0, 1080.0)
    if name == "policy_book_open":
        data = make_noise_sweep(0.340, 229, 0.090, 380.0, 680.0)
        thump = stamp(0.340, 230, 82.0, 0.025)
        return [data[i] + thump[i] * 0.55 for i in range(len(data))]
    if name == "stamp_approve":
        return stamp(0.190, 307, 132.0, 0.070)
    if name == "stamp_conditional":
        return stamp(0.210, 311, 158.0, 0.060)
    if name == "stamp_hold":
        return stamp(0.170, 313, 104.0, 0.045)
    if name == "stamp_investigate":
        data = stamp(0.250, 317, 184.0, 0.050)
        sweep = tone(0.250, [(300.0, 0.035), (530.0, 0.030)], 0.002, 0.120)
        return [data[i] + sweep[i] for i in range(len(data))]
    if name == "stamp_reject":
        return stamp(0.230, 331, 78.0, 0.085)
    if name == "decision_feedback":
        return tone(0.260, [(196.0, 0.055), (262.0, 0.044), (392.0, 0.035)], 0.006, 0.120)
    if name == "briefing_alert":
        return tone(0.420, [(392.0, 0.055), (523.25, 0.052)], 0.004, 0.180)
    if name == "incident_minor":
        return tone(0.360, [(330.0, 0.052), (660.0, 0.030)], 0.004, 0.160)
    if name == "incident_major":
        return tone(0.520, [(210.0, 0.060), (420.0, 0.050), (315.0, 0.028)], 0.004, 0.220)
    if name == "incident_critical":
        base = tone(0.700, [(92.0, 0.060), (184.0, 0.052), (520.0, 0.040)], 0.004, 0.300)
        noise = make_noise_sweep(0.700, 353, 0.042, 210.0, 75.0)
        return [base[i] + noise[i] for i in range(len(base))]
    if name == "report_ready":
        return tone(0.480, [(262.0, 0.055), (330.0, 0.050), (392.0, 0.044)], 0.008, 0.220)
    if name == "save_confirm":
        return tone(0.220, [(660.0, 0.052), (880.0, 0.043)], 0.002, 0.100)
    if name == "analysis_open":
        return tone(0.350, [(220.0, 0.045), (440.0, 0.040), (740.0, 0.026)], 0.004, 0.150)
    if name == "toast_unlock":
        return tone(0.420, [(523.25, 0.048), (659.25, 0.040), (783.99, 0.030)], 0.006, 0.200)
    if name == "error_denied":
        return tone(0.260, [(155.0, 0.060), (116.5, 0.045)], 0.002, 0.120)
    raise ValueError(name)


def make_sfx(name: str) -> None:
    mono = sfx_data(name)
    samples = [(value,) for value in mono]
    write_wav(SFX_ROOT / f"{name}.wav", samples, 1)


def main() -> None:
    for name, spec in BGM_SPECS.items():
        make_bgm(name, *spec)
    for name in SFX_NAMES:
        make_sfx(name)
    print(f"Generated {len(BGM_SPECS)} BGM and {len(SFX_NAMES)} SFX WAV files under {AUDIO_ROOT}")


if __name__ == "__main__":
    main()
