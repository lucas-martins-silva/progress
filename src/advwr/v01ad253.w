&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD253 2.00.00.009} /*** "010009" 25/06/2025 16:21:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD253 MUT}
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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                

def var i-dias       as integer    no-undo. 
def var i-mes        as integer    no-undo.
def var c-ano-per    as character  format "999999" no-undo.
def var c-periodo    as character  format "999999" no-undo.
def var c-formato    as char       no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*************Multiplanta********************/

def var i-tipo-movto as integer no-undo.

{cdp/cd7300.i1}
{fcp/fcapi201.i}

/************Fim*****************************/

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.
def var c-chave-mg       as char no-undo.
def var i-cont-mg        as inte no-undo.


{fcp/fc0303i1.i} /* Definiá∆o da temp-table tt-tb-prev-corr-mg  */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/


def var l-primeira-vez   as logical   no-undo.
def var de-percentual    as decimal   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES tb-prev-corr
&Scoped-define FIRST-EXTERNAL-TABLE tb-prev-corr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tb-prev-corr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tb-prev-corr.indice[1] tb-prev-corr.indice[2] ~
tb-prev-corr.indice[3] tb-prev-corr.indice[4] tb-prev-corr.indice[5] ~
tb-prev-corr.indice[6] tb-prev-corr.indice[7] tb-prev-corr.indice[8] ~
tb-prev-corr.indice[9] tb-prev-corr.indice[10] tb-prev-corr.indice[11] ~
tb-prev-corr.indice[12] tb-prev-corr.indice[13] tb-prev-corr.indice[14] ~
tb-prev-corr.indice[15] tb-prev-corr.indice[16] tb-prev-corr.indice[17] ~
tb-prev-corr.indice[18] tb-prev-corr.indice[19] tb-prev-corr.indice[20] ~
tb-prev-corr.indice[21] tb-prev-corr.indice[22] tb-prev-corr.indice[23] ~
tb-prev-corr.indice[24] tb-prev-corr.indice[25] tb-prev-corr.indice[26] ~
tb-prev-corr.indice[27] tb-prev-corr.indice[28] tb-prev-corr.indice[29] ~
tb-prev-corr.indice[30] tb-prev-corr.indice[31] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}indice[1] ~{&FP2}indice[1] ~{&FP3}~
 ~{&FP1}indice[2] ~{&FP2}indice[2] ~{&FP3}~
 ~{&FP1}indice[3] ~{&FP2}indice[3] ~{&FP3}~
 ~{&FP1}indice[4] ~{&FP2}indice[4] ~{&FP3}~
 ~{&FP1}indice[5] ~{&FP2}indice[5] ~{&FP3}~
 ~{&FP1}indice[6] ~{&FP2}indice[6] ~{&FP3}~
 ~{&FP1}indice[7] ~{&FP2}indice[7] ~{&FP3}~
 ~{&FP1}indice[8] ~{&FP2}indice[8] ~{&FP3}~
 ~{&FP1}indice[9] ~{&FP2}indice[9] ~{&FP3}~
 ~{&FP1}indice[10] ~{&FP2}indice[10] ~{&FP3}~
 ~{&FP1}indice[11] ~{&FP2}indice[11] ~{&FP3}~
 ~{&FP1}indice[12] ~{&FP2}indice[12] ~{&FP3}~
 ~{&FP1}indice[13] ~{&FP2}indice[13] ~{&FP3}~
 ~{&FP1}indice[14] ~{&FP2}indice[14] ~{&FP3}~
 ~{&FP1}indice[15] ~{&FP2}indice[15] ~{&FP3}~
 ~{&FP1}indice[16] ~{&FP2}indice[16] ~{&FP3}~
 ~{&FP1}indice[17] ~{&FP2}indice[17] ~{&FP3}~
 ~{&FP1}indice[18] ~{&FP2}indice[18] ~{&FP3}~
 ~{&FP1}indice[19] ~{&FP2}indice[19] ~{&FP3}~
 ~{&FP1}indice[20] ~{&FP2}indice[20] ~{&FP3}~
 ~{&FP1}indice[21] ~{&FP2}indice[21] ~{&FP3}~
 ~{&FP1}indice[22] ~{&FP2}indice[22] ~{&FP3}~
 ~{&FP1}indice[23] ~{&FP2}indice[23] ~{&FP3}~
 ~{&FP1}indice[24] ~{&FP2}indice[24] ~{&FP3}~
 ~{&FP1}indice[25] ~{&FP2}indice[25] ~{&FP3}~
 ~{&FP1}indice[26] ~{&FP2}indice[26] ~{&FP3}~
 ~{&FP1}indice[27] ~{&FP2}indice[27] ~{&FP3}~
 ~{&FP1}indice[28] ~{&FP2}indice[28] ~{&FP3}~
 ~{&FP1}indice[29] ~{&FP2}indice[29] ~{&FP3}~
 ~{&FP1}indice[30] ~{&FP2}indice[30] ~{&FP3}~
 ~{&FP1}indice[31] ~{&FP2}indice[31] ~{&FP3}
