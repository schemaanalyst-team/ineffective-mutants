# Introduction

This repository contains replication materials for the paper *"Automatic
Detection and Removal of Ineffective Mutants for the Mutation Analysis of
Relational Database Schemas"*. If you would like to learn more about this paper,
then please contact one or both of the paper's lead authors, [Phil
McMinn](http://mcminn.io/) and [Gregory M.
Kapfhammer](http://www.cs.allegheny.edu/sites/gkapfham/). When possible and as
needed, these lead authors will update this repository with additional details.
For now, the remainder of this documentation furnishes an overview of the key
scripts and the artifacts arising from a manual analysis completed by the
paper's first author.

## Creating Data Tables with the Ruby Scripts

These Ruby scripts were developed on MacOS, tested on Ubuntu 16.04, and run with
the `ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]` version of Ruby. The script
called `ruby/generate_all.rb` will automatically generate all of the data tables
presented in the aforementioned research paper. For instance, you could run this
script by typing the following command in your terminal window: `ruby
generate_all.rb`. Here are some more details about the most important scripts:

- `generate_mutant_totals_tables.rb`: Generates the produced, stillborn,
  impaired, equivalent, and redundant mutant tables by schema and by operator.

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

- `generate_mutation_time_tables.rb`: Generates the mutation analysis time tables.

- `generate_live_mutant_table.rb`: Generates the table showing the remaining
  live mutants by schema and operator.

- `_diff_mutants.rb`: Finds mutants in the "mutants" directory for one DBMS but
  not another.

- `_validate_files.rb`: Runs the other scripts that perform various validation
  checks.

## Test Suites Supporting the Manual Analysis of Mutants

One contribution of this paper's empirical study is a manual classification of
mutants, so as to ensure that the automatic characterization was correct. The
artifacts resulting from this analysis of these mutants was a collection of
JUnit test suites that could be automatically re-run. Each of these JUnit test
files follows a common pattern. For instance,
`WordNet_HyperSQL_22w85_REDUNDANT.java` first creates, connects to, and
configures a HyperSQL relational database management system. Since it is
specifically concerned with analyzing a mutant for the `WordNet` schema that is
a part of the experimental study it contains a `getSchemaName()` that returns
this schema's name.

It also contains methods that return the unique mutant identifier for this
specific mutant. Additionally, it contains a series of `INSERT` statements that
add data to certain tables of the `WordNet` database. Since this specific mutant
is redundant, it is illustrative to look at the `public void isRedundant()
throws SQLException` method and study both the JUnit assertions and the
experimenter's comments about why the mutant is redundant. Ultimately, you will
see that this Java file contains the following source code comment containing
the verdict of the manual analysis: `// ENTER END VERDICT (delete as
appropriate): redundant`.

## Additional Scripts and Data Files

The `r/R` directory contains scripts, written in the R language for statistical
computation, that we used to verify the results produced by the Ruby scripts.
Additionally, the `r/graphics` directory contains the PDFs of graphs that we
used to verify the results presented in the paper's tables. Ultimately, we
determined that the tables furnished a more compact and useful representation of
the data and thus we opted not to include them in the published paper. Finally,
the `raw-data` directory contains all of the `.dat` files that contain the raw
data resulting from running the experiments.

## Problems or Praise

If you have any problems with replicating the experimental results in this
paper, then please create an issue associated with this Git repository using the
"Issues" link at the top of this site. The contributors to this replication
package will do all that they can to resolve your issue and ensure that the
all of the scripts in this analysis package work correctly.
