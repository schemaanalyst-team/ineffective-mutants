This repository contains replication materials for the paper 

*"Automatic Detection and Removal of Ineffective Mutants for the Mutation Analysis of Relational Database Schemas"*

More information will be made available following publication of the paper.

In the meantime, contact:
Phil McMinn: p.mcminn@sheffield.ac.uk
Gregory Kapfhammer: gkapfham@allegheny.edu

#Details on each script

###_diff_mutants.rb
Finds mutants in the "mutants" directory for one DBMS but not another

###_validate_files.rb
Runs various validation scripts

###generate_mutant_totals_tables.rb
Generates the produced, still-born, impaired, equiv and redundant mutant tables by schema and by operator

###generate_stillborn_mutant_time_tables.rb
Generates the table showing the time taken to detect stillborn mutants using the DBMS, using the DBMS with transactions, using static analysis. Note that "stillborn" is currently impaired mutants for SQLite.

###generate_mutation_score_by_total_schema_changes_table.rb
Generates the table showing how many schemas experienced a change in mutation score moving from one pool to the next.

###generate_mutation_score_tables.rb
Generates the mutation score tables in the paper

###generate_mutant_type_by_schema_totals_table.rb
Generates the table showing the total number of schemas with a particular mutant type

###generate_mutation_time_tables.rb
Generates the mutation time tables in the paper

###generate_live_mutant_table.rb
Generates the table showing the remaining live mutants by schema and operator
