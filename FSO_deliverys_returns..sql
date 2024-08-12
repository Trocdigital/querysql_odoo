-- Permite comprobar el total de FSM contra el sistema, las deliverys y return las agrupa en la columna name_picking
SELECT
    fsmo.id AS fsm_order,
    -- ID de la orden FSM
    fsmo.name AS name_fsmo,
    -- Nombre de la orden FSM
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
    sw.name AS warehouse_name,
    -- Nombre del almacén asociado a la orden
    sw.code AS warehouse_code,
    -- Código del almacén asociado a la orden
    fs_stage.name AS stage_name,
    -- Nombre del estado o etapa de la orden
    ARRAY_AGG(spt.name) AS name_picking -- Agrega los nombres de los tipos de picking asociados a la orden en un solo campo
FROM
    fsm_order AS fsmo
    LEFT JOIN stock_picking AS sp ON fsmo.id = sp.fsm_order_id -- Une fsm_order con stock_picking usando el ID de la orden FSM
    LEFT JOIN stock_picking_type AS spt ON sp.picking_type_id = spt.id -- Une stock_picking con stock_picking_type usando el ID del tipo de picking
    LEFT JOIN fsm_location AS location ON location.id = fsmo.location_id -- Une fsm_order con fsm_location usando el ID de la ubicación
    LEFT JOIN res_partner AS location_partner ON location.partner_id = location_partner.id -- Une fsm_location con res_partner usando el ID del partner de la ubicación
    LEFT JOIN stock_location AS stock_location ON location.inventory_location_id = stock_location.id -- Une fsm_location con stock_location usando el ID de la ubicación de inventario
    LEFT JOIN stock_warehouse AS sw ON fsmo.warehouse_id = sw.id -- Une fsm_order con stock_warehouse usando el ID del almacén
    LEFT JOIN fsm_team AS ft ON ft.id = fsmo.team_id -- Une fsm_order con fsm_team usando el ID del equipo
    LEFT JOIN fsm_person AS fp ON fsmo.person_id = fp.id -- Une fsm_order con fsm_person usando el ID de la persona asignada
    LEFT JOIN res_partner AS assigned_partner ON fp.partner_id = assigned_partner.id -- Une fsm_person con res_partner usando el ID del partner asignado a la persona
    LEFT JOIN fsm_stage AS fs_stage ON fsmo.stage_id = fs_stage.id -- Une fsm_order con fsm_stage usando el ID de la etapa
GROUP BY
    fsmo.id,
    -- Agrupa por ID de la orden FSM
    fsmo.name,
    -- Agrupa por nombre de la orden FSM
    location.id,
    -- Agrupa por ID de la ubicación del kiosko
    location_partner.ref,
    -- Agrupa por referencia del partner asociado a la ubicación del kiosko
    ft.name,
    -- Agrupa por nombre del equipo
    assigned_partner.name,
    -- Agrupa por nombre del partner asignado a la orden
    location_partner.name,
    -- Agrupa por nombre del partner asociado a la ubicación del kiosko
    stock_location.name,
    -- Agrupa por nombre de la ubicación de inventario
    sw.name,
    -- Agrupa por nombre del almacén
    sw.code,
    -- Agrupa por código del almacén
    fs_stage.name -- Agrupa por nombre de la etapa
ORDER BY
    fsmo.id;

-- Ordena los resultados por el ID de la orden FSM