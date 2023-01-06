require "./spec_helper"

describe AndroidNDK do
  it "works" do
    AndroidNDK::API_LEVEL.should be_a(Int32)
  end
end
