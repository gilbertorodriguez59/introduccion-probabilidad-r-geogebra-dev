local capitulos = {
  ["01-incertidumbre-probabilidad.qmd"] = {colab="01-incertidumbre-probabilidad-colab.ipynb", r="01-incertidumbre-probabilidad.Rmd", interactivo="cap01-frecuencia-relativa.html"},
  ["02-espacios-eventos.qmd"] = {colab="02-espacios-eventos-colab.ipynb", r="02-espacios-eventos.Rmd", interactivo="cap02-eventos-venn.html"},
  ["03-conteo-probabilidad.qmd"] = {colab="03-conteo-probabilidad-colab.ipynb", r="03-conteo-probabilidad.Rmd", interactivo="cap03-conteo.html"},
  ["04-axiomas-probabilidad.qmd"] = {colab="04-axiomas-probabilidad-colab.ipynb", r="04-axiomas-probabilidad.Rmd", interactivo="cap04-axiomas.html"},
  ["05-condicional-independencia.qmd"] = {colab="05-condicional-independencia-colab.ipynb", r="05-condicional-independencia.Rmd", interactivo="cap05-condicional-independencia.html"},
  ["06-probabilidad-total-bayes.qmd"] = {colab="06-probabilidad-total-bayes-colab.ipynb", r="06-probabilidad-total-bayes.Rmd", interactivo="cap06-bayes.html"},
  ["07-variable-aleatoria-cdf.qmd"] = {colab="07-variable-aleatoria-cdf-colab.ipynb", r="07-variable-aleatoria-cdf.Rmd", interactivo="cap07-variable-aleatoria-cdf.html"}
}

local function basename(path)
  return path:match("([^/\\]+)$") or path
end

local function cell(text, url)
  if url then return {pandoc.Plain({pandoc.Link(text, url)})} end
  return {pandoc.Plain({pandoc.Str(text)})}
end

local function tabla(cfg)
  local repo = "https://github.com/gilbertorodriguez59/introduccion-probabilidad-r-geogebra-dev"
  local colab = "https://colab.research.google.com/github/gilbertorodriguez59/introduccion-probabilidad-r-geogebra-dev/blob/main/notebooks/" .. cfg.colab
  local rurl = repo .. "/blob/main/cuadernos-r/" .. cfg.r
  local inturl = "interactivos/" .. cfg.interactivo

  local aligns = {pandoc.AlignLeft, pandoc.AlignLeft, pandoc.AlignLeft, pandoc.AlignLeft}
  local widths = {0.23, 0.18, 0.22, 0.37}
  local headers = {
    {pandoc.Plain({pandoc.Str("Material")})},
    {pandoc.Plain({pandoc.Str("Formato")})},
    {pandoc.Plain({pandoc.Str("Acceso")})},
    {pandoc.Plain({pandoc.Str("Propósito")})}
  }
  local rows = {
    {cell("Cuaderno de Google Colab"), cell("Notebook interactivo (R)"), cell("Abrir en Colab", colab), cell("Ejecutar, modificar y experimentar con los ejemplos computacionales del capítulo.")},
    {cell("Cuaderno de R"), cell("R Markdown"), cell("Abrir cuaderno R", rurl), cell("Reproducir y ampliar los ejemplos en R/RStudio.")},
    {cell("Interactivo"), cell("HTML / GeoGebra"), cell("Abrir recurso", inturl), cell("Explorar visualmente los conceptos centrales del capítulo.")},
    {cell("Presentación"), cell("PDF / PPT"), cell("Próximamente"), cell("Se incorporará cuando se proporcionen los enlaces de las presentaciones.")},
    {cell("Video"), cell("Video"), cell("Próximamente"), cell("Explicación audiovisual complementaria del capítulo.")},
    {cell("Infografía"), cell("Imagen / PDF"), cell("Próximamente"), cell("Síntesis visual de conceptos, procedimientos y fórmulas clave.")}
  }
  return pandoc.SimpleTable({}, aligns, widths, headers, rows)
end

function Pandoc(doc)
  if not PANDOC_STATE.input_files or #PANDOC_STATE.input_files == 0 then return doc end
  local name = basename(PANDOC_STATE.input_files[1])
  local cfg = capitulos[name]
  if not cfg then return doc end

  local nuevos = {}
  local insertado = false
  for _, b in ipairs(doc.blocks) do
    if not insertado and b.t == "Header" and pandoc.utils.stringify(b.content):lower():match("referencias del capítulo") then
      table.insert(nuevos, pandoc.Header(2, "Materiales complementarios del capítulo"))
      table.insert(nuevos, tabla(cfg))
      table.insert(nuevos, pandoc.Para({pandoc.Str("Los cuadernos de R acompañan este capítulo para reproducir, modificar y extender los ejemplos. El cuaderno de Google Colab permite trabajar desde el navegador. Las presentaciones, videos e infografías se enlazarán en esta misma tabla cuando estén disponibles.")}))
      insertado = true
    end
    table.insert(nuevos, b)
  end
  if not insertado then
    table.insert(nuevos, pandoc.Header(2, "Materiales complementarios del capítulo"))
    table.insert(nuevos, tabla(cfg))
  end
  doc.blocks = nuevos
  return doc
end
