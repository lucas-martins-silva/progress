/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0109 2.00.00.005 } /*** 010005 ***/


/*************************************************************************
**    Programa.:  AGCQ0109
**    Objetivo.:  UPC para solicitar as Faixas para procura dos componentes.
**    Data.....:  Agosto/2003
*************************************************************************/

/*********************** Defini‡Æo de Parƒmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.


/* Projeto DAGR001 - IRM1909 - Replanejamento 11.8 para 11.5.10 - classifica‡Æo     */
{ggp/gg0001.i}


/******************** Defini‡Æo de Vari veis Globais *********************/
DEF NEW GLOBAL SHARED VAR tx-faixa-ini-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-faixa-fim-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-faixa-ini-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-faixa-fim-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-val-perc-desc-cq0109  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-val-perc-desc-cq0109  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-perc-padr-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-perc-padr-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-valr-padr-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-valr-padr-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-val-comp-preco-cq0109 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-val-comp-preco-cq0109 AS WIDGET-HANDLE NO-UNDO.
                                 
DEF NEW GLOBAL SHARED VAR wgh-bt-ok               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-bt-save             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-bt-cancela          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-bt-ajuda            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-rt-button           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR rt-upc-1                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-seq-comp-cq0109      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-descricao-cq0109     AS WIDGET-HANDLE NO-UNDO.

def new global shared var gr-tab-result           as rowid no-undo. /*vari vel global que possui o rowid do registro Pai */
                                                                       
/******************** Defini‡Æo de Vari veis Locais **********************/
Define var  c-char                                     as char           no-undo.
Define Var  wh-objeto                                  as widget-handle  no-undo.

/******************** Vari veis para aumentar a window *******************/
DEF NEW GLOBAL SHARED VAR wgh-grupo               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-fpage0              AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER b-comp-tab-res FOR comp-tab-res.
/************************** In¡cio do Programa ***************************/
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/") NO-ERROR.
       /*
MESSAGE "Evento ...:"   p-ind-event   SKIP
        "Objeto ...:"   p-ind-object  SKIP
        "HObjeto...:"   p-wgh-object  SKIP
        "hFrame ...:"   p-wgh-frame   SKIP
        "Tabela ...:"   p-cod-table   SKIP
        "Rowid  ...:"   string(p-row-table)   SKIP
        "NomeObjeto:"   c-char    .
         */
/*  AUMENTA WINDOW VIA UPC */ 


