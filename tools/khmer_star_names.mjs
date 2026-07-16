#!/usr/bin/env node
/** Apply Khmer transliterations to Latin pinyin star names in forecast_popup.dart */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const file = path.join(__dirname, '..', 'lib', 'widgets', 'forecast_popup.dart');
let content = fs.readFileSync(file, 'utf8');

const starMap = {
  'Zai Zha': 'ហ្សៃ ចា',
  'Long De': 'លុង ដេ',
  'Zi Wei': 'ជឺ វ៉ី',
  'Guo Ying': 'ក្វូ យិង',
  'Bao Bai': 'ប៉ាវ បៃ',
  'Tian Er': 'ទៀន អ៊ឹរ',
  'Tian Sha': 'ទៀន សា',
  'San He': 'សាន ហេ',
  'Xue Tang': 'ស្វេ តាង',
  'Bai Hu': 'បៃ ហូ',
  'Fei Lian': 'ហ្វី លៀន',
  'Da Sha': 'ដា សា',
  'Zhi Bei': 'ជី ប៉ី',
  'Tian De': 'ទៀន ដេ',
  'Fu De': 'ហ្វូ ដេ',
  'Fu Xing': 'ហ្វូ ស៊ីង',
  'Tian Xi': 'ទៀន ស៊ី',
  'Pi Ma': 'ពី ម៉ា',
  'Juan She': 'ជួន សេ',
  'Jiao Sha': 'ជៀវ សា',
  'Xian Chi': 'សៀន ឈី',
  'Tian Jie': 'ទៀន ជៀ',
  'Jie Shen': 'ជៀ សឹន',
  'Ba Zuo': 'បា សួច',
  'Tian Gou': 'ទៀន កូ',
  'Diao Ke': 'ឌៀវ ខេ',
  'Xue Ren': 'ស្វេ ស៊ិន',
  'Fu Chen': 'ហ្វូ ចឹន',
  'Lu Xun': 'លូ ស៊ុន',
  'Mo Yue': 'ម៉ូ យ៉ូ',
  'Bing Fu': 'ប៊ីង ហ្វូ',
  'Po Sui': 'ប៉ូ សួយ',
  'Wang Shen': 'វ៉ាង សឹន',
  'Sui Jia': 'សួយ ជៀ',
  'Jiang Xing': 'ជៀង ស៊ីង',
  'Jin Gui': 'ជីន ក្វី',
  'Tai Sui': 'តាយ សួយ',
  'Jian Feng': 'ជៀន ហ្វេង',
  'Fu Shi': 'ហ្វូ ស៊ី',
  'Sui Xing': 'សួយ ស៊ីង',
  'Tai Yang': 'តាយ យ៉ាង',
  'Sui He': 'សួយ ហេ',
  'Ban An': 'បាន អាន',
  'Tian Kong': 'ទៀន កុង',
  'Hui Chi': 'ហ៊ូយ ឈី',
  'Drinking jiǔ sè shā': 'ច្រិត ជីវ៉ូ សេ សា',
  'Liu Sha': 'លៀវ សៀ',
  'Sui Dian': 'សួយ ឌៀន',
  'Wen Chang': 'វ៉ិន ចាង',
  'Yi Ma': 'អ៊ី ម៉ា',
  'Sang Men': 'សាង ម៉ិន',
  'Di San': 'ឌី សាន',
  'Gu Chen': 'ហ្គូ ចឹន',
  'Gu Xu': 'ហ្គូ ស៊ូ',
  'Tai Yin': 'តាយ យិន',
  'Hong Luan': 'ហុង លួន',
  'Tian Yi': 'ទៀន អ៊ី',
  'Gou Jiao': 'កូ ជៀវ',
  'Guan Suo': 'ក្វាន សួច',
  'Zu Bao': 'ហ្សូ ប៉ាវ',
  'Di Jie': 'ឌី ជៀ',
  'Hua Gai': 'ហួ កៃ',
  'Wu Gui': 'វូ ក្វី',
  'Guan Fu': 'ក្វាន ហ្វូ',
  'Pi Tou': 'ពី ទូ',
  'Yue De': 'យ៉ូ ដេ',
  'Yu Tang': 'យូ តាង',
  'Xiao Hao': 'សៀវ ហាវ',
  'Si Fu': 'ស៊ី ហ្វូ',
  'You Yi': 'យូ អ៊ី',
};

let count = 0;
for (const [latin, khmer] of Object.entries(starMap)) {
  const pattern = `khmerName: '${latin}'`;
  const replacement = `khmerName: '${khmer}'`;
  if (content.includes(pattern)) {
    content = content.split(pattern).join(replacement);
    count++;
  }
}

fs.writeFileSync(file, content, 'utf8');
console.log(`Updated ${count} star names in forecast_popup.dart`);
