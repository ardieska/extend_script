require 'test_helper'

class ExtendScriptTest < Minitest::Test
  
  def setup
    @fixtures_dir = File.expand_path('./fixtures', File.dirname(__FILE__))
  end
  
  def teardown
    FileUtils.rm_rf "#{@fixtures_dir}/dist"
  end
  
  def test_that_it_has_a_version_number
    refute_nil ::ExtendScript::VERSION
  end  
  
  def test_merge_i_infile_capture_io
    out = capture_io { ::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/a.jsx} }.join
    assert_includes(out, "func_b")
    assert_includes(out, "func_c")
    refute_includes(out, "include")
  end

  def test_merge_i_infile
    result = <<-JSX
var func_c = function (mess) {
  $.writeln("function c: " + mess);
}
var func_b = function (mess) {
  $.writeln("function b: " + mess);
}
func_b("hello");
func_c("world");
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/a.jsx}}
  end

  def test_merge_i_infile_o_outfile
    assert_output(nil) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/a.jsx -o #{@fixtures_dir}/dist/abc.jsx}}
  end
  
  def test_merge_i_infile_remove_duplicate
    result = <<-JSX
var func_f = function (mess) {
  $.writeln("function f: " + mess);
}
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/d.jsx}}
  end
  
  
end
