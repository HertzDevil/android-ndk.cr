# core C defs

{% raise "`android` flag not set!" unless flag?(:android) %}

require "lib_c"
require "c/stddef"
require "c/stdarg"

module AndroidNDK
  @[Link("android")]
  lib Lib
    alias Char = LibC::Char
    alias Int = LibC::Int
    alias Float = LibC::Float
    alias SizeT = LibC::SizeT
    alias VaList = LibC::VaList

    alias Off64T = Int64
  end
end
