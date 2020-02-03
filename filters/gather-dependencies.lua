-- Print the source for every image
function imgSrc(img)
  print(img.src)
end

-- Print the source for every included file
function codeSrc(block)
  include_file = block.attributes["include_file"]
  if include_file ~= nil then
    print(include_file)
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
