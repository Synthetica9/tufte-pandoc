function CodeBlock(block)
  for i, c in ipairs(block.classes) do
    print(c, c=="sage")
    if c == "sage" then
      block.classes[i] = "python"
    end
  end
  return block
end

