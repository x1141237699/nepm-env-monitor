# 东软环保公众监督系统

## 项目结构

```
├── back-api/          Spring Boot 后端
├── nepm/              Vue3 统一前端（三端合一）
├── nepg/              网格员端（已合并至 nepm，保留参考）
├── nepv/              监测大屏（已合并至 nepm，保留参考）
├── docs/              作业文档与图片
├── scripts/           文档与图片生成脚本
├── start.ps1 / start.bat   一键启动前后端
└── stop.ps1 / stop.bat     一键停止前后端
```

## 环境依赖（必装）

运行本项目前，请在本机安装并配置以下环境：

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
- 前端端口：`5173`

> 若 MySQL 密码不是 `root`，请修改 `back-api/src/main/resources/application.properties` 中的 JDBC 配置。

## 数据库初始化（首次必做）

```bash
# 推荐：使用 Python 脚本导入（避免 Windows 终端中文乱码）
py back-api/scripts/import_db.py fix-encoding.sql

# 或全新初始化
py back-api/scripts/import_db.py init.sql

# 大屏演示数据（可选）
py back-api/scripts/import_db.py statistics-dashboard.sql
```

**注意**：不要用 PowerShell 管道 `Get-Content | mysql` 导入含中文的 SQL，否则中文会变成问号 `???`。

默认账号：
- 管理员：`admin` / `123`
- 公众监督员：`supervisor1` / `123456`
- 网格员：`grid001` / `123456`

## 一键启动 / 停止

### 启动

```powershell
# 方式一：双击
start.bat

# 方式二：PowerShell
powershell -ExecutionPolicy Bypass -File .\start.ps1
```

脚本会自动：
1. 检查 JDK、Maven、Node.js 是否可用
2. 首次运行自动执行 `npm install`
3. 启动后端（8080）并等待就绪
4. 启动前端（5173）

### 停止

```powershell
# 方式一：双击
stop.bat

# 方式二：PowerShell
powershell -ExecutionPolicy Bypass -File .\stop.ps1
```

### 访问地址

| 服务 | 地址 |
|------|------|
| 统一前端 | http://localhost:5173 |
| 后端 API | http://localhost:8080/api |

侧边栏分组导航：
- **公众监督员端**：登录/注册、空气质量反馈
- **网格员端**：登录、反馈任务列表、空气质量实测
- **管理员端**：登录、公众监督数据列表、AQI实测数据列表、监测大屏

## 手动启动（可选）

```bash
# 后端
cd back-api
mvn spring-boot:run

# 前端（另开终端）
cd nepm
npm install
npm run dev
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
- [ ] nepm 源码（删除 node_modules/）
- [ ] 运行截图
