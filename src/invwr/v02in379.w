&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V02IN379 2.00.00.022 } /*** "010022" 11/09/2023 15:33:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN379 MUT}
&ENDIF

/*------------------------------------------------------------------------/

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
def new global shared var gr-rep-prod  as rowid no-undo. 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cpp/cp0326.i "new"}

{cdp/cd0666.i}   /* Definiá∆o da temp-table geral tt-erro                  */
{cep/ceapi001k.i} /* Definiá∆o da temp-table de movimentaá∆o de estoques    */
{cpp/cpapi005.i} /* Definiá∆o da temp-table de movimento de GGF            */
{cpp/cpapi006.i} /* Definiá∆o da temp-table de m∆o-de-obra direta          */
{cpp/cpapi009.i} /* Definiá∆o das temp-tables da API de reporte repetitivo */
{cdp/cdcfgman.i}

def buffer b-rep-prod      for rep-prod.

def var i-nr-ordens         as integer            no-undo.
def var i-nr-val            as integer INITIAL 0 FORMAT "->,>>>,>>9":U  NO-UNDO.
def var l-emite-relatorio   as logical            no-undo.
def var i-retorno           as integer            no-undo.
def var de-qt-min         like rep-prod.qt-refugo no-undo.
def var de-qt-max         like rep-prod.qt-refugo no-undo.
def var c-mensagem          as char               no-undo.

def new global shared var h-acomp as handle       no-undo.

&IF DEFINED(bf_man_204) &THEN
    DEF NEW GLOBAL SHARED VAR handle-p-rxihel AS HANDLE NO-UNDO. /* Brand∆o, 21/MAR/06, Definida em CP0326 */
&ENDIF

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
&Scoped-define EXTERNAL-TABLES rep-prod
&Scoped-define FIRST-EXTERNAL-TABLE rep-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rep-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rep-prod.lote-serie 
&Scoped-define ENABLED-TABLES rep-prod
&Scoped-define FIRST-ENABLED-TABLE rep-prod
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 RECT-7 fi-disp-apr-con 
&Scoped-Define DISPLAYED-FIELDS rep-prod.nr-reporte rep-prod.it-codigo ~
rep-prod.cod-refer rep-prod.data rep-prod.nro-docto rep-prod.qt-reporte ~
rep-prod.serie-docto rep-prod.qt-estorno rep-prod.cod-depos ~
rep-prod.qt-refugo rep-prod.cod-localiz rep-prod.lote-serie ~
rep-prod.qt-apr-cond rep-prod.dt-vali-lote 
&Scoped-define DISPLAYED-TABLES rep-prod
&Scoped-define FIRST-DISPLAYED-TABLE rep-prod
&Scoped-Define DISPLAYED-OBJECTS fi-qt-estorno fi-qt-refugo fi-qt-apr-con ~
fi-dt-est fi-descricao fi-un fi-text-2 fi-text-4 fi-text-3 fi-nr-ordens ~
fi-nr-valorizadas fi-disp-estorno fi-disp-refugo fi-disp-apr-con 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-dt-est 

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
DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(60)" 
      VIEW-AS TEXT 
     SIZE 44.29 BY .67.

DEFINE VARIABLE fi-disp-apr-con AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Disp Aprov Cond" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-disp-estorno AS DECIMAL FORMAT "->>,>>9.99999":U INITIAL 0 
     LABEL "Disp Estorno" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-disp-refugo AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Disp Refugo" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-dt-est AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Estorno" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ordens AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "N£mero Ordens Reporte" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-nr-valorizadas AS CHARACTER FORMAT "X(20)":U INITIAL "0" 
     LABEL "Ordens Valorizadas" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-qt-apr-con AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Aprov Con" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-estorno AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Estorno" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-refugo AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Refugo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 23 BY .63.

DEFINE VARIABLE fi-text-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63.

