# WorkReady Primer

A browser-based interactive fiction primer for the **WorkReady** internship
simulation — a teaching tool for Curtin University's School of Marketing and
Management. Students play through six stages of an internship journey
(scanning the job board, submitting a resume, interviewing, completing a
work task, navigating a social moment, and the exit interview) before their
real placement.

The primer is designed as a **safe-to-fail rehearsal**: every choice has a
consequence, and after each decision the story shows the player what would
have happened if they'd picked the alternative ("shadow paths"). Students
can replay with different choices and see how the journey changes.

Live: <https://michael-borck.github.io/workready-primer/>

---

## How it works

The whole project is static — there is no server, no API, no database.
Everything runs in the browser.

```
┌──────────────────────────────────────────────────────────┐
│  index.html (HTML + CSS + rendering JS, all in one file) │
│        │                                                  │
│        ├── loads lib/ink.js  (inkjs runtime, vendored)   │
│        └── fetches workready.ink.json  (compiled story)  │
└──────────────────────────────────────────────────────────┘
```

Students see a title screen, pick a narrative tone (warm / professional /
playful), and play through ~15 minutes of branching narrative.

## Files

| File | What it is | Edit? |
|------|-----------|-------|
| `workready.ink` | The **source** story, written in [Ink](https://www.inklestudios.com/ink/). This is what you edit. | Yes — this is the only file you author |
| `workready.ink.json` | The **compiled** story. Generated from `workready.ink` by `build.sh`. The browser loads this file at runtime. | No — regenerate with `./build.sh` |
| `index.html` | The browser player — HTML structure, CSS, and ~150 lines of vanilla JS that talks to inkjs and renders text + choice buttons. | Only for visual/UX changes |
| `lib/ink.js` | The vendored inkjs runtime (v2.3.0). Copied here by `build.sh` from `node_modules/inkjs/dist/ink.js`. Vendored locally so the project has no CDN dependency. | No — `build.sh` overwrites it |
| `build.sh` | The build script (see below). | Rarely |
| `package.json` | Declares the inkjs version as a devDependency. | Only when bumping inkjs |

> **Note:** `workready.ink.json` is committed to the repo even though it's a
> build output. This is intentional — GitHub Pages has no build step, so the
> compiled JSON has to be in the repo for the site to work. Don't add it to
> `.gitignore`.

## Building

```bash
./build.sh
```

That's the entire build. The script:

1. Runs `npm install` (idempotent — fast no-op if already installed)
2. Copies the inkjs runtime to `lib/ink.js`
3. Compiles `workready.ink` → `workready.ink.json` using inkjs

You need Node.js installed. Nothing else.

### Pre-commit hook (recommended)

A pre-commit hook lives at `.githooks/pre-commit`. When `workready.ink` is
in a commit, it automatically runs `./build.sh` and stages the regenerated
`workready.ink.json` and `lib/ink.js` so they're included in the same
commit. This eliminates the "I forgot to rebuild" footgun.

The hook is enabled in this clone via a symlink. **On a fresh clone**,
re-enable it once with:

```bash
ln -sf ../../.githooks/pre-commit .git/hooks/pre-commit
```

(Or, if you prefer, `git config core.hooksPath .githooks` — same effect.)

To bypass the hook for a single commit (rare): `git commit --no-verify`.

## Authoring the story

Two reasonable workflows for editing `workready.ink`:

**Option A: [Inky editor](https://github.com/inkle/inky/releases)** (recommended for human authoring)
Inky is inkle's free desktop editor. It has syntax highlighting, a live
preview pane on the right where you can click through the story as you
write, and catches Ink syntax errors immediately. After editing in Inky,
either use its **File → Export to JSON** menu or just save the `.ink` file
and run `./build.sh`.

**Option B: text editor + LLM assistance** (the "vibe-coding" path)
Open `workready.ink` in any editor — it's plain text. The file is
structured around **knots** (`=== knot_name ===`) corresponding to the
six stages, plus shadow knots, a title screen, and an end summary. There
are extensive maintainer notes at the top of the file explaining the tone
system and shadow paths. After editing, run `./build.sh` to regenerate
the JSON.

### Tone variants — important

The story is written in **three parallel tones** (warm / professional /
playful) selected by the player on the title screen. Most narrative content
is wrapped in:

```ink
{tone:
- 1: warm version of the line
- 2: professional version
- 3: playful version
}
```

**When editing any narrative content, update all three variants together.**
The maintainer note at the top of `workready.ink` explains this in more
detail. LLMs are well-suited to keeping the three versions in sync — humans
should be careful not to update only one.

### Shadow paths

After each major decision, a `shadow_after_stageN` knot shows the player
what would have happened if they'd picked the alternative. This is the
primer's **core pedagogical mechanic** — preserve it when editing.

## Deployment

### GitHub Pages

Already configured. Pushing to `main` triggers a rebuild within ~30-60 seconds.

```bash
git add .
git commit -m "Update story"
git push
```

The `workready.ink.json` file must be committed (see note above).

### LMS embedding (Blackboard / Canvas)

Upload `index.html`, `lib/ink.js`, and `workready.ink.json` as content files,
or wrap as a SCORM package. Story completion is signalled via
`window.postMessage` to the parent frame (see `handleStoryEnd` in
`index.html`). For SCORM completion tracking, replace the `postMessage`
call with a SCORM API call (e.g. pipwerks.SCORM wrapper).

## Project structure summary

```
workready-primer/
├── workready.ink           # source — what you edit
├── workready.ink.json      # compiled — what the browser loads (commit this)
├── index.html              # the player
├── lib/
│   └── ink.js              # vendored inkjs runtime v2.3.0
├── build.sh                # ./build.sh to compile
├── package.json            # declares inkjs dependency
├── .gitignore              # ignores node_modules/
└── README.md               # this file
```

## Credits

Part of the **WorkReady** project at Curtin University, School of Marketing
and Management. Built with [Ink](https://www.inklestudios.com/ink/) by
inkle and [inkjs](https://github.com/inkle/inkjs).
