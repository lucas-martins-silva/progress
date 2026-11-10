&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V01IN407 2.00.00.044 } /*** "010044" 24/07/2024 10:14:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN407 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */
{utp/ut-glob.i}

def new global shared var gr-serie as rowid no-undo.

/* Local Variable Definitions ---                                       */

/*def var l-implanta    as logical no-undo.*/
def var r-registro    as rowid no-undo.
def var c-serie-aux   like serie.serie no-undo.
def var c-nota-fiscal as char format "x(20)".
def var c-remito      as char format "x(20)".

DEF VAR h-bopy2007 AS HANDLE NO-UNDO.
DEF VAR cAuxTraducao001 AS CHARACTER NO-UNDO.
DEF VAR i-pto-vda AS INT NO-UNDO.

DEF VAR h-ecu0101a        AS HANDLE               NO-UNDO.
DEF VAR l-cancel-ecu0101a AS LOGICAL  INITIAL YES NO-UNDO.
DEF VAR c-serie-ecu       LIKE serie.serie        NO-UNDO.
DEF VAR ph-cadsim         AS HANDLE               NO-UNDO.

DEFINE VARIABLE cLista             AS CHARACTER NO-UNDO.


def buffer b-serie for serie.

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */

/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.

{cdp/cd0905i1.i} /* Definiá∆o da temp-table tt-serie-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */

/****************************************************************/

