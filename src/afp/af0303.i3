/* Essa l¢gica foi retirada do af0303rp para facilitar a manuten‡Æo, j  que agora ser  chamada dentro de dois for eachïs. */
/* A altera‡Æo do af0303rp foi feita para melhora de performance. A regra abaixo nÆo teve nenhuma altera‡Æo */



IF af-item-contr-estab.cod-grp-avaliacao < trim(tt-param.c-grp-avaliacao-ini) and 
 af-item-contr-estab.cod-grp-avaliacao > trim(tt-param.c-grp-avaliacao-fim) THEN NEXT.

for first item fields(desc-item ge-codigo fm-codigo un)
   where item.it-codigo = trim(af-item-contr-estab.it-codigo) no-lock: end.  
IF NOT AVAIL ITEM THEN NEXT.
if tt-param.c-fm-codigo-ini > item.fm-codigo or
tt-param.c-fm-codigo-fim < item.fm-codigo then next.
if tt-param.i-ge-codigo-ini > item.ge-codigo or
tt-param.i-ge-codigo-fim < item.ge-codigo then next.

for first emitente fields (nome-abrev cod-gr-forn)
 where emitente.cod-emitente = af-item-contr-estab.cod-emitente no-lock. end.

IF AVAIL emitente THEN
 if tt-param.i-cod-gr-forn-ini > emitente.cod-gr-forn or
    tt-param.i-cod-gr-forn-fim < emitente.cod-gr-forn then next.

RUN pi-seta-titulo IN h-acomp (INPUT c-lb-estab + af-item-contr-estab.cod-estabel + 
                                  c-lb-item + af-item-contr-estab.it-codigo + 
                                  c-lb-fornec + STRING(af-item-contr-estab.cod-emitente)).


ASSIGN l-quant = NO
    l-preco = NO
    l-data  = NO.

ASSIGN l-var-qualidade  = NO
    l-var-preco      = NO
    l-var-data       = NO
    l-var-quantidade = NO.

/* Avalia os pontos de controle utilizados para o relacionamento ------------------------------------*/

IF tt-param.l-qualidade and af-item-contr-estab.qualidade THEN DO:
 FIND FIRST af-item-contr-estab-form 
      WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo
        AND af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo
        AND af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente
        AND af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao
        AND af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel 
        AND af-item-contr-estab-form.nr-controle  = i-nr-qualidade NO-LOCK NO-ERROR.
 IF AVAIL af-item-contr-estab-form THEN DO:
     ASSIGN l-qualidade  = YES   
            de-perc-quali = af-item-contr-estab-form.percentual.
 END.
END.

IF tt-param.l-quantidade AND af-item-contr-estab.quantidade THEN DO:
 FIND FIRST af-item-contr-estab-form 
      WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo
        AND af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo
        AND af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente
        AND af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao
        AND af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel 
        AND af-item-contr-estab-form.nr-controle  = i-nr-quant NO-LOCK NO-ERROR.
 IF AVAIL af-item-contr-estab-form THEN DO:
     ASSIGN l-quant       = YES
           de-perc-quant = af-item-contr-estab-form.percentual.
 END.
END.

IF tt-param.l-preco AND af-item-contr-estab.preco THEN DO:
 FIND FIRST af-item-contr-estab-form 
      WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo
        AND af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo
        AND af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente
        AND af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao
        AND af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel 
        AND af-item-contr-estab-form.nr-controle  = i-nr-preco NO-LOCK NO-ERROR.
 IF AVAIL af-item-contr-estab-form THEN DO:
    ASSIGN l-preco       = YES
           de-perc-preco = af-item-contr-estab-form.percentual.
 END.
END.

IF tt-param.l-data AND af-item-contr-estab.data-entrega THEN DO:
 FIND FIRST af-item-contr-estab-form 
      WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo
        AND af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo
        AND af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente
        AND af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao
        AND af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel 
        AND af-item-contr-estab-form.nr-controle  = i-nr-data NO-LOCK NO-ERROR.
 IF AVAIL af-item-contr-estab-form THEN DO:
     ASSIGN l-data       = YES   
            de-perc-data = af-item-contr-estab-form.percentual.
 END.
END.

/*---------------------------------------------------------------------------------------------------*/

