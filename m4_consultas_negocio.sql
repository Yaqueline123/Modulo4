

-- Archivo: m4_consultas_negocio.sql
-- Motor: SQL Server
-- Base de datos: Ventas_Tech_DB
-- Tabla: ventas

-- ==========================================
-- Consulta 1: Resumen ejecutivo mensual
-- ==========================================
SELECT 
    MONTH(fecha_venta) AS mes, 
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_facturado,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);


-- ==========================================
-- Consulta 2: Ranking de productos (Top 5)
-- ==========================================
SELECT TOP 5 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- ==========================================
-- Consulta 3: Clientes recurrentes
-- ==========================================
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- ==========================================
-- Consulta 4: Productos por encima/por debajo del promedio
-- ==========================================
WITH TotalesPorProducto AS (
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT 
    id_producto,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM TotalesPorProducto) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_vs_promedio
FROM TotalesPorProducto;


-- ==========================================
-- HALLAZGOS DEL ANÁLISIS
-- ==========================================
-- 1. Concentración de ingresos: El ranking de productos revela que unos pocos "productos estrella" en el Top 5 concentran una proporción altísima del total facturado mensual.
-- 2. Retención de clientes: La cantidad de clientes recurrentes (con más de 1 pedido) es relativamente baja en comparación con el volumen total de pedidos, lo que señala una clara oportunidad para implementar campañas de fidelización.
-- 3. Rendimiento asimétrico: Al analizar los productos frente al promedio, se evidencia que la mayoría del catálogo se etiqueta como 'Por debajo', lo que indica que el promedio está fuertemente sesgado hacia arriba por los productos más vendidos.
