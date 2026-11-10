&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V15IN124 2.00.00.003}  /*** 010003 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v15in124 MUT}
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
def var v-row-parent as rowid  no-undo.
def var h_p-cadsi2   as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ficha-cq
&Scoped-define FIRST-EXTERNAL-TABLE ficha-cq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ficha-cq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ficha-cq.qt-aprovada ficha-cq.qt-apr-cond ~
ficha-cq.qt-rejeitada ficha-cq.qt-consumida 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-aprovada ~{&FP2}qt-aprovada ~{&FP3}~
 ~{&FP1}qt-apr-cond ~{&FP2}qt-apr-cond ~{&FP3}~
 ~{&FP1}qt-rejeitada ~{&FP2}qt-rejeitada ~{&FP3}~
 ~{&FP1}qt-consumida ~{&FP2}qt-consumida ~{&FP3}
&Scoped-define ENABLED-TABLES ficha-cq
&Scoped-define FIRST-ENABLED-TABLE ficha-cq
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ficha-cq.nr-ficha ficha-cq.it-codigo ~
ficha-cq.qt-original ficha-cq.qt-aprovada ficha-cq.qt-apr-cond ~
ficha-cq.qt-rejeitada ficha-cq.qt-consumida 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS ficha-cq.nr-ficha ficha-cq.it-codigo ~
ficha-cq.qt-original 
&Scoped-define ADM-MODIFY-FIELDS ficha-cq.nr-ficha ficha-cq.it-codigo ~
ficha-cq.qt-original 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
nr-ficha|y|y|mgind.ficha-cq.nr-ficha
codigo-rejei||y|mgind.ficha-cq.codigo-rejei
cod-depos||y|mgind.ficha-cq.cod-depos
nr-ord-produ||y|mgind.ficha-cq.nr-ord-produ
it-codigo||y|mgind.ficha-cq.it-codigo
cod-estabel||y|mgind.ficha-cq.cod-estabel
nat-operacao||y|mgind.ficha-cq.nat-operacao
cod-resp||y|mgind.ficha-cq.cod-resp
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nr-ficha",
     Keys-Supplied = "nr-ficha,codigo-rejei,cod-depos,nr-ord-produ,it-codigo,cod-estabel,nat-operacao,cod-resp"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 1.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.72 BY 6.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ficha-cq.nr-ficha AT ROW 1.17 COL 31.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ficha-cq.it-codigo AT ROW 2.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     ficha-cq.qt-original AT ROW 3.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     ficha-cq.qt-aprovada AT ROW 4.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     ficha-cq.qt-apr-cond AT ROW 5.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     ficha-cq.qt-rejeitada AT ROW 6.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     ficha-cq.qt-consumida AT ROW 7.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     rt-key AT ROW 1 COL 1.29
     rt-mold AT ROW 2.58 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ficha-cq
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
         HEIGHT             = 8.21
         WIDTH              = 76.43.
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

/* SETTINGS FOR FILL-IN ficha-cq.it-codigo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN ficha-cq.nr-ficha IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN ficha-cq.qt-original IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
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
    WHEN 'nr-ficha':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = ficha-cq
           &WHERE = "WHERE ficha-cq.nr-ficha eq INTEGER(key-value)"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "ficha-cq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ficha-cq"}

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
       
    if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
      
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    
    run pi-validate.
    if  return-value = "ADM-ERROR":U then
        return "ADM-ERROR":U.
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    if  ficha-cq.qt-original = input frame {&frame-name} ficha-cq.qt-aprovada  +
                               input frame {&frame-name} ficha-cq.qt-rejeitada + 
                               input frame {&frame-name} ficha-cq.qt-apr-cond  + 
                               input frame {&frame-name} ficha-cq.qt-consumida then do:

        find current ficha-cq exclusive-lock no-error.

        /* Atualiza Roteiro */
        assign ficha-cq.inspecionado = yes
               ficha-cq.liberada     = yes
               ficha-cq.situacao     = 4
               ficha-cq.qt-a-liberar = 0.

        find current ficha-cq no-lock no-error.
    end.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    
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
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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

    if avail ficha-cq then do:       
       if ficha-cq.situacao = 4 or ficha-cq.situacao = 5 then do:
          run utp/ut-msgs.p (input "show", input 829, input "").
          if  valid-handle(h_p-cadsi2) then
              run pi-cancelar in h_p-cadsi2.
          return 'adm-error'. 
        end.
    end.  
        
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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

   find first param-global no-lock no-error.
   if not avail param-global then do:
   {utp/ut-table.i mguni param-global 1}
                   run utp/ut-msgs.p (input "show",
                                      input 56,
                                      input return-value). 
   return no-apply.
   end.
   find first param-estoq no-lock no-error.
   if not avail param-estoq then do:
   {utp/ut-table.i mguni param-estoq 1}
                   run utp/ut-msgs.p (input "show",
                                      input 56,
                                      input return-value). 
 
  return no-apply.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-handle as handle no-undo.

    assign h_p-cadsi2 = p-handle.

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


    find first item
       where item.it-codigo = input frame {&frame-name} ficha-cq.it-codigo no-lock no-error.
    if  avail item then do:
        if  not item.fraciona then do: /* Item n∆o aceita quantidade fracionada */
        
            if  input frame {&frame-name} ficha-cq.qt-aprovada  <> 
                int(input frame {&frame-name} ficha-cq.qt-aprovada) then do:

                run utp/ut-msgs.p (input "show",
                                   input 1304,
                                   input "").
                apply "entry" to ficha-cq.qt-aprovada in frame {&frame-name}.
                return "ADM-ERROR".
            end.
            else if input frame {&frame-name} ficha-cq.qt-rejeitada <> 
                    int(input frame {&frame-name} ficha-cq.qt-rejeitada) then do:

                run utp/ut-msgs.p (input "show",
                                   input 1304,
                                   input "").
                apply "entry" to ficha-cq.qt-rejeitada in frame {&frame-name}.
                return "ADM-ERROR".
            end.
            else if input frame {&frame-name} ficha-cq.qt-apr-cond  <> 
                    int(input frame {&frame-name} ficha-cq.qt-apr-cond) then do:

                run utp/ut-msgs.p (input "show",
                                   input 1304,
                                   input "").
                apply "entry" to ficha-cq.qt-apr-cond in frame {&frame-name}.
                return "ADM-ERROR".
            end.
            else if input frame {&frame-name} ficha-cq.qt-consumida <> 
                    int(input frame {&frame-name} ficha-cq.qt-consumida) then do:

                run utp/ut-msgs.p (input "show",
                                   input 1304,
                                   input "").
                apply "entry" to ficha-cq.qt-consumida in frame {&frame-name}.
                return "ADM-ERROR".
            end.
        end.
    end.

   if ficha-cq.qt-original > input frame {&frame-name} ficha-cq.qt-aprovada  +
                             input frame {&frame-name} ficha-cq.qt-rejeitada + 
                             input frame {&frame-name} ficha-cq.qt-apr-cond  + 
                             input frame {&frame-name} ficha-cq.qt-consumida then do:
       /* Avisa que o roteiro n∆o est† inspecionado */
       find current ficha-cq exclusive-lock no-error.

       assign ficha-cq.inspecionado = no.
       {utp/ut-table.i mgind ficha-cq 1}
       run utp/ut-msgs.p (input "show",
                          input 32026,
                          input return-value).

       find current ficha-cq no-lock no-error.
   end.
   else 
   if ficha-cq.qt-original < input frame {&frame-name} ficha-cq.qt-aprovada  +
                             input frame {&frame-name} ficha-cq.qt-rejeitada + 
                             input frame {&frame-name} ficha-cq.qt-apr-cond  + 
                             input frame {&frame-name} ficha-cq.qt-consumida then do:
       /* Impede alteraá∆o do roteiro */
       find current ficha-cq exclusive-lock no-error.

       assign ficha-cq.inspecionado = no.
       
       {utp/ut-table.i mgind ficha-cq 1}
       run utp/ut-msgs.p (input "show",
                          input 1303,
                          input return-value). 

       find current ficha-cq no-lock no-error.

       return "ADM-ERROR".
   end.

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nr-ficha" "ficha-cq" "nr-ficha"}
  {src/adm/template/sndkycas.i "codigo-rejei" "ficha-cq" "codigo-rejei"}
  {src/adm/template/sndkycas.i "cod-depos" "ficha-cq" "cod-depos"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "ficha-cq" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "it-codigo" "ficha-cq" "it-codigo"}
  {src/adm/template/sndkycas.i "cod-estabel" "ficha-cq" "cod-estabel"}
  {src/adm/template/sndkycas.i "nat-operacao" "ficha-cq" "nat-operacao"}
  {src/adm/template/sndkycas.i "cod-resp" "ficha-cq" "cod-resp"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "ficha-cq"}

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


