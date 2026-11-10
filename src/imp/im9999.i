/*******************************************************************************
**
**     Programa: IM9999.i - Procura traducao para mensagem.
**
*******************************************************************************/

  find trad-gerais use-index pk-tr-texto
     where trad-gerais.texto      =  "{1}"
     and   trad-gerais.cod-idioma =  {3}.cod-idioma
     no-lock no-error.
  if  avail trad-gerais then
      assign {2} = trim(trad-gerais.texto-trad).
