@echo off
REM Windows and symlinks do not get along with each other, so on Windows
REM `node_modules\ep_etherpad-lite` is sometimes a full copy of `ep_etherpad-lite` not a
REM symlink to `ep_etherpad-lite`. If it is a copy, Node.js sees `ep_etherpad-lite\foo.js` and
REM `node_modules\ep_etherpad-lite\foo.js` as two independent modules with
REM independent state, when they should be treated as the same file. To work
REM around this, everything must consistently use either `ep_etherpad-lite` or
REM `node_modules\ep_etherpad-lite` on Windows. Because some plugins access
REM Etherpad internals via `require('ep_etherpad-lite/foo')`,
REM `node_modules\ep_etherpad-lite` is used here.
cd ep_etherpad-lite
pnpm run prod
