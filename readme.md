# Showcase Landscaping

[Website](http://showcaselandscapingsc.com)

Static marketing site authored in Jade (Pug) templates and compiled to HTML. The compiled
HTML at the repo root is the deployed artifact (served via GitHub Pages).


### Project Setup

This project uses a 2014-era Grunt + Jade toolchain that requires an old version of Node. The
steps below are verified on macOS (Apple Silicon) using [nvm](https://github.com/nvm-sh/nvm).

#### 1. Use Node 8

The build tools predate Node 10, so select Node 8 with nvm. A `.nvmrc` in this repo pins the
version, so `nvm use` (no argument) picks it up automatically.

    nvm install 8.17.0   # on Apple Silicon installs the x64 build (runs under Rosetta 2)
    nvm use              # reads .nvmrc -> 8.17.0; run this in every new terminal

#### 2. Install dependencies

    npm install                      # project's Grunt plugins (uses the bundled npm 6)
    npm install -g grunt-cli@1.3.2   # the `grunt` command; newest grunt-cli that runs on Node 8

Newer `grunt-cli` (1.5.x) pulls in `v8flags@4`, which uses a Node 10+ API and crashes on Node 8.

`npm install` prints many deprecation and audit warnings. These come from build-time
dependencies only — they are never shipped to the site — so leave them as-is and do **not** run
`npm audit fix` (it would bump the pinned versions and break the build).

#### 3. Building Jade

    grunt jade   # compiles app/views/**/*.jade to HTML at the repo root

#### 4. Serving files locally

    grunt serve  # http://localhost:8001

To only preview the already-built site without the toolchain, serve the repo root with any
static server, e.g. `python3 -m http.server 8001`.


### Project Files

The main project files are under the `app/views` folder. Some common files are used/imported
from the `app/mixins` folder. After editing any `.jade` file, run `grunt jade` and commit the
regenerated `.html` alongside it — the root-level HTML files are what gets deployed.
