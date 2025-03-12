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

CREATE TABLE IF NOT EXISTS User (
  id INT AUTO_INCREMENT PRIMARY KEY,  -- 自增主键‌:ml-citation{ref="2,3" data="citationList"}
  account VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
);

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
