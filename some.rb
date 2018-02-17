require 'erb'
require 'yaml'

class Examples
  def basic_erb(str)
    ERB.new(str).result
  end

  def erb_then_yaml(fn)
    str   = File.read(fn)
    erb   = ERB.new(str)
    @vars = YAML.load(str.gsub(/\<%.*%\>/, ""))['vars'] || {}
    YAML.load(erb.result(binding))
  end
end

require 'minitest/autorun'

class ExamplesTest < Minitest::Test
  attr_reader :examples

  def setup
    @examples = Examples.new
  end

  def test_basic_erb
    assert_equal 'fortytwo', examples.basic_erb('<%= "forty" + "two" %>')
  end

  def test_erb_then_yaml
    assert_equal 42, examples.erb_then_yaml('some.yml')['answer']
  end

  def test_erb_then_yaml_with_variables
    assert_equal 'jack', examples.erb_then_yaml('more.yml')['answer']
  end

  def test_erb_then_yaml_when_no_variables
    assert_nil examples.erb_then_yaml('some.yml')['another answer']
  end
end