require 'minitest/autorun'
require 'minitest/pride'
require 'oj'
require_relative './test_helpers.rb'
require_relative '../lib/eson/tokenizer.rb'

describe Eson::Tokenizer do

  describe "with full eson program" do
    before do
      @program = TestHelpers.get_tokenizer_sample_program
      @token_sequence, @input_sequence = Eson::Tokenizer.tokenize_program(@program)
    end
    
    it "has empty input sequence" do
      @input_sequence.empty?.must_equal true 
    end
    it "has filled token sequence" do
      @token_sequence.empty?.wont_equal true 
    end
    it "has only tokens in sequence" do
      token_seq_length = @token_sequence.length 
      valid_token_seq_length = @token_sequence.select{|i| i.class == Struct::Token}.length
      (token_seq_length == valid_token_seq_length).must_equal true
    end
  end
  
  describe "empty eson program" do
    before do
      @empty_program = TestHelpers.get_empty_program
      @token_sequence, @input_sequence = Eson::Tokenizer.tokenize_program(@empty_program)
    end
    
    it "has empty input sequence" do
      @input_sequence.empty?.must_equal true
    end
    it "has full token sequence" do
      @token_sequence.empty?.wont_equal true
    end
    it "has only tokens in sequence" do
      token_seq_length = @token_sequence.length 
      valid_token_seq_length = @token_sequence.select{|i| i.class == Struct::Token}.length
      (token_seq_length == valid_token_seq_length).must_equal true
    end
  end
  
end