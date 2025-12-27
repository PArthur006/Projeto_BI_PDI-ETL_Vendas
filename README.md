# PROJETO BI com Pentaho PDI - ETL de Vendas com Enriquecimento via API

## DESCRIÇÃO

Este projeto implementa um pipeline de dados completo (End-to-End) utilizando Pentaho Data Integration (PDI) e PostgreSQL.
O objetivo é integrar dados transacionais de vendas (CSV) com dados de produtos de uma API externa (FakeStoreAPI), realizar o enriquecimento, tratamento e carga em um modelo dimensional (Star-Schema).

## ESTRUTURA DO PROJETO

A entrega está organizada da seguinte forma:

```
/01_Documentacao
   |-- Modelo_ER_DBeaver.png (Diagrama Entidade-Relacionamento do DW)
   |-- Print_job_Verde.png (Evidência de execução com sucesso)

/02_Scripts_SQL
   |-- 01_create_ods_stage.sql    (Criação das tabelas de Staging e ODS)
   |-- 02_create_dw_star_schema.sql (Criação das Dimensões, Fato e Tabelas de Controle/Log)
   |-- 03_popula_dim_tempo.sql    (Carga inicial da Dimensão Tempo e registros default)

/03_ETL
   |-- input/                     (Contém o dataset data.csv)
   |-- transformations/           (Arquivos .ktr individuais)
   |-- job_etl_vendas.kjb         (Job orquestrador principal)
   |-- job_...                    (Demais Jobs do projeto)
```

## PRÉ-REQUISITOS

1. PostgreSQL instalado e rodando na porta 5432.
2. Pentaho Data Integration (Spoon) instalado.
3. Acesso à Internet (para consumo da API FakeStore).
4. Criação prévia de um banco de dados vazio chamado **'dw_ecommerce'**.

## INSTRUÇÕES DE INSTALAÇÃO E EXECUÇÃO

### Passo 1: PREPARAÇÃO DO BANCO DE DADOS
- Abra o seu cliente SQL (DBeaver/PgAdmin).
- Conecte-se ao banco 'dw_ecommerce'.
- Execute os scripts da pasta '02_Scripts_SQL' na ordem numérica.

### Passo 2: CONFIGURAÇÃO DO PENTAHO
- Abra o arquivo '/03_ETL/job_etl_vendas.kjb' no Spoon.
- Verifique a conexão de banco de dados 'Postgres_Local'.
- Ajuste o Usuário e Senha conforme sua instalação local do PostgreSQL.

### Passo 3: EXECUÇÃO
- Execute o Job principal ('job_etl_vendas.kjb').
- O processo executará sequencialmente:
   1. Registro de Log: Marca o início da execução na tabela de auditoria.
   2. Verificação Incremental: Consulta a data da última carga para filtrar apenas novos registros.
   3. Ingestão: Coleta dados da API e do CSV.
   4. Enriquecimento: Cruza dados transacionais com categorias da API (Stage).
   5. Carga de Dimensões: Processa Clientes, Produtos (SCD2) e Tempo.
   6. Carga da Fato: Insere vendas novas e calcula métricas.
   7. Atualização de Controle: Atualiza a "Marca D'água" para a próxima execução.
   8. Finalização: Registra o sucesso (ou erro) na tabela de auditoria.

## DESTAQUES TÉCNICOS

### CARGA INCREMENTAL
Implementação de lógica de "Janela Deslizante". O ETL consulta a tabela de controle, recupera a data da última carga e processa na Fato apenas as vendas novas, garantindo performance e evitando duplicidade.

### ENRIQUECIMENTO
Utilização de algoritmo de Hashing em JavaScript para criar vínculos determinísticos entre os produtos CSV (Dataset Kaggle) e as categorias da API (FakeStore), solucionando a ausência de chaves naturais.

### SCD Tipo 2
Implementado na Dimensão Produto. Alterações no cadastro do produto geram uma nova versão, preservando o histórico de preços e descrições para vendas passadas.

### PORTABILIDADE

Todos os caminhos de arquivos utilizam variáveis relativas para funcionar em qualquer diretório ou sistema operacional sem necessidade de reconfiguração.

