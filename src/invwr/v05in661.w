&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V05IN661 2.00.00.016 } /*** "010016" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in661 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var da-iniper      as date format "99/99/9999"   no-undo.
def var da-fimper      as date format "99/99/9999"   no-undo.
def var i-per-corrente as int  format "99"           no-undo.
def var i-ano-corrente as int  format "9999"         no-undo.
def var da-iniper-fech as date format "99/99/9999"   no-undo.
def var da-fimper-fech as date format "99/99/9999"   no-undo. 

def var h-v01in661     as handle no-undo.
def var c-cod-estabel  as char   no-undo.

DEF VAR c-liter1 AS CHAR NO-UNDO.
DEF VAR c-liter2 AS CHAR NO-UNDO.
DEF VAR c-liter3 AS CHAR NO-UNDO.

DEFINE BUFFER b-estabelec FOR estabelec.
DEFINE BUFFER b-estab-mat FOR estab-mat.


{cdp/cdcfgmat.i}
{cep/ce0101.i2}

/* funcao spp-fechto-gerencial - seta variavel l-fechto-gerencial*/
{cep/ce0101.i3}

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
&Scoped-define EXTERNAL-TABLES estab-mat
&Scoped-define FIRST-EXTERNAL-TABLE estab-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 rt-mold RECT-4 
&Scoped-Define DISPLAYED-OBJECTS da-mensal-ate l-acerto-aut da-sumar-ate ~
l-gera-act da-contab-ate l-pm-ja-ini da-ult-fech-dia l-fec-ja-ini ~
c-ult-per-fech i-num-dec da-ini-periodo i-val-transf da-fim-periodo ~
c-lb-fase rs-tipo-pr-med c-lb-param c-lb-transf c-lb-tipo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS da-mensal-ate l-acerto-aut da-sumar-ate ~
l-gera-act da-contab-ate l-pm-ja-ini da-ult-fech-dia l-fec-ja-ini ~
c-ult-per-fech i-num-dec da-ini-periodo i-val-transf da-fim-periodo ~
rs-tipo-pr-med 
&Scoped-define ADM-MODIFY-FIELDS da-mensal-ate l-acerto-aut da-sumar-ate ~
l-gera-act da-contab-ate da-ult-fech-dia c-ult-per-fech i-num-dec ~
i-val-transf rs-tipo-pr-med 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-lb-fase AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-lb-param AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-tipo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-transf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 24.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-ult-per-fech AS CHARACTER FORMAT "9999/99" 
     LABEL "éltimo per¡odo fechado" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE da-contab-ate AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "Contabilizado at‚" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-fim-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-ini-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-mensal-ate AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "Data medio mensal" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-sumar-ate AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "Sumarizado at‚" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-ult-fech-dia AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "éltimo dia fechado" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-num-dec AS INTEGER FORMAT ">9" INITIAL 4 
     LABEL "Decimais Para C lculo" 
     VIEW-AS FILL-IN 
     SIZE 3.43 BY .88.

DEFINE VARIABLE i-val-transf AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "M‚dio", 1,
"Informado", 2
     SIZE 27.86 BY .75.

DEFINE VARIABLE rs-tipo-pr-med AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Di rio", 1,
"Mensal", 2
     SIZE 26 BY .75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 5.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.57 BY 9.

DEFINE VARIABLE l-acerto-aut AS LOGICAL INITIAL no 
     LABEL "Gera acertos custo on-line" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83.

DEFINE VARIABLE l-fec-ja-ini AS LOGICAL INITIAL no 
     LABEL "Fechamento iniciado" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.72 BY .83.

DEFINE VARIABLE l-gera-act AS LOGICAL INITIAL no 
     LABEL "Gera acertos c lculo m‚dio" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.14 BY .83.

