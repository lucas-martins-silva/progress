&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Q01IN065 2.00.00.024 } /*** 010024 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Q01IN065 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:  

  Description: from QUERY.W - Template For Query objects in the ADM

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
&Scop adm-attribute-dlg support/queryd.w
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

define new global shared var gr-contrato-for as rowid no-undo.

def var c-nr-contrato like contrato-for.nr-contrato no-undo.
def var i-origem as integer no-undo.
def var l-cancelar as logical no-undo.
def var i-seq as integer no-undo.
def var i-num-ord as integer no-undo.
def var i-numero-ordem as integer no-undo.
def var i-cont as integer no-undo.
def var c-contrato-dest like contrato-for.nr-contrato no-undo.

def buffer b-contrato-for for contrato-for.
def buffer b-item-contrat for item-contrat.
def buffer b-evento       for event-mod-contrat.
def buffer b-matriz-item  for matriz-rat-item.
def buffer b-formula      for formula-reaj.
def buffer b-clausula     for clausula-contrat.
def buffer b-anexo        for anexo-contrat.

def temp-table tt-aux-clausula 
    field marca     as char format "x(1)" label "   "
    field seq       as integer
    field descricao as char format "x(90)".

def temp-table tt-aux-anexo
    field marca     as char format "x(1)" label "   "
    field seq       as integer
    field descricao as char format "x(90)".

def temp-table tt-aux-item 
    field marca         as char format "x(1)" label "   "
    field num-seq-item  like item-contrat.num-seq-item
    field it-codigo     like item-contrat.it-codigo
    field un            like item.un
    field narrat-compra like item-contrat.narrat-compra.

def temp-table tt-item-contrat
    field nr-contrato  like item-contrat.nr-contrato
    field num-seq-item like item-contrat.num-seq-item
    field it-codigo    like item-contrat.it-codigo
    field preco-fornec like item-contrat.preco-fornec
    field qtd-total    like item-contrat.qtd-total
    field perc-compra  like item-fornec.perc-compra
    field r-rowid      as   rowid.

def temp-table tt-item-contrat-aux
    field nr-contrato      like item-contrat.nr-contrato
    field num-seq-item-ant like item-contrat.num-seq-item
    field num-seq-item-pos like item-contrat.num-seq-item
    field it-codigo        like item-contrat.it-codigo
    field preco-fornec like item-contrat.preco-fornec
    field qtd-total    like item-contrat.qtd-total
    field perc-compra  like item-fornec.perc-compra
    field r-rowid      as   rowid.

def new global shared var r-num-ped as rowid   no-undo.
def var l-erro as log no-undo.

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*Se este c¢digo for aberto no appbuilder, ap¢s salvo ser† necess†rio abrir o fonte em 
no modo de ediá∆o e remover as vari†veis abaixo que v∆o ser inclu°das autom†ticamente.
Fazer um merge com o fonte que est† est† na rede e verificar o que foi inclu°do 
autom†ticamente e remover.*/

&Scoped-define QUERY-NAME Query-Main
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main contrato-for


&Scoped-define KEY-PHRASE TRUE NO-LOCK 

{include/i-estab-security.i}


/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES contrato-for

/* Define KEY-PHRASE in case it is used by any query. */

/* Definitions for QUERY Query-Main                                     */
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH contrato-for 

&Scoped-define TABLES-IN-QUERY-Query-Main contrato-for


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" q-tables _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-comprado||y|mgind.contrato-for.cod-comprado
nr-contrato||y|mgind.contrato-for.nr-contrato
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-comprado,nr-contrato"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" q-tables _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Query definitions                                                    */

