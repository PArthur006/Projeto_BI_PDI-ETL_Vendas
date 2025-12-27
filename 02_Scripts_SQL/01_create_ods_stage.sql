-- 1. Limpeza inicial
DROP TABLE IF EXISTS public.ods_vendas CASCADE;
DROP TABLE IF EXISTS public.ods_produto CASCADE;
DROP TABLE IF EXISTS public.ods_cliente CASCADE;
DROP TABLE IF EXISTS public.ods_api_produtos CASCADE;
DROP TABLE IF EXISTS public.stage_produto CASCADE;

-- 2. Tabelas ODS
CREATE TABLE public.ods_vendas (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10,2),
    customer_id VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE public.ods_produto (
    stock_code VARCHAR(50),
    description TEXT
);

CREATE TABLE public.ods_cliente (
    customer_id VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE public.ods_api_produtos (
    id_produto_api INTEGER,
    title TEXT,
    price NUMERIC(10,2),
    description TEXT,
    category VARCHAR(100),
    image_url TEXT,
    rating_rate NUMERIC(3,1),
    rating_count INTEGER
);

-- 3. Tabela Stage 
CREATE TABLE public.stage_produto (
    stock_code VARCHAR(50),
    description TEXT,
    id_fake_api INTEGER,
    category VARCHAR(100),
    image_url TEXT,
    rating_rate NUMERIC(3,1)
);