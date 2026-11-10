/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3101RP 2.00.00.017 } /*** "010017" 23/09/2025 14:33:38  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3101rp MIM}
&ENDIF

{utp/ut-glob.i}
{imp/im0100x.i   tt-param-im3101}
{cxbo/bocx220h.i tt-selecao-embarque}
{cxbo/bocx310a.i tt-desp-embarque}
{inbo/boin090.i  tt-docum-est}
{inbo/boin759.i tt-impto-item-docto}

DEF TEMP-TABLE tt-param NO-UNDO
         FIELD usuario   AS CHAR
         FIELD destino   AS INT
         FIELD data-exec AS DATE
         FIELD hora-exec AS INT
         FIELD arquivo   AS CHAR.


define input parameter table for tt-parametros.
define input parameter table for tt-selecao-embarque.
define input parameter table for tt-desp-embarque.
define input parameter table for tt-docum-est. 
define input parameter c-embarque-anterior as char no-undo.
define input parameter l-executar          as LOG no-undo.



define variable cembarqueframe   LIKE embarque-imp.embarque no-undo.
define variable ccod-observacao  as char no-undo.
define variable cvalormercad     as char no-undo.
define variable cdescricaodesp   as char no-undo.
define variable h-bocx095        as handle no-undo.
DEFINE VARIABLE valor-MN         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE acm-imp-me       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE acm-imp-mn       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-base-impostos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-liter-1        AS CHAR FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE c-desc-impto     AS CHARACTER  FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE h-boin759na AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-valor-isento  like docum-est-cex.val-desp NO-UNDO.
DEFINE VARIABLE de-valor-sem-iva like docum-est-cex.val-desp NO-UNDO.
DEFINE VARIABLE de-valor-com-iva like docum-est-cex.val-desp NO-UNDO.
DEFINE VARIABLE i-imposto        AS INT NO-UNDO.

def stream relat-acomp.

form
impto-item-docto.cdn-imposto          format ">>>>>9"  column-label "Imposto"      
tipo-tax.descricao                    format "x(30)"   column-label "Descricao"    
de-base-impostos                      format ">>>>>,>>>,>>9.99999" column-label "Base Calculo" 
impto-item-docto.perc-imposto         format ">>>9.99" column-label "%"      
impto-item-docto.val-impto-merc-ext   format "->>,>>>,>>>,>>9.99" column-label "Valor ME"
impto-item-docto.val-impto            format "->>,>>>,>>>,>>9.99" column-label "Valor MN"
with stream-io width 132 60 down no-box frame f-impto.     

form 
    "--------------" at 50 skip
     "PARAMETROS 1"  at 51 skip
    "--------------" at 50 skip(2)
    cembarqueframe                      format "x(16)"        label "Embarque"                       colon 32      
&IF "{&mguni_version}" >= "2.071" &THEN
    tt-parametros.cod-estabel           format "x(05)"        label "Estabelecimento"                colon 85 skip 
&ELSE
    tt-parametros.cod-estabel           format "x(3)"         label "Estabelecimento"                colon 85 skip 
&ENDIF
    tt-parametros.cod-emitente-desp     format ">>>>>>>>9"    label "Fornecedor"                     colon 32 
    tt-parametros.da-transacao          format "99/99/9999"   label "Data Transacao"                 colon 85 skip
    tt-parametros.nff                   format "Sim/Nao"      label "Factura Factura"                colon 32
    tt-parametros.da-emissao            format "99/99/9999"   label "Data Emissao"                   colon 85 skip (1)
    tt-parametros.nro-docto             format "x(16)"        label "Nro Docto"                      colon 32
&IF "{&mguni_version}" >= "2.071" &THEN
    tt-parametros.estab-fisc            format "x(05)"        label "Estabelecimento Fiscal"         colon 85 skip
&ELSE
    tt-parametros.estab-fisc            format "x(3)"         label "Estabelecimento Fiscal"         colon 85 skip
&ENDIF
    tt-parametros.serie                 format "x(5)"         label "Serie"                          colon 32
    tt-parametros.nat-operacao          format "x(6)"         label "Nat Operacao"                   colon 85 skip (1)
    tt-parametros.da-cotacao            format "99/99/9999"   label "Data Cotacao Moeda"             colon 32
    ccod-observacao                     format "x(20)"        label "Cod Observacao"                 colon 85 skip
    tt-parametros.d-cotacao             format ">>>,>>9.9999999999" label "Cota‡Æo Moeda"            colon 32 skip
    tt-parametros.ct-transit            format "x(17)"        label "Conta Transitoria"              colon 32 skip (2)
    with stream-io width 132 side-labels no-box frame f-param.

form
    tt-selecao-embarque.embarque          format "x(16)"               column-label "Embarque"         at 25  
    tt-selecao-embarque.cod-incoterm      format "x(3)"                column-label "Incoterm"         at 42  
    tt-selecao-embarque.declaracao-import format "x(20)"               column-label "DI"               at 51  
    tt-selecao-embarque.nr-conhecimento   format "x(18)"               column-label "Conhecto Transp"  at 73  
    with stream-io width 132 60 down no-box frame f-sel-embarque.                                     

form
    tt-selecao-embarque.embarque            format "x(16)"               column-label "Embarque"         at 25  
    tt-selecao-embarque.cod-incoterm        format "x(3)"                column-label "Incoterm"         at 42  
    tt-selecao-embarque.declaracao-import   format "x(20)"               column-label "DI"               at 51  
    tt-selecao-embarque.cod-conhecto-master format "x(25)"               column-label "Conhecto Master"  at 73  
    tt-selecao-embarque.cod-conhecto-house  format "x(25)"               column-label "Conhecto House"   at 100  
    with stream-io width 132 60 down no-box frame f-sel-embarque-2.                                     

form                                                                                                  
    tt-desp-embarque.cod-desp             format ">>,>>9"              column-label "Cod Despes"       at 6   
    tt-desp-embarque.desc-desp            format "x(30)"               column-label "Descricao"        at 17  
    tt-desp-embarque.cod-emitente-desp    format ">>>>>>>>9"           column-label "Fornec Desp"      at 48  
    tt-desp-embarque.embarque             format "x(16)"               column-label "Embarque"         at 60  
    tt-desp-embarque.cod-pto-contr        format ">>,>>9"              column-label "Pto Contr"        at 78  
    tt-desp-embarque.val-desp             format ">>>>>,>>>,>>9.99999" column-label "Val Despes"       at 88  
    tt-desp-embarque.cond-pagto           format ">>>9"                column-label "Cond Pagto"       at 108 
    with stream-io width 132 60 down no-box frame f-sel-despesa.       

form                                                                                                  
    tt-desp-embarque.cod-desp                     format ">>,>>9"              column-label "Cod Despes"         at 6   
    tt-desp-embarque.desc-desp                    format "x(30)"               column-label "Descricao"          at 17  
    tt-desp-embarque.cod-emitente-desp            format ">>>>>>>>9"           column-label "Fornec Desp"        at 48  
    tt-desp-embarque.embarque                     format "x(16)"               column-label "Embarque"           at 60  
    tt-desp-embarque.cod-pto-contr                format ">>,>>9"              column-label "Pto Contr"          at 78
    tt-desp-embarque.val-desp                     format ">>>>>,>>>,>>9.99999" column-label "Val Despes"         at 88
    despes-embarq-internac.cdn-imposto            format ">>>9"                COLUMN-LABEL "Imp"                AT 108 
    despes-embarq-internac.val-preco-unit-isento  format ">>>>>,>>>,>>9.99999" COLUMN-LABEL "Val Despes Isento"  AT 113 
    despes-embarq-internac.val-preco-unit-com-iva format ">>>>>,>>>,>>9.99999" COLUMN-LABEL "Val Despes Com Iva" AT 133 
    despes-embarq-internac.val-preco-unit         format ">>>>>,>>>,>>9.99999" COLUMN-LABEL "Val Despes Sem IVA" AT 153      
    tt-desp-embarque.cond-pagto                   format ">>>9"                column-label "Cond Pagto"         at 173 
    with stream-io width 190 60 down no-box frame f-sel-despesa-pry. 

form                                                         
    docum-est-cex.cod-desp                format ">>,>>9"              column-label "Cod Despes"       at 16   
    cdescricaodesp                        format "x(30)"               column-label "Descricao"        at 27  
    docum-est-cex.cod-emitente-desp       format ">>>>>>>>9"           column-label "Fornec Desp"      at 58  
    docum-est-cex.val-desp                format ">>>>>,>>>,>>9.99999" column-label "Val Despes"       at 70  
    docum-est-cex.cod-cond-pag            format ">>>9"                column-label "Cond Pagto"       at 90 
    with stream-io width 132 60 down no-box frame f-despesa-cex.

form                                                         
    docum-est-cex.cod-desp                        format ">>,>>9"              column-label "Cod Despes"         at 6   
    cdescricaodesp                                format "x(30)"               column-label "Descricao"          at 17  
    docum-est-cex.cod-emitente-desp               format ">>>>>>>>9"           column-label "Fornec Desp"        at 48
    docum-est-cex.val-desp                        format ">>>>>,>>>,>>9.99999" column-label "Val Despes"         at 60 
    i-imposto                                     format ">>>9"                COLUMN-LABEL "Imp"                AT 80
    de-valor-isento                               format ">>>>>,>>>,>>9.99999" COLUMN-LABEL "Val Despes Isento"  AT 85
    de-valor-com-iva                              format ">>>>>,>>>,>>9.99999" COLUMN-LABEL "Val Despes Com IVA" AT 105
    de-valor-sem-iva                              format ">>>>>,>>>,>>9.99999" COLUMN-LABEL "Val Despes Sem IVA" AT 125     
    docum-est-cex.cod-cond-pag                    format ">>>9"                column-label "Cond Pagto"         at 145 
    with stream-io width 170 60 down no-box frame f-despesa-cex-pry.

form
                               skip(2)
    "------------------" at 48 skip
    "DOCUMENTO GERADO"   at 49 skip
    "------------------" at 48 skip(2)
    docum-est.cod-emitente                format "999999999"    label "Emitente"                       colon 55 skip
    docum-est.nro-docto                   format "x(16)"        label "Documento"                      colon 55 skip
    docum-est.serie-docto                 format "x(5)"         label "Serie"                          colon 55 skip
    docum-est.nat-operacao                format "x(6)"         label "Nat Operacao"                   colon 55 skip
    with stream-io width 132 side-labels no-box frame f-documento.

form
                               skip(2)
    "------------------" at 48 skip
    "IMPOSTOS"   at 49 skip
    "------------------" at 48 skip(2)
    with stream-io width 132 side-labels no-box frame f-impto-cabec.

FORM
    "-----------------------------------------" AT 3 skip
    "DOCUMENTO GERADO COM SUCESSO" at 5 skip
    "-----------------------------------------" at 3 skip(2)
    with stream-io width 132 side-labels no-box frame f-docto-gerado-sucesso.

FORM
    tt-impto-item-docto.cdn-imposto         at 6 
    c-desc-impto                            AT 19 LABEL "Desc Impto"
    tt-impto-item-docto.perc-imposto        at 45   
    tt-impto-item-docto.val-impto           at 60   
    tt-impto-item-docto.val-impto-merc-ext  at 80   
    with stream-io width 132 60 down no-box frame f-imposto.


run utp/ut-trfrrp.p (INPUT FRAME f-impto:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-param:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-sel-embarque:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-sel-embarque-2:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-sel-despesa:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-sel-despesa-pry:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-despesa-cex:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-despesa-cex-pry:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-documento:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-imposto:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-impto-cabec:handle).
run utp/ut-trfrrp.p (INPUT FRAME f-docto-gerado-sucesso:handle).


output stream relat-acomp to value (session:temp-directory + "im3101.tmp") convert target "iso8859-1".

find first tt-docum-est no-lock no-error.

IF l-executar THEN
    DISP STREAM relat-acomp
         WITH FRAME f-docto-gerado-sucesso.

find first tt-parametros no-error.
if  avail tt-parametros then do:

    &if defined(bf-mat-comex) &then
        if  tt-parametros.cod-observacao = 0 then
            {utp/ut-liter.i "Industria" *}
        if  tt-parametros.cod-observacao = 1 then
            {utp/ut-liter.i "Com‚rcio" *}
        if  tt-parametros.cod-observacao = 2 then
            {utp/ut-liter.i "Devolu‡Æo Cliente" *}
        if  tt-parametros.cod-observacao = 3 then
            {utp/ut-liter.i "Servico" *}
        assign ccod-observacao = TRIM(RETURN-VALUE).
    &ELSE 
        if  tt-parametros.cod-observacao = 1 then 
            {utp/ut-liter.i "Industria" *}
        if  tt-parametros.cod-observacao = 2 then
            {utp/ut-liter.i "Com‚rcio" *}
        if  tt-parametros.cod-observacao = 3 then
            {utp/ut-liter.i "Devolu‡Æo Cliente" *}
        if  tt-parametros.cod-observacao = 4 then
            {utp/ut-liter.i "Servico" *}
        assign ccod-observacao = TRIM(RETURN-VALUE).
    &endif        
    
    ASSIGN cembarqueframe   = c-embarque-anterior.
    
    disp stream relat-acomp
        cembarqueframe                               
        tt-parametros.cod-estabel         
        tt-parametros.cod-emitente-desp   
        tt-parametros.da-transacao        
        tt-parametros.nff
        tt-parametros.da-emissao          
        tt-parametros.nro-docto           
        tt-parametros.estab-fisc          
        tt-parametros.serie               
        tt-parametros.nat-operacao        
        tt-parametros.da-cotacao        
        ccod-observacao         
        tt-parametros.d-cotacao
        tt-parametros.ct-transit with frame f-param.
end.

{utp/ut-liter.i "EMBARQUES_SELECIONADOS" *}
ASSIGN c-liter-1 = TRIM(RETURN-VALUE).

put stream relat-acomp
                                     skip(2)
    "------------------------" at 45 skip      
    c-liter-1                  at 46  skip      
    "------------------------" at 45 skip(2). 

for each  tt-selecao-embarque
    where tt-selecao-embarque.marca = "X":U:
    &if "{&bf_mat_versao_ems}" <= "2.04" &then
        disp stream relat-acomp
            tt-selecao-embarque.embarque          
            tt-selecao-embarque.cod-incoterm                             
            tt-selecao-embarque.declaracao-import 
            tt-selecao-embarque.nr-conhecimento with frame f-sel-embarque.
        down with frame f-sel-embarque.
    &else
        disp stream relat-acomp
            tt-selecao-embarque.embarque            
            tt-selecao-embarque.cod-incoterm                               
            tt-selecao-embarque.declaracao-import   
            tt-selecao-embarque.cod-conhecto-master        
            tt-selecao-embarque.cod-conhecto-house with frame f-sel-embarque-2.
        down with frame f-sel-embarque-2.
    &endif
end.

IF CAN-FIND (FIRST impto-item-docto
                 where impto-item-docto.serie-docto  = tt-docum-est.serie-docto     
                   and impto-item-docto.nro-docto    = tt-parametros.nro-docto    
                   and impto-item-docto.cod-emitente = tt-parametros.cod-emitente 
                   and impto-item-docto.nat-operacao = tt-parametros.nat-operacao) THEN DO:

    {utp/ut-liter.i "IMPOSTOS" *}
    ASSIGN c-liter-1 = TRIM(RETURN-VALUE).

    put stream relat-acomp
                                             skip(2)   
            "------------------------" at 45 skip
            "        " c-liter-1       at 46 skip
            "------------------------" at 45 skip(2).
    
    assign acm-imp-me = 0
           acm-imp-mn = 0.
    
    FOR EACH docum-est-cex NO-LOCK
        WHERE docum-est-cex.serie-docto      = tt-docum-est.serie-docto   
              AND docum-est-cex.nro-docto    = tt-parametros.nro-docto     
              AND docum-est-cex.cod-emitente = tt-parametros.cod-emitente  
              AND docum-est-cex.nat-operacao = tt-parametros.nat-operacao:
    
        FIND FIRST desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = docum-est-cex.cod-desp NO-ERROR.
        
         IF  AVAIL desp-imp
         AND desp-imp.inc-base-ipi THEN
            ASSIGN de-base-impostos = de-base-impostos + docum-est-cex.val-desp.
    
    END.
    
    for each impto-item-docto no-lock
    	where impto-item-docto.serie-docto  = tt-docum-est.serie-docto
    	  and impto-item-docto.nro-docto    = tt-parametros.nro-docto
          and impto-item-docto.cod-emitente = tt-parametros.cod-emitente
          and impto-item-docto.nat-operacao = tt-parametros.nat-operacao
        BREAK BY impto-item-docto.cdn-imposto:
    	  
       IF FIRST-OF (impto-item-docto.cdn-imposto) THEN DO:
            FIND FIRST tipo-tax NO-LOCK
                WHERE tipo-tax.cod-tax = impto-item-docto.cdn-imposto NO-ERROR.
        
            assign acm-imp-me = acm-imp-me + impto-item-docto.val-impto-merc-ext
                   acm-imp-mn = acm-imp-mn + impto-item-docto.val-impto.
        
           disp stream relat-acomp
                 impto-item-docto.cdn-imposto
                 tipo-tax.descricao   
                 de-base-impostos 
                 impto-item-docto.perc-imposto
                 impto-item-docto.val-impto-merc-ext 
                 impto-item-docto.val-impto WITH FRAME f-impto. 
           down with frame f-impto. 
       END.
    end.
    
    {utp/ut-liter.i "TOTAL_IMPOSTOS" *}
    ASSIGN c-liter-1 = TRIM(RETURN-VALUE).

    put stream relat-acomp SKIP "------------------ ------------------" AT 68.
    put stream relat-acomp SKIP c-liter-1 FORMAT "x(13)" AT 52  ": " .
    put stream relat-acomp acm-imp-me TO 85.
    put stream relat-acomp acm-imp-mn TO 104.
END.

{utp/ut-liter.i "DESPESAS_SELECIONADAS" *}
ASSIGN c-liter-1 = TRIM(RETURN-VALUE).

put stream relat-acomp
                                     skip(2)   
    "------------------------" at 45 skip
    c-liter-1                  at 46 skip
    "------------------------" at 45 skip(2).

for each  tt-desp-embarque
    where tt-desp-embarque.selecionado = yes:

    FIND FIRST despes-embarq-internac 
         where despes-embarq-internac.cod-estabel       = tt-desp-embarque.cod-estabel
           and despes-embarq-internac.embarque          = tt-desp-embarque.embarque
           and despes-embarq-internac.cod-itiner        = tt-desp-embarque.cod-itiner
           and despes-embarq-internac.cod-pto-contr     = tt-desp-embarque.cod-pto-contr
           and despes-embarq-internac.cod-desp          = tt-desp-embarque.cod-desp
           and despes-embarq-internac.cod-emitente-desp = tt-desp-embarque.cod-emitente-desp no-lock no-error. 

    IF i-pais-impto-usuario = 9 /* Paraguai */ AND AVAIL despes-embarq-internac THEN DO:
        disp stream relat-acomp
             tt-desp-embarque.cod-desp          
             tt-desp-embarque.desc-desp         
             tt-desp-embarque.cod-emitente-desp 
             tt-desp-embarque.embarque          
             tt-desp-embarque.cod-pto-contr
             tt-desp-embarque.val-desp     
             despes-embarq-internac.cdn-imposto            
             despes-embarq-internac.val-preco-unit-isento  
             despes-embarq-internac.val-preco-unit-com-iva 
             despes-embarq-internac.val-preco-unit                              
             tt-desp-embarque.cond-pagto with frame f-sel-despesa-pry.
        down with frame f-sel-despesa-pry.
    END.
    ELSE DO:
        disp stream relat-acomp
            tt-desp-embarque.cod-desp          
            tt-desp-embarque.desc-desp         
            tt-desp-embarque.cod-emitente-desp 
            tt-desp-embarque.embarque          
            tt-desp-embarque.cod-pto-contr     
            tt-desp-embarque.val-desp          
            tt-desp-embarque.cond-pagto with frame f-sel-despesa.
        down with frame f-sel-despesa.
    END.
  
