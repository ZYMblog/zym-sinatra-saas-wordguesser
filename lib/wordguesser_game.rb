class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :count
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
    @count = 0
    $i=0
    while $i<@word.size do
      $i+=1
      @word_with_guesses=@word_with_guesses + '-'
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(guess_letter)
    raise ArgumentError if guess_letter == '' or guess_letter=~/[^a-zA-Z]/ or guess_letter==nil
    guess_letter=guess_letter.downcase
    if guesses.include? guess_letter or wrong_guesses.include? guess_letter
      return false
    elsif word.include? guess_letter
      # Initialize a loop variable
      len = 0
      # do loop begins
      loop do
        if guess_letter == word[len]
          word_with_guesses[len] = guess_letter
        end 
        len += 1
        if (len == word.size)
          break
        end
      end
      @guesses = guess_letter
      @count += 1
      return true
      
    elsif !word.include? guess_letter 
      @wrong_guesses = guess_letter
      @count += 1
      return true   
    end
  end

  def check_win_or_lose()
    if word_with_guesses == word
      return :win
    elsif @count >= 7
      return :lose
    else
      return :play
    end
  end
end
