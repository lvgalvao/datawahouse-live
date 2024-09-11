### **README - Sistema de CRM e Vendas da ZapFlow**

Esse repositório faz parte da aula sobre análise de dados de vendas utilizando SQL, com foco em consultas essenciais para monitoramento de desempenho e identificação de padrões de vendas.

### **Índice**

1. [Introdução](#introdução)
2. [Importância da Análise de Dados](#importância-da-análise-de-dados)
3. [Queries e Explicações](#queries-e-explicações)
   - [Consulta Completa de Vendas](#consulta-completa-de-vendas)
   - [Datas Distintas](#datas-distintas)
   - [Contagem de Vendas por Data](#contagem-de-vendas-por-data)
   - [Preços Distintos](#preços-distintos)
   - [Contagem de Vendas por Valor](#contagem-de-vendas-por-valor)
   - [Vendas dos Últimos 7 Dias](#vendas-dos-últimos-7-dias)
   - [Vendas com Valor Inferior a 6 Mil no Período de 01/09/2024 a 11/09/2024](#vendas-com-valor-inferior-a-6-mil-no-período-de-01-09-2024-a-11-09-2024)
   - [Agregação de Vendas por Dia e Produto](#agregação-de-vendas-por-dia-e-produto)
4. [Análises Importantes](#análises-importantes)
5. [Instalação e Configuração do DBT](#instalação-e-configuração-do-dbt)
6. [Estrutura do Projeto](#estrutura-do-projeto)
   - [Configuração do Source](#configuração-do-source)
   - [Camada Bronze](#camada-bronze)
   - [Camada Silver](#camada-silver)
   - [Camada Gold](#camada-gold)
7. [Execução do Projeto DBT](#execução-do-projeto-dbt)
8. [Conclusão](#conclusão)

---

### **Introdução**

O Sistema de CRM e Vendas da ZapFlow utiliza SQL para realizar análises detalhadas das vendas. Com a ajuda dessas consultas, é possível obter insights sobre o desempenho dos produtos, identificar tendências e detectar possíveis fraudes. Este README detalha as principais queries utilizadas no projeto e explica a importância de cada análise.

### **Importância da Análise de Dados**

A análise de dados é essencial para qualquer negócio que deseja entender seu desempenho e tomar decisões baseadas em informações precisas. Através da análise de vendas, é possível identificar os produtos mais vendidos, os melhores horários de vendas, tendências sazonais, e até mesmo padrões de fraude. Isso ajuda as empresas a ajustarem suas estratégias de marketing, vendas e operações para maximizar os resultados.

### **Queries e Explicações**

#### **1. Consulta Completa de Vendas**

```sql
SELECT 
    * 
FROM 
    vendas
```

**Descrição:**
- Essa query retorna todos os registros da tabela de vendas, exibindo todos os campos (email, data, valor, quantidade, produto).
- **Importância:** Útil para obter uma visão geral de todas as vendas realizadas, especialmente para verificar a integridade dos dados.

#### **2. Datas Distintas**

```sql
SELECT 
    DISTINCT DATE(data) AS dia 
FROM 
    vendas 
ORDER BY 
    dia ASC
```

**Descrição:**
- Retorna todas as datas únicas em que ocorreram vendas.
- **Importância:** Ajuda a identificar os dias ativos de vendas, sendo útil para análises sazonais ou de frequência.

#### **3. Contagem de Vendas por Data**

```sql
SELECT 
    DISTINCT DATE(data) AS dia,
    COUNT(data) AS qte 
FROM 
    vendas 
GROUP BY
    data
ORDER BY 
    dia ASC
```

**Descrição:**
- Essa query conta o número de transações realizadas em cada data distinta.
- **Importância:** Permite analisar o volume de vendas por dia, identificando picos ou períodos de baixa atividade.

#### **4. Preços Distintos**

```sql
SELECT 
    DISTINCT valor 
FROM 
    vendas
```

**Descrição:**
- Retorna todos os valores únicos de vendas registrados na tabela.
- **Importância:** Ajuda a entender a variedade de preços, identificando diferentes faixas de valores praticados nos produtos.

#### **5. Contagem de Vendas por Valor**

```sql
SELECT 
    valor,
    COUNT(valor) AS qte
FROM 
    vendas 
GROUP BY 
    valor
```

**Descrição:**
- Contabiliza a quantidade de vendas para cada valor distinto.
- **Importância:** Identifica a frequência de vendas para cada faixa de preço, útil para detectar padrões de compra e verificar se há valores fora do esperado.

#### **6. Vendas dos Últimos 7 Dias**

```sql
SELECT 
    DATE(data) AS dia, 
    SUM(valor) AS total_vendas, 
    COUNT(*) AS total_transacoes 
FROM 
    vendas 
WHERE 
    data >= CURRENT_DATE - INTERVAL '6 days' 
    AND data < CURRENT_DATE + INTERVAL '1 day' 
GROUP BY 
    DATE(data) 
ORDER BY 
    dia DESC
```

**Descrição:**
- Agrega as vendas dos últimos 7 dias, mostrando o total vendido e o número de transações por dia.
- **Importância:** Permite monitorar o desempenho recente das vendas, identificar padrões diários e ajustar estratégias em tempo real.

#### **7. Vendas com Valor Inferior a 6 Mil no Período de 01/09/2024 a 11/09/2024**

```sql
SELECT 
    email, 
    data, 
    valor, 
    quantidade, 
    produto 
FROM 
    vendas 
WHERE 
    valor < 6000 
    AND data >= '2024-09-01' 
    AND data <= '2024-09-11'
ORDER BY 
    data ASC, 
    valor DESC
```

**Descrição:**
- Filtra vendas com valores abaixo de 6 mil reais dentro do período específico.
- **Importância:** Ajuda a focar em vendas menores que podem representar o grosso do volume de vendas ou identificar produtos de menor ticket médio.

#### **8. Agregação de Vendas por Dia e Produto**

```sql
WITH vendas_filtradas AS (
    SELECT 
        email, 
        DATE(data) AS dia, 
        valor, 
        quantidade, 
        produto 
    FROM 
        vendas 
    WHERE 
        valor < 6000 
        AND data >= '2024-09-01' 
        AND data <= '2024-09-11'
)
SELECT 
    dia, 
    produto, 
    SUM(valor) AS total_valor, 
    SUM(quantidade) AS total_quantidade,
    COUNT(*) AS total_vendas
FROM 
    vendas_filtradas
GROUP BY 
    dia, 
    produto
ORDER BY 
    dia ASC
```

**Descrição:**
- Utiliza uma CTE (`vendas_filtradas`) para filtrar vendas específicas e, em seguida, agrega os resultados por dia e produto.
- **Importância:** Permite visualizar o desempenho de cada produto por dia, ajudando a identificar os dias mais fortes de vendas para cada produto, além de ajudar na detecção de tendências e sazonalidades.

### **Análises Importantes**

Essas análises ajudam a visualizar e interpretar os dados de vendas, identificando padrões, comportamentos fora do comum e possibilitando decisões mais assertivas no dia a dia do negócio.

### **Instalação e Configuração do DBT**

#### **1. Instalar o DBT**

Instale o DBT com suporte ao PostgreSQL utilizando o comando:

```bash
pip install dbt-postgres
```

#### **2. Criar o Projeto DBT**

Após instalar o DBT, crie um novo projeto:

```bash
dbt init vendas_dbt
cd vendas_dbt
```

#### **3. Configuração da Conexão com o PostgreSQL**

Configure o arquivo `profiles.yml` para conectar o DBT ao PostgreSQL. Geralmente localizado em `~/.dbt/` ou na pasta do projeto.

**Exemplo de `profiles.yml`:**

```yaml
vendas_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: seu_usuario
      password: sua_senha
      port: 5432
      dbname: seu_banco_de_dados
      schema: vendas
      threads: 4
```

### **Estrutura do Projeto**

#### **Configuração do Source**

Crie o arquivo `sources.yml` na pasta `models` para definir o ponto de entrada dos dados:

**Arquivo `models/sources.yml`:**

```yaml
version: 2

sources:
  - name: vendas_source
    schema: vendas
    tables:
      - name: vendas
```

#### **Camada Bronze**

**Arquivo `models/bronze/bronze_vendas.sql`:**

```sql
{{ config(materialized='view') }}

SELECT 
    * 
FROM 
    {{ source('vendas_source', 'vendas') }}
```

#### **Camada Silver**

**Arquivo `models/silver/silver_vendas.sql`:**

```sql
{{ config(materialized='view') }}

WITH cleaned_data AS (
    SELECT 
        email, 
        DATE(data) AS data,
        valor, 
        quantidade, 
        produto
    FROM 
        {{ ref('bronze_vendas

') }}
    WHERE 
        valor > 0 
        AND valor < 8000
        AND data <= CURRENT_DATE
)

SELECT * FROM cleaned_data
```

#### **Camada Gold - Agregados dos Últimos 7 Dias**

**Arquivo `models/gold/gold_vendas_7_dias.sql`:**

```sql
{{ config(materialized='view') }}

WITH vendas_7_dias AS (
    SELECT 
        data, 
        produto, 
        SUM(valor) AS total_valor, 
        SUM(quantidade) AS total_quantidade, 
        COUNT(*) AS total_vendas
    FROM 
        {{ ref('silver_vendas') }}
    WHERE 
        data >= CURRENT_DATE - INTERVAL '6 days'
    GROUP BY 
        data, produto
)

SELECT 
    data, 
    produto, 
    total_valor, 
    total_quantidade, 
    total_vendas
FROM 
    vendas_7_dias
ORDER BY 
    data ASC
```

#### **Camada Gold - Agregados por Vendedor**

**Arquivo `models/gold/gold_vendas_por_vendedor.sql`:**

```sql
{{ config(materialized='view') }}

WITH vendas_7_dias_vendedor AS (
    SELECT 
        email AS vendedor, 
        DATE(data) AS data, 
        SUM(valor) AS total_valor, 
        SUM(quantidade) AS total_quantidade, 
        COUNT(*) AS total_vendas
    FROM 
        {{ ref('silver_vendas') }}
    WHERE 
        data >= CURRENT_DATE - INTERVAL '6 days'
    GROUP BY 
        email, DATE(data)
)

SELECT 
    vendedor, 
    data, 
    total_valor, 
    total_quantidade, 
    total_vendas
FROM 
    vendas_7_dias_vendedor
ORDER BY 
    data ASC, vendedor ASC
```

### **Execução do Projeto DBT**

Após configurar todas as camadas, execute o DBT para materializar as views:

```bash
dbt run
```

### **Conclusão**

Este README detalha a importância de analisar os dados de vendas usando SQL, explicando passo a passo cada query utilizada no projeto de CRM e Vendas da ZapFlow. As queries apresentadas fornecem uma base sólida para entender o comportamento de vendas, identificar padrões e ajustar estratégias de negócio, proporcionando uma vantagem competitiva significativa no mercado.

As análises realizadas não só ajudam a visualizar o desempenho atual, mas também preparam as empresas para futuras decisões estratégicas, garantindo que as operações sejam orientadas por dados e insights acionáveis.