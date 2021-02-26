require 'net/http'

class DictionaryClient

  def initialize(word)
    @word = word
  end

  def valid_scrabble_word?
    scrabble_score.present?
  end

  private

  attr_reader :word

  def scrabble_score
    response = Net::HTTP.get(scrabble_score_uri)
    JSON.parse(response)['value']
  end

  def scrabble_score_uri
    # make this cleaner
    URI("#{root}/v4/word.json/#{word}/scrabbleScore?api_key=#{api_key}")
  end

  def root
    'http://api.wordnik.com'
  end

  def api_key
    ENV['WORDNIK_API_KEY']
  end
end
