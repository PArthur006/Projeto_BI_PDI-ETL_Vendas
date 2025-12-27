-- 1. Limpeza DW
DROP TABLE IF EXISTS public.fat_vendas CASCADE;
DROP TABLE IF EXISTS public.dim_produto CASCADE;
DROP TABLE IF EXISTS public.dim_cliente CASCADE;
DROP TABLE IF EXISTS public.dim_tempo CASCADE;

-- 2. Limpeza Tabelas de Controle
DROP TABLE IF EXISTS public.etl_controle_carga;
DROP TABLE IF EXISTS public.etl_ultima_carga;

-- 3. Dimensão Tempo
CREATE TABLE public.dim_tempo (
    sk_tempo INTEGER PRIMARY KEY,
    data_completa DATE,
    ano INTEGER,
    mes INTEGER,
    dia INTEGER,
    dia_semana VARCHAR(20),
    nome_mes VARCHAR(20),
    trimestre INTEGER
);

-- 4. Dimensão Cliente (SCD Tipo 1)
CREATE TABLE public.dim_cliente (
    sk_cliente SERIAL PRIMARY KEY,
    customer_id VARCHAR(50),
    country VARCHAR(50),
    dt_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Dimensão Produto (SCD Tipo 2)
CREATE TABLE public.dim_produto (
    sk_produto SERIAL PRIMARY KEY,
    stock_code VARCHAR(50),
    description TEXT,
    category VARCHAR(100),
    image_url TEXT,
    rating_rate NUMERIC(3,1),
    version INTEGER,
    date_from TIMESTAMP,
    date_to TIMESTAMP
);

-- 6. Fato Vendas
CREATE TABLE public.fat_vendas (
    sk_venda SERIAL PRIMARY KEY,
    sk_cliente INTEGER REFERENCES dim_cliente(sk_cliente),
    sk_produto INTEGER REFERENCES dim_produto(sk_produto),
    sk_tempo INTEGER REFERENCES dim_tempo(sk_tempo),
    invoice_no VARCHAR(20),
    quantity INTEGER,
    unit_price NUMERIC(10,2),
    total_line_value NUMERIC(10,2)
);

-- 7. Tabela de Logs e Auditoria
CREATE TABLE public.etl_controle_carga (
    id_execucao SERIAL PRIMARY KEY,
    nome_job VARCHAR(100),
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fim TIMESTAMP,
    status VARCHAR(50),
    mensagem_erro TEXT
);

-- 8. Tabela de Controle Incremental
CREATE TABLE public.etl_ultima_carga (
    tabela_destino VARCHAR(50) PRIMARY KEY,
    data_carga TIMESTAMP
);