import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { CustomEditor, type ExtensionAPI, getAgentDir } from "@earendil-works/pi-coding-agent";
import { TuiMainScreen } from "@earendil-works/pi-tui";

const RESET = "\x1b[0m";
const PROMPT = "\x1b[1m›\x1b[22m ";
const BOTTOM = "\0solid-editor-bottom\0";

export default function (pi: ExtensionAPI) {
	// Pi paints its default bordered editor before extensions start. Hold renders until this editor is
	// installed, so the first frame over the `pi` wrapper's skeleton is the final layout.
	const proto = TuiMainScreen.prototype as unknown as { doRender(this: TuiMainScreen): void };
	const doRender = proto.doRender;
	const held = new Set<TuiMainScreen>();
	proto.doRender = function () {
		held.add(this);
	};
	const release = () => {
		if (proto.doRender === doRender) return;
		proto.doRender = doRender;
		for (const tui of held) tui.requestRender();
	};
	// Never hold longer than this, e.g. while a startup prompt such as project trust is shown.
	setTimeout(release, 1000).unref();

	pi.on("session_start", (_event, ctx) => {
		// After the remaining session_start handlers (the footer) have run.
		setImmediate(release);

		class SolidEditor extends CustomEditor {
			// Pi applies the `editorPaddingX` setting after construction; keep the 2 cells the prompt is drawn into.
			setPaddingX(): void {}

			protected renderTopBorder(width: number): string {
				return " ".repeat(width);
			}

			protected renderBottomBorder(): string {
				return BOTTOM;
			}

			render(width: number): string[] {
				const lines = super.render(width);
				const bottom = lines.indexOf(BOTTOM);
				lines[bottom] = " ".repeat(width);
				// Draw the prompt into the 2-cell left padding of the first text line.
				if (lines[1]?.startsWith("  ")) lines[1] = PROMPT + lines[1].slice(2);
				// The theme's neutral panel color; read per render so theme switches apply.
				const bg = ctx.ui.theme.getBgAnsi("toolPendingBg");
				const paint = (line: string) => bg + line.replaceAll(RESET, RESET + bg) + RESET;
				// Paint the box (top padding, text, bottom padding); leave autocomplete below it as is.
				return lines.map((line, i) => (i <= bottom ? paint(line) : line));
			}
		}

		ctx.ui.setEditorComponent((tui, theme, keybindings) => new SolidEditor(tui, theme, keybindings, { paddingX: 2 }));

		// Cache the panel and accent colors for the startup skeleton drawn by the `pi` wrapper.
		// Skip terminals without a panel color, so they don't overwrite the colors of a capable one.
		const { theme } = ctx.ui;
		const panel = theme.getBgAnsi("toolPendingBg");
		if (ctx.mode !== "tui" || !panel.includes("[48;")) return;
		const dir = join(getAgentDir(), "cache");
		mkdirSync(dir, { recursive: true });
		writeFileSync(join(dir, "skeleton-colors"), `${panel}\n${theme.getFgAnsi("accent")}\n`);
	});
}
