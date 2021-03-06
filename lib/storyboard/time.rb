class STRTime
  REGEX = '([[:digit:]]+):([[:digit:]]+):([[:digit:]]+)[,\.]([[:digit:]]{3})'
  attr_reader :value

  class <<self
    def parse(str, skip_encode=false)
      matcher = skip_encode ? Regexp.new(REGEX) : Storyboard.encode_regexp(REGEX)
      hh,mm,ss,ms = str.scan(matcher).flatten.map{|i|
        Float(i.force_encoding("ASCII-8bit").delete("\000"))
      }
      value = ((((hh*60)+mm)*60)+ss) + ms/1000
      self.new(value)
    end
  end

  def initialize(value)
    @value = value
  end

  def +(bump)
    STRTime.new(@value + bump)
  end

  def to_srt
    ss = @value.floor
    ms = ((@value - ss)*1000).to_i

    mm = ss / 60
    ss = ss - mm * 60

    hh = mm / 60
    mm = mm - hh * 60

    "%02i:%02i:%02i.%03i" % [hh, mm, ss, ms]
  end
end
