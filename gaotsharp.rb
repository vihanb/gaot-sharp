require "io/console"

class GaotSharp
    def initialize(code)
        tokens = code.split(/\s+/).map do |token|
            if token =~ /^baa+$/
                fail "THE GAOT CANT BAA FOR MORE THAN 100 SECONDS ;_;" if token.length - 3 > 100
                ["a", token.length - 3]
            elsif token =~ /^blee+t$/
                ["e", token.length - 4]
            else
                fail ";_; Y U DO DIS. THE GAOT NO UNDERSTAND #{token.inspect} ;_; GOAT NO GIV CHES"
            end
        end
        @ast = GaotSharp.parse tokens
        @stack = []
        @vars = {}
    end

    def self.parse(tokens)
        ast = []
        until tokens.empty?
            tok = tokens.shift
            if tok == ["e", 1]
                ast << ["b", parse(tokens)]
            elsif tok == ["e", 2]
                break
            else
                ast << tok
            end
        end
        ast
    end

    def last
        @stack.last or 0
    end
    def pop(n=nil)
        if n
            (1..n).map {pop}.to_a.reverse
        else
            @stack.pop or 0
        end
    end

    def exec_(ast)
        ast.each do |elm|
            cmd, arg = elm
            case cmd
            when "a"
                @stack << arg
            when "e"
                case arg
                when 3
                    a, b = pop 2
                    @stack.push a + b
                when 4
                    a, b = pop 2
                    @stack.push a - b
                when 5
                    a, b = pop 2
                    @stack.push a * b
                when 6
                    a, b = pop 2
                    @stack.push a / b
                when 7
                    a, b = pop 2
                    @stack.push a % b
                when 8
                    @stack.push -pop
                when 9
                    @stack.push pop.abs
                when 10
                    print pop
                when 11
                    print pop.chr
                when 12
                    @stack.push STDIN.readline.chomp.to_i
                when 13
                    @stack.push STDIN.getch.ord
                when 14
                    @stack.push last
                when 15
                    a = pop
                    b = pop
                    @stack.push a
                    @stack.push b
                when 16
                    pop
                when 17
                    a, b = pop 2
                    @vars[b] = a
                when 18
                    @stack.push @vars[pop]
                end
            when "b"
                while last != 0
                    exec_ arg
                end
            end
        end
    end

    def exec
        exec_ @ast
    end
end

gaot = GaotSharp.new File.read ARGV[0]
gaot.exec
