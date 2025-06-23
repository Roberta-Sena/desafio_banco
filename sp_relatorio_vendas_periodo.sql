DROP PROCEDURE IF EXISTS sp_relatorio_vendas_periodo;
DELIMITER $$

CREATE PROCEDURE sp_relatorio_vendas_periodo (
    IN data_inicio DATE,
    IN data_fim DATE,
    IN categoria_produto VARCHAR(100)
)
BEGIN
    CREATE TEMPORARY TABLE tmp_relatorio_vendas (
        tipo_linha VARCHAR(20),           -- 'Resumo' ou 'Produto'
        descricao VARCHAR(200),
        quantidade INT,
        valor DECIMAL(15,2)
    );

    INSERT INTO tmp_relatorio_vendas (tipo_linha, descricao, quantidade, valor)
    SELECT 
        'Resumo', 
        'Quantidade/Soma Total de Pedidos', 
        COUNT(DISTINCT p.id_pedido), 
        COALESCE(SUM(p.vl_pedido), 0)
    FROM 
        pedido p
    WHERE 
        p.dt_pedido BETWEEN data_inicio AND data_fim;

    INSERT INTO tmp_relatorio_vendas (tipo_linha, descricao, quantidade, valor)
    SELECT 
        'Resumo', 
        'Média Valor por Pedido', 
        NULL,
        COALESCE(AVG(p.vl_pedido), 0)
    FROM 
        pedido p
    WHERE 
        p.dt_pedido BETWEEN data_inicio AND data_fim;


    -- Inserir lista de produtos da categoria com quantidade vendida e status atual do pedido
    INSERT INTO tmp_relatorio_vendas (tipo_linha, descricao, quantidade, valor)
    SELECT
        'Produto',
        CONCAT('Produto: ', pr.nm_produto),
        SUM(ip.qt_produto) AS quantidade_vendida,
        COALESCE(SUM(pr.vl_produto), 0)
    FROM
        item_pedido ip
    JOIN pedido p ON ip.id_pedido = p.id_pedido
    JOIN produto pr ON ip.id_produto = pr.id_produto
    JOIN categoria_produto cp ON pr.id_categoria = cp.id_categoria
    WHERE
        p.dt_pedido BETWEEN data_inicio AND data_fim
        AND cp.nm_categoria = categoria_produto
    GROUP BY
        pr.nm_produto
    ORDER BY
        quantidade_vendida DESC;

    -- Retornar resultado consolidado
    SELECT 
        tipo_linha,
        descricao,
        quantidade,
        valor
    FROM tmp_relatorio_vendas;

    -- Limpar tabela temporária
    DROP TEMPORARY TABLE tmp_relatorio_vendas;

END $$
DELIMITER ;
