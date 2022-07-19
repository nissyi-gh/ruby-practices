class Ls
  @options = {}

  class << self
    def main
      "main"
    end

    def options
      @options
    end
  end
end

Ls.main
