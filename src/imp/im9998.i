/*******************************************************************************
**
**     Programa: IM9998.i - Procura traducao para mensagem. 
**     Parƒmetros: {1} - Vari vel que cont‚m o Texto
**                 {2} - Vari vel que vai receber a tradu‡Æo
**                 {3} - Tabela que cont‚m o cod-idioma.
**
*******************************************************************************/

  find trad-gerais use-index pk-tr-texto
     where trad-gerais.texto      =  {1}
     and   trad-gerais.cod-idioma =  {3}.cod-idioma
     no-lock no-error.
  if  avail trad-gerais then
      assign {2} = trad-gerais.texto-trad.
  else
      assign {2} = {1}.
