&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V32IN271 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V32IN271 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-alterada as logical no-undo init no.

{cep/ce1234.i} /*** Defini»’o TTs e Variÿveis - Valida»’o Decimais ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS de-vl-ggf-orc11 de-vl-ggf-orc21 ~
de-vl-ggf-orc31 de-vl-ggf-orc12 de-vl-ggf-orc22 de-vl-ggf-orc32 ~
de-vl-ggf-orc13 de-vl-ggf-orc23 de-vl-ggf-orc33 de-vl-ggf-orc14 ~
de-vl-ggf-orc24 de-vl-ggf-orc34 de-vl-ggf-orc15 de-vl-ggf-orc25 ~
de-vl-ggf-orc35 de-vl-ggf-orc16 de-vl-ggf-orc26 de-vl-ggf-orc36 c-texto1 ~
c-moeda1 c-moeda2 c-moeda3 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS de-vl-ggf-orc11 de-vl-ggf-orc21 ~
de-vl-ggf-orc31 

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
DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .63 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc11 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc12 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc13 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc14 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc15 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc16 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc21 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc22 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc23 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc24 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc25 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc26 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc31 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc32 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc33 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc34 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc35 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-orc36 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.43 BY 8.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-vl-ggf-orc11 AT ROW 2.25 COL 18 COLON-ALIGNED
     de-vl-ggf-orc21 AT ROW 2.25 COL 40 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc31 AT ROW 2.25 COL 62 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc12 AT ROW 3.5 COL 18 COLON-ALIGNED
     de-vl-ggf-orc22 AT ROW 3.5 COL 40 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc32 AT ROW 3.5 COL 62 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc13 AT ROW 4.75 COL 18 COLON-ALIGNED
     de-vl-ggf-orc23 AT ROW 4.75 COL 40 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc33 AT ROW 4.75 COL 62 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc14 AT ROW 6 COL 18 COLON-ALIGNED
     de-vl-ggf-orc24 AT ROW 6 COL 40 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc34 AT ROW 6 COL 62 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc15 AT ROW 7.25 COL 18 COLON-ALIGNED
     de-vl-ggf-orc25 AT ROW 7.25 COL 40 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc35 AT ROW 7.25 COL 62 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc16 AT ROW 8.5 COL 18 COLON-ALIGNED
     de-vl-ggf-orc26 AT ROW 8.5 COL 40 COLON-ALIGNED NO-LABEL
     de-vl-ggf-orc36 AT ROW 8.5 COL 62 COLON-ALIGNED NO-LABEL
     c-texto1 AT ROW 1.08 COL 2.43 NO-LABEL
     c-moeda1 AT ROW 1.5 COL 18 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 1.5 COL 40 COLON-ALIGNED NO-LABEL
     c-moeda3 AT ROW 1.5 COL 62 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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
         HEIGHT             = 8.83
         WIDTH              = 84.43.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc11 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc13 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc14 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc15 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc16 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc21 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc22 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc23 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc24 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc25 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc26 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc31 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc32 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc33 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc34 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc35 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-orc36 IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

find first param-global no-lock.
find first param-cs no-lock.
find first param-estoq no-lock.


do with frame {&frame-name}:

  {utp/ut-liter.i GGF_Or‡ado * r}
  assign c-texto1 = trim(return-value).

  {utp/ut-liter.i Corrente * r}
  assign de-vl-ggf-orc11:label = param-cs.ocorrencia[1]
         de-vl-ggf-orc12:label = param-cs.ocorrencia[2]
         de-vl-ggf-orc13:label = param-cs.ocorrencia[3]
         de-vl-ggf-orc14:label = param-cs.ocorrencia[4]
         de-vl-ggf-orc15:label = param-cs.ocorrencia[5]
         de-vl-ggf-orc16:label = param-cs.ocorrencia[6]
         c-moeda1 = return-value.

  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then 
        assign c-moeda2 = moeda.descricao.
  end.   
  else do :
     assign de-vl-ggf-orc21:visible = no
            de-vl-ggf-orc22:visible = no 
            de-vl-ggf-orc23:visible = no
            de-vl-ggf-orc24:visible = no
            de-vl-ggf-orc25:visible = no
            de-vl-ggf-orc26:visible = no.
  end.

  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then 
        assign c-moeda3 = moeda.descricao.
  end.   
  else do :
     assign de-vl-ggf-orc31:visible = no
            de-vl-ggf-orc32:visible = no 
            de-vl-ggf-orc33:visible = no
            de-vl-ggf-orc34:visible = no
            de-vl-ggf-orc35:visible = no
            de-vl-ggf-orc36:visible = no.    
  end.

  disp c-texto1 c-moeda1 c-moeda2 c-moeda3.

end.

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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
  /* Dispatch standard ADM method.                             */

  /*** Tratamento e Valida»’o casas decimais ***/

  assign l-rejeita-dec = no
         de-vl-ggf-orc11:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc11, 0))
         de-vl-ggf-orc21:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc21, param-estoq.moeda1))
         de-vl-ggf-orc31:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc31, param-estoq.moeda2))
         de-vl-ggf-orc12:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc12, 0))
         de-vl-ggf-orc22:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc22, param-estoq.moeda1))
         de-vl-ggf-orc32:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc32, param-estoq.moeda2))
         de-vl-ggf-orc13:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc13, 0))
         de-vl-ggf-orc23:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc23, param-estoq.moeda1))
         de-vl-ggf-orc33:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name}
                                                               de-vl-ggf-orc33, param-estoq.moeda2))
         de-vl-ggf-orc14:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc14, 0))
         de-vl-ggf-orc24:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc24, param-estoq.moeda1))
         de-vl-ggf-orc34:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc34, param-estoq.moeda2))
         de-vl-ggf-orc15:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc15, 0))
         de-vl-ggf-orc25:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc25, param-estoq.moeda1))
         de-vl-ggf-orc35:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc35, param-estoq.moeda2))
         de-vl-ggf-orc16:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc16, 0))
         de-vl-ggf-orc26:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc26, param-estoq.moeda1))
         de-vl-ggf-orc36:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                               de-vl-ggf-orc36, param-estoq.moeda2)).                                                                                                                                                                                                                                                                          


  if  l-rejeita-dec then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 18100, 
                         input " ").
      return 'ADM-ERROR':U.        
  end.




  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  do with frame {&frame-name}:
  if (ord-prod.estado <> 8 or ord-prod.valorizada <> yes) or l-alterada then do:

    find first ext-ord
         where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
           and ext-ord.mo-codigo    = 0
           and ext-ord.op-seq       = 0 no-error.
    if not available(ext-ord) then do:
      create ext-ord.
      assign ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
             ext-ord.mo-codigo    = 0
             ext-ord.op-seq       = 0.
      VALIDATE ext-ord.
    end.

    assign ext-ord.vl-ggf-orc[1] = input de-vl-ggf-orc11
           ext-ord.vl-ggf-orc[2] = input de-vl-ggf-orc12
           ext-ord.vl-ggf-orc[3] = input de-vl-ggf-orc13
           ext-ord.vl-ggf-orc[4] = input de-vl-ggf-orc14
           ext-ord.vl-ggf-orc[5] = input de-vl-ggf-orc15
           ext-ord.vl-ggf-orc[6] = input de-vl-ggf-orc16.

    if param-estoq.tem-moeda1 then do:
      find first ext-ord
           where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
             and ext-ord.mo-codigo    = 1
             and ext-ord.op-seq       = 0 no-error.
      if not available(ext-ord) then do:
        create ext-ord.
        assign ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
               ext-ord.mo-codigo    = 1
               ext-ord.op-seq       = 0.
        VALIDATE ext-ord.
      end.

      assign ext-ord.vl-ggf-orc[1] = input de-vl-ggf-orc21
             ext-ord.vl-ggf-orc[2] = input de-vl-ggf-orc22
             ext-ord.vl-ggf-orc[3] = input de-vl-ggf-orc23
             ext-ord.vl-ggf-orc[4] = input de-vl-ggf-orc24
             ext-ord.vl-ggf-orc[5] = input de-vl-ggf-orc25
             ext-ord.vl-ggf-orc[6] = input de-vl-ggf-orc26.

    end.  
    if param-estoq.tem-moeda2 then do:
      find first ext-ord
           where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
             and ext-ord.mo-codigo    = 2
             and ext-ord.op-seq       = 0 no-error.
      if not available(ext-ord) then do:
        create ext-ord.
        assign ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
               ext-ord.mo-codigo    = 2
               ext-ord.op-seq       = 0.
        VALIDATE ext-ord.
      end.

      assign ext-ord.vl-ggf-orc[1] = input de-vl-ggf-orc31
             ext-ord.vl-ggf-orc[2] = input de-vl-ggf-orc32
             ext-ord.vl-ggf-orc[3] = input de-vl-ggf-orc33
             ext-ord.vl-ggf-orc[4] = input de-vl-ggf-orc34
             ext-ord.vl-ggf-orc[5] = input de-vl-ggf-orc35
             ext-ord.vl-ggf-orc[6] = input de-vl-ggf-orc36.

    end.  
  end.
