const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const flowcharts = [
  '主业务流程图.mmd',
  '公众反馈流程图.mmd',
  '网格员确认流程图.mmd',
  '管理员指派流程图.mmd',
  '统计看板流程图.mmd',
  'er-diagram.mmd',
];

const flowDir = path.join(__dirname, 'flowcharts');
const outFlowDir = path.join(__dirname, '..', 'docs', '03-流程图');
const outDocsDir = path.join(__dirname, '..', 'docs');

fs.mkdirSync(outFlowDir, { recursive: true });

for (const file of flowcharts) {
  const input = path.join(flowDir, file);
  const baseName = file.replace('.mmd', '.png');
  const outFlow = path.join(outFlowDir, baseName);
  const outDoc = path.join(outDocsDir, baseName);
  try {
    execSync(`npx --yes @mermaid-js/mermaid-cli -i "${input}" -o "${outFlow}" -b white`, {
      stdio: 'inherit',
      cwd: __dirname,
    });
    if (file === 'er-diagram.mmd') {
      fs.copyFileSync(outFlow, outDoc);
    }
    console.log('Exported:', baseName);
  } catch (e) {
    console.error('Failed:', file, e.message);
  }
}
