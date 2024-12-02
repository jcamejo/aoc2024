File.readlines("input", chomp: true)
  .map { |location| location.split(" ").map(&:to_i) }
  .then do |location| 
    left_list = location.map(&:first).sort
    right_list = location.map(&:last).sort

    # Task 1
    sorted_locations = left_list.zip(right_list)
    differences = sorted_locations.sum { |location| location.sort { |a,b| b <=> a }.reduce(:-) }

    p "differences", differences

    # Task 2
    match_map = right_list.group_by { |i| i }.transform_values { |matches| matches.length }
    similarity_score = left_list.sum { |n| p n; n * match_map.fetch(n,0) }

    p "similarity", similarity_score
  end