end.

FIND FIRST tt-docum-est NO-ERROR.

find docum-est 
    where docum-est.cod-emitente = tt-docum-est.cod-emitente 
    and   docum-est.nro-docto    = tt-docum-est.nro-docto    
    and   docum-est.serie-docto  = tt-docum-est.serie-docto  
    and   docum-est.nat-operacao = tt-docum-est.nat-operacao  no-lock no-error.
if  avail docum-est then do:
    disp stream relat-acomp
        docum-est.cod-emitente  
        docum-est.nro-docto    
        docum-est.serie-docto   
        docum-est.nat-operacao with frame f-documento.
    if l-executar then do:
        assign cvalormercad = string(docum-est.valor-mercad, ">>>>>,>>>,>>9.99").
        put stream relat-acomp 
            "Vl Tot Mercad:" at 42 trim(cvalormercad) format "x(16)" at 57.
    end.

end.

if  not valid-handle (h-bocx095) then
    run cxbo/bocx095.p persistent set h-bocx095.

put stream relat-acomp skip (2).
for each  docum-est-cex 
    where docum-est-cex.serie-docto       = docum-est.serie-docto
    and   docum-est-cex.nro-docto         = docum-est.nro-docto
    and   docum-est-cex.cod-emitente      = docum-est.cod-emitente
    and   docum-est-cex.nat-operacao      = docum-est.nat-operacao no-lock:

    run retornaDescDespesa in h-bocx095 (input docum-est-cex.cod-desp, output cdescricaodesp).

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

        ASSIGN de-valor-isento  = 0
               de-valor-sem-iva = 0
               de-valor-com-iva = 0
               i-imposto        = 0.

        FOR EACH item-doc-est-cex OF docum-est-cex NO-LOCK:
            FIND FIRST item-doc-est-cex-internac OF item-doc-est-cex NO-LOCK NO-ERROR.
            IF AVAIL item-doc-est-cex-internac THEN
                ASSIGN de-valor-isento  = de-valor-isento  + item-doc-est-cex-internac.val-preco-unit-isento
                       de-valor-sem-iva = de-valor-sem-iva + item-doc-est-cex-internac.val-preco-unit
                       de-valor-com-iva = de-valor-com-iva + item-doc-est-cex-internac.val-preco-unit-com-iva
                       i-imposto        = item-doc-est-cex-internac.cdn-imposto.
        END.
        
        disp stream relat-acomp
             docum-est-cex.cod-desp         
             cdescricaodesp                 
             docum-est-cex.cod-emitente-desp
             docum-est-cex.val-desp         
             i-imposto
             de-valor-isento
             de-valor-com-iva
             de-valor-sem-iva             
             docum-est-cex.cod-cond-pag with frame f-despesa-cex-pry.
        down with frame f-despesa-cex-pry.

    END.
    ELSE DO:
        disp stream relat-acomp
            docum-est-cex.cod-desp         
            cdescricaodesp                 
            docum-est-cex.cod-emitente-desp
            docum-est-cex.val-desp         
            docum-est-cex.cod-cond-pag with frame f-despesa-cex.
        down with frame f-despesa-cex.
    END.
