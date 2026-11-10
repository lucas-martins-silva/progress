&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movmnt           PROGRESS
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
{include/i-prgvrs.i V22IN270 2.00.00.080 } /*** "010080" ***/

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

{cdp/cdcfgman.i} /* Pre-processadores */

/* global variable definitions */
def new global shared var v-row-parent  as rowid no-undo.                               
def new global shared var gr-equipto    as rowid no-undo.
def new global shared var gr-tag        as rowid no-undo.
def new global shared var gr-mi-parada  as rowid no-undo.
def new global shared var gr-manut      as rowid no-undo.
def new global shared var gr-tipo-manut as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-formato-1 as char init "99:99" no-undo.
def var c-formato-2 as char init "99,99" no-undo.
def var c-label-1   as char format "x(15)" no-undo.
def var c-label-2   as char format "x(17)" no-undo.
def var c-label-3   as char format "x(20)" no-undo.
def var hr-hora-ini as decimal format ">9.99"   no-undo.
def var hr-hora-fim as decimal format ">9.99"   no-undo.
def var i-tot-hora  as decimal no-undo initial 0.
def var c-tot-hora  as CHAR FORMAT "x(6)"   no-undo.
def var hr-hora as decimal format ">9.99"   no-undo.
def var hr-min  as decimal format ">9.99"   no-undo.
DEF VAR c-liter2 AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-liter1 AS CHAR FORMAT "x(30)" NO-UNDO.
def var da-data-1   as date format 99/99/9999.
def var i-seq-aux   as integer.

{cep/ceapi001.i}
{cpp/cpapi013.i}
{cdp/cd0666.i}
{cdp/cdcfgmnt.i}
&if defined (bf_mnt_calib) &then
{gcp/gcapi002.i} /* calibracao */
&endif

def var c-handle   as char.
def var h-handle   as handle.
def var c-combo    as char format "x(10)" no-undo.
def var de-minuto  as decimal no-undo.
def var c-tempo    as char    no-undo.
def var c-hora     as char    no-undo.
def var de-valor   as decimal no-undo.
def var i-valor    as integer no-undo.
def var de-tempo   as decimal no-undo.
def var de-minuto1 as decimal no-undo.
def var c-tempo1   as char    no-undo.
def var c-hora1    as char    no-undo.
def var de-valor1  as decimal no-undo.
def var i-valor1   as integer no-undo.
def var de-tempo1  as decimal no-undo.

DEFINE VARIABLE i-min-aux1 AS DEC    NO-UNDO.
DEFINE VARIABLE i-min-aux2 AS DEC    NO-UNDO.
DEFINE VARIABLE i-hora-1 AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-hora-2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE d-hora   AS DECIMAL    NO-UNDO.


{utp/ut-glob.i}
{btb/btb008za.i0}

def var h-cpapi013 as handle  no-undo.
def var c-servidor as char    no-undo.

/*referente ao modulo MI PREDITIVA*/
DEFINE VARIABLE h-RelacOrd-preditiva AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-ems204             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-log-modul-predit   AS LOGICAL    NO-UNDO.
/*Estado Preditiva*/
DEFINE VARIABLE i-estado-pred        AS INTEGER    NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.dt-fecham 
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-manut.cd-equipto ord-manut.cd-manut ~
ord-manut.cd-tipo ord-manut.cd-tag ord-manut.cd-parada ord-manut.dt-manut ~
ord-manut.dt-prev ord-manut.dt-fecham 
&Scoped-define DISPLAYED-TABLES ord-manut
&Scoped-define FIRST-DISPLAYED-TABLE ord-manut
&Scoped-Define DISPLAYED-OBJECTS cb-estado-preditiva c-descr-equipto ~
c-descr-manut c-descr-tipo-manut c-descr-tag c-descr-parada cb-tp-relogio ~
da-data-parada c-hora-ini da-data-retorno c-hora-ret tempo-para 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-tp-relogio da-data-parada c-hora-ini ~
da-data-retorno c-hora-ret tempo-para 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
al-codigo||y|movind.ord-manut.al-codigo
cd-causa-padr||y|movind.ord-manut.cd-causa-padr
cd-equipto||y|movind.ord-manut.cd-equipto
nr-ord-produ||y|movind.ord-manut.nr-ord-produ
cd-inspecao||y|movind.ord-manut.cd-inspecao
cd-interv-padr||y|movind.ord-manut.cd-interv-padr
cd-manut||y|movind.ord-manut.cd-manut
sequencia||y|movind.ord-manut.sequencia
cd-parada||y|movind.ord-manut.cd-parada
cd-tag||y|movind.ord-manut.cd-tag
cd-pend-padr||y|movind.ord-manut.cd-pend-padr
cd-planejado||y|movind.ord-manut.cd-planejado
cd-projeto||y|movind.ord-manut.cd-projeto
nr-rot-insp||y|movind.ord-manut.nr-rot-insp
nr-rot-lubr||y|movind.ord-manut.nr-rot-lubr
cd-sint-padr||y|movind.ord-manut.cd-sint-padr
cd-tipo||y|movind.ord-manut.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "al-codigo,cd-causa-padr,cd-equipto,nr-ord-produ,cd-inspecao,cd-interv-padr,cd-manut,sequencia,cd-parada,cd-tag,cd-pend-padr,cd-planejado,cd-projeto,nr-rot-insp,nr-rot-lubr,cd-sint-padr,cd-tipo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-estado-preditiva AS CHARACTER FORMAT "X(256)":U INITIAL "          1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31.72 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-relogio AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-descr-equipto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-tag AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-tipo-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-hora-ini AS CHARACTER FORMAT "x(5)":U INITIAL "0000" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-hora-ret AS CHARACTER FORMAT "X(5)":U INITIAL "0000" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-parada AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-retorno AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tempo-para AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Tempo Parada":R15 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 9.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-estado-preditiva AT ROW 9.17 COL 50 COLON-ALIGNED
     ord-manut.cd-equipto AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descr-equipto AT ROW 1.17 COL 82.57 RIGHT-ALIGNED NO-LABEL
     ord-manut.cd-manut AT ROW 2.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-manut AT ROW 2.17 COL 82.43 RIGHT-ALIGNED NO-LABEL
     ord-manut.cd-tipo AT ROW 3.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-descr-tipo-manut AT ROW 3.17 COL 82.43 RIGHT-ALIGNED NO-LABEL
     ord-manut.cd-tag AT ROW 4.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descr-tag AT ROW 4.17 COL 82.43 RIGHT-ALIGNED NO-LABEL
     ord-manut.cd-parada AT ROW 5.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-parada AT ROW 5.17 COL 82.57 RIGHT-ALIGNED NO-LABEL
     ord-manut.dt-manut AT ROW 6.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ord-manut.dt-prev AT ROW 6.17 COL 54.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ord-manut.dt-fecham AT ROW 7.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     cb-tp-relogio AT ROW 8.17 COL 20 COLON-ALIGNED
     da-data-parada AT ROW 7.17 COL 50 COLON-ALIGNED
     c-hora-ini AT ROW 7.17 COL 71.57 COLON-ALIGNED
     da-data-retorno AT ROW 8.17 COL 50 COLON-ALIGNED
     c-hora-ret AT ROW 8.17 COL 71.57 COLON-ALIGNED
     tempo-para AT ROW 9.21 COL 20 COLON-ALIGNED HELP
          "Tempo de Parada do Equipamento para a Ordem"
     rt-mold AT ROW 1 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movmnt.ord-manut
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
         HEIGHT             = 9.75
         WIDTH              = 86.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:HEIGHT           = 9.75
       FRAME f-main:WIDTH            = 86.72.

