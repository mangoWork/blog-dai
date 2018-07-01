在输入数学公式的时候，需要在数学公式的前后加入

## 上下标 {#上下标}

* 上标 ^
* 下标 \_

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 上标 | $$ a^b $$ | $a^b$ |
| 下标 | $$ a_b $$ | $a\_b$ |

## 分数 {#分数}

* \frac{ }{ }
* 第一个{ }写分子，第二个{ }写分母。

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 分数 | $$ \frac{3+8a}{5b+6} $$ | $\frac{3+8a}{5b+6}$ |

## 累加 {#累加}

* \sum\_{ }^{ }
* 累加号的上标下标的前后顺序可以互换。

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 求和号 | $$ \sum{3x^n} $$ | $\sum{3x^n}$ |
| 带范围求和 | $$ \sum_{n=1}^N{3x^n} $$ | $\sum\_{n=1}^N{3x^n}$ |

## 累乘 {#累乘}

* \prod\_{ }^{ }
* 累加号的上标下标的前后顺序可以互换。

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 求和号 | $$ \prod{3x^n} $$ | $\prod{3x^n}$ |
| 带范围求乘 | $$ \prod_{n=1}^N{3x^n} $$ | $\prod\_{n=1}^N{3x^n}$ |

## 开方 {#开方}

* \sqrt\[ \]{ }
* \[ \]中写的是开几次方，{ }中写的是需要开方的数值。

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 开方号 | $$ \sqrt[5]{100} $$ | $\sqrt\[5\]{100}$ |

## 积分 {#积分}

* \int\_{ }^{ }

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 积分 | $$ \int^5_1{f(x)}{rm d}x $$ | $\int^5\_1{f\(x\)}{\rm d}x$ |
| 二重积分 | $$ \iint^5_1{f(x)}{rm d}x $$ | $\iint^5\_1{f\(x\)}{\rm d}x$ |
| 三重积分 | $$ \iiint^5_1{f(x)}{rm d}x $$ | $\iiint^5\_1{f\(x\)}{\rm d}x$ |

## 正无穷、负无穷 {#正无穷负无穷}

* \infty

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 正无穷 | $$ +\infty $$ | $+\infty$ |
| 负无穷 | $$ -\infty $$ | $-\infty$ |

## 极限 {#极限}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 左箭头 | $$ \lim_{n\rightarrow+\infty} n$$ | $\lim\_{n\rightarrow+\infty} n$ |

## 关系运算符 {#关系运算符}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 大于等于 | $$ \geq$$ | $\geq$ |
| 小于等于 | $$ \leq$$ | $\leq$ |
| 包含于 | $$ \subset$$ | $\subset$ |
| 包含 | $$ \supset$$ | $\supset$ |
| 属于 | $$ \in$$ | $\in$ |

## 二元运算符 {#二元运算符}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 加减 | $$ \pm$$ | $\pm$ |
| 点乘 | $$ \cdot$$ | $\cdot$ |
| 乘 | $$ \times$$ | $\times$ |
| 除 | $$ \div$$ | $\div$ |

## 否定关系运算符 {#否定关系运算符}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 不等于 | $$\ne$$ | $\ne$ |
| 不小于 | $$ \nless $$ | $\nless$ |
| 不包含 | $$ \varsubsetneqq $$ | $\varsubsetneqq$ |

## 对数运算符 {#对数运算符}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 对数 | $$ \log $$ | $\log$ |
| 对数 | $$ \log_2{18} $$ | $\log\_2{18}$ |
| 对数 | $$ \ln $$ | $\ln$ |

## 三角运算符 {#三角运算符}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 垂直 | $$ \bot $$ | $\bot$ |
| 角 | $$ \angle $$ | $\angle$ |
| 30度角 | $$ 30^\circ $$ | $30^\circ$ |
| 正弦 | $$ \sin $$ | $\sin$ |
| 余弦 | $$ \cos $$ | $\cos$ |
| 正切 | $$ \tan $$ | $\tan$ |

## 箭头 {#箭头}

| 名称 | 数学表达式 | markdown公式 |
| :--- | :--- | :--- |
| 左箭头 | $$ \leftarrow $$ | $\leftarrow$ |
| 右箭头 | $$ \rightarrow $$ | $\rightarrow$ |
| 长箭头 | $$ \longrightarrow $$ | $\longrightarrow$ |
| 上箭头 | $$ \uparrow $$ | $\uparrow$ |
| 下箭头 | $$ \downarrow $$ | $\downarrow$ |


