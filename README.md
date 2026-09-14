# WorkReady primer

A standalone interactive story that introduces the WorkReady internship journey. Students choose warm, professional or playful narration and practise decisions about applying, interviewing, doing a task, joining colleagues and reflecting on a placement. Alternative-outcome passages show what another choice might have led to.

[Project home](https://github.com/michael-borck/workready-deploy) · [Architecture](https://github.com/michael-borck/workready-deploy/blob/main/docs/architecture.md#independent-primer) · [Live primer](https://primer.eduserver.au/)

The player runs Ink in the browser. It needs no contractor code, WorkReady API or live model call. Completing this story does not complete a student's API placement.

## Files

| Path | Purpose |
|---|---|
| `workready.ink` | Editable story source, tones, choices and scene tags |
| `workready.ink.json` | Compiled story loaded by the browser; commit generated changes |
| `index.html` | Player, card layouts, styles and scene rendering |
| `lib/ink.js` | Vendored inkjs runtime copied by the build |
| `assets/scenes/*.jpg` | Eight cartoon scene illustrations shipped as static assets |
| `build.sh`, `package.json`, `package-lock.json` | Compiler/runtime dependency and build recipe |
| `.githooks/pre-commit` | Optional hook to rebuild staged Ink changes |

The scene artwork was generated during authoring with the local `limn` tool. Students load the saved images; the build does not generate artwork.

## Build and preview

Requires Node.js and npm. From this repository:

```bash
bash build.sh
python3 -m http.server 8080
```

The build installs npm dependencies, copies the runtime into `lib/` and compiles the story JSON. Open `http://localhost:8080`. Serve over HTTP because browser fetch rules can block a `file://` story load.

Review compiler output and play the changed paths in each affected tone. Check the alternative-outcome passages and scene images as well as the main choices.

The optional pre-commit hook rebuilds when `workready.ink` is staged and stages the generated JSON/runtime. To install it in a fresh clone:

```bash
ln -s ../../.githooks/pre-commit .git/hooks/pre-commit
```

If a hook already exists, integrate the build step with it rather than replacing it. The hook calls `./build.sh`, so the script must be executable. Manual `bash build.sh` works without that hook.

## Author the story

Use [Inky](https://github.com/inkle/inky/releases) or a text editor. The source uses Ink knots such as `=== knot_name ===`, with tone-specific passages:

```ink
{tone:
- 1: warm version
- 2: professional version
- 3: playful version
}
```

Update the corresponding tone variants together. Preserve the `shadow_after_stageN` alternative-outcome passages. Story tags and the scene map in `index.html` must agree when adding or renaming artwork.

## Publish and embed

GitHub Pages publishes `main` at the repository root, with the custom domain `primer.eduserver.au`. It does not compile Ink. Publish reviewed source, compiled JSON, vendored runtime and any changed player/assets together. There is no `pages.yml` workflow in this repository.

For embedding or copying the player, include `index.html`, `workready.ink.json`, `lib/ink.js` and `assets/scenes/`. The player sends completion information to a parent frame with `postMessage`. An LMS would need to validate and handle that message; SCORM packaging and gradebook reporting are not implemented here.

Built with [Ink](https://www.inklestudios.com/ink/) and [inkjs](https://github.com/inkle/inkjs). Project-wide publication instructions live in [operations](https://github.com/michael-borck/workready-deploy/blob/main/docs/operations.md).
