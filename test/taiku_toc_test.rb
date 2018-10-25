require 'test_helper'

class TaikuToc::Test < ActiveSupport::TestCase
  setup do
    @content = TaikuToc.parse(read_file("sample.yml"))
  end

  test "to_html" do
    assert_equal read_file("sample.html").gsub(/>[\s]+</, "><").strip, @content.to_html.gsub(/>[\s]+</, "><").strip
  end

  test "to_markdown" do
    assert_equal read_file("sample.md").strip, @content.to_markdown.strip
  end

  test "to_json" do
    assert_equal read_file("sample.json"), @content.to_json
  end

  test "parse from json" do
    content = TaikuToc.parse(read_file("sample.json"), format: :json)
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
    assert_equal "install-mysql", content[2].url
    assert_equal 1234, content[2].id
    assert_equal 1, content[2].depth
  end
end
