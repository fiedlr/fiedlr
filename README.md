This is the source code for [my personal webpage](http://fiedlr.sk/).

The webpage falls under regular copyright laws and its code is available here only _as a reference_. This means you should NOT use it as a template for another website. Check [Hakyll's website](https://jaspervdj.be/hakyll) for better examples.

# Features

Here's the list of key things to me that I haven't found in Hakyll and managed to get working only after a few days of research and hard work (I know it might not seem so).

- Automatic **PDF generation** for tex files using _Pandoc API_ itself (no ugly wrappers),
  - reserves `$pdf$` field for the link-to-file if the pdf file exists,
- working bibtex citations (you need to set `$bibliography$` in post metadata to point to the bib file) with _clickable_ links and a 'References' section title before the rendered bibliography,
- nice math rendering with _MathJax_ (you need to set `$mathjax$` to true in post metadata to make it load),
- code snippets with syntax highlighting and linkable _line numbering_,
  - you need to set `.numberLines` class in the snippet attribute section (\`\`\`\{.numberLines\})
- post categories based on `posts` dir structure (thanks to [Hakyll tags](https://jaspervdj.be/hakyll/reference/Hakyll-Web-Tags.html)),
  - `$categories$` renders links to all the existing categories,
  - `$category$` is capitalized,
- no `posts/` URL prefix for post entries,
- `removeHTMLExtensions` filter can be used to remove '.html' extension from relative links,
  - use if you want nice URLs without messing with the routes (e.g. you have set up *mod_redirect* in `.htaccess`),
- `numbersections: true` in the YAML block *enables* section numbering from LaTeX sources (unlike unmodified Hakyll),
- for internal links in LaTeX sources use the standard `\label{id}` with `\protect\hyperlink{id}{link name}` (`\ref` does not work),
- `teaser: "string"` in the YAML block sets `string` as the introduction for the post in the post list (it is INCLUDED in the post itself),
  - teaser also determines, if the post will be shown in the recent posts,
  - `excludeteaser: true` in the YAML block excludes the teaser from the post.
- `pages` folder for static pages generation (accessible from root)
- outputs to `docs` to work with GitHub Pages
