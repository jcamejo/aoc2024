ordering_rules = []
page_updates = []
nodes = []

File.readlines("input", chomp: true).map do |line|
  if line.include?("|")
    ordering_rules << line.split("|").map(&:to_i)
  end

  if line.include?(",")
    page_updates << line.split(",").map(&:to_i)
  end
end

class Node
  attr_reader :number, :parents, :children

  def initialize(number)
    @number = number
    @children = []
    @parents = []
  end

  def add_children(node)
    @children << node unless @children.find { |child| self == node }
  end

  def add_parents(node)
    @parents << node unless @parents.find { |child| self == node }
  end

  def ==(node)
    number == node.number
  end

  def next_child(number)
    @children.find { |child| child.number == number }
  end

  def next_parent(number)
    @parents.find { |child| child.number == number }
  end
end

# Nodes
@nodes = ordering_rules.flatten.uniq.map { |number| Node.new(number) }

@nodes.each do |node|
  ordering_rules
    .select { |rule| rule.first == node.number }
    .map { |rule| rule[1] }
    .uniq
    .each { |number| node.add_children(@nodes.find { |node| node.number == number }) }

  ordering_rules
    .select { |rule| rule[1] == node.number }
    .map { |rule| rule[0] }
    .uniq
    .each { |number| node.add_parents(@nodes.find { |node| node.number == number }) }
end


def valid_children?(node, children)
  level = 0
  total_children = children.length

  return true if children.length == 0

  children.each do |number| 
    node = node.next_child(number)

    return false if node.nil?
    level += 1

    return true if level == total_children
  end

  false
end

def valid_parents?(node, parents)
  level = 0
  total_parents = parents.length

  return true if parents.length == 0


  parents.reverse_each do |number| 
    node = node.next_parent(number)

    return [number, false] if node.nil?
    level += 1

    return true if level == total_parents
  end
end

def valid_update?(page)
  valid_updates = []
  page.each_with_index do |page_number, i|
    node = @nodes.find { |node| node.number == page_number }
    childs = i == 0  ? page[1..] : page[i+1..]
    parents = i == 0 ? [] : page[0..(i-1)]

    valid_updates << valid_children?(node, childs) && valid_parents?(node, parents)
  end

  valid_updates.all?
end

valid_pages = page_updates.select { |page|  valid_update?(page) }
invalid_pages = page_updates.reject { |page|  valid_update?(page) }

middle_values = valid_pages.map do |page| 
  middle_index = (page.length / 2.0).round - 1

  page[middle_index]
end

p valid_pages.length
p invalid_pages.length