ASSIGN wgh-fpage0 = p-wgh-frame.

 IF p-ind-event = "before-initialize" AND 
    p-ind-object = "container" THEN DO:
 
     /* Aumenta a window via UPC */
     ASSIGN CURRENT-WINDOW:HEIGHT = 8.25
            wgh-fpage0:HEIGHT     = 8.25.
     
     ASSIGN wgh-grupo  = p-wgh-frame:FIRST-CHILD.
    
     DO WHILE VALID-HANDLE(wgh-grupo):
        IF wgh-grupo:TYPE = "button" THEN DO:
           CASE wgh-grupo:NAME:
                WHEN "bt-ok"    THEN 
                      ASSIGN wgh-bt-ok      = wgh-grupo:HANDLE. 
                WHEN "bt-save"  THEN 
                      ASSIGN wgh-bt-save    = wgh-grupo:HANDLE. 
                WHEN "bt-cancela"  THEN 
                      ASSIGN wgh-bt-cancela = wgh-grupo:HANDLE. 
                WHEN "bt-ajuda"  THEN 
                      ASSIGN wgh-bt-ajuda   = wgh-grupo:HANDLE. 
            END CASE. 
        END.
         
        IF wgh-grupo:TYPE = "rectangle" THEN DO:
           IF wgh-grupo:NAME = "rt-button"    THEN 
              ASSIGN wgh-rt-button  = wgh-grupo:HANDLE. 
        END.
                                                              
        IF wgh-grupo:TYPE = "field-group" THEN
           ASSIGN wgh-grupo = wgh-grupo:FIRST-CHILD.
        ELSE 
           ASSIGN wgh-grupo = wgh-grupo:NEXT-SIBLING.
     END. /* do while */ 
 
     ASSIGN wgh-bt-ok:ROW        = 8.15
            wgh-bt-save:ROW      = 8.15
            wgh-bt-cancela:ROW   = 8.15
            wgh-bt-ajuda:ROW     = 8.15
            wgh-rt-button:ROW    = 4.45
            wgh-rt-button:HEIGHT = 3.10.  

     CREATE RECTANGLE  rt-upc-1
     ASSIGN FRAME             = p-wgh-frame
            WIDTH             = 88.5
            HEIGHT            = 1.45
            ROW               = 7.85
            COL               = 1.3
            NAME              = 'rect-Upc-1'
            EDGE-PIXELS       = 2
            BGCOLOR           = 8.

      rt-upc-1:GRAPHIC-EDGE.
      
     CREATE text tx-faixa-ini-cq0109                            
     ASSIGN FRAME        = p-wgh-frame
            FORMAT       = "x(14)"
            WIDTH        = 12
            HEIGHT       = 00.88
            SCREEN-VALUE = "Faixa Inicial:"
            ROW          = 4.57
            COL          = 11.5
            VISIBLE      = YES.
 
     CREATE FILL-IN wh-faixa-ini-cq0109                        
     ASSIGN FRAME             = p-wgh-frame
            SIDE-LABEL-HANDLE = tx-faixa-ini-cq0109:HANDLE        
            LABEL             = "Faixa Inicial:"     
            DATA-TYPE         = "decimal"
            FORMAT            = "->>,>>9.9999"
            WIDTH             = 13.00
            HEIGHT            = .88
            ROW               = 4.57
            COL               = 20.25
            NAME              = "wh-faixa-ini"
            SENSITIVE         = NO
            VISIBLE           = YES.

     CREATE text tx-faixa-fim-cq0109                            
     ASSIGN FRAME        = p-wgh-frame
            FORMAT       = "x(14)"
            WIDTH        = 12.00
            HEIGHT       = 00.88
            SCREEN-VALUE = "Faixa Final:"
            ROW          = 4.57
            COL          = 42
            VISIBLE      = YES.
 
     CREATE FILL-IN wh-faixa-fim-cq0109                        
     ASSIGN FRAME             = p-wgh-frame
            SIDE-LABEL-HANDLE = tx-faixa-fim-cq0109:HANDLE        
            LABEL             = "Faixa Final: "     
            DATA-TYPE         = "decimal"     
            FORMAT            = "->>,>>9.9999"
            WIDTH             = 13.00
            HEIGHT            = .88
            ROW               = 4.57
            COL               = 55
            NAME              = "wh-faixa-fim"
            SENSITIVE         = NO
            VISIBLE           = YES.

     CREATE text tx-val-perc-desc-cq0109                            
     ASSIGN FRAME        = p-wgh-frame
            FORMAT       = "x(11)"
            WIDTH        = 10.00
            HEIGHT       = 00.88
            SCREEN-VALUE = "% Desconto:"
            ROW          = 5.57
            COL          = 11.5
            VISIBLE      = YES.
 
     CREATE FILL-IN wh-val-perc-desc-cq0109                        
     ASSIGN FRAME             = p-wgh-frame
            SIDE-LABEL-HANDLE = tx-val-perc-desc-cq0109:HANDLE        
            LABEL             = "% Desconto: "     
            DATA-TYPE         = "decimal"     
            FORMAT            = ">>9.9999"
            WIDTH             = 13.00
            HEIGHT            = .88
            ROW               = 5.57
            COL               = 20.25
            NAME              = "wh-val-perc-desc"
            SENSITIVE         = NO
            VISIBLE           = YES.

     CREATE text tx-val-comp-preco-cq0109                            
     ASSIGN FRAME        = p-wgh-frame
            FORMAT       = "x(15)"
            WIDTH        = 15.00
            HEIGHT       = 00.88
            SCREEN-VALUE = "Vlr Comp Preco:"
            ROW          = 5.57
            COL          = 42
            VISIBLE      = YES.
 
     CREATE FILL-IN wh-val-comp-preco-cq0109                        
     ASSIGN FRAME             = p-wgh-frame
            SIDE-LABEL-HANDLE = tx-val-comp-preco-cq0109:HANDLE        
            LABEL             = "Vlr Comp Preco: "     
            DATA-TYPE         = "decimal"     
            FORMAT            = "->>>,>>9.9999"
            WIDTH             = 13.00
            HEIGHT            = .88
            ROW               = 5.57
            COL               = 55
            NAME              = "wh-val-comp-preco"
            SENSITIVE         = NO
            VISIBLE           = YES.              

      CREATE text tx-perc-padr-cq0109
      ASSIGN FRAME        = p-wgh-frame
             FORMAT       = "x(10)"
             WIDTH        = 09.00
             HEIGHT       = 00.88
             SCREEN-VALUE = "% Tx Padr:"
             ROW          = 6.57
             COL          = 11.5
             VISIBLE      = YES.
      
      CREATE FILL-IN wh-perc-padr-cq0109                        
      ASSIGN FRAME             = p-wgh-frame
             SIDE-LABEL-HANDLE = tx-perc-padr-cq0109:HANDLE        
             LABEL             = "% Tx Padr: "     
             DATA-TYPE         = "decimal"     
             FORMAT            = ">>9.99"
             WIDTH             = 6.00
             HEIGHT            = .88
             ROW               = 6.57
             COL               = 20.25
             NAME              = "wh-perc-padr"
             SENSITIVE         = NO
             VISIBLE           = YES.

      CREATE text tx-valr-padr-cq0109
      ASSIGN FRAME        = p-wgh-frame
             FORMAT       = "x(15)"
             WIDTH        = 15.00
             HEIGHT       = 00.88
             SCREEN-VALUE = "R$ Tx Padrao:"
             ROW          = 6.57
             COL          = 42
             VISIBLE      = YES.
      
      CREATE FILL-IN wh-valr-padr-cq0109                        
      ASSIGN FRAME             = p-wgh-frame
             SIDE-LABEL-HANDLE = tx-valr-padr-cq0109:HANDLE        
             LABEL             = "R$ Tx Padrao: "     
             DATA-TYPE         = "decimal"     
             FORMAT            = "->>>,>>9.9999"
             WIDTH             = 13.00
             HEIGHT            = .88
             ROW               = 6.57
             COL               = 55
             NAME              = "wh-valr-padr"
             SENSITIVE         = NO
             VISIBLE           = YES.
      
      tx-faixa-ini-cq0109:MOVE-TO-TOP().
      tx-faixa-fim-cq0109:MOVE-TO-TOP().
      wh-faixa-ini-cq0109:MOVE-TO-TOP().
      wh-faixa-fim-cq0109:MOVE-TO-TOP().
      wh-val-perc-desc-cq0109:MOVE-TO-TOP().
      wh-perc-padr-cq0109:MOVE-TO-TOP().
      wh-valr-padr-cq0109:MOVE-TO-TOP().
      wh-val-comp-preco-cq0109:MOVE-TO-TOP().

      wh-faixa-ini-cq0109:MOVE-BEFORE-TAB-ITEM(wgh-bt-ok).
      wh-faixa-fim-cq0109:MOVE-AFTER-TAB-ITEM(wh-faixa-ini-cq0109).  
      wh-val-perc-desc-cq0109:MOVE-AFTER-TAB-ITEM(wh-faixa-fim-cq0109).
      wh-val-comp-preco-cq0109:MOVE-AFTER-TAB-ITEM(wh-val-perc-desc-cq0109).
      wh-perc-padr-cq0109:MOVE-AFTER-TAB-ITEM(wh-val-comp-preco-cq0109).
      wh-valr-padr-cq0109:MOVE-AFTER-TAB-ITEM(wh-perc-padr-cq0109).
