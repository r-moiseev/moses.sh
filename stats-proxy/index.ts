// Прокси stats.moses.sh → moses.goatcounter.com.
// Прямой CNAME на GoatCounter флапает из РФ (Bunny CDN); Cloudflare edge доступен
// стабильно. Спека предусматривала этот шаг как контингенцию для блокировщиков —
// здесь он применён против недоступности из РФ.
export default {
  async fetch(req: Request): Promise<Response> {
    const url = new URL(req.url);
    url.hostname = "moses.goatcounter.com";
    const headers = new Headers(req.headers);
    headers.delete("host");
    const ip = req.headers.get("cf-connecting-ip");
    if (ip) headers.set("x-forwarded-for", ip);
    const init: RequestInit = { method: req.method, headers, redirect: "manual" };
    if (req.method !== "GET" && req.method !== "HEAD") init.body = req.body;
    return fetch(new Request(url, init));
  },
};
