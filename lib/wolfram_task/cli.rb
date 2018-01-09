require 'thor'
require 'wolfram_task'

module WolframTask
  class CLI < Thor
    desc 'search', 'Find languages influenced by those on the yaml file'
    option :file, :required => true, :aliases => '-f'
    def search
      finder = Finder.new
      ap finder.search(options.fetch('file'))
    end
  end
end