/* SETTINGS FOR FILL-IN c-descr-equipto IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-descr-manut IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-descr-parada IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-descr-tag IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-descr-tipo-manut IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-hora-ini IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-hora-ret IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-estado-preditiva IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-relogio IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN ord-manut.cd-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-parada IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN da-data-retorno IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-prev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tempo-para IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME c-hora-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hora-ini V-table-Win
ON LEAVE OF c-hora-ini IN FRAME f-main
DO:
  {cdp/cd9998.i}

    if  input frame {&frame-name} c-hora-ini <> "" then do:
      if c-hora-ini:format in frame {&frame-name} = c-formato-1 then do:
         if  substring(input frame {&frame-name} c-hora-ini,3,2) > "59" then do:
             run utp/ut-msgs.p(input "show",
                               input 3046,
                               input return-value).
             apply 'entry' to c-hora-ini in frame {&frame-name}.
             return no-apply.
         end.
        if  substring(input frame {&frame-name} c-hora-ini,1,2) >= "24" then do:
            run utp/ut-msgs.p(input "show",
                              input 3046,
                              input return-value).
            apply 'entry' to c-hora-ini in frame {&frame-name}.
            return no-apply.
        end.
      end.
      else do:
         if  substring(input frame {&frame-name} c-hora-ini,1,2) >= "24" then do:
             run utp/ut-msgs.p(input "show",
                               input 15908,
                               input return-value).
             apply 'entry' to c-hora-ini in frame {&frame-name}.
             return no-apply.
         end.
      end.

       /* do with frame {&frame-name}: */
           assign c-hora = substring(input frame {&frame-name} c-hora-ini,1,2)
                  de-minuto = dec(substring(input frame {&frame-name} c-hora-ini,3,2)).

           if  c-hora-ini:format in frame {&frame-name} = c-formato-1 then
               assign de-minuto  = de-minuto * 60 / 100
                      c-tempo    = c-hora + string(de-minuto).
           else
               assign de-minuto  = de-minuto * 100 / 60
                       c-tempo   = c-hora + string(de-minuto).
               {cdp/cd9998.i1}
        /*end.*/       
    end.

    apply "entry" to tempo-para in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hora-ret
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hora-ret V-table-Win
ON LEAVE OF c-hora-ret IN FRAME f-main
DO:

{cdp/cd9998.i} 

    if  input frame {&frame-name} c-hora-ret <> "" then do:
      if c-hora-ret:format in frame {&frame-name} = c-formato-1 then do:
         if substring(input frame {&frame-name} c-hora-ret,3,2) > "59" then do:
             run utp/ut-msgs.p(input "show",
                               input 3046,
                               input return-value).
             apply "entry" to c-hora-ret in frame {&frame-name}.
             return no-apply.
         end.
         if  substring(input frame {&frame-name} c-hora-ret,1,2) >= "24" then do:
             run utp/ut-msgs.p(input "show",
                               input 3046,
                               input return-value).
             apply "entry" to c-hora-ret in frame {&frame-name}.
             return no-apply.
         end.
      end.
      else do:
         if  substring(input frame {&frame-name} c-hora-ret,1,2) >= "24" then do:
             run utp/ut-msgs.p(input "show",
                               input 15908,
                               input return-value).
             apply 'entry' to c-hora-ret in frame {&frame-name}.
             return no-apply.
         end.
      end.

       /* do with frame {&frame-name}: */       
           assign c-hora = substring(input frame {&frame-name} c-hora-ret,1,2)
                  de-minuto = dec(substring(input frame {&frame-name} c-hora-ret,3,2)).

           if  c-hora-ret:format in frame {&frame-name} = c-formato-1 then
               assign de-minuto  = de-minuto * 60 / 100
                       c-tempo   = c-hora + string(de-minuto).
           else
               assign de-minuto     = de-minuto * 100 / 60
                      c-tempo       = c-hora + string(de-minuto).
           {cdp/cd9998.i1}
       /* end. */   
    end.

    apply "entry" to tempo-para in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-relogio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-relogio V-table-Win
