Details on each script
----------------------

_diff_mutants.rb
-- Description: finds mutants in the "mutants" directory for one DBMS but not another

_validate_files.rb
-- Description: runs various validation scripts

generate_mutant_totals_tables.rb
-- Description: generates the produced, still-born, impaired, equiv and redundant mutant tables by schema and by operator

generate_stillborn_mutant_time_tables.rb
-- Description: the time taken to detect stillborn mutants using the DBMS, using the DBMS with transactions, using static analysis. Note that "stillborn" is currently impaired mutants for SQLite.

generate_mutation_score_by_total_schema_changes_table.rb
-- Description: generates table showing how many schemas experienced a change in mutation score moving from one pool to the next.

generate_mutation_score_tables.rb
-- Description: generates the mutation score tables in the paper

generate_mutant_type_by_schema_totals_table.rb
-- Description: generate the table showing the total number of schemas with a particular mutant type

generate_mutation_time_tables.rb
-- Description: generates the mutation time tables in the paper

generate_live_mutant_table.rb
-- Description: generates the table showing the remaining live mutants by schema and operator