DEFINE VARIABLE fi-text-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 25 BY .63.

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "xx" 
      VIEW-AS TEXT 
     SIZE 5.43 BY .67.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 5.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.92.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.96.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.57 BY 5.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-qt-estorno AT ROW 11.71 COL 63 COLON-ALIGNED
     fi-qt-refugo AT ROW 12.75 COL 63 COLON-ALIGNED
     fi-qt-apr-con AT ROW 13.79 COL 63 COLON-ALIGNED
     fi-dt-est AT ROW 14.88 COL 63 COLON-ALIGNED
     rep-prod.nr-reporte AT ROW 1.17 COL 13 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 11.72 BY .63
     rep-prod.it-codigo AT ROW 2.17 COL 13 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 17.43 BY .63
     fi-descricao AT ROW 2.17 COL 33.29 COLON-ALIGNED NO-LABEL
     fi-un AT ROW 2.17 COL 80.57 COLON-ALIGNED NO-LABEL
     rep-prod.cod-refer AT ROW 3.17 COL 13 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 12.43 BY .63
     fi-text-2 AT ROW 4.25 COL 3 NO-LABEL
     rep-prod.data AT ROW 5.29 COL 17.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 12.86 BY .63
     rep-prod.nro-docto AT ROW 5.29 COL 48.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 17.43 BY .63
     rep-prod.qt-reporte AT ROW 6.13 COL 17.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 18 BY .63
     rep-prod.serie-docto AT ROW 6.13 COL 48.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 9.43 BY .63
     rep-prod.qt-estorno AT ROW 6.92 COL 17.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 18 BY .63
     rep-prod.cod-depos AT ROW 6.92 COL 48.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 7.43 BY .63
     rep-prod.qt-refugo AT ROW 7.75 COL 17.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 18 BY .63
     rep-prod.cod-localiz AT ROW 7.75 COL 48.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 25 BY .63
     rep-prod.lote-serie AT ROW 8.54 COL 48.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 37.43 BY .63
     rep-prod.qt-apr-cond AT ROW 8.79 COL 17.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 18 BY .63
     rep-prod.dt-vali-lote AT ROW 9.33 COL 48.57 COLON-ALIGNED
           VIEW-AS TEXT 
          SIZE 12.86 BY .63
     fi-text-4 AT ROW 10.71 COL 1 COLON-ALIGNED NO-LABEL
     fi-text-3 AT ROW 10.71 COL 46 NO-LABEL
     fi-nr-ordens AT ROW 11.75 COL 24 COLON-ALIGNED
     fi-nr-valorizadas AT ROW 12.58 COL 24 COLON-ALIGNED
     fi-disp-estorno AT ROW 13.67 COL 24 COLON-ALIGNED
     fi-disp-refugo AT ROW 14.46 COL 24 COLON-ALIGNED
     fi-disp-apr-con AT ROW 15.25 COL 24 COLON-ALIGNED
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 2.17 COL 80.14
     "-" VIEW-AS TEXT
          SIZE 1.43 BY .63 AT ROW 2.17 COL 33.43
     RECT-4 AT ROW 10.96 COL 45
     RECT-5 AT ROW 4.5 COL 1
     RECT-6 AT ROW 1 COL 1
     RECT-7 AT ROW 10.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.rep-prod
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
         HEIGHT             = 15.13
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN rep-prod.cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.data IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-disp-estorno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-disp-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-est IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-nr-ordens IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-valorizadas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-apr-con IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-estorno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-text-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-text-3 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-text-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       rep-prod.lote-serie:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN rep-prod.nr-reporte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.nro-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.qt-apr-cond IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.qt-estorno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.qt-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.qt-reporte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-prod.serie-docto IN FRAME f-main
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
  {src/adm/template/row-list.i "rep-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rep-prod"}

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

  for each tt-relatorio :
      delete tt-relatorio.
  end.

  for each tt-rep-prod :
      delete tt-rep-prod.
  end.     

  /* Dispatch standard ADM method.                             */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */

  do trans on error undo, return "adm-error":

     run utp/ut-acomp.p persistent set h-acomp.
     {utp/ut-liter.i Estornando_Reporte *}
     run pi-inicializar in h-acomp (input  Return-value ).

     run pi-desabilita-cancela in h-acomp.

     create tt-rep-prod.
     buffer-copy rep-prod to tt-rep-prod
     assign tt-rep-prod.cod-versao-integracao = 001
            tt-rep-prod.data                  = input frame {&frame-name} fi-dt-est.

     {utp/ut-run.i cpp/cpapi011.p "input        table tt-rep-prod ,
                                   input-output table tt-erro     ,
                                   input        table tt-relatorio,
                                   input        yes                 " }

     run pi-finalizar in h-acomp.                                   

     if return-value = "nok" then do:
        find first tt-relatorio no-lock no-error.      
        if avail tt-relatorio and l-emite-relatorio then 
           run cpp/cp0324h.w (input table tt-relatorio).     

        find first tt-erro no-error.   
        if avail tt-erro then
           run cdp/cd0666.w (INPUT TABLE TT-ERRO).

        undo, return "adm-error".   
     end.

     /* Chamada EPC para a assign record */
     {include/i-epc003.i}

  end.   

  find first tt-relatorio no-lock no-error.      
  if avail tt-relatorio and l-emite-relatorio then 
     run cpp/cp0324h.w (input table tt-relatorio).     

  for each tt-relatorio :
      delete tt-relatorio.
  end.

  for each tt-rep-prod :
     delete tt-rep-prod.
  end.     

  find first tt-erro no-lock no-error.               
  if avail tt-erro then
     run cdp/cd0666.w (INPUT TABLE TT-ERRO).                                                     

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

  /* Dispatch standard ADM method.   
                            */
/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
 * */
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-ASSIGN-FIELDS) &then
      disable {&ADM-ASSIGN-FIELDS} with frame {&frame-name}.
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

   if avail rep-prod then do:
      find item where item.it-codigo = rep-prod.it-codigo no-lock no-error.
      assign fi-descricao = if avail item then item.desc-item
                            else "":U
             fi-un        = if avail item then item.un
                            else "":U.                                        
      {cpp/cp0326.i1}                            
   end.                                                     


  /* Dispatch standard ADM method.                             */
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  {utp/ut-liter.i Informaá‰es_Reporte mcp l}

  assign fi-text-2 = return-value
         fi-text-2:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Dados_Estorno mcp l}

  assign fi-text-3 = return-value
         fi-text-3:screen-value in frame {&frame-name} = return-value
         fi-dt-est = today.         

 {utp/ut-liter.i Informaá‰es_Adicionais mcp l}

  assign fi-text-4 = return-value
         fi-text-4:screen-value in frame {&frame-name} = return-value.     
  if  avail rep-prod then do:
      assign fi-disp-estorno = de-aux-est
             fi-disp-refugo  = de-aux-ref
             fi-disp-apr-con = de-aux-apr
             fi-qt-estorno   = de-aux-est
             fi-qt-refugo    = de-aux-ref
             fi-qt-apr-con   = de-aux-apr.

      disp rep-prod.nr-reporte
           rep-prod.it-codigo
           rep-prod.cod-depos    
           rep-prod.cod-refer         
           rep-prod.nro-docto
           rep-prod.serie-docto
           rep-prod.cod-depos
           rep-prod.cod-localiz
           rep-prod.lote-serie
           rep-prod.dt-vali-lote
           rep-prod.data
           rep-prod.qt-reporte
           rep-prod.qt-estorno
           rep-prod.qt-apr-con
           rep-prod.qt-refugo 
           i-nr-ordens @ fi-nr-ordens
           fi-nr-valorizadas
           fi-disp-estorno
           fi-disp-refugo
           fi-disp-apr-con 
           fi-qt-estorno
           fi-qt-refugo
           fi-qt-apr-con
           fi-dt-est 
           fi-descricao
           fi-un with frame {&frame-name}.   
      ASSIGN fi-nr-valorizadas:SCREEN-VALUE IN FRAME {&frame-name} = trim(STRING(i-nr-val ,"->,>>>,>>9":U)).
  end.
    /*** Chamada EPC para o display-fields ******/
    {include/i-epc006.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win
PROCEDURE local-enable-fields:
  /*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
  ------------------------------------------------------------------------------*/

  DEF VAR l-aux AS LOG INIT NO NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN get-attribute('adm-new-record').
  /* Dispatch standard ADM method. */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior. */
  &IF DEFINED(bf_man_204) &THEN
    FOR EACH ord-rep
      WHERE ord-rep.nr-reporte = INT(rep-prod.nr-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK:

      FIND FIRST ord-prod NO-LOCK
        WHERE ord-prod.nr-ord-produ = ord-rep.nr-ord-produ NO-ERROR.

      IF ord-prod.rep-prod < 4 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 57737, INPUT "":U).
        IF VALID-HANDLE(handle-p-rxihel) THEN
          RUN local-enable IN handle-p-rxihel.
        RETURN "adm-error":U.
      END.

      IF CAN-FIND(FIRST ficha-cq
        WHERE ficha-cq.nr-ficha = ord-rep.nr-ficha AND ficha-cq.situacao = 4 NO-LOCK) THEN DO:
        ASSIGN l-aux = YES.
        LEAVE.
      END.
    END.

    IF l-aux THEN DO:
      RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 31799, INPUT "":U).
      IF RETURN-VALUE <> "YES":U THEN DO:
        IF VALID-HANDLE(handle-p-rxihel) THEN
          RUN local-enable IN handle-p-rxihel. /* Brand∆o, 21/MAR/06, Roda pi para habilitar bot‰es */
        RETURN "adm-error":U.
      END.
    END.
  &ENDIF

  &if DEFINED(ADM-ASSIGN-FIELDS) &then
    ENABLE {&ADM-ASSIGN-FIELDS} WITH FRAME {&frame-name}.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  {cpp/cp0326.i1}

  {utp/ut-liter.i Informaá‰es_Reporte mcp l}

  assign fi-text-2 = return-value
         fi-text-2:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Dados_Estorno mcp l}

  assign fi-text-3 = return-value
         fi-text-3:screen-value in frame {&frame-name} = return-value.         

 {utp/ut-liter.i Informaá‰es_Adicionais mcp l}

  assign fi-text-4 = return-value
         fi-text-4:screen-value in frame {&frame-name} = return-value.                  

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail rep-prod then
     assign gr-rep-prod = rowid(rep-prod).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-variaveis V-table-Win 
PROCEDURE pi-atualiza-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-emite-relatorio   as l no-undo.

assign l-emite-relatorio   = p-emite-relatorio.

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
  {src/adm/template/snd-list.i "rep-prod"}

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
