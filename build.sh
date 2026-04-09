#!/bin/bash
# Build script for WorkReady Interactive Fiction Primer
#
# What this does:
#   1. Installs the inkjs compiler from package.json (idempotent — fast no-op
#      if already installed)
#   2. Copies the inkjs runtime to lib/ink.js (vendored, used by index.html)
#   3. Compiles workready.ink → workready.ink.json (the file index.html loads)
#
# Usage: ./build.sh
#
# LMS DEPLOYMENT NOTES:
# - For Blackboard/Canvas embedding, upload index.html, lib/ink.js, and
#   workready.ink.json (or wrap as a SCORM zip).
# - Story completion is signalled via window.postMessage to the parent frame
#   (see handleStoryEnd in index.html). For SCORM completion, replace the
#   postMessage call with a SCORM API call (e.g. pipwerks.SCORM wrapper).
# - The current build inlines no LMS-specific code, so the same artefacts
#   work standalone, on GitHub Pages, or embedded in an LMS.

set -e
cd "$(dirname "$0")"

echo "[1/3] Installing dependencies..."
npm install --silent

echo "[2/3] Vendoring inkjs runtime to lib/ink.js..."
mkdir -p lib
cp node_modules/inkjs/dist/ink.js lib/ink.js

echo "[3/3] Compiling workready.ink → workready.ink.json..."
node -e "
const { Compiler, CompilerOptions } = require('inkjs/full');
const fs = require('fs');

const source = fs.readFileSync('workready.ink', 'utf-8');
const errors = [];
const opts = new CompilerOptions(null, [], false, (msg, type) => {
    errors.push({ msg, type });
});

const compiler = new Compiler(source, opts);
const story = compiler.Compile();

const errs = errors.filter(e => e.type === 2);
const warns = errors.filter(e => e.type === 1);

if (errs.length > 0) {
    errs.forEach(e => console.error('ERROR:', e.msg));
    process.exit(1);
}
if (warns.length > 0) {
    warns.forEach(e => console.warn('WARNING:', e.msg));
}

const json = story.ToJson();
fs.writeFileSync('workready.ink.json', json);
console.log('Saved workready.ink.json (' + (json.length / 1024).toFixed(1) + ' KB)');
"

echo ""
echo "Done. Open index.html in a browser to play, or push to GitHub Pages."
