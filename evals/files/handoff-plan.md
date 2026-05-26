# 轻量级团队知识库 - 项目规划

## 项目概述
一个面向小团队的轻量级内部知识库系统，让知识创建和发现变得简单。

## 产品形态
Web 应用，响应式设计，支持桌面和移动端访问。

## 核心功能
1. Markdown 编辑器 — 支持实时预览和语法高亮
2. 标签分类系统 — 文章可打多个标签，支持按标签筛选
3. 全文搜索 — 搜索标题和正文内容
4. 关联图谱 — 自动根据标签和链接生成文章关联关系
5. 用户权限 — 管理员和普通成员角色

## 页面结构
- 首页：最近更新、常用标签、搜索入口
- 文章列表页：按标签/日期筛选
- 文章详情页：Markdown 渲染 + 关联文章推荐
- 编辑页：Markdown 编辑器 + 标签管理
- 图谱页：可视化知识关联图谱
- 管理后台：用户管理、系统设置

## 信息结构
- 文章：id, title, content, tags[], author, created_at, updated_at
- 标签：id, name, color
- 用户：id, name, email, role
- 存储：PostgreSQL + Redis 缓存

## 技术栈
- 前端：Next.js + TailwindCSS
- 后端：Next.js API Routes
- 数据库：PostgreSQL (via Prisma)
- 部署：Vercel
- 搜索：PostgreSQL Full Text Search

## 设计规范
简洁、中性风格，以内容阅读体验为核心，参考 Notion 的极简设计语言。
