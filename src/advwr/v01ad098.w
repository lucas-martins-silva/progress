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
{include/i-prgvrs.i V01AD098 2.00.00.016 } /*** "010016" 25/06/2025 16:21:12  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad098 MUT}
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

define new global shared var gr-emitente as rowid no-undo.

{include/i-vrtab.i emitente}
{include/i-vrtab.i grupo-fornec}

/* miniflexibilização */
{include/i_dbvers.i}

{cdp/cdcfgfin.i}

define new global shared var c-emit-cd0401 like emitente.nome-abrev.

define var c-container  as char    no-undo.
define var i-cont       as integer no-undo.
define var i-opcao      as integer no-undo.
define var sequencia    as integer no-undo.
define var l-existe     as logical no-undo.
define var wh-container as handle  no-undo.
define var wh-painel    as handle  no-undo.
define var wh-query     as handle  no-undo.
define var r-emitente   as rowid   no-undo.
define var r-reg        as rowid   no-undo.
define var l-status     as logical no-undo.
define var d-num-emi       like emitente.cod-emitente no-undo.
define var c-nome-anterior like emitente.nome-abrev   no-undo.
define var i-ult-emitente  like emitente.cod-emitente no-undo.

define buffer b-emitente-aux for emitente.
define buffer b-fluxo-caixa  for fluxo-caixa.
define buffer b-titulo       for titulo.
define buffer b-mov-tit      for mov-tit.
define buffer b-tit-ap       for tit-ap.
define buffer b-mov-ap       for mov-ap.
define buffer b-emitente     for emitente.

/*************Multiplanta********************/

define var i-tipo-movto as integer no-undo.
define var l-cria       as logical initial no no-undo.
define var i-for-aux    like emitente.cod-emitente.

DEF VAR l-funcao-portador-ap AS LOG NO-UNDO.

/* verifica função */
{include/getdefinedfunction.i}
ASSIGN l-funcao-portador-ap = &if defined(BF_FIN_PORTADOR_AP) &then yes &else GetDefinedFunction("SPP-PORTADOR-AP") &endif.

{cdp/cd7300.i1}
{cdp/cdapi229.i}

/************Fim*****************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.nome-abrev emitente.cod-gr-forn 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome-abrev ~{&FP2}nome-abrev ~{&FP3}~
 ~{&FP1}cod-gr-forn ~{&FP2}cod-gr-forn ~{&FP3}
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS emitente.cod-emitente emitente.nome-abrev ~
emitente.cod-gr-forn 
&Scoped-Define DISPLAYED-OBJECTS c-nome-gr 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS emitente.cod-emitente 

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
DEFINE VARIABLE c-nome-gr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.cod-emitente AT ROW 1.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     emitente.nome-abrev AT ROW 2.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     emitente.cod-gr-forn AT ROW 3.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-nome-gr AT ROW 3.25 COL 34 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
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
         HEIGHT             = 3.63
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN c-nome-gr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN emitente.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME emitente.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-emitente V-table-Win
ON LEAVE OF emitente.cod-emitente IN FRAME f-main /* C¢digo */
DO:
  /*verifica se o emitente ja esta cadastrado como cliente ,
    se ja estiver forca sair do inclui e entra na opcao modifica movendo 3 para o identific*/

  do with frame {&frame-name} : 
      assign l-existe = no. 
      find emitente where emitente.cod-emitente = integer(emitente.cod-emitente:screen-value) NO-LOCK no-error.
      if avail emitente  then do:
         if emitente.identific = 1 then do:
           l-existe = yes.
           disp emitente.nome-abrev @ emitente.nome-abrev.
           ASSIGN r-emitente = ROWID(EMITENTE).
           RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) . /*cancela a opcao inclusao */

           find emitente where rowid(emitente) = r-emitente EXCLUSIVE-LOCK NO-ERROR.
           assign emitente.identific = 3.

           RUN dispatch IN wh-query ( INPUT 'open-query':U ) . /*reabre a query*/
           RUN pi-reposiciona-query IN wh-query (r-emitente).  /*reposiciona no registro informado pelo usuario*/
           RUN pi-alterar IN wh-painel. /*entra na opcao modifica*/
         end.  
      end.     
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.cod-gr-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-gr-forn V-table-Win
ON F5 OF emitente.cod-gr-forn IN FRAME f-main /* Grupo */
DO:
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z01ad131.w
                   &campo=emitente.cod-gr-forn
                   &campozoom=cod-gr-forn}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-gr-forn V-table-Win
