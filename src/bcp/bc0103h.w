&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0103H 2.00.00.005} /*** "010005" 07/11/2023 07:39:58  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0103H MBC}
&ENDIF

{include/i_fncrowid.i}

/******************************************************************************
** BC0103H.W - solicita dados para teste de etiqueta
******************************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-etiqueta          AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-quant-registros  AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-tipo-dados       AS INTEGER   NO-UNDO. /* 1-dados fixos, 2-sequenciais */
DEFINE OUTPUT PARAMETER p-arquivo-saida    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-geracao-word     AS INTEGER   NO-UNDO. /* 1-novo doc, 2-impressao */
DEFINE OUTPUT PARAMETER p-impres-ems-teste AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

&IF {&ROWID_READY} = YES &THEN
    DEFINE NEW GLOBAL SHARED VAR v_rec_layout_impres AS ROWID NO-UNDO.
&ELSE
    DEFINE NEW GLOBAL SHARED VAR v_rec_layout_impres AS RECID NO-UNDO.
&ENDIF

/* Include com funá‰es de manipulaá∆o dos dados de impress∆o da etiqueta */
{bcp/bc0103.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-1 RECT-2 fi-quant-registros ~
cb-tipo-dados fi-arquivo-saida cb-geracao-word bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS fi-etiqueta fi-descricao fi-destino ~
fi-impressora fi-layout fi-quant-registros cb-tipo-dados fi-arquivo-saida ~
cb-geracao-word fi-impres-ems 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-GO 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE cb-geracao-word AS CHARACTER FORMAT "x(20)":U INITIAL "0" 
     LABEL "Geraá∆o MSWord" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1 - Novo Documento","2 - Impressora" 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-dados AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Dados" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1 - Dados Fixos (XXX XXX ...)","2 - Sequenciais (001 002 ...)" 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE fi-arquivo-saida AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-destino AS CHARACTER FORMAT "X(256)":U 
     LABEL "Destino" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-etiqueta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-impres-ems AS CHARACTER FORMAT "X(256)":U 
     LABEL "Impressora Teste" 
     VIEW-AS FILL-IN 
     SIZE 34.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-impressora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Impressora EMS" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout EMS" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quant-registros AS INTEGER FORMAT ">>>9":U INITIAL 1 
     LABEL "Quant Registros" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.43 BY 4.54.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.57 BY 6.33.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 75.57 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     fi-etiqueta AT ROW 1.54 COL 18.43 COLON-ALIGNED
     fi-descricao AT ROW 1.54 COL 26.14 COLON-ALIGNED NO-LABEL
     fi-destino AT ROW 2.54 COL 18.43 COLON-ALIGNED
     fi-impressora AT ROW 3.54 COL 18.57 COLON-ALIGNED
     fi-layout AT ROW 4.54 COL 18.43 COLON-ALIGNED
     fi-quant-registros AT ROW 6.42 COL 18 COLON-ALIGNED
     cb-tipo-dados AT ROW 7.42 COL 18 COLON-ALIGNED
     fi-arquivo-saida AT ROW 8.54 COL 18 COLON-ALIGNED
     cb-geracao-word AT ROW 9.54 COL 18 COLON-ALIGNED
     fi-impres-ems AT ROW 10.67 COL 17.86 COLON-ALIGNED
     bt-ok AT ROW 12.63 COL 2.43
     bt-cancela AT ROW 12.63 COL 13.43
     rt-buttom AT ROW 12.38 COL 1.43
     RECT-1 AT ROW 1.17 COL 1.86
     RECT-2 AT ROW 5.92 COL 1.72
     SPACE(0.99) SKIP(2.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Teste de Etiqueta"
         DEFAULT-BUTTON bt-ok CANCEL-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-destino IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-etiqueta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-impres-ems IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-impressora IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-layout IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}
{include/i_fnctrad.i}    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Teste de Etiqueta */
DO:  
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
   APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela D-Dialog
ON CHOOSE OF bt-cancela IN FRAME D-Dialog /* Cancelar */
DO:
   APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
   DO WITH FRAME {&frame-name}:
      /* Valida dados informados */
      IF INTEGER(fi-quant-registros:SCREEN-VALUE) < 1 THEN DO:
         RUN utp/ut-msgs.p ('show':U, 25735, '':U).
         APPLY 'entry':U TO fi-quant-registros.
            RETURN NO-APPLY.
      END.
      IF fi-arquivo-saida:VISIBLE = YES AND fi-arquivo-saida:SCREEN-VALUE = "":U THEN DO:
         RUN utp/ut-msgs.p (INPUT "SHOW":U,
                            INPUT 1848,
                            INPUT "":U).
         APPLY "ENTRY":U TO fi-arquivo-saida.
         RETURN NO-APPLY.
      END.
      /* valida a impressora EMS se foi informada com o layout de impress∆o */
      IF fi-impres-ems:SENSITIVE = YES THEN DO:
         FIND FIRST layout_impres
              WHERE layout_impres.nom_impressora    = fi-impres-ems:SCREEN-VALUE
                AND layout_impres.cod_layout_impres = c-layout-ems NO-LOCK NO-ERROR.
         IF NOT AVAIL layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 19097,
                               INPUT c-layout-ems + "~~":U + fi-impres-ems:SCREEN-VALUE).
            RETURN NO-APPLY.
         END.
      END.
      /* Retorna os campos informados */
      p-quant-registros  = INTEGER(fi-quant-registros:SCREEN-VALUE).
      p-arquivo-saida    = fi-arquivo-saida:SCREEN-VALUE.
      p-tipo-dados       = INTEGER(SUBSTRING(cb-tipo-dados:SCREEN-VALUE, 1, 1)).
      p-geracao-word     = INTEGER(SUBSTRING(cb-geracao-word:SCREEN-VALUE, 1, 1)).
      p-impres-ems-teste = fi-impres-ems:SCREEN-VALUE.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-impres-ems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-impres-ems D-Dialog
