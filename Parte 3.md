**Parte 3 - Otimização de uma Query**

- Consulta alterada
```sql
CREATE PROCEDURE sp_consulta_pedidos(
    IN p_valor_minimo DECIMAL(10,2),
    IN p_status VARCHAR(50)
)
BEGIN
    SELECT 
        c.nome AS nome_cliente,
        p.id AS id_pedido,
        p.valor_total AS valor_total
    FROM pedidos p
    JOIN clientes c ON p.id_cliente = c.id
    WHERE p.status = p_status
      AND p.valor_total > p_valor_minimo
    ORDER BY p.data_criacao DESC;
END$$
```
**Justificativa:**
Alterei a consulta para utilizar JOIN explícito, tornando mais clara a definição dos relacionamentos entre as tabelas e separando as condições de junção dos filtros da consulta. Também apliquei aliases nas colunas, facilitando a leitura e a identificação dos dados no resultado.
A criação da procedure permite parametrizar os filtros de status e valor, tornando a consulta mais reutilizável, dinâmica e flexível.
Além disso, recomendaria a criação de uma tabela de domínio para os status, utilizando o ID como chave de filtro, o que garante melhor performance, integridade referencial e evita inconsistências nos dados.

**Pontos importantes:**
- Verificar índices das colunas que fazem parte dos filtros e ordenação.
- Verificar se é necessário recuperar todos os pedidos, podendo adicionar um filtro por data.

**Observação:**
No banco que criei inclui essa procedure de acordo com o modelo criado.
