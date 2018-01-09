require 'yaml'
require 'cgi'
require 'open-uri'
require 'nokogiri'
require 'awesome_print'
require_relative 'wolfram_task/version'

module WolframTask
  class Finder

    UsageError = Class.new(StandardError)

    def search(file)
      begin
        file = load_file(file)
        langs = parse_file(file)
        url = format_url(langs)
        data = perform_search(url)
        extract_langs(data)
      rescue Exception => ex
        abort("ERROR: #{ex.message}")
      end
    end

  #######
  private
  #######

    def load_file(f)
      File.file?(f) ? YAML.load_file(f) : fail(ArgumentError, 'Invalid File.')
    end

    def parse_file(f)
      begin
        f.first.fetch('langs').join(';')
      rescue
        fail(ArgumentError, 'Invalid File.')
      end
    end

    def format_url(langs)
      "http://api.wolframalpha.com/v2/query?" +
          "input=#{CGI.escape(langs)}&format=plaintext&appid=KAH797-L3HG3QPUY2"
    end

    def perform_search(url)
      Nokogiri::XML.parse(open(url))
    end

    def extract_langs(data)
      fail(UsageError, 'Unsuccessful request.') unless request_successful?(data)
      text = extract_text(data)
      parse_text(text)
    end

    def request_successful?(data)
      data.xpath('//queryresult/@success').to_s.downcase == 'true'
    end

    def extract_text(data)
      raw_text = data.xpath('//plaintext')[1].to_s
      text_in_range(raw_text, 'languages influenced', 'official website')
    end

    def text_in_range(text, range_start, range_end)
      start_index = text.index(range_start) + range_start.length
      end_index = text.index(range_end)
      final_range = Range.new(start_index, end_index, true)
      text[final_range]
    end

    def parse_text(text)
      text.split('|').map(&:strip).reject(&:empty?)
    end
  end
end