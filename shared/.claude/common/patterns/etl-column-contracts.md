# ETL Column Contracts

A pattern for maintaining schema contracts between external data sources and target databases in ETL pipelines.

**Applies to**: ETL pipelines where each API report (or external data source) maps 1:1 to a database table with no transformation beyond column renaming.

## The Problem

A pipeline that fetches from an external API and writes to a database needs to maintain a mapping between source column names and target column names. The naive approach is separate dictionaries for column maps, report config, column lists, and table names. These proliferate quickly and all describe the same underlying relationship but must stay in sync manually.

## The Pattern

Consolidate all schema knowledge into a single model class per table. The model is the contract: it defines the target table name, target column names and types, source API column names, and any vendor-specific config needed to fetch data. Everything else is derived from the model at runtime.

### Core Principles

- **Single source of truth**: one object owns all knowledge about a table, its columns, and how they map to the data source. No parallel structures to keep in sync.
- **Metadata on the column, not beside it**: the API name lives on the column definition itself, not in a separate dict keyed by table name. Adding or removing a column is a one-line change, not a coordinated edit across multiple structures.
- **Derivation over declaration**: column maps, API column lists, and report config are computed from the model at runtime. The same information is never declared twice.
- **Convention over configuration**: use well-known ORM conventions (table name on the class, columns as attributes) so the pattern is immediately recognizable to backend developers.

### When This Works

The mapping between source and target is 1:1: each API report maps directly to one database table. The only transformation is column renaming.

### When This Breaks

If the API shape and database shape diverge (computed columns, multiple sources writing to one table, reshaping rows), the model can't represent both sides. In that case, split into separate source and target models with an explicit mapper between them.

## Structure

Each model class carries:

1. **Table identity**: name and schema of the target table
2. **Column definitions**: name, type, and nullability in the target database
3. **Source mapping**: each column carries metadata linking it to the corresponding field name in the source API
4. **Vendor config**: class-level attributes for any source-specific settings (report type identifiers, API parameters, date granularity)

Helper functions derive useful structures from the model:

- **Column map**: `{api_field: db_column}` dict, built by iterating the model's columns and reading their source metadata
- **API column list**: the list of field names to request from the source API, extracted from the same metadata
- **DDL generation**: the model's column definitions can generate `CREATE TABLE` statements for the target database

## Example (Python / SQLAlchemy)

```python
class AdPerformance(Base):
    __tablename__ = "AD_PERFORMANCE"
    __table_args__ = {"schema": "AD_MICROSOFT"}

    # Vendor-specific config
    __report_type__ = "AdPerformanceReportRequest"
    __report_column_type__ = "AdPerformanceReportColumn"

    # Columns: DB name as attribute, API name in info dict
    date = Column(Date, nullable=False, info={"api": "TimePeriod"})
    account_id = Column(BigInteger, nullable=False, info={"api": "AccountId"})
    campaign_name = Column(String, info={"api": "CampaignName"})
    impressions = Column(BigInteger, info={"api": "Impressions"})
    clicks = Column(BigInteger, info={"api": "Clicks"})
    spend = Column(Numeric(18, 6), info={"api": "Spend"})
```

The `info={"api": "..."}` dict is the ORM's official extension point for arbitrary column metadata. It is ignored by the ORM engine but accessible at runtime.

Helper to derive the column map:

```python
def column_map(model):
    return {
        col.info["api"]: col.name
        for col in model.__table__.columns
        if "api" in col.info
    }
```

This replaces a hand-maintained dictionary that would need updating every time a column is added, renamed, or removed.

## Language-Agnostic Takeaway

The specific ORM is not the point. The pattern works in any language with a model/schema layer:

1. Define a class or struct per target table
2. Attach source field metadata to each column definition (annotations, decorators, attribute metadata, whatever the ORM provides)
3. Write small utility functions that derive mappings from the model at runtime
4. Attach vendor-specific config as class-level constants

The result is a single file you can hand to a new developer and say "this is the complete contract for this table: where the data comes from, what it's called in our database, and how to fetch it."
