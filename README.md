# Pardot Source dbt Package ([Docs](https://fivetran.github.io/dbt_pardot_source/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_pardot_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

## What does this dbt package do?
- Materializes [Pardot staging tables](https://fivetran.github.io/dbt_pardot_source/#!/overview/pardot_source/models/?g_v=1) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/pardot/#schemainformation). These staging tables clean, test, and prepare your Pardot data from [Fivetran's connector](https://fivetran.com/docs/applications/pardot) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Pardot data through the [dbt docs site](https://fivetran.github.io/dbt_pardot_source/).
- These tables are designed to work simultaneously with our [Pardot transformation package](https://github.com/fivetran/dbt_pardot).

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Pardot connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Step 2: Install the package (skip if also using the `pardot` transformation package)
If you  are **not** using the [Pardot transformation package](https://github.com/fivetran/dbt_pardot), include the following package version in your `packages.yml` file. If you are installing the transform package, the source package is automatically installed as a dependency.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/pardot_source
    version: [">=0.6.0", "<0.7.0"]
```
### Step 3: Define database and schema variables
By default, this package runs using your destination and the `pardot` schema. If this is not where your Pardot data is (for example, if your Pardot schema is named `pardot_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  pardot_source:
    pardot_database: your_database_name
    pardot_schema: your_schema_name 
```

### (Optional) Step 4: Additional configurations
<details><summary>Expand to view configurations</summary>

#### Changing the Build Schema
By default this package will build the Pardot staging models within a schema titled (<target_schema> + `_stg_pardot`). If this is not where you would like your Pardot staging models to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
models:
  pardot_source:
    +schema: my_new_staging_models_schema # leave blank for just the target_schema
```
#### Passthrough Columns
By default, the package includes all of the standard columns in the `stg_pardot__prospect` model. If you want to include custom columns, configure them using the `prospect_passthrough_columns` variable:

```yml
vars:
  pardot_source:
    prospect_passthrough_columns: ["custom_creative","custom_contact_state"]
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_pardot_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    pardot_<default_source_table_name>_identifier: your_table_name 
```
</details>

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/pardot_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_pardot_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) to learn how to contribute to a dbt package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_pardot_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
