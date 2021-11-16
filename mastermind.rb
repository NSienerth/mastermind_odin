# frozen_string_literal: true

require './player'
require './evil_genius'
# Core functionality for Mastermind. Hands IO, calls to children.
# Is the only interface for the game and all functions after initialize are hidden behind privacy
class MastermindGame
  def initialize(guesses = 10)
    puts 'Would you like to be the code-breaker or the Mastermind?(breaker/maker)'
    choose_player_type
    @guesses = guesses
    puts "Code scrambled, game starting. You have #{@guesses} guesses."
    play
  end

  private

  def choose_player_type
    until @mastermind
      case gets.chomp
      when 'breaker'
        play_breaker
      when 'maker'
        play_maker
      else
        puts 'You must choose maker or breaker.'
      end
    end
  end

  def play_breaker
    @mastermind = EvilGenius.new(:maker)
    @code_breaker = Player.new(:breaker)
  end

  def play_maker
    @mastermind = Player.new(:maker)
    @code_breaker = EvilGenius.new(:breaker)
  end

  def play
    victory = false
    @guesses.times do |guess_number|
      puts "#{@guesses - guess_number} attempts remaining. Input a code."
      result = guess_handshake(guess_number)
      victory = result == '4B0W'
      break if victory
    end
    end_game(victory)
  end

  def end_game(victory)
    if victory
      puts "Codebreaker #{@code_breaker.name} has deciphered the code! #{@mastermind.name} loses!"
    else
      puts "Codebreaker #{@code_breaker.name} was stumped by #{@mastermind.name}'s code."
    end
  end

  def guess_handshake(turn)
    guess = @code_breaker.make_a_guess(turn)
    result = @mastermind.check_codes(guess)
    @code_breaker.record_result(turn, result)
    result
  end
end

MastermindGame.new
