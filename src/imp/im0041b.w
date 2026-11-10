&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0041B 2.00.00.003 } /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0041B MIM}
&ENDIF


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0041B
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2

{cxbo/bocx351.i tt-licenciam-import-oc}
{cxbo/bocx351.i tt-licenciam-import-oc-aux}

/* Parameters Definitions ---                                           */
define input-output parameter table for tt-licenciam-import-oc.
define output parameter iExporta as integer no-undo.
define output parameter lOk      as logical no-undo.

/* Local Variable Definitions ---                                       */
define variable h-boin356    as handle                      no-undo.
define variable h-bocx351    as handle                      no-undo.
define variable iSituacao    as integer                     no-undo.
define variable cReturn      as character                   no-undo.
define variable cCodLivre1   as character format "x(100)":U no-undo.
define variable cCodLivre2   as character format "x(100)":U no-undo.
define variable dDatLivre1   AS DATE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 rtToolBar cNrLi dData ~
rsExportacao btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS iNumeroOrdem iParcela cSituacao cItCodigo ~
cClassFiscal cNrLi dData rsExportacao 

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

DEFINE VARIABLE cClassFiscal AS CHARACTER FORMAT "9999.99.99":U 
     LABEL "Classifica‡Æo Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cItCodigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE cNrLi AS CHARACTER FORMAT "X(20)":U 
     LABEL "Nr LI" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE cSituacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.86 BY .88 NO-UNDO.

