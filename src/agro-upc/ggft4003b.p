/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003B 2.00.00.009 } /*** "010009" 19/04/2024 17:46:24  ***/


/*************************************************************************
**    Programa.:  GGFT4003b
**    Objetivo.:  UPC para Solicitar o contrato 
**    Data.....:  Agosto/2003
*************************************************************************/
{ggp/tt-erro.i}
{utp/ut-glob.i}
/*********************** Defini‡Æo de Parƒmetros *************************/
DEFINE INPUT PARAMETER p-ind-event                  AS CHARACTER                    NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object                 AS CHARACTER                    NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object                 AS HANDLE                       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame                  AS WIDGET-HANDLE                NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table                  AS CHARACTER                    NO-UNDO.
DEFINE INPUT PARAMETER p-row-table                  AS ROWID                        NO-UNDO.

/******************** Defini‡Æo de Vari veis Globais *********************/
DEF NEW GLOBAL SHARED VAR v-wgh-object              AS HANDLE                       NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl            AS HANDLE                       NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-folder                  AS HANDLE                       NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-nota-ent-ft4003b    AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-serie-ent-fut-ft4003b  AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cidade-cif-ft4003b     AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nat-operacao-ft4003b   AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lbl-contrato-ft4003b   AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-contrato-ft4003b   AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btpeso-ft4003b         AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcomisao-ft4003b      AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-taxa-exp-ft4003b    AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-cancelar-ft4003b    AS WIDGET-HANDLE                NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-Contrato-ft4003         LIKE gg-contrato.cod-contrato.
/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VARIABLE c-char                              AS CHAR                         NO-UNDO.
DEFINE VARIABLE wh-objeto                           AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE wgh-child                           AS WIDGET-HANDLE                NO-UNDO.
DEFINE VARIABLE l-ok                                AS LOGICAL INITIAL YES          NO-UNDO.
DEFINE VARIABLE c-folder                            AS CHAR                         NO-UNDO.
/************************** In¡cio do Programa ***************************/
IF NOT CONNECTED ('emsgra':U) THEN 
	RETURN "OK":U.
ELSE
    IF NOT CAN-FIND( FIRST param-global WHERE param-global.log-modul-gg = YES) THEN
        RETURN "OK":U. 

ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.
       
v-wgh-object = p-wgh-object.

IF p-ind-event   = "before-display" THEN DO:

   ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
          wh-objeto = wh-objeto:FIRST-CHILD.

   BLOCK:
   DO WHILE VALID-HANDLE(wh-objeto):

      IF wh-objeto:NAME = "fpage2" THEN DO:
         ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                wgh-child  = wgh-child:FIRST-CHILD.
         DO WHILE VALID-HANDLE(wgh-child):
           IF wgh-child:NAME = "serie-ent-fut" THEN DO:
               ASSIGN wh-serie-ent-fut-ft4003b = wh-objeto.
           END.
           IF wgh-child:NAME = "nr-nota-ent-fut" THEN DO:
              ASSIGN wh-nr-nota-ent-ft4003b = wgh-child.
              LEAVE BLOCK.
           END.

           ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
         END.
      END.
      IF  wh-objeto:NAME = "fpage4" THEN DO:
          ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                 wgh-child  = wgh-child:FIRST-CHILD.
          DO  WHILE VALID-HANDLE(wgh-child):
              IF  wgh-child:NAME = "cidade-cif" THEN DO:
                  ASSIGN wh-cidade-cif-ft4003b = wgh-child.
              END.
              ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
          END.
      END.
      IF  wh-objeto:NAME = "fpage1" THEN DO:
          ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                 wgh-child  = wgh-child:FIRST-CHILD.
          DO  WHILE VALID-HANDLE(wgh-child):
              IF  wgh-child:NAME = "nat-operacao" THEN DO:
                  ASSIGN wh-nat-operacao-ft4003b = wgh-child.
              END.
              ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
          END.
      END.
      ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
   END.

   IF VALID-HANDLE(wh-serie-ent-fut-ft4003b) THEN DO:
       CREATE TEXT wh-lbl-contrato-ft4003b
       ASSIGN ROW            = wh-nr-nota-ent-ft4003b:ROW
              COLUMN         = (wh-nr-nota-ent-ft4003b:COLUMN + 15)
              FRAME          = wh-objeto
              SENSITIVE      = NO
              VISIBLE        = YES
              HEIGHT-CHARS   = 0.88
              WIDTH-CHARS    = 8
              FORMAT         = "x(17)"
              SCREEN-VALUE   = "Contrato:".

       CREATE FILL-IN wh-cod-contrato-ft4003b
       ASSIGN ROW          = wh-nr-nota-ent-ft4003b:ROW
              COLUMN       = (wh-nr-nota-ent-ft4003b:COLUMN + 22)
              DATA-TYPE    = "CHARACTER"
              FRAME        = wh-objeto
              SENSITIVE    = YES
              VISIBLE      = YES
              HEIGHT       = 0.88
              WIDTH        = 16.9
              NAME         = "cod-contrato"
              FORMAT       = "x(20)"
              SCREEN-VALUE = " "
              TOOLTIP      = "Contrato"
              HELP         = "N£mero do Contrato".

       ON 'F5' OF wh-cod-contrato-ft4003b OR "MOUSE-SELECT-DBLCLICK" OF wh-cod-contrato-ft4003b PERSISTENT
          RUN agro-upc/ggft4003ba.p.
       ON 'LEAVE' OF wh-cod-contrato-ft4003b PERSISTENT
          RUN agro-upc/ggft4003bb.p.
       wh-cod-contrato-ft4003b:LOAD-MOUSE-POINTER("image/lupa.cur").
       
       ASSIGN c-Contrato-ft4003     = "" .
   END.
