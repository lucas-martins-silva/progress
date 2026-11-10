&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V37IN090 2.00.00.021 } /*** "010021" 17/10/2024 16:48:35 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v37in090 MUT}
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
def new global shared var gr-documento as rowid no-undo.
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
def var rw-natureza   as rowid                 no-undo.
def var l-inclui      as logical               no-undo.
def var h-handle-aux1 as handle                no-undo.
def var c-natureza like docum-est.nat-operacao no-undo.
def var i-especie     as integer               no-undo.
def var i-observa     as integer               no-undo.
def var c-via-transp  as char  format "x(15)"  no-undo.

DEF VAR oCbTipoCte     AS rep.list.TipoCteList            NO-UNDO.

{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev-transp c-placa-1 c-uf-placa-1 ~
c-placa-2 c-uf-placa-2 c-placa-3 c-uf-placa-3 i-modal c-cod-modalid-frete ~
c-des-modalid-frete cb-tipo-cte c-aviso-recolhimento c-uf-origem ~
c-situacao-aviso c-cod-ibge-orig c-cod-ibge-dest 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS i-modal 
&Scoped-define ADM-MODIFY-FIELDS i-modal 

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
DEFINE BUTTON bt-nf-saida 
     LABEL "NF Sa°da" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-tipo-cte AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo CT-e" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE i-modal AS CHARACTER FORMAT "x(256)":U 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Outros" 
     DROP-DOWN-LIST
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE c-aviso-recolhimento AS CHARACTER FORMAT "X(10)":U 
     LABEL "Aviso Recolhimento" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ibge-dest LIKE cidade.cdn-munpio-ibge
     LABEL "C¢d IBGE Munic Dest" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ibge-orig LIKE cidade.cdn-munpio-ibge
     LABEL "C¢d IBGE Munic Orig" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-modalid-frete AS CHARACTER FORMAT "X(8)":U 
     LABEL "Modalid. Frete" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-modalid-frete AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-transp AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abrev Transp" 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-placa-1 AS CHARACTER FORMAT "X(7)":U 
     LABEL "Placa 1" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-placa-2 AS CHARACTER FORMAT "X(7)":U 
     LABEL "Placa 2" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-placa-3 AS CHARACTER FORMAT "X(7)":U 
     LABEL "Placa 3" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao-aviso AS CHARACTER FORMAT "X(12)":U 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-origem AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF Orig/Dest (GIA-SP)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-placa-1 AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF 1" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-placa-2 AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF 2" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-placa-3 AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF 3" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 13.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-nome-abrev-transp AT ROW 2 COL 22.43 COLON-ALIGNED
     c-placa-1 AT ROW 3 COL 22.43 COLON-ALIGNED
     c-uf-placa-1 AT ROW 3 COL 57.14 COLON-ALIGNED
     c-placa-2 AT ROW 4 COL 22.43 COLON-ALIGNED
     c-uf-placa-2 AT ROW 4 COL 57.14 COLON-ALIGNED
     c-placa-3 AT ROW 5 COL 22.43 COLON-ALIGNED
     c-uf-placa-3 AT ROW 5 COL 57.14 COLON-ALIGNED
     i-modal AT ROW 6 COL 22.43 COLON-ALIGNED
     c-cod-modalid-frete AT ROW 7 COL 22.43 COLON-ALIGNED
     c-des-modalid-frete AT ROW 7 COL 29.72 COLON-ALIGNED NO-LABEL
     cb-tipo-cte AT ROW 8 COL 22.43 COLON-ALIGNED
     c-aviso-recolhimento AT ROW 9 COL 22.43 COLON-ALIGNED
     c-uf-origem AT ROW 9 COL 57.14 COLON-ALIGNED
     c-situacao-aviso AT ROW 10 COL 22.43 COLON-ALIGNED
     c-cod-ibge-orig AT ROW 11 COL 22.43 COLON-ALIGNED HELP
          "Munic°pio IBGE" WIDGET-ID 2
          LABEL "C¢d IBGE Munic Orig"
     c-cod-ibge-dest AT ROW 11 COL 52.86 COLON-ALIGNED HELP
          "Munic°pio IBGE" WIDGET-ID 4
          LABEL "C¢d IBGE Munic Dest"
     bt-nf-saida AT ROW 13 COL 5
     RECT-6 AT ROW 1 COL 1
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
         HEIGHT             = 13.46
         WIDTH              = 85.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-nf-saida IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-aviso-recolhimento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-ibge-dest IN FRAME f-main
   NO-ENABLE LIKE = mgcad.cidade.cdn-munpio-ibge EXP-LABEL EXP-SIZE     */