&Scoped-define ENABLED-TABLES tb-prev-corr
&Scoped-define FIRST-ENABLED-TABLE tb-prev-corr
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS tb-prev-corr.cd-tabela ~
tb-prev-corr.indice[1] tb-prev-corr.indice[2] tb-prev-corr.indice[3] ~
tb-prev-corr.indice[4] tb-prev-corr.indice[5] tb-prev-corr.indice[6] ~
tb-prev-corr.indice[7] tb-prev-corr.indice[8] tb-prev-corr.indice[9] ~
tb-prev-corr.indice[10] tb-prev-corr.indice[11] tb-prev-corr.indice[12] ~
tb-prev-corr.indice[13] tb-prev-corr.indice[14] tb-prev-corr.indice[15] ~
tb-prev-corr.indice[16] tb-prev-corr.indice[17] tb-prev-corr.indice[18] ~
tb-prev-corr.indice[19] tb-prev-corr.indice[20] tb-prev-corr.indice[21] ~
tb-prev-corr.indice[22] tb-prev-corr.indice[23] tb-prev-corr.indice[24] ~
tb-prev-corr.indice[25] tb-prev-corr.indice[26] tb-prev-corr.indice[27] ~
tb-prev-corr.indice[28] tb-prev-corr.indice[29] tb-prev-corr.indice[30] ~
tb-prev-corr.indice[31] 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-prev-corr.cd-tabela 
&Scoped-define ADM-MODIFY-FIELDS tb-prev-corr.indice[1] ~
tb-prev-corr.indice[2] tb-prev-corr.indice[3] tb-prev-corr.indice[4] ~
tb-prev-corr.indice[5] tb-prev-corr.indice[6] tb-prev-corr.indice[7] ~
tb-prev-corr.indice[8] tb-prev-corr.indice[9] tb-prev-corr.indice[10] ~
tb-prev-corr.indice[11] tb-prev-corr.indice[12] tb-prev-corr.indice[13] ~
tb-prev-corr.indice[14] tb-prev-corr.indice[15] tb-prev-corr.indice[16] ~
tb-prev-corr.indice[17] tb-prev-corr.indice[18] tb-prev-corr.indice[19] ~
tb-prev-corr.indice[20] tb-prev-corr.indice[21] tb-prev-corr.indice[22] ~
tb-prev-corr.indice[23] tb-prev-corr.indice[24] tb-prev-corr.indice[25] ~
tb-prev-corr.indice[26] tb-prev-corr.indice[27] tb-prev-corr.indice[28] ~
tb-prev-corr.indice[29] tb-prev-corr.indice[30] tb-prev-corr.indice[31] 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 13.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-prev-corr.cd-tabela AT ROW 1.25 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tb-prev-corr.indice[1] AT ROW 2.63 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[2] AT ROW 3.42 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[3] AT ROW 4.25 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[4] AT ROW 5.04 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[5] AT ROW 5.83 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[6] AT ROW 6.67 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[7] AT ROW 7.46 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[8] AT ROW 8.25 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[9] AT ROW 9.08 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[10] AT ROW 9.88 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[11] AT ROW 10.71 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[12] AT ROW 11.5 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[13] AT ROW 12.29 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[14] AT ROW 13.13 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[15] AT ROW 13.92 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[16] AT ROW 2.63 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[17] AT ROW 3.42 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[18] AT ROW 4.25 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[19] AT ROW 5.04 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[20] AT ROW 5.83 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[21] AT ROW 6.67 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[22] AT ROW 7.46 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[23] AT ROW 8.25 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[24] AT ROW 9.08 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[25] AT ROW 9.88 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[26] AT ROW 10.71 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[27] AT ROW 11.5 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     tb-prev-corr.indice[28] AT ROW 12.29 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[29] AT ROW 13.13 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[30] AT ROW 13.92 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     tb-prev-corr.indice[31] AT ROW 14.75 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     rt-key AT ROW 1.04 COL 1
     rt-mold AT ROW 2.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.tb-prev-corr
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 14.92
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN tb-prev-corr.cd-tabela IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[10] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[11] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[12] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[13] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[14] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[15] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[16] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[17] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[18] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[19] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[1] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[20] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[21] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[22] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[23] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[24] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[25] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[26] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[27] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[28] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[29] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[2] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[30] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[31] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[3] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[4] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[5] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[6] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[7] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[8] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN tb-prev-corr.indice[9] IN FRAME f-main
   3                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME tb-prev-corr.cd-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-prev-corr.cd-tabela V-table-Win