DEFINE VARIABLE l-pm-ja-ini AS LOGICAL INITIAL no 
     LABEL "Pre‡o m‚dio iniciado" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     da-mensal-ate AT ROW 1.75 COL 23 COLON-ALIGNED
     l-acerto-aut AT ROW 1.75 COL 50
     da-sumar-ate AT ROW 2.75 COL 23 COLON-ALIGNED
     l-gera-act AT ROW 2.75 COL 50
     da-contab-ate AT ROW 3.75 COL 23 COLON-ALIGNED
     l-pm-ja-ini AT ROW 3.75 COL 50
     da-ult-fech-dia AT ROW 4.75 COL 23 COLON-ALIGNED
     l-fec-ja-ini AT ROW 4.75 COL 50
     c-ult-per-fech AT ROW 5.75 COL 23 COLON-ALIGNED
     i-num-dec AT ROW 5.75 COL 72 COLON-ALIGNED HELP
          "Informe o n£mero de decimais"
     da-ini-periodo AT ROW 6.75 COL 23 COLON-ALIGNED
     i-val-transf AT ROW 7.58 COL 55.14 NO-LABEL
     da-fim-periodo AT ROW 7.75 COL 23 COLON-ALIGNED
     c-lb-fase AT ROW 8.75 COL 23 COLON-ALIGNED
     rs-tipo-pr-med AT ROW 9.21 COL 55 NO-LABEL
     c-lb-param AT ROW 1 COL 44 COLON-ALIGNED NO-LABEL
     c-lb-transf AT ROW 7 COL 45.72 NO-LABEL
     c-lb-tipo AT ROW 8.58 COL 46 NO-LABEL
     RECT-2 AT ROW 9 COL 45
     RECT-3 AT ROW 1.25 COL 45
     rt-mold AT ROW 1.25 COL 1
     RECT-4 AT ROW 7.33 COL 45
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mat
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 9.96
         WIDTH              = 91.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

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
       FRAME f-main:HEIGHT           = 9.96
       FRAME f-main:WIDTH            = 91.72.

/* SETTINGS FOR FILL-IN c-lb-fase IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lb-param IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lb-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-transf IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-ult-per-fech IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-contab-ate IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-fim-periodo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN da-ini-periodo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN da-mensal-ate IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-sumar-ate IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-ult-fech-dia IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN i-num-dec IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET i-val-transf IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-acerto-aut IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-fec-ja-ini IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX l-gera-act IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-pm-ja-ini IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET rs-tipo-pr-med IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME c-ult-per-fech
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ult-per-fech V-table-Win
ON ENTRY OF c-ult-per-fech IN FRAME f-main /* éltimo per¡odo fechado */
DO:
    assign self:format = '9999/99'.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ult-per-fech V-table-Win
ON LEAVE OF c-ult-per-fech IN FRAME f-main /* éltimo per¡odo fechado */
DO:
  if substring(self:screen-value,1,1) = '0' or
     substring(self:screen-value,1,1) = ''  then do:
     assign self:format = 'xxxxxx'
            self:screen-value = ''.
  end.
  else do:
     {cdp/cd9998.i}

    run cdp/cdapi005.p (input  INPUT FRAME {&FRAME-NAME} c-ult-per-fech,
                        output da-iniper               ,   
                        output da-fimper               ,
                        output i-per-corrente          ,
                        output i-ano-corrente          ,
                        output da-iniper-fech          ,
                        output da-fimper-fech          ).

    assign da-mensal-ate:screen-value   in frame {&frame-name} = string(da-fimper-fech)
           da-sumar-ate:screen-value    in frame {&frame-name} = string(da-fimper-fech)
           da-contab-ate:screen-value   in frame {&frame-name} = string(da-fimper-fech)
           da-ult-fech-dia:screen-value in frame {&frame-name} = string(da-fimper-fech)
           da-ini-periodo:screen-value  in frame {&frame-name} = string(da-iniper)
           da-fim-periodo:screen-value  in frame {&frame-name} = string(da-fimper).
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-contab-ate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-contab-ate V-table-Win
ON LEAVE OF da-contab-ate IN FRAME f-main /* Contabilizado at‚ */
DO:
    IF adm-new-record THEN DO:
        &if defined(bf_mat_fech_estab) &then
        if  adm-new-record then
            run Get-Field-Screen-Value in adm-broker-hdl 
                (input h-v01in661, input "cod-estabel").
        
        assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
        if  can-find (first movto-estoq
                      where movto-estoq.cod-estabel = c-cod-estabel
                        and movto-estoq.dt-trans <= input frame {&FRAME-NAME} da-contab-ate) then do:
            run utp/ut-msgs.p (input "show", input 28306, input da-contab-ate:label in frame {&FRAME-NAME}).
            apply 'entry' to da-contab-ate in frame {&FRAME-NAME}.
            return no-apply.
        end.
        &endif  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-mensal-ate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-mensal-ate V-table-Win
