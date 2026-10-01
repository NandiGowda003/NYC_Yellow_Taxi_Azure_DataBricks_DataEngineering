# NYC Yellow Taxi — Azure Data Engineering

End-to-end Azure data engineering project processing NYC Yellow Taxi data using Azure Data Factory, ADLS Gen2, Azure Databricks, Azure SQL Database, REST API enrichment and Power BI.

The project focuses on production-oriented **incremental ingestion, watermarking, control tables, data quality, SCD Type 2, idempotent processing and analytics**.

---

## Architecture

```text
NYC TLC
   │
   ▼
Azure Data Factory
   │
   ▼
ADLS Gen2
Bronze
   │
   ▼
Azure Databricks
Silver
   │
   ▼
Azure Databricks
Gold
   │
   ├──────────────► Power BI
   │
   ▼
Analytics Marts

Azure SQL Database
(Control + Watermark + Audit)

Currency REST API
       │
       ▼
Reference / Gold Enrichment
```

## Tech Stack
| Technology         | Purpose                               |
| ------------------ | ------------------------------------- |
| Azure Data Factory | Incremental ingestion & orchestration |
| ADLS Gen2          | Data lake storage                     |
| Azure Databricks   | PySpark transformations               |
| Delta Lake         | Gold storage                          |
| Azure SQL Database | Control, watermark & audit            |
| REST API           | Currency enrichment                   |
| Power BI           | Analytics & visualization             |
| GitHub             | Source control                        |
| GitHub Actions     | CI validation                         |


## Data Coverage
### January 2026 → July 2026

#### Source:
NYC Taxi & Limousine Commission Yellow Taxi trip data.
Monthly Parquet files are processed incrementally rather than loading the entire dataset repeatedly.

## Data Architecture
### Bronze

Raw Yellow Taxi files are stored by year and month.

### Silver
* PySpark transformations include:
* Column standardization
* Data type handling
* Derived trip metrics
* Data quality validation
* Duplicate removal
* Invalid-record quarantine
* Source lineage

### Gold
Analytics-ready Delta datasets include:
* Taxi trip fact
* Taxi zone SCD Type 2 dimension
* Daily taxi metrics
* Zone performance
* Payment performance
* Currency-enriched metrics

## Incremental Processing

ADF uses Azure SQL control tables and a watermark to identify the next source period to process.

```text
Control Table
     ↓
Watermark Check
     ↓
Next Pending Month
     ↓
Bronze
     ↓
Silver
     ↓
Gold
     ↓
Success
     ↓
Update Watermark
```


## Idempotency
Before writing to Gold, the incremental process checks whether the source period already exists.

```text
Source Period
     │
     ▼
Already in Gold?
   /       \
 Yes       No
  │         │
 Skip      Append
This prevents duplicate processing when a month is retried.
```

## Data Quality
The Silver layer validates records and separates invalid data into quarantine storage.

#### Examples:
* Invalid trip duration
* Negative fare
* Negative total amount
* Duplicate records
* Invalid records

#### For July 2026:
Source rows       : 3,530,109
Valid Silver rows : 3,473,063
Quarantined rows  :    57,046

## SCD Type 2
The Taxi Zone dimension implements SCD Type 2 using:

#### Surrogate key
* Effective-from date
* Effective-to date
* Current-row flag
* Record hash

#### Initial reference dataset:
265 taxi zones

## API Enrichment
A currency REST API provides daily USD → INR exchange rates.
The rates are used to create a currency-enriched Gold dataset for revenue analysis.

## Power BI
The published Power BI report contains:

#### Executive Overview
* Total trips
* Total revenue
* Average fare
* Average trip distance
* Daily trends

#### Zone Analysis
* Pickup zone performance
* Revenue by zone
* Passenger volume
* Zone map

#### Financial & Payment Analysis
* USD revenue
* INR revenue
* Exchange-rate trend
* Revenue by payment type
* Payment-type share

#### Pickup Zone Map
* NYC taxi zone boundaries
* Trips by pickup zone
* Custom GeoJSON Shape Map

## Key Engineering Concepts
* Incremental batch processing
* Metadata-driven orchestration
* Watermarking
* Control tables
* Pipeline auditing
* Failure handling
* Idempotency
* Medallion Architecture
* PySpark
* Delta Lake
* Data Quality
* Data Quarantine
* SCD Type 2
* REST API integration
* Power BI
* GitHub Actions / CI

## Results

The pipeline processes approximately 25.9 million valid taxi trips across the January–July 2026 dataset.

### The final solution provides:

#### Source → Incremental Ingestion → Data Lake → Spark Transformation → Gold Marts → Power BI

with control, watermark, audit and data-quality mechanisms supporting the pipeline.

## Future Enhancements
* Automated source discovery
* Additional TLC datasets
* Expanded automated data-quality tests
* Production monitoring and alerting
* Automated ADF and Databricks deployment
* Additional API enrichment

## Disclaimer

This is an independent portfolio project using publicly available NYC TLC data for demonstration.
