SELECT
    pp.id AS product_id,
    -- ID del producto
    pt.name AS product_name,
    -- Nombre del producto
    pt.default_code AS sku,
    -- Código del producto
    sp.id AS stock_picking_id,
    -- ID del picking
    fsmo.name AS name_fsmo,
    -- Nombre de la orden FSM
    fs_stage.name AS status_fsm,
    -- Nombre del estado o etapa de la orden
    sp.name AS stock_picking_name,
    -- Nombre del picking (Delivery or Return)
    spt.name AS picking_type_name,
    -- Nombre del tipo de picking
    spt.code AS picking_type_code,
    -- Código del tipo de picking
    sp.origin AS document_origin,
    -- Nombre de la orden de Field Service
    sp.date AS stock_picking_date,
    -- Fecha del picking
    sml.qty_done AS quantity_moved,
    -- Cantidad movida
    sl_from.name AS location_from,
    -- Ubicación de origen
    sl_to.name AS location_to,
    -- Ubicación de destino
    sp.state AS status_picking,
    -- Estado del picking
    sw.id AS warehouse_id,
    -- ID del almacén
    sw.name AS warehouse_name,
    -- Nombre del almacén
    fsmo.id AS fsm_order_id,
    -- ID de la orden FSM
    location.id AS kiosk_id,
    -- ID de la ubicación del kiosko
    location.complete_name AS name_kiosk,
    -- Nombre completo de la ubicación del kiosko
    location_partner.ref AS reference,
    -- Referencia del partner asociado a la ubicación del kiosko
    assigned_partner.name AS assigned_to,
    -- Nombre del partner asignado a la orden
    ft.name AS team,
    -- Nombre del equipo asignado a la orden
    location_partner.name AS partner_name,
    -- Nombre del partner asociado a la ubicación del kiosko
    stock_location.name AS inventory_location_name,
    -- Nombre de la ubicación de inventario asociada a la orden
    sw.name AS warehouse_name_order,
    -- Nombre del almacén asociado a la orden
    sw.code AS warehouse_code_order,
    -- Código del almacén asociado a la orden
    sm.id AS stock_move_id,
    -- ID del movimiento de stock
    sml.id AS stock_move_line_id,
    -- ID de la línea del movimiento de stock
    ARRAY_AGG(spt.name) AS name_picking -- Agrega los nombres de los tipos de picking asociados a la orden en un solo campo
FROM
    stock_picking sp
    LEFT JOIN stock_picking_type spt ON sp.picking_type_id = spt.id -- Relación con tipo de picking
    LEFT JOIN stock_move sm ON sp.id = sm.picking_id -- Relación con movimientos de stock
    LEFT JOIN stock_move_line sml ON sm.id = sml.move_id -- Relación con líneas de movimiento de stock
    LEFT JOIN product_product pp ON sml.product_id = pp.id -- Relación con productos
    LEFT JOIN product_template pt ON pp.product_tmpl_id = pt.id -- Relación con plantillas de producto
    LEFT JOIN stock_location sl_from ON sml.location_id = sl_from.id -- Ubicación de origen
    LEFT JOIN stock_location sl_to ON sml.location_dest_id = sl_to.id -- Ubicación de destino
    LEFT JOIN stock_location swl ON sp.location_id = swl.id -- Ubicación del almacén asociado al picking (por defecto)
    LEFT JOIN stock_warehouse sw ON swl.warehouse_id = sw.id -- Relación con almacén usando la ubicación
    LEFT JOIN fsm_order fsmo ON sp.fsm_order_id = fsmo.id -- Relación con la orden FSM
    LEFT JOIN fsm_location location ON location.id = fsmo.location_id -- Relación con ubicación del kiosko
    LEFT JOIN res_partner location_partner ON location.partner_id = location_partner.id -- Relación con partner de la ubicación del kiosko
    LEFT JOIN stock_location stock_location ON location.inventory_location_id = stock_location.id -- Relación con ubicación de inventario
    LEFT JOIN fsm_team ft ON ft.id = fsmo.team_id -- Relación con equipo
    LEFT JOIN fsm_person fp ON fsmo.person_id = fp.id -- Relación con persona asignada
    LEFT JOIN res_partner assigned_partner ON fp.partner_id = assigned_partner.id -- Relación con partner asignado
    LEFT JOIN fsm_stage fs_stage ON fsmo.stage_id = fs_stage.id -- Relación con etapa
    -- WHERE sp.fsm_order_id = '46' -- Filtrar por la Field Service específica (SOLO PARA TESTEAR)
GROUP BY
    pp.id,
    pt.name,
    pt.default_code,
    sm.id,
    sml.id,
    sp.id,
    sp.name,
    sp.date,
    sp.origin,
    spt.name,
    spt.code,
    sml.qty_done,
    sl_from.name,
    sl_to.name,
    sp.state,
    sw.id,
    sw.name,
    fsmo.id,
    fsmo.name,
    location.id,
    location.complete_name,
    location_partner.ref,
    assigned_partner.name,
    ft.name,
    location_partner.name,
    stock_location.name,
    sw.code,
    fs_stage.name
ORDER BY
    --sp.date DESC, -- Ordenar por fecha de picking
    pp.id;

-- Ordenar por ID de producto