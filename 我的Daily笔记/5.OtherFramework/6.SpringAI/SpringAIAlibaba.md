> 从本质上讲，Spring AI 解决了 AI 集成的基本挑战：Connecting your enterprise Data and APIs with the AI Models。

# Spring AI Alibaba

[核心概念-阿里云Spring AI Alibaba官网官网](https://java2ai.com/docs/1.0.0-M6.1/concepts/?spm=0.29160081.0.0.2b8047adVO9V2p)

[Vector Databases :: Spring AI Reference](https://docs.spring.io/spring-ai/reference/api/vectordbs.html)

## 核心概念

### Agent 智能体

[Building Effective AI Agents \ Anthropic](https://www.anthropic.com/engineering/building-effective-agents?spm=5176.29160081.0.0.2856aa5cEVdmm7)

### Model 模型

AI 模型是旨在处理和生成信息的算法，通常模仿人类的认知功能。通过从大型数据集中学习模式和见解，这些模型可以做出预测、文本、图像或其他输出，从而增强各个行业的各种应用。

AI 模型有很多种，每种都适用于特定的用例。虽然 ChatGPT 及其生成 AI 功能通过文本输入和输出吸引了用户，但许多模型和公司都提供不同的输入和输出。在 ChatGPT 之前，许多人都对文本到图像的生成模型着迷，例如 Midjourney 和 Stable Diffusion。

![image-20250605103952429](.\assets\image-20250605103952429.png)

Spring AI 目前支持以语言、图像和音频形式处理输入和输出的模型。上表中的最后一行接受文本作为输入并输出数字，通常称为嵌入文本（Embedding Text），用来表示 AI 模型中使用的内部数据结构。Spring AI 提供了对 Embedding 的支持以支持开发更高级的应用场景。

GPT 等模型的独特之处在于其预训练特性，正如 GPT 中的“P”所示——Chat Generative Pre-trained Transformer。这种预训练功能将 AI 转变为通用的开发工具，开发者使用这种工具不再需要广泛的机器学习或模型训练背景。

### Prompt 提示

Prompt作为语言基础输入的基础，指导AI模型生成特定的输出。对于熟悉ChatGPT的人来说，Prompt似乎只是输入到对话框中的文本，然后发送到API。然而，它的内涵远不止于此。在许多AI模型中，Prompt的文本不仅仅是一个简单的字符串。

ChatGPT的API包含多个文本输入，每个文本输入都有其角色。例如，系统角色用于告知模型如何行为并设定交互的背景。还有用户角色，通常是来自用户的输入。

撰写有效的Prompt既是一门艺术，也是一门科学。ChatGPT旨在模拟人类对话，这与使用SQL“提问”有很大的区别。与AI模型的交流就像与另外一个人对话一样。

这种互动风格的重要性使得“Prompt工程”这一学科应运而生。现在有越来越多的技术被提出，以提高Prompt的有效性。投入时间去精心设计Prompt可以显著改善生成的输出。

分享Prompt已成为一种共同的实践，且正在进行积极的学术研究。例如，最近的一篇研究论文发现，最有效的Prompt之一可以以“深呼吸一下，分步进行此任务”开头。这表明语言的重要性之高。我们尚未完全了解如何充分利用这一技术的前几代版本，例如ChatGPT 3.5，更不用说正在开发的新版本了。

### Prompt Template 提示词模板

创建有效的Prompt涉及建立请求的上下文，并用用户输入的特定值替换请求的部分内容。这个过程使用传统的基于文本的模板引擎来进行Prompt的创建和管理。Spring AI采用开源库StringTemplate来实现这一目的。

例如，考虑以下简单的Prompt模板：

```java
Tell me a {adjective} joke about {content}.
```

在Spring AI中，Prompt模板可以类比于Spring MVC架构中的“视图”。一个模型对象，通常是java.util.Map，提供给Template，以填充模板中的占位符。渲染后的字符串成为传递给AI模型的Prompt的内容。

传递给模型的Prompt在具体数据格式上有相当大的变化。从最初的简单字符串开始，Prompt逐渐演变为包含多条消息的格式，其中每条消息中的每个字符串代表模型的不同角色。

### Embeding 嵌入

嵌入（Embedding）是文本、图像或视频的数值表示，能够捕捉输入之间的关系，Embedding通过将文本、图像和视频转换为称为向量（Vector）的浮点数数组来工作。这些向量旨在捕捉文本、图像和视频的含义，Embedding数组的长度称为向量的维度。

通过计算两个文本片段的向量表示之间的数值距离，应用程序可以确定用于生成嵌入向量的对象之间的相似性。

![image-20250605104213253](.\assets\image-20250605104213253.png)

作为一名探索人工智能的Java开发者，理解这些向量表示背后的复杂数学理论或具体实现并不是必需的。对它们在人工智能系统中的作用和功能有基本的了解就足够了，尤其是在将人工智能功能集成到您的应用程序中时。

Embedding在实际应用中，特别是在检索增强生成（RAG）模式中，具有重要意义。它们使数据能够在语义空间中表示为点，这类似于欧几里得几何的二维空间，但在更高的维度中。这意味着，就像欧几里得几何中平面上的点可以根据其坐标的远近关系而接近或远离一样，在语义空间中，点的接近程度反映了意义的相似性。关于相似主题的句子在这个多维空间中的位置较近，就像图表上彼此靠近的点。这种接近性有助于文本分类、语义搜索，甚至产品推荐等任务，因为它允许人工智能根据这些点在扩展的语义空间中的“位置”来辨别和分组相关概念。

您可以将这个语义空间视为一个向量。

### Token

token是 AI 模型工作原理的基石。输入时，模型将单词转换为token。输出时，它们将token转换回单词。

在英语中，一个token大约对应一个单词的 75%。作为参考，莎士比亚的全集总共约 90 万个单词，翻译过来大约有 120 万个token。

![image-20250605104301110](.\assets\image-20250605104301110.png)

也许更重要的是 “token = 金钱”。在托管 AI 模型的背景下，您的费用由使用的token数量决定。输入和输出都会影响总token数量。

此外，模型还受到 token 限制，这会限制单个 API 调用中处理的文本量。此阈值通常称为“上下文窗口”。模型不会处理超出此限制的任何文本。

例如，ChatGPT3 的token限制为 4K，而 GPT4 则提供不同的选项，例如 8K、16K 和 32K。Anthropic 的 Claude AI 模型的token限制为 100K，而 Meta 的最新研究则产生了 1M token限制模型。

要使用 GPT4 总结莎士比亚全集，您需要制定软件工程策略来切分数据并在模型的上下文窗口限制内呈现数据。Spring AI 项目可以帮助您完成此任务。

### Structured Output 结构化输出

即使您要求回复为 JSON ，AI 模型的输出通常也会以 `java.lang.String` 的形式出现。它可能是正确的 JSON，但它可能并不是你想要的 JSON 数据结构，它只是一个字符串。此外，在提示词 Prompt 中要求 “返回JSON” 并非 100% 准确。

这种复杂性导致了一个专门领域的出现，涉及创建 Prompt 以产生预期的输出，然后将生成的简单字符串转换为可用于应用程序集成的数据结构。
![image-20250605104411649](.\assets\image-20250605104411649.png)

[结构化输出转换](https://java2ai.com/docs/dev/tutorials/basics/tutorials/structured-output/)采用精心设计的提示，通常需要与模型进行多次交互才能实现所需的格式