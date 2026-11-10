&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0310A 2.00.00.005 } /*** 010005 ***/
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0310A
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              de-indice ~
                              cb-resultado ~
                              c-narrativa

{afbo/boaf008.i3 tt-af-contr-indice-aux}
{afbo/boaf008.i tt-af-contr-indice}

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER TABLE FOR tt-af-contr-indice-aux.
DEFINE OUTPUT PARAMETER l-ok AS LOGICAL NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf008 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf006 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf021 AS HANDLE NO-UNDO.

DEFINE VARIABLE cResultados    AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cResultadosIni AS CHARACTER                NO-UNDO.
DEFINE VARIABLE de-indice-result      LIKE af-contr-indice.indice NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-num-seq      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-nr-versao-grp-avaliacao AS INTEGER       NO-UNDO.

def var l-habilita   as log  no-undo.
def var c-resultados as char no-undo.
def var c-valor      as char no-undo.
DEF VAR i-nr-versao  AS INT  NO-UNDO.

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 rtToolBar ~
i-nr-versao-grp-aval dt-indice c-periodo cb-resultado de-indice ~
de-percentual de-nota c-narrativa btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-des-cod-estabel ~
i-cod-emitente c-des-cod-emitente i-nr-controle c-des-nr-controle ~
c-it-codigo c-des-it-codigo c-cod-grp-resp c-des-cod-grp-resp ~
c-cod-grp-aval c-des-cod-grp-aval i-nr-versao-grp-aval dt-indice c-periodo ~
cb-resultado de-indice de-percentual de-nota c-narrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-resultado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Resultado" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 63.14 BY 5.88.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-aval AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Avalia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Respons vel" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cod-emitente AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 45.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cod-estabel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 52.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cod-grp-aval AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cod-grp-resp AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-it-codigo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-nr-controle AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "99/9999":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-indice AS DECIMAL FORMAT "->>9.9999" INITIAL 0 
     LABEL "Öndice" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-nota AS DECIMAL FORMAT "->>9.9999" INITIAL 0 
     LABEL "Nota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-percentual AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Percentual" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE dt-indice AS DATE FORMAT "99/99/9999" 
     LABEL "Data Öndice" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-controle AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "N£mero Controle" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-versao-grp-aval AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 7.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 6.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-estabel AT ROW 1.29 COL 14 COLON-ALIGNED
     c-des-cod-estabel AT ROW 1.29 COL 20.29 COLON-ALIGNED NO-LABEL
     i-cod-emitente AT ROW 2.29 COL 14 COLON-ALIGNED
     c-des-cod-emitente AT ROW 2.29 COL 27.14 COLON-ALIGNED NO-LABEL
     i-nr-controle AT ROW 3.29 COL 14 COLON-ALIGNED
     c-des-nr-controle AT ROW 3.29 COL 24.14 COLON-ALIGNED NO-LABEL
     c-it-codigo AT ROW 4.29 COL 14 COLON-ALIGNED
     c-des-it-codigo AT ROW 4.29 COL 34.14 COLON-ALIGNED NO-LABEL
     c-cod-grp-resp AT ROW 5.29 COL 14 COLON-ALIGNED
     c-des-cod-grp-resp AT ROW 5.29 COL 26.14 COLON-ALIGNED NO-LABEL
     c-cod-grp-aval AT ROW 6.29 COL 14 COLON-ALIGNED
     c-des-cod-grp-aval AT ROW 6.29 COL 26.14 COLON-ALIGNED NO-LABEL
     i-nr-versao-grp-aval AT ROW 6.29 COL 64 COLON-ALIGNED NO-LABEL
     dt-indice AT ROW 7.25 COL 14 COLON-ALIGNED
     c-periodo AT ROW 7.25 COL 61 COLON-ALIGNED
     cb-resultado AT ROW 8.88 COL 14 COLON-ALIGNED
     de-indice AT ROW 8.88 COL 63 COLON-ALIGNED
     de-percentual AT ROW 9.88 COL 14 COLON-ALIGNED
     de-nota AT ROW 9.88 COL 63 COLON-ALIGNED
     c-narrativa AT ROW 11.58 COL 10 NO-LABEL
     btOK AT ROW 18 COL 2
     btCancel AT ROW 18 COL 13
     btHelp2 AT ROW 18 COL 67.29
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 12.79 COL 2.43
     RECT-1 AT ROW 1.13 COL 1
     RECT-2 AT ROW 8.63 COL 1
     RECT-3 AT ROW 11.33 COL 1
     rtToolBar AT ROW 17.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.14 BY 18.38
         FONT 1
         DEFAULT-BUTTON btOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.38
         WIDTH              = 77.14
         MAX-HEIGHT         = 19.63
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.63
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-grp-aval IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-grp-resp IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cod-grp-aval IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cod-grp-resp IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-nr-controle IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-controle IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    assign l-ok = no.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    
    if cb-resultado:screen-value = "" 
    or cb-resultado:screen-value = ?  then 
        assign i-num-seq = 0.
    RUN setPeriodo IN h-boaf008 (INPUT c-periodo).
    
    if  avail tt-af-contr-indice-aux then do:

        empty temp-table tt-af-contr-indice.

        if  tt-af-contr-indice-aux.ind-tipo = 2 then do: /* inclui */

            run emptyRowErrors in h-boaf008.

            /*--- Cria novo registro para temp-table no DBO ---*/
            run newRecord in h-boaf008.

            /*--- Retorna registro da temp-table do DBO ---*/
            run getRecord in h-boaf008 (output table tt-af-contr-indice).

            /*--- Posiciona o registro ---*/
            find first tt-af-contr-indice no-error. 

            assign tt-af-contr-indice.ep-codigo    = i-ep-codigo-usuario 
                   tt-af-contr-indice.cod-estabel  = input frame fPage0 c-cod-estabel 
                   tt-af-contr-indice.cod-emitente = input frame fPage0 i-cod-emitente
                   tt-af-contr-indice.nr-versao    = i-nr-versao
                   tt-af-contr-indice.nr-controle  = input frame fPage0 i-nr-controle 
                   tt-af-contr-indice.it-codigo    = input frame fPage0 c-it-codigo   
                   tt-af-contr-indice.indice       = input frame fPage0 de-indice     
                   tt-af-contr-indice.percentual   = input frame fPage0 de-percentual 
                   tt-af-contr-indice.nota         = input frame fPage0 de-nota       
                   tt-af-contr-indice.narrativa    = input frame fPage0 c-narrativa
                   tt-af-contr-indice.seq-resultado = i-num-seq.
            
    
            if  tt-af-contr-indice-aux.log-per-variavel then 
                assign tt-af-contr-indice.dt-indice = input frame fPage0 dt-indice.
            else 
                assign tt-af-contr-indice.dt-indice = date(int(substr(c-periodo,1,2)),01,int(substr(c-periodo,3,4))).

            run setRecord in h-boaf008 (input table tt-af-contr-indice).

            run createRecord in h-boaf008.
            if  return-value = "NOK":U then do:
        
                /*--- Retorna temp-table RowErrors do DBO ---*/
                run getRowErrors in h-boaf008 (output table RowErrors).
                    
                /*--- Inicializa tela de mensagens de erros ---*/
                {method/showmessage.i1}
                    
                /*--- Seta cursor do mouse para normal ---*/
                session:set-wait-state("":U).
                    
                /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                {method/showmessage.i2 &Modal="YES"}

                return no-apply.
            end.
        end.
        else do: /* modifica */

            run emptyRowErrors in h-boaf008.

            /*--- Reposiciona DBO atrav‚s do rowid do registro corrente selecionado ---*/
            run repositionRecord in h-boaf008 (input tt-af-contr-indice-aux.r-rowid).

            run getRecord in h-boaf008 (output table tt-af-contr-indice).

            find first tt-af-contr-indice no-error.
            if  avail tt-af-contr-indice then
                assign tt-af-contr-indice.indice       = input frame fPage0 de-indice     
                       tt-af-contr-indice.percentual   = input frame fPage0 de-percentual 
                       tt-af-contr-indice.nota         = input frame fPage0 de-nota       
                       tt-af-contr-indice.narrativa    = input frame fPage0 c-narrativa
                       tt-af-contr-indice.seq-resultado = i-num-seq.   
    
            /*--- Limpa a temp-table RowObject no DBO ---*/
            run emptyRowObject in h-boaf008.

            /*--- Transfere temp-table para o DBO ---*/
            run setRecord in h-boaf008 (input table tt-af-contr-indice).

            /*--- Altera registro corrente do DBO ---*/
            run updateRecord in h-boaf008.
            if  return-value = "NOK":U then do:

                run getRowErrors in h-boaf008 (output table RowErrors).

                /*--- Inicializa tela de mensagens de erros ---*/
                {method/showmessage.i1}

                if  not can-find(first RowErrors
                                 where (RowErrors.ErrorType = "INTERNAL":U) 
                                 and   (RowErrors.ErrorNumber = 10)) then do:

                    /*--- Seta cursor do mouse para normal ---*/
                    session:set-wait-state("":U).

                    /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                    {method/showmessage.i2 &Modal="yes"}

                    return no-apply.
                end.
            end.
        end.
    end.

    assign l-ok = yes.
    {method/showmessage.i3}
    apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-resultado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-resultado wWindow
