
-- BigQuery Billing Export: airflow_cost_by_service.sql
-- Adjust `project.dataset.table` to match your billing export table

SELECT
  service.description AS service,
  sku.description AS sku,
  project.id AS project_id,
  ROUND(SUM(cost), 2) AS total_cost_usd,
  ROUND(SUM(usage.amount), 2) AS total_usage,
  usage.unit AS usage_unit,
  FORMAT_DATE('%Y-%m-%d', usage_start_time) AS usage_date
FROM
  `your-billing-project.your_dataset.gcp_billing_export_v1_XXXXXX`
WHERE
  project.id = "your-airflow-project-id"
  AND usage_start_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY
  service, sku, project_id, usage_unit, usage_date
ORDER BY
  total_cost_usd DESC
