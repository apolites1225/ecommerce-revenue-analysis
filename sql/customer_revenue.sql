-- public.customer_revenue source

CREATE OR REPLACE VIEW public.customer_revenue
AS SELECT c.customer_unique_id,
    count(DISTINCT o.order_id) AS total_orders,
    sum(op.payment_value) AS total_revenue,
        CASE
            WHEN count(DISTINCT o.order_id) = 1 THEN 'Single Order'::text
            ELSE 'Repeat Customer'::text
        END AS customer_type
   FROM customers c
     JOIN orders o ON c.customer_id::text = o.customer_id::text
     JOIN order_payments op ON o.order_id::text = op.order_id::text
  WHERE o.order_status::text = 'delivered'::text
  GROUP BY c.customer_unique_id;