ASSIGN i-ult-tempo[18] = TIME.
ASSIGN l-padrao = NO.
IF l-quant OR l-preco OR l-data OR l-qualidade THEN DO:
 IF af-item-contr-estab.quantidade   OR 
    af-item-contr-estab.preco        OR
    af-item-contr-estab.data-entrega OR
    af-item-contr-estab.qualidade THEN
     FOR FIRST prazo-compra FIELDS ()
         WHERE prazo-compra.it-codigo     = trim(af-item-contr-estab.it-codigo)
           AND (prazo-compra.situacao     = 2 OR prazo-compra.situacao = 6)
           AND prazo-compra.data-entrega >= da-per-ini
           AND prazo-compra.data-entrega <= da-per-fim,
        FIRST ordem-compra FIELDS()
        WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem
          AND ordem-compra.it-codigo    = trim(af-item-contr-estab.it-codigo)
          AND ordem-compra.cod-estabel  = af-item-contr-estab.cod-estabel
          AND ordem-compra.cod-emitente = af-item-contr-estab.cod-emitente NO-LOCK: END.   
     ASSIGN l-padrao = AVAIL prazo-compra.        
END.

ASSIGN i-tempo[18] = i-tempo[18] + TIME - i-ult-tempo[18].

assign i-mes-ini = MONTH(da-per-ini).
IF FIRST-OF(af-item-contr-estab.ep-codigo)    OR
FIRST-OF(af-item-contr-estab.cod-estabel)  OR
FIRST-OF(af-item-contr-estab.cod-emitente) OR
FIRST-OF(af-item-contr-estab.it-codigo) THEN DO:

 run pi-seta-titulo in h-acomp (input c-lb-elim-indices).
 RUN pi-elimina-indices.
END.
BLOCO_ANO:
do i-ano = YEAR(da-per-ini) TO YEAR(da-per-fim):
bloco_mes:
do i-mes = i-mes-ini to 13:
   if i-ano = YEAR(da-per-fim) and
      i-mes > MONTH(da-per-fim) then do:
       LEAVE BLOCO_ANO.
   END.
   IF i-mes = 13 THEN DO:
       ASSIGN i-mes-ini = 1.
       LEAVE bloco_mes.
   END.

   run setPeriodo in h-boaf008 (input string(i-mes,"99") + string(i-ano,"9999")).
   run getDataPeriodo in h-boaf008 (output da-dt-indice).

   assign da-data-ini = da-dt-indice
          da-data-fim = da-dt-indice.

   if month(da-data-fim) = 12 then 
      assign da-data-fim = date(01,01,(year(da-data-fim) + 1))
             da-data-fim = da-data-fim - 1.
   else
      assign da-data-fim = date(month(da-data-fim) + 1,01,year(da-data-fim))
             da-data-fim = da-data-fim - 1.

   IF AVAIL param-af AND param-af.log-usa-versao THEN DO:
       IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
            RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                  INPUT af-item-contr-estab.it-codigo,
                                                  INPUT af-item-contr-estab.cod-emitente,
                                                  INPUT af-item-contr-estab.cod-estabel,
                                                  INPUT TABLE tt-versao-data,
                                                  OUTPUT TABLE tt-item-data).
            FOR EACH tt-item-data NO-LOCK:
               IF da-data-ini >= tt-item-data.data-ini AND
                  da-data-fim <= tt-item-data.data-fim THEN DO:

                   IF tt-item-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                       NEXT.               

                   RUN pi-calcula-pontos IN THIS-PROCEDURE.

                END.
                ELSE DO:
                    NEXT.
                END.
            END.
       END.
       ELSE DO: /* controle de validade conforme cadastro de versoes */
            FOR EACH tt-versao-data NO-LOCK:
                IF da-data-ini >= tt-versao-data.data-ini AND
                   da-data-fim <= tt-versao-data.data-fim THEN DO:

                   IF tt-versao-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                       NEXT.  
                   
                   RUN pi-calcula-pontos IN THIS-PROCEDURE.
                END.
                ELSE DO:
                    NEXT.
                END.
            END.
       END.
   END. /* param-af.log-usa-versao*/
   ELSE DO: /*nao usa versao*/
       RUN pi-calcula-pontos IN THIS-PROCEDURE.
   END. /* else do: */

  END. /*bloco mes*/
END. /*bloco ano */


