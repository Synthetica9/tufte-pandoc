-- Print the source for every image
function printSrc(img)
  print(img.src)
end

-- Kill the full pandoc executable (which is allowed from a lua filter 🤷🏻‍♀️)
function kill(doc, meta)
  os.exit(0)
end

return {
  {Image = printSrc },
  {Pandoc = kill }
}
