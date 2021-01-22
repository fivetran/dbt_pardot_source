# Pardot (Source)

This package models Pardot data from [Fivetran's connector](https://fivetran.com/docs/applications/pardot). It uses data in the format described by [the Pardot ERD](https://docs.google.com/presentation/d/1YQquOmlb7pIMI1Tcc2Qcner4rSCI8RYdrie1DRkJzds/edit#slide=id.g244d368397_0_1).

This package enriches your Fivetran data by doing the following:

* Adds descriptions to tables and columns that are synced using Fivetran
* Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
* Models staging tables, which will be used in our transform package

## Models

This package contains staging models, designed to work simultaneously with our [Pardot modeling package](https://github.com/fivetran/dbt_pardot). The staging models are designed to:

* Remove any rows that are soft-deleted
* Name columns consistently across all packages:
  * Boolean fields are prefixed with `is_` or `has_`
  * Timestamps are appended with `_timestamp`
  * ID primary keys are prefixed with the name of the table. For example, the prospect table's ID column is renamed `prospect_id`.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration

### Source data location

By default, this package will look for your Pardot data in the `pardot` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Pardot data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  pardot_source:
    pardot_database: your_database_name
    pardot_schema: your_schema_name 
```

### Passthrough Columns

By default, the package includes all of the standard columns in the `stg_pardot__prospect` model. If you want to include custom columns, configure them using the `prospect_passthrough_columns` variable:

```yml
# dbt_project.yml

...
vars:
  pardot_source:
    prospect_passthrough_columns: ["custom_creative","custom_contact_state"]
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn more about Fivetran [in the Fivetran docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
