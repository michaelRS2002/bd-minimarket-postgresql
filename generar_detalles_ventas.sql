DO $$
DECLARE
    venta RECORD;
    num_productos INT;
    i INT;
    producto_id INT;
    cantidad INT;
    precio NUMERIC;
    subtotal NUMERIC;
BEGIN
    FOR venta IN SELECT id_venta FROM ventas ORDER BY id_venta LOOP
        -- Determinar número de productos por venta (1-8 productos con distribución realista)
        CASE 
            WHEN random() < 0.3 THEN num_productos := 1 + floor(random() * 2)::int; -- 30% compras pequeñas (1-2 productos)
            WHEN random() < 0.7 THEN num_productos := 2 + floor(random() * 3)::int; -- 40% compras medianas (2-4 productos)
            ELSE num_productos := 4 + floor(random() * 5)::int; -- 30% compras grandes (4-8 productos)
        END CASE;
        
        -- Insertar productos para esta venta
        FOR i IN 1..num_productos LOOP
            -- Seleccionar producto aleatorio
            SELECT id_producto, precio_unitario INTO producto_id, precio
            FROM productos 
            ORDER BY random() 
            LIMIT 1;
            
            -- Cantidad entre 1 y 3
            cantidad := 1 + floor(random() * 3)::int;
            
            -- Calcular subtotal
            subtotal := precio * cantidad;
            
            -- Insertar detalle
            INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal_producto)
            VALUES (venta.id_venta, producto_id, cantidad, subtotal);
        END LOOP;
    END LOOP;
END $$;