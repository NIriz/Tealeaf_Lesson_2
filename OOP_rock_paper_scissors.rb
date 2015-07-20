class Player
  include Comparable

  attr_accessor :choice 
  attr_reader :name

  def initialize(name)
    @name = name
    @choice = choice
  end

  def to_s
    puts "#{name} chose #{choice}"
  end

  def <=> (another_choice)
    if @choice == another_choice
      0
    elsif (@choice == 'rock' && another_choice == 'scissors') || (@choice == 'paper' && another_choice == 'scissors') || (@choice == 'scissors' && another_choice == 'paper')
      1
    else
      -1
    end
  end
end


class Human < Player
  def turn
    puts "Please pick 'rock', 'paper' or 'scissors'!"
    self.choice = gets.chomp
    if Game::CHOICES.include?(self.choice) == false
      begin 
        puts "Sorry, that is not an option, please choose one of 'rock', 'paper' or 'scissors'."
        self.choice = gets.chomp
      end until Game::CHOICES.include?(self.choice)
    end
    self.to_s
  end
end


class Computer < Player
  def turn
    self.choice = Game::CHOICES.sample
    self.to_s
  end
end


class Game
  CHOICES = ['rock', 'paper', 'scissors']
  attr_accessor :human, :computer

  def initialize
    @human = Human.new("Scully")
    @computer = Computer.new("Data")
  end

  def play
    human.turn
    computer.turn
    compare_hand
    play_again?
  end

  def compare_hand
    if human.choice == computer.choice
      puts "It's a tie!"
    elsif human.choice > computer.choice
      puts "#{human.name} won!"
    else
      puts "Sorry, #{computer.name} got lucky this time and won."
    end
  end

  def play_again?
    puts "Would you like to play again? Enter 'yes' or 'no'."
    answer = gets.chomp
    if answer == 'yes'
      Game.new.play
    else
      exit
    end
  end
end

Game.new.play