end.  


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

  disable all with frame {&frame-name}.  

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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  find first ext-ord
       where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
         and ext-ord.mo-codigo    = 0
         and ext-ord.op-seq       = 0 
         no-lock no-error.
  if available(ext-ord) then
    assign de-vl-ggf-orc11 = ext-ord.vl-ggf-orc[1]
           de-vl-ggf-orc12 = ext-ord.vl-ggf-orc[2]
           de-vl-ggf-orc13 = ext-ord.vl-ggf-orc[3]
           de-vl-ggf-orc14 = ext-ord.vl-ggf-orc[4]
           de-vl-ggf-orc15 = ext-ord.vl-ggf-orc[5]
           de-vl-ggf-orc16 = ext-ord.vl-ggf-orc[6].
  else
    assign de-vl-ggf-orc11 = 0
           de-vl-ggf-orc12 = 0
           de-vl-ggf-orc13 = 0
           de-vl-ggf-orc14 = 0
           de-vl-ggf-orc15 = 0
           de-vl-ggf-orc16 = 0.

  disp de-vl-ggf-orc11
       de-vl-ggf-orc12
       de-vl-ggf-orc13
       de-vl-ggf-orc14
       de-vl-ggf-orc15
       de-vl-ggf-orc16
       with frame {&frame-name}.

  find first ext-ord
       where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
         and ext-ord.mo-codigo    = 1
         and ext-ord.op-seq       = 0 
         no-lock no-error.
  if available(ext-ord) and param-estoq.tem-moeda1 then
    assign de-vl-ggf-orc21 = ext-ord.vl-ggf-orc[1]
           de-vl-ggf-orc22 = ext-ord.vl-ggf-orc[2]
           de-vl-ggf-orc23 = ext-ord.vl-ggf-orc[3]
           de-vl-ggf-orc24 = ext-ord.vl-ggf-orc[4]
           de-vl-ggf-orc25 = ext-ord.vl-ggf-orc[5]
           de-vl-ggf-orc26 = ext-ord.vl-ggf-orc[6].
  else
    assign de-vl-ggf-orc21 = 0
           de-vl-ggf-orc22 = 0
           de-vl-ggf-orc23 = 0
           de-vl-ggf-orc24 = 0
           de-vl-ggf-orc25 = 0
           de-vl-ggf-orc26 = 0.

  disp de-vl-ggf-orc21
       de-vl-ggf-orc22
       de-vl-ggf-orc23
       de-vl-ggf-orc24
       de-vl-ggf-orc25
       de-vl-ggf-orc26
       with frame {&frame-name}.

  find first ext-ord
       where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
         and ext-ord.mo-codigo    = 2
         and ext-ord.op-seq       = 0 
         no-lock no-error.
  if available(ext-ord) and param-estoq.tem-moeda2 then
    assign de-vl-ggf-orc31 = ext-ord.vl-ggf-orc[1]
           de-vl-ggf-orc32 = ext-ord.vl-ggf-orc[2]
           de-vl-ggf-orc33 = ext-ord.vl-ggf-orc[3]
           de-vl-ggf-orc34 = ext-ord.vl-ggf-orc[4]
           de-vl-ggf-orc35 = ext-ord.vl-ggf-orc[5]
           de-vl-ggf-orc36 = ext-ord.vl-ggf-orc[6].
  else
    assign de-vl-ggf-orc31 = 0
           de-vl-ggf-orc32 = 0
           de-vl-ggf-orc33 = 0
           de-vl-ggf-orc34 = 0
           de-vl-ggf-orc35 = 0
           de-vl-ggf-orc36 = 0.

  disp de-vl-ggf-orc31
       de-vl-ggf-orc32
       de-vl-ggf-orc33
       de-vl-ggf-orc34
       de-vl-ggf-orc35
       de-vl-ggf-orc36
       with frame {&frame-name}.

  assign l-alterada = no. 

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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif


  do with frame {&frame-name}:
    if  ord-prod.estado <> 8 or ord-prod.valorizada <> yes then do:

      if param-cs.ocorrencia[1] <> "" then
        enable de-vl-ggf-orc11.
      else do:
        disable de-vl-ggf-orc11.
      end.
      if param-cs.ocorrencia[2] <> "" then
        enable de-vl-ggf-orc12.
      else do:
        disable de-vl-ggf-orc12.
      end.
      if param-cs.ocorrencia[3] <> "" then
        enable de-vl-ggf-orc13.
      else do:
        disable de-vl-ggf-orc13.
      end.
      if param-cs.ocorrencia[4] <> "" then
        enable de-vl-ggf-orc14.
      else do:
        disable de-vl-ggf-orc14.
      end.
      if param-cs.ocorrencia[5] <> "" then
        enable de-vl-ggf-orc15.
      else do:
        disable de-vl-ggf-orc15.
      end.
      if param-cs.ocorrencia[6] <> "" then
        enable de-vl-ggf-orc16.
      else do:
        disable de-vl-ggf-orc16.
      end.

      if param-estoq.tem-moeda1 = yes then do:
        if param-cs.ocorrencia[1] <> "" then
          enable de-vl-ggf-orc21.
        else do:
          disable de-vl-ggf-orc21.
        end.
        if param-cs.ocorrencia[2] <> "" then
          enable de-vl-ggf-orc22.
        else do:
          disable de-vl-ggf-orc22.
        end.
        if param-cs.ocorrencia[3] <> "" then
          enable de-vl-ggf-orc23.
        else do:
          disable de-vl-ggf-orc23.
        end.
        if param-cs.ocorrencia[4] <> "" then
          enable de-vl-ggf-orc24.
        else do:
          disable de-vl-ggf-orc24.
        end.
        if param-cs.ocorrencia[5] <> "" then
          enable de-vl-ggf-orc25.
        else do:
          disable de-vl-ggf-orc25.
        end.
        if param-cs.ocorrencia[6] <> "" then
          enable de-vl-ggf-orc26.
        else do:
          disable de-vl-ggf-orc26.
        end.
      end.

      if param-estoq.tem-moeda2 = yes then do:
        if param-cs.ocorrencia[1] <> "" then
          enable de-vl-ggf-orc31.
        else do:
          disable de-vl-ggf-orc31.
        end.
        if param-cs.ocorrencia[2] <> "" then
          enable de-vl-ggf-orc32.
        else do:
          disable de-vl-ggf-orc32.
        end.
        if param-cs.ocorrencia[3] <> "" then
          enable de-vl-ggf-orc33.
        else do:
          disable de-vl-ggf-orc33.
        end.
        if param-cs.ocorrencia[4] <> "" then
          enable de-vl-ggf-orc34.
        else do:
          disable de-vl-ggf-orc34.
        end.
        if param-cs.ocorrencia[5] <> "" then
          enable de-vl-ggf-orc35.
        else do:
          disable de-vl-ggf-orc35.
        end.
        if param-cs.ocorrencia[6] <> "" then
          enable de-vl-ggf-orc36.
        else do:
          disable de-vl-ggf-orc36.
        end.
      end.    

    end.
    else do:
      disable all with frame {&frame-name}.
    end.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alterada V-table-Win 
PROCEDURE pi-alterada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign l-alterada = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */

   /*Segue um exemplo de valida»’o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "ord-prod"}

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


