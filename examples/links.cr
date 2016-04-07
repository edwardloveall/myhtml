# Example: extract links and around texts from html

require "../src/myhtml"

str = if filename = ARGV[0]?
        File.read(filename)
      else
        <<-HTML
        <html>
          <div>
            Before
            <br>
            <a href='/link1'>Link1</a>
            <br>
            After
          </div>

          #
          <a href='/link2'>Link2</a>
          --

          <div>some<span>⬠ ⬡ ⬢</span></div>
          <a href='/link3'>Link3</a>
          <script>asdf</script>
          <span>⬣ ⬤ ⬥ ⬦</span>
        </html>
        HTML
      end

def good_texts?(iterator)
  iterator
    .tags(:_text)
    .select(&.parents.all? { |n| n.visible? && !n.object? })
    .map(&.tag_text.strip)
    .reject(&.empty?)
end

Myhtml::Parser.new.parse(str).tags(:a).each do |node|
  anchor = node.child.try &.tag_text.strip
  href = node.attribute_by("href")
  before = good_texts?(node.left_iterator).first?
  after = good_texts?((node.child || node).right_iterator).first?
  puts "(#{before}) <#{href}>(#{anchor}) (#{after})"
end

# Output:
#   (Before) </link1>(Link1) (After)
#   (#) </link2>(Link2) (--)
#   (⬠ ⬡ ⬢) </link3>(Link3) (⬣ ⬤ ⬥ ⬦)
