function RawBlock(block)
  if block.format == "markdown" then
    print('Extracting RawBlock')
    x = pandoc.read(block.text, "markdown")
    return pandoc.Div(x.blocks)
  end
end
