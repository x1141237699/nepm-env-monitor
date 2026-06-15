const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

const prototypes = [
  { html: 'admin-login.html', output: '系统管理员端-登录.png', width: 1280, height: 800 },
  { html: 'admin-feedback-list.html', output: '系统管理员端-反馈列表.png', width: 1280, height: 800 },
  { html: 'admin-feedback-detail.html', output: '系统管理员端-反馈详情.png', width: 1280, height: 800 },
  { html: 'admin-assign.html', output: '系统管理员端-指派网格员.png', width: 1280, height: 800 },
  { html: 'supervisor-register.html', output: '公众监督员端-注册.png', width: 375, height: 812 },
  { html: 'supervisor-login.html', output: '公众监督员端-登录.png', width: 375, height: 812 },
  { html: 'supervisor-select-grid.html', output: '公众监督员端-选择网格.png', width: 375, height: 812 },
  { html: 'supervisor-feedback.html', output: '公众监督员端-提交反馈.png', width: 375, height: 812 },
  { html: 'grid-login.html', output: '网格员端-登录.png', width: 375, height: 812 },
  { html: 'grid-assign-list.html', output: '网格员端-指派列表.png', width: 375, height: 812 },
  { html: 'grid-confirm-aqi.html', output: '网格员端-确认AQI数据.png', width: 375, height: 812 },
];

async function main() {
  const protoDir = path.join(__dirname, 'prototypes');
  const outDir = path.join(__dirname, '..', 'docs', '03-原型图');
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  for (const item of prototypes) {
    const page = await browser.newPage();
    await page.setViewportSize({ width: item.width, height: item.height });
    const filePath = 'file:///' + path.join(protoDir, item.html).replace(/\\/g, '/');
    await page.goto(filePath);
    await page.waitForTimeout(300);
    await page.screenshot({ path: path.join(outDir, item.output), fullPage: true });
    await page.close();
    console.log('Exported:', item.output);
  }
  await browser.close();
}

main().catch(console.error);
