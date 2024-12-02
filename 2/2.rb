def get_order(a,b)
  if a < b
    :asc
  elsif a > b
    :desc
  else
    nil
  end
end

def safe_report?(report)
  previous_level = nil
  main_order = nil

  outcome = report.all? do |level|
    if previous_level.nil?
      previous_level = level
      next true
    elsif previous_level == level
      next false
    elsif main_order.nil?
      main_order = get_order(previous_level, level)
      next true if main_order.nil?
    end

    current_order = get_order(previous_level, level)
    difference = previous_level - level

    puts "difference #{previous_level} - #{level}", difference

    if current_order == main_order && difference.between?(-3,3)
      previous_level = level
      next true
    else
      next false
    end
  end

  outcome
end

File.readlines("input", chomp: true)
  .map { |report| report.split(" ").map(&:to_i) }
  .then do |reports|
    safe_reports = reports.select { |report| safe_report?(report) }

    p "safe reports", safe_reports.length
  end
