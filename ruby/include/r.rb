## This Ruby library requires Rserve
##
## You will need to install the rserve-client gem, i.e. 'gem install rserve-client'
## (For JRuby you may also need to gem install spoon)
##
## On the R side, go to the R Package Installer and install Rserve
## Then, open an R connection as follows
##
## > library(Rserve)
## Then
## > Rserve()
## or
## Rserve(args="--no-save")
##
## The ruby line
## 'puts $r.eval('x<-c(1)').as_doubles'
## can be used as a simple test that everything works.

require 'rserve'

def r_init(debug=false)
  $r = Rserve::Connection.new
  $r_debug = debug
  r_eval 'source(file="' + File.dirname(__FILE__) + '/a12test.R")'
end

def r_eval(r_code)
  puts r_code if $r_debug
  $r.eval(r_code)
end

def r_as_double(r_code)
  puts r_code if $r_debug
  $r.eval(r_code).as_doubles[0]
end

def r_as_string(r_code)
  puts r_code if $r_debug
  $r.eval(r_code).as_string
end

def r_as_boolean(r_code)
  puts r_code if $r_debug
  return $r.eval(r_code).as_string == "TRUE"
end

def mean(values) 
  values_r = 'c(' + values.join(',') + ')';
  r_as_double "mean(#{values_r})" 
end

def sd(values) 
  values_r = 'c(' + values.join(',') + ')';
  r_as_double "sd(#{values_r})" 
end

def wilcox_test(values1, values2, paired=false)
  values_r1 = 'c(' + values1.join(',') + ')';
  values_r2 = 'c(' + values2.join(',') + ')';

  paired_string = paired ? ", paired = TRUE" : "" 

  p_value = r_as_double "x<-wilcox.test(#{values_r1}, #{values_r2}#{paired_string})$p.value"  
  side = r_as_boolean("mean(#{values_r1}) < mean(#{values_r2})") ? 1 : 2
  side = r_as_boolean("mean(#{values_r1}) == mean(#{values_r2})") ? 0 : side
  {
      p_value: p_value,
      side: side
  }
end

def a12_test(values1, values2)
  values_r1 = 'c(' + values1.join(',') + ')';
  values_r2 = 'c(' + values2.join(',') + ')';

  r_eval "result <- a.test(#{values_r1}, #{values_r2})"
  value = r_as_double 'result$value'
  size = r_as_string 'result$size'
  side = 0
  side = 1 if value < 0.5
  side = 2 if value > 0.5

  {
      value: value,
      size: size,
      side: side
  }
end

def fisher_test(successes1, successes2, total)
  failures1 = total - successes1
  failures2 = total - successes2

  p_value = r_as_double "fisher.test(rbind(c(#{successes1},#{failures1}), c(#{successes2}, #{failures2})))$p.value"
  side = (successes1 > successes2) ? 1 : 2
  side = (successes1 == successes2) ? 0 : side
  {
      p_value: p_value,
      side: side
  }
end

r_init
