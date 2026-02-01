import json
import os
import boto3
import csv
from io import StringIO
import pg8000.dbapi as pg
from datetime import datetime
 
def lambda_handler(event, context):
 
    # ---- Read environment variables ----
    host = os.environ["DB_HOST"]
    port = int(os.environ["DB_PORT"])
    database = os.environ["DB_NAME"]
    user = os.environ["DB_USER"]
    password = os.environ["DB_PASSWORD"]
    bucket = os.environ["S3_BUCKET"]
 
    # ---- Connect to PostgreSQL (RDS) ----
    conn = pg.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password
    )
 
    cursor = conn.cursor()
 
    # Your business query
    query = """
    SELECT
    o.orderid,
    c.customername,
    p.productname,
    oli.quantity,
    oli.rate,
    oli.amount,
    o.totalamount,
    o.createdon
FROM public.ordertransaction o
JOIN public.customer c ON o.customerid = c.customerid
JOIN public.orderlineitems oli ON o.orderid = oli.orderid
JOIN public.product p ON oli.productid = p.productid
ORDER BY o.orderid;
"""
 
    cursor.execute(query)
    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    print("Total rows fetched:" , len(rows))
    # ---- Convert to CSV in memory ----
    csv_buffer = StringIO()
    writer = csv.writer(csv_buffer)
    writer.writerow(columns)
    writer.writerows(rows)
 
    # ---- Upload to S3 ----
    s3 = boto3.client("s3")
    file_key = f"sales/etl_output_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.csv" 

    s3.put_object(
        Bucket=bucket,
        # Key="etl_output.csv",
        Key = file_key,
        Body=csv_buffer.getvalue()
    )
 
    cursor.close()
    conn.close()
 
    return {
        "status": "success",
        "message": "ETL completed and CSV uploaded to S3",
        "rows": len(rows)
    }