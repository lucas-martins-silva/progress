/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0401B 2.00.00.006 } /*** "010006" ***/


/**************************************************************************
**    Programa.: GGCD0401B
**    Objetivo.: UPC para Manutencao de Contatos do Fornecedor - cd0401b
**    Data.....: Outubro de 2006
**************************************************************************/
{utp/ut-glob.i}
/*********************** Definicao de Parametros *************************/
DEFINE INPUT PARAMETER p-ind-event                AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object               AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object               AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame                AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table                AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table                AS ROWID         NO-UNDO.

/******************* Definicao de Variaveis Globais **********************/
DEF NEW GLOBAL SHARED VAR wh-conjuge-cd0401b      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cpf-cd0401b          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-label-cpf-cd0401b    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rg-cd0401b           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-label-rg-cd0401b     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-orgao-cd0401b        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-label-orgao-cd0401b  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-estado-cd0401b       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-label-estado-cd0401b AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-area-cd0401b         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-cd0401b         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-sequencia-cd0401b    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-aux                  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-retan-cd0401b        AS WIDGET-HANDLE NO-UNDO.

DEF                   VAR  c-char                 AS CHAR          NO-UNDO.
DEF                   VAR  i-linha                AS INTEGER       NO-UNDO.
DEF                   VAR  c-cpf                  AS CHAR          NO-UNDO.
DEF NEW GLOBAL SHARED VAR  l-ok-cd0401b           AS LOG           NO-UNDO.

DEF BUFFER b-cont-emit FOR cont-emit.

/************************** Inicio do Programa ***************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), 
                                  p-wgh-object:FILE-NAME,"~/") NO-ERROR.
/*
MESSAGE "Evento ...:" p-ind-event         SKIP
        "Objeto ...:" p-ind-object        SKIP
        "HObjeto...:" p-wgh-object        SKIP
        "hFrame ...:" p-wgh-frame         SKIP
        "Tabela ...:" p-cod-table         SKIP
        "Rowid  ...:" STRING(p-row-table) SKIP
        "NomeObjeto:" c-char.
*/

