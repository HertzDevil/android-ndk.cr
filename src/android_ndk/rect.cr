require "./lib/rect"

struct AndroidNDK::Rect
  def initialize(@data : Lib::ARect)
  end

  def to_unsafe
    pointerof(@data)
  end

  def self.empty
    new(Lib::ARect.new(left: 0, up: 0, right: 0, bottom: 0))
  end

  def left : Int32
    @data.left
  end

  def up : Int32
    @data.up
  end

  def right : Int32
    @data.right
  end

  def bottom : Int32
    @data.bottom
  end
end