ON VALUE-CHANGED OF cb-tp-relogio IN FRAME f-main
DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    if LOOKUP (cb-tp-relogio:SCREEN-VALUE,cb-tp-relogio:LIST-ITEM-PAIRS) = 1 THEN  /* horario */    
    &else
    if LOOKUP (cb-tp-relogio:SCREEN-VALUE,cb-tp-relogio:LIST-ITEMS) = 1 THEN  /* horario */
    &endif
        assign c-hora-ini:format in frame {&frame-name} = c-formato-1
               c-hora-ret:format in frame {&frame-name} = c-formato-1.
    else 
        assign c-hora-ini:format in frame {&frame-name} = c-formato-2
               c-hora-ret:format in frame {&frame-name} = c-formato-2.

    if  c-combo <> input frame {&frame-name} cb-tp-relogio then do:
        assign c-hora = substring(input frame {&frame-name} c-hora-ini,1,2)
               de-minuto  = dec(substring(input frame {&frame-name} c-hora-ini,3,2))
               c-hora1    = substring(input frame {&frame-name} c-hora-ret,1,2)
               de-minuto1 = dec(substring(input frame {&frame-name} c-hora-ret,3,2)).
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        if  LOOKUP (cb-tp-relogio:SCREEN-VALUE,cb-tp-relogio:LIST-ITEM-PAIRS) = 1 then DO:
        &else
        if  LOOKUP (cb-tp-relogio:SCREEN-VALUE,cb-tp-relogio:LIST-ITEMS) = 1 then DO:
        &endif
            assign de-minuto     = de-minuto * 60 / 100
                   de-tempo      = dec(c-hora) + (de-minuto / 100)
                   de-minuto1    = de-minuto1 * 60 / 100
                   de-tempo1     = dec(c-hora1) + (de-minuto1 / 100).
        END.
        ELSE DO:
            assign de-minuto     = de-minuto * 100 / 60
                   de-tempo      = dec(c-hora) + (de-minuto / 100)
                   de-minuto1    = de-minuto1 * 100 / 60
                   de-tempo1     = dec(c-hora1) + (de-minuto1 / 100).
        END.

        {cdp/cd9998.i}
        assign i-valor   = truncate(de-tempo,0)
               de-valor  = (de-tempo - i-valor) * 100
               c-tempo   = string(i-valor,"99") + string(de-valor,"99")
               i-valor1  = truncate(de-tempo1,0)
               de-valor1 = (de-tempo1 - i-valor1) * 100
               c-tempo1  = string(i-valor1,"99") + string(de-valor1,"99").

        disp c-tempo  @ c-hora-ini with frame {&frame-name}.
        disp c-tempo1 @ c-hora-ret with frame {&frame-name}.
        assign c-combo = input frame {&frame-name} cb-tp-relogio.
    end.
    apply "entry" to tempo-para in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-data-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-data-parada V-table-Win
ON LEAVE OF da-data-parada IN FRAME f-main
DO:

  apply "entry" to tempo-para in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-data-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-data-retorno V-table-Win
ON LEAVE OF da-data-retorno IN FRAME f-main
DO:
    apply "entry" to tempo-para in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.dt-fecham
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.dt-fecham V-table-Win
ON LEAVE OF ord-manut.dt-fecham IN FRAME f-main /* Data T‚rmino */
DO:
  FIND CURRENT ord-manut EXCLUSIVE-LOCK NO-ERROR.
      IF ord-manut.estado = 5 AND ord-manut.om-encerrada = YES THEN DO:
          ASSIGN ord-manut.om-encerrada = NO
                 ord-manut.estado-om = 2.
      END.
  FIND CURRENT ord-manut NO-LOCK NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tempo-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tempo-para V-table-Win
