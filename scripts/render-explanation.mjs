#!/usr/bin/env node

import { spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { basename, dirname, extname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const args = process.argv.slice(2);
const noOpen = args.includes("--no-open");
const positional = args.filter((arg) => arg !== "--no-open");

if (positional.length < 1 || positional.length > 2) {
  console.error("Usage: render-explanation.mjs <input.md> [output.html] [--no-open]");
  process.exit(2);
}

const input = resolve(positional[0]);
const output = resolve(positional[1] ?? input.slice(0, -extname(input).length) + ".html");
const scriptDir = dirname(fileURLToPath(import.meta.url));
const templatePath = join(scriptDir, "..", "templates", "explain-visually.html");
const workDir = mkdtempSync(join(tmpdir(), "explain-visually-"));

function run(command, commandArgs) {
  const result = spawnSync(command, commandArgs, { stdio: "inherit" });
  if (result.error) throw result.error;
  if (result.status !== 0) process.exit(result.status ?? 1);
}

function escapeHtml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

try {
  const markdown = readFileSync(input, "utf8");
  const mermaidBlocks = /^```mermaid[^\n]*\n([\s\S]*?)^```[ \t]*$/gm;
  let renderedMarkdown = "";
  let cursor = 0;
  let diagramIndex = 0;

  for (const match of markdown.matchAll(mermaidBlocks)) {
    diagramIndex += 1;
    const sourcePath = join(workDir, `diagram-${diagramIndex}.mmd`);
    const svgPath = join(workDir, `diagram-${diagramIndex}.svg`);
    writeFileSync(sourcePath, match[1]);
    run("npx", ["-y", "@mermaid-js/mermaid-cli", "-i", sourcePath, "-o", svgPath, "-b", "transparent"]);

    const svg = readFileSync(svgPath, "utf8");
    const svgStart = svg.indexOf("<svg");
    if (svgStart < 0) throw new Error(`Mermaid did not produce SVG for diagram ${diagramIndex}`);

    renderedMarkdown += markdown.slice(cursor, match.index);
    renderedMarkdown += `\n<div class="diagram">\n${svg.slice(svgStart)}\n</div>\n`;
    cursor = match.index + match[0].length;
  }

  if (diagramIndex === 0) throw new Error("No fenced Mermaid blocks found");
  renderedMarkdown += markdown.slice(cursor);

  const renderedMarkdownPath = join(workDir, "rendered.md");
  const bodyPath = join(workDir, "body.html");
  writeFileSync(renderedMarkdownPath, renderedMarkdown);
  run("npx", ["-y", "marked", "--gfm", "-i", renderedMarkdownPath, "-o", bodyPath]);

  const title = markdown.match(/^#\s+(.+)$/m)?.[1] ?? basename(input, extname(input));
  const template = readFileSync(templatePath, "utf8");
  const html = template
    .replace("{{TITLE}}", () => escapeHtml(title))
    .replace("{{CONTENT}}", () => readFileSync(bodyPath, "utf8"));
  writeFileSync(output, html);

  if (!noOpen) {
    if (process.platform === "darwin") run("open", [output]);
    else if (process.platform === "win32") run("cmd", ["/c", "start", "", output]);
    else run("xdg-open", [output]);
  }

  console.log(output);
} finally {
  rmSync(workDir, { recursive: true, force: true });
}