END.

IF p-ind-event = "After-display"  then do:
    
   ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.
   BLOCK:
   DO  WHILE VALID-HANDLE(wh-objeto):
       IF  wh-objeto:NAME = "fpage4" THEN DO:
           ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                  wgh-child  = wgh-child:FIRST-CHILD.
           DO  WHILE VALID-HANDLE(wgh-child):
               IF  wgh-child:NAME = "cidade-cif" THEN DO:
                   ASSIGN wh-cidade-cif-ft4003b = wgh-child.
               END.
               ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
           END.
       END.
       IF  wh-objeto:NAME = "fpage2" THEN DO:
           ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                  wgh-child  = wgh-child:FIRST-CHILD.
           DO  WHILE VALID-HANDLE(wgh-child):
               IF wgh-child:NAME = "vl-taxa-exp" THEN DO:
                   ASSIGN wh-vl-taxa-exp-ft4003b = wgh-child.
               END.
               ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
           END.
       END.
       IF  wh-objeto:NAME = "btCancel" THEN DO:
           ASSIGN wh-bt-cancelar-ft4003b = wh-objeto.
       END.

       ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
   END.

   FIND FIRST wt-docto NO-LOCK
       WHERE ROWID(wt-docto) = p-row-table NO-ERROR.
   IF  AVAIL wt-docto THEN DO:

       /*Pesagem*/
       FIND FIRST gg-ext-wt-docto NO-LOCK
           WHERE gg-ext-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.
       CREATE BUTTON wh-btpeso-ft4003b
       ASSIGN FRAME     = p-wgh-frame
              ROW       = wh-bt-cancelar-ft4003b:ROW         //16.79
              COLUMN    = wh-bt-cancelar-ft4003b:COLUMN + 11 //35
              HEIGHT    = 1
              WIDTH     = 10
              TOOLTIP   = "Pesagem"  
              HELP      = "Pesagem"
              LABEL     = "Pesagem"
              SENSITIVE = TRUE
              VISIBLE   = TRUE. 
            ON 'choose' OF wh-btpeso-ft4003b PERSISTENT
            RUN agro-upc/ggft4003d.p ( INPUT ROWID(wt-docto)) .

       /*Contrato*/
       IF  AVAIL gg-ext-wt-docto THEN DO:
           ASSIGN wh-cod-contrato-ft4003b:SCREEN-VALUE =  STRING(gg-ext-wt-docto.cod-contrato)   .
           APPLY "Leave" TO wh-cod-contrato-ft4003b.
       END.
       ELSE
           ASSIGN wh-cod-contrato-ft4003b:SCREEN-VALUE =  ""  .

       /* Sugerir Cota‡Æo do Contrato */
       IF VALID-HANDLE(wh-vl-taxa-exp-ft4003b)
       AND NOT CAN-FIND(FIRST gg-ext-wt-docto NO-LOCK
                        WHERE gg-ext-wt-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                          AND gg-ext-wt-docto.cod-estabel   = wt-docto.cod-estabel 
                          AND gg-ext-wt-docto.serie         = wt-docto.serie       
                          AND gg-ext-wt-docto.nr-nota-fis   = wt-docto.nr-nota)  THEN DO: /* s¢ sugere a cota‡Æo do contrato se for a primeira vez que o usuario entrar na tela*/
           FOR FIRST gg-contrato-prod NO-LOCK
               WHERE gg-contrato-prod.nome-abrev   = wt-docto.nome-abrev
                 AND gg-contrato-prod.nr-pedcli    = wt-docto.nr-pedcli:

               FOR FIRST gg-contrato OF gg-contrato-prod NO-LOCK:
                   ASSIGN wh-vl-taxa-exp-ft4003b:SCREEN-VALUE = STRING(gg-contrato.cotacao-fat).
               END.
           END.
       END.
       /* fim Sugerir Cota‡Æo do Contrato */
   END.
END.

IF p-ind-event = "Before-assign" THEN DO:

   FIND FIRST wt-docto NO-LOCK
        WHERE ROWID(wt-docto) = p-row-table NO-ERROR.

   IF  AVAIL wt-docto  THEN DO:
       FIND FIRST gg-ext-wt-docto EXCLUSIVE-LOCK
           WHERE gg-ext-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.
       IF NOT AVAIL gg-ext-wt-docto THEN DO: 
          CREATE gg-ext-wt-docto.                                               
          ASSIGN gg-ext-wt-docto.seq-wt-docto  = wt-docto.seq-wt-docto        
                 gg-ext-wt-docto.cod-estabel   = wt-docto.cod-estabel         
                 gg-ext-wt-docto.serie         = wt-docto.serie               
                 gg-ext-wt-docto.nr-nota-fis   = wt-docto.nr-nota.        
       END.                                    
       IF  AVAIL gg-ext-wt-docto THEN          
           ASSIGN gg-ext-wt-docto.cod-contrato = wh-cod-contrato-ft4003b:SCREEN-VALUE .  
   END.
    
   /*** Variaveis Globais ***/
   IF  VALID-HANDLE(wh-cod-contrato-ft4003b) THEN
       ASSIGN c-Contrato-ft4003 = wh-cod-contrato-ft4003b:SCREEN-VALUE.    
   ELSE 
       ASSIGN c-Contrato-ft4003 = "".  

    /******** Esta Criando a gg-ext-nota-fiscal dentro da Bodi317
              com as vari veis atualizadas acima                  ************/    
END.