END.

if  p-ind-object  = 'VIEWER'      and
    p-ind-event   = 'INITIALIZE'   and
    c-char        = 'v02in052.w'  then do:
    assign wh-objeto = p-wgh-frame:FIRST-CHILD.
    do  while valid-handle(wh-objeto):
        if  wh-objeto:NAME = "descricao" 
            then assign wh-descricao-cq0109 = wh-objeto.
        if  wh-objeto:NAME = "seq-comp" 
            then assign wh-seq-comp-cq0109 = wh-objeto.

        if  wh-objeto:TYPE = 'field-group' 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
    end.
    on 'leave' of wh-seq-comp-cq0109  persistent
          run agro-upc/ggcq0109a.p. 
end.
  
if  p-ind-event   = "ADD" and
    p-ind-object  = 'VIEWER'      and
    c-char        = 'v02in052.w' then do: 
    IF VALID-HANDLE(wh-faixa-ini-cq0109) THEN
       ASSIGN wh-faixa-ini-cq0109:SCREEN-VALUE     = ""
              wh-faixa-fim-cq0109:SCREEN-VALUE     = ""
              wh-val-perc-desc-cq0109:SCREEN-VALUE = ""
              wh-val-comp-preco-cq0109:SCREEN-VALUE = ""
              wh-perc-padr-cq0109:SCREEN-VALUE     = ""
              wh-valr-padr-cq0109:SCREEN-VALUE     = "".
