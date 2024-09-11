{{ config(materialized='view') }}

WITH cleaned_data AS (
    SELECT 
        email, 
        DATE(data) AS data,
        valor, 
        quantidade, 
        produto
    FROM 
        {{ ref('bronze_vendas') }}
    WHERE 
        valor > 0 
        AND valor < 8000  -- Removendo valores extremos acima de 8000
        AND data <= CURRENT_DATE  -- Removendo datas futuras
)

SELECT * FROM cleaned_data
