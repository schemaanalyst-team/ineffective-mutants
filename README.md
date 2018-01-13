# Introduction

This repository contains replication materials for the paper *"Automatic
Detection and Removal of Ineffective Mutants for the Mutation Analysis of
Relational Database Schemas"*. If you would like to learn more about this paper,
then please contact one or both of the paper's leader authors, [Phil
McMinn](http://mcminn.io/) and [Gregory M.
Kapfhammer](http://www.cs.allegheny.edu/sites/gkapfham/). When possible, these
authors will update this repository with additional details. For now, the
remainder of this documentation furnishes an overview of the key scripts.

## Creating Data Tables with the Ruby Scripts

These Ruby scripts were developed on MacOS, tested on Ubuntu 16.04, and run with
the `ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]` version of Ruby. The script
called `ruby/generate_all.rb` will automatically generate all of the data tables
presented in the aforementioned research paper. For instance, you could run this
script by typing the following command in your terminal window: `ruby
generate_all.rb`. Here are some more details about these scripts:

- `_diff_mutants.rb`: Finds mutants in the "mutants" directory for one DBMS but
  not another.

- `_validate_files.rb`: Runs the other scripts that perform various validation
  checks.

- `generate_mutant_totals_tables.rb`: Generates the produced, stillborn,
  impaired, equivalent, and redundant mutant tables by schema and by operator

- `generate_stillborn_mutant_time_tables.rb`: Generates the table showing the
  time taken to detect stillborn mutants using the DBMS, using the DBMS with
  transactions, and through the use of static analysis. Note that "stillborn" is
  currently impaired mutants for the SQLite DBMS.

- `generate_mutation_score_by_total_schema_changes_table.rb`: Generates the
  table showing how many schemas experienced a change in mutation score moving
  from one pool to the next.

- `generate_mutation_score_tables.rb`: Generates the mutation score tables.

- `generate_mutant_type_by_schema_totals_table.rb`: Generates the table showing
  the total number of schemas with a particular type of mutant.

- `generate_mutation_time_tables.rb`: Generates the mutation analysis time tables,

- `generate_live_mutant_table.rb`: Generates the table showing the remaining
  live mutants by schema and operator.

## Problems or Praise

If you have any problems with replicating the experimental results in this
paper, then please create an issue associated with this Git repository using the
"Issues" link at the top of this site. The contributors to this replication
package will do all that they can to resolve your issue and ensure that the
all of the scripts in this analysis package work correctly.
