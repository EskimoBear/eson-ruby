require 'minitest/autorun'
require 'minitest/pride'
require 'pp'
require_relative '../lib/eson/eson_grammars.rb'

describe Eson::EsonGrammars do
  
  subject {Eson::EsonGrammars}

  describe "validate_keys" do
    before do
      @lang = subject.keys
    end
    it "should contain built rules" do
      @lang.nonterminals.must_include :proc_identifier
      @lang.terminals.must_include :attribute_name
      @lang.terminals.must_include :special_form_identifier
      @lang.terminals.must_include :unreserved_procedure_identifier
      @lang.terminals.must_include :nullable
    end
  end
  
  describe "validate_e1" do
    before do
      @lang = subject.e1
    end
    it "should be E1" do
      @lang.must_be_kind_of Struct::E1
    end
    it "should contain new rules" do
      @lang.terminals.must_include :word_form
      @lang.terminals.must_include :variable_identifier
      @lang.nonterminals.must_include :sub_string
      @lang.nonterminals.must_include :sub_string_list
      @lang.nonterminals.must_include :string
      @lang.nonterminals.must_include :value
      @lang.nonterminals.must_include :array
      @lang.nonterminals.must_include :attribute
      @lang.nonterminals.must_include :call
      @lang.nonterminals.must_include :declaration
      @lang.nonterminals.must_include :program
    end
    it "should have top rule" do
      @lang.must_respond_to :top_rule
      @lang.top_rule.follow_set.must_include :eof
    end
    it "has no partial rules" do
      @lang.values.none?{|x| x.partial_status}.must_equal true
    end
  end

  describe "validate_format" do
    before do
      @lang = subject.format
    end
    it "rules have s_attr line_no" do
      @lang.values.all?{|i| i.s_attr.include? :line_no}
        .must_equal true
    end
    it "rules have s_attr indent" do
      @lang.values.all?{|i| i.s_attr.include? :indent}
        .must_equal true
    end
    it "only colon has s_attr spaces_after" do
      @lang.colon.s_attr.include?(:spaces_after)
        .must_equal true
      (@lang.terms - [:colon])
        .none?{|i| @lang.send(i).s_attr.include? :spaces_after}
        .must_equal true
    end
  end
end

describe Eson::Rule do
  before do
    @lang = Eson::EsonGrammars.format
  end
  describe "#to_s" do
    it "is a terminal rule" do
      @lang.element_divider.to_s.must_match /( := )/ 
    end
    it "is a concatenation rule" do
      @lang.variable_identifier.to_s.must_match /( := )/
    end
    it "is a alternation rule" do
      @lang.special_form_identifier.to_s.must_match /( := )/
    end
    it "is a repetition rule" do
      @lang.sub_string_list.to_s.must_match /( := )/
    end
    it "is an option rule" do
      @lang.element_set.to_s.must_match /( := )/
    end
  end
  
  it "is terminal rule" do
    @lang.number.partial_status.must_equal false
    first_set = @lang.number.first_set
    first_set.must_be_instance_of Array
    first_set.length.must_equal 1
    first_set.must_equal [:number]
  end
  it "has non-terminals" do
    @lang.value.partial_status.must_equal false
    first_set = @lang.value.first_set
    first_set.must_be_instance_of Array
    first_set.length.must_equal 8
    first_set.must_include :variable_identifier
    first_set.must_include :true
    first_set.must_include :false
    first_set.must_include :null
    first_set.must_include :string_delimiter
    first_set.must_include :number
    first_set.must_include :array_start
    first_set.must_include :program_start
  end
  describe "starts with nonterminal" do
    it "is option rule" do
      @lang.element_set.partial_status.must_equal false
      first_set = @lang.element_set.first_set
      first_set.must_be_instance_of Array
      first_set.length.must_equal 9
      first_set.must_include :variable_identifier
      first_set.must_include :true
      first_set.must_include :false
      first_set.must_include :null
      first_set.must_include :string_delimiter
      first_set.must_include :number
      first_set.must_include :array_start
      first_set.must_include :program_start
      first_set.must_include :nullable
    end
  end
end
