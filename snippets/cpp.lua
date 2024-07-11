local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  -- Snippets
  s({ trig = "main", dscr = "Main function entrypoint." }, {
    t({"int main(int argc, char **argv) {", "\t"}),
    i(0),
    t({"", "}"})
  }),

  s({ trig = "pdebug", dscr = "Debug print with cout." }, {
    t("std::cout << \""),
    i(1, "Test"),
    t("\" << std::endl;")
  })
},
{
  -- Autosnippets
}

