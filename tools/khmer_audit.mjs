#!/usr/bin/env node
/**
 * Generates docs/khmer_audit.csv from app_en.arb vs app_km.arb.
 * Run: node tools/khmer_audit.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const en = JSON.parse(fs.readFileSync(path.join(root, 'lib/l10n/app_en.arb'), 'utf8'));
const km = JSON.parse(fs.readFileSync(path.join(root, 'lib/l10n/app_km.arb'), 'utf8'));

const keys = Object.keys(en).filter((k) => !k.startsWith('@') && k !== '@@locale');

function placeholders(s) {
  return (s.match(/\{[^}]+\}/g) || []).sort().join(',');
}

function issueTags(key, enVal, kmVal) {
  const tags = [];
  if (!kmVal || kmVal.trim() === '') tags.push('empty');
  if (kmVal === enVal) tags.push('same_as_en');
  if (/មិះ|រទេះ|អ៉ីមែល/.test(kmVal)) tags.push('typo');
  if (placeholders(enVal) !== placeholders(kmVal)) tags.push('placeholder');
  // English leak: 4+ letter Latin word not in allowlist
  const allow = /Master Elf|BaZi|Feng Shui|QiMen|Qi Men|I Ching|Xuan Kong|Period|Mao Shan|Google|Facebook|Telegram|WhatsApp|Instagram|TikTok|App Store|Google Play|PlasGate|Stonechat|SMS|URL|PDF|iOS|Android|Resorts|Singapore|Sentosa|MRT|Tung Shu|Luo Pan|Lo Shu|Mountains|Tiger|Dragon|Phoenix|Sha|Bazi|Dunjia|Dun Jia|Flying Star|Eight Mansions|Cardinal|Kan|Kun|Zhen|Xun|Qian|Dui|Gen|Li|Odd|Yin|Yang|Yi|Bing|Ding|yarrow|hexagram|Li Fire|Bing Wu|Fei Xing|Mount Mao|Qi Men|Iching|QiMen|Charter|Harmony|Mastery|Publications|Phoenix|Crimson|Horse|Stonechat|http|https|masterelf|hongchhayheng|t\.me|facebook\.com/i;
  const latin = kmVal.match(/[A-Za-z]{4,}/g);
  if (latin && latin.some((w) => !allow.test(w))) tags.push('english_leak');
  return tags;
}

function csvEscape(s) {
  return `"${String(s).replace(/"/g, '""').replace(/\n/g, ' ')}"`;
}

const rows = [['key', 'EN text', 'current KM', 'issue tags', 'proposed KM', 'reviewer', 'status']];
for (const key of keys) {
  const enVal = en[key];
  const kmVal = km[key] ?? '';
  const tags = issueTags(key, enVal, kmVal);
  if (tags.length === 0) continue;
  rows.push([
    key,
    enVal,
    kmVal,
    tags.join(';'),
    '',
    'Master Elf team',
    'open',
  ].map(csvEscape).join(','));
}

const out = path.join(root, 'docs', 'khmer_audit.csv');
fs.writeFileSync(out, '\uFEFF' + rows.map((r) => (Array.isArray(r) ? r.join(',') : r)).join('\n'), 'utf8');
console.log(`Wrote ${rows.length - 1} flagged rows to ${out}`);
console.log(`Total keys: ${keys.length}, missing in KM: ${keys.filter((k) => !(k in km)).length}`);
