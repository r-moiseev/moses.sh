#!/usr/bin/env bash
# Проверки по собранному public/. Запуск: hugo --cleanDestinationDir --panicOnWarning && tests/check.sh
# Production-режим: черновики и будущие даты не публикуются.
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
grep -q '(in progress)' $idx && fail "главная EN: анонс несуществующего кода"
grep -q '(в работе)' public/ru/index.html && fail "главная RU: анонс несуществующего кода"
grep -q '<h2 id="what-i-do">' $idx || fail "главная: нет блока what-i-do"
grep -q '<h2 id="writing-about">' $idx || fail "главная: нет блока writing-about"
grep -q '<h2 id="чем-занимаюсь">' public/ru/index.html || fail "главная RU: нет блока"
test ! -f public/series/index.html || fail "пустой индекс серий EN"
test ! -f public/ru/series/index.html || fail "пустой индекс серий RU"
# RSS
for f in public/index.xml public/ru/index.xml; do
  python3 -c "import sys,xml.dom.minidom as m; m.parse(sys.argv[1])" $f || fail "$f не валидный XML"
  grep -q 'xmlns:content="http://purl.org/rss/1.0/modules/content/"' $f || fail "$f без namespace content"
done
# 404 и RSS-ссылка (финальный ревью)
test -s public/404.html || fail "404 пустая или отсутствует"
grep -q 'href="/"' public/404.html || fail "404 без ссылки на главную"
grep -q 'Роман Моисеев' public/ru/index.html || fail "RU: имя не переведено"
grep -q 'Roman Moiseev' public/ru/index.html && fail "RU: английское имя на странице"
grep -q 'Roman Moiseev' public/index.html || fail "EN: имени нет"
echo "sidebar/head: ok"