IF  p-ind-event   = "INITIALIZE":U    AND
    p-ind-object  = "VIEWER":U        AND
    c-char        = "cd0401b-v01.w":U THEN DO:
    ASSIGN wh-aux = p-wgh-frame:FIRST-CHILD
           wh-aux = wh-aux:FIRST-CHILD.   

    REPEAT WHILE VALID-HANDLE(wh-aux):
        IF wh-aux:NAME = "fPage1":U THEN
           ASSIGN wh-aux  = wh-aux:FIRST-CHILD
                  wh-aux  = wh-aux:FIRST-CHILD.        
        IF wh-aux:NAME = "nome":U THEN
           wh-nome-cd0401b = wh-aux:HANDLE.
        IF wh-aux:NAME = "area":U THEN
           wh-area-cd0401b = wh-aux:HANDLE.
        ASSIGN wh-aux = wh-aux:NEXT-SIBLING.
    END.  

    ASSIGN i-linha = wh-area-cd0401b:ROW + 1.

    CREATE RECTANGLE wh-retan-cd0401b
    ASSIGN ROW         = 3.7 /*i-linha - 0.5*/
           COL         = wh-area-cd0401b:COLUMN + 38.5
           FRAME       = p-wgh-frame
           WIDTH       = 28.5
           HEIGHT      = 5
           NAME        = "retan-cd0401b":U
           EDGE-PIXELS = 2
           BGCOLOR     = 8
           FILLED      = NO.
    wh-retan-cd0401b:GRAPHIC-EDGE.

    {utp/ut-liter.i "Cìnjuge" * R}
    CREATE TOGGLE-BOX wh-conjuge-cd0401b
    ASSIGN ROW       = 3.35
           COLUMN    = 63.6
           FRAME     = p-wgh-frame
           HEIGHT    = 0.79
           WIDTH     = 11.0
           TOOLTIP   = return-value
           HELP      = return-value
           LABEL     = return-value
           SENSITIVE = NO
           VISIBLE   = TRUE.
    wh-conjuge-cd0401b:CHECKED = NO.
    ON 'value-changed':U OF wh-conjuge-cd0401b PERSISTENT RUN agro-upc/ggcd0401b1.p.
    
    {utp/ut-liter.i "CPF" * R}
    CREATE TEXT wh-label-cpf-cd0401b
    ASSIGN ROW          = 4.5
           COLUMN       = 63.5
           FRAME        = p-wgh-frame
           SENSITIVE    = NO
           VISIBLE      = YES
           HEIGHT-CHARS = 0.8
           WIDTH-CHARS  = 4
           FORMAT       = "x(4)"
           SCREEN-VALUE = RETURN-VALUE + ":":U.

    ASSIGN wh-label-cpf-cd0401b:WIDTH-CHARS = LENGTH(wh-label-cpf-cd0401b:SCREEN-VALUE)
           wh-label-cpf-cd0401b:COLUMN = wh-label-cpf-cd0401b:COLUMN + (4 - LENGTH(wh-label-cpf-cd0401b:SCREEN-VALUE)).
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    {utp/ut-liter.i "CPF" * R}
    CREATE FILL-IN wh-cpf-cd0401b 
    ASSIGN ROW          = 4.5
           COLUMN       = 67.5
           DATA-TYPE    = "character":U
           FRAME        = wh-area-cd0401b:FRAME
           SENSITIVE    = NO
           VISIBLE      = YES
           WIDTH        = 20.14
           HEIGHT       = 0.88  
           WIDTH-CHARS  = 20.14
           NAME         = RETURN-VALUE
           FORMAT       = param-global.formato-id-pessoal
           SCREEN-VALUE = "":U
           HELP         = RETURN-VALUE.

    {utp/ut-liter.i "RG" * R}
    CREATE TEXT wh-label-rg-cd0401b
    ASSIGN ROW          = 5.5
           COLUMN       = 64.5
           FRAME        = p-wgh-frame
           SENSITIVE    = NO
           VISIBLE      = YES
           HEIGHT-CHARS = 0.88
           WIDTH-CHARS  = 3
           FORMAT       = "x(3)"
           SCREEN-VALUE = RETURN-VALUE + ":":U.

    {utp/ut-liter.i "RG" * R}
    CREATE FILL-IN wh-rg-cd0401b
    ASSIGN ROW          = 5.5
           COLUMN       = 67.5
           DATA-TYPE    = "character":U
           FRAME        = wh-area-cd0401b:FRAME
           SENSITIVE    = NO
           VISIBLE      = YES
           WIDTH        = 20.14
           HEIGHT       = 0.88  
           WIDTH-CHARS  = 20.14
           NAME         = RETURN-VALUE
           FORMAT       = "X(19)"
           SCREEN-VALUE = "":U
           HELP         = RETURN-VALUE.

    {utp/ut-liter.i "‡rg∆o" * R}
    CREATE TEXT wh-label-orgao-cd0401b
    ASSIGN ROW          = 6.5
           COLUMN       = 62.5
           FRAME        = p-wgh-frame
           SENSITIVE    = NO
           VISIBLE      = YES
           HEIGHT-CHARS = 0.88
           WIDTH-CHARS  = 6
           FORMAT       = "x(6)"
           SCREEN-VALUE = RETURN-VALUE + ":":U.

    {utp/ut-liter.i "‡rg∆o" * R}
    CREATE FILL-IN wh-orgao-cd0401b
    ASSIGN ROW          = 6.5
           COLUMN       = 67.5
           DATA-TYPE    = "character":U
           FRAME        = wh-area-cd0401b:FRAME
           SENSITIVE    = NO
           VISIBLE      = YES
           WIDTH        = 9.14
           HEIGHT       = 0.88  
           WIDTH-CHARS  = 9.14
           NAME         = RETURN-VALUE
           FORMAT       = "X(8)"
           SCREEN-VALUE = "":U
           HELP         = RETURN-VALUE.

    {utp/ut-liter.i "Estado" * R}
    CREATE TEXT wh-label-estado-cd0401b
    ASSIGN ROW          = 7.5
           COLUMN       = 62
           FRAME        = p-wgh-frame
           SENSITIVE    = NO
           VISIBLE      = YES
           HEIGHT-CHARS = 0.88
           WIDTH-CHARS  = 6
           FORMAT       = "x(7)"
           SCREEN-VALUE = RETURN-VALUE + ":":U.
    
    ASSIGN wh-label-estado-cd0401b:WIDTH-CHARS = LENGTH(wh-label-estado-cd0401b:SCREEN-VALUE)
           wh-label-estado-cd0401b:COLUMN = wh-label-estado-cd0401b:COLUMN + (7 - LENGTH(wh-label-estado-cd0401b:SCREEN-VALUE)).

    {utp/ut-liter.i "Estado" * R}
    CREATE FILL-IN wh-estado-cd0401b
    ASSIGN ROW          = 7.5
           COLUMN       = 67.5
           DATA-TYPE    = "character":U
           FRAME        = wh-area-cd0401b:FRAME
           SENSITIVE    = NO
           VISIBLE      = YES
           WIDTH        = 4.14
           HEIGHT       = 0.88  
           WIDTH-CHARS  = 4.14
           NAME         = RETURN-VALUE
           FORMAT       = "X(2)"
           SCREEN-VALUE = "":U
           HELP         = RETURN-VALUE.
    ON 'F5':U OF wh-estado-cd0401b OR "MOUSE-SELECT-DBLCLICK":U OF wh-estado-cd0401b PERSISTENT
        RUN agro-upc/ggcd0401b-z01.p. 
   wh-estado-cd0401b:LOAD-MOUSE-POINTER("image/lupa.cur":U).
