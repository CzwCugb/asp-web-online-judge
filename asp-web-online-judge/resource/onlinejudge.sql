DROP DATABASE IF EXISTS onlinejudge;

CREATE DATABASE IF NOT EXISTS onlinejudge CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE onlinejudge;
DROP TABLE IF EXISTS problem;
DROP TABLE IF EXISTS User;

CREATE TABLE IF NOT EXISTS problem (
  id INT AUTO_INCREMENT PRIMARY KEY,  -- 自增主键‌:ml-citation{ref="2,3" data="citationList"}
  title VARCHAR(255) NOT NULL,       -- 题目标题
  description TEXT NOT NULL,         -- 题目描述
  difficulty ENUM('Easy','Medium','Hard') NOT NULL,  -- 枚举约束‌:ml-citation{ref="2,3" data="citationList"}
  time_memory_limit VARCHAR(50) NOT NULL,
  total_accepted INT DEFAULT 0,
  total_attempted INT DEFAULT 0,
  algorithm_tags VARCHAR(255),
  FULLTEXT INDEX idx_description (description)  -- 全文检索支持‌:ml-citation{ref="2" data="citationList"}
);

CREATE TABLE if NOT EXISTS User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NULL,
    registrationdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

USE onlinejudge;
insert Into User(
	account,
    password
)values(
	'admin',
    'admin'
);


INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'Hello,World!', 
    '
## 题目描述

编写一个能够输出 `Hello,World!` 的程序。

提示：
- 使用英文标点符号；
- `Hello,World!` 逗号后面**没有**空格。
- `H` 和 `W` 为**大写**字母。

## 输入格式

无

## 输出格式

无

## 输入输出样例 #1

### 输入 #1

```
无
```

### 输出 #1

```
Hello,World!
```', 
    'Easy', 
    '1s / 128MB',
    0,
    0,
    N'顺序结构'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'输出字符菱形', 
    '
## 题目描述

用 `*` 构造一个对角线长 $5$ 个字符，倾斜放置的菱形。

## 输入格式

没有输入要求。

## 输出格式

如样例所示。用 `*` 构成的菱形。

## 输入输出样例 #1

### 输入 #1

```

```

### 输出 #1

```
*
 ***
*****
 ***
  *
```', 
    'Easy', 
    '1s / 128MB',
    0,
    0,
    N'顺序结构'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'超级玛丽游戏', 
    '
## 题目背景

本题是试机题目。

## 题目描述

超级玛丽是一个非常经典的游戏。请你用字符画的形式输出超级玛丽中的一个场景。

```
                ********
               ************
               ####....#.
             #..###.....##....
             ###.......######              ###            ###
                ...........               #...#          #...#
               ##*#######                 #.#.#          #.#.#
            ####*******######             #.#.#          #.#.#
           ...#***.****.*###....          #...#          #...#
           ....**********##.....           ###            ###
           ....****    *****....
             ####        ####
           ######        ######
##############################################################
#...#......#.##...#......#.##...#......#.##------------------#
###########################################------------------#
#..#....#....##..#....#....##..#....#....#####################
##########################################    #----------#
#.....#......##.....#......##.....#......#    #----------#
##########################################    #----------#
#.#..#....#..##.#..#....#..##.#..#....#..#    #----------#
##########################################    ############
```

## 输入格式

无

## 输出格式

如描述
', 
    'Easy', 
    '1s / 128MB',
    0,
    0,
    N'字符串'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'A+B Problem', 
    '
## 题目背景

**不熟悉算法竞赛的选手请看这里：**

算法竞赛中要求的输出格式中，**不能有多余的内容**，**这也包括了“请输入整数 $\\bm a$ 和 $\\bm b$” 这一类的提示用户输入信息的内容**。若包含了这些内容，将会被认为是 `Wrong Answer`，即洛谷上的 `WA`。在对比代码输出和标准输出时，系统将忽略每一行结尾的空格，以及最后一行之后多余的换行符。