## 总结

|符号	|代码|	描述|
|-|-|-|
|∑|	$\sum$|	求和公式|
|∑ni=0|	$\sum_{i=0}^n$	|求和上下标|
|y={xα | $y =\begin{cases} x\\ \alpha	\end{cases}$|	大括号|
|×	|$\times$|	乘号|
|±|	$\pm$	|正负号|
|÷|	$\div$	|除号|
|∣|	$\mid$	|竖线|
|⋅|	$\cdot$	|点|
|∘|	$\circ$|	圈|
|∗|	$\ast $|	星号|
|⨂|	$\bigotimes$	|克罗内克积|
|⨁|	$\bigoplus$	|异或|
|≤|	$\leq$	|小于等于|
|≥|	$\geq$	|大于等于|
|≠|	$\neq$|	不等于|
|≈|	$\approx$	|约等于|
|∏	|$\prod$|	N元乘积|
|∐	|$\coprod$	|N元余积|
|⋯	|$\cdots$	|省略号|
|∫	|$\int$	|积分|
|∬	|$\iint$|	双重积分|
|∮|	$\oint$|	曲线积分
|∞	|$\infty$	|无穷|
|∇	|$\nabla$	|梯度
|∵	|$\because$	|因为
|∴	|$\therefore$|	所以|
|∀	|$\forall$|	任意|
|∃	|$\exists$|	存在|
|≠	|$\not=$	|不等于|
|≯	|$\not>$|	不大于|
|≤|	$\leq$|	小于等于|
|≥|	$\geq$|	大于等于|
|⊄   |	$\not\subset$|	不属于|
|∅|	$\emptyset$|	空集|
|∈|	$\in$|	属于|
|∉|	$\notin$	|不属于|
|⊂|	$\subset$|	子集|
|⊆|	$\subseteq$|	真子集|
|⋃|	$\bigcup$|	并集|
|⋂|	$\bigcap$|	交集|
|⋁|	$\bigvee$|	逻辑或|
|⋀|	$\bigwedge$|	逻辑与|
|⨄|	$\biguplus$|	多重集|
|⨆|	$\bigsqcup$	|
|y^|	$\hat{y}$|	期望值|
|yˇ|	$\check{y}$	
|y˘|	$\breve{y}$|	
|$$ \overline{a+b+c+d}$$|	$\overline{a+b+c+d}$|	平均值|
|$$ \underline{a+b+c+d}$$ |$\underline{a+b+c+d}$	|
|↑|	$\uparrow$	|向上|
|↓|	$\downarrow$	|向下|
|⇑|	$\Uparrow$	|
|⇓|	$\Downarrow$	|
|→|	$\rightarrow$	|向右|
|←|	$\leftarrow$	|向左|
|⇒|	$\Rightarrow$	|向右箭头|
|⟸|	$\Longleftarrow$	|向左长箭头|
|⟵|	$\longleftarrow$	|向左单箭头|
|⟶|	$\longrightarrow$|	向右长箭头|
|⟹|	$\Longrightarrow$|	向右箭头|
|α|	$\alpha$	|
|β|	$\beta$	|
|γ|	$\gamma$|	
|Γ|	$\Gamma$|	
|δ|	$\delta$|	
|Δ|	$\Delta$|	
|ϵ|	$\epsilon$	|
|ε|	$\varepsilon$	|
|ζ|	$\zeta$	|
|η|	$\eta$	|
|θ|	$\theta$	|
|Θ|	$\Theta$|
|ϑ|	$\vartheta$	|
|ι|	$\iota$	|
|π|	$\pi$	|
|ϕ|	$\phi$	|
|ψ|	$\psi$	|
|Ψ|	$\Psi$	|
|ω|	$\omega$	|
|Ω|	$\Omega$|
|χ|	\chi	|
|ρ|	$\rho$	|
|ο|	$\omicron$	|
|σ|	$\sigma$	|
|Σ|	$\Sigma$	|
|ν|	$\nu$	|
|ξ|	$\xi$	|
|τ|	$\tau$	|
|λ|	$\lambda$	|
|Λ|	$\Lambda$	|
|μ|	\mu	|
|∂|	$\partial$	|


