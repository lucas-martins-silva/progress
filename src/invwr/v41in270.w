&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V41IN270 2.00.00.004}  /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V41IN270 MUT}
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
def new global shared var l-solic-encerr-cs0307 as logical no-undo.                               
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-alterada as logical no-undo.

{cep/ce1234.i} /*** Defini‡Æo TTs e Vari veis - Valida‡Æo Decimais ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-OBJECTS de-vl-mat-orc1 de-vl-mat-orc2 ~
de-vl-mat-orc3 de-vl-mob-orc1 de-vl-mob-orc2 de-vl-mob-orc3 c-texto1 ~
c-moeda11 c-moeda21 c-moeda31 c-texto2 c-moeda12 c-moeda22 c-moeda32 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS de-vl-mat-orc1 de-vl-mat-orc2 ~
de-vl-mat-orc3 

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
DEFINE VARIABLE c-moeda11 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda12 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda21 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda22 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda31 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda32 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE de-vl-mat-orc1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-orc2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-orc3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-orc1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-orc2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-orc3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 3.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-vl-mat-orc1 AT ROW 3 COL 5 COLON-ALIGNED NO-LABEL
     de-vl-mat-orc2 AT ROW 3 COL 34 COLON-ALIGNED NO-LABEL
     de-vl-mat-orc3 AT ROW 3 COL 62 COLON-ALIGNED NO-LABEL
     de-vl-mob-orc1 AT ROW 6.75 COL 5 COLON-ALIGNED NO-LABEL
     de-vl-mob-orc2 AT ROW 6.75 COL 34 COLON-ALIGNED NO-LABEL
     de-vl-mob-orc3 AT ROW 6.75 COL 62 COLON-ALIGNED NO-LABEL
     c-texto1 AT ROW 1.25 COL 1 COLON-ALIGNED NO-LABEL
     c-moeda11 AT ROW 2 COL 5 COLON-ALIGNED NO-LABEL
     c-moeda21 AT ROW 2 COL 34 COLON-ALIGNED NO-LABEL
     c-moeda31 AT ROW 2 COL 62 COLON-ALIGNED NO-LABEL
     c-texto2 AT ROW 5 COL 1 COLON-ALIGNED NO-LABEL
     c-moeda12 AT ROW 5.75 COL 5 COLON-ALIGNED NO-LABEL
     c-moeda22 AT ROW 5.75 COL 34 COLON-ALIGNED NO-LABEL
     c-moeda32 AT ROW 5.75 COL 62 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1.5 COL 2
     rt-mold-2 AT ROW 5.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-manut
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 8.71
         WIDTH              = 84.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-moeda11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda21 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda22 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda31 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda32 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-mat-orc1 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-vl-mat-orc2 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-vl-mat-orc3 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-vl-mob-orc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-mob-orc2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-mob-orc3 IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

{mnbo/bomn150.i1} /*TT envio email, parametros email MI0101*/
{mnbo/bomn150.i2} /*pi-envia-email, pi-email-encerrar*/	

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

find first param-global no-lock no-error.
find first param-cs no-lock no-error.
find first param-estoq no-lock no-error.

do with frame {&frame-name}:
  {utp/ut-field.i mgind ext-ord vl-mat-orc 1}
  assign c-texto1 = return-value.
  {utp/ut-field.i mgind ext-ord vl-mob-orc 1}
  assign c-texto2 = return-value.
  {utp/ut-liter.i Corrente * r}
  assign c-moeda11 = return-value
         c-moeda12 = return-value.
  if avail param-estoq and param-estoq.tem-moeda1 then do:
   find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
    if avail moeda then 
     assign c-moeda21 = moeda.descricao
            c-moeda22 = moeda.descricao.
  end.   
  if avail param-estoq and param-estoq.tem-moeda2 then do:
   find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
    if avail moeda then 
     assign c-moeda31 = moeda.descricao
            c-moeda32 = moeda.descricao.
  end.
  disp c-moeda11 c-moeda12 c-moeda21 c-moeda22 c-moeda31 c-moeda32
       c-texto1 c-texto2.  
