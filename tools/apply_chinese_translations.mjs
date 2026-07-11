#!/usr/bin/env node
/**
 * Applies contextual Chinese translations to lib/l10n/app_zh.arb
 * Run: node tools/apply_chinese_translations.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const arbPath = path.join(__dirname, '..', 'lib', 'l10n', 'app_zh.arb');
const zh = JSON.parse(fs.readFileSync(arbPath, 'utf8'));

/** @type {Record<string, string>} */
const patches = {
  appTitle: 'Master Elf 风水',
  heroMasterElfCaption: 'Master Elf',
  eventsGoat2027Title: 'Master Elf — 迎接 2027 火羊年',
  event1Title: 'Master Elf - 凤凰崛起 2026',
  event2Location: '新加坡圣淘沙名胜世界',
  event3Location: '新加坡名胜世界',
  event4Title: '择日大师班',
  eventsZodiacStripPhoenix: '凤凰 2026',
  eventsZodiacStripGoat: '火羊 2027',
  earlyBirdEnds: '早鸟优惠',
  tooltipWhatsApp: 'WhatsApp 联系',
  tooltipFacebook: 'Facebook',
  tooltipInstagram: 'Instagram',
  tooltipTikTok: 'TikTok',
  tooltipTelegram: 'Telegram',
  bookStoreBook1Title: '现代风水',
  bookStoreBook2Title: '奇门遁甲应用',
  bookStoreBook3Title: '战略易经',
  bookStoreBook4Title: '茅山之道',
};

let applied = 0;
for (const [key, value] of Object.entries(patches)) {
  if (key in zh) {
    zh[key] = value;
    applied++;
  } else {
    console.warn('Missing key in arb:', key);
  }
}

fs.writeFileSync(arbPath, JSON.stringify(zh, null, 2) + '\n', 'utf8');
console.log(`Applied ${applied} updates to ${arbPath}`);