ON LEAVE OF da-mensal-ate IN FRAME f-main /* Data medio mensal */
DO:

    IF adm-new-record THEN DO:
    
        &if defined(bf_mat_fech_estab) &then
         if  adm-new-record then
             run Get-Field-Screen-Value in adm-broker-hdl 
                 (input h-v01in661, input "cod-estabel").
        
         assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
         if  can-find (first movto-estoq
                       where movto-estoq.cod-estabel = c-cod-estabel
                         and movto-estoq.dt-trans   <= input frame {&FRAME-NAME} da-mensal-ate) then do:
             {utp/ut-field.i mgind estab-mat mensal-ate 02}
             run utp/ut-msgs.p (input "show", input 28306, input return-value).
             apply 'entry' to da-mensal-ate in frame {&FRAME-NAME}.
             return no-apply.
         end.
         &endif  
         
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-sumar-ate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-sumar-ate V-table-Win
ON LEAVE OF da-sumar-ate IN FRAME f-main /* Sumarizado at‚ */
DO:
     IF adm-new-record THEN DO:

            &if defined(bf_mat_fech_estab) &then
            if  adm-new-record then
                run Get-Field-Screen-Value in adm-broker-hdl 
                    (input h-v01in661, input "cod-estabel").
            
            assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
            if  can-find (first movto-estoq
                          where movto-estoq.cod-estabel = c-cod-estabel
                            and movto-estoq.dt-trans <= input frame {&FRAME-NAME} da-sumar-ate) then do:
                run utp/ut-msgs.p (input "show", input 28306, input da-sumar-ate:label in frame {&FRAME-NAME}).
                apply 'entry' to da-sumar-ate in frame {&FRAME-NAME}.
                return no-apply.
            end.
            &endif  
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-ult-fech-dia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-ult-fech-dia V-table-Win
ON LEAVE OF da-ult-fech-dia IN FRAME f-main /* éltimo dia fechado */
DO:

    IF adm-new-record THEN DO:
       &if defined(bf_mat_fech_estab) &then
       if  adm-new-record then
           run Get-Field-Screen-Value in adm-broker-hdl 
               (input h-v01in661, input "cod-estabel").
       
       assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
       if  can-find (first movto-estoq
                     where movto-estoq.cod-estabel = c-cod-estabel
                       and movto-estoq.dt-trans <= input frame {&FRAME-NAME} da-ult-fech-dia) then do:
           run utp/ut-msgs.p (input "show", input 28306, input da-ult-fech-dia:label in frame {&FRAME-NAME}).
           apply 'entry' to da-ult-fech-dia in frame {&FRAME-NAME}.
           return no-apply.
       end.
       &endif  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-val-transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-val-transf V-table-Win
ON VALUE-CHANGED OF i-val-transf IN FRAME f-main
DO:
    run utp/ut-msgs.p (input 'show', input 56560, input '').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo-pr-med
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-pr-med V-table-Win
ON VALUE-CHANGED OF rs-tipo-pr-med IN FRAME f-main
DO:

  DEF VAR c-msg AS CHAR NO-UNDO.

  IF NOT AVAIL param-global THEN
        find first param-global no-lock no-error. 
        
          IF AVAIL param-global AND 
          &IF DEFINED (bf_man_206b) &THEN
                param-global.modulo-ch
          &ELSE
                param-global.modulo-cp
          &ENDIF
                THEN DO:
                
                if input frame {&frame-name} rs-tipo-pr-med = 1 THEN DO:
                  RUN utp/ut-msgs.p (INPUT 'show',
                                                         INPUT 51487,
                                                         INPUT '').
                  IF return-value = 'no' THEN DO:
                        ASSIGN rs-tipo-pr-med:SCREEN-VALUE IN frame {&frame-name} = "2" .
                        DISP rs-tipo-pr-med with frame {&frame-name}.
                  END. 
          END.
  END.
    if input frame {&FRAME-NAME} rs-tipo-pr-med = 1  then do:
        assign l-gera-act:screen-value in frame {&FRAME-NAME} = "no"
               l-gera-act = no.
        disable l-gera-act with frame {&frame-name}.
    end.
    else
        enable l-gera-act with frame {&frame-name}.

    IF  SELF:SCREEN-VALUE = "1" /*diario*/ THEN DO:
        IF  l-fechto-gerencial THEN DO:
            {utp/ut-liter.i "M‚dio_Di rio"}
            ASSIGN c-msg = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Fechamento_Gerencial" *}
            RUN utp/ut-msgs.p("show",56972,c-msg + "~~" + TRIM(RETURN-VALUE)).
            ASSIGN SELF:SCREEN-VALUE = "2". //mensal
            RETURN NO-APPLY.
        END.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

&if defined(bf_mat_fech_estab) &then
  {utp/ut-field.i mgind estab-mat mensal-ate 1}
  assign da-mensal-ate:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat sumar-ate 1}
  assign da-sumar-ate:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat contab-ate 1}
  assign da-contab-ate:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat ult-fech-dia 1}
  assign da-ult-fech-dia:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat ult-per-fech 1}
  assign c-ult-per-fech:label in frame {&FRAME-NAME} = return-value.
