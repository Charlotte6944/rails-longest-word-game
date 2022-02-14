class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:response].upcase
    @letters = params[:letters].split(" ").join
    if include?(@word, @letters)
      if english_word?(@word)
        @response = "Congratulations! #{@word} is a valid English word!"
      else
        @response = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @response = "Sorry but #{@word} can't be built out of #{@letters}"
    end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def include?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end
