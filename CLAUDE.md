# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Static marketing website for Showcase Lawn Maintenance & Landscaping LLC (Greenville, SC),
served at showcaselandscapingsc.com. Pages are authored as Jade (Pug) templates and compiled
to plain HTML; there is no server-side runtime.

## Commands

The build needs the legacy toolchain (see "Gotchas") — Node 8 via nvm plus `grunt-cli@1.3.2`
installed globally. With that in place:

```bash
nvm use          # selects Node 8.17.0 from .nvmrc (run in each new shell)
npm install      # install Grunt + plugins (uses the bundled npm 6)
grunt jade       # compile app/views/**/*.jade -> HTML at the repo root
grunt            # default task: serve http://localhost:8001 + watch/recompile jade
```

To just preview the already-built site without the toolchain, serve the repo root with any
static server, e.g. `python3 -m http.server 8001` (paths are absolute, so don't open via `file://`).

The registered Grunt tasks are `jade` (compile), `connect` (static server), `watch`, and the
default task (`connect` + `watch`, run via bare `grunt`). `jshint`, `nodeunit`, and `uglify` are
in `devDependencies` but unused — there is no lint or test step. A `Makefile` wraps the common
commands: `make build`, `make serve`, `make deploy` (see Deploying).

## Critical workflow: source vs. generated output

The compiled `*.html` files (`index.html`, `about/index.html`, `irrigation/index.html`, …) are
**committed to the repo and are the deployed artifact** — the site is served from the repo root
(GitHub Pages; see `CNAME`). They are generated, not hand-edited.

- Edit the Jade source under `app/views/`, never the root-level `.html` files directly.
- After editing Jade, run `grunt jade` and commit **both** the `.jade` change and the
  regenerated `.html`. Skipping the recompile means your change never reaches production.

The `grunt jade` task maps each source file relative to `app/views/` onto the repo root:
`app/views/index.jade` → `index.html`, `app/views/about/index.jade` → `about/index.html`, etc.
Output uses `pretty: false`, so generated HTML is single-line/minified — don't try to read diffs
of it; reason about the `.jade` instead.

## Deploying

The live site (showcaselandscapingsc.com) is GitHub Pages serving the **`gh-pages`** branch at
its root, with `master` as the source of truth and `gh-pages` a fast-forwarded mirror. Publish
with **`make deploy`** from a clean `master`: it recompiles, refuses to run on uncommitted or
stale HTML, pushes `master`, then fast-forwards `gh-pages`. Make changes on `master` and deploy —
**never commit directly on `gh-pages`** (that recreates the master/gh-pages divergence that was
reconciled in the convergence merge).

## Architecture

**Templating.** Every page is `app/views/<page>/index.jade` and follows the same shape:

```jade
extends ../../mixins/_layout
include ../../mixins/mixins
block content
  // page body goes here
```

- `app/mixins/_layout.jade` — the single base layout all pages `extends`. Owns the `<head>`
  (CSS/JS includes, inline Google Analytics), the top nav, the left sidebar (Services menu +
  contact blurb), the footer, and the `block content` slot pages fill. Override points are the
  named blocks `title`, `menu`, and `content`.
- `app/mixins/mixins.jade` — shared mixins reused across pages: `main_menu()` (the services nav,
  defined as a label→URL JS object — **add new service pages to this map** so they appear in the
  sidebar), `top_menu_top()`, `phone_number()`, `showcase_image(src, title)`,
  `call_for_a_free_estimate()`, and `ngg_album(title, image_src)`.
- `app/old/` — the original pre-Jade raw HTML, kept for reference only. Not part of the build.

**Galleries.** `showcase-gallery` and `ba-gallery` define a local `image_list` mixin that loops
over numbered files in the page's own `img/` subfolder (e.g. `showcase-gallery/img/1.jpg`) and
wraps each in a `data-lightbox` anchor. To add gallery images, drop sequentially-numbered files
into that `img/` folder and extend the loop's range. Image viewing uses Lightbox
(`js/lightbox.min.js` + `css/lightbox.min.css`); jQuery is loaded from a CDN in the layout.

**Front-end assets.** All shared CSS is in `css/`, JS libraries in `js/` (jQuery via CDN plus
vendored `lightbox`, `fadeslideshow`, `flir`, `shutter-reloaded`). Site images live in `images/`;
per-gallery images live under each gallery page's `img/`.

## Gotchas

- **Jade text vs. interpolation.** A leading `|` emits *literal* text. `|=title` renders the
  literal string `=title`, not the variable — to interpolate inside piped text use `#{title}`,
  or drop the `|` and use `= title`. (The `ngg_album` mixin currently has this bug, visible in the
  generated home page as a literal `=title`.)
- **Legacy toolchain (verified recipe).** Grunt 0.4.5 / grunt-contrib-jade 0.15.x require an old
  Node — use **Node 8.17.0** via nvm (`.nvmrc` pins it). On Apple Silicon this is the x64 build
  under Rosetta 2, since Node 8 has no arm64 binary; nvm fetches it automatically. Install the
  `grunt` command with **`npm install -g grunt-cli@1.3.2`** — the current grunt-cli (1.5.x) pulls
  `v8flags@4`, which calls a Node 10+ API and crashes on Node 8. The deprecation/audit warnings
  from `npm install` are build-time only (not shipped to the site); do **not** `npm audit fix`, as
  it bumps the pinned versions and breaks the build. `package.json` still carries the placeholder
  name `my-project-name`.

## Commits

Do not add Claude/AI attribution to commits or PRs: no `Co-Authored-By: Claude` trailer, no
"Generated with Claude Code" line, and no mention of Claude in commit messages or PR descriptions.
Author commits as the human developer.
