require 'test_helper'

class BlueDoc::Toc::Test < ActiveSupport::TestCase
  setup do
    @content = BlueDoc::Toc.parse(read_file("sample.yml"))
    @prefix = "https://localhost/foo/bar/"
  end

  test "with a bad field" do
    toc = <<~TOC
    ---
    - title: Getting Started
      url: getting-started
      depth: 0
      id: 999
      badField: foo
    - title: Datatbases
      url:
      depth: 1
      id:
    TOC

    content = BlueDoc::Toc.parse(toc)
    assert_equal 2, content.size
    assert_equal "Getting Started", content[0].title
    assert_equal "getting-started", content[0].url
    assert_equal 0, content[0].depth
    assert_equal 999, content[0].id
    assert_equal "Datatbases", content[1].title
    assert_nil content[1].url
    assert_equal 1, content[1].depth
    assert_nil content[1].id
  end

  test "to_html" do
    # puts @content.to_html
    assert_equal read_file("sample.html").gsub(/>[\s]+</, "><").strip, @content.to_html.gsub(/>[\s]+</, "><").strip
  end

  test "to_html with prefix" do
    # puts @content.to_html(prefix: @prefix)
    assert_equal read_file("sample-with-prefix.html").gsub(/>[\s]+</, "><").strip, @content.to_html(prefix: @prefix).gsub(/>[\s]+</, "><").strip
  end

  test "to_html with prefix and suffix" do
    html = @content.to_html(prefix: "./docs/", suffix: ".md")
    assert_equal read_file("sample-with-suffix.html").gsub(/>[\s]+</, "><").strip, html.gsub(/>[\s]+</, "><").strip
  end

  test "to_markdown" do
    assert_equal read_file("sample.md").strip, @content.to_markdown.strip
  end

  test "to_markdown with prefix" do
    assert_equal read_file("sample-with-prefix.md").strip, @content.to_markdown(prefix: @prefix).strip
  end

  test "to_markdown with prefix and suffix" do
    assert_equal read_file("sample-with-suffix.md").strip, @content.to_markdown(prefix: "./docs/", suffix: ".md").strip
  end

  test "to_json" do
    assert_equal read_file("sample.json"), @content.to_json
  end

  test "to_yaml" do
    formated_yaml = YAML.dump(YAML.load(read_file("sample.yml")))
    assert_equal formated_yaml, @content.to_yaml
  end

  test "parse from json" do
    content = BlueDoc::Toc.parse(read_file("sample.json"), format: :json)
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

  test "parse from markdown" do
    content = BlueDoc::Toc.parse(read_file("sample1.md"), format: :markdown)
    assert_equal 6, content.size
    assert_equal 0, content[0].depth
    assert_equal 0, content[1].depth
    assert_equal 1, content[2].depth
    assert_equal 2, content[3].depth

    expected = [{"title"=>"Getting Started", "url"=>"getting-started", "depth"=>0, "id"=>nil}, {"title"=>"No link line", "url"=>nil, "depth"=>0, "id"=>nil}, {"title"=>"Bad urls", "url"=>"install-mysql", "depth"=>1, "id"=>nil}, {"title"=>"Complex urls", "url"=>"https://google.com/search?client=safari&_rls=en&t=12&q=Ruby+Rails", "depth"=>2, "id"=>nil}, {"title"=>"Absolute link", "url"=>"/install-macos-linux", "depth"=>2, "id"=>nil}, {"title"=>"Mail to", "url"=>"mailto:foo@bar.com", "depth"=>1, "id"=>nil}]
    assert_equal expected, content.as_json
  end

  test "parse from 4 space indent markdown" do
    content = BlueDoc::Toc.parse(read_file("4space.md"), format: :markdown)
    assert_equal 5, content.size
    assert_equal 0, content[0].depth
    assert_equal 1, content[1].depth
    assert_equal 2, content[2].depth
    assert_equal 1, content[3].depth
    assert_equal 0, content[4].depth
  end

  test "parse from tab indent markdown" do
    raw = "- [Hello](hello)\n\t- [World](world)\n\t\t[Foo](/foo)\n\t[Bar](/bar)"
    content = BlueDoc::Toc.parse(raw, format: :markdown)
    assert_equal "Hello", content[0].title
    assert_equal "hello", content[0].url
    assert_equal 0, content[0].depth
    assert_equal "World", content[1].title
    assert_equal "world", content[1].url
    assert_equal 1, content[1].depth
    assert_equal 2, content[2].depth
    assert_equal 1, content[3].depth
  end

  test "parse with strict mode" do
    bad_toc = <<~TOC
    adsglkj
    asdgkladsg
    TOC

    assert_raise(BlueDoc::Toc::FormatError) { BlueDoc::Toc.parse(bad_toc, format: :yaml, strict: true) }

    content = BlueDoc::Toc.parse(bad_toc, format: :yaml)
    assert_equal %(<ul class="toc-items">\n</ul>), content.to_html.strip
  end

  test "Array methods" do
    assert_nil @content.find { |item| item.url == "not-exist-item" }
    item = @content.find { |item| item.url == "install-mysql-linux" }
    assert_equal @content[3], item
    assert_equal "install-mysql-linux", item.url
    assert_equal "Linux Install", item.title

    assert_equal @content[3], @content.find_by_url("install-mysql-linux")
    assert_equal item, @content.find_by_url("install-mysql-linux")

    @content.sort { |a, b| a.title <=> b.title }
    @content.sort_by { |a| a.title }
    assert_equal 2, @content.take(2).length
    assert_equal @content[0], @content.first
  end
end
