import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const BAR_WIDTH = 10;
// Theme's dark track color for the unused parts of both meters.
const TRACK = "scrollbarTrack";
// Thinking levels in order; the meter fills one dot per level above "off".
const LEVELS = ["off", "minimal", "low", "medium", "high", "xhigh", "max"] as const;
const LEVEL_COLORS = {
	off: "thinkingOff",
	minimal: "thinkingMinimal",
	low: "thinkingLow",
	medium: "thinkingMedium",
	high: "thinkingHigh",
	xhigh: "thinkingXhigh",
	max: "thinkingMax",
} as const;

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const home = homedir();
					const path = ctx.cwd.startsWith(home) ? `~${ctx.cwd.slice(home.length)}` : ctx.cwd;
					const branch = footerData.getGitBranch();
					const left = theme.fg("accent", path) + (branch ? theme.fg("muted", `  ${branch}`) : "");

					const percent = ctx.getContextUsage()?.percent ?? 0;
					const filled = Math.round((Math.min(percent, 100) / 100) * BAR_WIDTH);
					let color: "success" | "warning" | "error" = "success";
					if (percent > 80) color = "error";
					else if (percent > 50) color = "warning";
					const bar = theme.fg(color, "━".repeat(filled)) + theme.fg(TRACK, "━".repeat(BAR_WIDTH - filled));
					const level = pi.getThinkingLevel();
					const steps = LEVELS.indexOf(level);
					const thinking =
						theme.fg(LEVEL_COLORS[level], "●".repeat(steps)) +
						theme.fg(TRACK, "●".repeat(LEVELS.length - 1 - steps));
					const model = theme.fg("dim", ctx.model?.name ?? "no model");
					const right = `${model}  ${thinking}  ${bar} ${theme.fg("dim", `${Math.round(percent)}%`)}`;

					const pad = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
					return [truncateToWidth(left + pad + right, width)];
				},
			};
		});
	});
}
