
class Card
  attr_accessor :suit, :face_value

  def initialize(suit, face_value)
    @suit = suit
    @face_value = face_value
  end

  def to_s
    "The #{face_value} of #{suit}"
  end
end

class Deck 
  attr_accessor :cards

  SUITS = ["Hearts", "Diamonds", "Spades", "Clubs"]
  FACE_VALUES = ["Queen", "King", "Jack", "Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

  def initialize
    @cards = []

    SUITS.each do |suit|
      FACE_VALUES.each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end
end
  

module Hand 

  def display_hand
    puts "#{name} has:"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> The total number of points is #{calculate_total}."
  end

  def calculate_total
    total = 0
    face_values = cards.map{|card| card.face_value}
    
    face_values.each do |value|
      if value == 'Ace'
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    # correct for Aces
    face_values.select{|value| value == "Ace"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
  

  def add(new_card)
    cards << new_card
  end

  def add_and_display_new_card(new_card)
    cards << new_card
    puts "=> The new card is #{new_card}"
    puts "=> The total number of points is #{calculate_total}."
  end

  def is_busted?
    calculate_total > Blackjack::BLACKJACK_AMOUNT
  end

  def twentyone?
    calculate_total == Blackjack::BLACKJACK_AMOUNT
  end

  def bust_or_21(human_or_dealer)
    if human_or_dealer.is_busted?
      puts "#{human_or_dealer.name} is over 21, busted!"
      play_again
    elsif human_or_dealer.twentyone?
      puts "#{human_or_dealer.name} hit Blackjack!"
      play_again
    else
      false
    end
  end

  def play_again
    puts "Would you like to play again? (yes/no)"
    answer = gets.chomp.downcase
    if answer == 'yes'
      system 'clear'
      puts "Starting a new game."
      puts
      deck = Deck.new
      human.cards = []
      dealer.cards = []
      play
    else
      puts "Bye!"
      exit
    end
  end
end


class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end 
end

class Dealer
  include Hand

  attr_accessor :cards
  attr_reader :name

  def initialize
    @name = "Dealer"
    @cards = []
  end
end



class Blackjack 
  BLACKJACK_AMOUNT = 21
  DEALER_MINIMUM = 17

  include Hand

  attr_reader :dealer 
  attr_accessor :deck, :human

  def initialize
    @human = Player.new("Player")
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def welcome
    puts "Welcome to blackjack! The goal is to get as close to 21 points before the dealer gets a chance to beat you!"
    puts
    puts "You will get a chance to hit (for more cards) or stay after I deal you 2 cards, good luck."
    puts
    puts "-----------------*---------------*----------------".center(80)
  end

  def set_player_name
    puts "What is your name?"
    human.name = gets.chomp
  end


  def compare_hands
    case
    when human.calculate_total == dealer.calculate_total
      puts "It's the rare tie!"
      play_again
    when human.calculate_total > dealer.calculate_total
      puts "#{human.name} won!"
      play_again
    else
      puts "The house wins this round!"
      play_again
    end
  end

  def deal_cards
    human.add(deck.deal_card)
    dealer.add(deck.deal_card)
    human.add(deck.deal_card)
    dealer.add(deck.deal_card)
  end

  def show_flop
    human.display_hand
    puts "=> Dealer's first card is hidden for now, the second one is:\n#{dealer.cards[1]}"
  end


  def human_turn
    if bust_or_21(human) == false
      puts "Do you wan't to hit or stay?"
      answer = gets.chomp.downcase
      while !['hit', 'stay'].include?(answer)
        puts "Error: enter 'hit' or 'stay'."
        answer = gets.chomp.downcase
      end
      until (answer == 'stay') || (bust_or_21(human) != false)
        human.add_and_display_new_card(deck.deal_card)
        bust_or_21(human)
        puts "Do you wan't to hit or stay?"
        answer = gets.chomp.downcase
      end 
    end
  end

  def dealer_turn
    puts "Dealer's turn."
    dealer.display_hand
    sleep 0.10
    bust_or_21(dealer)
    until (dealer.calculate_total >= 17) || (bust_or_21(dealer) != false)
      dealer.add_and_display_new_card(deck.deal_card)
      sleep 0.10
      dealer.calculate_total
      bust_or_21(dealer)
    end
    while dealer.calculate_total < human.calculate_total
      dealer.add_and_display_new_card(deck.deal_card)
      sleep 0.10
      bust_or_21(dealer)
    end
  end


  def play
    welcome
    set_player_name
    deal_cards
    show_flop
    puts
    human_turn
    system 'clear'
    dealer_turn
    compare_hands
    play_again
  end

end


game = Blackjack.new
game.play