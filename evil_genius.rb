# frozen_string_literal: true

require './player'
# AI for playing against a human. Overwrites input functions to automate responses.
# Uses Donald Knuth's algorithm for winning in 5 turns.
class EvilGenius < Player
  attr_accessor :role, :name

  def initialize(role)
    @name = role == :maker ? 'Mastermind' : 'Turing'
    super(role, @name)
  end

  def make_a_guess(turn)
    @history[turn][:code] = @next_guess
  end

  def record_result(turn, result)
    super
    consider_answer(turn, result)
  end

  private

  attr_accessor :master_code, :history, :answer_set, :next_guess

  def consider_answer(turn, result)
    @answer_set.delete_if { |entry| result != check_codes(@history[turn][:code], entry) }
    @next_guess = @answer_set[0]
  end

  def maker_setup
    @master_code = Array.new(4) { rand(1..6).to_s }.join('')
  end

  def breaker_setup
    @history = Array.new(10) { { code: 'None', result: 'None' } }
    @answer_set = *(1111..6666)
    @answer_set.map!(&:to_s).delete_if { |entry| entry =~ /[0789]/ }
    @next_guess = '1122'
  end
end
