Use desafio_produto;
DROP PROCEDURE IF EXISTS sp_consulta_pedidos;
DELIMITER $$

CREATE PROCEDURE sp_consulta_pedidos (
    IN p_valor_minimo DECIMAL(10,2),
    IN p_status VARCHAR(50)
)
BEGIN
    SELECT 
        c.nm_cliente AS nome_cliente, 
        p.id_pedido  AS id_pedido, 
        p.vl_pedido  AS valor_total
    FROM 
        pedido p
    INNER JOIN 
        cliente c ON p.id_cliente = c.id_cliente
    INNER JOIN 
        (
            SELECT sp1.id_pedido, sp1.id_status
            FROM status_pedido sp1
            INNER JOIN (
                SELECT id_pedido, MAX(dt_status) AS ultima_data
                FROM status_pedido
                GROUP BY id_pedido
            ) sp2 ON sp1.id_pedido = sp2.id_pedido AND sp1.dt_status = sp2.ultima_data
        ) ult_status ON ult_status.id_pedido = p.id_pedido
    WHERE 
        ult_status.id_status = p_status
        AND p.vl_pedido > p_valor_minimo
    ORDER BY 
        p.dt_pedido DESC;
END$$
DELIMITER ;
