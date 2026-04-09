#!/bin/bash
# Build script for WorkReady Interactive Fiction Primer
# Compiles workready.ink to JSON using inkjs via Node.js
#
# Prerequisites: npm install inkjs (one-time)
# Usage: ./build.sh
#
# LMS DEPLOYMENT NOTES:
# - For Blackboard/Canvas embedding, upload index.html + workready.ink.json
#   as content files (or wrap as a SCORM zip).
# - Story completion is signalled via window.postMessage to the parent frame
#   (see handleStoryEnd in index.html). For SCORM completion, replace the
#   postMessage call with a SCORM API call (e.g. pipwerks.SCORM wrapper).
# - The current build inlines no LMS-specific code, so the same artefacts
#   work standalone or embedded.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Compiling workready.ink..."

# Check if inkjs is available
if ! node -e "require('inkjs/full')" 2>/dev/null; then
    echo "Installing inkjs..."
    npm install --save-dev inkjs@2.3.0
fi

node -e "
const { Compiler } = require('inkjs/full');
const { Story } = require('inkjs');
const fs = require('fs');

const source = fs.readFileSync('workready.ink', 'utf-8');
const errors = [];
const opts = new (require('inkjs/full').CompilerOptions)(null, [], false, (msg, type) => {
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

echo "Done. Open index.html in a browser to play."
