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
    out = capture_io { ::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/01_master.jsx} }.join
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
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/01_master.jsx}}
    assert_output(result) {::ExtendScript::Client.start %W{merge --input #{@fixtures_dir}/01_master.jsx}}
  end

  def test_merge_i_infile_o_outfile
    assert_output(nil) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/01_master.jsx -o #{@fixtures_dir}/dist/abc.jsx}}
    assert_output(nil) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/01_master.jsx --output #{@fixtures_dir}/dist/abc.jsx}}
  end
  
  def test_merge_i_infile_remove_duplicate
    result = <<-JSX
var func_f = function (mess) {
  $.writeln("function f: " + mess);
}
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/04_master.jsx}}
  end
  
  def test_merge_i_file_embed_version
    result = <<-JSX
var func_f = function (mess) {
  $.writeln("function f: " + mess);
}
//## VERSION 1.2.3
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/06_master.jsx -e 1.2.3}}
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/06_master.jsx --embed-version 1.2.3}}
  end
  
  # #target
  def test_merge_i_file_detach_target
    result = <<-JSX
alert("Hi");
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/07_master_hash_target.jsx -d}}
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/07_master_hash_target.jsx --detach-target}}
  end

  # #target
  def test_merge_i_file_detach_target_false
    result = <<-JSX
#target "indesign"
alert("Hi");
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/07_master_hash_target.jsx -d false}}
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/07_master_hash_target.jsx --no-detach-target}}
  end
  
  # //@target
  def test_merge_i_file_detach_at_directive_target
    result = <<-JSX
alert("Hi");
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/08_master_at_target.jsx -d}}
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/08_master_at_target.jsx --detach-target}}
  end
  
  def test_merge_i_file_detach_at_directive_exclude_targetengine
    result = <<-JSX
//@targetengine "session"
alert("Hi");
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/09_master_targetengine.jsx -d}}
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/09_master_targetengine.jsx --detach-target}}
  end
  

  def test_merge_i_file_detach_and_attach_target
    result = <<-JSX
#target 'photoshop-70'
alert("Hi");
JSX
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/07_master_hash_target.jsx -d -a #target\ 'photoshop-70'}}
    assert_output(result) {::ExtendScript::Client.start %W{merge -i #{@fixtures_dir}/07_master_hash_target.jsx --detach-target --attach-target #target\ 'photoshop-70'}}
  end
  
end
