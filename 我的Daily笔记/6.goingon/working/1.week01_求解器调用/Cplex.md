> 学习目标
>
> - 使用Java调用CPLEX等求解器的API
> - CPLEX求解器的特性
> - 线性规划，整数规划的数学建模方法

# Cplex 求解器

## JAVA建模和求解

基本步骤

1. 变量声明
2. 目标函数设置
3. 约束添加
4. 求解

### 引例

求解如下线性规划模型

$\begin{aligned}
& {\text{max}} \quad {x_1 + 2x_2 + 3x_3} \\
& \text{subject to} \\
& \left\{
\begin{aligned}
-x_1 + x_2 + x_3 &\leq 20 \\
x_1 - 3x_2 + x_3 &\leq 30 \\
x_1 &\leq 40 \\
x_1, x_2, x_3 &\geq 0
\end{aligned}
\right.
\end{aligned}$

```java
    public static void testOutput() throws IloException {
        IloCplex cplex = new IloCplex();
        double[] lb = {0.0, 0.0, 0.0};
        double[] ub = {40.0, Double.MAX_VALUE, Double.MAX_VALUE};
        IloNumVar[] x = cplex.numVarArray(3, lb, ub);

        double[] objvals = {1.0, 2.0, 3.0};
        cplex.addMaximize(cplex.scalProd(x, objvals));

        double[] coeff1 = {-1.0, 1.0, 1.0};
        double[] coeff2 = {1.0, -3.0, 1.0};
        cplex.addLe(cplex.scalProd(x, coeff1), 20.0);
        cplex.addLe(cplex.scalProd(x, coeff2), 30.0);

        if (cplex.solve()) {
            cplex.output().println("Solution status: " + cplex.getStatus());
            cplex.output().println("Objective: " + cplex.getObjective());
            cplex.output().println("Solution value: " + cplex.getObjValue());
            double[] val = cplex.getValues(x);
            for (int j = 0; j < val.length; j++) {
                cplex.output().println("x" + (j + 1) + "=" + val[j]);
            }
        }
        cplex.end();
    }
```

### 大数据量问题