end.

IF NOT VALID-HANDLE(h-boin759na) THEN
    RUN inbo/boin759na.p PERSISTENT SET h-boin759na.

EMPTY TEMP-TABLE tt-impto-item-docto.
RUN getImptoItemDoctoByDocumEst IN h-boin759na (INPUT ROWID(docum-est),
                                                INPUT 0, /*retornar todos*/
                                                OUTPUT TABLE tt-impto-item-docto).

IF CAN-FIND(FIRST tt-impto-item-docto) THEN   
    DISP STREAM relat-acomp
        WITH FRAME f-impto-cabec.


FOR EACH tt-impto-item-docto,
    FIRST tipo-tax NO-LOCK
    WHERE tipo-tax.cod-tax = tt-impto-item-docto.cdn-imposto:

    ASSIGN c-desc-impto = tipo-tax.descricao.

    DISP STREAM relat-acomp
        tt-impto-item-docto.cdn-imposto    
        c-desc-impto
        tt-impto-item-docto.perc-imposto       
        tt-impto-item-docto.val-impto          
        tt-impto-item-docto.val-impto-merc-ext WITH FRAME f-imposto.
        DOWN WITH FRAME f-imposto.
END.

IF VALID-HANDLE(h-boin759na) THEN DO:
    RUN destroy IN h-boin759na.
    ASSIGN h-boin759na = ?.
END.

if  valid-handle (h-bocx095) then do:
    delete procedure h-bocx095.
    assign h-bocx095 = ?.
end.

output stream relat-acomp close.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 3
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.arquivo         = session:temp-directory + "im3101.tmp".

{include/i-rptrm.i}

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.


return "OK":U.     



