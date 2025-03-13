# Online Judge Website based on ASP.NET Framework

## To do List
- [X] 主要处理数据库链接的代码
- [X] 注册页面数据库链接
- [X] 注册页面验证
- [X] 传cookie
- [X] 登录数据库验证
- [X] 读取数据库特定题目生成对应题目页面
- [X] 导入Markdig库,创建markdown_to_html类
- [X] markdown转页面
- [ ] 后端运行代码并返回是否ac
- [ ] 各页面读取cookie中内容并显示是否登录

# DataBase E-R

```mermaid
erDiagram
    users {
        INT user_id PK "AUTO_INCREMENT"
        VARCHAR username "50 UNIQUE NOT NULL"
        VARCHAR password_hash "255 NOT NULL"
        VARCHAR email "100 UNIQUE NOT NULL"
        ENUM role "('user', 'admin') DEFAULT 'user'"
        TIMESTAMP registration_time "DEFAULT CURRENT_TIMESTAMP"
    }
    problems {
        INT problem_id PK "AUTO_INCREMENT"
        VARCHAR title "255 NOT NULL"
        TEXT description "NOT NULL"
        TEXT input_description "NOT NULL"
        TEXT output_description "NOT NULL"
        TEXT sample_input "NOT NULL"
        TEXT sample_output "NOT NULL"
        INT time_limit "NOT NULL" 
        INT memory_limit "NOT NULL"
        ENUM difficulty "('easy', 'medium', 'hard') DEFAULT 'medium'"
        INT created_by FK "NOT NULL"
    }
    test_cases {
        INT test_case_id PK "AUTO_INCREMENT"
        INT problem_id FK "NOT NULL"
        TEXT input_data "NOT NULL"
        TEXT expected_output "NOT NULL"
        BOOLEAN is_sample "DEFAULT FALSE"
    }
    submissions {
        INT submission_id PK "AUTO_INCREMENT"
        INT user_id FK "NOT NULL"
        INT problem_id FK "NOT NULL"
        TEXT code "NOT NULL"
        ENUM language "('C', 'C++', 'Java', 'Python', 'JavaScript') NOT NULL"
        TIMESTAMP submit_time "DEFAULT CURRENT_TIMESTAMP"
        ENUM status "('Pending', 'Accepted', 'Wrong Answer', 'Time Limit Exceeded', 'Memory Limit Exceeded', 'Runtime Error', 'Compilation Error') DEFAULT 'Pending'"
        INT execution_time "DEFAULT NULL"
        INT memory_used "DEFAULT NULL"
    }
    contests {
        INT contest_id PK "AUTO_INCREMENT"
        VARCHAR title "255 NOT NULL"
        TEXT description
        DATETIME start_time "NOT NULL"
        DATETIME end_time "NOT NULL"
        INT created_by FK "NOT NULL"
    }
    contest_problems {
        INT contest_id FK "NOT NULL"
        INT problem_id FK "NOT NULL"
    }
    contest_participants {
        INT contest_id FK "NOT NULL"
        INT user_id FK "NOT NULL"
    }
    announcements {
        INT announcement_id PK "AUTO_INCREMENT"
        VARCHAR title "255 NOT NULL"
        TEXT content "NOT NULL"
        INT created_by FK "NOT NULL"
        TIMESTAMP created_time "DEFAULT CURRENT_TIMESTAMP"
    }

    users ||--o{ problems : "创建"
    problems ||--o{ test_cases : "包含"
    users ||--o{ submissions : "提交"
    problems ||--o{ submissions : "关联"
    users ||--o{ contests : "创建"
    contests ||--o{ contest_problems : "包含"
    problems ||--o{ contest_problems : "被包含"
    contests ||--o{ contest_participants : "有"
    users ||--o{ contest_participants : "参与"
    users ||--o{ announcements : "发布"
```

