require 'spec_helper'

describe "nrser.state_mate" do
  it "has a version number" do
    expect(File.read(ROOT + "VERSION")).not_to be nil
  end
end