&endif

{utp/ut-field.i mgadm ano-fiscal ini-periodo 1}
assign da-ini-periodo:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgadm ano-fiscal fim-periodo 1}
assign da-fim-periodo:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Fase_C lculo_M‚dio MCD L}
assign c-lb-fase:label in frame {&frame-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  {src/adm/template/row-list.i "estab-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mat"}

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

  &if defined(bf_mat_fech_estab) &then
    {utp/ut-rdset.i rs-tipo-pr-med mce}   
    assign i-num-dec:screen-value in frame {&FRAME-NAME} = "4".
    {utp/ut-liter.i Tipo_Pre‡o_M‚dio * L}
    assign c-lb-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Valoriza_Entrada_Transferˆncia * L}
    assign c-lb-transf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Parƒmetros * L}
    assign c-lb-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  &endif     
  
 
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  &if defined(bf_mat_fech_estab) &then
      if input frame {&FRAME-NAME} i-num-dec < 4 or input frame {&FRAME-NAME} i-num-dec > 10 then do:
          run utp/ut-msgs.p(input "show",
                            input 27146,
                            input "").
          return 'ADM-ERROR':U.                          
      end.
  &endif
   
  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME} ON ERROR UNDO, RETURN 'ADM-ERROR':
    &if defined(bf_mat_fech_estab) &then
        if avail estab-mat then
        DO:
            
           /********************** Validacao fechamento por Empresa *********************/
           RUN pi-valida-fech-por-emp.
           IF RETURN-VALUE = "NOK":U THEN RETURN "ADM-ERROR".
           /*****************************************************************************/
            
           assign estab-mat.tipo-pr-med = input frame {&FRAME-NAME} rs-tipo-pr-med
                  estab-mat.acerto-aut  = l-acerto-aut:checked in frame {&FRAME-NAME}
                  estab-mat.gera-act    = l-gera-act:checked in frame {&FRAME-NAME}
                  estab-mat.num-dec     = input frame {&FRAME-NAME} i-num-dec.
                  
           assign c-lb-fase = {ininc/i09in287.i 04  estab-mat.fase-medio}.

           IF da-mensal-ate:sensitive   in frame {&frame-name} = YES and 
              da-sumar-ate:sensitive    in frame {&frame-name} = yes and 
              da-contab-ate:sensitive   in frame {&frame-name} = yes and 
              da-ult-fech-dia:sensitive in frame {&frame-name} = yes and 
              c-ult-per-fech:sensitive  in frame {&frame-name} = yes THEN
              assign estab-mat.mensal-ate   = input frame {&frame-name} da-mensal-ate
                     estab-mat.sumar-ate    = input frame {&frame-name} da-sumar-ate
                     estab-mat.contab-ate   = input frame {&frame-name} da-contab-ate
                     estab-mat.ult-fech-dia = input frame {&frame-name} da-ult-fech-dia
                     estab-mat.ult-per-fech = input frame {&frame-name} c-ult-per-fech.

        END.
        assign i-num-dec:screen-value in frame {&FRAME-NAME} = "4".

        ASSIGN estab-mat.idi-val-transf = INPUT FRAME {&FRAME-NAME} i-val-transf.
    &endif
  END.
  
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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-CREATE-FIELDS) &then
       disable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
    &endif

    &if  defined(ADM-MODIFY-FIELDS) &then
       disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
   &if defined(bf_mat_fech_estab) &then
     if avail estab-mat then
     DO:
        assign rs-tipo-pr-med  = estab-mat.tipo-pr-med 
               l-acerto-aut    = estab-mat.acerto-aut
               l-gera-act      = estab-mat.gera-act
               l-pm-ja-ini     = estab-mat.pm-ja-ini
               l-fec-ja-ini    = estab-mat.fec-ja-ini
               i-num-dec       = estab-mat.num-dec
               da-mensal-ate   = estab-mat.mensal-ate 
               da-sumar-ate    = estab-mat.sumar-ate  
               da-contab-ate   = estab-mat.contab-ate 
               da-ult-fech-dia = estab-mat.ult-fech-dia 
               c-ult-per-fech  = estab-mat.ult-per-fech
               i-val-transf    = if not avail estab-mat or estab-mat.idi-val-transf = 0 then 2
                                 else estab-mat.idi-val-transf.   
                            
         assign c-lb-fase = {ininc/i09in287.i 04  estab-mat.fase-medio}.
  
         run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                             output da-iniper             ,   
                             output da-fimper             ,
                             output i-per-corrente        ,
                             output i-ano-corrente        ,
                             output da-iniper-fech        ,
                             output da-fimper-fech        ).
                                                                             
         assign da-ini-periodo = da-iniper
                da-fim-periodo = da-fimper.

     END.
  &endif
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

   /* Code placed here will execute AFTER standard behavior.    */
    &if defined(bf_mat_fech_estab) &then
        {utp/ut-liter.i Tipo_Pre‡o_M‚dio * L}
        assign c-lb-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
        {utp/ut-liter.i Valoriza_Entrada_Transferˆncia * L}
        assign c-lb-transf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
        {utp/ut-liter.i Parƒmetros * L}
        assign c-lb-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
    &endif
    
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  find first param-estoq no-lock no-error.
  if  param-estoq.tp-fech = 2 then do:

      if adm-new-record then
        enable rs-tipo-pr-med
               l-acerto-aut
               l-gera-act
               da-mensal-ate
               da-sumar-ate
               da-contab-ate
               c-ult-per-fech
               da-ult-fech-dia
               i-num-dec with frame {&frame-name}.
      else do:
          if can-find(first item-estab where
                            item-estab.cod-estabel = estab-mat.cod-estabel and
                            (item-estab.val-unit-mat-m[1] <> 0 or
                             item-estab.val-unit-mob-m[1] <> 0 or
                             item-estab.val-unit-ggf-m[1] <> 0 or
                             item-estab.val-unit-mat-o[1] <> 0 or
                             item-estab.val-unit-mob-o[1] <> 0 or
                             item-estab.val-unit-ggf-o[1] <> 0 or
                             item-estab.val-unit-mat-p[1] <> 0 or
                             item-estab.val-unit-mob-p[1] <> 0 or
                             item-estab.val-unit-ggf-p[1] <> 0)) then
              disable da-mensal-ate
                      da-sumar-ate
                      da-contab-ate
                      c-ult-per-fech
                      da-ult-fech-dia
                      with frame {&frame-name}.
          else 
              enable da-mensal-ate
                     da-sumar-ate
                     da-contab-ate
                     c-ult-per-fech
                     da-ult-fech-dia
                     with frame {&frame-name}.
  
          if  estab-mat.mensal-ate = estab-mat.ult-fech-dia then
              enable rs-tipo-pr-med
                     l-acerto-aut
                     l-gera-act
                     i-num-dec with frame {&frame-name}.
          else
              disable rs-tipo-pr-med
                      l-acerto-aut
                      l-gera-act
                      i-num-dec with frame {&frame-name}.

          run pi-habilita-campos (input estab-mat.cod-estabel).

      end. /* else do */

      IF  SUBSTR(param-estoq.char-2,67,1) <> "S" AND  /* nao agrupa por empresa*/
          can-find(funcao WHERE 
              funcao.cd-funcao = "spp-valoriza-nft-estab" AND 
              funcao.ativo     = yes)  THEN
          ENABLE i-val-transf WITH FRAME {&FRAME-NAME}.
      ELSE
          DISABLE i-val-transf WITH FRAME {&FRAME-NAME}.

  END. /* if  param-estoq.tp-fech = 2 */
  ELSE DO:
      
      enable da-mensal-ate
             da-sumar-ate
             da-contab-ate
             c-ult-per-fech
             da-ult-fech-dia
             with frame {&frame-name}.

      disable c-lb-fase
              rs-tipo-pr-med
              i-val-transf
              l-acerto-aut
              l-gera-act
              l-pm-ja-ini
              l-fec-ja-ini
              i-num-dec with frame {&frame-name}.

      if input frame {&FRAME-NAME} i-num-dec = 0 then
         assign i-num-dec:screen-value in frame {&FRAME-NAME} = "4".

  END.        
  
  if  input frame {&FRAME-NAME} rs-tipo-pr-med = 1  then 
      assign l-gera-act:screen-value in frame {&FRAME-NAME} = "no"
             l-gera-act = no.  

  {utp/ut-field.i mgind estab-mat acerto-aut 2}
  assign l-acerto-aut:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat gera-act 2}
  assign l-gera-act:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Pre‡o_M‚dio_Iniciado *}
  assign l-pm-ja-ini:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Fechamento_Iniciado *}
  assign l-fec-ja-ini:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Decimais_para_C lculo *}
  assign i-num-dec:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Tipo_Pre‡o_M‚dio * L}
  assign c-lb-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Valoriza_Entrada_Transferˆncia * L}
  assign c-lb-transf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Parƒmetros * L}
  assign c-lb-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = return-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c-valor           AS CHARACTER   NO-UNDO.
    
  /* Code placed here will execute PRIOR to standard behavior. */
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {varinc/var00083.i 04 1}.
      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN c-valor = RETURN-VALUE + ", 1, " .
      ASSIGN cAuxTraducao001 = {varinc/var00083.i 04 2}.
      run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                          INPUT "",
                          INPUT "").
      ASSIGN c-valor = c-valor + RETURN-VALUE + ", 2" 
             i-val-transf:radio-buttons in frame {&frame-name} = c-valor.
  &else
      ASSIGN c-valor = {varinc/var00083.i 04 1} + ", 1, "
                     + {varinc/var00083.i 04 2} + ", 2"
               i-val-transf:radio-buttons in frame {&frame-name} = c-valor.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  &if defined(bf_mat_fech_estab) &then
    {utp/ut-field.i mgind estab-mat acerto-aut 2}
    assign l-acerto-aut:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-field.i mgind estab-mat gera-act 2}
    assign l-gera-act:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Pre‡o_M‚dio_Iniciado *}
    assign l-pm-ja-ini:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Fechamento_Iniciado *}
    assign l-fec-ja-ini:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Decimais_para_C lculo *}
    assign i-num-dec:label in frame {&FRAME-NAME} = return-value.     
  &endif
  
  &if defined(bf_mat_fech_estab) &then
     if avail estab-mat then
        assign c-lb-fase = {ininc/i09in287.i 04  estab-mat.fase-medio}.
  &endif
   
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-handle V-table-Win 
PROCEDURE pi-grava-handle :
/*------------------------------------------------------------------------------
  Purpose: Guarda o handle da viewer principal (cabecalho)     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable ponteiro as widget-handle no-undo.

    ponteiro = session:first-procedure.
    ponteiro = ponteiro:next-sibling.
    
    do  while valid-handle(ponteiro):
        assign h-v01in661 = ponteiro:handle.
        if  ponteiro:file-name = "invwr~\v01in661.w":u then
            leave.
        else
            ponteiro = ponteiro:next-sibling.
    end.    
    
    return 'OK':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-cod-estabel as char.

find estabelec where estabelec.cod-estabel = c-cod-estabel no-lock no-error.
if avail estabelec then do:
    if estabelec.usa-mensal then
       enable rs-tipo-pr-med
              l-gera-act
              i-num-dec with frame {&FRAME-NAME}.
    else
       disable rs-tipo-pr-med
               l-gera-act
               i-num-dec with frame {&FRAME-NAME}.
    if estabelec.usa-on-line then
       enable l-acerto-aut with frame {&FRAME-NAME}.
    else 
       disable l-acerto-aut with frame {&FRAME-NAME}.
end.

if input frame {&FRAME-NAME} rs-tipo-pr-med = 1  then do:
    disable l-gera-act with frame {&frame-name}.
end.
else
    enable l-gera-act with frame {&frame-name}. 

IF l-agr-estab-emp THEN
    DISABLE i-val-transf
        WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-fech-por-emp V-table-Win 
PROCEDURE pi-valida-fech-por-emp PRIVATE :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
        
    FIND FIRST param-estoq NO-LOCK NO-ERROR.
   
    IF NOT AVAILABLE param-estoq OR SUBSTRING(param-estoq.CHAR-2,67,1) <> "S" THEN RETURN "OK":U.
    
    FOR FIRST b-estabelec NO-LOCK 
        WHERE b-estabelec.cod-estabel = estab-mat.cod-estabel:
  
        IF estab-mat.tipo-pr-med  <> input frame {&FRAME-NAME} rs-tipo-pr-med    OR
           estab-mat.acerto-aut   <> l-acerto-aut:checked in frame {&FRAME-NAME} OR
           estab-mat.gera-act     <> l-gera-act:checked in frame {&FRAME-NAME}   OR
           estab-mat.num-dec      <> input frame {&FRAME-NAME} i-num-dec         OR 
           estab-mat.mensal-ate   <> input frame {&frame-name} da-mensal-ate     OR
           estab-mat.sumar-ate    <> input frame {&frame-name} da-sumar-ate      OR
           estab-mat.contab-ate   <> input frame {&frame-name} da-contab-ate     OR
           estab-mat.ult-fech-dia <> input frame {&frame-name} da-ult-fech-dia   OR
           estab-mat.ult-per-fech <> input frame {&frame-name} c-ult-per-fech THEN DO:
              
           RUN utp/ut-msgs.p (INPUT 'show',
                              INPUT 54409, 
                              INPUT b-estabelec.ep-codigo).
                                                       
           IF RETURN-VALUE = "NO" THEN RETURN "NOK":U.                            
        END.      
             
        FOR EACH estabelec NO-LOCK  
            WHERE estabelec.ep-codigo = b-estabelec.ep-codigo:
        
           FOR FIRST b-estab-mat EXCLUSIVE-LOCK
               WHERE b-estab-mat.cod-estabel = estabelec.cod-estabel:

               /* se algum dos estabelecimento da empresa jah possui movto-estoq, entao
                  as datas de fechamento nao podem ser alteradas para nao causar inconsistencias de saldos */
               IF  CAN-FIND(FIRST movto-estoq
                            WHERE movto-estoq.cod-estabel = b-estab-mat.cod-estabel)     
               AND (b-estab-mat.mensal-ate   <> INPUT FRAME {&FRAME-NAME} da-mensal-ate   OR  
                    b-estab-mat.sumar-ate    <> INPUT FRAME {&FRAME-NAME} da-sumar-ate    OR  
                    b-estab-mat.contab-ate   <> INPUT FRAME {&FRAME-NAME} da-contab-ate   OR  
                    b-estab-mat.ult-fech-dia <> INPUT FRAME {&FRAME-NAME} da-ult-fech-dia OR  
                    b-estab-mat.ult-per-fech <> INPUT FRAME {&FRAME-NAME} c-ult-per-fech)
               THEN DO:
                   ASSIGN c-liter1 = ""
                          c-liter2 = ""
                          c-liter3 = "".
                   {utp/ut-liter.i Estabelecimento * r}
                   ASSIGN c-liter1 = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i ja * r}
                   ASSIGN c-liter1 = c-liter1 + TRIM(RETURN-VALUE) + " " + estabelec.cod-estabel + " " + RETURN-VALUE.
                   {utp/ut-liter.i "Movimentos_de_estoque" * r}
                   ASSIGN c-liter2 = c-liter2 + TRIM(RETURN-VALUE).
                   {utp/ut-liter.i Estabelecimento * r}
                   ASSIGN c-liter3 = TRIM(RETURN-VALUE) + " " + estabelec.cod-estabel.
                   {utp/ut-liter.i pertence_a_mesma_empresa_do_estabelecimento * r}
                   ASSIGN c-liter3 = c-liter3 + " " + TRIM(RETURN-VALUE) + " " + estab-mat.cod-estabel.
                   RUN utp/ut-msgs.p("show",1170, c-liter1 + "~~ " + c-liter2 + "~~" + c-liter3).
                   UNDO, RETURN "NOK".
               END.

               ASSIGN b-estab-mat.tipo-pr-med  = INPUT FRAME {&FRAME-NAME} rs-tipo-pr-med    
                      b-estab-mat.acerto-aut   = l-acerto-aut:checked in frame {&FRAME-NAME} 
                      b-estab-mat.gera-act     = l-gera-act:checked in frame {&FRAME-NAME}   
                      b-estab-mat.num-dec      = INPUT FRAME {&FRAME-NAME} i-num-dec          
                      b-estab-mat.mensal-ate   = INPUT FRAME {&FRAME-NAME} da-mensal-ate     
                      b-estab-mat.sumar-ate    = INPUT FRAME {&FRAME-NAME} da-sumar-ate      
                      b-estab-mat.contab-ate   = INPUT FRAME {&FRAME-NAME} da-contab-ate     
                      b-estab-mat.ult-fech-dia = INPUT FRAME {&FRAME-NAME} da-ult-fech-dia   
                      b-estab-mat.ult-per-fech = INPUT FRAME {&FRAME-NAME} c-ult-per-fech.                 
            END.     

        END.
    END.
    
    RETURN "OK":U.         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

