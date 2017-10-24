require 'z3'

class Sudoku
  def initialize(*puzzle)
    @solver = Z3::Solver.new
    @cells = (0..8).map do |row|
      (0..8).map do |cell|
        Z3.Int "cell #{row+1} #{cell+1}"
      end
    end
    @cells.flatten.each do |cell|
      @solver.assert cell >= 1
      @solver.assert cell <= 9
    end
    @cells.transpose.each do |col|
      @solver.assert Z3.Distinct(*col)
    end
    @cells.each do |row|
      @solver.assert Z3.Distinct(*row)
    end
    @cells.each_slice(3).each do |three_rows|
      three_rows.transpose.each_slice(3).each do |square|
        @solver.assert Z3.Distinct(*square.flatten)
      end
    end
    puzzle.each_with_index do |row, row_pos|
      row.each_with_index do |cell, cell_pos|
        @solver.assert @cells[row_pos][cell_pos] == cell.to_i unless cell == '_'
      end
    end
  end

  def print_solution
    puts 'Impossible' unless @solver.check == :sat
    solutions = @cells.map do |row|
      row.map { |c| @solver.model[c] }
    end
    solutions.each_with_index do |row, row_pos|
      row.each_with_index do |cell, cell_pos|
        print "#{cell}"
        print (cell_pos == 2 || cell_pos == 5) ? ' | ' : ' '
      end
      print "\n"
      puts "------+-------+------" if (row_pos == 2 || row_pos == 5)
    end
  end
end

sudoku_data = File.open('first.sudoku').read.split("\n").map(&:split)
sud = Sudoku.new(*sudoku_data)
sud.print_solution
