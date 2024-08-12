SELECT
    pp.id AS product_id,
    -- ID del producto
    pt.name AS product_name,
    -- Nombre del producto
    pt.default_code AS product_code,
    -- Código del producto
    sm.id AS stock_move_id,
    -- ID del movimiento de stock
    sml.id AS stock_move_line_id,
    -- ID de la línea del movimiento de stock
    sp.id AS stock_picking_id,
    -- ID del picking
    sp.name AS stock_picking_name,
    -- Nombre del picking
    sp.date AS stock_picking_date,
    -- Fecha del picking
    sp.origin AS fsm_order_name,
    -- Nombre de la orden de Field Service
    spt.name AS picking_type_name,
    -- Nombre del tipo de picking
    spt.code AS picking_type_code,
    -- Código del tipo de picking
    sml.qty_done AS quantity_moved,
    -- Cantidad movida
    sl_from.name AS location_from,
    -- Ubicación de origen
    sl_to.name AS location_to -- Ubicación de destino
FROM
    stock_picking sp
    LEFT JOIN stock_picking_type spt ON sp.picking_type_id = spt.id -- Relación con tipo de picking
    LEFT JOIN stock_move sm ON sp.id = sm.picking_id -- Relación con movimientos de stock
    LEFT JOIN stock_move_line sml ON sm.id = sml.move_id -- Relación con líneas de movimiento de stock
    LEFT JOIN product_product pp ON sml.product_id = pp.id -- Relación con productos
    LEFT JOIN product_template pt ON pp.product_tmpl_id = pt.id -- Relación con plantillas de producto
    LEFT JOIN stock_location sl_from ON sml.location_id = sl_from.id -- Ubicación de origen
    LEFT JOIN stock_location sl_to ON sml.location_dest_id = sl_to.id -- Ubicación de destino
WHERE
    sp.company_id = 17 -- Filtrar por empresa
    AND spt.code IN ('outgoing', 'incoming') -- Incluir tipos de picking de entrega y devolución
    -- AND sp.fsm_order_id = '46' -- Filtrar por la Field Service específica (SOLO PARA TESTEAR)
ORDER BY
    sp.date DESC,
    -- Ordenar por fecha de picking
    pp.id;