DEFINE VARIABLE dData AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Restri‡Æo Embarque" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE iNumeroOrdem AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "Ordem de Compra" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iParcela AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE rsExportacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Exporta LI e Data para todos os itens da mesma classifica‡Æo fiscal", 1,
"NÆo exporta LI e Data", 2
     SIZE 53 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 6.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     iNumeroOrdem AT ROW 1.5 COL 26 COLON-ALIGNED
     iParcela AT ROW 2.5 COL 26 COLON-ALIGNED
     cSituacao AT ROW 2.5 COL 33.14 COLON-ALIGNED NO-LABEL
     cItCodigo AT ROW 3.5 COL 26 COLON-ALIGNED
     cClassFiscal AT ROW 4.5 COL 26 COLON-ALIGNED
     cNrLi AT ROW 5.5 COL 26 COLON-ALIGNED HELP
          "N£mero da Licen‡a de Importa‡Æo"
     dData AT ROW 6.5 COL 26 COLON-ALIGNED HELP
          "Data de Restri‡Æo do Embarque"
     rsExportacao AT ROW 7.67 COL 2.86 HELP
          "Tipo Exporta‡Æo Licenciamento Importa‡Æo" NO-LABEL
     btOK AT ROW 10.38 COL 2
     btCancel AT ROW 10.38 COL 13
     btHelp2 AT ROW 10.38 COL 63.29
     RECT-2 AT ROW 1 COL 1
     RECT-3 AT ROW 7.58 COL 1
     rtToolBar AT ROW 10.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.29 BY 11.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.67
         WIDTH              = 73
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 94
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 94
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
/* SETTINGS FOR FILL-IN cClassFiscal IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cItCodigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cSituacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iNumeroOrdem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iParcela IN FRAME fpage0
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
    assign lOk = no.
    apply "CLOSE":U to this-procedure.
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
    DEFINE VARIABLE l-return-epc-ok AS LOGICAL INITIAL YES NO-UNDO.

    Records:
    do transaction on error undo, leave:

        if  avail tt-licenciam-import-oc then do:

            run emptyRowErrors in h-bocx351.
            run goToKey        in h-bocx351 (input tt-licenciam-import-oc.numero-ordem,
                                             input tt-licenciam-import-oc.parcela).
            assign cReturn = return-value. 

            /* Acerta os valores dos campos livres utilizados para classificacao na tela do im0041.w */
            if  cReturn = "OK" then do:

                run getCharField in h-bocx351 (input "cod-livre-1":U,
                                               output cCodLivre1).
                run getCharField in h-bocx351 (input "cod-livre-2":U,
                                               output cCodLivre2).
            end.
            else
                assign cCodLivre1 = ""
                       cCodLivre2 = "".

            /*--------- INICIO UPC ---------*/
            RUN pi-ExecutaEPC  (INPUT "BeforeGrava-licenciam-import-oc", /* p-ind-event  */
                                INPUT "IM0041B",                         /* p-ind-object */
                                INPUT THIS-PROCEDURE,                    /* p-wgh-object */
                                INPUT FRAME fPage0:HANDLE,               /* p-wgh-frame  */
                                INPUT ?,                                 /* p-cod-table  */
                                INPUT ?).                                /* p-row-table  */

            IF c-nom-prog-dpc-mg97  <> ""
            OR c-nom-prog-appc-mg97 <> ""
            OR c-nom-prog-upc-mg97  <> "" THEN
                IF  RETURN-VALUE = "NOK":U THEN
                    ASSIGN l-return-epc-ok = NO.
            /*--------- FIM UPC ---------*/

            IF input frame fPage0 cNrLi = "" AND input frame fPage0 dData <> ? THEN DO:            
                run utp/ut-msgs.p (input "show":U,
                                   input 56574,
                                   input "").
                undo Records, leave Records.
            END.

            if  input frame fPage0 cNrLi <> "" AND l-return-epc-ok then do:
        
                run emptyRowErrors in h-bocx351.
                run emptyRowObject in h-bocx351.

                empty temp-table tt-licenciam-import-oc-aux.
                create tt-licenciam-import-oc-aux.
                buffer-copy tt-licenciam-import-oc to tt-licenciam-import-oc-aux.

                assign tt-licenciam-import-oc.licenca-import     = input frame fPage0 cNrLi
                       tt-licenciam-import-oc.dat-livre-1        = input frame fPage0 dData
                       tt-licenciam-import-oc-aux.licenca-import = input frame fPage0 cNrLi
                       tt-licenciam-import-oc-aux.dat-livre-1    = input frame fPage0 dData
                       tt-licenciam-import-oc-aux.cod-livre-1    = cCodLivre1
                       tt-licenciam-import-oc-aux.cod-livre-2    = cCodLivre2.

                run setRecord in h-bocx351 (input table tt-licenciam-import-oc-aux).
                if  cReturn = "NOK":U then
                    /* registro nao existe ainda, por isso cria */
                    run createRecord in h-bocx351.
                else
                    /*registro ja existente, por isso apenas altera */
                    run updateRecord in h-bocx351.
        
                if  return-value = "NOK":U then do:

                    run getRowErrors in h-bocx351 (output table RowErrors).

                    for each  RowErrors 
                        where RowErrors.errorType = "INTERNAL":U:
                        delete RowErrors.
                    end.

                    if  can-find (first RowErrors) then do:
                        {method/ShowMessage.i1}
                        {method/ShowMessage.i2 &Modal="YES"}
                        undo Records, leave Records.
                    end.
                end.
                else
                    /*--- Elimina Janela de mensagens de erros ---*/
                    {method/ShowMessage.i3}
            end.
            else if cReturn = "OK":U AND l-return-epc-ok then do: /*registro ja existente, por isso elimina */

                run utp/ut-msgs.p (input "show":U,
                                   input 30445,
                                   input "").
                if  return-value = "yes":U then do:

                    assign tt-licenciam-import-oc.licenca-import = input frame fPage0 cNrLi
                           tt-licenciam-import-oc.dat-livre-1    = input frame fPage0 dData.

                    run emptyRowErrors in h-bocx351.
                    run emptyRowObject in h-bocx351.
                    run setRecord      in h-bocx351 (input table tt-licenciam-import-oc).
                    run deleteRecord   in h-bocx351.
                    if  return-value = "NOK":U then do:
        
                        run getRowErrors in h-bocx351 (output table RowErrors).

                        for each  RowErrors 
                            where RowErrors.errorType = "INTERNAL":U:
                            delete RowErrors.
                        end.
            
                        if  can-find (first RowErrors) then do:
                            {method/ShowMessage.i1}
                            {method/ShowMessage.i2 &Modal="YES"}
                            undo Records, leave Records.
                        end.
                    end.
                    else
                        /*--- Elimina Janela de mensagens de erros ---*/
                        {method/ShowMessage.i3}
                end.
                else 
                    undo Records, leave Records.
            end.
        end.

        assign lOk      = yes
               iExporta = input frame fPage0 rsExportacao.
    
        apply "CLOSE":U to this-procedure.
    end.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

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

    if  valid-handle (h-boin356) then do:

        delete procedure h-boin356.
        assign h-boin356 = ?.
    end.

    if  valid-handle (h-bocx351) then do:

        delete procedure h-bocx351.
        assign h-bocx351 = ?.
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

    find first tt-licenciam-import-oc no-error.
    if  avail  tt-licenciam-import-oc then do:

        if  not valid-handle (h-bocx351) then
            run cxbo/bocx351.p persistent set h-bocx351.

        run openQueryStatic in h-bocx351 (input "Main":U).

        if  not valid-handle (h-boin356) then
            run inbo/boin356.p persistent set h-boin356.

        run openQueryStatic in h-boin356 (input "Main":U).

        assign iNumeroOrdem = tt-licenciam-import-oc.numero-ordem
               iParcela     = tt-licenciam-import-oc.parcela
               cItCodigo    = tt-licenciam-import-oc.cod-livre-1 /*neste programa o item*/
               cClassFiscal = tt-licenciam-import-oc.cod-livre-2 /*neste programa o class-fiscal*/
               cNrLi        = tt-licenciam-import-oc.licenca-import
               dData        = tt-licenciam-import-oc.dat-livre-1.
               

        run goToKey in h-boin356 (input tt-licenciam-import-oc.numero-ordem,
                                  input tt-licenciam-import-oc.parcela).
        if  return-value = "OK":U then do:

            run getIntField in h-boin356 (input "situacao":U,
                                          output iSituacao).

            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            assign cSituacao = {ininc/i02in274.i 04 iSituacao}.
            run utp/ut-liter.p (input replace(trim(cSituacao)," ","_"),
                                input "",
                                input "").
            assign cSituacao = return-value.
            &else
            assign cSituacao = {ininc/i02in274.i 04 iSituacao}.
            &endif

            display iNumeroOrdem
                    iParcela    
                    cSituacao
                    cItCodigo   
                    cClassFiscal
                    cNrLi 
                    dData 
                with frame fPage0.
    
            enable cNrLi dData rsExportacao with frame fPage0.
        end.
    end.

    /*--------- INICIO UPC ---------*/
    RUN pi-ExecutaEPC  (INPUT "afterInitializeInterface", /* p-ind-event  */
                        INPUT "CONTAINER",                /* p-ind-object */
                        INPUT THIS-PROCEDURE,             /* p-wgh-object */
                        INPUT FRAME fPage0:HANDLE,        /* p-wgh-frame  */
                        INPUT ?,                          /* p-cod-table  */
                        INPUT ?).                         /* p-row-table  */
    /*--------- FIM UPC ---------*/

    return "OK":U.
