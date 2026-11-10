&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V15AD204 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V15AD204 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-73 RECT-74 RECT-75 RECT-76 RECT-77 ~
fi-contas-receber fi-contas-pagar fi-pedidos fi-faturamento fi-compras 
&Scoped-Define DISPLAYED-OBJECTS fi-cr-recebimento fi-ap-pagamento ~
fi-cr-vencimento fi-ap-vencimento fi-pd-pedidos fi-ft-notas ~
fi-ft-devolucoes fi-cc-compras fi-cc-recebimento fi-contas-receber ~
fi-contas-pagar fi-pedidos fi-faturamento fi-compras 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE fi-ap-pagamento AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Pagamento Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ap-vencimento AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vencimento Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-compras AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Compras Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-recebimento AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Recebimento Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-compras AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-contas-pagar AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE fi-contas-receber AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE fi-cr-recebimento AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Recebimento Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cr-vencimento AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vencimento Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-faturamento AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE fi-ft-devolucoes AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Devolucoes Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ft-notas AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Notas Fiscais Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pd-pedidos AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Pedidos Dia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pedidos AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-73
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 2.33.

DEFINE RECTANGLE RECT-74
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 2.33.

DEFINE RECTANGLE RECT-75
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 2.33.

DEFINE RECTANGLE RECT-76
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 2.33.

DEFINE RECTANGLE RECT-77
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-cr-recebimento AT ROW 1.75 COL 26 COLON-ALIGNED
     fi-ap-pagamento AT ROW 1.75 COL 69 COLON-ALIGNED
     fi-cr-vencimento AT ROW 2.75 COL 26 COLON-ALIGNED
     fi-ap-vencimento AT ROW 2.75 COL 69 COLON-ALIGNED
     fi-pd-pedidos AT ROW 4.75 COL 26 COLON-ALIGNED
     fi-ft-notas AT ROW 4.75 COL 69 COLON-ALIGNED
     fi-ft-devolucoes AT ROW 5.75 COL 69 COLON-ALIGNED
     fi-cc-compras AT ROW 7.75 COL 26 COLON-ALIGNED
     fi-cc-recebimento AT ROW 8.75 COL 26 COLON-ALIGNED
     fi-contas-receber AT ROW 1.25 COL 2 NO-LABEL
     fi-contas-pagar AT ROW 1.25 COL 45 NO-LABEL
     fi-pedidos AT ROW 4.25 COL 2 NO-LABEL
     fi-faturamento AT ROW 4.25 COL 45 NO-LABEL
     fi-compras AT ROW 7.25 COL 2 NO-LABEL
     RECT-73 AT ROW 1.5 COL 1
     RECT-74 AT ROW 1.5 COL 44
     RECT-75 AT ROW 4.5 COL 1
     RECT-76 AT ROW 4.5 COL 44
     RECT-77 AT ROW 7.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 8.83
         WIDTH              = 86.
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

/* SETTINGS FOR FILL-IN fi-ap-pagamento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ap-vencimento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cc-compras IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cc-recebimento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-compras IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-contas-pagar IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-contas-receber IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cr-recebimento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cr-vencimento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-faturamento IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-ft-devolucoes IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ft-notas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pd-pedidos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pedidos IN FRAME f-main
   ALIGN-L                                                              */
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

{utp/ut-liter.i Contas_a_Receber}
ASSIGN fi-contas-receber                                     = TRIM(RETURN-VALUE)
       fi-contas-receber:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Contas_a_Pagar}
ASSIGN fi-contas-pagar                                     = TRIM(RETURN-VALUE)
       fi-contas-pagar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Pedidos}
ASSIGN fi-pedidos                                     = TRIM(RETURN-VALUE)
       fi-pedidos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Faturamento}
ASSIGN fi-faturamento                                     = TRIM(RETURN-VALUE)
       fi-faturamento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Compras}