{bhp/bh9999.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES serie
&Scoped-define FIRST-EXTERNAL-TABLE serie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR serie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS serie.serie-vinc serie.forma-emis serie.int-1 ~
serie.nr-ult-fat 
&Scoped-define ENABLED-TABLES serie
&Scoped-define FIRST-ENABLED-TABLE serie
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 RECT-5 RECT-6 ~
bt-zoom-ecu c-serie-fiscal f-pto-venda i-timbrado dt-val-ini dt-val-fim ~
cb-tp-regime 
&Scoped-Define DISPLAYED-FIELDS serie.serie serie.serie-vinc ~
serie.forma-emis serie.int-1 serie.nr-ult-fat 
&Scoped-define DISPLAYED-TABLES serie
&Scoped-define FIRST-DISPLAYED-TABLE serie
&Scoped-Define DISPLAYED-OBJECTS c-serie-fiscal f-pto-venda i-timbrado ~
dt-val-ini dt-val-fim cb-tp-regime FILL-IN-2 FILL-IN-4 FILL-IN-5 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS serie.serie 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
serie|y|y|mgind.serie.serie
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "serie",
     Keys-Supplied = "serie"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-zoom-ecu 
     IMAGE-UP FILE "image/im-zoom.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cb-tp-regime AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo de Regime" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE c-serie-fiscal AS CHARACTER FORMAT "X(2)":U 
     LABEL "Serie Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE dt-val-fim AS DATE FORMAT "99/99/9999":U 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dt-val-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-pto-venda AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Pto Vda" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(23)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Timbrado" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE i-timbrado AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "N£mero" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 2.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 2.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 8.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-zoom-ecu AT ROW 1.08 COL 39.57 WIDGET-ID 2
     serie.serie AT ROW 1.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     serie.serie-vinc AT ROW 2.67 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-serie-fiscal AT ROW 3.88 COL 13.57 COLON-ALIGNED WIDGET-ID 8
     serie.forma-emis AT ROW 4.75 COL 33.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Autom†tica", 1,
"Manual", 2
          SIZE 24 BY .75
     serie.int-1 AT ROW 4.75 COL 60.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nota Fiscal", 1,
"Remito", 2
          SIZE 24 BY .75
     f-pto-venda AT ROW 4.88 COL 13.57 COLON-ALIGNED WIDGET-ID 6
     serie.nr-ult-fat AT ROW 6.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     i-timbrado AT ROW 7.88 COL 38.86 COLON-ALIGNED
     dt-val-ini AT ROW 7.88 COL 57.72 COLON-ALIGNED WIDGET-ID 12
     dt-val-fim AT ROW 7.88 COL 71.72 COLON-ALIGNED WIDGET-ID 14
     cb-tp-regime AT ROW 9.17 COL 30 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-2 AT ROW 3.71 COL 30.29 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 3.71 COL 58.57 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 7.21 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.54 COL 1
     RECT-1 AT ROW 3.92 COL 31.86
     RECT-5 AT ROW 3.92 COL 59.43
     RECT-6 AT ROW 7.5 COL 32 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.serie
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.42
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 10.42
       FRAME f-main:WIDTH            = 88.57.

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-5:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN serie.serie IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       serie.serie-vinc:HIDDEN IN FRAME f-main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-zoom-ecu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom-ecu V-table-Win
ON CHOOSE OF bt-zoom-ecu IN FRAME f-main
DO:
    RUN pi-gera-serie-equador.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-fiscal V-table-Win
ON LEAVE OF c-serie-fiscal IN FRAME f-main /* Serie Fiscal */
DO:
  ASSIGN c-serie-fiscal = c-serie-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-val-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-val-fim V-table-Win
ON LEAVE OF dt-val-fim IN FRAME f-main /* atÇ */
DO:
  ASSIGN dt-val-fim = DATE(dt-val-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-val-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-val-ini V-table-Win
ON LEAVE OF dt-val-ini IN FRAME f-main /* Validade */
DO:
  ASSIGN dt-val-ini = DATE(dt-val-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-timbrado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-timbrado V-table-Win
ON LEAVE OF i-timbrado IN FRAME f-main /* N£mero */
DO:
  ASSIGN i-timbrado = INT(i-timbrado:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME serie.int-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL serie.int-1 V-table-Win
ON VALUE-CHANGED OF serie.int-1 IN FRAME f-main /* int-1 */
DO:

    if input frame {&frame-name} serie.int-1 = 2 then do:
        assign serie.forma-emis:screen-value in frame {&frame-name} = '1'.
        assign serie.forma-emis:sensitive in frame {&frame-name} = no.
    end. 
    else
        assign serie.forma-emis:sensitive in frame {&frame-name} = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME serie.serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL serie.serie V-table-Win
ON LEAVE OF serie.serie IN FRAME f-main /* SÇrie */
DO:
  assign serie.serie-vinc:screen-value in frame {&frame-name} = 
         serie.serie:screen-value in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME serie.serie-vinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL serie.serie-vinc V-table-Win
ON F5 OF serie.serie-vinc IN FRAME f-main /* SÇrie Vinculada */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in407.w"
                     &campo = serie.serie-vinc
                     &campozoom = serie}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL serie.serie-vinc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF serie.serie-vinc IN FRAME f-main /* SÇrie Vinculada */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if serie.serie-vinc:LOAD-MOUSE-POINTER ("Image\lupa.cur") THEN.
  
  {include/i-freeac.i} /*include para tirar acentuaá∆o*/
  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 x Magnus I.01 */
   
 /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'serie':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = serie
           &WHERE = "WHERE serie.serie eq key-value"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "serie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "serie"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    {utp/ut-rtlbl.i mgind serie forma-emis fill-in-2}

    {utp/ut-rtlbl.i mgind serie serie fill-in-4}

    /* Code placed here will execute AFTER standard behavior.    */

    IF i-pais-impto-usuario = 21
    AND adm-new-record THEN
        RUN pi-gera-serie-equador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-int-1       AS INT  NO-UNDO.
    DEF VAR c-cod-livre-1 AS CHAR NO-UNDO.
    DEF VAR c-tp-regime   AS CHAR NO-UNDO.
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* {utp/ut-liter.i Forma_Emiss∆o_Notas}
    assign c-forma-emis-nota:screen-value in frame {&frame-name} = trim(return-value).  
    
    {utp/ut-liter.i Serie}
    assign c-ind-ser-remito:screen-value in frame {&frame-name} = trim(return-value). */
    
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    find first serie no-lock where serie.serie = input FRAME {&FRAME-NAME} serie.serie no-error.
    if  serie.serie:sensitive in frame {&frame-name} = yes then do:
        if available serie then do:
            {utp/ut-table.i mgind serie 1}
            run utp/ut-msgs.p (input "show",
                               input 24,
                               input return-value).
            apply 'entry' to serie.serie in frame {&frame-name}.
            return 'adm-error'.  
        end.                                                                   
    end.
     
    if  input frame {&frame-name} serie.serie-vinc <> "" 
    and serie.serie-vinc:visible in frame {&frame-name} = yes then do:
       if input frame {&frame-name} serie.serie-vinc <> 
          input frame {&frame-name} serie.serie then do:
          assign c-serie-aux = input frame {&frame-name} serie.serie-vinc.
          find first b-serie where
                     b-serie.serie = c-serie-aux no-lock no-error.
          if available b-serie then do: 
             find first b-serie where b-serie.serie-vinc = c-serie-aux no-lock no-error.
             if avail b-serie then do:       
                run utp/ut-msgs.p (input "show",
                                   input 906,
                                   input "").
                apply 'entry' to serie.serie-vinc in frame {&frame-name}.
                return 'adm-error'.
             end.
          end.
          else do: 
              run utp/ut-msgs.p (input "show",
                                 input 5580,
                                 input return-value).
              apply 'entry' to serie.serie in frame {&frame-name}.
              return 'adm-error'.  
          end.
       end.  
    end.
    
    if  not adm-new-record 
    and serie.int-1:visible   in frame {&frame-name} = yes 
    and serie.int-1:sensitive in frame {&frame-name} = yes 
    and serie.int-1 <> input frame {&frame-name} serie.int-1 then do:
        {utp/ut-table.i mgdis nota-fiscal 1}
        assign c-nota-fiscal = return-value.
        {utp/ut-table.i mgdis remito 1}
        assign c-remito = return-value.
        if  serie.int-1 = 1
        and input frame {&frame-name} serie.int-1 = 2 then do:
            find first nota-fiscal
                 where nota-fiscal.serie = serie.serie no-lock no-error.
            if  avail nota-fiscal then do:
                run utp/ut-msgs.p (input "show",
                                   input 17810,
                                   input c-nota-fiscal + "~~" + c-remito + "~~" + c-nota-fiscal).
                apply 'entry' to serie.serie in frame {&frame-name}.
                return 'adm-error'.
            end.
        end.
        else do:
            find first remito
                 where remito.serie = serie.serie no-lock no-error.
            if  avail remito then do:
                run utp/ut-msgs.p (input "show",
                                   input 17810,
                                   input c-remito + "~~" + c-nota-fiscal + "~~" + c-remito).
                apply 'entry' to serie.serie in frame {&frame-name}.
                return 'adm-error'.
            end.    
        end.
    /* katia */
    end.
    
    IF i-pais-impto-usuario = 21 /* Equador */ THEN DO: 
        IF serie.int-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2"
        AND SUBSTRING(input frame {&frame-name} serie.serie,1,1) <> "3" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 53766,
                               INPUT "").
            RETURN 'adm-error'.
        END.        
    
        IF serie.int-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1"
        AND SUBSTRING(input frame {&frame-name} serie.serie,1,1) = "3" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 53925,
                               INPUT "").
            RETURN 'adm-error'.
        END.        
    END.
    
    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN i-int-1 = int(serie.int-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    
    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

        ASSIGN i-pto-vda = input frame {&frame-name} f-pto-venda
               c-tp-regime = cb-tp-regime:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        APPLY 'leave':U TO dt-val-fim IN FRAME {&FRAME-NAME}.
        IF dt-val-fim < dt-val-ini OR (dt-val-fim = ? AND dt-val-ini <> ?) THEN DO:
            run utp/ut-msgs.p (input "show",
                               input 7530,
                               input return-value).
            apply 'entry' to dt-val-fim in frame {&frame-name}.
            return 'adm-error'.
        END.

        IF cb-tp-regime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" OR
           cb-tp-regime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN DO:
            {utp/ut-liter.i "Tipo de Regime" *}
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 265, 
                               INPUT RETURN-VALUE).
            APPLY 'entry' to cb-tp-regime IN FRAME {&FRAME-NAME}.
            RETURN 'adm-error'.
        END.
    END.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
    /* Integraá∆o EMS 2.04 x Magnus I.01 */
    {cdp/cd0002i1.i serie}
      
    IF RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */

    IF  i-pais-impto-usuario <> 1 
    AND AVAIL serie THEN
        ASSIGN serie.int-1 = i-int-1.

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        ASSIGN c-cod-livre-1 = string(c-serie-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME},'99') + ';' + 
                               string(i-timbrado:SCREEN-VALUE IN FRAME {&FRAME-NAME},"99999999") + ';' + 
                               c-tp-regime
               dt-val-ini    = date(dt-val-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME})
               dt-val-fim    = date(dt-val-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

        RUN pi-atualiza-campos IN h-bopy2007 (INPUT serie.serie,
                                              INPUT i-pto-vda,
                                              INPUT c-cod-livre-1,
                                              INPUT dt-val-ini,
                                              INPUT dt-val-fim).

        ASSIGN f-pto-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(i-pto-vda)
               cb-tp-regime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-tp-regime.

    END.

    IF i-pais-impto-usuario = 21 /* Equador */ THEN
        ASSIGN c-serie-ecu = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.
    
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 4 Serie Serie.Serie '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

   IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
       IF VALID-HANDLE(h-bopy2007) THEN DO:
           RUN goToKey IN h-bopy2007 (INPUT serie.serie,
                                      INPUT 0,
                                      INPUT f-pto-venda).
           IF RETURN-VALUE = "OK":U THEN
               RUN deleteRecord IN h-bopy2007.
       END.
   END.

  /* Integraá∆o EMS 2.04 x Magnus I.01 */
  {cdp/cd0002i1.i1 serie "no"} 
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  if return-value = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.
 
  /* Integraá∆o EMS 2.04 x Magnus I.01 */
  {cdp/cd0002i1.i1 serie "yes"}
    
  assign serie.forma-emis:sensitive in frame {&frame-name} = no.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
        IF VALID-HANDLE(h-bopy2007) THEN
            RUN destroy IN h-bopy2007.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

     /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
       disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
  
    IF i-pais-impto-usuario = 21 /* Equador */ THEN
        ASSIGN bt-zoom-ecu:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
       
    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN serie.int-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
        ASSIGN f-pto-venda:SENSITIVE IN FRAME {&FRAME-NAME}    = NO
               c-serie-fiscal:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               i-timbrado:SENSITIVE IN FRAME {&frame-name}     = NO
               dt-val-ini:SENSITIVE IN FRAME {&frame-name}     = NO
               dt-val-fim:SENSITIVE IN FRAME {&frame-name}     = NO
               cb-tp-regime:SENSITIVE IN FRAME {&frame-name}   = NO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c-reg AS CHARACTER     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut-rtlbl.i mgind serie serie fill-in-4} 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-rtlbl.i mgind serie forma-emis fill-in-2} 
    
  /* Code placed here will execute AFTER standard behavior.    */

    DEF VAR c-cod-livre-1 AS CHAR NO-UNDO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ 
    AND AVAIL serie THEN
        IF  serie.int-1 <> 0 THEN
            ASSIGN serie.int-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(serie.int-1).
        ELSE
            ASSIGN serie.int-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(1).

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

        ASSIGN cLista = ""
               cLista = {local/pry/py2inc/i01py2007.i 03}.

        &if "{&FNC_MULTI_IDIOMA}" = "Yes":U &then
            RUN utp/ut-lstit.p (input-output cLista).
            ASSIGN cb-tp-regime:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cLista.
        &else
            ASSIGN cb-tp-regime:LIST-ITEMS      IN FRAME {&FRAME-NAME} = cLista.
        &endif
        
        IF VALID-HANDLE(h-bopy2007) AND AVAIL serie THEN DO:
            RUN pi-busca-campos IN h-bopy2007 (INPUT  serie.serie,
                                               OUTPUT f-pto-venda,
                                               OUTPUT c-cod-livre-1,
                                               OUTPUT dt-val-ini,
                                               OUTPUT dt-val-fim).

            IF RETURN-VALUE = "NOK":U THEN
                ASSIGN f-pto-venda     = 000
                       c-serie-fiscal  = ''
                       i-timbrado      = 0
                       dt-val-ini      = ?
                       dt-val-fim      = ?
                       cb-tp-regime    = "".
            
            ELSE DO:
                ASSIGN c-serie-fiscal = IF num-entries(c-cod-livre-1, ";") >= 1 AND ENTRY(1,c-cod-livre-1,";") <> '' THEN ENTRY(1,c-cod-livre-1,";")      ELSE ''
                       i-timbrado     = IF num-entries(c-cod-livre-1, ";") >= 2 AND ENTRY(2,c-cod-livre-1,";") <> '' THEN int(ENTRY(2,c-cod-livre-1,";")) ELSE 0
                       c-serie-fiscal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-serie-fiscal
                       i-timbrado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-timbrado)
                       dt-val-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(dt-val-ini)
                       dt-val-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(dt-val-fim).

                ASSIGN c-reg = entry(3,c-cod-livre-1,";") NO-ERROR.
                IF c-reg <> "" THEN
                    ASSIGN cb-tp-regime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-reg.
                ELSE
                    ASSIGN cb-tp-regime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
            END.
        END.
        ELSE 
            ASSIGN f-pto-venda     = 000
                   c-serie-fiscal  = '00'
                   i-timbrado      = 0
                   dt-val-ini      = ?
                   dt-val-fim      = ?
                   cb-tp-regime    = "".

        ASSIGN f-pto-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(f-pto-venda).
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
 
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    if  serie.int-1:visible   in frame {&frame-name} = yes 
    and serie.int-1:sensitive in frame {&frame-name} = yes 
    and input frame {&frame-name} serie.int-1 = 2 then 
        assign serie.forma-emis:sensitive in frame {&frame-name} = no.
 

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF i-pais-impto-usuario = 21 /*Equador*/ THEN
        ASSIGN serie.serie:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
    IF  i-pais-impto-usuario = 4 /* Mexico */ THEN
        ASSIGN serie.serie-vinc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                    
        ASSIGN f-pto-venda:SENSITIVE IN FRAME {&FRAME-NAME}    = YES              
               c-serie-fiscal:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               i-timbrado:SENSITIVE IN FRAME {&frame-name}     = YES
               dt-val-ini:SENSITIVE IN FRAME {&frame-name}     = YES
               dt-val-fim:SENSITIVE IN FRAME {&frame-name}     = YES
               cb-tp-regime:SENSITIVE IN FRAME {&frame-name}   = YES.         
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut-rtlbl.i mgind serie forma-emis fill-in-2}

  {utp/ut-rtlbl.i mgind serie serie fill-in-4} 

  /* Dispatch standard ADM method.                             */
     
  &if defined(bf_fin_ems2_x_mg) &then
      find funcao 
         where funcao.cd-funcao = "spp-ems2fin-x-mg"
           and funcao.ativo     = yes no-lock no-error.
      
      if avail funcao then do:
         assign serie.serie:format in frame {&frame-name} = "x(03)"
                serie.serie-vinc:format in frame {&frame-name} = "x(03)".
      end.
  &endif             
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN c-serie-fiscal:VISIBLE IN FRAME {&FRAME-NAME} = NO
         i-timbrado:VISIBLE IN FRAME {&frame-name}     = NO
         dt-val-ini:VISIBLE IN FRAME {&frame-name}     = NO
         dt-val-fim:VISIBLE IN FRAME {&frame-name}     = NO
         fill-in-5:HIDDEN IN FRAME {&FRAME-NAME}       = YES
         rect-6:VISIBLE IN FRAME {&FRAME-NAME}         = NO.

  IF i-pais-impto-usuario = 21 /* Equador */ THEN
      ASSIGN bt-zoom-ecu:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  ELSE
      ASSIGN bt-zoom-ecu:VISIBLE = NO.

  IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN
      ASSIGN serie.serie-vinc:HIDDEN IN FRAME {&FRAME-NAME} = NO.

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

      RUN local/pry/bopy2007.p PERSISTENT SET h-bopy2007.

      RUN openQueryStatic IN h-bopy2007 (INPUT "Main":U) NO-ERROR.

      ASSIGN rect-6:VISIBLE IN FRAME {&FRAME-NAME}           = YES
             fill-in-5:HIDDEN IN FRAME {&FRAME-NAME}         = NO
             f-pto-venda:HIDDEN IN FRAME {&frame-name}       = NO
             c-serie-fiscal:VISIBLE IN FRAME {&FRAME-NAME}   = YES
             i-timbrado:VISIBLE IN FRAME {&frame-name}       = YES
             dt-val-ini:VISIBLE IN FRAME {&frame-name}       = YES
             dt-val-fim:VISIBLE IN FRAME {&frame-name}       = YES
             c-serie-fiscal:SENSITIVE IN FRAME {&frame-name} = NO
             i-timbrado:SENSITIVE IN FRAME {&frame-name}     = NO
             dt-val-ini:SENSITIVE IN FRAME {&frame-name}     = NO
             dt-val-fim:SENSITIVE IN FRAME {&frame-name}     = NO
             f-pto-venda:SENSITIVE IN FRAME {&frame-name}    = NO
             f-pto-venda:LABEL IN FRAME {&FRAME-NAME} = "Ponto Expediá∆o"
             cb-tp-regime:SENSITIVE IN FRAME {&frame-name}   = NO.
      
  END.
  ELSE 
      ASSIGN f-pto-venda:HIDDEN  IN FRAME {&frame-name}  = YES
             cb-tp-regime:HIDDEN IN FRAME {&frame-name}  = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if avail serie then
     assign gr-serie = rowid(serie).
     
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  
 /* Dispatch standard ADM method.                             */
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

 /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         
    {cdp/cd0003i1.i serie cdp/cd0905i1.p}
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-serie-mg V-table-Win 
PROCEDURE pi-cria-tt-serie-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.
         
    for each tt-serie-mg:
        delete tt-serie-mg.
    end.
        
    create tt-serie-mg.
    assign tt-serie-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-serie-mg.l-atualiza     = p-atualiza.
   
    assign tt-serie-mg.serie      = fn-free-accent(serie.serie)
           tt-serie-mg.serie-vinc = fn-free-accent(serie.serie-vinc).
                   
    if serie.forma-emis = 1 then
       assign tt-serie-mg.forma-emis = yes.
    else
       assign tt-serie-mg.forma-emis = no. /*2*/
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/**************************************************************************
** 1 - Nome do programa; 2 - Nome da Tabela; 3 - Valor da chave prim†ria
***************************************************************************/

