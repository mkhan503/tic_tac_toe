# module containing methods to run the game
module GridInputs
  
  private

  def input_symbols_in_grid(row, element, player)
    element = adjust_element_number(element)
    # if that block already has a symbol, then self.record_input
    if @grid[row][element].include?('X') || @grid[row][element].include?('O')
      puts 'Ooops! Looks like that cell is occupied! Enter another cell number'
      record_player_input(player)
    else
      @grid[row][element] = "  #{player.symbol}  "
      
    end
  end

  def adjust_element_number(num)
    case num
    when 1
      0
    when 3
      4
    else
      num
    end
  end

  def record_player_input(player)
    input = gets.chomp.split
    row = input[0].to_i
    element = input[1].to_i
    begin
      input_symbols_in_grid(row, element, player)
    rescue
      puts 'Enter a valid number for row and column i.e. between 1 and 3 inclusive.
            The two numbers must be seperated by a space'
      record_player_input(player)
    end
  end

  def check_result(player1, player2)
    check_all = {
                  1 => [[1, 1], [1, 2], [1, 3]],
                  2 => [[2, 1], [2, 2], [2, 3]],
                  3 => [[3, 1], [3, 2], [3, 3]],
                  4 => [[1, 1], [2, 1], [3, 1]],
                  5 => [[1, 2], [2, 2], [3, 2]],
                  6 => [[1, 3], [2, 3], [3, 3]],
                  7 => [[1, 1], [2, 2], [3, 3]],
                  8 => [[1, 3], [2, 2], [3, 1]]
                }

    check_all.each_value do |array|
      result_string = ''
      array.each do |element|
        element[1] = adjust_element_number(element[1])
        result_string << @grid[element[0]][element[1]]
      end

      result_string = result_string.gsub(/\s+/, '')
      occurance = symbol_occurance(result_string)

      if occurance == 3
        if result_string.chr == player1.symbol
          puts "#{player1.name} is the winner"
        else
          puts "#{player2.name} is the winner"
        end
        play_again?
        exit
      end
    end
  end

  def symbol_occurance(string)
    count = 0
    string.each_char do |char|
      count += 1 if char == string.chr
    end
    count
  end

  def play_again?
    puts 'Would you like to play again? Y or N?'
    answer = gets.chomp.upcase
    if answer == 'Y'
      Game.new
    else
      exit
    end
  end
end

# starting new game
class Game
  include GridInputs

  private

  def initialize
    @grid = {
              1 => ['     ', '|', '     ', '|', '     '],
              line1: ['_____|_____|_____'],
              2 => ['     ', '|', '     ', '|', '     '],
              line2: ['_____|_____|_____'],
              3 => ['     ', '|', '     ', '|', '     '],
              line3: ['     |     |     ']
            }
    initiate_players
  end

  def initiate_players
    puts 'Enter name for Player 1'
    name = gets.chomp
    player1 = Player.new(name, 'X')
    puts "#{player1.name} your symbol is #{player1.symbol}"
    puts "\n"
    puts 'Enter name for Player 2'
    name = gets.chomp
    player2 = Player.new(name, 'O')
    puts "#{player2.name} your symbol is #{player2.symbol}"
    puts "\n"
    start_match(player1, player2)
  end

  def print_grid
    puts "\n" * 2
    @grid.each { |_, v| puts v.join('') }
    puts "\n" * 2
  end

  def start_match(player1, player2)
    (1..9).each do |i|
      if i.odd?
        puts "#{player1.name}, make your move by entering row and column number of the cell you wish to select"
        print_grid
        record_player_input(player1)
      else
        puts "#{player2.name}, make your move by entering row and column number of the cell you wish to select"
        print_grid
        record_player_input(player2)
      end
      check_result(player1, player2) if i >= 5
      if i == 9
        puts 'It is a draw'
        play_again?
      end
    end
  end
end

# class player
class Player < Game
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

Game.new