DEF VAR l-erro-data AS LOG NO-UNDO.
 if input frame {&FRAME-NAME} da-mensal-ate = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-mensal-ate in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.
 
 if input frame {&FRAME-NAME} da-sumar-ate = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-sumar-ate in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.

 if input frame {&FRAME-NAME} da-contab-ate = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-contab-ate in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.

 if input frame {&FRAME-NAME} da-ult-fech-dia = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-ult-fech-dia in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.

 if substring(c-ult-per-fech:screen-value,1,1) = '0' 
 or substring(c-ult-per-fech:screen-value,1,1) = '' then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 333,
                       input "").
    apply 'entry' to c-ult-per-fech in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.


 run cdp/cdapi005.p (input frame {&frame-name} c-ult-per-fech,
                     output da-iniper,   
                     output da-fimper,
                     output i-per-corrente,
                     output i-ano-corrente,
                     output da-iniper-fech,
                     output da-fimper-fech).

  if  da-fimper-fech = ? then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 16459, /* Ano fiscal n’o estÿ cadastrado */
                         input "").
      apply 'entry' to c-ult-per-fech in frame {&frame-name}.
      return "adm-error".
  end.
  
 /***************** Validacao do estab-mat.ult-fech-dia *********************/
 if  da-ult-fech-dia:sensitive in frame {&frame-name} = yes then
     if  da-fimper-fech <> input frame {&frame-name} da-ult-fech-dia then do:
         {include/i-vldprg.i}
         {utp/ut-field.i mgind estab-mat ult-fech-dia 1}
         run utp/ut-msgs.p (input "show",
                         input 29928, /* &1 deve ser igual a &2 */
                         input return-value + "~~" +
                               string(da-fimper-fech)).
         apply 'entry' to da-ult-fech-dia in frame {&frame-name}.
         return "ADM-ERROR".
     end.
 /*****************************************************************************/    
  
 /***************** Validacao do estab-mat.mensal-ate ************************/
 if  da-mensal-ate:sensitive in frame {&frame-name} = yes then
     if  da-fimper-fech <> input frame {&frame-name} da-mensal-ate then do:
         {include/i-vldprg.i}
         {utp/ut-field.i mgind estab-mat mensal-ate 1}
         run utp/ut-msgs.p (input "show",
                            input 29928, /* &1 deve ser igual a &2 */
                            input return-value + "~~" +
                                  string(da-fimper-fech)).
         apply 'entry' to da-mensal-ate in frame {&frame-name}.
         return "ADM-ERROR".
     end.
 /*****************************************************************************/    
   
 /***************** Validacao do estab-mat.contab-ate ***********************/
 if  da-contab-ate:sensitive in frame {&frame-name} = yes then
     if  da-fimper-fech <> input frame {&frame-name} da-contab-ate then do:
         {include/i-vldprg.i}
         {utp/ut-field.i mgind estab-mat contab-ate 1}
         run utp/ut-msgs.p (input "show",
                            input 29928, /* &1 deve ser igual a &2 */
                            input return-value + "~~" +
                                  string(da-fimper-fech)).
         apply 'entry' to da-contab-ate in frame {&frame-name}.
         return "ADM-ERROR".
     end.
 /*****************************************************************************/    

