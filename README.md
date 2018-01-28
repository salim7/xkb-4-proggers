# xkb-4-proggers
Bash script that generates a new keyboard layout handy for programmers with non-US keyboards.

## The new Layout
I personally didn't use the caps-lock key often (AND I DON'T RECOMMEND TO). However, that's a pity because the caps-lock key occupies a handy and easy-accessible position on the keyboard. That's why the new keyboard layout uses the caps-lock key as a modifier button.

| Key Combination | Character name | Character |
| --------------- |:-------------- |:---------:|
| `[SHIFT]+[CAPS-LOCK]` | CAPS-LOCK |  |
| `[CAPS-LOCK]+[A]` | apostrophe | ' |
| `[CAPS-LOCK]+[S]` | double quotes | " |
| `[CAPS-LOCK]+[D]` | backslash | \\ |
| `[CAPS-LOCK]+[F]` | bracket left | \[ |
| `[CAPS-LOCK]+[G]` | bracket right | ] |
| `[CAPS-LOCK]+[H]` | grave | \` |
| `[CAPS-LOCK]+[J]` | brace left | { |
| `[CAPS-LOCK]+[K]` | brace right | } |
| `[CAPS-LOCK]+[L]` | slash | / |
| `[CAPS-LOCK]+[Ö]` | semicolon | ; |
| `[CAPS-LOCK]+[Ä]` | End | |

These new key combinations speed up your typing speed especially when writing code.

## Setup
 * Requirements: (Ubuntu?) Linux
 * Download or clone the repository: `git clone git@github.com:salim7/xkb-4-proggers.git`
 * Ensure your current keyboard layout shall be the base
 * Run install script: `./install.sh`, continue
 * Go to Gnome Settings, Text Input and add the new layout to your input source. You may want to make it the default one.
 * Enjoy!
 * In case of errors, you can revert the changes by: `sudo cp evdev.xml.bak /usr/share/X11/xkb/rules/evdev.xml && sudo cp evdev.bak /usr/share/X11/xkb/rules/evdev`
 
## Additional Notes
See [License](LICENSE)
