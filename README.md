# 东软环保公众监督系统

## 项目结构

```
├── back-api/          Spring Boot 后端（8080）
├── nepm/              Vue3 管理员端（5173）
├── nepg/              Vue3 网格员端（5174）
├── nepv/              Vue3 监测大屏（5175）
├── neps/              Vue3 公众监督员端（5176）
├── docs/              作业文档与图片
├── scripts/           文档与图片生成脚本
├── start.ps1 / start.bat   一键启动后端 + 四个前端
└── stop.ps1 / stop.bat     一键停止
```

## 环境依赖（必装）

| 依赖 | 版本要求 | 用途 | 验证命令 |
|------|----------|------|----------|
| **JDK** | 8 或以上 | 运行 Spring Boot 后端 | `java -version` |
| **Maven** | 3.6 或以上 | 构建与启动后端 | `mvn -version` |
| **MySQL** | 8.0 | 业务数据库 | 服务名为 `MySQL80` |
| **Node.js** | 18 或以上 | 运行 Vue 前端 | `node -version` |
| **npm** | 随 Node 安装 | 安装前端依赖 | `npm -version` |

### 可选依赖

| 依赖 | 用途 |
|------|------|
| **Python 3** | 导入 SQL、生成 Word 文档 |
| **python-docx** | `pip install python-docx`，生成说明书 |
| **Git** | 代码版本管理 |

### 默认配置

- MySQL 账号：`root` / `root`
- 数据库名：`nepm_db`
- 后端端口：`8080`（context-path: `/api`）

> 若 MySQL 密码不是 `root`，请修改 `back-api/src/main/resources/application.properties` 中的 JDBC 配置。

## 数据库初始化（首次必做）

```bash
py back-api/scripts/import_db.py fix-encoding.sql
# 或
py back-api/scripts/import_db.py init.sql
# 大屏演示数据（可选）
py back-api/scripts/import_db.py statistics-dashboard.sql
```

**注意**：不要用 PowerShell 管道 `Get-Content | mysql` 导入含中文的 SQL。

默认账号：
- 管理员：`admin` / `123`
- 公众监督员：`supervisor1` / `123456`
- 网格员：`grid001` / `123456`

## 一键启动 / 停止

```powershell
# 启动（后端 + nepm + nepg + nepv + neps）
start.bat
# 或
powershell -ExecutionPolicy Bypass -File .\start.ps1

# 停止
stop.bat
# 或
powershell -ExecutionPolicy Bypass -File .\stop.ps1
```

### 访问地址

| 项目 | 端口 | 地址 |
|------|------|------|
| 管理员端 nepm | 5173 | http://localhost:5173 |
| 网格员端 nepg | 5174 | http://localhost:5174 |
| 监测大屏 nepv | 5175 | http://localhost:5175 |
| 公众监督员端 neps | 5176 | http://localhost:5176 |
| 后端 API | 8080 | http://localhost:8080/api |

## 手动启动（可选）

```bash
# 后端
cd back-api && mvn spring-boot:run

# 管理员端
cd nepm && npm install && npm run dev

# 网格员端
cd nepg && npm install && npm run dev

# 监测大屏
cd nepv && npm install && npm run dev

# 公众监督员端
cd neps && npm install && npm run dev
```

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
- [ ] nepm/nepg/nepv/neps 源码（删除 node_modules/）
- [ ] 运行截图
