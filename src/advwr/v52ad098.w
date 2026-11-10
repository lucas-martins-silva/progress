&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V52AD098 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V52AD098 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var de-fator-2 as decimal format "999999,9999" init 1 no-undo.
def new global shared var de-fator-1 as decimal format "999999,9999" init 1 no-undo.
def new global shared var gr-emitente  as rowid no-undo.
def new global shared var de-indice like cotacao.cota-mensal init 1 no-undo.

/*def var de-tab-val-1 like ped-venda.vl-liq-ab.
def var de-tab-val-2 like ped-venda.vl-liq-ab.
def var de-tab-val-3 like ped-venda.vl-liq-ab.
def var de-tab-val-4 like ped-venda.|vl-liq-ab.
def var de-tab-val-5 like ped-venda.vl-liq-ab.*/

def var i-moeda-aux like cotacao.mo-codigo init 0 no-undo.
def var da-ate-dez  as date format "99/99/9999" no-undo.
def var da-dez-vin  as date format "99/99/9999" no-undo.
def var da-vin-tri  as date format "99/99/9999" no-undo.

def var i-totpdre     as integer format ">>,>>9"   no-undo.
def var i-totpdaa     as integer format ">>,>>9"   no-undo.
def var de-totvlap    like ped-venda.vl-liq-ab no-undo.
def var de-totvlre    like ped-venda.vl-liq-ab no-undo.
def var de-totvlaa    like ped-venda.vl-liq-ab no-undo.
def var de-qtatend    like ped-item.qt-atendida no-undo.
def var de-vlaber     like ped-venda.vl-liq-abe no-undo.
def var de-valatped   like ped-venda.vl-liq-ab no-undo.
def var l-ind1        as logical format "Sim/Nao" no-undo.
def var l-ind2        like l-ind1 no-undo.
def var l-ind3        like l-ind1 no-undo.
def var l-ind4        like l-ind1 no-undo.
def var l-ind5        like l-ind1 no-undo.
def var l-atrasado    as logical initial no no-undo.
def var da-dt-atr     like da-ate-dez initial today no-undo.
def var da-dt-prv     like da-ate-dez no-undo.
def var da-entmai     like ped-item.dt-entorig initial today no-undo.
def var da-prvmai     like ped-item.dt-entorig initial today no-undo.
def var c-pedmai      like ped-venda.nr-pedcli no-undo.
def var de-valmai     like ped-venda.vl-liq-ab no-undo.
def var de-valmaiat   like ped-venda.vl-liq-ab no-undo.
def var c-pedatr      like ped-venda.nr-pedcli no-undo.
def var da-dtentatr   like ped-item.dt-entorig no-undo.
def var da-entpvatr   like ped-item.dt-entorig no-undo.
def var i-diamaiat    as integer format ">>9"  no-undo.
def var i-diamai      like i-diamaiat          no-undo.
def var l-soma-ped   as logical               no-undo.
def var l-primeira-vez as logical             initial YES no-undo.