ON VALUE-CHANGED OF cb-resultado IN FRAME fpage0 /* Resultado */
DO:
    ASSIGN i-num-seq = INT(entry(1, cb-resultado:screen-value in frame fpage0,"-")).
    
    run piRetornaIndice in h-boaf021 ( INPUT FRAME fPage0 i-nr-controle,
                                       INPUT i-num-seq,
                                       OUTPUT de-indice-result).
    ASSIGN de-indice:SCREEN-VALUE IN FRAME fpage0 = STRING(de-indice-result)
           de-nota:SCREEN-VALUE IN FRAME fpage0 = STRING(de-indice-result * de-percentual / 100).

.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- af-contr-indice ---*/
    if  valid-handle (h-boaf008) then do:
        delete procedure h-boaf008.
        assign h-boaf008 = ?.
    end.

    if  valid-handle (h-boaf006) then do:
        delete procedure h-boaf006.
        assign h-boaf006 = ?.
    end.

    if  valid-handle (h-boaf021) then do:
        delete procedure h-boaf021.
        assign h-boaf021 = ?.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first tt-af-contr-indice-aux no-error.

    if  avail tt-af-contr-indice-aux then do with frame fPage0:
        if  tt-af-contr-indice-aux.log-per-variavel then do:

            assign dt-indice           = tt-af-contr-indice-aux.dt-indice
                   c-periodo           = "".

            if  tt-af-contr-indice-aux.ind-tipo = 2 then /*inclusao*/
                assign dt-indice:sensitive = yes.
        end.
        else 
            assign c-periodo           = string(month(tt-af-contr-indice-aux.dt-indice),"99")
                                       + string(year(tt-af-contr-indice-aux.dt-indice),"9999")
                   c-periodo:sensitive = no
                   dt-indice           = ?
                   dt-indice:sensitive = no.
        FIND FIRST af-item-contr-estab-form WHERE
                 af-item-contr-estab-form.ep-codigo    = i-ep-codigo-usuario AND  
                 af-item-contr-estab-form.it-codigo    = tt-af-contr-indice-aux.it-codigo AND  
                 af-item-contr-estab-form.cod-emitente = tt-af-contr-indice-aux.cod-emitente AND
                 af-item-contr-estab-form.cod-estabel  = tt-af-contr-indice-aux.cod-estabel AND
                 af-item-contr-estab-form.nr-controle  = tt-af-contr-indice-aux.nr-controle AND
                 af-item-contr-estab-form.nr-versao    = tt-af-contr-indice-aux.nr-versao NO-LOCK NO-ERROR.
        
        IF NOT VALID-HANDLE(h-boaf006) THEN
            RUN afbo/boaf006.p PERSISTENT SET h-boaf006.

        RUN openQueryStatic IN h-boaf006 (INPUT "Main":U) NO-ERROR.
        RUN goToKey IN h-boaf006(INPUT i-ep-codigo-usuario,
                                 INPUT tt-af-contr-indice-aux.it-codigo,
                                 INPUT tt-af-contr-indice-aux.cod-emitente,
                                 INPUT tt-af-contr-indice-aux.nr-versao,
                                 INPUT tt-af-contr-indice-aux.cod-estabel). 
        
        IF RETURN-VALUE = "ok":U THEN 
            RUN getIntField IN h-boaf006(INPUT "nr-versao-grp-avaliacao",
                                         OUTPUT i-nr-versao-grp-avaliacao).

        assign c-cod-estabel      = tt-af-contr-indice-aux.cod-estabel
               c-des-cod-estabel  = tt-af-contr-indice-aux.nome-estabel
               i-cod-emitente     = tt-af-contr-indice-aux.cod-emitente
               i-nr-versao        = tt-af-contr-indice-aux.nr-versao
               i-nr-versao-grp-aval = i-nr-versao-grp-avaliacao
               c-des-cod-emitente = tt-af-contr-indice-aux.nome-emit
               i-nr-controle      = tt-af-contr-indice-aux.nr-controle
               c-des-nr-controle  = tt-af-contr-indice-aux.nome-controle
               c-it-codigo        = tt-af-contr-indice-aux.it-codigo
               c-des-it-codigo    = tt-af-contr-indice-aux.desc-item
               c-cod-grp-resp     = tt-af-contr-indice-aux.cod-grp-resp
               c-des-cod-grp-resp = tt-af-contr-indice-aux.nome-grp-resp
               c-cod-grp-aval     = tt-af-contr-indice-aux.cod-grp-aval
               c-des-cod-grp-aval = tt-af-contr-indice-aux.nome-grp-aval
               de-indice          = tt-af-contr-indice-aux.indice
               de-percentual      = IF AVAIL af-item-contr-estab-form THEN af-item-contr-estab-form.percentual
                                    ELSE tt-af-contr-indice-aux.percentual
               de-nota            = tt-af-contr-indice-aux.nota
               c-narrativa        = tt-af-contr-indice-aux.narrativa.


        disp {&DISPLAYED-OBJECTS}.
    end.

    RUN resultadoPontoControle IN h-boaf008 (INPUT input frame fpage0 c-cod-estabel,
                                         INPUT input frame fpage0 i-cod-emitente,
                                         INPUT input frame fpage0 c-it-codigo,
                                         INPUT input frame fpage0 i-nr-controle,
                                         INPUT tt-af-contr-indice-aux.dt-indice, 
                                         input if tt-af-contr-indice-aux.ind-tipo = 2 then 1 else 2,
                                         OUTPUT l-habilita,
                                         OUTPUT c-resultados,
                                         OUTPUT c-valor).

    IF c-resultados <> "" THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            ASSIGN cb-resultado:list-item-pairs in frame fpage0 = c-resultados
                   cb-resultado:screen-value in frame fpage0 = c-valor.
        &else
            ASSIGN cb-resultado:list-items in frame fpage0 = c-resultados
                   cb-resultado:screen-value in frame fpage0 = c-valor.
        &endif
    END.
    
    ASSIGN i-num-seq = INT(entry(1, cb-resultado:screen-value in frame fpage0,"-")).

    IF l-habilita THEN DO:
        ENABLE cb-resultado WITH FRAME fpage0.
        DISABLE de-indice WITH FRAME fpage0.
    END.
    ELSE DO:
        ENABLE de-indice WITH FRAME fpage0.
        DISABLE cb-resultado WITH FRAME fpage0.
    END.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- af-contr-indice ---*/
    if  not valid-handle (h-boaf008) then
        run afbo/boaf008.p persistent set h-boaf008.

    run openQueryStatic in h-boaf008 (input "Main").

    if  not valid-handle (h-boaf021) then
        run afbo/boaf021.p persistent set h-boaf021.

    run openQueryStatic in h-boaf021 (input "Main").

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

