# moses.sh

Personal site: AI infrastructure & platform notes. Hugo + [Risotto](https://github.com/joeroe/risotto), deployed to Cloudflare Workers Static Assets from GitHub Actions.

## Local

    git submodule update --init
    hugo server -D

Hugo 0.164.0 extended (pinned in CI).

## Layout

- `content/posts/<slug>/index.{en,ru}.md` — articles, one bundle per article, one file per language
- `content/series/<slug>/_index.{en,ru}.md` — series descriptions
- `layouts/` — overrides of the theme; the theme itself is a submodule and is not modified
- `static/js/count.js` — GoatCounter client, self-hosted copy of https://gc.zgo.at/count.js

## License

Code (layouts, config) — MIT. Texts under `content/` — CC BY 4.0.
