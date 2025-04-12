
# GCP Airflow Cost Dashboard

This setup provides a cost visibility dashboard using:

- **BigQuery Billing Export**
- **Looker Studio (formerly Data Studio)** or Google Sheets

## Setup Steps

1. **Enable Billing Export to BigQuery**
   - In GCP Console: Billing > Settings > Export > BigQuery export
   - Choose or create a dataset (e.g., `billing.airflow_costs`)

2. **Update the Query**
   - Replace:
     - `your-billing-project` with billing export project
     - `your_dataset` with dataset name
     - `your-airflow-project-id` with your actual project ID

3. **Create a Scheduled Query**
   - In BigQuery UI > Scheduled Queries
   - Run daily and export to a table/view for reporting

4. **Visualize**
   - Use Google Looker Studio
   - Connect your BigQuery table
   - Build visuals: cost per service, daily usage trends, alerts

## Optional

- Add thresholds to detect high costs or anomalies
- Export summaries to GCS or send via Pub/Sub to alerting pipeline