END.

if  p-ind-event   = "validate" and
    p-ind-object  = 'VIEWER'      and
    c-char        = 'v02in052.w' then do:     
    IF wh-faixa-ini-cq0109:SENSITIVE = YES THEN DO:
       IF wh-faixa-fim-cq0109:SCREEN-VALUE = "" OR
          wh-faixa-fim-cq0109:SCREEN-VALUE = "0,0000" THEN DO:
          
          {utp/ut-liter.i "Faixa Final deve ser informada" * R}
          RUN utp/ut-msgs.p (INPUT "SHOW",
                             INPUT 17567,
                             INPUT RETURN-VALUE).

          APPLY 'entry' TO wh-faixa-fim-cq0109.
          RETURN "nok".
       END.
       IF wh-faixa-ini-cq0109:SCREEN-VALUE > wh-faixa-fim-cq0109:SCREEN-VALUE THEN DO:

          RUN utp/ut-msgs.p (INPUT "SHOW",
                             INPUT 794,
                             INPUT RETURN-VALUE).

          APPLY 'entry' TO wh-faixa-ini-cq0109.
          RETURN "nok".
       END.
    END.
end. 

if  p-ind-object  = 'VIEWER'      and
    p-ind-event   = 'Display'   and
    c-char        = 'v02in052.w'   then do:
                
    IF p-row-table <> ? AND 
       valid-handle(wh-faixa-ini-cq0109) THEN DO:
       FIND FIRST comp-tab-res NO-LOCK 
             WHERE rowid(comp-tab-res) = p-row-table NO-ERROR.
       IF AVAIL comp-tab-res THEN  DO:
          FIND FIRST gg-ext-comp-tab-res NO-LOCK
               WHERE gg-ext-comp-tab-res.nr-tabela = comp-tab-res.nr-tabela
                 AND gg-ext-comp-tab-res.seq-comp  = comp-tab-res.seq-comp  NO-ERROR.
          IF AVAIL gg-ext-comp-tab-res THEN DO:
             ASSIGN wh-faixa-ini-cq0109:SCREEN-VALUE      = string(gg-ext-comp-tab-res.num-faixa-ini)
                    wh-faixa-fim-cq0109:SCREEN-VALUE      = string(gg-ext-comp-tab-res.num-faixa-fim)
                    wh-val-perc-desc-cq0109:SCREEN-VALUE  = string(gg-ext-comp-tab-res.val-perc-desc)
                    wh-val-comp-preco-cq0109:SCREEN-VALUE = STRING(gg-ext-comp-tab-res.vlr-comp-preco)
                    wh-perc-padr-cq0109:SCREEN-VALUE      = STRING(gg-ext-comp-tab-res.perc-desc-pdr)
                    wh-valr-padr-cq0109:SCREEN-VALUE      = STRING(gg-ext-comp-tab-res.val-desc-pdr).
          END.
          ELSE do: 
              ASSIGN wh-faixa-ini-cq0109:SCREEN-VALUE      = ""
                     wh-faixa-fim-cq0109:SCREEN-VALUE      = ""
                     wh-val-perc-desc-cq0109:SCREEN-VALUE  = ""
                     wh-val-comp-preco-cq0109:SCREEN-VALUE = ""
                     wh-perc-padr-cq0109:SCREEN-VALUE      = ""
                     wh-valr-padr-cq0109:SCREEN-VALUE      = "".
          END.
       END.
    END.
END.  

if p-ind-event   =  "enable"       and
   p-ind-object  =  "viewer"       and
   c-char        =  'v02in052.w'  then do:
   IF VALID-HANDLE(wh-faixa-ini-cq0109) THEN DO:
      FIND FIRST tab-result NO-LOCK 
           WHERE rowid(tab-result) = gr-tab-result NO-ERROR.
      IF AVAIL tab-result THEN DO:
         FIND FIRST gg-ext-tab-result NO-LOCK
              WHERE gg-ext-tab-result.nr-tabela = tab-result.nr-tabela NO-ERROR.
         IF AVAIL gg-ext-tab-result THEN DO:
            IF gg-ext-tab-result.log-faixa = YES THEN 
               ASSIGN wh-faixa-ini-cq0109:SENSITIVE      = YES
                      wh-faixa-fim-cq0109:SENSITIVE      = YES
                      wh-val-perc-desc-cq0109:SENSITIVE  = YES
                      wh-val-comp-preco-cq0109:SENSITIVE = YES
                      wh-descricao-cq0109:SENSITIVE      = NO
                      wh-perc-padr-cq0109:SENSITIVE      = YES
                      wh-valr-padr-cq0109:SENSITIVE      = YES.
            ELSE
               ASSIGN wh-faixa-ini-cq0109:SENSITIVE      = NO
                      wh-faixa-fim-cq0109:SENSITIVE      = NO
                      wh-val-perc-desc-cq0109:SENSITIVE  = NO
                      wh-val-comp-preco-cq0109:SENSITIVE = YES
                      wh-descricao-cq0109:SENSITIVE      = YES
                      wh-perc-padr-cq0109:SENSITIVE      = NO
                      wh-valr-padr-cq0109:SENSITIVE      = NO.
         END.
      END.
   END.
