CREATE DATABASE IF NOT EXISTS onlinejudge;

USE onlinejudge;

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
    passworduser
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
    N'完全背包问题', 
    N'有 N
 种物品和一个容量是 V
 的背包，每种物品都有无限件可用。

第 i
 种物品的体积是 vi
，价值是 wi
。

求解将哪些物品装入背包，可使这些物品的总体积不超过背包容量，且总价值最大。
输出最大价值。

输入格式
第一行两个整数，N，V
，用空格隔开，分别表示物品种数和背包容积。

接下来有 N
 行，每行两个整数 vi,wi
，用空格隔开，分别表示第 i
 种物品的体积和价值。

输出格式
输出一个整数，表示最大价值。

数据范围
0<N,V≤1000

0<vi,wi≤1000
输入样例
4 5
1 2
2 4
3 4
4 5
输出样例：
10', 
    'Easy', 
    '1s / 64MB',
    0,
    0,
    N'背包九讲,模板题'
);


USE onlinejudge;
INSERT INTO problem (
    title, 
    description, 
    difficulty, 
    time_memory_limit,
    total_accepted,
    total_attempted,
    algorithm_tags
) VALUES (
    N'01背包问题', 
    N'<div class="ui bottom attached tab active martor-preview" data-tab="preview-tab-content">
                        <p>有 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-1-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>N</mi></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-1" role="math" style="width: 1.096em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0.888em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.305em, 1000.89em, 2.294em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-2"><span class="mi" id="MathJax-Span-3" style="font-family: MathJax_Math-italic;">N<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.107em;"></span></span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.059em; border-left: 0px solid; width: 0px; height: 0.941em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>N</mi></math></span></span><script type="math/tex" id="MathJax-Element-1">N</script> 件物品和一个容量是 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-2-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>V</mi></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-4" role="math" style="width: 0.94em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0.784em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.305em, 1000.78em, 2.294em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-5"><span class="mi" id="MathJax-Span-6" style="font-family: MathJax_Math-italic;">V<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.211em;"></span></span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.059em; border-left: 0px solid; width: 0px; height: 1.003em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>V</mi></math></span></span><script type="math/tex" id="MathJax-Element-2">V</script> 的背包。每件物品只能使用一次。</p>
<p>第 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-3-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>i</mi></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-7" role="math" style="width: 0.471em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0.367em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.305em, 1000.32em, 2.294em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-8"><span class="mi" id="MathJax-Span-9" style="font-family: MathJax_Math-italic;">i</span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.059em; border-left: 0px solid; width: 0px; height: 0.941em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>i</mi></math></span></span><script type="math/tex" id="MathJax-Element-3">i</script> 件物品的体积是 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-4-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><msub><mi>v</mi><mi>i</mi></msub></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-10" role="math" style="width: 0.94em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0.784em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.513em, 1000.78em, 2.451em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-11"><span class="msubsup" id="MathJax-Span-12"><span style="display: inline-block; position: relative; width: 0.784em; height: 0px;"><span style="position: absolute; clip: rect(3.388em, 1000.47em, 4.169em, -999.997em); top: -4.008em; left: 0.003em;"><span class="mi" id="MathJax-Span-13" style="font-family: MathJax_Math-italic;">v</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span><span style="position: absolute; top: -3.852em; left: 0.471em;"><span class="mi" id="MathJax-Span-14" style="font-size: 70.7%; font-family: MathJax_Math-italic;">i</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span></span></span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.247em; border-left: 0px solid; width: 0px; height: 0.878em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>v</mi><mi>i</mi></msub></math></span></span><script type="math/tex" id="MathJax-Element-4">v_i</script>，价值是 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-5-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><msub><mi>w</mi><mi>i</mi></msub></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-15" role="math" style="width: 1.253em; display: inline-block;"><span style="display: inline-block; position: relative; width: 1.044em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.513em, 1001.04em, 2.451em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-16"><span class="msubsup" id="MathJax-Span-17"><span style="display: inline-block; position: relative; width: 1.044em; height: 0px;"><span style="position: absolute; clip: rect(3.388em, 1000.68em, 4.169em, -999.997em); top: -4.008em; left: 0.003em;"><span class="mi" id="MathJax-Span-18" style="font-family: MathJax_Math-italic;">w</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span><span style="position: absolute; top: -3.852em; left: 0.732em;"><span class="mi" id="MathJax-Span-19" style="font-size: 70.7%; font-family: MathJax_Math-italic;">i</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span></span></span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.247em; border-left: 0px solid; width: 0px; height: 0.878em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>w</mi><mi>i</mi></msub></math></span></span><script type="math/tex" id="MathJax-Element-5">w_i</script>。</p>
<p>求解将哪些物品装入背包，可使这些物品的总体积不超过背包容量，且总价值最大。<br>
输出最大价值。</p>
<h4>输入格式</h4>
<p>第一行两个整数，<span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-6-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>N</mi><mrow class=&quot;MJX-TeXAtom-ORD&quot;><mo>&amp;#xFF0C;</mo></mrow><mi>V</mi></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-20" role="math" style="width: 3.076em; display: inline-block;"><span style="display: inline-block; position: relative; width: 2.555em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.201em, 1002.55em, 2.503em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-21"><span class="mi" id="MathJax-Span-22" style="font-family: MathJax_Math-italic;">N<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.107em;"></span></span><span class="texatom" id="MathJax-Span-23"><span class="mrow" id="MathJax-Span-24"><span class="mo" id="MathJax-Span-25"><span style="font-family: STIXGeneral, &quot;Arial Unicode MS&quot;, serif; font-size: 83%; font-style: normal; font-weight: normal;">，</span></span></span></span><span class="mi" id="MathJax-Span-26" style="font-family: MathJax_Math-italic;">V<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.211em;"></span></span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.309em; border-left: 0px solid; width: 0px; height: 1.316em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>N</mi><mrow class="MJX-TeXAtom-ORD"><mo>，</mo></mrow><mi>V</mi></math></span></span><script type="math/tex" id="MathJax-Element-6">N，V</script>，用空格隔开，分别表示物品数量和背包容积。</p>
<p>接下来有 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-7-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>N</mi></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-27" role="math" style="width: 1.096em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0.888em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.305em, 1000.89em, 2.294em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-28"><span class="mi" id="MathJax-Span-29" style="font-family: MathJax_Math-italic;">N<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.107em;"></span></span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.059em; border-left: 0px solid; width: 0px; height: 0.941em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>N</mi></math></span></span><script type="math/tex" id="MathJax-Element-7">N</script> 行，每行两个整数 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-8-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><msub><mi>v</mi><mi>i</mi></msub><mo>,</mo><msub><mi>w</mi><mi>i</mi></msub></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-30" role="math" style="width: 2.711em; display: inline-block;"><span style="display: inline-block; position: relative; width: 2.242em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.565em, 1002.24em, 2.555em, -999.997em); top: -2.185em; left: 0.003em;"><span class="mrow" id="MathJax-Span-31"><span class="msubsup" id="MathJax-Span-32"><span style="display: inline-block; position: relative; width: 0.784em; height: 0px;"><span style="position: absolute; clip: rect(3.388em, 1000.47em, 4.169em, -999.997em); top: -4.008em; left: 0.003em;"><span class="mi" id="MathJax-Span-33" style="font-family: MathJax_Math-italic;">v</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span><span style="position: absolute; top: -3.852em; left: 0.471em;"><span class="mi" id="MathJax-Span-34" style="font-size: 70.7%; font-family: MathJax_Math-italic;">i</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span></span></span><span class="mo" id="MathJax-Span-35" style="font-family: MathJax_Main;">,</span><span class="msubsup" id="MathJax-Span-36" style="padding-left: 0.159em;"><span style="display: inline-block; position: relative; width: 1.044em; height: 0px;"><span style="position: absolute; clip: rect(3.388em, 1000.68em, 4.169em, -999.997em); top: -4.008em; left: 0.003em;"><span class="mi" id="MathJax-Span-37" style="font-family: MathJax_Math-italic;">w</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span><span style="position: absolute; top: -3.852em; left: 0.732em;"><span class="mi" id="MathJax-Span-38" style="font-size: 70.7%; font-family: MathJax_Math-italic;">i</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span></span></span></span><span style="display: inline-block; width: 0px; height: 2.19em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.309em; border-left: 0px solid; width: 0px; height: 0.878em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>v</mi><mi>i</mi></msub><mo>,</mo><msub><mi>w</mi><mi>i</mi></msub></math></span></span><script type="math/tex" id="MathJax-Element-8">v_i, w_i</script>，用空格隔开，分别表示第 <span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-9-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>i</mi></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-39" role="math" style="width: 0.471em; display: inline-block;"><span style="display: inline-block; position: relative; width: 0.367em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.305em, 1000.32em, 2.294em, -999.997em); top: -2.133em; left: 0.003em;"><span class="mrow" id="MathJax-Span-40"><span class="mi" id="MathJax-Span-41" style="font-family: MathJax_Math-italic;">i</span></span><span style="display: inline-block; width: 0px; height: 2.138em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.059em; border-left: 0px solid; width: 0px; height: 0.941em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>i</mi></math></span></span><script type="math/tex" id="MathJax-Element-9">i</script> 件物品的体积和价值。</p>
<h4>输出格式</h4>
<p>输出一个整数，表示最大价值。</p>
<h4>数据范围</h4>
<p><span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-10-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mn>0</mn><mo>&amp;#x003C;</mo><mi>N</mi><mo>,</mo><mi>V</mi><mo>&amp;#x2264;</mo><mn>1000</mn></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-42" role="math" style="width: 8.701em; display: inline-block;"><span style="display: inline-block; position: relative; width: 7.242em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.357em, 1007.19em, 2.555em, -999.997em); top: -2.185em; left: 0.003em;"><span class="mrow" id="MathJax-Span-43"><span class="mn" id="MathJax-Span-44" style="font-family: MathJax_Main;">0</span><span class="mo" id="MathJax-Span-45" style="font-family: MathJax_Main; padding-left: 0.263em;">&lt;</span><span class="mi" id="MathJax-Span-46" style="font-family: MathJax_Math-italic; padding-left: 0.263em;">N<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.107em;"></span></span><span class="mo" id="MathJax-Span-47" style="font-family: MathJax_Main;">,</span><span class="mi" id="MathJax-Span-48" style="font-family: MathJax_Math-italic; padding-left: 0.159em;">V<span style="display: inline-block; overflow: hidden; height: 1px; width: 0.211em;"></span></span><span class="mo" id="MathJax-Span-49" style="font-family: MathJax_Main; padding-left: 0.263em;">≤</span><span class="mn" id="MathJax-Span-50" style="font-family: MathJax_Main; padding-left: 0.263em;">1000</span></span><span style="display: inline-block; width: 0px; height: 2.19em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.309em; border-left: 0px solid; width: 0px; height: 1.191em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mn>0</mn><mo>&lt;</mo><mi>N</mi><mo>,</mo><mi>V</mi><mo>≤</mo><mn>1000</mn></math></span></span><script type="math/tex" id="MathJax-Element-10">0 \lt N, V \le 1000</script><br>
<span class="MathJax_Preview" style="color: inherit;"></span><span class="MathJax" id="MathJax-Element-11-Frame" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mn>0</mn><mo>&amp;#x003C;</mo><msub><mi>v</mi><mi>i</mi></msub><mo>,</mo><msub><mi>w</mi><mi>i</mi></msub><mo>&amp;#x2264;</mo><mn>1000</mn></math>" role="presentation" style="position: relative;"><nobr aria-hidden="true"><span class="math" id="MathJax-Span-51" role="math" style="width: 8.909em; display: inline-block;"><span style="display: inline-block; position: relative; width: 7.398em; height: 0px; font-size: 120%;"><span style="position: absolute; clip: rect(1.357em, 1007.35em, 2.555em, -999.997em); top: -2.185em; left: 0.003em;"><span class="mrow" id="MathJax-Span-52"><span class="mn" id="MathJax-Span-53" style="font-family: MathJax_Main;">0</span><span class="mo" id="MathJax-Span-54" style="font-family: MathJax_Main; padding-left: 0.263em;">&lt;</span><span class="msubsup" id="MathJax-Span-55" style="padding-left: 0.263em;"><span style="display: inline-block; position: relative; width: 0.784em; height: 0px;"><span style="position: absolute; clip: rect(3.388em, 1000.47em, 4.169em, -999.997em); top: -4.008em; left: 0.003em;"><span class="mi" id="MathJax-Span-56" style="font-family: MathJax_Math-italic;">v</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span><span style="position: absolute; top: -3.852em; left: 0.471em;"><span class="mi" id="MathJax-Span-57" style="font-size: 70.7%; font-family: MathJax_Math-italic;">i</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span></span></span><span class="mo" id="MathJax-Span-58" style="font-family: MathJax_Main;">,</span><span class="msubsup" id="MathJax-Span-59" style="padding-left: 0.159em;"><span style="display: inline-block; position: relative; width: 1.044em; height: 0px;"><span style="position: absolute; clip: rect(3.388em, 1000.68em, 4.169em, -999.997em); top: -4.008em; left: 0.003em;"><span class="mi" id="MathJax-Span-60" style="font-family: MathJax_Math-italic;">w</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span><span style="position: absolute; top: -3.852em; left: 0.732em;"><span class="mi" id="MathJax-Span-61" style="font-size: 70.7%; font-family: MathJax_Math-italic;">i</span><span style="display: inline-block; width: 0px; height: 4.013em;"></span></span></span></span><span class="mo" id="MathJax-Span-62" style="font-family: MathJax_Main; padding-left: 0.263em;">≤</span><span class="mn" id="MathJax-Span-63" style="font-family: MathJax_Main; padding-left: 0.263em;">1000</span></span><span style="display: inline-block; width: 0px; height: 2.19em;"></span></span></span><span style="display: inline-block; overflow: hidden; vertical-align: -0.309em; border-left: 0px solid; width: 0px; height: 1.191em;"></span></span></nobr><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mn>0</mn><mo>&lt;</mo><msub><mi>v</mi><mi>i</mi></msub><mo>,</mo><msub><mi>w</mi><mi>i</mi></msub><mo>≤</mo><mn>1000</mn></math></span></span><script type="math/tex" id="MathJax-Element-11">0\lt v_i, w_i \le 1000</script></p>
<h4>输入样例</h4>
<pre class="hljs"><code>4 5
1 2
2 4
3 4
4 5
</code></pre>

<h4>输出样例：</h4>
<pre class="hljs"><code>8
</code></pre>
                    </div>', 
    'Easy', 
    '1s / 64MB',
    0,
    0,
    N'背包九讲,模板题'
);