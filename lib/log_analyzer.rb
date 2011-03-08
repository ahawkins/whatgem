class LogAnalyzer 
  TEST_UNIT_REGEX = /\d+ tests, \d+ assertions, \d+ failures, \d+ errors, \d+ skips/
  RSPEC_REGEX = /\d+ examples, \d+ failures, \d+ pending/

  def self.pass_rate(log)
    if log.blank?
      0.0
    elsif log.match TEST_UNIT_REGEX
      test_unit_results(log)
    elsif log.match RSPEC_REGEX
      rspec_results(log)
    else
      0.0
    end
  end

  private
  def self.test_unit_results(log)
    total_tests = log.match(/(\d+) tests/)[1].to_f
    failed_tests = log.match(/(\d+) failures/)[1].to_f
    error_tests = log.match(/(\d+) errors/)[1].to_f


    (total_tests - failed_tests - error_tests) / total_tests
  end

  def self.rspec_results(log)
    total_tests = log.match(/(\d+) examples/)[1].to_f
    failed_tests = log.match(/(\d+) failures/)[1].to_f

    (total_tests - failed_tests) / total_tests
  end
end
