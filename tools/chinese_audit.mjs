#!/usr/bin/env node
/**
 * Generates docs/chinese_audit.csv from app_en.arb vs app_zh.arb.
 * Run: node tools/chinese_audit.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const en = JSON.parse(fs.readFileSync(path.join(root, 'lib/l10n/app_en.arb'), 'utf8'));
const zh = JSON.parse(fs.readFileSync(path.join(root, 'lib/l10n/app_zh.arb'), 'utf8'));

const keys = Object.keys(en).filter((k) => !k.startsWith('@') && k !== '@@locale');

const priceUrlExempt =
  /Price$|Prefix$|Link$|facebook|telegram|http|^\$|^\d+\.\d+$|t\.me/i;

function placeholders(s) {
  return (s.match(/\{[^}]+\}/g) || []).sort().join(',');
}

function issueTags(key, enVal, zhVal) {
  const tags = [];
  if (!zhVal || zhVal.trim() === '') tags.push('empty');
  if (zhVal === enVal && !priceUrlExempt.test(key) && !priceUrlExempt.test(enVal)) {
    tags.push('same_as_en');
  }
  if (placeholders(enVal) !== placeholders(zhVal)) tags.push('placeholder');
  return tags;
}

function csvEscape(s) {
  return `"${String(s).replace(/"/g, '""').replace(/\n/g, ' ')}"`;
}

const rows = [['key', 'EN text', 'current ZH', 'issue tags', 'proposed ZH', 'reviewer', 'status']];
for (const key of keys) {
  const enVal = en[key];
  const zhVal = zh[key] ?? '';
  const tags = issueTags(key, enVal, zhVal);
  if (tags.length === 0) continue;
  rows.push(
    [key, enVal, zhVal, tags.join(';'), '', 'Master Elf team', 'open'].map(csvEscape).join(','),
  );
}

const out = path.join(root, 'docs', 'chinese_audit.csv');
fs.writeFileSync(out, '\uFEFF' + rows.join('\n'), 'utf8');
console.log(`Wrote ${rows.length - 1} flagged rows to ${out}`);
console.log(`Total keys: ${keys.length}, missing in ZH: ${keys.filter((k) => !(k in zh)).length}`);
