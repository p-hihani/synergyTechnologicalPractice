# Delphi 10.2 + IIS + MS SQL Server: пример WEB-приложения (WebBroker ISAPI)

## 1) Краткий обзор рынка и архитектур WEB‑приложений

| Класс ИС | Примеры | Типовая архитектура | Сильные стороны | Риски/ограничения | Где уместно |
|---|---|---|---|---|---|
| CRM/ERP (SaaS) | Salesforce, MS Dynamics 365, SAP S/4HANA + Fiori, Odoo, 1C, Битрикс24 | Многоуровневая (SPA/SSR фронт + API + БД), event-driven, микросервисы | Процессы «из коробки», масштабируемость | Лицензии, вендор‑локин, сложность кастомизаций | Продажи, финансы, склад, производство |
| CMS/порталы | WordPress, Drupal, Joomla, Headless CMS (Strapi) | MVC/Headless (REST/GraphQL), кэш, CDN | Быстрый запуск контента, экосистема | Безопасность плагинов, производительность | Сайты, блоги, порталы, Intranet |
| E‑commerce | Magento/Adobe, Shopify, Shopware | Сервисная архитектура, API‑first, платежные шлюзы | Каталог, корзина, акции | Интеграции, высокие SLA | Интернет‑магазины |
| BPM/ESB | Camunda, Bonita | Микросервисы, оркестрация, очереди | Наглядные процессы, интеграции | Кривая обучения | Сквозные процессы |
| BI/аналитика | Power BI, Tableau, Metabase | DWH + визуализации (web) | Самообслуживание аналитики | Качество данных | Отчеты, дашборды |
| Helpdesk/ITSM | Jira Service Management, GLPI | Веб + workflow | SLA, triage | Лицензии/админка | Поддержка/Сервисы |

**Паттерны архитектуры WEB‑приложений**: 
- 3‑звенная (UI/API/DB), микросервисы, CQRS/ES, SOA; SPA + REST/GraphQL; SSR/ISR; очереди (RabbitMQ/Kafka); кэш (Redis); облака (K8s, Docker).  
**Деплой**: IIS/ASP.NET, Apache/Nginx, облака (Azure/AWS/GCP), PaaS.  
**Безопасность**: TLS, OAuth2/OIDC, JWT, RBAC/ABAC, защита от XSS/CSRF/SQLi, аудит.

## 2) Варианты использования в компании
1. **Внутренние реестры** (склад, заявки): небольшой монолит (IIS + MS SQL).  
2. **Портал заказов/интеграции**: API‑шлюз, авторизация по OAuth2, очередь на фоновые задачи.  
3. **Отчеты/дашборды**: read‑replica БД, кэширование.  
4. **CRM‑лайт**: готовый SaaS + тонкая интеграция через веб‑хуки, синхронизация с внутренними сервисами.

## 3) Практика: WebBroker ISAPI на Delphi 10.2 + IIS + MS SQL Server

### Возможности демо
- REST API: `/api/products` (GET — список, POST — создать), `/api/products/{id}` (GET/PUT/DELETE), `/health`.
- Подключение к **MS SQL Server** через **FireDAC**.
- Простая HTML‑страница для ручного теста API.

### Быстрый старт
1. Выполните скрипт БД `db/mssql/01_schema.sql` в MSSQL.  
2. Откройте проект `src/DelphiWebApp.dpr` в Delphi, соберите **ISAPI DLL** (Win32).  
3. В IIS:  
   - Включите **ISAPI Extensions** и **ISAPI Filters**.  
   - Создайте AppPool (вкл. 32‑bit apps = **True**, Pipeline = Integrated).  
   - Создайте сайт/виртуальный каталог, укажите физическую папку с DLL (например, `C:\inetpub\delphiapp`).  
   - Привяжите каталог к пулу, добавьте **Handler Mapping**: `*.dll` → `IsapiModule` (разрешить).  
   - Разрешите исполняемые файлы (Request Filtering → File Name Extensions → .dll → Allow).  
4. Скопируйте скомпилированную `DelphiWebApp.dll` в корень сайта.  
5. Проверьте:  
   - `GET http://localhost/DelphiWebApp.dll/health` → `{"status":"ok"}`  
   - `GET http://localhost/DelphiWebApp.dll/api/products` → JSON со списком.

### Переменные окружения (рекомендовано)
- `DB_SERVER` (по умолчанию `localhost`), `DB_DATABASE` (`DelphiShop`), `DB_USER`, `DB_PASSWORD`.  
Если `DB_USER`/`DB_PASSWORD` не заданы — используется Windows Integrated Security.

### Структура репозитория
```
delphi-web-arch-sample/
├─ README.md
├─ docs/
│  └─ iis_setup.md
├─ db/
│  └─ mssql/
│     └─ 01_schema.sql
└─ src/
   ├─ DelphiWebApp.dpr
   ├─ WebModuleUnit1.pas
   └─ WebModuleUnit1.dfm
```

## 4) Экспорт схемы БД
Скрипт `db/mssql/01_schema.sql` содержит DDL и демо‑данные для **MS SQL Server**.  
Если потребуется **MySQL**, экспорт возможен из MySQL Workbench (File → Export → Forward Engineer SQL CREATE Script).

---

**Лицензия:** MIT.  
**Назначение:** учебный пример для проверки навыков WEB‑архитектуры и деплоя под IIS.
