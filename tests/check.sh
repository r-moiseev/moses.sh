#!/usr/bin/env bash
# Проверки по собранному public/. Запуск: hugo -D -F --panicOnWarning && tests/check.sh
# -F только локально: статья 1.1 датирована днём запуска (2026-11-02), без -F не собирается.
# CI собирает без -D и без -F: черновики и будущие даты в прод не попадают.
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
grep -q '<h2 id="what-i-do">' $idx || fail "главная: нет блока what-i-do"
grep -q '<h2 id="writing-about">' $idx || fail "главная: нет блока writing-about"
grep -q '<h2 id="code">' $idx || fail "главная: нет блока code"
grep -q '<h2 id="чем-занимаюсь">' public/ru/index.html || fail "главная RU: нет блока"
grep -c '<li>' $idx | awk '$1 < 10 {exit 1}' || fail "главная: меньше 10 буллетов"
# Статьи и серии
test -f public/ru/posts/claude-guard-hooks/index.html || fail "RU-статья не собралась"
test -f public/posts/claude-guard-hooks/index.html && fail "EN-страница статьи без EN-версии не должна существовать"
test -f public/ru/series/agent-infra/index.html || fail "нет страницы серии RU"
test -f public/series/agent-infra/index.html || fail "нет страницы серии EN"
grep -q 'claude-guard-hooks' public/index.xml && fail "RU-статья попала в EN-ленту"
grep -q 'claude-guard-hooks' public/ru/index.xml || fail "RU-статья не попала в RU-ленту"
art=public/ru/posts/claude-guard-hooks/index.html
grep -q 'href="/ru/series/agent-infra/"' $art || fail "в статье нет ссылки на серию"
grep -q 'Обсудить в Telegram' $art && fail "discuss без значения отрендерился"
grep -qE 'href="([^"]*)/ru/posts/"' public/ru/index.html || fail "нет ссылки на /ru/posts/ в меню"
echo "sidebar/head: ok"
