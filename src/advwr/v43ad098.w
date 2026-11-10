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
{include/i-prgvrs.i V43AD098 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V43AD098 MUT}
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
def var de-tab-val-4 like ped-venda.vl-liq-ab.
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

def var i-nr-ped-1 as integer format "ZZ,ZZ9" no-undo.
def var i-nr-ped-2 as integer format "ZZ,ZZ9" no-undo.
def var i-nr-ped-3 as integer format "ZZ,ZZ9" no-undo.
def var i-nr-ped-4 as integer format "ZZ,ZZ9" no-undo.
def var i-nr-ped-5 as integer format "ZZ,ZZ9" no-undo.
def var i-totpdap  as integer format ">>,>>9" no-undo.
def var de-tab-val-1  like ped-venda.vl-liq-ab no-undo.
def var de-tab-val-2  like ped-venda.vl-liq-ab no-undo.
def var de-tab-val-3  like ped-venda.vl-liq-ab no-undo.
def var de-tab-val-4  like ped-venda.vl-liq-ab no-undo.
def var de-tab-val-5  like ped-venda.vl-liq-ab no-undo.
def var de-totvlab    like ped-venda.vl-liq-ab no-undo.
def var l-soma-ped   as logical               no-undo.
def var l-primeira-vez as logical             initial YES no-undo.

{cdp/cdcfgdis.i} /*preprocessador de vers∆o*/
{cdp/cd1234.i}   /* Definiá∆o da funá∆o fn_ajust_dec conforme engenharia "Ajustes de Casas Decimais"*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 
&Scoped-Define DISPLAYED-OBJECTS c-pedmai de-valmaiat i-diamai i-diamaiat ~
de-valmai c-pedatr da-entmai da-dtentatr da-prvmai da-entpvatr 

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
DEFINE VARIABLE c-pedatr AS CHARACTER FORMAT "X(12)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-pedmai AS CHARACTER FORMAT "X(12)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE da-dtentatr AS DATE FORMAT "99/99/9999" 
     LABEL "":R25 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE da-entmai AS DATE FORMAT "99/99/9999" 
     LABEL "":R25 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE da-entpvatr AS DATE FORMAT "99/99/9999" 
     LABEL "":R25 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE da-prvmai AS DATE FORMAT "99/99/9999" 
     LABEL "":R25 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE de-valmai AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-valmaiat AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE i-diamai AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-diamaiat AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.29 BY 6.38.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.29 BY 6.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-pedmai AT ROW 1.71 COL 19 COLON-ALIGNED
     de-valmaiat AT ROW 1.71 COL 62 COLON-ALIGNED
     i-diamai AT ROW 2.71 COL 19 COLON-ALIGNED
     i-diamaiat AT ROW 2.71 COL 62 COLON-ALIGNED
     de-valmai AT ROW 3.71 COL 19 COLON-ALIGNED
     c-pedatr AT ROW 3.71 COL 62 COLON-ALIGNED
     da-entmai AT ROW 4.71 COL 19 COLON-ALIGNED
     da-dtentatr AT ROW 4.71 COL 62 COLON-ALIGNED
     da-prvmai AT ROW 5.71 COL 19 COLON-ALIGNED
     da-entpvatr AT ROW 5.71 COL 62 COLON-ALIGNED
     RECT-27 AT ROW 1 COL 1
     RECT-28 AT ROW 1 COL 44
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-pedatr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pedmai IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dtentatr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-entmai IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-entpvatr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-prvmai IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valmai IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valmaiat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-diamai IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-diamaiat IN FRAME F-Main
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
  assign c-pedmai    = ""
         i-diamai    = 0
         de-valmai   = 0
         da-entmai   = today
         da-prvmai   = today
         de-valmaiat = 0
         i-diamaiat  = 0
         c-pedatr    = ""
         da-dtentatr = today
         da-entpvatr = today
         l-atrasado  = no.

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      {cdp/cd1022.i3}
  &ELSE
      {pdp/pd0902.i3}
  &ENDIF

  if l-atrasado = no then
      assign c-pedmai = ""
             i-diamai = 0
             de-valmai = 0
             da-entmai = ?
             da-prvmai = ?
             de-valmaiat = 0
             i-diamaiat = 0
             c-pedatr = ""
             da-dtentatr = ?
             da-entpvatr = ?.

  display c-pedmai    
          i-diamai    
          de-valmai   
          da-entmai   
          da-prvmai   
          de-valmaiat 
          i-diamaiat  
          c-pedatr    
          da-dtentatr
          da-entpvatr
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

      /* A moeda padr∆o n∆o precisa de cotaá∆o cadastrada. */
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
  {utp/ut-liter.i Pedido_Maior_Atraso * L}
  assign c-pedmai:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Nr_Dias_Atraso * L}
  assign i-diamai:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Valor_Aberto_Atraso * L}
  assign de-valmai:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Data_Entrega * L}
  assign da-entmai:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Data_Entrega_Prevista * L}
  assign da-prvmai:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Maior_Valor_Atraso * L}
  assign de-valmaiat:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Nr_Dias_Atraso * L}
  assign i-diamaiat:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Pedido_Cliente * L}
  assign c-pedatr:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Data_Entrega * L}
  assign da-dtentatr:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Data_Entrega_Prevista * L}
  assign da-entpvatr:label in frame {&frame-name} = trim(return-value).


  assign da-ate-dez = today + 10
         da-dez-vin = today + 20
         da-vin-tri = today + 30.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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


