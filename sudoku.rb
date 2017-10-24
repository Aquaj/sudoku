require 'z3'

class Sudoku
  def initialize(*puzzle)
    @solver = Z3.solver
    @cells = (0..8).map do |row|
      (0..8).map do |cell|
        Z3.Int "cell #{row+1} #{cell+1}"
      end
    end
    @cells.flatten.each do |cell|

    end
  end

  def print_solution

  end
end

sudoku_data = File.open('first.sudoku').read.split("\n").map(&:split)
sud = Sudoku.new(sudoku_data)
sud.print_solution
