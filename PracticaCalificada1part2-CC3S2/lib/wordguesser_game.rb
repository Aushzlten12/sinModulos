class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  attr_accessor :word, :guesses, :wrong_guesses
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil?
      raise ArgumentError, "El caracter no puede ser nulo"
    end
    if letter.empty? 
      raise ArgumentError, "La caracter ingresada no puede ser vacía"
    end
    if /^[^a-zA-Z]{1}$/ =~ letter
      raise ArgumentError, "El caracter ingresado debe ser una letra"
    end
    if @word.include?(letter.downcase)
      if !@guesses.include?(letter.upcase) && !@guesses.include?(letter.downcase)
        @guesses = @guesses +  letter
        return true
      end
    else 
      if !@wrong_guesses.include?(letter.upcase) && !@wrong_guesses.include?(letter.downcase)
        @wrong_guesses = @wrong_guesses +  letter
        return true
      end
    end
    false
  end

  def word_with_guesses
    displayWord = '-' * @word.length
    @guesses.each_char do |letra|
      indices = []
      @word.each_char.with_index do |caracter, indice|
        indices << indice if caracter == letra
      end
      if !indices.empty?
        indices.each do |indice|
          displayWord[indice] = letra
        end
      end
    end
    return displayWord
  end
  
  def check_win_or_lose
    if word_with_guesses == @word
      :win
    elsif @wrong_guesses.length == 7
      :lose
    else
      :play
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

end