ON ENTRY OF tempo-para IN FRAME f-main /* Tempo Parada */
DO:
    DEFINE VARIABLE hr-min-temporario AS CHAR    NO-UNDO.
    assign hr-hora-ini = 0
           hr-hora-fim = 0.
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      if  LOOKUP (cb-tp-relogio:SCREEN-VALUE,cb-tp-relogio:LIST-ITEM-PAIRS) = 1 then DO: /* horario */        
    &else
      if  LOOKUP (cb-tp-relogio:SCREEN-VALUE,cb-tp-relogio:LIST-ITEMS) = 1 then DO: /* horario */
    &endif

        if  substring(input frame {&frame-name} c-hora-ini,1,2) <> ""
            and substring(input frame {&frame-name} c-hora-ini,3,2) <> "" then
                assign hr-hora-ini = ((int(substring(input frame {&frame-name} c-hora-ini,1,2)) * 60) +
                                      (int(substring(input frame {&frame-name} c-hora-ini,3,2)))) / 60.
            if  substring(input frame {&frame-name} c-hora-ret,1,2) <> ""
            and substring(input frame {&frame-name} c-hora-ret,3,2) <> "" then
                assign hr-hora-fim = ((int(substring(input frame {&frame-name} c-hora-ret,1,2)) * 60) +
                                      (int(substring(input frame {&frame-name} c-hora-ret,3,2)))) / 60.
            if  (input frame {&frame-name} da-data-parada)  <> ? or 
                (input frame {&frame-name} da-data-retorno) <> ? then do:
                assign i-tot-hora = dec((input frame {&frame-name} da-data-retorno) - 
                                        (input frame {&frame-name} da-data-parada)).
                if  i-tot-hora = 0 then do:
                    assign i-tot-hora = hr-hora-fim - hr-hora-ini.
                end.    
                else do:
                    assign i-tot-hora = i-tot-hora * 24.
                    if  hr-hora-fim < hr-hora-ini then
                         assign i-tot-hora = i-tot-hora - (hr-hora-ini - hr-hora-fim).
                    else assign i-tot-hora = i-tot-hora + (hr-hora-fim - hr-hora-ini).
                end.
            end.
            else do:
               assign i-tot-hora = hr-hora-fim - hr-hora-ini.
            end.    

            disp i-tot-hora @ tempo-para
                 with frame {&frame-name}.
      END.
      else do:
          ASSIGN hr-hora-ini = 0
                 hr-hora-fim = 0.

            
          ASSIGN hr-hora = int(substring(input frame {&frame-name} c-hora-ini,1,2))
                 hr-min  = int(substring(input frame {&frame-name} c-hora-ini,3,2))
                 hr-hora-ini = DEC(STRING(hr-hora) + "," + STRING(hr-min,"99")).

          ASSIGN hr-hora = (int(substring(input frame {&frame-name} c-hora-ret,1,2)))
                 hr-min  = (int(substring(input frame {&frame-name} c-hora-ret,3,2)))
                 hr-hora-fim = DEC(STRING(hr-hora) + "," + STRING(hr-min,"99")).

          ASSIGN c-tot-hora = STRING((hr-hora-fim - hr-hora-ini),"->9.99") NO-ERROR.

            if  (input frame {&frame-name} da-data-parada)  <> ? or 
                (input frame {&frame-name} da-data-retorno) <> ? then do:
                assign i-tot-hora = dec((input frame {&frame-name} da-data-retorno) - 
                                        (input frame {&frame-name} da-data-parada)).
                if  i-tot-hora <> 0 then do:
                    assign i-tot-hora = i-tot-hora * 24.
                    assign i-tot-hora = i-tot-hora + (DEC(c-tot-hora)).
                    disp i-tot-hora @ tempo-para
                         with frame {&frame-name}.
                end.
                ELSE
                   disp c-tot-hora @ tempo-para
                        with frame {&frame-name}.
            end.
            ELSE
               disp c-tot-hora @ tempo-para
                    with frame {&frame-name}.
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

  /************************ INTERNAL PROCEDURES ********************/
 {utp/ut-liter.i Tipo_de_Rel¢gio * r} 
 assign cb-tp-relogio:label in frame {&frame-name} = trim(return-value).
 {utp/ut-liter.i Hora * r}
 assign c-hora-ini:label in frame {&frame-name} = trim(return-value)
        c-hora-ret:label in frame {&frame-name} = trim(return-value).
 {utp/ut-liter.i Data_Parada * r}
 assign da-data-parada:label in frame {&frame-name} = trim(return-value).
 {utp/ut-liter.i Data_Retorno * r}
 assign da-data-retorno:label in frame {&frame-name} = trim(return-value).
 {utp/ut-field.i mgind ord-manut tempo-para 1}
 assign tempo-para:label = return-value.


 /************************ MODULO PREDITIVA ********************/
 &IF DEFINED (bf_mnt_ems204) &THEN
 ASSIGN l-ems204 = YES.
 &ENDIF

 IF l-ems204 THEN DO:
 /*cosulta em parametros globais se o modulo MI PREDITIVA esta disponivel*/
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN DO:
        &IF DEFINED (bf_mnt_ems206b) &THEN
            ASSIGN l-log-modul-predit = param-global.log-modul-predit.
        &else
            assign l-log-modul-predit = if substring(param-global.char-2,25,1) = "y":U then yes else no.
        &ENDIF         
    END.
    {utp/ut-liter.i Estado_Preditiva *}
    cb-estado-preditiva:LABEL IN FRAME {&frame-name}= TRIM(RETURN-VALUE). 
 END.
 ELSE
     ASSIGN cb-estado-preditiva:HIDDEN IN FRAME {&frame-name} = NO.

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

  /* No Foreign keys are accepted by this SmartObject. */

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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}                         

    /* Ponha na pi-validate todas as valida»„es */
    /* N’o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */    

    find first param-mi   no-lock no-error.
    if avail param-mi then
    find item where item.it-codigo = param-mi.it-codigo no-lock no-error.
    &if defined (bf_mnt_ems203) &then
    find first param-mnt no-lock no-error.
    &else
    find ord-prod where 
         ord-prod.nr-ord-produ = ord-manut.nr-ord-produ no-lock no-error.
    &endif
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

    /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
    assign ord-manut.tempo-para = decimal(tempo-para:screen-value in frame {&frame-name}). 

    for each ord-taref
        where ord-taref.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock:
        for each ord-esp where 
            ord-esp.nr-ord-produ = ord-taref.nr-ord-produ and   
            ord-esp.cd-tarefa    = ord-taref.cd-tarefa exclusive-lock:
            assign ord-esp.encerrada = yes
                   ord-esp.conclusao = 100.
            if  param-global.modulo-pi = yes then
                run mip/mi9100.p (ord-manut.nr-ord-produ,
                                  ord-esp.cd-tarefa,
                                  ord-esp.tp-especial). 
        end.
        assign ord-taref.encerrada = yes.
    end.
    assign hr-hora-ini = 0
           hr-hora-fim = 0.
    if  input frame {&frame-name} c-hora-ini <> "" then
        if  substring(input frame {&frame-name} c-hora-ini,1,2) <> ""
        and substring(input frame {&frame-name} c-hora-ini,3,2) <> "" then
            assign hr-hora-ini = ((int(substring(input frame {&frame-name} c-hora-ini,1,2)) * 60) +
                                  (int(substring(input frame {&frame-name} c-hora-ini,3,2)))) / 60.
    if  input frame {&frame-name} c-hora-ret <> "" then
        if  substring(input frame {&frame-name} c-hora-ret,1,2) <> ""
        and substring(input frame {&frame-name} c-hora-ret,3,2) <> "" then
            assign hr-hora-fim = ((int(substring(input frame {&frame-name} c-hora-ret,1,2)) * 60) +
                                  (int(substring(input frame {&frame-name} c-hora-ret,3,2)))) / 60.
    if  da-data-parada <> ?
    or  da-data-retorno <> ? then do:
        assign i-tot-hora = (input frame {&frame-name} da-data-parada) - 
                            (input frame {&frame-name} da-data-retorno). 
        if  i-tot-hora = 0 then
            assign i-tot-hora = hr-hora-fim - hr-hora-ini.
        else do:
            assign i-tot-hora = i-tot-hora * 24.
            if  hr-hora-fim < hr-hora-ini then
                assign i-tot-hora = i-tot-hora - (hr-hora-ini - hr-hora-fim).
            else
                assign i-tot-hora = i-tot-hora + (hr-hora-fim - hr-hora-ini).
        end.
    end.
    else
        assign i-tot-hora = hr-hora-fim - hr-hora-ini.

    for each reservas
        where reservas.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock:

        run cdp/cd7000.p (0,
                          reservas.it-codigo,
                          "").

        if not valid-handle (h-cpapi013) then
            run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
                                                          input        table tt-deposito,
                                                          input-output table tt-erro,
                                                          input        yes).
        run pi-desaloca-reserva in h-cpapi013 (input rowid(reservas)).
        assign reservas.estado = 2.

    end.

    /*Logica para GRAVA°€O dos valores nos campos Data Parada, Hora, Data Retorno e Hora*/
    &if "{&bf_mnt_ems206}" = "Yes" &then
          /*LOGICA PARA A RELEASE 206*/
        IF param-mi.tp-relogio = 1 OR cb-tp-relogio:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i01in289.i 04 1} 
        THEN DO:                   /*relogio horario*/
            ASSIGN ord-manut.dt-parada  = date(da-data-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.dt-retorno = date(da-data-retorno:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.hr-parada = (INT(SUBSTRING(c-hora-ini:SCREEN-VALUE IN FRAME {&frame-name},1,2)) + 
                                         (INT(SUBSTRING(c-hora-ini:SCREEN-VALUE IN FRAME {&frame-name},4,2)) / 60)) * 100
                   ord-manut.hr-retorno = (INT(SUBSTRING(c-hora-ret:SCREEN-VALUE IN FRAME {&frame-name},1,2)) + 
                                          (INT(SUBSTRING(c-hora-ret:SCREEN-VALUE IN FRAME {&FRAME-NAME},4,2)) / 60)) * 100.
        END.
        ELSE DO:                   /*relogio decimal*/
            ASSIGN ord-manut.dt-parada  = date(da-data-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.dt-retorno = date(da-data-retorno:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.hr-parada  = DEC(c-hora-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}) * 100
                   ord-manut.hr-retorno = DEC(c-hora-ret:SCREEN-VALUE IN FRAME {&FRAME-NAME}) * 100.
        END.
    &ELSEIF "{&bf_mnt_ems204}" = "Yes" &then
        /*LOGICA PARA A 204*/
        IF cb-tp-relogio:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i01in289.i 04 1}
        THEN                /*rel½gio horÿrio*/
            ASSIGN ord-manut.data-1 = date(da-data-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.data-2 = date(da-data-retorno:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.INT-1 = (INT(SUBSTRING(c-hora-ini:SCREEN-VALUE IN FRAME {&frame-name},1,2)) + 
                                      (INT(SUBSTRING(c-hora-ini:SCREEN-VALUE IN FRAME {&frame-name},4,2)) / 60)) * 100
                   ord-manut.INT-2 = (INT(SUBSTRING(c-hora-ret:SCREEN-VALUE IN FRAME {&frame-name},1,2)) + 
                                      (INT(SUBSTRING(c-hora-ret:SCREEN-VALUE IN FRAME {&frame-name},4,2)) / 60)) * 100.
        ELSE                  /*relogio decimal*/
            ASSIGN ord-manut.data-1 = date(da-data-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.data-2 = date(da-data-retorno:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   ord-manut.int-1  = DEC(c-hora-ini:SCREEN-VALUE IN FRAME {&frame-name}) * 100
                   ord-manut.int-2  = DEC(c-hora-ret:SCREEN-VALUE IN FRAME {&frame-name}) * 100.



      &ENDIF 


   /* Code placed here will execute AFTER standard behavior.    */


/***************************************Calibracao ***************/

    &if defined (bf_mnt_calib) &then
        IF &IF DEFINED (bf_mnt_ems205) &THEN
              param-global.log-modul-calib 
           &else
              substr(param-global.char-2,100,1) = "2" 
           &endif
            
            &IF DEFINED (bf_mnt_ems208) &THEN
                                AND ord-manut.tp-manut = 3
            &else
                                AND ord-manut.dec-1 =  3
            &endif
            THEN DO:
            
            for each tt-erro:
                delete tt-erro.
            end.
            for each tt-apont-calib:
                delete tt-apont-calib.
            end.
            create tt-apont-calib.
            assign tt-apont-calib.nr-ord-produ = ord-manut.nr-ord-produ
                   tt-apont-calib.cd-equipto   = ord-manut.cd-equipto
                   tt-apont-calib.acao         = 6 /* encerra */
                   tt-apont-calib.cod-versao-integracao = 001.
            RUN gcp/gcapi002.p(input table tt-apont-calib,
                               input        table tt-ord-gerada,
                               input-output table tt-erro,
                               input  NO ) .
            FIND FIRST tt-erro NO-ERROR.
            if AVAIL tt-erro then do:
                run cdp/cd0666.w (input table tt-erro).
                return 'ADM-ERROR':U.
            END.
        END.
    &endif

/******************************************* PREDITIVA ************************************************/

/***************** grava na a ord-manut o valor do combo-box Estado Preditiva **********************************/
    &IF DEFINED (bf_mnt_ems204) &THEN
    IF l-log-modul-predit THEN DO:
        ASSIGN i-estado-pred = LOOKUP(cb-estado-preditiva:SCREEN-VALUE IN FRAME {&frame-name},{ininc/i12in271.i 03}). 

        &IF DEFINED(bf_mnt_ems206b) &THEN
            ASSIGN ord-manut.estado-pred = i-estado-pred.
        &ELSEIF DEFINED(bf_mnt_ems204) &then
            ASSIGN OVERLAY(ord-manut.char-1,17,2) = STRING(i-estado-pred,"99").
        &ENDIF   
    END.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if valid-handle (h-cpapi013) then
    run pi-finalizar in h-cpapi013.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

    ASSIGN cb-estado-preditiva:SENSITIVE IN FRAME f-main = FALSE.

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
        
    if  available ord-manut then do:
        find equipto
            where equipto.cd-equipto = ord-manut.cd-equipto
            no-lock no-error.
        if avail equipto then 
           assign c-descr-equipto = equipto.descricao
                  gr-equipto      = rowid(equipto).
        else 
           assign c-descr-equipto = "":U.

        find manut
            where manut.cd-manut = ord-manut.cd-manut
            no-lock no-error.
        if avail manut then
           assign c-descr-manut = manut.descricao
                  gr-manut      = rowid(manut).
        else
           assign c-descr-manut = "":U.

        find tipo-manut
            where tipo-manut.cd-tipo =  ord-manut.cd-tipo
            no-lock no-error.
        if avail tipo-manut then
           assign c-descr-tipo-manut = tipo-manut.descricao
                  gr-tipo-manut      = rowid(tipo-manut).
        else
           assign c-descr-tipo-manut =  "":U.

        find tag
            where tag.cd-tag = ord-manut.cd-tag
            no-lock no-error.
        if avail tag then
           assign c-descr-tag = tag.descricao
                  gr-tag      = rowid(tag).
        else 
           assign c-descr-tag = "":U.

        find mi-parada
           where mi-parada.cd-parada = ord-manut.cd-parada
           no-lock no-error.
        if avail mi-parada then 
           assign c-descr-parada = mi-parada.descricao
                  gr-mi-parada   = rowid(mi-parada).
        else
           assign c-descr-parada = "":U.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
        
        /** Codigo nao deve continuar caso record is not available **/
        if not avail ord-manut then return.
        
    assign tempo-para:screen-value in frame {&frame-name} = string(ord-manut.tempo-para).
    find first param-mi
        no-lock no-error.
    if  avail param-mi then do:
        if param-mi.formato-cd-equipto <> " " then
           assign ord-manut.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.

        if  param-mi.formato-cd-tag <> " " then
            assign ord-manut.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
    end.

    /* Code placed here will execute AFTER standard behavior.    */

    /*Logica para exibi»’o dos valores nos campos Data Parada, Hora, Data Retorno e Hora*/
    &if "{&bf_mnt_ems206}" = "Yes" &then
        /*LOGICA PARA A RELEASE 206*/
        ASSIGN da-data-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = string(ord-manut.dt-parada)                                               
               da-data-retorno:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(ord-manut.dt-retorno).   
        IF param-mi.tp-relogio = 1 OR cb-tp-relogio:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i01in289.i 04 1} 
        THEN DO:               /*rel½gio horÿrio*/ 
            ASSIGN c-hora-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                         string(truncate((ord-manut.hr-parada / 100),0),"99") + 
                         STRING(INT((ord-manut.hr-parada / 100 - truncate((ord-manut.hr-parada / 100),0)) * 60),"99")
                  c-hora-ret:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                         string(truncate((ord-manut.hr-retorno / 100),0),"99") + 
                         STRING(INT((ord-manut.hr-retorno / 100 - truncate((ord-manut.hr-retorno / 100),0)) * 60),"99").
        END.
        ELSE DO:                   /*relogio decimal*/
            ASSIGN c-hora-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(ord-manut.hr-parada,"9999")
                   c-hora-ret:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ord-manut.hr-retorno,"9999").
        END.
    &ELSEIF "{&bf_mnt_ems204}" = "Yes" &then
            /*LOGICA PARA A 204*/
            ASSIGN da-data-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = string(ord-manut.data-1)                                               
                   da-data-retorno:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(ord-manut.data-2).   
            IF param-mi.tp-relogio = 1 OR cb-tp-relogio:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i01in289.i 04 1} 
            THEN DO:               /*rel½gio horÿrio*/ 
                ASSIGN c-hora-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                             string(truncate((ord-manut.INT-1 / 100),0),"99") + 
                             STRING(INT((ord-manut.INT-1 / 100 - truncate((ord-manut.INT-1 / 100),0)) * 60),"99")
                      c-hora-ret:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                             string(truncate((ord-manut.int-2 / 100),0),"99") + 
                             STRING(INT((ord-manut.int-2 / 100 - truncate((ord-manut.int-2 / 100),0)) * 60),"99").
            END.
            ELSE DO:                   /*relogio decimal*/
                ASSIGN c-hora-ini:SCREEN-VALUE IN FRAME {&frame-name} = string(ord-manut.INT-1,"9999")
                       c-hora-ret:SCREEN-VALUE IN FRAME {&frame-name} = STRING(ord-manut.int-2,"9999").
            END.
    &endif     /*206*/

    &IF DEFINED (bf_mnt_ems204) &THEN
    IF l-log-modul-predit THEN DO:
        &IF DEFINED(bf_mnt_ems206b) &THEN        
        ASSIGN i-estado-pred = IF ord-manut.estado-pred < 1 THEN 1 ELSE ord-manut.estado-pred.
        &ELSEIF DEFINED(bf_mnt_ems204) &then                
        ASSIGN i-estado-pred = IF int(substring(ord-manut.char-1,17,2)) < 1 THEN 1 ELSE int(substring(ord-manut.char-1,17,2)).
        &ENDIF   
        ASSIGN cb-estado-preditiva:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i12in271.i 04 i-estado-pred}.
    END.
    &endif

    IF l-log-modul-predit = YES THEN DO:
        FIND tipo-manut WHERE tipo-manut.cd-tipo = Ord-Manut.cd-tipo NO-LOCK NO-ERROR.
        IF AVAIL tipo-manut THEN 
            IF tipo-manut.tp-manut = 2 THEN
                ASSIGN cb-estado-preditiva:HIDDEN = FALSE. 
            ELSE
                ASSIGN cb-estado-preditiva:HIDDEN = TRUE.
        ELSE  
            ASSIGN  cb-estado-preditiva:HIDDEN = TRUE.
    END. 
    ELSE
        ASSIGN cb-estado-preditiva:HIDDEN = TRUE.

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

    IF AVAIL ord-manut AND 
        ord-manut.estado-om = 3 THEN DO:
        run utp/ut-msgs.p(input "show",
                          input 8877,
                          input "").
        return "ADM-ERROR":U.
    END.

    run get-attribute ('adm-new-record').
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
         enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    IF l-log-modul-predit = YES THEN DO:
        FIND tipo-manut WHERE tipo-manut.cd-tipo = Ord-Manut.cd-tipo NO-LOCK NO-ERROR.
        IF AVAIL tipo-manut THEN 
            IF tipo-manut.tp-manut = 2 THEN
                ASSIGN cb-estado-preditiva:HIDDEN    = FALSE
                       cb-estado-preditiva:SENSITIVE = TRUE.
            ELSE
                ASSIGN cb-estado-preditiva:HIDDEN = TRUE.
        ELSE  
            ASSIGN  cb-estado-preditiva:HIDDEN = TRUE.
    END. 


    if avail ord-manut then
       assign ord-manut.dt-fecham:screen-value in frame {&frame-name} = string(ord-manut.dt-prev).

    &if defined (bf_mnt_ems203) &then
       /*Polibrasil - FO830.243/  FO830.243*/
        if can-find(first funcao
                   where funcao.cd-funcao = "spp-midtfech":U
                     and funcao.ativo     = yes no-lock) and 
          avail ord-manut then
          assign ord-manut.dt-fecham:screen-value in frame {&frame-name} = string(today).
    &endif

    apply "entry":U to ord-manut.dt-fecham in frame {&frame-name}.


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
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
       ASSIGN c-lista = {ininc/i01in289.i 04 1}.
       ASSIGN c-lista = c-lista + "," + {ininc/i01in289.i 04 3}.
       run utp/ut-lstit.p (input-output c-lista).
       ASSIGN cb-tp-relogio:LIST-ITEM-PAIRS IN FRAME {&frame-name} = c-lista.
   &else
       cb-tp-relogio:add-last({ininc/i01in289.i 04 1}) in frame {&frame-name}. /*carrega o combo*/
       cb-tp-relogio:add-last({ininc/i01in289.i 04 3}) in frame {&frame-name}.
   &endif

   /*Carrega o combo Estado Preditiva*/
    &IF DEFINED (bf_mnt_ems204) &THEN
       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao002 = {ininc/i12in271.i 03}.
           RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
           ASSIGN cb-estado-preditiva:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cAuxTraducao002.
       &else
           ASSIGN cb-estado-preditiva:LIST-ITEMS IN FRAME {&frame-name} = {ininc/i12in271.i 03}.
       &endif
    &endif

   find first param-mi no-lock no-error.
   if  avail param-mi then
       if param-mi.tp-relogio = 1 
       or  param-mi.tp-relogio = 3 then do:
           assign c-hora-ini:screen-value in frame {&frame-name}  = "0000"
                  c-hora-ret:screen-value in frame {&frame-name}  = "0000"
                  cb-tp-relogio:screen-value in frame {&frame-name} = {ininc/i01in289.i 04 param-mi.tp-relogio}
           .
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
               DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
               ASSIGN cAuxTraducao001 = {ininc/i01in289.i 04 param-mi.tp-relogio}.
               run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                   INPUT "",
                                   INPUT "").
               ASSIGN c-combo                                           = RETURN-VALUE.
           &else
               ASSIGN c-combo                                           = {ininc/i01in289.i 04 param-mi.tp-relogio}.
           &endif
           if  param-mi.tp-relogio = 1 then
               assign c-hora-ini:format in frame {&frame-name} = c-formato-1
                      c-hora-ret:format in frame {&frame-name} = c-formato-1.
           else
             assign c-hora-ini:format in frame {&frame-name} = c-formato-2
                    c-hora-ret:format in frame {&frame-name} = c-formato-2.
       end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.
------------------------------------------------------------------------------*/

    run notify('pi-recebe-valor, group-assign-source').


    find first param-global
        no-lock no-error.

    {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */

    IF CAN-FIND (FIRST movto-ggf WHERE
                       movto-ggf.nr-ord-produ = ord-manut.nr-ord-produ AND
                       movto-ggf.dt-trans > date(ord-manut.dt-fecham:SCREEN-VALUE in frame {&frame-name})) 
        THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 28555,
                          input "").

        if RETURN-VALUE = "no" then do:
           apply "entry" to ord-manut.dt-fecham in frame {&frame-name}.
           return "ADM-ERROR":U.
        END.
    END.

    IF CAN-FIND (FIRST movto-mat WHERE
                       movto-mat.nr-ord-produ = ord-manut.nr-ord-produ AND
                       movto-mat.dt-trans > date(ord-manut.dt-fecham:SCREEN-VALUE in frame {&frame-name})) 
        THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 28555,
                          input "").

        if RETURN-VALUE = "no" then do:
           apply "entry" to ord-manut.dt-fecham in frame {&frame-name}.
           return "ADM-ERROR":U.
        END.
    END.


    if date(ord-manut.dt-fecham:SCREEN-VALUE in frame {&frame-name}) > today then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                          input 27297,
                          input ""). 
         if RETURN-VALUE = "no" then do:

         APPLY "entry" TO ord-manut.dt-fecham IN FRAME {&frame-name}.
         return "ADM-ERROR":U.
         end.
    end.

    if  input frame {&frame-name} ord-manut.dt-fecham = ? then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 1090,
                          input "").
        apply "entry" to ord-manut.dt-fecham in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.

    FIND FIRST equipto WHERE equipto.cd-equipto = ord-manut.cd-equipto NO-LOCK NO-ERROR.
    IF AVAIL equipto THEN DO:
        if date(ord-manut.dt-fecham:SCREEN-VALUE in frame {&frame-name}) < equipto.data-ativa then do:
           {include/i-vldprg.i}
           {utp/ut-field.i mgmnt equipto data-ativa 1}
           assign c-liter1 = trim(return-value).
           {utp/ut-field.i movmnt ord-manut dt-fecham 1}
           assign c-liter2 = trim(return-value).
           run utp/ut-msgs.p(input "show",
                             input 7017,
                             input c-liter2 + "~~" + c-liter1).
           APPLY "entry" TO ord-manut.dt-fecham IN FRAME {&frame-name}.
           return "ADM-ERROR":U.
        end.
    END.

   /* if  param-global.modulo-ce then do:
        find first param-estoq
            no-lock no-error.
        if  avail param-estoq
        and input frame {&frame-name} ord-manut.dt-fecham <= param-estoq.mensal-ate then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p(input "show",
                              input 1586,
                              input "").
            apply "entry" to ord-manut.dt-fecham in frame {&frame-name}.
            return "ADM-ERROR":U.
        end.
    end. */

    /*find first movto-mat
 *         where movto-mat.nr-ord-produ = ord-manut.nr-ord-produ
 *         and   movto-mat.dt-trans     > input frame {&frame-name} ord-manut.dt-fecham
 *         no-lock no-error.
 *     find first movto-ggf
 *         where movto-ggf.nr-ord-produ = ord-manut.nr-ord-produ
 *         and   movto-ggf.dt-trans     > input frame {&frame-name} ord-manut.dt-fecham
 *         no-lock no-error.
 *     if  avail movto-mat
 *     or  avail movto-ggf then do:
 *         {include/i-vldprg.i}
 *         run utp/ut-msgs.p(input "show",
 *                           input 6191,
 *                           input "").
 *         return "ADM-ERROR":U.
 *     end.*/

    /*alterado FO*/
    if  input frame {&frame-name} da-data-parada < ord-manut.dt-manut
    and input frame {&frame-name} da-data-parada > ord-manut.dt-fecham then do:
        {utp/ut-liter.i Data_de_Parada * r}
        assign c-label-1 = trim(return-value).
        {utp/ut-liter.i data_de_abertura * r}
        assign c-label-2 = trim(return-value).
        {utp/ut-liter.i data_de_fechamento * r}
        assign c-label-3 = trim(return-value).
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 3662,
                          input c-label-1 + "~~" + c-label-2 + "~~" + c-label-3).
        apply "entry" to da-data-parada in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.
    /*alterado FO*/
    if  input frame {&frame-name} da-data-retorno > ord-manut.dt-fecham
    and input frame {&frame-name} da-data-retorno < ord-manut.dt-manut then do:
        {utp/ut-liter.i Data_de_Retorno * r}
        assign c-label-1 = trim(return-value).
        {utp/ut-liter.i data_de_abertura * r}
        assign c-label-2 = trim(return-value).
        {utp/ut-liter.i data_de_fechamento * r}
        assign c-label-3 = trim(return-value).
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 3662,
                          input c-label-1 + "~~" + c-label-2 + "~~" + c-label-3).
        apply "entry" to da-data-retorno in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.
    if  input frame {&frame-name} da-data-retorno < input frame {&frame-name} da-data-parada then do:
        {include/i-vldprg.i}
        assign da-data-retorno = input frame {&frame-name} da-data-retorno
               da-data-parada  = input frame {&frame-name} da-data-parada.
        run utp/ut-msgs.p(input "show",
                          input 89,
                          input string(da-data-retorno,"99/99/9999") + "~~" +
                                string(da-data-parada,"99/99/9999")).
        apply "entry" to da-data-retorno in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.

    FIND FIRST equipto WHERE equipto.cd-equipto = ord-manut.cd-equipto NO-LOCK NO-ERROR.
    IF AVAIL equipto THEN DO:
        if input frame {&frame-name} da-data-parada < equipto.data-ativa then do:
           {include/i-vldprg.i}
           {utp/ut-field.i mgmnt equipto data-ativa 1}
           assign c-liter1 = trim(return-value).
           {utp/ut-liter.i Data_de_Parada * r}
           assign c-liter2 = trim(return-value).
           run utp/ut-msgs.p(input "show",
                             input 7017,
                             input c-liter2 + "~~" + c-liter1).
           APPLY "entry" TO da-data-parada IN FRAME {&frame-name}.
           return "ADM-ERROR":U.
        end.
    END.

    FIND FIRST equipto WHERE equipto.cd-equipto = ord-manut.cd-equipto NO-LOCK NO-ERROR.
    IF AVAIL equipto THEN DO:
        if input frame {&frame-name} da-data-retorno < equipto.data-ativa then do:
           {include/i-vldprg.i}
           {utp/ut-field.i mgmnt equipto data-ativa 1}
           assign c-liter1 = trim(return-value).
           {utp/ut-liter.i Data_de_Retorno * r}
           assign c-liter2 = trim(return-value).
           run utp/ut-msgs.p(input "show",
                             input 7017,
                             input c-liter2 + "~~" + c-liter1).
           APPLY "entry" TO da-data-retorno IN FRAME {&frame-name}.
           return "ADM-ERROR":U.
        end.
    END.

    if input frame {&frame-name} tempo-para < 0 or input frame {&frame-name} tempo-para = ? then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 27555,
                          input "").        
        apply "entry" to tempo-para in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.

    if input frame {&frame-name} tempo-para > 0
    AND (   input frame {&frame-name} da-data-retorno = ?
         OR input frame {&frame-name} da-data-parada = ?)
    then do:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-tempo_invalido AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tempo_Inválido"  *}
        ASSIGN c-tempo_invalido = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "O_tempo_de_parada_do_equipamento_nÆo_condiz_com_a_data_de_parada_e_data_de_retorno._Avaliar_as_datas_informadas." *}
        ASSIGN c-tempo_invalido = c-tempo_invalido + '~~' + TRIM(RETURN-VALUE).

