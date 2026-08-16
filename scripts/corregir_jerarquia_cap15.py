from pathlib import Path

path = Path('15-variables-conjuntas-marginales-condicionales.qmd')
texto = path.read_text(encoding='utf-8').splitlines()

salida = []
primer_h1 = True
for linea in texto:
    if linea.startswith('# '):
        if primer_h1:
            salida.append(linea)
            primer_h1 = False
        else:
            salida.append('#' + linea)  # # -> ##
    else:
        salida.append(linea)

path.write_text('\n'.join(salida) + '\n', encoding='utf-8')
print('Jerarquía del capítulo 15 corregida: sólo el título principal queda como H1.')
