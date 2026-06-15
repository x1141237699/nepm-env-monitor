# 东软环保公众监督系统

## 项目结构

```
├── back-api/          Spring Boot 后端
├── nepm/              Vue3 管理端前端
├── docs/              作业文档与图片
│   ├── 03-原型图/
│   ├── 03-流程图/
│   ├── 04-数据库设计说明书.docx
│   ├── 04-接口设计说明书.docx
│   └── 05-需求规格说明书.docx
└── scripts/           文档与图片生成脚本
```

## 环境要求

- JDK 8+
- Maven 3.6+
- MySQL 8.0（默认 root/root）
- Node.js 18+
- Python 3 + python-docx（生成 Word 文档）

## 数据库初始化

```bash
# 推荐：使用 Python 脚本导入（避免 Windows 终端中文乱码）
py back-api/scripts/import_db.py fix-encoding.sql

# 或全新初始化（首次安装）
py back-api/scripts/import_db.py init.sql
```

**注意**：不要用 PowerShell 管道 `Get-Content | mysql` 导入含中文的 SQL，否则中文会变成问号 `???`。

默认账号：
- 管理员：admin / 123
- 公众监督员：supervisor1 / 123456
- 网格员：grid001 / 123456

## 启动后端

```bash
cd back-api
mvn spring-boot:run
```

后端地址：http://localhost:8080/api

## 启动前端

```bash
cd nepm
npm install
npm run dev
```

前端地址：http://localhost:5173

## 生成文档与图片

```bash
cd scripts
pip install python-docx
python generate_docs.py
node export_flowcharts.js
node export_prototypes.js
```

## 提交清单

- [ ] docs/03-原型图/ 全部 PNG
- [ ] docs/03-流程图/ 5 张流程图
- [ ] 3 份 .docx 文档
- [ ] back-api 源码（删除 target/）
- [ ] nepm 源码（删除 node_modules/）
- [ ] 运行截图
