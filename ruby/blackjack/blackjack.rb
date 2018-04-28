class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards, :total

  def initialize
    @cards = []
  end

  def deal_hand(deck)
    @cards << deck.deal_card
  end

  def display_hand
    @total = 0
    @cards.each do |card|
      printf "#{card.name} of #{card.suite} "
      if card.value.kind_of?(Array)
        if @total + card.value[0] > 21
          @total += card.value[1]
        else
          @total += card.value[0]
        end
      else 
        @total += card.value
      end
    end
    puts "\nTotal: #{@total}"
  end

  def display_dealer
    puts "#{cards[0].name} of #{cards[0].suite}"
  end

  def options
    input = ""
    while (input != "H" && input != "S" ) do
      puts "Stand or Hit? Input S or H"
      input = gets.chomp.upcase
    end
    return input
  end
end

class Blackjack
  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Hand.new
    @dealer = Hand.new
    2.times { player.deal_hand(@deck) }
    2.times { dealer.deal_hand(@deck) }
  end

  def start
    puts "You have been dealt: "
    @player.display_hand
    puts "Dealer has: "
    @dealer.display_dealer
    while @player.options != "S" do
      puts "You decided to Hit"
      player.deal_hand(@deck)
      puts "Your card"
      @player.display_hand
      check_player_bust
    end
    puts "You chosen to Stay"
    puts "Dealer Cards: "
    @dealer.display_hand
    check_dealer_hand
    check_winner
  end

  def check_dealer_hand
    if @dealer.total < 17
      @dealer.deal_hand(@deck)
      puts "Dealer Cards"
      @dealer.display_hand
    end
    if @dealer.total > 21
      puts "Dealer busted! You win"
      new_game
    end
    if @dealer.total == 21
      puts "Dealer wins"
      new_game
    end
  end

  def check_player_bust
    if @player.total > 21
      puts "You Bust! Dealer Wins"
      new_game
    elsif @player.total == 21
      puts "Winner Winner, Chicken Dinner. You Won!"
      new_game
    end
  end

  def check_winner
    if @player.total > @dealer.total
      puts "You win"
      new_game
    else
      puts "House wins"
      new_game
    end
  end

  def new_game
    new_game = ""
    while (new_game != "Y" && new_game != "N") do
      puts "Try again? Input Y or N"
      new_game = gets.chomp.upcase
    end
    if new_game == "N"
      puts "Closing Game"
      exit(0)
    else 
      puts "Starting new game..."
      newgame = Blackjack.new
      newgame.start
    end
  end
end

blackjack = Blackjack.new
blackjack.start

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class BlackjackTest < Test::Unit::TestCase
  def setup
    @blackjack = Blackjack.new
  end

  def test_new_game_player_initialized
    assert(@blackjack.player)
  end

  def test_new_game_dealer_initialized
    assert(@blackjack.dealer)
  end

  def test_new_game_deck_initialized
    assert(@blackjack.deck)
  end
end