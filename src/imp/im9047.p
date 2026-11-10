/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9047 2.00.00.004} /*** "010004" 29/12/2025 14:18:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9047 MIM}
&ENDIF

{utp/ut-glob.i}

/*******************************************************************************
****    Programa criado para recalcular os valores quando 
****    na modifica‡Æo da nota de importa‡Æo.
****
****    Programa chamada apartir da boin176.m46    
****
****    p-embarque     - Embarque gravado no docum-est
****    p-cod-estabel  - Estabel gravado no docum-est
****    p-dt-emissao   - Data emissao gravado no docum-est
****    p-quant-forn   - Quantidade do item-doc-est
****    p-pre-unit-for - Preco unitario do fornecedor gravado no ordem-compra
****    p-mo-codigo    - Moeda gravado no ordem-compra
****    p-aliquota-ipi - Gravado no ordem-compra
*******************************************************************************/

       DEF INPUT  PARAMETER p-embarque     LIKE embarque-imp.embarque     NO-UNDO.
       DEF INPUT  PARAMETER p-cod-estabel  LIKE embarque-imp.cod-estabel  NO-UNDO.
       DEF INPUT  PARAMETER p-dt-emissao   LIKE docum-est.dt-emissao      NO-UNDO.
       DEF INPUT  PARAMETER p-quant-forn   LIKE item-doc-est.qt-do-forn   NO-UNDO.
       DEF INPUT  PARAMETER p-pre-unit-for LIKE ordem-compra.pre-unit-for NO-UNDO.
       DEF INPUT  PARAMETER p-mo-codigo    LIKE ordem-compra.mo-codigo    NO-UNDO.
       DEF INPUT  PARAMETER p-aliquota-ipi LIKE ordem-compra.aliquota-ipi NO-UNDO.
       DEF OUTPUT PARAMETER p-de-valor     LIKE ordem-compra.pre-unit-for /*AS DECIMAL*/                     NO-UNDO.
        
       def var de-cotacao-dia-imp LIKE cotacao.cotacao[1]        no-undo.
       def var da-cotacao-imp     as date                        no-undo.
       def var de-preco-unit-mo   LIKE cotacao-item.preco-unit   no-undo.
       DEF VAR p-de-valor-orig    LIKE ordem-compra.pre-unit-for NO-UNDO.

       find first embarque-imp where
                  embarque-imp.cod-estabel = p-cod-estabel and
                  embarque-imp.embarque    = p-embarque no-lock no-error.
       if avail embarque-imp then
          if embarque-imp.data-1 <> ? then
              assign da-cotacao-imp = embarque-imp.data-1.
          else
              assign da-cotacao-imp = p-dt-emissao.   
       else
          assign da-cotacao-imp = p-dt-emissao.   
               
       assign de-preco-unit-mo = (p-pre-unit-for * 100) 
                               / (100 + p-aliquota-ipi).
         
       assign p-de-valor-orig = (p-quant-forn * de-preco-unit-mo).
       
       IF  i-pais-impto-usuario <> 1 THEN
           ASSIGN p-de-valor-orig = ROUND(p-de-valor-orig,2).
       
       IF  NOT AVAIL embarque-imp 
       OR (AVAIL embarque-imp AND embarque-imp.dec-1 = 0) THEN
           RUN cdp/cd0812.p (INPUT  p-mo-codigo,
                             input  0,
                             input  p-de-valor-orig,
                             input  da-cotacao-imp,
                             output p-de-valor).                           
       ELSE
           RUN cdp/cd0812a.p (INPUT  p-mo-codigo,
                              input  0,
                              input  p-de-valor-orig,
                              input  embarque-imp.dec-1,
                              output p-de-valor).       

       ASSIGN p-de-valor = ROUND(p-de-valor,2).
