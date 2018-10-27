# BookLab::Toc

Book TOC read/write tool.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'booklab-toc'
```

And then execute:
```bash
$ bundle
```

## Usage

```rb
@content = BookLab::Toc.parse(read_file("sample.yml"))
@content.each do |item|
  puts item.id
  puts item.title
  puts item.url
  puts item.depth
end

@content = BookLab::Toc.parse(read_file("sample.json"), format: :json)
@content.to_html
@content.to_markdown
@content.to_json
@content = BookLab::Toc.parse(read_file("sample.md"), format: :markdown)
@content.to_html(prefix: "https://booklab.io/booklab/docs/")
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
