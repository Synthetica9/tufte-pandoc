-- Print the source for every image
function imgSrc(img)
  print(img.src)
end

-- Print the source for every included file
function codeSrc(block)
  attributes = {"include_file", "executable"}
  for _, attribute in ipairs(attributes) do
    file = block.attributes[attribute]
    if file ~= nil then
      print(file)
    end
  end
end

-- Kill the full pandoc executable (which is allowed from a lua filter 🤷🏻‍♀️)
function kill(doc, meta)
  os.exit(0)
end

return {
  {
    Image = imgSrc,
    CodeBlock = codeSrc,
  },
  { Pandoc = kill },
}