ASSIGN fi-compras                                     = TRIM(RETURN-VALUE)
       fi-compras:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Recebimento_Dia}
ASSIGN fi-cr-recebimento:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Vencimento_Dia}
ASSIGN fi-cr-vencimento:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Pagamento_Dia}
ASSIGN fi-ap-pagamento:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Vencimento_Dia}
ASSIGN fi-ap-vencimento:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Pedidos_Dia}
ASSIGN fi-pd-pedidos:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Notas_Fiscais_Dia}
ASSIGN fi-ft-notas:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Devolu‡äes_Dia}
ASSIGN fi-ft-devolucoes:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Compras_Dia}
ASSIGN fi-cc-compras:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Recebimento_Dia}
ASSIGN fi-cc-recebimento:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

ASSIGN fi-cr-recebimento:BGCOLOR IN FRAME {&FRAME-NAME} = 15
       fi-cr-recebimento:FGCOLOR IN FRAME {&FRAME-NAME} = 0
       fi-cr-vencimento:BGCOLOR IN FRAME {&FRAME-NAME}  = 15
       fi-cr-vencimento:FGCOLOR IN FRAME {&FRAME-NAME}  = 0
       
       fi-ap-pagamento:BGCOLOR IN FRAME {&FRAME-NAME}   = 15
       fi-ap-pagamento:FGCOLOR IN FRAME {&FRAME-NAME}   = 0
       fi-ap-vencimento:BGCOLOR IN FRAME {&FRAME-NAME}  = 15
       fi-ap-vencimento:FGCOLOR IN FRAME {&FRAME-NAME}  = 0
       
       fi-pd-pedidos:BGCOLOR IN FRAME {&FRAME-NAME}     = 15
       fi-pd-pedidos:FGCOLOR IN FRAME {&FRAME-NAME}     = 0
       
       fi-ft-notas:BGCOLOR IN FRAME {&FRAME-NAME}       = 15
       fi-ft-notas:FGCOLOR IN FRAME {&FRAME-NAME}       = 0
       fi-ft-devolucoes:BGCOLOR IN FRAME {&FRAME-NAME}  = 15
       fi-ft-devolucoes:FGCOLOR IN FRAME {&FRAME-NAME}  = 0
       
       fi-cc-compras:BGCOLOR IN FRAME {&FRAME-NAME}     = 15
       fi-cc-compras:FGCOLOR IN FRAME {&FRAME-NAME}     = 0
       fi-cc-recebimento:BGCOLOR IN FRAME {&FRAME-NAME} = 15
       fi-cc-recebimento:FGCOLOR IN FRAME {&FRAME-NAME} = 0.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.
    
    ASSIGN v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizacao V-table-Win 
PROCEDURE pi-atualizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-empresa              AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-data                 AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-data-inicio-carteira AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-fator                AS INTEGER NO-UNDO.
    
    RUN gep/gebo02011.p ( INPUT p-empresa,
                          INPUT p-data,
                          INPUT p-data-inicio-carteira,
                          INPUT p-fator,
                          
                         OUTPUT fi-pd-pedidos,
                         OUTPUT fi-ft-notas,
                         OUTPUT fi-ft-devolucoes,
                         OUTPUT fi-cc-compras,
                         OUTPUT fi-cc-recebimento,
                         OUTPUT fi-ap-pagamento,
                         OUTPUT fi-ap-vencimento,
                         OUTPUT fi-cr-recebimento,
                         OUTPUT fi-cr-vencimento).
    
    DISPLAY fi-cr-recebimento fi-cr-vencimento
            fi-ap-pagamento   fi-ap-vencimento
            fi-pd-pedidos
            fi-ft-notas       fi-ft-devolucoes
            fi-cc-compras     fi-cc-recebimento
        WITH FRAME {&FRAME-NAME}.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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
    
    RUN pi-trata-state IN THIS-PROCEDURE (INPUT p-issuer-hdl, INPUT p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