{cdp/cdcfgdis.i} /*preprocessador de vers∆o*/
{cdp/cd1234.i}   /* Definiá∆o da funá∆o fn_ajust_dec conforme engenharia "Ajustes de Casas Decimais"*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS de-totvlab i-totpdap i-nr-ped-2 ~
de-tab-val-2 i-totpdnap i-nr-ped-3 de-tab-val-3 de-tab-val-1 i-nr-ped-4 ~
de-tab-val-4 i-nr-ped-1 i-nr-ped-5 de-tab-val-5 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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
DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 13.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 7.72 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto3 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 4.29 BY .63 NO-UNDO.

DEFINE VARIABLE de-tab-val-1 AS DECIMAL FORMAT "z,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-tab-val-2 AS DECIMAL FORMAT "z,zzz,zzz,zz9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-tab-val-3 AS DECIMAL FORMAT "z,zzz,zzz,zz9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-tab-val-4 AS DECIMAL FORMAT "z,zzz,zzz,zz9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-tab-val-5 AS DECIMAL FORMAT "z,zzz,zzz,zz9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-totvlab AS DECIMAL FORMAT "z,zzz,zzz,zz9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ped-1 AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ped-2 AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ped-3 AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ped-4 AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ped-5 AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdap AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-totpdnap AS DECIMAL FORMAT "zz,zz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.14 BY 5.92.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.72 BY 5.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     de-totvlab AT ROW 2 COL 25 COLON-ALIGNED
     i-totpdap AT ROW 3 COL 25 COLON-ALIGNED
     i-nr-ped-2 AT ROW 3.17 COL 53.14 COLON-ALIGNED
     de-tab-val-2 AT ROW 3.17 COL 63 COLON-ALIGNED NO-LABEL
     i-totpdnap AT ROW 4 COL 25 COLON-ALIGNED
     i-nr-ped-3 AT ROW 4.17 COL 53.14 COLON-ALIGNED
     de-tab-val-3 AT ROW 4.17 COL 63 COLON-ALIGNED NO-LABEL
     de-tab-val-1 AT ROW 5 COL 25 COLON-ALIGNED
     i-nr-ped-4 AT ROW 5.17 COL 53.14 COLON-ALIGNED
     de-tab-val-4 AT ROW 5.17 COL 63 COLON-ALIGNED NO-LABEL
     i-nr-ped-1 AT ROW 6 COL 25 COLON-ALIGNED
     i-nr-ped-5 AT ROW 6.17 COL 53.14 COLON-ALIGNED
     de-tab-val-5 AT ROW 6.17 COL 63 COLON-ALIGNED NO-LABEL
     c-texto1 AT ROW 1.13 COL 44.29 NO-LABEL
     c-texto2 AT ROW 2.04 COL 57.14 COLON-ALIGNED NO-LABEL
     c-texto3 AT ROW 2.04 COL 79.29 COLON-ALIGNED NO-LABEL
     "----------------------------------------------" VIEW-AS TEXT
          SIZE 20.43 BY .38 AT ROW 2.63 COL 65
     "-----------------------------------" VIEW-AS TEXT
          SIZE 9 BY .38 AT ROW 2.63 COL 55
     RECT-2 AT ROW 1.46 COL 1
     RECT-1 AT ROW 1.46 COL 42.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 6.42
         WIDTH              = 85.43.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-texto1 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-texto3 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN de-tab-val-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tab-val-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tab-val-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tab-val-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tab-val-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-totvlab IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-ped-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-ped-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-ped-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-ped-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-ped-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdap IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-totpdnap IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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
    assign i-nr-ped-1   = 0
         i-nr-ped-2   = 0
         i-nr-ped-3   = 0
         i-nr-ped-4   = 0
         i-nr-ped-5   = 0
         i-totpdre    = 0
         i-totpdaa    = 0
         i-totpdap    = 0
         i-totpdnap   = 0
         de-tab-val-1 = 0
         de-tab-val-2 = 0
         de-tab-val-3 = 0
         de-tab-val-4 = 0
         de-tab-val-5 = 0
         de-totvlab   = 0
         l-atrasado   = no.

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      {cdp/cd1022.i3}
  &ELSE
      {pdp/pd0902.i3}
  &ENDIF

  assign i-totpdnap = i-totpdre + i-totpdaa.

  display i-nr-ped-1   
          i-nr-ped-2   
          i-nr-ped-3   
          i-nr-ped-4   
          i-nr-ped-5   
          i-totpdap   
          i-totpdnap 
          de-tab-val-1 
          de-tab-val-2 
          de-tab-val-3 
          de-tab-val-4 
          de-tab-val-5 
          de-totvlab   
          with frame {&frame-name}.          


  /* O local-display Ç chamado duas vezes no local-initialize do PD0902B. */
  IF l-primeira-vez = YES THEN
      ASSIGN l-primeira-vez = NO.
  ELSE
  DO:                                                                       
      find first para-ped no-lock no-error.  

       /* ====================== Fator de Convers∆o ====================== */     

      /***************************************************
       * Pre-processador de Usuario e Moeda de Credito   *
       ***************************************************/
       &if  defined (bf_dis_usu_moeda_cred)  &then
       /* Na 2.02 em diante, busca a moeda do "Mo Lim Cred" (PD0806) */             
            if  not avail (emitente) then
                find emitente where rowid(emitente) = gr-emitente  no-lock no-error.

            if avail emitente and emitente.moeda-libcre <> 0 then 
                assign i-moeda-aux = emitente.moeda-libcre.
            else
                assign i-moeda-aux    = 0.

       &else
       /* Na 2.0, busca da "Moeda Limite CrÇdito" (PD0301). */
            if  para-ped.moeda-libcre <> 0 then 
                assign i-moeda-aux = para-ped.moeda-libcre.
            else
                assign i-moeda-aux    = 0.      
       &endif.

      /* A moeda padr∆o n∆o precisa de cotaá∆o cadastrada */
      {pdp/pd9100.i "i-moeda-aux" "today" "de-fator-2"}
      if  not avail cotacao and i-moeda-aux <> 0 then do:
          {utp/ut-liter.i Moeda}
          run utp/ut-msgs.p (input "show",
                             input 3288,
                             input trim(return-value) + " " + string(i-moeda-aux)).
          assign de-fator-2 = 1.
      end. 
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
  {utp/ut-liter.i "AtÇ_10_dias" * L}
  assign i-nr-ped-2:label in frame {&frame-name} = return-value.  
  {utp/ut-liter.i "De_10_a_20_dias" * L}
  assign i-nr-ped-3:label in frame {&frame-name} = return-value.  
  {utp/ut-liter.i "De_20_a_30_dias" * L}
  assign i-nr-ped-4:label in frame {&frame-name} = return-value.  
  {utp/ut-liter.i "Mais_de_30_dias" * L}
  assign i-nr-ped-5:label in frame {&frame-name} = return-value. 

  {utp/ut-liter.i "Valor_Total_em_Aberto" * L}
  assign de-totvlab:label in frame {&frame-name} = return-value.   
  {utp/ut-liter.i "Pedidos_Aberto_Aprovados" * L}
  assign i-totpdap:label in frame {&frame-name} = return-value. 
  {utp/ut-liter.i "Pedidos_Aberto_n∆o_Aprovados" * L}
  assign i-totpdnap:label in frame {&frame-name} = return-value. 
  {utp/ut-liter.i "Valor_Aberto_em_Atraso" * L}
  assign de-tab-val-1:label in frame {&frame-name} = return-value. 
  {utp/ut-liter.i "Pedidos_em_Atraso" * L}
  assign i-nr-ped-1:label in frame {&frame-name} = return-value. 

  {utp/ut-liter.i "Saldo_a_Atender" * R}
  assign c-texto1:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-liter.i "Nr_Ped" * R}
  assign c-texto2:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i "Valor" * R}
  assign c-texto3:screen-value in frame {&frame-name} = return-value.

  assign da-ate-dez = today + 10
         da-dez-vin = today + 20
         da-vin-tri = today + 30.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "emitente"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

