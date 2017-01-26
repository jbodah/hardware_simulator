module HardwareSimulator
  class CmpFile
    def self.load(file)
      parse File.read(file)
    end

    def self.parse(blob)
      parsed = Parser.new(blob).parse
      cast parsed
    end

    def self.cast(parsed)
      new(parsed)
    end

    def initialize(expecteds)
      @expecteds = expecteds
    end

    def each
      return to_enum unless block_given?
      @expecteds.each do |e|
        yield Test.new(e)
      end
    end

    class Test
      attr_reader :expected

      def initialize(expected)
        @expected = expected
      end

      def input; @expected; end
      def output; @expected; end
    end

    class Parser
      def initialize(blob)
        @blob = blob
      end

      def parse
        splits =
          @blob.each_line.map do |line|
            line.split('|').map(&:strip).reject(&:empty?)
          end

        headers = splits.shift
        expecteds = splits.map do |split|
          obj = {}
          split.each_with_index do |val, idx|
            obj[headers[idx]] = val.to_i
          end
          obj
        end
      end
    end
  end
end