若因此类问题出现本机似乎输出了正确的结果，但是实际提交结果为错误的现象，请勿认为是洛谷评测机出了问题，而是你的代码中可能存在多余的输出信息。用户可以参考在题目末尾提供的代码。

此外，**请善用应用中的在线 IDE 功能**，以避免不同平台的评测产生差异。

最后，请不要在对应的题目讨论区中发布自己的题解，请发布到题解区域中，否则将处以删除或禁言的处罚。若发现无法提交题解则表明本题题解数量过多，仍不应发布讨论。若您的做法确实与其他所有题解均不一样，请联系管理员添加题解。

## 题目描述

输入两个整数 $a, b$，输出它们的和（$|a|,|b| \\le {10}^9$）。

注意

1. Pascal 使用 `integer` 会爆掉哦！
2. 有负数哦！
3. C/C++ 的 main 函数必须是 `int` 类型，而且 C 最后要 `return 0`。这不仅对洛谷其他题目有效，而且也是 NOIP/CSP/NOI 比赛的要求！

好吧，同志们，我们就从这一题开始，向着大牛的路进发。

> 任何一个伟大的思想，都有一个微不足道的开始。

## 输入格式

两个以空格分开的整数。

## 输出格式

一个整数。

## 输入输出样例 #1

### 输入 #1

```
20 30
```

### 输出 #1

```
50
```
', 
    'Easy', 
    '1s / 128MB',
    0,
    0,
    N'模拟'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'小鸟的设备', 
    '
## 题目背景

小鸟有 $n$ 个可同时使用的设备。

## 题目描述

第 $i$ 个设备每秒消耗 $a_i$ 个单位能量。能量的使用是连续的，也就是说能量不是某时刻突然消耗的，而是匀速消耗。也就是说，对于任意实数，在 $k$ 秒内消耗的能量均为 $k\\times a_i$ 单位。在开始的时候第 $i$ 个设备里存储着 $b_i$ 个单位能量。

同时小鸟又有一个可以给任意一个设备充电的充电宝，每秒可以给接通的设备充能 $p$ 个单位，充能也是连续的，不再赘述。你可以在任意时间给任意一个设备充能，从一个设备切换到另一个设备的时间忽略不计。

小鸟想把这些设备一起使用，直到其中有设备能量降为  $0$。所以小鸟想知道，在充电器的作用下，她最多能将这些设备一起使用多久。

## 输入格式

第一行给出两个整数 $n,p$。

接下来 $n$ 行，每行表示一个设备，给出两个整数，分别是这个设备的 $a_i$ 和 $b_i$。

## 输出格式

如果小鸟可以无限使用这些设备，输出 $-1$。

否则输出小鸟在其中一个设备能量降为 $0$ 之前最多能使用多久。

设你的答案为 $a$，标准答案为 $b$，只有当 $a,b$ 满足 
$\\dfrac{|a-b|}{\\max(1,b)} \\leq 10^{-4}$ 的时候，你能得到本测试点的满分。

## 输入输出样例 #1

### 输入 #1

```
2 1
2 2
2 1000
```

### 输出 #1

```
2.0000000000
```

## 输入输出样例 #2

### 输入 #2

```
1 100
1 1
```

### 输出 #2

```
-1
```

## 输入输出样例 #3

### 输入 #3

```
3 5
4 3
5 2
6 1
```

### 输出 #3

```
0.5000000000
```

## 说明/提示

对于 $100\\%$ 的数据，$1\\leq n\\leq 100000$，$1\\leq p\\leq 100000$，$1\\leq a_i,b_i\\leq100000$。', 
    'Medium', 
    '1s / 128MB',
    0,
    0,
    N'贪心,二分'
);

