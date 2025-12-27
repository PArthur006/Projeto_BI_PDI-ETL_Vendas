-- 1. Popula Dimensão Tempo 
TRUNCATE TABLE public.dim_tempo CASCADE;

INSERT INTO public.dim_tempo (sk_tempo, data_completa, ano, mes, dia, dia_semana, nome_mes, trimestre)
SELECT
    TO_CHAR(datum, 'yyyymmdd')::INT AS sk_tempo,
    datum AS data_completa,
    EXTRACT(YEAR FROM datum) AS ano,
    EXTRACT(MONTH FROM datum) AS mes,
    EXTRACT(DAY FROM datum) AS dia,
    TO_CHAR(datum, 'TMDay') AS dia_semana,
    TO_CHAR(datum, 'TMMonth') AS nome_mes,
    EXTRACT(QUARTER FROM datum) AS trimestre
FROM (
    SELECT '2010-01-01'::DATE + SEQUENCE.DAY AS datum
    FROM GENERATE_SERIES(0, 1100) AS SEQUENCE(DAY)
) DQ
WHERE datum <= '2012-12-31'
ORDER BY 1;

-- 2. Criação das Linhas Zero 

-- Tempo Desconhecido
INSERT INTO public.dim_tempo (sk_tempo, data_completa, ano, mes, dia, dia_semana, nome_mes, trimestre)
VALUES (0, '1900-01-01', 1900, 1, 1, 'N/A', 'N/A', 1);

-- Cliente Desconhecido
INSERT INTO public.dim_cliente (sk_cliente, customer_id, country)
OVERRIDING SYSTEM VALUE
VALUES (0, 'N/A', 'N/A');

-- Produto Desconhecido 
INSERT INTO public.dim_produto (sk_produto, stock_code, description, category, version, date_from, date_to) 
OVERRIDING SYSTEM VALUE
VALUES (0, 'N/A', 'Produto Desconhecido', 'N/A', 1, '1900-01-01 00:00:00', '2199-12-31 23:59:59');

-- 3. Inicialização do Controle Incremental
DELETE FROM public.etl_ultima_carga WHERE tabela_destino = 'fat_vendas';
INSERT INTO public.etl_ultima_carga (tabela_destino, data_carga)
VALUES ('fat_vendas', '1900-01-01 00:00:00');