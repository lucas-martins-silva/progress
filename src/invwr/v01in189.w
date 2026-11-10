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
{include/i-prgvrs.i V01IN189 2.00.00.025 } /*** "010025" 09/01/2026 14:41:39  ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in189 MUT}
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
{include/i-vrtab.i localizacao}

/* Parameters Definitions ---                                           */
define buffer b-localizacao for localizacao.

/* Local Variable Definitions ---                                       */

define variable r-localizacao   as rowid no-undo.
define variable gr-localizacao  as rowid no-undo.

{bhp/bh9999.i1}

/** Integraá∆o MES X PPI-Multitask **/
DEFINE VARIABLE h-cdapi1003     AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-cdapi990      AS HANDLE       NO-UNDO.
DEFINE VARIABLE cXML            AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cXMLAux         AS LONGCHAR     NO-UNDO.
DEFINE VARIABLE cChave          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-des-msg-ret   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hShowMsg        AS HANDLE       NO-UNDO.

{cdp/cdcfgman.i}
{com/totvs/datasul/eai/include/error.i } /* rowErrors*/
{cdp/cdapi990.i2} /* tt-cria-pendencia */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES localizacao
&Scoped-define FIRST-EXTERNAL-TABLE localizacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR localizacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS localizacao.descricao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}
&Scoped-define ENABLED-TABLES localizacao
&Scoped-define FIRST-ENABLED-TABLE localizacao
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS localizacao.cod-estabel ~
localizacao.cod-depos localizacao.cod-localiz localizacao.descricao 
&Scoped-Define DISPLAYED-OBJECTS c-estabelec c-deposito 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS localizacao.cod-estabel ~
localizacao.cod-depos localizacao.cod-localiz localizacao.descricao 
&Scoped-define ADM-ASSIGN-FIELDS localizacao.cod-estabel ~
localizacao.cod-depos localizacao.cod-localiz localizacao.descricao 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-deposito AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.72 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     localizacao.cod-estabel AT ROW 1.17 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-estabelec AT ROW 1.17 COL 34.43 COLON-ALIGNED NO-LABEL
     localizacao.cod-depos AT ROW 2.17 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-deposito AT ROW 2.17 COL 34.43 COLON-ALIGNED NO-LABEL
     localizacao.cod-localiz AT ROW 3.17 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     localizacao.descricao AT ROW 4.58 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.localizacao
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
         HEIGHT             = 4.71
         WIDTH              = 89.72.
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

/* SETTINGS FOR FILL-IN c-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN localizacao.cod-depos IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN localizacao.cod-estabel IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN localizacao.cod-localiz IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN localizacao.descricao IN FRAME f-main
   1 2                                                                  */
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

&Scoped-define SELF-NAME localizacao.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL localizacao.cod-depos V-table-Win
ON F5 OF localizacao.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in084.w"
                 &tabela=localizacao
                 &atributo=cod-depos} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL localizacao.cod-depos V-table-Win
ON LEAVE OF localizacao.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-deposito
                   &where="deposito.cod-depos = input frame {&frame-name} localizacao.cod-depos"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL localizacao.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF localizacao.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME localizacao.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL localizacao.cod-estabel V-table-Win
ON F5 OF localizacao.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                  &tabela=localizacao
                  &atributo=cod-estabel} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL localizacao.cod-estabel V-table-Win