END.

if p-ind-event  = "assign"   and 
   p-ind-object = "viewer"       and
   c-char       = "v02in052.w"  then do:
   
    FIND FIRST tab-result NO-LOCK 
         WHERE rowid(tab-result) = gr-tab-result NO-ERROR.
    IF AVAIL tab-result THEN DO:
       FIND FIRST gg-ext-tab-result NO-LOCK
            WHERE gg-ext-tab-result.nr-tabela = tab-result.nr-tabela NO-ERROR.
       IF AVAIL gg-ext-tab-result THEN DO:
          
          
             FIND FIRST comp-tab-res NO-LOCK
                  WHERE rowid(comp-tab-res) = p-row-table NO-ERROR.
             IF AVAIL comp-tab-res THEN DO:
                FIND FIRST gg-ext-comp-tab-res EXCLUSIVE-LOCK
                     WHERE gg-ext-comp-tab-res.nr-tabela = comp-tab-res.nr-tabela
                       AND gg-ext-comp-tab-res.seq-comp  = comp-tab-res.seq-comp  NO-ERROR.
                IF NOT AVAIL gg-ext-comp-tab-res THEN DO:
                   CREATE gg-ext-comp-tab-res.
                   ASSIGN gg-ext-comp-tab-res.nr-tabela         = tab-result.nr-tabela
                          gg-ext-comp-tab-res.seq-comp          = int(wh-seq-comp-cq0109:SCREEN-VALUE)
                          gg-ext-comp-tab-res.num-faixa-ini     = decimal(wh-faixa-ini-cq0109:SCREEN-VALUE)    
                          gg-ext-comp-tab-res.num-faixa-fim     = decimal(wh-faixa-fim-cq0109:SCREEN-VALUE)    
                          gg-ext-comp-tab-res.val-perc-desc     = decimal(wh-val-perc-desc-cq0109:SCREEN-VALUE)
                          gg-ext-comp-tab-res.vlr-comp-preco    = decimal(wh-val-comp-preco-cq0109:SCREEN-VALUE)
                          gg-ext-comp-tab-res.perc-desc-pdr     = DECIMAL(wh-perc-padr-cq0109:SCREEN-VALUE)
                          gg-ext-comp-tab-res.val-desc-pdr      = DECIMAL(wh-valr-padr-cq0109:SCREEN-VALUE).

                END.
                ELSE ASSIGN gg-ext-comp-tab-res.num-faixa-ini   = decimal(wh-faixa-ini-cq0109:SCREEN-VALUE)     
                            gg-ext-comp-tab-res.num-faixa-fim   = decimal(wh-faixa-fim-cq0109:SCREEN-VALUE)     
                            gg-ext-comp-tab-res.val-perc-desc   = decimal(wh-val-perc-desc-cq0109:SCREEN-VALUE)
                            gg-ext-comp-tab-res.vlr-comp-preco  = DECIMAL(wh-val-comp-preco-cq0109:SCREEN-VALUE)
                            gg-ext-comp-tab-res.perc-desc-pdr   = DECIMAL(wh-perc-padr-cq0109:SCREEN-VALUE)
                            gg-ext-comp-tab-res.val-desc-pdr    = DECIMAL(wh-valr-padr-cq0109:SCREEN-VALUE).

                IF  gg-ext-tab-result.log-faixa = YES THEN DO:
                    FIND CURRENT comp-tab-res EXCLUSIVE-LOCK.
                    ASSIGN comp-tab-res.descricao = wh-faixa-ini-cq0109:SCREEN-VALUE.
                    FIND CURRENT comp-tab-res NO-LOCK.
                END.
              END.
       END.
    END.
 END.
  
  

  