ON LEAVE OF emitente.cod-gr-forn IN FRAME f-main /* Grupo */
DO:
  {include/leave.i &tabela=grupo-fornec
                   &atributo-ref=descricao
                   &variavel-ref=c-nome-gr
                   &where="grupo-fornec.cod-gr-forn = input frame {&frame-name} emitente.cod-gr-forn"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-gr-forn V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.cod-gr-forn IN FRAME f-main /* Grupo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nome-abrev V-table-Win
ON LEAVE OF emitente.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:
  c-emit-cd0401 = input frame {&frame-name} emitente.nome-abrev.

  if emitente.cod-emitente:sensitive = no then do:

     if input frame {&frame-name} emitente.nome-abrev <> emitente.nome-abrev then do:
         run utp/ut-msgs.p (input "show",
                            input 26,
                            input "").
         if return-value = "no" then do:
            RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
         end.
     end.                            
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
find first param-global no-lock no-error.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

assign i-for-aux= int(fill("9",length(emitente.cod-emitente:format in frame {&FRAME-NAME}))).

if emitente.cod-gr-forn:load-mouse-pointer('image/lupa.cur') then.

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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */

     find last emitente no-lock no-error.
     if  avail emitente then do:
         if  emitente.cod-emitente < i-for-aux then
             assign d-num-emi = emitente.cod-emitente + 1.
         else do:
             assign d-num-emi = 1.
             repeat:
                find emitente 
                     where emitente.cod-emitente = d-num-emi no-lock no-error.
                if  not avail emitente then 
                    leave.
                else
                    assign d-num-emi = d-num-emi + 1.
            end.
        end.
     end.
     else
        assign d-num-emi = 1.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   disp d-num-emi @ emitente.cod-emitente with frame {&FRAME-NAME}.

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

     do with frame {&frame-name} :
        if emitente.cod-emitente:sensitive then do:
           if can-find(emitente where emitente.cod-emitente = integer(emitente.cod-emitente:screen-value)) then do:

                 run utp/ut-msgs.p (input "show",
                                    input 8330,
                                    input "").      
                 if return-value = "yes" then do:
                    find last b-emitente no-lock no-error.
                    if avail b-emitente then do:
                       if b-emitente.cod-emitente < i-for-aux then
                          assign i-ult-emitente = b-emitente.cod-emitente + 1.
                       else do:
                          assign i-ult-emitente = 1.
                          repeat:
                             find b-emitente 
                                  where b-emitente.cod-emitente = i-ult-emitente no-lock no-error.
                             if  not avail b-emitente then 
                                 leave.
                             else
                                 assign i-ult-emitente = i-ult-emitente + 1.
                          end.
                       end.
                    end.
                    else assign i-ult-emitente = 1.
                    assign emitente.cod-emitente:screen-value in frame {&frame-name} = string(i-ult-emitente).
                 end.
                 else do:
                    apply "entry" to emitente.cod-emitente in frame {&frame-name}.
                    return 'ADM-ERROR':U.                 
                 end.
           end.   
        end.

        find first b-emitente no-lock 
             where b-emitente.nome-abrev = input frame {&frame-name} emitente.nome-abrev no-error.

        if  avail b-emitente and b-emitente.cod-emitente <> input frame {&frame-name} emitente.cod-emitente then do:
            run utp/ut-msgs.p (input "show",
                               input 2811,
                               input "").
            apply "entry" to emitente.nome-abrev in frame {&frame-name}.
            return "adm-error":U.                     
        end.
     end. 

  /* Ponha aqui as demais valida‡äes */
   if  avail emitente
   and input frame {&frame-name} emitente.nome-abrev <> emitente.nome-abrev then do:
      assign c-nome-anterior = emitente.nome-abrev.
   end.          

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

 /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .


  IF RETURN-VALUE = 'ADM-ERROR':U THEN 
     RETURN 'ADM-ERROR':U.   
  assign i-cont = 0.
  if  avail emitente
  and emitente.nome-abrev <> c-nome-anterior then do:
     for each b-titulo use-index emitente
         where b-titulo.cod-emitente = emitente.cod-emitente no-lock :
         assign r-reg = rowid(b-titulo).
         find titulo where rowid(titulo) = r-reg EXCLUSIVE-LOCK NO-ERROR.
         assign titulo.nome-abrev = emitente.nome-abrev.
         for each b-mov-tit
             where b-mov-tit.ep-codigo   = titulo.ep-codigo
               and b-mov-tit.cod-estabel = titulo.cod-estabel
               and b-mov-tit.cod-esp     = titulo.cod-esp
               and b-mov-tit.nr-docto    = titulo.nr-docto
               and b-mov-tit.serie       = titulo.serie
               and b-mov-tit.parcela     = titulo.parcela no-lock:
               assign r-reg = rowid (b-mov-tit).
               find mov-tit
                    where rowid(mov-tit) = r-reg EXCLUSIVE-LOCK NO-ERROR.
               assign mov-tit.nome-abrev = emitente.nome-abrev.
               release mov-tit.
          end.
          {utp/ut-liter.i Alterando_Nome_Abreviado}
          assign i-cont = i-cont + 1. 
          status input trim(return-value) + string(i-cont).
          release titulo.
     end.      
     for each b-fluxo-caixa use-index nr-fluxo 
         where b-fluxo-caixa.nome-abrev = c-nome-anterior no-lock:
         assign r-reg = rowid(b-fluxo-caixa).
         find fluxo-caixa
              where rowid(fluxo-caixa) = r-reg EXCLUSIVE-LOCK NO-ERROR.
         assign fluxo-caixa.nome-abrev = emitente.nome-abrev.
         {utp/ut-liter.i Alterando_Nome_Abreviado}
          assign i-cont = i-cont + 1 .
          status input trim(return-value) + string(i-cont).
          release fluxo-caixa.
     end.
     for each b-tit-ap 
         where b-tit-ap.cod-fornec = emitente.cod-emitente no-lock:
         assign r-reg = rowid(b-tit-ap).
         find tit-ap
              where rowid(tit-ap) = r-reg EXCLUSIVE-LOCK NO-ERROR.
         assign tit-ap.nome-abrev = emitente.nome-abrev.
         for each b-mov-ap 
             where b-mov-ap.ep-codigo   = tit-ap.ep-codigo
               and b-mov-ap.cod-estabel = tit-ap.cod-estabel
               and b-mov-ap.cod-esp     = tit-ap.cod-esp
               and b-mov-ap.serie       = tit-ap.serie
               and b-mov-ap.nr-docto    = tit-ap.nr-docto
               and b-mov-ap.parcela     = tit-ap.parcela
               and b-mov-ap.cod-fornec  = tit-ap.cod-fornec no-lock:
               assign r-reg = rowid(b-mov-ap).
               find mov-ap
                    where rowid(mov-ap) = r-reg EXCLUSIVE-LOCK NO-ERROR.
               assign mov-ap.nome-abrev = emitente.nome-abrev.
               release mov-ap.
           end.
           {utp/ut-liter.i Alterando_Nome_Abreviado}
           assign i-cont = i-cont + 1 .
           status input trim(return-value) + string(i-cont).

           release tit-ap.    
     end.   
  end. 

  /* Code placed here will execute AFTER standard behavior.    */
  do transaction:
     do with frame {&frame-name}:
        find current emitente exclusive-lock  no-error. /*posiciona no registro corrente */
        if l-existe = yes then do:
           assign emitente.identific = 3.
           for each cont-emit    
               where cont-emit.cod-emitente = emitente.cod-emitente exclusive-lock:
               assign cont-emit.identific = 3.
           end.
        end.   
        else assign emitente.identific = 2.
      end.      
  end.


  find grupo-fornec 
       where grupo-fornec.cod-gr-forn = input frame {&FRAME-NAME} emitente.cod-gr-forn no-lock no-error.
   if not avail grupo-fornec then do:
      run utp/ut-msgs.p (input "show",
                         input 4278,
                         input "").

      apply 'entry' to emitente.cod-gr-forn.
      return 'adm-error'.
    end.  

  /* Code placed here will execute AFTER standard behavior.    */




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if l-existe = yes 
  and emitente.identific = 3 then do:
     do transaction :
        find emitente 
             where emitente.cod-emitente = input frame {&frame-name} emitente.cod-emitente
             EXCLUSIVE-LOCK NO-ERROR.
        assign emitente.identific  = 1.
     end.       
     run dispatch in wh-query('open-query':U).

  end.         


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  do with frame {&frame-name}:
     find first b-emitente 
          where b-emitente.nome-abrev  <> emitente.nome-abrev:screen-value
            and b-emitente.nome-matriz =  emitente.nome-abrev:screen-value
            and b-emitente.identific   <> 1 no-lock no-error.
     if avail b-emitente then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Fornecedor" *}
        run utp/ut-msgs.p (input "show",
                           input 81,
                           input RETURN-VALUE).
        return "adm-error":U.
     end.
     find first est-ap 
          where est-ap.cod-fornec = integer(emitente.cod-emitente:screen-value) EXCLUSIVE-LOCK no-error.
     if avail est-ap then
        delete est-ap.
     if emitente.identific <> 3 then do :
        for each his-emit 
            where his-emit.cod-emitente = emitente.cod-emitente exclusive-lock:
            delete his-emit.
        end.
        for each cont-emit  
            where cont-emit.cod-emitente = emitente.cod-emitente  exclusive-lock:
             if cont-emit.identific = 2 then 
                delete cont-emit.
             if cont-emit.identific = 3 then
                assign cont-emit.identific = 1.   
        end.   
        assign i-opcao = 3.      
        {cdp/cd0401.i2} /*gera imagem do fornecedor*/
     end.   
  end.

  /* Dispatch standard ADM method.                             */
  if emitente.identific <> 3 then 
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  else do:
     find b-emitente where b-emitente.cod-emitente = integer(emitente.cod-emitente:screen-value) EXCLUSIVE-LOCK no-error.
     if  avail b-emitente then
         assign b-emitente.identific = 1.
  end.  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  if avail emitente then do:
      find first grupo-fornec 
           where grupo-fornec.cod-gr-forn = emitente.cod-gr-forn 
           no-lock no-error.
      assign c-nome-gr = if avail grupo-fornec
                         then grupo-fornec.descricao 
                         else "":U.
  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if  avail emitente then 
      assign gr-emitente = rowid(emitente).

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if  avail emitente then do:
      assign gr-emitente = rowid(emitente).
      find grupo-fornec where grupo-fornec.cod-gr-forn = emitente.cod-gr-forn no-lock no-error.
      if  avail grupo-fornec then 
          assign gr-grupo-fornec = rowid(grupo-fornec).
  end.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-recebe-handle V-table-Win 
PROCEDURE p-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER h_p-cadsim AS HANDLE.
  DEF INPUT PARAMETER h_q01ad098 AS HANDLE.

  /*wh-painel recebe o handle do painel de cadastro simples.
    wh-query  recebe o handle da query de fornecedor      */

   ASSIGN wh-painel = h_p-cadsim
          wh-query  = h_q01ad098 .

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

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