/* SETTINGS FOR FILL-IN c-cod-ibge-orig IN FRAME f-main
   NO-ENABLE LIKE = mgcad.cidade.cdn-munpio-ibge EXP-LABEL EXP-SIZE     */
/* SETTINGS FOR FILL-IN c-cod-modalid-frete IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-modalid-frete IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev-transp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-placa-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-placa-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-placa-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao-aviso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-uf-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-uf-placa-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-uf-placa-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-uf-placa-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-cte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX i-modal IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-nf-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nf-saida V-table-Win
ON CHOOSE OF bt-nf-saida IN FRAME f-main /* NF Sa°da */
DO:
    
    SESSION:SET-WAIT-STATE("general").
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO. 
    
    run rep/re1001a4.w (INPUT gr-documento,
                        INPUT "":U,
                        INPUT THIS-PROCEDURE).
    
    SESSION:SET-WAIT-STATE("").
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    
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
 
  {utp/ut-liter.i Via_Transporte * r }
  assign i-modal:label in frame {&frame-name} = return-value.
     
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find first param-estoq no-lock no-error.

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  assign input frame {&frame-name} i-modal
         docum-est.via-transp = {adinc/i01ad268.i 06 i-modal}.

  

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
 
  DEFINE VARIABLE l-cte AS LOGICAL     NO-UNDO.
  DEF VAR oModFrete AS rep.list.ModalidadeFreteCteList NO-UNDO.
 
  /* Code placed here will execute PRIOR to standard behavior. */

  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  FOR FIRST docum-est
      WHERE ROWID(docum-est) = gr-documento NO-LOCK:
  END.
 
  /* Code placed here will execute AFTER standard behavior.    */

  if  avail docum-est then do with frame {&frame-name}:
      /*********** IN÷CIO CAT 95 ***********/
      &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
          ASSIGN c-nome-abrev-transp:screen-value = docum-est.nome-transp            
                 c-placa-1:SCREEN-VALUE           = docum-est.cod-placa[1]              
                 c-placa-2:SCREEN-VALUE           = docum-est.cod-placa[2]              
                 c-placa-3:SCREEN-VALUE           = docum-est.cod-placa[3]             
                 c-uf-placa-1:SCREEN-VALUE        = docum-est.cod-uf-placa[1]           
                 c-uf-placa-2:SCREEN-VALUE        = docum-est.cod-uf-placa[2]           
                 c-uf-placa-3:SCREEN-VALUE        = docum-est.cod-uf-placa[3]
                 c-uf-origem:SCREEN-VALUE         = SUBSTRING(docum-est.char-2,211,2).
      &else
          ASSIGN c-nome-abrev-transp:screen-value = SUBSTRING(docum-est.char-2,102,12) 
                 c-placa-1:SCREEN-VALUE           = SUBSTRING(docum-est.char-2,115,7)  
                 c-placa-2:SCREEN-VALUE           = SUBSTRING(docum-est.char-2,122,7)  
                 c-placa-3:SCREEN-VALUE           = SUBSTRING(docum-est.char-2,129,7)  
                 c-uf-placa-1:SCREEN-VALUE        = SUBSTRING(docum-est.char-2,136,2)  
                 c-uf-placa-2:SCREEN-VALUE        = SUBSTRING(docum-est.char-2,138,2)  
                 c-uf-placa-3:SCREEN-VALUE        = SUBSTRING(docum-est.char-2,140,2).  
      &ENDIF
      /*********** FIM CAT 95 ***********/
      ASSIGN c-cod-modalid-frete:SCREEN-VALUE = SUBSTRING(docum-est.char-2,143,8).

      oCbTipoCte = NEW rep.list.TipoCteList().
      cb-tipo-cte:LIST-ITEM-PAIRS IN FRAME  {&FRAME-NAME} = ",," + oCbTipoCte:getLista().
      DELETE OBJECT oCbTipoCte.   
      IF SUBSTRING(docum-est.char-2,151,2) = "" THEN
         ASSIGN cb-tipo-cte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      ELSE
         ASSIGN cb-tipo-cte:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = trim(SUBSTRING(docum-est.char-2,151,2)).
      /************ Aviso Recolhimento **************/

      ASSIGN c-aviso-recolhimento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(docum-est.char-1,192,16)
             c-situacao-aviso:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "".

      FIND FIRST aviso-recolhto 
           WHERE aviso-recolhto.cod-estabel = docum-est.cod-estabel
             AND aviso-recolhto.cdn-emit    = docum-est.cod-emitente
             AND aviso-recolhto.nr-docto    = c-aviso-recolhimento:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
      IF AVAIL aviso-recolhto THEN DO:       
           IF aviso-recolhto.cod-situacao = 1 THEN  ASSIGN c-situacao-aviso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cadastrado".
           IF aviso-recolhto.cod-situacao = 2 THEN  ASSIGN c-situacao-aviso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Impresso".
           IF aviso-recolhto.cod-situacao = 3 THEN  ASSIGN c-situacao-aviso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Recebido".
      END.   

      /********Fim do Aviso de Recolhimento***********/

      /*cod-munpio-ibge*/
      ASSIGN c-cod-ibge-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(docum-est.char-2,246,10)
             c-cod-ibge-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(docum-est.char-2,236,10).
      /*****************/
      IF CAN-FIND(FIRST natur-oper
                  WHERE natur-oper.nat-operacao = docum-est.nat-operacao
                    AND natur-oper.tipo-compra = 2
                    AND natur-oper.nota-rateio = NO) THEN DO:
          
          ASSIGN bt-nf-saida:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      END.
      ELSE ASSIGN bt-nf-saida:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
          
      IF CAN-FIND(FIRST natur-oper
                  WHERE natur-oper.nat-operacao = docum-est.nat-operacao 
                    AND natur-oper.tipo-compra = 2) AND 
         SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = "57" OR 
         SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = "67" THEN DO:
         
          l-cte = YES.
          oModFrete = NEW rep.list.ModalidadeFreteCteList().
          ASSIGN c-des-modalid-frete:SCREEN-VALUE IN FRAME {&FRAME-NAME} = oModFrete:getDescricao(int(c-cod-modalid-frete:SCREEN-VALUE IN FRAME {&frame-name})).
          DELETE OBJECT oModFrete. 
      END.
      
  end.
  else do with frame {&frame-name}:
       assign c-nome-abrev-transp:screen-value  = " "
              c-placa-1:SCREEN-VALUE            = " "  
              c-placa-2:SCREEN-VALUE            = " " 
              c-placa-3:SCREEN-VALUE            = " " 
              c-uf-placa-1:SCREEN-VALUE         = " "  
              c-uf-placa-2:SCREEN-VALUE         = " "  
              c-uf-placa-3:SCREEN-VALUE         = " "
              c-uf-origem:SCREEN-VALUE          = " "
              c-cod-modalid-frete:SCREEN-VALUE  = " "
              c-aviso-recolhimento:SCREEN-VALUE = " ". 
  end.

  IF NOT l-cte THEN DO:
      FIND FIRST modalid-frete WHERE modalid-frete.cod-modalid-frete =
                                 c-cod-modalid-frete:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
      IF AVAIL modalid-frete THEN
         ASSIGN c-des-modalid-frete:SCREEN-VALUE IN FRAME {&FRAME-NAME} = modalid-frete.des-modalid-frete.
      ELSE 
         ASSIGN c-des-modalid-frete:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  END.
  
  if  avail docum-est then do with frame {&frame-name}:
      if docum-est.via-transp = 0 then do:
         i-modal:screen-value = {adinc/i01ad268.i 04 1}.
      end.   
      else do:
           assign i-modal:screen-value = {adinc/i01ad268.i 04 docum-est.via-transp}.
      end.   
  end.
  else do with frame {&frame-name}:
       i-modal:screen-value = {adinc/i01ad268.i 04 1}.
  end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
   assign i-modal:list-items in frame {&frame-name} = {adinc/i01ad268.i 03}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
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
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

