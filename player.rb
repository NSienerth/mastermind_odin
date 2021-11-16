# frozen_string_literal: true

# Core I/O for Mastermind game, including code checking functionality.
# Class can be either Mastermind and Codebreaker without duplicating code.
class Player
  attr_accessor :name, :role

  def initialize(role, name = nil)
    @role = role
    @name = name
    if @name.nil?
      puts 'Input your name.'
      @name = gets.chomp
    end
    maker_setup if @role == :maker
    breaker_setup if @role == :breaker
  end

  def check_codes(guess, baseline = @master_code)
    unchecked_baseline = baseline.dup
    unchecked_guess = guess.dup
    right = count_perfect_matches(unchecked_baseline, unchecked_guess)
    wrong = count_partial_matches(unchecked_baseline, unchecked_guess)
    right + wrong
  end

  def make_a_guess(turn)
    @history[turn][:code] = gets.chomp[0, 4]
  end

  def record_result(turn, result)
    @history[turn][:result] = result
    show_history
  end

  private

  attr_accessor :master_code, :history

  def maker_setup
    puts 'You are the Mastermind. Determine your diabolical code: Select 4 digits of 1-6.'
    @master_code = gets.chomp[0, 4]
    puts 'Ready for your futile resistance.'
  end

  def breaker_setup
    @history = Array.new(10) { { code: 'None', result: 'None' } }
    puts "You must break the Mastermind's code. It consists of 4 digits 1-6."
    puts 'Matching numbers in the right spot will generate a blue light.'
    puts 'Matches that are out of position will generate a white light.'
  end

  def show_history
    puts 'Guess History'
    10.times do |count|
      puts "#{count + 1}: #{@history.dig(count, :code)}  Outcome: #{@history.dig(count, :result)}"
    end
  end

  def count_perfect_matches(baseline, guess)
    matches = 0
    baseline.length.times do |index|
      next unless baseline[index] == guess[index]

      baseline[index] = '.'
      guess[index] = '.'
      matches += 1
    end
    baseline.gsub!('.', '')
    guess.gsub!('.', '')
    "#{matches}B"
  end

  def count_partial_matches(baseline, guess)
    partials = 0
    baseline.length.times do |index|
      next unless guess.include?(baseline[index])

      baseline_count = baseline.count(baseline[index])
      guess_count = guess.count(baseline[index])
      partials += baseline_count > guess_count ? guess_count : baseline_count
      guess.gsub!(baseline[index], '')
    end
    "#{partials}W"
  end
end