END PROCEDURE.

PROCEDURE pi-retorna-tt-licenciam-import-oc:
    DEF OUTPUT PARAMETER TABLE FOR tt-licenciam-import-oc.
END PROCEDURE.

PROCEDURE pi-envia-tt-licenciam-import-oc:
    DEF INPUT PARAMETER TABLE FOR tt-licenciam-import-oc.
END PROCEDURE.

PROCEDURE pi-ExecutaEPC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-ind-event     AS CHAR          NO-UNDO.
    DEF INPUT PARAM p-ind-object    AS CHAR          NO-UNDO.
    DEF INPUT PARAM p-wgh-object    AS HANDLE        NO-UNDO.
    DEF INPUT PARAM p-wgh-frame     AS WIDGET-HANDLE NO-UNDO.
    DEF INPUT PARAM p-cod-table     AS CHAR          NO-UNDO.
    DEF INPUT PARAM p-row-table     AS ROWID         NO-UNDO.
    
    IF  c-nom-prog-dpc-mg97  <> "" THEN RUN VALUE(c-nom-prog-dpc-mg97) (p-ind-event,p-ind-object,p-wgh-object,p-wgh-frame,p-cod-table,p-row-table).
    IF  c-nom-prog-appc-mg97 <> "" THEN RUN VALUE(c-nom-prog-appc-mg97)(p-ind-event,p-ind-object,p-wgh-object,p-wgh-frame,p-cod-table,p-row-table).
    IF  c-nom-prog-upc-mg97  <> "" THEN RUN VALUE(c-nom-prog-upc-mg97) (p-ind-event,p-ind-object,p-wgh-object,p-wgh-frame,p-cod-table,p-row-table).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

