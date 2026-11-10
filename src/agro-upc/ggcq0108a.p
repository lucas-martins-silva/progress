/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0108A 2.00.00.004 } /*** 010004 ***/


/*************************************************************************
**    Programa.:  AGCQ0108
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
define new global shared VAR  v-wgh-object      AS handle        no-undo.

/******************** Defini‡Æo de Vari veis Locais **********************/
Define var  c-char                                     as char           no-undo.
Define Var  wh-objeto                                  as widget-handle  no-undo.
Define NEW GLOBAL SHARED VAR  wh-faixa-cq0108a        as widget-handle  no-undo.


Define Var  c-folder                             as Char           no-undo.

DEFINE VARIABLE c-mes1 AS CHARACTER FORMAT "x(13)"  NO-UNDO.

{utp/ut-liter.i "Possui Faixa?" * R}
ASSIGN c-mes1 = RETURN-VALUE.

/************************** In¡cio do Programa ***************************/

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/":U), p-wgh-object:file-name,"~/":U) NO-ERROR.
       
v-wgh-object = p-wgh-object.

/*
MESSAGE "Evento ...:"   p-ind-event   SKIP
        "Objeto ...:"   p-ind-object  SKIP
        "HObjeto...:"   p-wgh-object  SKIP
        "hFrame ...:"   p-wgh-frame   SKIP
        "Tabela ...:"   p-cod-table   SKIP
        "Rowid  ...:"   string(p-row-table)   SKIP
        "NomeObjeto:"   c-char   .
  */

if  p-ind-event   = "initialize":U and
    p-ind-object  = 'VIEWER':U      and
    c-char        = 'v01in416.w':U then do:     

    {utp/ut-liter.i "Possui faixa para encontrar componente?" * R}
    create toggle-box wh-faixa-cq0108a 
    assign frame     = p-wgh-frame
           col       = 68
           row       = 2.70
           visible   = yes
           sensitive = NO
           help      = RETURN-VALUE
           label     = c-mes1.

end.
if  p-ind-object  = 'VIEWER':U      and
    p-ind-event   = 'Display':U   and
    c-char        = 'v01in416.w':U  then do:

    IF p-row-table <> ? AND 
       valid-handle(wh-faixa-cq0108a) THEN DO:
       FIND FIRST tab-result NO-LOCK WHERE rowid(tab-result) = p-row-table NO-ERROR.
       IF AVAIL tab-result THEN  DO:
           FIND FIRST gg-ext-tab-result NO-LOCK
                WHERE gg-ext-tab-result.nr-tabela = tab-result.nr-tabela NO-ERROR.
           IF AVAIL gg-ext-tab-result THEN 
               ASSIGN wh-faixa-cq0108a:CHECKED = gg-ext-tab-result.log-faixa.
           ELSE ASSIGN wh-faixa-cq0108a:CHECKED = NO.
       END.
    END.
END.          
                       
if p-ind-event   =  "enable":U       and
   p-ind-object  =  "viewer":U       and
   c-char   =  'v01in416.w':U  then do:
   
  IF VALID-HANDLE(wh-faixa-cq0108a) THEN
     ASSIGN wh-faixa-cq0108a:SENSITIVE = YES.

end.   

if p-ind-event  = "assign":U   and 
   p-ind-object = "viewer":U       and
   c-char       = "v01in416.w":U  then do:
   
   FIND FIRST tab-result NO-LOCK WHERE rowid(tab-result) = p-row-table NO-ERROR.
   IF AVAIL tab-result THEN  DO:
      FIND FIRST gg-ext-tab-result EXCLUSIVE-LOCK
           WHERE gg-ext-tab-result.nr-tabela = tab-result.nr-tabela NO-ERROR.
      IF NOT AVAIL gg-ext-tab-result THEN DO:
         CREATE gg-ext-tab-result.
         ASSIGN gg-ext-tab-result.nr-tabela    = tab-result.nr-tabela
                gg-ext-tab-result.log-faixa    = wh-faixa-cq0108a:CHECKED.
      END.
      ELSE ASSIGN gg-ext-tab-result.log-faixa  = wh-faixa-cq0108a:CHECKED.
   END.
end.
  
  