END.

IF  p-ind-event = "AFTER-ENABLE":U THEN DO:
    ASSIGN wh-conjuge-cd0401b:SENSITIVE = YES.
    IF wh-conjuge-cd0401b:CHECKED = YES THEN
        ASSIGN wh-cpf-cd0401b    :SENSITIVE = YES
               wh-rg-cd0401b     :SENSITIVE = YES
               wh-orgao-cd0401b  :SENSITIVE = YES
               wh-estado-cd0401b :SENSITIVE = YES.
    ELSE
        ASSIGN wh-cpf-cd0401b    :SENSITIVE = NO
               wh-rg-cd0401b     :SENSITIVE = NO
               wh-orgao-cd0401b  :SENSITIVE = NO
               wh-estado-cd0401b :SENSITIVE = NO.
END.

IF  p-ind-event = "AFTER-DISABLE":U THEN DO:
    ASSIGN wh-conjuge-cd0401b:SENSITIVE = NO
           wh-cpf-cd0401b    :SENSITIVE = NO
           wh-rg-cd0401b     :SENSITIVE = NO
           wh-orgao-cd0401b  :SENSITIVE = NO
           wh-estado-cd0401b :SENSITIVE = NO.
END.

IF  p-ind-event  = "DISPLAY":U       AND 
    p-ind-object = "VIEWER":U        AND 
    c-char       = "cd0401b-v01.w":U THEN  DO:
    FIND b-cont-emit WHERE ROWID(b-cont-emit) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-cont-emit THEN DO:
       FIND FIRST gg-ext-cont-emit EXCLUSIVE-LOCK
            WHERE gg-ext-cont-emit.cod-emitente = b-cont-emit.cod-emitente
              AND gg-ext-cont-emit.sequencia    = b-cont-emit.sequencia NO-ERROR.
       IF AVAIL gg-ext-cont-emit THEN
          ASSIGN wh-conjuge-cd0401b:CHECKED      = IF gg-ext-cont-emit.log-conjuge THEN YES ELSE NO
                 wh-cpf-cd0401b    :SCREEN-VALUE = gg-ext-cont-emit.cpf
                 wh-rg-cd0401b     :SCREEN-VALUE = gg-ext-cont-emit.rg
                 wh-orgao-cd0401b  :SCREEN-VALUE = gg-ext-cont-emit.orgao-rg
                 wh-estado-cd0401b :SCREEN-VALUE = gg-ext-cont-emit.estado-rg.
       ELSE
           ASSIGN wh-conjuge-cd0401b:CHECKED      = NO
                  wh-cpf-cd0401b    :SCREEN-VALUE = "":U
                  wh-rg-cd0401b     :SCREEN-VALUE = "":U
                  wh-orgao-cd0401b  :SCREEN-VALUE = "":U
                  wh-estado-cd0401b :SCREEN-VALUE = "":U.
    END.
END.

IF  p-ind-event  = "BEFORE-ASSIGN" AND
    p-ind-object = "VIEWER"        AND 
    c-char       = "cd0401b-v01.w" THEN  DO:

    IF wh-cpf-cd0401b:SCREEN-VALUE <> "" 
    OR wh-cpf-cd0401b:SCREEN-VALUE <> "?" 
    OR wh-cpf-cd0401b:SCREEN-VALUE <> ? THEN DO:
       RUN pi-retira-pontuacao(INPUT wh-cpf-cd0401b:SCREEN-VALUE, OUTPUT c-cpf).
       ASSIGN l-ok-cd0401b = YES.
       RUN ggp/cpf.p (INPUT c-cpf, INPUT-OUTPUT l-ok-cd0401b).
       IF l-ok-cd0401b = NO AND wh-conjuge-cd0401b:CHECKED THEN DO:

           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-cpf-invalido AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "CPF_Inv†lido" *}
           ASSIGN c-lbl-liter-cpf-invalido = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-informe-um-cpf-valido AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Informe_um_CPF_v†lido" *}
           ASSIGN c-lbl-liter-informe-um-cpf-valido = TRIM(RETURN-VALUE).
           RUN utp/ut-msgs.p (INPUT "SHOW",
                              INPUT 27979,
                              INPUT c-lbl-liter-cpf-invalido + "~~" + c-lbl-liter-informe-um-cpf-valido + ".").

           apply 'entry' to wh-cpf-cd0401b.
       END.
    END.
   
    IF wh-conjuge-cd0401b:CHECKED THEN DO:
        IF NOT CAN-FIND(unid-feder WHERE unid-feder.pais   = "Brasil" 
                                     AND unid-feder.estado = wh-estado-cd0401b:SCREEN-VALUE) THEN DO:

           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-estado-inexistente AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Estado_inexistente" *}
           ASSIGN c-lbl-liter-estado-inexistente = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-informe-um-estado-valido AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Informe_um_estado_v†lido" *}
           ASSIGN c-lbl-liter-informe-um-estado-valido = TRIM(RETURN-VALUE).
           RUN utp/ut-msgs.p (INPUT "SHOW",
                              INPUT 27979,
                              INPUT c-lbl-liter-estado-inexistente + "." + "~~" + c-lbl-liter-informe-um-estado-valido + ".").

           APPLY "entry" TO wh-estado-cd0401b.
        END.
    END.
