require_relative 'include/common'
require_relative 'include/ineffective_mutant_types_data_file'
require_relative 'include/mutation_analysis_data_file'

dbmses.each do |dbms|
  imdf = IneffectiveMutantsDataFile.new(dbms)
  madf = MutationAnalysisDataFile.new(dbms, 'avmdefaults')

  schemas.each do |schema|
    puts "Checking #{schema} with #{dbms}"

    mutants = imdf.count_for(schema)
    num_impaired = mutants[:impaired]
    num_equivalent = mutants[:equivalent]
    num_redundant = mutants[:redundant]

    minus_all = madf.mutation_scores(schema, Mode::ALL)
    minus_i = madf.mutation_scores(schema, Mode::MINUS_I)
    minus_ie = madf.mutation_scores(schema, Mode::MINUS_IE)
    minus_ier = madf.mutation_scores(schema, Mode::MINUS_IER)

    # IMPAIRED MUTANT CHECK
    # impaired mutants should always be easily killed, so this check should always pass
    for n in 0..minus_i.length-1
      run_before = minus_all[n]
      run_after = minus_i[n]

      denominator_before = run_before[:total].to_i
      denominator_after = run_after[:total].to_i

      denominator_reduced = denominator_before == (denominator_after + num_impaired)

      if (!denominator_reduced)
        puts "IMPAIRED mutant DENOMINATOR check failed for #{schema} with #{dbms} with run #{n}"
        puts "-- denominator before: #{denominator_before}"
        puts "-- denominator after: #{denominator_after}"
        puts "-- num impaired: #{num_impaired}"
      end

      numerator_before = run_before[:killed].to_i
      numerator_after = run_after[:killed].to_i
      numerator_reduced = numerator_before == (numerator_after + num_impaired)

      if (!numerator_reduced)
        puts "IMPAIRED mutant NUMERATOR check failed for #{schema} with #{dbms} with run #{n}"
        puts "-- numerator before: #{numerator_before}"
        puts "-- numerator after: #{numerator_after}"
        puts "-- num impaired: #{num_impaired}"
      end
    end

    # EQUIVALENT MUTANT CHECK
    # equivalent mutants will always be live, so this check should always pass
    for n in 0..minus_i.length-1
      run_before = minus_i[n]
      run_after = minus_ie[n]

      denominator_before = run_before[:total].to_i
      denominator_after = run_after[:total].to_i

      denominator_reduced = denominator_before == (denominator_after + num_equivalent)

      if (!denominator_reduced)
        puts "EQUIVALENT mutant DENOMINATOR check failed for #{schema} with #{dbms} with run #{n}"
        puts "-- denominator before: #{denominator_before}"
        puts "-- denominator after: #{denominator_after}"
        puts "-- num equivalent: #{num_equivalent}"
      end

      numerator_before = run_before[:killed].to_i
      numerator_after = run_after[:killed].to_i
      numerator_same = numerator_before == numerator_after

      if (!numerator_same)
        puts "EQUIVALENT mutant NUMERATOR check failed for #{schema} with #{dbms} with run #{n}"
        puts "-- numerator before: #{numerator_before}"
        puts "-- numerator after: #{numerator_after}"
      end
    end

    # REDUNDANT MUTANT CHECK
    # can raise false positives. If all pass then it doesn't really tell us anything other than the redundant mutants are easy to kill...
    for n in 0..minus_ie.length-1
      run_before = minus_ie[n]
      run_after = minus_ier[n]

      denominator_before = run_before[:total].to_i
      denominator_after = run_after[:total].to_i

      denominator_reduced = denominator_before == (denominator_after + num_redundant)

      if (!denominator_reduced)
        puts "REDUNDANT mutant DENOMINATOR check failed for #{schema} with #{dbms} with run #{n}"
        puts "-- denominator before: #{denominator_before}"
        puts "-- denominator after: #{denominator_after}"
        puts "-- num redundant: #{num_redundant}"
      end

      numerator_before = run_before[:killed].to_i
      numerator_after = run_after[:killed].to_i
      numerator_reduced = numerator_before == (numerator_after + num_redundant)

      if (!numerator_reduced)
        puts "REDUNDANT mutant NUMERATOR check failed for #{schema} with #{dbms} with run #{n}"
        puts "-- numerator before: #{numerator_before}"
        puts "-- numerator after: #{numerator_after}"
        puts "-- num redundant: #{num_redundant}"
      end
    end
  end
end