ON LEAVE OF localizacao.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-estabelec
                   &where="estabelec.cod-estabel = input frame {&frame-name} localizacao.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL localizacao.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF localizacao.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  FIND FIRST param-global no-lock no-error.     
  IF localizacao.cod-estabel:load-mouse-pointer ("image~\lupa.cur") IN FRAME {&frame-name} THEN.   
  IF localizacao.cod-depos:load-mouse-pointer ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
 
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

  /* No Foreign keys are accepted by this SmartObject. */

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
  {src/adm/template/row-list.i "localizacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "localizacao"}

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
  
  if  (localizacao.cod-estabel:sensitive in frame {&frame-name} = yes
  and  localizacao.cod-depos:sensitive   in frame {&frame-name} = yes
  and  localizacao.cod-localiz:sensitive in frame {&frame-name} = yes)
  and  can-find (b-localizacao
         where b-localizacao.cod-estabel = input frame {&frame-name} localizacao.cod-estabel
         and   b-localizacao.cod-depos   = input frame {&frame-name} localizacao.cod-depos
         and   b-localizacao.cod-localiz = input frame {&frame-name} localizacao.cod-localiz no-lock) then do: 
      {utp/ut-field.i mgind localizacao cod-localiz 1}  
      run utp/ut-msgs.p (input "show", input 7, input return-value).
   

    return 'ADM-ERROR':U.
    
  end.  /* if */

  /* Ponha aqui as demais validaá‰es */
  
  /** Validaá∆o do c¢digo do estabelecimento **/
  if (input frame {&frame-name} localizacao.cod-estabel = " " ) or
     not can-find( estabelec 
     where estabelec.cod-estabel = input frame {&frame-name} localizacao.cod-estabel no-lock)
  then do:
     run utp/ut-msgs.p (input "show", input 2061, "").
     apply 'entry' to localizacao.cod-estabel in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.   
 
  /** Validaá∆o de c¢digo do dep¢sito **/
  if (input frame {&frame-name} localizacao.cod-depos = " ") or
     not can-find( deposito
     where deposito.cod-depos = input frame {&frame-name} localizacao.cod-depos no-lock)
  then do:   
     run utp/ut-msgs.p (input "show", input 530, "").
     apply 'entry' to localizacao.cod-depos in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.   
 
  /**  Validaá∆o para localizacao.descricao **/
  
  if (input frame {&frame-name} localizacao.descricao = ""
  or  input frame {&frame-name} localizacao.descricao = ? ) then do:
    
    run utp/ut-msgs.p (input "show", input 190, "" ).

    apply 'entry' to localizacao.descricao in frame {&frame-name}.
      
    return 'ADM-ERROR':U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Integraá∆o MES X PPI Multitask */
  IF adm-new-record THEN
      RUN pi-send-message.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/

    /*Foi retirado est† validaá∆o por problemas de performance na base do cliente (Grendene). 
        Essa validaá∆o est† sendo feito pela trigger tdin189.p, onde valida a saldo estoque */

    /*Obs.:  a tabela saldo-estoq n∆o eÔ movida para bancos historicos*/

    /*if  not available(param-global) then
        find first param-global no-lock no-error.
    
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 4 Localizacao localizacao.cod-estabel localizacao.cod-depos localizacao.cod-localiz '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.*/
/************************************************************************************************************/

  if can-find (first item-uni-estab 
			   where item-uni-estab.deposito-pad = localizacao.cod-depos 
			     and item-uni-estab.cod-localiz  = localizacao.cod-localiz
				 and item-uni-estab.cod-estabel  = localizacao.cod-estabel) then do:
	{utp/ut-field.i mgind localizacao cod-localiz 1}
	run utp/ut-msgs.p (input "show", input 3, input return-value ). 
    return 'ADM-ERROR':U.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

  /* Code placed here will execute PRIOR to standard behavior. */
  
if available localizacao then do:
     find first estabelec where estabelec.cod-estabel = localizacao.cod-estabel no-lock no-error.                            
     assign c-estabelec = if avail estabelec then estabelec.nome else "":U.
end.  

if available localizacao then do:
     find first deposito where deposito.cod-depos = localizacao.cod-depos no-lock no-error.                            
     assign c-deposito = if avail deposito then deposito.nome else "":U.
end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  if avail localizacao then
     assign gr-localizacao = rowid(localizacao).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-send-message V-table-Win 
PROCEDURE pi-send-message :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST param-cp NO-LOCK NO-ERROR.
    IF AVAIL param-cp AND param-cp.log-integr-ppi-mes THEN DO:
        
        IF AVAIL localizacao THEN DO:
        
            RUN cdp/cdapi1003.p PERSISTENT SET h-cdapi1003. 
            RUN cdp/cdapi990.p  PERSISTENT SET h-cdapi990. 
            
            EMPTY TEMP-TABLE RowErrors NO-ERROR.
            
            RUN pi-SendDirectUpsert IN h-cdapi1003 (INPUT ROWID(localizacao),
                                                    OUTPUT cXml,
                                                    OUTPUT cChave,
                                                    OUTPUT TABLE RowErrors).

            IF CAN-FIND(FIRST RowErrors ) THEN DO:
                ASSIGN c-des-msg-ret = ""
                       cXMLAux     = cXML.
                
                /* Busca a descriªío dos erros para criar a pendencia */
                FOR EACH RowErrors:
                    ASSIGN c-des-msg-ret =  c-des-msg-ret + RowErrors.errorDescription + chr(10) .
                END.
                
                EMPTY TEMP-TABLE RowErrors NO-ERROR.
                
                /** Tela de confirmacao **/
                {utp/ut-liter.i da_localizacao * }
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 54394, 
                                   INPUT TRIM(RETURN-VALUE) + " ":U + localizacao.cod-localiz).

                IF RETURN-VALUE = "YES":U THEN DO:
                    EMPTY TEMP-TABLE tt-cria-pendencia NO-ERROR.
                    
                    DO WHILE(TRUE):
                        CREATE tt-cria-pendencia.
                        ASSIGN tt-cria-pendencia.cTransaction      = "AddressStock":U
                               tt-cria-pendencia.cInternalId       = cChave
                               tt-cria-pendencia.cErrorDescription = c-des-msg-ret
                               tt-cria-pendencia.iTipStatus        = 1. /* Pendente com Erro */

                        IF LENGTH(cXMLAux) > 9990 THEN DO:
                            ASSIGN tt-cria-pendencia.cXml  =  SUBSTR(cXMLAux, 1, 9990)
                                   SUBSTR(cXMLAux,1, 9990) = "":U.
                        END.
                        ELSE DO:
                            ASSIGN tt-cria-pendencia.cXml = cXMLAux.
                            LEAVE.        
                        END.
                    END. 

                    RUN createPendency IN h-cdapi990 (INPUT TABLE tt-cria-pendencia,
                                                      OUTPUT TABLE RowErrors).
                END.
                ELSE DO:
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END.
            ELSE DO:
                /* Se o retorno for ok, verifica se existe pendencia para a chave. Se tiver, exlui */           
                IF CAN-FIND(FIRST pendcia-integr-mes 
                            WHERE pendcia-integr-mes.cod-chave-ident = cChave) THEN
                    RUN deletePendciaByIdentif IN h-cdapi990 (INPUT cChave).
            END.

            IF CAN-FIND(FIRST rowErrors) THEN DO:
                {method/showmessage.i1}     
                {method/showmessage.i2 &Modal="YES"}
                {method/showmessage.i3}  
                RETURN "ADM-ERROR":U.
            END.

            DELETE PROCEDURE h-cdapi990  NO-ERROR. 
            DELETE PROCEDURE h-cdapi1003 NO-ERROR.
        END.
    END.

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

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "localizacao"}

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


