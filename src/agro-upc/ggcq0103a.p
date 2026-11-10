/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0103A 2.00.00.005 } /*** 010005 ***/

/***********************************************************************
** Programa: agro-upc/ggcq0103a.p
** Objetivo: Campo para informar se nota do Recebimento procisa de pedido
************************************************************************/

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID      NO-UNDO.


/* Projeto DAGR001 - IRM1909 - Replanejamento 11.8 para 11.5.10 - classifica‡Æo     */
{ggp/gg0001.i}


DEFINE VARIABLE h-win                                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-char                                    AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-lbl-resp-padrao           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-resp-padrao-v02in164 AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-resp-padrao-v02in164  AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-ordem-v02in164  AS CHAR NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-lbl-ordem            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-resp-ordem-v02in164  AS WIDGET-HANDLE NO-UNDO.


DEFINE VARIABLE l-achou AS LOGICAL    NO-UNDO.

ASSIGN h-win = p-wgh-object.
IF NOT VALID-HANDLE(h-win) THEN RETURN "OK":U.
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/":U), p-wgh-object:FILE-NAME,"~/":U).
/**************************************************************************/

/*MESSAGE "Evento ...:"   p-ind-event         SKIP
        "Objeto ...:"   p-ind-object        SKIP
        "HObjeto...:"   p-wgh-object        SKIP
        "hFrame ...:"   p-wgh-frame         SKIP
        "Tabela ...:"   p-cod-table         SKIP
        "Rowid  ...:"   string(p-row-table) SKIP
        "NomeObjeto:"   c-char         .*/

IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "viewer":U     AND
    c-char       = "v02in164.w":U THEN DO:
    {agro-upc/ggcq0103.i5}
    {utp/ut-liter.i "Resultado padrao" * R}
    CREATE FILL-IN wh-resp-padrao-v02in164
    ASSIGN FRAME        = p-wgh-frame
           COLUMN       = 74
           ROW          = 7
           SENSITIVE    = NO
           VISIBLE      = YES
           NAME         = RETURN-VALUE
           FORMAT       = "x(6)"
           TOOLTIP      = RETURN-VALUE
           HELP         = RETURN-VALUE.


    /***/
    {utp/ut-liter.i "Ordem do Exame: " * R}
    CREATE TEXT wh-lbl-ordem
    ASSIGN FRAME          = p-wgh-frame
           COLUMN         = 60
           ROW            = 6.2
           VISIBLE        = YES 
           FORMAT         = "x(18)"
           SCREEN-VALUE   = return-value.

    {utp/ut-liter.i "Ordem do Exame" * R}
    CREATE FILL-IN wh-resp-ordem-v02in164
    ASSIGN FRAME        = p-wgh-frame
           DATA-TYPE    = "integer"
           COLUMN       = 74
           WIDTH        = 3
           ROW          = 6
           SENSITIVE    = NO
           VISIBLE      = YES
           NAME         = RETURN-VALUE
           FORMAT       = ">9"
           TOOLTIP      = RETURN-VALUE
           HELP         = RETURN-VALUE.

    /***/
END.
      
IF  p-ind-event  = "add":U        AND
    p-ind-object = "viewer":U     AND
    c-char       = "v02in164.w":U THEN DO:
    {agro-upc/ggcq0103.i5}
    {utp/ut-liter.i "Ordem do Exame: " * R}
    CREATE TEXT wh-lbl-ordem
    ASSIGN FRAME          = p-wgh-frame
           COLUMN         = 60
           ROW            = 6.2
           VISIBLE        = YES 
           FORMAT         = "x(18)"
           SCREEN-VALUE   = return-value.
    ASSIGN wh-lbl-resp-padrao:VISIBLE = YES.
    ASSIGN wh-lbl-ordem:VISIBLE = YES.

    ASSIGN wh-resp-ordem-v02in164:SCREEN-VALUE = "0":U.
END.
                         
IF  p-ind-event  = "after-enable":U AND
    p-ind-object = "VIEWER":U       AND
    c-char       = "v02in164.w":U   THEN DO:
    ASSIGN wh-resp-padrao-v02in164:SENSITIVE = YES
           wh-resp-ordem-v02in164:SENSITIVE  = YES.
           
END.
                           
IF  p-ind-event  = "after-disable":U AND
    p-ind-object = "VIEWER":U        AND
    c-char       = "v02in164.w":U    THEN DO:
    ASSIGN wh-resp-padrao-v02in164:SENSITIVE = NO.
    ASSIGN wh-resp-ordem-v02in164:SENSITIVE = NO.
END.

IF  p-ind-event  = "display":U    AND
    p-ind-object = "VIEWER":U     AND
    c-char       = "v02in164.w":U THEN DO:

    FIND FIRST it-exame NO-LOCK
         WHERE ROWID(it-exame) = p-row-table NO-ERROR.
    IF AVAIL it-exame THEN DO:
        FOR FIRST gg-ext-it-exame NO-LOCK
             WHERE gg-ext-it-exame.it-codigo = it-exame.it-codigo
               AND gg-ext-it-exame.cod-exame = it-exame.cod-exame:
        END.
        IF AVAIL gg-ext-it-exame THEN DO:
            ASSIGN wh-resp-padrao-v02in164:SCREEN-VALUE = gg-ext-it-exame.des-resultado
                   wh-resp-ordem-v02in164:SCREEN-VALUE  = STRING(gg-ext-it-exame.int-1).
        END.
        ELSE            
            ASSIGN wh-resp-padrao-v02in164:SCREEN-VALUE = "":U
                   wh-resp-ordem-v02in164:SCREEN-VALUE = "0":U.  
    END.
    ASSIGN l-achou = NO.
END.


IF p-ind-event  = "assign":U     AND
   p-ind-object = "VIEWER":U     AND
   c-char       = "v02in164.w":U THEN DO:
    ASSIGN c-resp-padrao-v02in164 = wh-resp-padrao-v02in164:SCREEN-VALUE
           c-ordem-v02in164       = wh-resp-ordem-v02in164:SCREEN-VALUE.
END.

IF p-ind-event  = "end-update":U     AND
   p-ind-object = "VIEWER":U     AND
   c-char       = "v02in164.w":U THEN DO:

    FIND FIRST it-exame NO-LOCK
        WHERE ROWID(it-exame) = p-row-table NO-ERROR.
    IF AVAIL it-exame THEN DO:
       FOR FIRST gg-ext-it-exame EXCLUSIVE-LOCK
            WHERE gg-ext-it-exame.it-codigo = it-exame.it-codigo
              AND gg-ext-it-exame.cod-exame = it-exame.cod-exame:
            ASSIGN l-achou = YES.
       END.
        IF l-achou <> YES THEN DO:
           CREATE gg-ext-it-exame.
           ASSIGN gg-ext-it-exame.it-codigo     = it-exame.it-codigo
                  gg-ext-it-exame.cod-exame     = it-exame.cod-exame
                  gg-ext-it-exame.des-resultado = c-resp-padrao-v02in164
                  gg-ext-it-exame.int-1         = INT(c-ordem-v02in164).
        END.
        ELSE
          ASSIGN gg-ext-it-exame.des-resultado = c-resp-padrao-v02in164
                 gg-ext-it-exame.int-1         = int(c-ordem-v02in164).
    END.
    ASSIGN l-achou = ?.
END.