END.

IF  p-ind-event  = "ASSIGN"        AND
    p-ind-object = "VIEWER"        AND 
    c-char       = "cd0401b-v01.w" THEN  DO:

    FIND b-cont-emit WHERE ROWID(b-cont-emit) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-cont-emit THEN DO:
        ASSIGN wh-aux = p-wgh-frame:FIRST-CHILD
               wh-aux = wh-aux:FIRST-CHILD.   
        REPEAT WHILE VALID-HANDLE(wh-aux):
            IF wh-aux:NAME = "fPage1" THEN
               ASSIGN wh-aux  = wh-aux:FIRST-CHILD
                      wh-aux  = wh-aux:FIRST-CHILD.        
            IF wh-aux:NAME = "sequencia" THEN
               wh-sequencia-cd0401b = wh-aux:HANDLE.
            ASSIGN wh-aux = wh-aux:NEXT-SIBLING.
        END.
       FIND FIRST gg-ext-cont-emit EXCLUSIVE-LOCK
            WHERE gg-ext-cont-emit.cod-emitente = b-cont-emit.cod-emitente
              AND gg-ext-cont-emit.sequencia    = INT(wh-sequencia-cd0401b:SCREEN-VALUE) NO-ERROR.
       IF  NOT AVAIL gg-ext-cont-emit THEN DO:
           CREATE gg-ext-cont-emit.
           ASSIGN gg-ext-cont-emit.cod-emitente = b-cont-emit.cod-emitente
                  gg-ext-cont-emit.sequencia    = INT(wh-sequencia-cd0401b:SCREEN-VALUE).
       END.
       ASSIGN gg-ext-cont-emit.log-conjuge = IF wh-conjuge-cd0401b:CHECKED THEN YES ELSE NO
              gg-ext-cont-emit.cpf         = wh-cpf-cd0401b   :SCREEN-VALUE  
              gg-ext-cont-emit.rg          = wh-rg-cd0401b    :SCREEN-VALUE  
              gg-ext-cont-emit.orgao-rg    = wh-orgao-cd0401b :SCREEN-VALUE  
              gg-ext-cont-emit.estado-rg   = wh-estado-cd0401b:SCREEN-VALUE.
    END.
END.
/*
IF VALID-HANDLE(wh-label-cpf-cd0401b) THEN
    ASSIGN wh-label-cpf-cd0401b   :SCREEN-VALUE = "CPF:".

IF VALID-HANDLE(wh-label-rg-cd0401b) THEN
   ASSIGN wh-label-rg-cd0401b    :SCREEN-VALUE = "RG:".

IF VALID-HANDLE(wh-label-orgao-cd0401b) THEN
   ASSIGN wh-label-orgao-cd0401b :SCREEN-VALUE = "‡rg∆o:".

IF VALID-HANDLE(wh-label-estado-cd0401b) THEN
   ASSIGN wh-label-estado-cd0401b:SCREEN-VALUE = "Estado:".
*/

PROCEDURE pi-retira-pontuacao:
    DEF INPUT  PARAM c-cpf-1 AS CHAR FORMAT "x(20)".
    DEF OUTPUT PARAM c-cpf-2 AS CHAR FORMAT "x(20)".
    DEF VAR          i-cont  AS INT NO-UNDO.
    DO i-cont = 1 TO 20:
       IF INDEX("./-",SUBSTR(c-cpf-1,i-cont,1)) = 0 THEN
          ASSIGN c-cpf-2 = c-cpf-2 + SUBSTR(c-cpf-1,i-cont,1).
    END.
END PROCEDURE.
/* fim - GGcd0401b.p */
