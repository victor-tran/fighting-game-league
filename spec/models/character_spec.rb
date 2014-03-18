require 'spec_helper'

describe Character do
  it { should respond_to(:name) }
  it { should respond_to(:game) }
end