ON LEAVE OF tb-prev-corr.cd-tabela IN FRAME f-main /* Previs∆o */
DO:
   assign c-formato = input frame {&FRAME-NAME} tb-prev-corr.cd-tabela no-error.
   if  error-status:get-number(1) <> 0 then do:
       assign tb-prev-corr.cd-tabela:format in frame {&FRAME-NAME} = "x(06)".
   end.
   else do:
       assign tb-prev-corr.cd-tabela:format in frame {&FRAME-NAME} = "99/9999".
   end.             

   assign c-ano-per = string(input frame {&FRAME-NAME} tb-prev-corr.cd-tabela, "999999").
 
   assign i-mes = int(substring(c-ano-per,1,2)).
   if  i-mes < 1  or i-mes > 12  then do:
       run utp/ut-msgs.p (input "show",
                          input 333,
                          input "").
       apply "entry" to tb-prev-corr.cd-tabela in frame {&frame-name}.  
       return no-apply.  
   end.  

  if input frame {&frame-name} tb-prev-corr.cd-tabela = ? then do:
     run utp/ut-msgs.p (input "show",
                        input 6101,
                        input "").
     return 'no-apply'.          
  end.            

  if  l-primeira-vez then do:
      run utp/ut-msgs.p (input "show",
                         input 26174,
                         input "").
      if  return-value = "no" then do:
          run fcp/fc0303a.w(output de-percentual).
          if de-percentual <> 0 then
             run pi-rateio.
      end.                   
      assign l-primeira-vez = no.
  end.                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF
  
  {utp/ut-liter.i Indice_Previsto * C}
  assign tb-prev-corr.indice[1]:label  in frame {&frame-name} = return-value + " 01"
         tb-prev-corr.indice[2]:label  in frame {&frame-name} = return-value + " 02"
         tb-prev-corr.indice[3]:label  in frame {&frame-name} = return-value + " 03"
         tb-prev-corr.indice[4]:label  in frame {&frame-name} = return-value + " 04"
         tb-prev-corr.indice[5]:label  in frame {&frame-name} = return-value + " 05"
         tb-prev-corr.indice[6]:label  in frame {&frame-name} = return-value + " 06"
         tb-prev-corr.indice[7]:label  in frame {&frame-name} = return-value + " 07"
         tb-prev-corr.indice[8]:label  in frame {&frame-name} = return-value + " 08"
         tb-prev-corr.indice[9]:label  in frame {&frame-name} = return-value + " 09"
         tb-prev-corr.indice[10]:label in frame {&frame-name} = return-value + " 10"
         tb-prev-corr.indice[11]:label in frame {&frame-name} = return-value + " 11"
         tb-prev-corr.indice[12]:label in frame {&frame-name} = return-value + " 12"
         tb-prev-corr.indice[13]:label in frame {&frame-name} = return-value + " 13"
         tb-prev-corr.indice[14]:label in frame {&frame-name} = return-value + " 14"
         tb-prev-corr.indice[15]:label in frame {&frame-name} = return-value + " 15"
         tb-prev-corr.indice[16]:label in frame {&frame-name} = return-value + " 16"
         tb-prev-corr.indice[17]:label in frame {&frame-name} = return-value + " 17"
         tb-prev-corr.indice[18]:label in frame {&frame-name} = return-value + " 18"
         tb-prev-corr.indice[19]:label in frame {&frame-name} = return-value + " 19"
         tb-prev-corr.indice[20]:label in frame {&frame-name} = return-value + " 20"
         tb-prev-corr.indice[21]:label in frame {&frame-name} = return-value + " 21"
         tb-prev-corr.indice[22]:label in frame {&frame-name} = return-value + " 22"
         tb-prev-corr.indice[23]:label in frame {&frame-name} = return-value + " 23"
         tb-prev-corr.indice[24]:label in frame {&frame-name} = return-value + " 24"
         tb-prev-corr.indice[25]:label in frame {&frame-name} = return-value + " 25"
         tb-prev-corr.indice[26]:label in frame {&frame-name} = return-value + " 26"
         tb-prev-corr.indice[27]:label in frame {&frame-name} = return-value + " 27"
         tb-prev-corr.indice[28]:label in frame {&frame-name} = return-value + " 28"
         tb-prev-corr.indice[29]:label in frame {&frame-name} = return-value + " 29"
         tb-prev-corr.indice[30]:label in frame {&frame-name} = return-value + " 30"
         tb-prev-corr.indice[31]:label in frame {&frame-name} = return-value + " 31".
  
  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "tb-prev-corr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tb-prev-corr"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  
  if (month(today)) < 10 then do:
   assign tb-prev-corr.cd-tabela:screen-value in frame {&frame-name} = "0" +
            string(month(today)) + string(year(today)).
  end.
  else do:
    assign tb-prev-corr.cd-tabela:screen-value in frame {&frame-name} = 
           string(month(today)) + string(year(today)).
  end.         
  
  assign l-primeira-vez = yes.
          

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    find tb-prev-corr
       where tb-prev-corr.cd-tabela = input frame {&frame-name} tb-prev-corr.cd-tabela 
       no-lock  no-error.     
    if avail tb-prev-corr       /* O sensitive testa se Ç uma alteraá∆o ou inclus∆o */              
     and tb-prev-corr.cd-tabela:sensitive then do:
     run utp/ut-msgs.p (input "show",
                        input 7,
                        input tb-prev-corr.cd-tabela).
        return 'adm-error'.                   
    end.  


    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .


    /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    {cdp/cd0002i1.i tb-prev-corr}


    /********************Multiplanta***********************/
  
    assign c-transacao = "ADM043".
    {cdp/cd7300.i5 "001" c-transacao}
  
    assign i-tipo-movto = if tb-prev-corr.cd-tabela:sensitive in frame {&frame-name} then 1
                                                                                else 2.
   
    run pi-cria-tt-dados (input i-tipo-movto).
  
    {cdp/cd7300.i6 "001" c-transacao}
  
    /******************Fim-Multiplanta********************/ 



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0002i1.i1 tb-prev-corr "no"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    if return-value = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.
    
    {cdp/cd0002i1.i1 tb-prev-corr "yes"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */


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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query V-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .
 
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
    
    {cdp/cd0003i1.i tb-prev-corr fcp/fc0303i1.p}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-tipo-movto as integer.
     
    if  param-global.modulo-mp and
        tt-replica-msg.log-replica-msg  = yes then do: 
        create tt-tb-prev-corr-aux.
        buffer-copy tb-prev-corr
              to tt-tb-prev-corr-aux.
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 149
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(tb-prev-corr.cd-tabela) + "," + 
                                             string(tb-prev-corr.seq-mes).
        raw-transfer tt-tb-prev-corr-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                     
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-tb-prev-corr-mg V-table-Win 
PROCEDURE pi-cria-tt-tb-prev-corr-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.
    
    for each tt-tb-prev-corr-mg:
        delete tt-tb-prev-corr-mg.
    end.
    
    create tt-tb-prev-corr-mg.
    assign tt-tb-prev-corr-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-tb-prev-corr-mg.l-atualiza     = p-atualiza.

    /* Campos Iguais */
    assign tt-tb-prev-corr-mg.cd-tabela = tb-prev-corr.cd-tabela
           tt-tb-prev-corr-mg.seq-mes   = tb-prev-corr.seq-mes.

    do i-cont-mg = 1 to 31:
       assign tt-tb-prev-corr-mg.indice[i-cont-mg] = tb-prev-corr.indice[i-cont-mg].
    end.

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
    
    assign c-chave-mg = tb-prev-corr.cd-tabela + ";" + trim(string(tb-prev-corr.seq-mes)).
    
    {cdp/cd0004i1.i "FC0303" "TB-PREV-CORR" c-chave-mg tt-tb-prev-corr-mg.ind-tipo-movto tt-erros-mg.help-msg}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio V-table-Win 
PROCEDURE pi-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {fcp/fc0303.i}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-tb-prev-corr-mg V-table-Win 
PROCEDURE pi-valida-tb-prev-corr-mg :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
 
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tb-prev-corr"}

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