run utp/ut-msgs.p(input "show",
                  input 17006,
                  input c-tempo_invalido).

        APPLY "entry" TO da-data-parada IN FRAME {&frame-name}.
        return "ADM-ERROR":U.
    end.

    if  input frame {&frame-name} da-data-retorno < input frame {&frame-name} da-data-parada then do:
        {include/i-vldprg.i}
        assign da-data-retorno = input frame {&frame-name} da-data-retorno
               da-data-parada  = input frame {&frame-name} da-data-parada.
        run utp/ut-msgs.p(input "show",
                          input 89,
                          input string(da-data-retorno,"99/99/9999") + "~~" +
                                string(da-data-parada,"99/99/9999")).
        apply "entry" to da-data-retorno in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.
    if  input frame {&frame-name} da-data-retorno = input frame {&frame-name} da-data-parada AND
        input frame {&frame-name} c-hora-ini > input frame {&frame-name} c-hora-ret THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 57003,
                          input "").        
        apply "entry" to c-hora-ini in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.

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
  {src/adm/template/sndkycas.i "al-codigo" "ord-manut" "al-codigo"}
  {src/adm/template/sndkycas.i "cd-causa-padr" "ord-manut" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "ord-manut" "cd-equipto"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "ord-manut" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "cd-inspecao" "ord-manut" "cd-inspecao"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "ord-manut" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "ord-manut" "cd-manut"}
  {src/adm/template/sndkycas.i "sequencia" "ord-manut" "sequencia"}
  {src/adm/template/sndkycas.i "cd-parada" "ord-manut" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-tag" "ord-manut" "cd-tag"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "ord-manut" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-planejado" "ord-manut" "cd-planejado"}
  {src/adm/template/sndkycas.i "cd-projeto" "ord-manut" "cd-projeto"}
  {src/adm/template/sndkycas.i "nr-rot-insp" "ord-manut" "nr-rot-insp"}
  {src/adm/template/sndkycas.i "nr-rot-lubr" "ord-manut" "nr-rot-lubr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "ord-manut" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "ord-manut" "cd-tipo"}

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
  {src/adm/template/snd-list.i "ord-manut"}

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