DROP TABLE IF EXISTS submissions;
CREATE TABLE submissions (
    submission_id VARCHAR(36) PRIMARY KEY COMMENT 'UUID格式的提交ID',
    user_id INT NOT NULL COMMENT '关联用户表的用户ID',
    problem_id INT NOT NULL COMMENT '关联题目表的题目ID',
    submission_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    status_ ENUM('IC', 'AC', 'WA', 'RE', 'TLE', 'MLE', 'CE', 'in_queue') 
        NOT NULL DEFAULT 'IC' COMMENT '判题状态：IC=错误 in_queue=在队列中',
    test_cases TEXT NOT NULL COMMENT '存储各测试点状态的JSON数组，格式为：[{"case_id": 1, "status": "AC"}, ...]',
    code_ TEXT NOT NULL COMMENT '提交的源代码',
    language_ ENUM('C++', 'Python') NOT NULL COMMENT '编程语言类型',
    comp_id INT NOT NULL COMMENT '比赛ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代码提交记录表';



DROP TABLE IF EXISTS test_case;
CREATE TABLE test_case (
    test_case_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增测试用例ID',
    problem_id INT NOT NULL COMMENT '关联的题目ID',
    input_data TEXT NOT NULL COMMENT '测试用例输入数据',
    output_data TEXT NOT NULL COMMENT '测试用例期望输出数据',
    FOREIGN KEY (problem_id) REFERENCES problem(id) ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS test_case_mapping;
CREATE TABLE test_case_mapping(
    problem_id INT NOT NULL,
    test_case_mapping INT AUTO_INCREMENT PRIMARY KEY,
    in_problem_case_id INT NOT NULL,
    test_case_id INT NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 为问题1（Hello,World!）插入测试用例 
INSERT INTO test_case (problem_id, input_data, output_data)
VALUES (1, '', 'Hello,World!');
INSERT INTO test_case_mapping(problem_id,in_problem_case_id,test_case_id)
VALUES (1,1,1);
 
-- 为问题2（输出字符菱形）插入测试用例 
INSERT INTO test_case (problem_id, input_data, output_data)
VALUES (2, '', 
'*
 *** 
*****
 *** 
  *');
INSERT INTO test_case_mapping(problem_id,in_problem_case_id,test_case_id)
VALUES (2,1,2);
 
-- 为问题3（超级玛丽游戏）插入测试用例 
INSERT INTO test_case (problem_id, input_data, output_data)
VALUES (3, '', 
'                ******** 
               ************ 
               ####....#.
             #..###.....##....
             ###.......######              ###            ### 
                ...........               #...#          #...#
               ##*#######                 #.#.#          #.#.# 
            ####*******######             #.#.#          #.#.# 
           ...#***.****.*###....          #...#          #...#
           ....**********##.....           ###            ### 
           ....****    *****....
             ####        #### 
           ######        ###### 
############################################################## 
#...#......#.##...#......#.##...#......#.##------------------#
###########################################------------------#
#..#....#....##..#....#....##..#....#....##################### 
##########################################    #----------#
#.....#......##.....#......##.....#......#    #----------#
##########################################    #----------#
#.#..#....#..##.#..#....#..##.#..#....#..#    #----------#
##########################################    ############');
INSERT INTO test_case_mapping(problem_id,in_problem_case_id,test_case_id)
VALUES (3,1,3);
 
-- 为问题4（A+B Problem）插入测试用例 
INSERT INTO test_case (problem_id, input_data, output_data)
VALUES (4, '20 30', '50');
INSERT INTO test_case (problem_id, input_data, output_data)
VALUES (4, '30 40', '70');
INSERT INTO test_case_mapping(problem_id,in_problem_case_id,test_case_id)
VALUES (4,1,4);
INSERT INTO test_case_mapping(problem_id,in_problem_case_id,test_case_id)
VALUES (4,2,5);

-- 为问题5（小鸟的设备）插入测试用例 
INSERT INTO test_case (problem_id, input_data, output_data)
VALUES (5, 
'2 1 
2 2 
2 1000', 
'2.0000000000');
INSERT INTO test_case_mapping(problem_id,in_problem_case_id,test_case_id)
VALUES (5,1,6);
 
-- 删除比赛-题目关联表
DROP TABLE IF EXISTS category_problems;

-- 删除比赛表
DROP TABLE IF EXISTS categories;
-- 题单表
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 题单-题目关联表
CREATE TABLE IF NOT EXISTS category_problems (
    category_id INT NOT NULL,
    problem_id INT NOT NULL,
    PRIMARY KEY (category_id, problem_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (problem_id) REFERENCES problem(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 插入基础题单
INSERT INTO categories (category_name) VALUES
(N'入门题库'),
(N'算法基础'),
(N'周赛精选');

-- 插入带自动生成ID的题单
INSERT INTO categories (category_name) VALUES (N'新手必做');
SET @new_category_id = LAST_INSERT_ID();  -- 获取新插入题单的ID

-- 假设已存在题目ID（根据你的problem表插入语句）
SET @hello_world_id = 1;  -- Hello,World! 的ID
SET @diamond_id = 2;      -- 输出字符菱形的ID

-- 关联题目到题单
INSERT INTO category_problems (category_id, problem_id) VALUES
(1, @hello_world_id),    -- 入门题库关联HelloWorld
(1, @diamond_id),        -- 入门题库关联菱形题
(@new_category_id, 1),   -- 新手必做关联HelloWorld
(@new_category_id, 2);   -- 新手必做关联菱形题


-- 删除比赛-题目关联表
DROP TABLE IF EXISTS competition_problems;

-- 删除比赛表
DROP TABLE IF EXISTS competitions;
-- 比赛表
CREATE TABLE IF NOT EXISTS competitions (
    competition_id INT PRIMARY KEY,  -- 移除 AUTO_INCREMENT，允许手动插入 ID
    competition_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 比赛-题目关联表
CREATE TABLE IF NOT EXISTS competition_problems (
    competition_id INT NOT NULL,
    problem_id INT NOT NULL,
    PRIMARY KEY (competition_id, problem_id),
    FOREIGN KEY (competition_id) REFERENCES competitions(competition_id),
    FOREIGN KEY (problem_id) REFERENCES problem(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入比赛数据（手动指定 competition_id）
INSERT INTO competitions (competition_id, competition_name, start_time, end_time)
VALUES
(1, '春季编程挑战赛', '2024-02-01 09:00:00', '2025-04-07 23:59:00'),
(2, '秋季算法竞赛', '2025-03-15 10:00:00', '2025-09-21 23:59:00'),
(3, '夏季编程马拉松', '2022-06-01 08:00:00', '2026-06-05 18:00:00'),
(4, '冬季数据结构竞赛', '2026-12-10 14:00:00', '2026-12-15 23:59:00');

-- 插入比赛–题目关联数据
INSERT INTO competition_problems (competition_id, problem_id)
VALUES
(1, 1), (1, 2), (1, 3),  -- 春季编程挑战赛的题目1,2,3
(2, 2), (2, 4), (2, 5),  -- 秋季算法竞赛的题目2,4,5
(3, 1), (3, 5),          -- 夏季编程马拉松的题目1,5
(4, 3), (4, 4);          -- 冬季数据结构竞赛的题目3,4

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'最小总代价调整圈形顺序', 
    '
## 题目描述

佳佳刚进高中，在军训的时候，由于佳佳吃苦耐劳，很快得到了教官的赏识，成为了“小教官”。在军训结束的那天晚上，佳佳被命令组织同学们进行篝火晚会。

一共有 $n$ 个同学，编号从 $1$ 到 $n$。一开始，同学们按照 $1, 2, \dots, n$ 的顺序坐成一圈，而实际上每个人都有两个最希望相邻的同学。

如何下命令调整同学的次序，形成新的一个圈，使之符合同学们的意愿，成为摆在佳佳面前的一大难题。

佳佳可向同学们下达命令，每一个命令的形式如下：

(b₁, b₂, ...)

这里 $m$ 的值是由佳佳决定的，每次命令 $m$ 的值都可以不同。这个命令的作用是移动编号是 $b₁, b₂, ..., bₘ$ 的这 $m$ 个同学的位置。

要求 $b₁$ 换到 $b₂$ 的位置，$b₂$ 换到 $b₃$ 的位置，...，$bₘ$ 换到 $b₁$ 的位置。

执行每个命令的代价是 $m$，我们需要佳佳用**最少的总代价**实现同学们的愿望。

你能帮助佳佳吗？

## 输入格式

第一行是一个整数 $n$，表示一共有 $n$ 个同学。

接下来 $n$ 行，每行两个不同的正整数，表示每个同学最希望相邻的两个同学。

## 输出格式

一个整数，为最小的总代价。如果无法实现目标，输出 -1。

## 输入输出样例 #1

### 输入 #1

4 3 4 4 3 1 2 1 2

### 输出

2

- 对于 $30\\%$ 的数据，满足 $n \\leq 1000$；
- 对于 $100\\%$ 的数据，满足 $3 \\leq n \\leq 50000$。
',
    'Medium',
    '1s / 128MB',
    0,
    0,
    N'图论,模拟,最小代价'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'等腰直角三角形总面积', 
    '
## 题目描述

给出平面上的 $n$ 个等腰直角三角形。每个三角形用三个整数 $x, y, m$ 描述。一个三角形的三个顶点分别是 $(x, y), (x+m, y), (x, y+m)$。

你的任务是计算这些三角形覆盖的**总面积**（注意：重叠部分只计算一次）。

## 输入格式

第一行一个整数 $n$，表示三角形个数。

接下来 $n$ 行，每行三个整数 $x_i, y_i, m_i$，描述一个等腰直角三角形。

## 输出格式

输出一个实数，**保留一位小数**，表示这些三角形覆盖的总面积（去重后的面积）。

## 输入输出样例 #1

### 输入

5 
-5 -3 6 
-1 -2 3 
0 0 2 
-2 2 1 
-4 -1 2

### 输出

24.5

## 说明/提示

- 所有三角形为边长为 $m$ 的直角等腰三角形；
- 顶点固定为 $(x, y), (x+m, y), (x, y+m)$；
- 三角形可能部分或完全重叠，重叠区域只算一次面积。

### 数据范围

- $1 \\leq n \\leq 2000$；
- $-10^7 \\leq x_i, y_i \\leq 10^7$；
- $1 \\leq m_i \\leq 1000$。
', 
    'Hard', 
    '1s / 128MB',
    0,
    0,
    N'计算几何,面积并,扫描线'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'合法字符串计数', 
    '

## 题目描述

定义一个字符串合法，当且仅当该字符串只由 `A` 和 `B` 构成，且**没有连续的三个 `A`**。

P 哥知道，密码是长度为 $N$ 的合法字符串的数量对 $19260817$ 取模的结果。但是他不会算，所以他只能把 $N$ 告诉你，请你来计算答案。

P 哥一共想试 $M$ 组数据。

## 输入格式

第一行一个整数 $M$，表示询问次数。

接下来 $M$ 行，每行一个正整数 $N$，表示该组询问中的字符串长度。

## 输出格式

对于每一组询问，输出一行一个整数，表示合法字符串数量对 $19260817$ 取模的结果。

## 输入输出样例 #1

### 输入

3 1 3 6

### 输出

2 7 44

## 说明/提示

合法字符串的定义如下：

- 仅由 `A` 和 `B` 构成；
- 不允许连续出现 `AAA`。

### 数据范围

- 对于 $20\\%$ 的数据，$N \\leq 20$，$M \\leq 2$；
- 对于 $70\\%$ 的数据，$N \\leq 10^7$；
- 对于 $100\\%$ 的数据，$1 \\leq N \\leq 10^9$，$1 \\leq M \\leq 10$。

- 输出均对 $19260817$ 取模。
', 
    'Medium', 
    '1s / 128MB',
    0,
    0,
    N'动态规划,矩阵快速幂,数列'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'广义斐波那契数列取模', 
    '
## 题目描述

广义的斐波那契数列是指形如：

$$
a_n = p \\times a_{n-1} + q \\times a_{n-2}
$$

的数列。

现给定数列的两个系数 $p$ 和 $q$，以及数列的前两项 $a_1$ 和 $a_2$，另给出两个整数 $n$ 和 $m$，请你求出数列的第 $n$ 项 $a_n$ 对 $m$ 取模的结果。

## 输入格式

输入包含一行六个整数：$p, q, a_1, a_2, n, m$

## 输出格式

输出一个整数，表示 $a_n \\bmod m$

## 输入输出样例 #1

### 输入

1 1 1 1 10 7

### 输出

6

## 说明/提示

该数列即为标准的斐波那契数列：

$$
a_1 = 1,\\ a_2 = 1,\\ a_3 = 2,\\ a_4 = 3,\\ a_5 = 5,\\ a_6 = 8,\\ \dots
$$

第 $10$ 项为 $55$，$55 \\bmod 7 = 6$

---

### 数据范围

- $0 \\leq p, q, a_1, a_2 \\leq 2^{31}-1$
- $1 \\leq n, m \\leq 2^{31}-1$
', 
    'Hard', 
    '1s / 128MB',
    0,
    0,
    N'数学,快速幂,矩阵快速幂,线性递推'
);
INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'最大边界点矩形', 
    '
## 题目描述

在二维平面上给出 $n$ 个点。请你找出一个**边与坐标轴平行的矩形**，使得其**边界上包含的点数尽可能多**。

矩形必须由原输入中的点决定，即选定矩形时，所有判断均以给出的 $n$ 个点为依据。

## 输入格式

第一行一个整数 $n$，表示平面上的点的数量。

接下来 $n$ 行，每行两个整数，分别表示每个点的横坐标和纵坐标。

## 输出格式

一个整数，表示某个边与坐标轴平行的矩形的边界上，**最多可以包含多少个点**。

## 输入输出样例 #1

### 输入


10 
2 3 
9 2 
7 4 
3 4 
5 7 
1 5 
10 4 
10 6 
11 4 
4 6

### 输出

7

### 数据范围与约定

- 对于 $40\\%$ 的数据，$1 \\leq n \\leq 30$；
- 对于 $100\\%$ 的数据，$1 \\leq n \\leq 300$；
- 所有点的横、纵坐标范围为 $[1, 100]$；
- 不存在重复的点。
', 
    'Medium', 
    '1s / 128MB',
    0,
    0,
    N'枚举,计算几何,坐标系'
);

INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'不下降子序列得分计算', 
    '
## 题目描述

有一群大朋友（年龄 $\\geq 15$），他们每人手里拿着一个数字，这个数字是一个 $0$ 到 $9$ 的一位数。

对于每个大朋友，我们定义他的“得分”为：**以他结尾的最长不下降子序列中所有数字之和**。

> 注意：子序列必须**以当前大朋友为结尾**，并且是**不下降的子序列**。

如果存在多个长度相同的不下降子序列，则选择**编号字典序最小的那个**（即选择最靠前的那个）。

请你计算每个人的得分。

## 输入格式

第一行一个整数 $n$，表示大朋友人数。

第二行 $n$ 个整数，表示每个人手上的数字（范围 $[0, 9]$）。

## 输出格式

输出一行 $n$ 个整数，表示每个人的得分。

## 输入输出样例 #1

### 输入

5
1 2 5 3 4

### 输出
1 3 8 6 10

## 说明/提示

以编号为 5 的人为例（数字为 4），最长不下降子序列可以是：

- 1 2 3 4，总和为 10（以他结尾）；

其他人也类似进行 DP 转移即可。

### 数据范围

- 对于 $50\\%$ 的数据，$1 \\leq n \\leq 500$；
- 对于 $80\\%$ 的数据，$1 \\leq n \\leq 10^3$；
- 对于 $100\\%$ 的数据，$1 \\leq n \\leq 10^4$；
- 所有数字均在 $[0, 9]$ 范围内。
', 
    'Easy', 
    '1s / 128MB',
    0,
    0,
    N'动态规划,序列,最长不下降子序列,LNDS'
);