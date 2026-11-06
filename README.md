<p align="center">
  <img src="docs/icon.png" width="128" alt="airPointer icon">
</p>

<h1 align="center">airPointer</h1>

<p align="center">
  <b>Your AirPods are now a mouse.</b><br>
  Turn your head to point. Rest on a button to click. Completely hands-free on your Mac.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-15%2B-blue" alt="macOS 15+">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT">
</p>

> airPointer is a renamed build of [AirCursor](https://github.com/m-afham/AirCursor) by m-afham (MIT).

<p align="center">
  <img src="docs/screenshots/welcome.png" width="820" alt="airPointer guided tour">
</p>

## What it does

airPointer reads the motion sensors already built into your AirPods and turns head movement into a smooth, precise pointer. It runs as a native menu bar app. There's no extra hardware, no camera, and no network.

| You do | airPointer does *(defaults, all remappable)* |
|---|---|
| Turn your head | Moves the pointer (smooth, accelerated, works across all your displays) |
| Rest the pointer on a button | **Hover click.** A ring fills, then it clicks. Only buttons, links, tabs, menus, fields and Dock icons count, so resting on text you're reading never clicks |
| Press the stem once | Left click |
| Press the stem twice | Right click |
| Press the stem three times | Scroll mode: look up/down/left/right to scroll |
| Nod | Left click, landing where you pointed *before* the nod |
| Shake your head | Pause / resume |
| Tilt left / right | Your choice: Back/Forward, switch Spaces, Mission Control… |

Other actions you can assign: double click, middle click, drag lock, recenter, App windows, the screenshot tool, and more. Shortcuts: **⌃⌥T** pause · **⌃⌥S** scroll mode · **⌃⌥C** recenter · **⌃⌥D** drag.

### A one-minute guided tour

On first launch airPointer takes you through two permissions and connecting your AirPods, then has you **try it once for real**: point at a button with your head and hold still until it clicks, or nod. While you do that, it learns how big your natural nod is and tunes nod detection to match. A 3D pair of earbuds mirrors your head in real time the whole way through. If you leave for System Settings to grant a permission, the tour comes back and resumes on the same step.

<p align="center">
  <img src="docs/screenshots/tryit.png" width="410" alt="Try it: point and nod">
  <img src="docs/screenshots/done.png" width="410" alt="Cheat sheet">
</p>

## Requirements

- macOS 15 Sequoia or later (Apple silicon or Intel)
- Headphones with head-tracking sensors: **AirPods Pro** (any generation), **AirPods Max**, **AirPods (3rd generation or later)**, or **Beats Fit Pro**

## Install

```bash
make install     # builds airPointer.app (Apple silicon), copies it to /Applications, launches it
```

Then follow the guided tour. `make run` builds and launches without installing.

Building works with just the Command Line Tools (`xcode-select --install`). `make test` needs full
Xcode, because the tests use XCTest. SwiftUI's `@State` is spelled `@ViewState` in this codebase
(see `Sources/AirPointer/StateShim.swift`): the `@State` macro's plugin only ships with Xcode.

Ad-hoc signed builds lose the Accessibility grant on every rebuild. After `make install`, open
**System Settings › Privacy & Security › Accessibility** and switch airPointer off and on again.

### Uninstall

1. Quit airPointer from its menu bar icon (**Quit**).
2. Delete **airPointer** from Applications.
3. Optional: remove its settings and permissions:
   ```bash
   defaults delete com.vxwshxl.airPointer
   tccutil reset All com.vxwshxl.airPointer
   ```

## Permissions & privacy

| Permission | Why |
|---|---|
| Accessibility | To move the pointer, click and scroll for you |
| Motion | To read head movement from your AirPods |
| Bluetooth | To list, pair and connect your headphones |

Motion data is processed in memory on your Mac and never stored or sent anywhere. airPointer makes no network requests and has no analytics.

## Troubleshooting

**The pointer doesn't move.** AirPods only send head-tracking data to the device they're *playing audio for*. If your iPhone has them, or your Mac's sound output is set to its speakers, no motion arrives. Put the AirPods in, then choose them under **Control Center › Sound**. airPointer switches the Mac's output to your AirPods automatically when it can, and warns you when it can't.

**After an update, the pointer doesn't move even though Accessibility is on.** macOS ties the permission to the exact build. Open **System Settings › Privacy & Security › Accessibility** and switch airPointer off and on again. The guided tour reopens on its own and walks you through it.

**Something else is off.** Open **Settings › Shortcuts & General › Diagnostics**. It checks every link in the chain (permissions, Bluetooth, audio route, motion samples) and marks the first one that's failing.

**Hover click is too fast, too slow, or clicks things I didn't mean to.** Go to **Settings › Clicks & Gestures › Hover click** to change the rest time, or turn it off. It pauses while you type, and it only clicks things macOS reports as clickable.

**Nods don't click, or click by accident.** Go to **Settings › Clicks & Gestures** and adjust **Nod size needed**. The hint underneath shows how big your last nod was. Replaying the guided tour also re-tunes it automatically.

**Stem presses play/pause my music instead.** macOS sends AirPods presses to the "Now Playing" app. airPointer claims that role while tracking, but if music is playing in another app, that app may win. Head gestures always work.

**Removing an AirPod clicks.** Taking one out sends "pause", which counts as a stem press. Pause tracking first (shake or ⌃⌥T), or turn off Automatic Ear Detection.

## How it works

```
CMHeadphoneMotionManager (~25 Hz attitude)
   → MotionDifferentiator      angular rates (deg/s), wrap-around + gap safe
   → GestureDetector           nod / shake / tilt (direction-agnostic, with cooldown)
   → PointerMapper             dead zone + sensitivity + bounded acceleration → px/s
   → PointerSmoother (120 Hz)  frame-rate-independent easing; stops when samples go stale
   → EventSynthesizer          CGEvent move / click / drag / scroll / keys
MPRemoteCommandCenter          stem presses (play/pause, next, previous) → triggers
```

- **Relative (velocity) mapping.** The pointer follows how fast you turn your head, not your absolute head angle. Nothing to calibrate, and no drift.
- **Gestures don't move your target.** Recent pointer positions are buffered. When a nod or shake is recognized, the click lands where you were pointing when the gesture began.
- **Your mouse still works.** Move a real mouse or trackpad and airPointer picks up from the new position.
- **Safe by default.** A held drag is released on pause, disconnect, stalled motion or sleep.

The pointer and gesture core (`Sources/AirPointerCore`) is plain Swift with unit tests. See [CONTRIBUTING.md](CONTRIBUTING.md) for a tour of the code.

## Contributing

Issues and PRs are welcome, especially gesture tuning across AirPods models. Please attach the Diagnostics output to bug reports. Every PR gets an automated review against the project's rulebook, and merged app changes are released automatically. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)

---

<sub>AirPods, AirPods Pro, AirPods Max, Beats and macOS are trademarks of Apple Inc., registered in the U.S. and other countries. airPointer is an independent open-source project and is not affiliated with, sponsored by, or endorsed by Apple Inc. The 3D earbuds and app icon are original artwork.</sub>