{cdp/cd0004i1.i "CD0905" "SERIE" serie.serie tt-serie-mg.ind-tipo-movto tt-erros-mg.help-msg}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-serie-equador V-table-Win 
PROCEDURE pi-gera-serie-equador :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Object AS CHAR NO-UNDO.

    ASSIGN c-serie-ecu = ""
           l-cancel-ecu0101a = YES.
       
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN local/ecu/ecu0101a.w PERSISTENT SET h-ecu0101a(INPUT THIS-PROCEDURE).

    IF  VALID-HANDLE (h-ecu0101a) THEN DO:
        RUN initializeInterface IN h-ecu0101a.

        WAIT-FOR CLOSE OF h-ecu0101a FOCUS CURRENT-WINDOW.
    END. 

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    /*Se cancelou deve limpar os campos e desabilitar a tela*/
    IF l-cancel-ecu0101a THEN DO:
        RUN pi-cancelar IN ph-cadsim.
    END.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM ph-cadsim-aux AS HANDLE NO-UNDO.
    
    ASSIGN ph-cadsim = ph-cadsim-aux.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-serie-mg V-table-Win 
PROCEDURE pi-valida-serie-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input-output param p-ind-tipo-movto as int no-undo.
       
    return "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "serie" "serie" "serie"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "serie"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-serie-ecu V-table-Win 
PROCEDURE set-serie-ecu :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-serie-ecu LIKE serie.serie NO-UNDO.
    
    ASSIGN serie.serie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-serie-ecu
           c-serie-ecu = p-serie-ecu
           l-cancel-ecu0101a = NO
           bt-zoom-ecu:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

