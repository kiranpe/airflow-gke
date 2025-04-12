from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'example_hello_world',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False,
    tags=['example'],
) as dag:

    hello = BashOperator(
        task_id='say_hello',
        bash_command='echo "Hello from Airflow on GKE!"'
    )