end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .*/

  /*** Tratamento e Valida‡Æo casas decimais ***/

  assign l-rejeita-dec = no
         de-vl-mat-orc1:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                              de-vl-mat-orc1, 0))
         de-vl-mat-orc2:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                              de-vl-mat-orc2, param-estoq.moeda1))
         de-vl-mat-orc3:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                              de-vl-mat-orc3, param-estoq.moeda2))
         de-vl-mob-orc1:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                              de-vl-mob-orc1, 0))
         de-vl-mob-orc2:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                              de-vl-mob-orc2, param-estoq.moeda1))
         de-vl-mob-orc3:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} 
                                                              de-vl-mob-orc3, param-estoq.moeda2)).

  if  l-rejeita-dec then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 18100, 
                         input " ").
      return 'ADM-ERROR':U.        
  end.

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  find ord-prod 
       where ord-prod.nr-ord-prod = ord-manut.nr-ord-prod NO-LOCK no-error.
   if avail ord-prod then do:
      do with frame {&frame-name}:
         if (ord-prod.estado <> 8 or ord-prod.valorizada <> yes) or l-alterada then do:
            find first ext-ord
               where ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
               and ext-ord.mo-codigo    = 0
               and ext-ord.op-seq       = 0 no-error.
            if not available(ext-ord) then do:
               create ext-ord.
               assign ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
                      ext-ord.mo-codigo    = 0
                      ext-ord.op-seq       = 0.
            end.
            assign ext-ord.vl-mat-orc = input de-vl-mat-orc1
                   ext-ord.vl-mob-orc = input de-vl-mob-orc1.
            if param-estoq.tem-moeda1 then do:
               find first ext-ord
                    where ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
                      and ext-ord.mo-codigo    = param-estoq.moeda1
                      and ext-ord.op-seq       = 0 no-error.
               if not available(ext-ord) then do:
                  create ext-ord.
                  assign ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
                         ext-ord.mo-codigo    = param-estoq.moeda1
                         ext-ord.op-seq       = 0.
               end.
               assign ext-ord.vl-mat-orc = input de-vl-mat-orc2
                      ext-ord.vl-mob-orc = input de-vl-mob-orc2.
            end.  
            if param-estoq.tem-moeda2 then do:
               find first ext-ord
                    where ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
                      and ext-ord.mo-codigo    = param-estoq.moeda2
                      and ext-ord.op-seq       = 0 no-error.
               if not available(ext-ord) then do:
                  create ext-ord.
                  assign ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
                         ext-ord.mo-codigo    = param-estoq.moeda2
                         ext-ord.op-seq       = 0.
               end.
               assign ext-ord.vl-mat-orc = input de-vl-mat-orc3
                      ext-ord.vl-mob-orc = input de-vl-mob-orc3.
            end.  
         end.
      end.  
   end.  
     
   /* envia e-mail encerramento solicita‡ao de servi‡o 
      l-solic-encerr-cs0307 atualizada na v39in270.w */
   IF ord-manut.estado = 8 AND l-encerrar-ss AND l-solic-encerr-cs0307 THEN DO:            
      FOR FIRST ordem-solic NO-LOCK
          WHERE ordem-solic.nr-ord-prod = ord-manut.nr-ord-prod:
              RUN pi-email-encerrar(INPUT ordem-solic.nr-soli-serv).
      END.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first ext-ord
       where ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
         and ext-ord.mo-codigo    = 0
         and ext-ord.op-seq       = 0 no-error.
  if available(ext-ord) then
     assign de-vl-mat-orc1 = ext-ord.vl-mat-orc
            de-vl-mob-orc1 = ext-ord.vl-mob-orc.
  else
    assign de-vl-mat-orc1 = 0
           de-vl-mob-orc1 = 0.

  disp de-vl-mat-orc1
       de-vl-mob-orc1
       with frame {&frame-name}.

  find first ext-ord
       where ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
         and ext-ord.mo-codigo    = param-estoq.moeda1
         and ext-ord.op-seq       = 0 no-error.
  if available(ext-ord) and param-estoq.tem-moeda1 then
    assign de-vl-mat-orc2 = ext-ord.vl-mat-orc
           de-vl-mob-orc2 = ext-ord.vl-mob-orc.
  else
    assign de-vl-mat-orc2 = 0
           de-vl-mob-orc2 = 0.  

  disp de-vl-mat-orc2
       de-vl-mob-orc2
       with frame {&frame-name}.

  find first ext-ord
       where ext-ord.nr-ord-produ = ord-manut.nr-ord-produ
         and ext-ord.mo-codigo    = param-estoq.moeda2
         and ext-ord.op-seq       = 0 no-error.
  if available(ext-ord) and param-estoq.tem-moeda2 then
    assign de-vl-mat-orc3 = ext-ord.vl-mat-orc
           de-vl-mob-orc3 = ext-ord.vl-mob-orc.
  else
    assign de-vl-mat-orc3 = 0
           de-vl-mob-orc3 = 0.

  disp de-vl-mat-orc3
       de-vl-mob-orc3
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  find ord-prod 
       where ord-prod.nr-ord-prod = ord-manut.nr-ord-prod NO-LOCK no-error.
  if avail ord-prod then do:      
     do with frame {&frame-name}:
        if ord-prod.estado <> 8 or ord-prod.valorizada <> yes then do:
            enable de-vl-mat-orc1
                   de-vl-mob-orc1.      
            if param-estoq.tem-moeda1 = yes then
               enable de-vl-mat-orc2
                      de-vl-mob-orc2.
            else
                disable de-vl-mat-orc2
                        de-vl-mob-orc2.
            if param-estoq.tem-moeda2 = yes then
               enable de-vl-mat-orc3
                      de-vl-mob-orc3.  
            else
                enable de-vl-mat-orc3
                       de-vl-mob-orc3.
        end.
        else 
            disable all with frame {&frame-name}.
        RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
     end.   
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
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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


