-- public.monthly_revenue source

CREATE OR REPLACE VIEW public.monthly_revenue
AS WITH orders_with_month AS (
         SELECT o.order_id,
            date_trunc('month'::text, o.order_purchase_timestamp)::date AS order_month,
            to_char(o.order_purchase_timestamp, 'Mon YYYY'::text) AS order_month_label
           FROM orders o
          WHERE o.order_status::text = 'delivered'::text
        ), total_order_value AS (
         SELECT op.order_id,
            sum(op.payment_value) AS total_order_value
           FROM order_payments op
          GROUP BY op.order_id
        ), combined AS (
         SELECT owm.order_id,
            owm.order_month,
            owm.order_month_label,
            tov.total_order_value
           FROM orders_with_month owm
             JOIN total_order_value tov ON owm.order_id::text = tov.order_id::text
        )
 SELECT order_month,
    order_month_label,
    count(order_id) AS num_orders,
    sum(total_order_value) AS revenue
   FROM combined
  GROUP BY order_month, order_month_label
  ORDER BY order_month;