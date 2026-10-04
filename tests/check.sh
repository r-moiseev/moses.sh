#!/usr/bin/env bash
# Проверки по собранному public/. Запуск: hugo -D --panicOnWarning && tests/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*" >&2; exit 1; }
idx=public/index.html

grep -q 'cdnjs.cloudflare.com' $idx && fail "cdnjs в head"
grep -q 'fonts.googleapis.com' $idx && fail "Google Fonts в head"
grep -q 'href="https://github.com/r-moiseev"' $idx || fail "нет ссылки на GitHub в сайдбаре"
grep -q 'href=""' $idx && fail "пустой href: контакт без url отрендерился"
grep -q 'src="/js/count.js"' $idx || fail "count.js не подключён"
grep -q 'data-goatcounter="https://stats.moses.sh/count"' $idx || fail "нет endpoint GoatCounter"
grep -q 'href="/ru/"' $idx || fail "нет переключателя на /ru/"
grep -q 'href="/"' public/ru/index.html || fail "нет переключателя на / из RU"
grep -q 'rel="alternate" type="application/rss+xml"' $idx || fail "нет ссылки на RSS"
echo "sidebar/head: ok"