ON F5 OF fi-impres-ems IN FRAME D-Dialog /* Impressora Teste */
DO:
   run BTB/btb036ka.w /*prg_sea_layout_impres*/.
   if v_rec_layout_impres <> ? then do with frame {&frame-name}:
      &IF {&ROWID_READY} = YES &THEN
         FIND FIRST layout_impres
              WHERE ROWID(layout_impres) = v_rec_layout_impres NO-LOCK NO-ERROR.
      &ELSE
         FIND FIRST layout_impres
              WHERE RECID(layout_impres) = v_rec_layout_impres NO-LOCK NO-ERROR.
      &ENDIF

      fi-impres-ems:SCREEN-VALUE = layout_impres.nom_impressora.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-impres-ems D-Dialog
ON MOUSE-SELECT-DBLCLICK OF fi-impres-ems IN FRAME D-Dialog /* Impressora Teste */
DO:
   APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi-etiqueta fi-descricao fi-destino fi-impressora fi-layout 
          fi-quant-registros cb-tipo-dados fi-arquivo-saida &IF "{&FNC_MULTI_IDIOMA}" <> "Yes" &THEN cb-geracao-word &endif
          fi-impres-ems 
      WITH FRAME D-Dialog.
  ENABLE rt-buttom RECT-1 RECT-2 fi-quant-registros cb-tipo-dados 
         fi-arquivo-saida cb-geracao-word bt-ok bt-cancela 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VARIABLE c-destino AS CHARACTER NO-UNDO.
  
   /* Code placed here will execute PRIOR to standard behavior. */
   DO WITH FRAME {&FRAME-NAME}:
      fi-impres-ems:LOAD-MOUSE-POINTER("image/lupa.cur":U). 
   END.
   /* Dispatch standard ADM method.                             */
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
      RUN utp/ut-trfrrp.p (INPUT FRAME {&frame-name}:HANDLE).
   &ENDIF
  
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) . /* Alterado para ap¢s a atribuiá∆o do list-items devido a nova tÇcnica de traduá∆o */
   /* Code placed here will execute AFTER standard behavior.    */

{utp/ut9000.i "BC0103H" "2.00.00.005"} /* 07/11/2023 07:39:58 */

   /* Mostra dados da etiqueta e determina campos a serem solicitados ---------*/
   FIND FIRST tipo-etiqueta
        WHERE tipo-etiqueta.tipo-etiq = p-etiqueta NO-LOCK NO-ERROR.
   RUN pi-obtem-campos-impressao (BUFFER tipo-etiqueta,
                                  OUTPUT i-tipo-destino,
                                  OUTPUT c-impres-ems, OUTPUT c-layout-ems,
                                  OUTPUT c-doc-msword, OUTPUT c-imp-windows).
   {utp/ut-liter.i "Arquivo,Impressora EMS,MSWord,LibreOffice"}
   c-destino = TRIM(RETURN-VALUE).
  
   DO WITH FRAME {&frame-name}:
      fi-etiqueta:SCREEN-VALUE      = STRING(tipo-etiqueta.tipo-etiq).
      fi-descricao:SCREEN-VALUE     = tipo-etiqueta.titulo.
      fi-destino:SCREEN-VALUE       = ENTRY(i-tipo-destino, c-destino).
      fi-impressora:SCREEN-VALUE    = c-impres-ems.
      fi-layout:SCREEN-VALUE        = c-layout-ems.
      cb-geracao-word:SCREEN-VALUE  = &IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN ENTRY(2, cb-geracao-word:LIST-ITEM-PAIRS) &else ENTRY(1, cb-geracao-word:LIST-ITEMS) &endif .
      cb-tipo-dados:SCREEN-VALUE    = &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN ENTRY(2, cb-tipo-dados:LIST-ITEM-PAIRS) &else ENTRY(1, cb-tipo-dados:LIST-ITEMS) &endif.
      fi-arquivo-saida:SCREEN-VALUE = SESSION:TEMP-DIRECTORY
                                    + "TEST":U
                                    + STRING(p-etiqueta, '9999')
                                    + (IF i-tipo-destino = 3 OR i-tipo-destino = 4 THEN ".RTF":U ELSE ".ETQ":U).
      /* se n∆o for geraá∆o word n∆o pede opá∆o do word */
      IF i-tipo-destino <> 3 THEN 
         cb-geracao-word:SENSITIVE = NO.
      /* se n∆o for geraá∆o word n∆o pede opá∆o do libre */
      IF i-tipo-destino <> 4 THEN 
         cb-geracao-word:SENSITIVE = NO.
      /* se for impress∆o EMS n∆o pede arquivo de saida */
      IF i-tipo-destino = 2 THEN
         fi-arquivo-saida:SENSITIVE = NO.
      /* se for impress∆o EMS sem impressora pede impressora */
      IF i-tipo-destino = 2 AND c-impres-ems = "":U THEN
          fi-impres-ems:SENSITIVE = YES.
      ELSE
          fi-impres-ems:SENSITIVE = NO.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
   DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
  
   RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