/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.33
         WIDTH              = 22.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "mgind.contrato-for"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Design-Parent    is WINDOW q-tables @ ( 1.17 , 9.86 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm/method/query.i}
{include/c-query.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases q-tables adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query-cases q-tables adm/support/_adm-opn.p
PROCEDURE local-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

  /*Code placed here will execite PRIOR ro standard behavior*/
  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN
    {include/i-estab-openquery.i}
  &ELSE
    RUN dispatch IN THIS-PROCEDURE (INPUT 'open-query-cases':U).
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize q-tables 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if gr-contrato-for <> ?
    then do: 
       RUN dispatch IN THIS-PROCEDURE ('open-query':U ) .
       RUN pi-reposiciona-query (input gr-contrato-for).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relacionamentos q-tables 
PROCEDURE pi-gera-relacionamentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN set-cursor IN adm-broker-hdl (INPUT "WAIT":u).
  case i-origem:
       when 1 then do:
            assign i-seq = 1.
            repeat:
                if CAN-FIND(last b-clausula WHERE
                                 b-clausula.nr-contrat = c-contrato-dest and
                                 b-clausula.num-seq-claus = i-seq) then 
                    assign i-seq = i-seq + 1.
                  else
                     leave.
             end.

            for each tt-aux-clausula where tt-aux-clausula.marca = "*":
                find clausula-mod where
                     clausula-mod.nr-contrato = c-nr-contrato and
                     clausula-mod.num-seq-clausula-model = tt-aux-clausula.seq
                     no-lock no-error.
                create clausula-contrat.
                assign clausula-contrat.nr-contrato        = c-contrato-dest
                       clausula-contrat.des-clausula      = clausula-mod.des-clausula
                       clausula-contrat.narrat-claus      = clausula-mod.narrat-claus
                       clausula-contrat.ind-sit-clausula  = 1
                       clausula-contrat.usuario           = c-seg-usuario
                       clausula-contrat.hra-alter         = string(time,"HH:MM:SS")
                       clausula-contrat.dat-revisao       = today
                       clausula-contrat.nr-alter          = 1
                       clausula-contrat.num-seq-claus     = i-seq
                       i-seq                              = i-seq + 1.
            end.

            assign i-seq = 1.
            repeat:
                if CAN-FIND(last b-anexo WHERE
                                 b-anexo.nr-contrat = c-contrato-dest and
                                      b-anexo.num-seq-anex = i-seq) then 
                    assign i-seq = i-seq + 1.
                 else
                     leave.
            end.

            for each tt-aux-anexo where tt-aux-anexo.marca = "*":
                find anexo-mod where
                     anexo-mod.nr-contrato = c-nr-contrato and
                     anexo-mod.num-seq-anexo-mod = tt-aux-anexo.seq
                     no-lock no-error.
                create anexo-contrat.
                assign anexo-contrat.nr-contrato    = c-contrato-dest
                       anexo-contrat.des-anexo     = anexo-mod.des-anexo
                       anexo-contrat.narrat-anex   = anexo-mod.narrat-anex
                       anexo-contrat.ind-sit-anex  = 1
                       anexo-contrat.usuario       = c-seg-usuario
                       anexo-contrat.hra-alter     = string(time,"HH:MM:SS")
                       anexo-contrat.dat-revisao   = today
                       anexo-contrat.nr-alter      = 1.

                assign anexo-contrat.num-seq-anex  = i-seq
                       i-seq                       = i-seq + 1.
            end. 
       end.

       when 2 then do:  
            assign i-seq = 1.
            repeat:
                if CAN-FIND(last b-item-contrat WHERE
                                 b-item-contrat.nr-contrat = c-contrato-dest and
                                 b-item-contrat.num-seq-item = i-seq) then 
                    assign i-seq = i-seq + 1.
                else
                    leave.
            end.

            for each tt-aux-item where tt-aux-item.marca = "*":
                find b-item-contrat where 
                     b-item-contrat.nr-contrato = c-nr-contrato and
                     b-item-contrat.num-seq-item = tt-aux-item.num-seq-item
                     no-lock no-error.
                if avail b-item-contrat then do:
                   {cnp/cn0201j.i}
                    assign i-seq = i-seq + 1.
                end.
            end.

            assign i-seq = 1.
            repeat:
                if CAN-FIND(last b-clausula WHERE
                                 b-clausula.nr-contrat = c-contrato-dest and
                                  b-clausula.num-seq-claus = i-seq) then 
                    assign i-seq = i-seq + 1.
                  else
                     leave.
            end.

            for each tt-aux-clausula where tt-aux-clausula.marca = "*":
                find clausula-contrat where
                     clausula-contrat.nr-contrato = c-nr-contrato and
                     clausula-contrat.num-seq-clausula = tt-aux-clausula.seq
                     no-lock no-error.
                create b-clausula.
                assign b-clausula.nr-contrat        = c-contrato-dest
                       b-clausula.des-clausula      = clausula-contrat.des-clausula
                       b-clausula.narrat-claus      = clausula-contrat.narrat-claus
                       b-clausula.ind-sit-clausula  = 1
                       b-clausula.usuario           = c-seg-usuario
                       b-clausula.hra-alter         = string(time,"HH:MM:SS")
                       b-clausula.dat-revisao       = today
                       b-clausula.nr-alter          = clausula-contrat.nr-alter
                       b-clausula.num-seq-claus     = i-seq
                       i-seq                        = i-seq + 1.
            end.

            assign i-seq = 1.
            repeat:
                if CAN-FIND(last b-anexo WHERE
                                 b-anexo.nr-contrat = c-contrato-dest and
                                 b-anexo.num-seq-anex = i-seq) then 
                    assign i-seq = i-seq + 1.
                else
                    leave.
            end.

            for each tt-aux-anexo where tt-aux-anexo.marca = "*":
                find anexo-contrat where
                     anexo-contrat.nr-contrato = c-nr-contrato and
                     anexo-contrat.num-seq-anexo = tt-aux-anexo.seq
                     no-lock no-error.
                create b-anexo.
                assign b-anexo.nr-contrat    = c-contrato-dest
                       b-anexo.des-anexo     = anexo-contrat.des-anexo
                       b-anexo.narrat-anex   = anexo-contrat.narrat-anex
                       b-anexo.ind-sit-anex  = 1
                       b-anexo.usuario       = c-seg-usuario
                       b-anexo.hra-alter     = string(time,"HH:MM:SS")
                       b-anexo.dat-revisao   = today
                       b-anexo.nr-alter      = anexo-contrat.nr-alter.
                if i-seq = param-contrat.num-seq-anexo-item then
                   assign i-seq = i-seq + 1.
                assign b-anexo.num-seq-anex  = i-seq
                       i-seq                 = i-seq + 1.
            end.         
       end.
  end case.

  RUN notify ('open-query,record-target':U).
  RUN set-cursor IN adm-broker-hdl (INPUT "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-rowid q-tables 
PROCEDURE pi-retorna-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output parameter p-rowid as rowid no-undo.
    assign p-rowid = if available contrato-for then rowid(contrato-for) else ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key q-tables adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-comprado" "contrato-for" "cod-comprado"}
  {src/adm/template/sndkycas.i "nr-contrato" "contrato-for" "nr-contrato"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "contrato-for"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).


    /**********    
  if p-state = "Copia" then do:
     find first param-contrat no-lock no-error.
     assign c-nr-contrato   = contrato-for.nr-contrato
            c-contrato-dest = ""
            i-origem        = 2.
     run cnp/cn0201h.w (input-output c-nr-contrato,
                        input-output i-origem,
                        input-output c-contrato-dest,
                        output       l-cancelar,
                        input        yes,
                        input        yes). 
     if not l-cancelar then do:
        case i-origem:
             when 1 then do:  
                  for each tt-aux-clausula:
                      delete tt-aux-clausula.
                  end.
                  for each  clausula-mod
                      where clausula-mod.nr-contrato  = c-nr-contrato NO-LOCK:
                      create tt-aux-clausula.
                      assign tt-aux-clausula.seq       = clausula-mod.num-seq-clausula
                             tt-aux-clausula.descricao = clausula-mod.des-clausula.
                  end.

                  find first tt-aux-clausula no-error.
                  if avail tt-aux-clausula then do:
                     {utp/ut-table.i mgind clausula-mod 1}
                     run cnp/cn0201i.w (input-output table tt-aux-clausula,
                                        input return-value,
                                        output l-cancelar).
                     if l-cancelar then
                        for each tt-aux-clausula:
                            delete tt-aux-clausula.
                        end.
                  end.

                  for each tt-aux-anexo:
                      delete tt-aux-anexo.
                  end.
                  for each  anexo-mod 
                      where anexo-mod.nr-contrato  = c-nr-contrato NO-LOCK:
                      create tt-aux-anexo.
                      assign tt-aux-anexo.seq       = anexo-mod.num-seq-anexo
                             tt-aux-anexo.descricao = anexo-mod.des-anexo.
                  end.

                  find first tt-aux-anexo no-error.
                  if avail tt-aux-anexo then do:
                     {utp/ut-table.i mgind anexo-mod 1}
                     run cnp/cn0201i.w (input-output table tt-aux-anexo,
                                        input return-value,
                                        output l-cancelar).
                     if l-cancelar then
                        for each tt-aux-anexo:
                            delete tt-aux-anexo.
                        end.
                  end.

                  find first contrat-modelo 
                       where contrat-modelo.nr-contrato = c-nr-contrato
                  no-lock no-error.
                  if valid-handle(wh-programa) then return.
                  RUN get-attribute ('ProgIncMod':U).
                  IF RETURN-VALUE <>  ? AND 
                     RETURN-VALUE <> "":U THEN DO:             
                     ASSIGN V-ROW-TABLE = ROWID(contrat-modelo).

                     run value(RETURN-VALUE) persistent 
                         set wh-programa (input-output v-row-table, 
                                          input "inclui":u, 
                                          input this-procedure).
                     run dispatch in wh-programa (input 'initialize':u).
                     run notify in wh-programa (input 'add-record':u).
                     run pi-copia-modelo in wh-programa.
                     RUN pi-entry in wh-programa.
                  END.
             end.

             when 2 then do:
                  for each tt-aux-item:
                      delete tt-aux-item.
                  end.
                  for each  item-contrat 
                      where item-contrat.nr-contrato  = c-nr-contrato NO-LOCK,
                      each  item where item.it-codigo = item-contrat.it-codigo NO-LOCK:
                      create tt-aux-item.
                      assign tt-aux-item.num-seq-item  = item-contrat.num-seq-item
                             tt-aux-item.it-codigo     = item-contrat.it-codigo
                             tt-aux-item.un            = item.un
                             tt-aux-item.narrat-compra = item-contrat.narrat-compra.
                  end.

                  find first tt-aux-item no-error.
                  if avail tt-aux-item then do:
                     run cnp/cn0201j.w (input-output table tt-aux-item,
                                        output l-cancelar).
                     if l-cancelar then
                        for each tt-aux-item:
                            delete tt-aux-item.
                        end.
                  end.

                  for each tt-aux-clausula:
                      delete tt-aux-clausula.
                  end.
                  for each  clausula-contrat 
                      where clausula-contrat.nr-contrato  = c-nr-contrato NO-LOCK:
                      create tt-aux-clausula.
                      assign tt-aux-clausula.seq       = clausula-contrat.num-seq-clausula
                             tt-aux-clausula.descricao = clausula-contrat.des-clausula.
                  end.

                  find first tt-aux-clausula no-error.
                  if avail tt-aux-clausula then do:
                     {utp/ut-table.i mgind clausula-contrat 1}
                     run cnp/cn0201i.w (input-output table tt-aux-clausula,
                                        input return-value,
                                        output l-cancelar).
                     if l-cancelar then
                        for each tt-aux-clausula:
                            delete tt-aux-clausula.
                        end.
                  end.

                  for each tt-aux-anexo:
                      delete tt-aux-anexo.
                  end.
                  for each  anexo-contrat 
                      where anexo-contrat.nr-contrato  = c-nr-contrato NO-LOCK:
                      create tt-aux-anexo.
                      assign tt-aux-anexo.seq       = anexo-contrat.num-seq-anexo
                             tt-aux-anexo.descricao = anexo-contrat.des-anexo.
                  end.

                  find first tt-aux-anexo no-error.
                  if avail tt-aux-anexo then do:
                     {utp/ut-table.i mgind anexo-contrat 1}
                     run cnp/cn0201i.w (input-output table tt-aux-anexo,
                                        input return-value,
                                        output l-cancelar).
                     if l-cancelar then
                        for each tt-aux-anexo:
                            delete tt-aux-anexo.
                        end.
                  end.

                  find first b-contrato-for 
                       where b-contrato-for.nr-contrato = c-nr-contrato
                  no-lock no-error.
                  if avail b-contrato-for then do:
                     RUN pi-reposiciona-query (input rowid (b-contrato-for)).
                     run pi-trata-state (p-issuer-hdl, p-state).
                  end.
             end.
        end case.
        run pi-seta-nr-contrato in wh-programa (input c-contrato-dest).
     end.
  end.
  else run pi-trata-state (p-issuer-hdl, p-state).
  **********/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