IF INPUT FRAME {&FRAME-NAME} i-val-transf <> estab-mat.idi-val-transf THEN DO:

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = estab-mat.cod-estabel NO-LOCK NO-ERROR.

    FIND FIRST saldo-terc
        WHERE saldo-terc.cod-emitente  = estabelec.cod-emitente
        AND   saldo-terc.tipo-sal-terc = 3 /*transito*/
        AND   saldo-terc.quantidade    > 0 NO-LOCK NO-ERROR.

    IF AVAIL saldo-terc THEN
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56542,
                           INPUT "").
END.

IF  NOT AVAIL param-estoq THEN
    FIND FIRST param-estoq NO-LOCK NO-ERROR.

IF  SUBSTR(param-estoq.char-2,67,1) = "S" /* agrupa por empresa*/ THEN DO:

    ASSIGN l-erro-data = NO.
    
    /* se o medio de algum dos estabelecimentos da empresa jah teve o medio calculado
       mas ainda nao fechou o periodo, entao nao deixa incluir novo estabeleicimento no grupo */
    FOR FIRST b-estabelec
        WHERE b-estabelec.cod-estabel = estab-mat.cod-estabel NO-LOCK,
        EACH  estabelec NO-LOCK  
        WHERE estabelec.ep-codigo = b-estabelec.ep-codigo:
    
        FOR FIRST b-estab-mat EXCLUSIVE-LOCK
            WHERE b-estab-mat.cod-estabel = estabelec.cod-estabel:
    
            IF  b-estab-mat.mensal-ate <> b-estab-mat.ult-fech-dia THEN DO:
                ASSIGN l-erro-data = YES.
                LEAVE.
            END.
    
         END.     
    END.
    
    
    
    IF  da-ult-fech-dia:SENSITIVE IN FRAME {&FRAME-NAME} 
    AND l-erro-data THEN DO:
        {utp/ut-liter.i "Estabelecimento_Estoque" * r}
        ASSIGN c-liter1 = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Empresa_esta_em_periodo_de_fechamento._Aguarde_ate_que_o_fechamento_seja_finalizado" * r}
        ASSIGN c-liter2 = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p("show",7481, c-liter1 + "~~" + c-liter2 ).
        RETURN "adm-error".
    END.

END.

RETURN "OK".

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
  {src/adm/template/snd-list.i "estab-mat"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

