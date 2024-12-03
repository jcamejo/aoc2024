def get_order(report)
  report[0] > report[1] ? :desc : :asc
end

def valid_level?(report, current_level, next_level)
  return true if next_level.nil?

  difference = current_level - next_level

  return false if difference == 0

  main_order = get_order(report)

  return true if main_order == :asc && difference.between?(-3, -1)
  return true if main_order == :desc && difference.between?(1, 3)

  false
end

def all_valid?(report)
  match_valid(report).all?
end

def match_valid(report)
  new_report = []

  report.each_with_index do |level, i| 
    new_report << valid_level?(report, level, report[i+1])
  end

  new_report
end

def check_report(report, stack: 0, max_level: 2)
  return false if stack == max_level

  return true if all_valid?(report)

  return false if stack+1 == max_level

  report.each_with_index do |level, i|
    new_report = report.dup.tap{|r| r.delete_at(i) }

    return true if check_report(new_report, stack: stack+1)
  end

  false
end

File.readlines("input", chomp: true)
  .map { |report| report.split(" ").map(&:to_i) }
  .then do |reports|
    safe_reports = reports.select do |report| 
      check_report(report, max_level: 1)
    end

    safe_reports_with_damper = reports.select do |report| 
      check_report(report)
    end


    # Task 1
    pp safe_reports.length

    # Task 2
    pp safe_reports_with_damper.length
  end
