def get_order(a,b)
  if a < b
    :asc
  elsif a > b
    :desc
  else
    nil
  end
end

def identify_bad_levels(report)
  main_order = nil
  report.each_with_index do |level, i|
    next_level = report[i+1]
    next if next_level.nil?

    difference = level - next_level
    if difference == 0
      report[i] = nil 
      next
    end

    main_order = get_order(level, next_level) if main_order.nil?
    current_order = get_order(level, next_level)

    if main_order != current_order
      report[i] = nil 
      next
    end

    if difference < -3 || difference > 3
      report[i] = nil 
      next
    end
  end

  p "report", report
  report
end

File.readlines("input", chomp: true)
  .map { |report| report.split(" ").map(&:to_i) }
  .then do |reports|
    reports.map! { |report| identify_bad_levels(report) }

    safe_reports = reports.select { |report| !report.include?(nil) }

    p "safe reports", safe_reports.length
  end
