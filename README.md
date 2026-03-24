# ccw-plugin-battery

A [ccstatuswidgets](https://github.com/warunacds/ccstatuswidgets) plugin that shows your laptop's battery level and charging status in the Claude Code status line.

## Install

```bash
ccw plugin add https://github.com/warunacds/ccw-plugin-battery
```

## Enable

```bash
ccw add battery
```

## Example Output

| State            | Output       |
|------------------|--------------|
| Normal (>=50%)   | `🔋 78%`    |
| Medium (20-49%)  | `🔋 35%`    |
| Low (<20%)       | `🪫 12%`    |
| Charging         | `⚡ 78%`    |

Colors change dynamically: green (>=50%), yellow (20-49%), red (<20%).

On desktops without a battery, the widget produces no output and is hidden.

## Supported Platforms

- **macOS** — uses `pmset -g batt`
- **Linux** — reads `/sys/class/power_supply/BAT0/capacity`

## License

MIT
