-- public.revenue_by_state source

CREATE OR REPLACE VIEW public.revenue_by_state
AS WITH total_order_value AS (
         SELECT op.order_id,
            sum(op.payment_value) AS total_order_value
           FROM order_payments op
          GROUP BY op.order_id
        )
 SELECT c.customer_state,
    'Brazil'::text AS country,
    count(DISTINCT o.order_id) AS num_orders,
    sum(tov.total_order_value) AS revenue,
    round((sum(tov.total_order_value) / NULLIF(count(DISTINCT o.order_id), 0)::double precision)::numeric, 2) AS avg_order_value
   FROM customers c
     JOIN orders o ON c.customer_id::text = o.customer_id::text
     JOIN total_order_value tov ON o.order_id::text = tov.order_id::text
  WHERE o.order_status::text = 'delivered'::text
  GROUP BY c.customer_state
  ORDER BY (sum(tov.total_order_value)) DESC;