require 'test_helper'

class BookLab::Toc::Test < ActiveSupport::TestCase
  setup do
    @content = BookLab::Toc.parse(read_file("sample.yml"))
    @prefix = "https://localhost/foo/bar/"
  end

  test "to_html" do
    assert_equal read_file("sample.html").gsub(/>[\s]+</, "><").strip, @content.to_html.gsub(/>[\s]+</, "><").strip
  end
  
  test "to_html with prefix" do
    assert_equal read_file("sample-with-prefix.html").gsub(/>[\s]+</, "><").strip, @content.to_html(prefix: @prefix).gsub(/>[\s]+</, "><").strip
  end
  
  test "to_markdown" do
    assert_equal read_file("sample.md").strip, @content.to_markdown.strip
  end
  
  test "to_markdown with prefix" do
    assert_equal read_file("sample-with-prefix.md").strip, @content.to_markdown(prefix: @prefix).strip
  end

  test "to_json" do
    assert_equal read_file("sample.json"), @content.to_json
  end

  test "to_yaml" do
    formated_yaml = YAML.dump(YAML.load(read_file("sample.yml")))
    assert_equal formated_yaml, @content.to_yaml
  end

  test "parse from json" do
    content = BookLab::Toc.parse(read_file("sample.json"), format: :json)
    assert_equal 11, content.size
    assert_equal "Getting Started", content[0].title
    assert_equal "getting-started", content[0].url
    assert_equal 999, content[0].id
    assert_equal 0, content[0].depth

    assert_equal "Datatbases", content[1].title
    assert_nil content[1].url
    assert_nil content[1].id
    assert_equal 0, content[1].depth

    assert_equal "Install MySQL", content[2].title
    assert_equal "/install-mysql", content[2].url
    assert_equal 1234, content[2].id
    assert_equal 1, content[2].depth
  end

  test "parse form markdown" do
    content = BookLab::Toc.parse(read_file("sample1.md"), format: :markdown)
    assert_equal 6, content.size

    expected = [{"title"=>"Getting Started", "url"=>"getting-started", "depth"=>0, "id"=>nil}, {"title"=>"No link line", "url"=>nil, "depth"=>0, "id"=>nil}, {"title"=>"Bad urls", "url"=>"install-mysql", "depth"=>1, "id"=>nil}, {"title"=>"Complex urls", "url"=>"https://google.com/search?client=safari&_rls=en&t=12&q=Ruby+Rails", "depth"=>2, "id"=>nil}, {"title"=>"Absolute link", "url"=>"/install-macos-linux", "depth"=>2, "id"=>nil}, {"title"=>"Mail to", "url"=>"mailto:foo@bar.com", "depth"=>1, "id"=>nil}]
    assert_equal expected, content.as_json
  end
end
