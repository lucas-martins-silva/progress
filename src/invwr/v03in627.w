&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V03IN627 2.00.00.033 } /*** "010033" 09/01/2026 14:41:40 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v03in627 MUT}
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
define new global shared var gr-usuarmater as rowid NO-UNDO.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var c-requis as char.
def var c-aprov  as char.
def var l-deleta as log.
def var i-cont-tp-docum as int init 5 no-undo.

{cdp/cd0669.i}

{bhp/bh9999.i1}

{cdp/cdcfgmat.i}

DEF VAR h-axssu015 AS HANDLE                  NO-UNDO.
DEF VAR c-action   AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEF SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INT  INITIAL ?
     FIELD ttv_des_msg_ajuda AS char INITIAL ?
     FIELD ttv_des_msg_erro  AS char INITIAL ?
.

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
&Scoped-define EXTERNAL-TABLES usuar-mater
&Scoped-define FIRST-EXTERNAL-TABLE usuar-mater


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR usuar-mater.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS usuar-mater.cod-usuario 
&Scoped-define ENABLED-TABLES usuar-mater
&Scoped-define FIRST-ENABLED-TABLE usuar-mater
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS usuar-mater.cod-usuario 
&Scoped-define DISPLAYED-TABLES usuar-mater
&Scoped-define FIRST-DISPLAYED-TABLE usuar-mater
&Scoped-Define DISPLAYED-OBJECTS c_nom_usuario 

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
DEFINE VARIABLE c_nom_usuario AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 51.86 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     usuar-mater.cod-usuario AT ROW 1.25 COL 14.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c_nom_usuario AT ROW 1.25 COL 30.72 COLON-ALIGNED HELP
          "Nome Usu†rio" NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.usuar-mater
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
         HEIGHT             = 1.38
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c_nom_usuario IN FRAME f-main
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME usuar-mater.cod-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.cod-usuario V-table-Win
ON F5 OF usuar-mater.cod-usuario IN FRAME f-main /* Usu†rio */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                     &campo=usuar-mater.cod-usuario
                     &campozoom=cod_usuario}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.cod-usuario V-table-Win
ON LEAVE OF usuar-mater.cod-usuario IN FRAME f-main /* Usu†rio */
DO:

  {include/leave.i &tabela=usuar_mestre
                   &atributo-ref=nom_usuario
                   &variavel-ref=c_nom_usuario
                   &where="usuar_mestre.cod_usuario = input frame {&frame-name} usuar-mater.cod-usuario"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.cod-usuario V-table-Win
ON MOUSE-SELECT-DBLCLICK OF usuar-mater.cod-usuario IN FRAME f-main /* Usu†rio */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                     &campo=usuar-mater.cod-usuario
                     &campozoom=cod_usuario}
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

if usuar-mater.cod-usuario:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Usu†rio * R}
assign usuar-mater.cod-usuario:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "usuar-mater"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "usuar-mater"}

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

if  adm-new-record = yes then do: 
    find usuar-mater where usuar-mater.cod-usuario = input frame {&frame-name} 
         usuar-mater.cod-usuario no-lock no-error.
    if  avail usuar-mater then do:
        {utp/ut-table.i mgind usuar-mater 1}
        run utp/ut-msgs.p ("show",1,trim(return-value)).
        apply "entry" to usuar-mater.cod-usuario in frame {&frame-name}.
        return "adm-error".                    
    end.
    find usuar_mestre where usuar_mestre.cod_usuario = input frame {&frame-name}
         usuar-mater.cod-usuario no-lock no-error.
    if  not avail usuar_mestre then do:
        {utp/ut-table.i mguni usuar_mestre 1}
        run utp/ut-msgs.p ("show",2,return-value).
        apply "entry" to usuar-mater.cod-usuario in frame {&frame-name}.
        return "adm-error".  
    end.                    
end.   

/* Dispatch standard ADM method.                             */
RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   return 'ADM-ERROR':U.

find first usuar_mestre where usuar_mestre.cod_usuario = usuar-mater.cod-usuario no-lock no-error.
if  avail usuar_mestre then
    &if "{&mgind_dbtype}" = "progress":U &then
        assign usuar-mater.nome-usuar = usuar_mestre.nom_usuario.
    &else
        assign usuar-mater.nome-usuar = substring(usuar_mestre.nom_usuario,1,40).
    &endif
else 
    assign usuar-mater.nome-usuar = "".


/****************************************************************/    
/* Para execuá∆o de Adapter da Mensagem Unidade de Medida - EAI */
/****************************************************************/
/* Execucao caso usuario possua integracao EAI e paradigma*/
IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-portal-paradigma":U AND funcao.ativo) AND v_log_eai_habilit THEN DO:
    IF adm-new-record THEN ASSIGN c-action = "add":U.
                      ELSE ASSIGN c-action = "upd":U.

    RUN PITransUpsert IN h-axssu015 (INPUT  ROWID(usuar-mater),
                                     INPUT  c-action,
                                     OUTPUT TABLE tt_log_erro).

    IF CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro" *}
        FOR EACH tt_log_erro:
            run utp/ut-msgs.p (input "show":U,
                               input 17006,
                               input RETURN-VALUE + " " + STRING(tt_log_erro.ttv_num_cod_erro) + "~~" +
                                     tt_log_erro.ttv_des_msg_erro).
            return('adm-error':U).
        END.
    END.
END.


if  usuar-mater.usuar-requis = yes 
or  usuar-mater.usuar-solic  = yes then do:
    find requisitante where requisitante.nome-abrev = usuar-mater.cod-usuario exclusive-lock no-error. 
    if  not avail requisitante then do:
        create requisitante.
        assign requisitante.nome-abrev    = usuar-mater.cod-usuario.
    end. 
    assign requisitante.nome          = substring(usuar-mater.nome-usuar,1,30)
           requisitante.limite-requis = usuar-mater.lim-requis
           requisitante.mo-codigo     = usuar-mater.mo-codigo
           requisitante.tp-preco      = usuar-mater.tp-preco
           requisitante.sc-codigo     = usuar-mater.sc-codigo
           requisitante.limite-solic  = usuar-mater.lim-solic
           requisitante.e-mail        = usuar-mater.e-mail
           requisitante.home-page     = usuar-mater.home-page
           requisitante.telefone[1]   = usuar-mater.telefone[1]       
           requisitante.telefone[2]   = usuar-mater.telefone[2]            
           requisitante.ramal[1]      = usuar-mater.ramal[1]       
           requisitante.ramal[2]      = usuar-mater.ramal[2]   
           requisitante.limite-manut  = usuar-mater.lim-requis-manut.
end.

if  adm-new-record = no then 
    find requisitante where requisitante.nome-abrev = usuar-mater.cod-usuario exclusive-lock no-error. 
if  avail requisitante then do:
    assign l-deleta = yes.
    {utp/ut-table.i mgind requisitante 1}
    assign c-requis = return-value.
    if  usuar-mater.usuar-requis = no 
    and usuar-mater.usuar-solic  = no then do:    
        find first requisicao 
             where requisicao.nome-abrev = requisitante.nome-abrev
             no-lock no-error.
        if  avail requisicao then do:
            run utp/ut-msgs.p (input "show", input 6778, input "").    
            assign l-deleta = no.
        end.
        if  l-deleta = yes then 
            delete requisitante.
        else 
            assign usuar-mater.usuar-requis = yes.
    end.   
end.   

if  usuar-mater.usuar-comprador = yes then do:
    find comprador where 
         comprador.cod-comprado = usuar-mater.cod-usuario exclusive-lock no-error. 
    if  not avail comprador then do:
        create comprador.
        assign comprador.cod-comprado     = usuar-mater.cod-usuario.
    end. 
    assign comprador.nome           = substring(usuar-mater.nome-usuar,1,30)
           comprador.lim-compra     = usuar-mater.lim-solic
           comprador.mo-codigo      = usuar-mater.mo-codigo
           comprador.corporativo    = usuar-mater.corporativo
           comprador.cod-grp-compra = usuar-mater.cod-grp-compra
           comprador.e-mail         = usuar-mater.e-mail
           comprador.home-page      = usuar-mater.home-page
           comprador.telefone[1]    = usuar-mater.telefone[1]
           comprador.telefone[2]    = usuar-mater.telefone[2]
           comprador.ramal[1]       = usuar-mater.ramal[1]
           comprador.ramal[2]       = usuar-mater.ramal[2]
           comprador.telefax        = usuar-mater.telefax 
           comprador.ramal-fax      = usuar-mater.ramal-fax
           comprador.telef-modem    = usuar-mater.telef-modem
           comprador.ramal-modem    = usuar-mater.ramal-modem.
end.
else do:
    if  adm-new-record = no then 
        find comprador where 
             comprador.cod-comprado = usuar-mater.cod-usuario exclusive-lock no-error. 
    if avail comprador then do:
        if can-find (first familia use-index comprador where
                           familia.cod-comprado = comprador.cod-comprado) or
           can-find (first item use-index comprador where
                           item.cod-comprado = comprador.cod-comprado) or 
           can-find (first ordem-compra use-index comprador where
                           ordem-compra.cod-comprado = comprador.cod-comprado) or 
           can-find (first cotacao-item use-index comprador where
                           cotacao-item.cod-comprado = comprador.cod-comprado) 
           then do:
           run utp/ut-msgs.p (input "show",
                              input 6709,
                              input "").
           assign usuar-mater.usuar-comprador = yes.
        end.  
        ELSE DO:
            delete comprador.
            
            DO i-cont-tp-docum = 5 TO 8:
                FOR FIRST perm-usuar EXCLUSIVE-LOCK
                    WHERE perm-usuar.cod-usuar  = usuar-mater.cod-usuario     
                      AND perm-usuar.tipo-docum = i-cont-tp-docum: 
                    DELETE perm-usuar.
                END.    
            END.
        END.
    end.
end.   

if  usuar-mater.usuar-aprovador = yes then do:
    find aprovador where 
         aprovador.cod-aprov = usuar-mater.cod-usuario exclusive-lock no-error.
    if  not avail aprovador then do:
        create aprovador.
        assign aprovador.cod-aprov = usuar-mater.cod-usuario
               aprovador.mestre    = no.
    end.
    assign aprovador.des-aprov = usuar-mater.nome-usuar.
end.  
else if adm-new-record = no then do: 
    find aprovador where aprovador.cod-aprov = usuar-mater.cod-usuario exclusive-lock no-error.
    if  avail aprovador then do:
        /* Elimina Relacionamentos */
        run cdp/cd1701a.p(usuar-mater.cod-usuario).
        delete aprovador.
    end.
end.

   release comprador.
   release requisitante.          
   release aprovador.

   &if "{&bf_mat_versao_ems}" >= "2.05" &then
       if usuar-mater.usuar-comprador = yes then do:      

           /* 
           5 --> Pedidos Normais N∆o Emitidos 
           6 --> Pedidos Normais Emitidos
           7 --> Pedidos Emergenciais N∆o Emitidos
           8 --> Pedidos Emergenciais Emitidos
           */

           do i-cont-tp-docum = 5 to 8:
               FOR first perm-usuar where perm-usuar.cod-usuar = usuar-mater.cod-usuario     
                   and perm-usuar.tipo-docum = i-cont-tp-docum no-lock: 
               end.
               if not avail perm-usuar then do:
                   create perm-usuar.
                   assign perm-usuar.cod-usuar = usuar-mater.cod-usuario
                          perm-usuar.tipo-docum = i-cont-tp-docum
                          perm-usuar.perm-elim  = yes
                          perm-usuar.perm-incl  = yes
                          perm-usuar.perm-libe  = yes
                          perm-usuar.perm-modi  = yes
                          perm-usuar.perm-real  = yes.

                   RELEASE perm-usuar.
               end.
           end.
       end.
   &endif 

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
    
    def var texto-1 as char no-undo.
    def var texto-2 as char no-undo.

    for each tt-erro:
        delete tt-erro.
    end.    

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 4 Usuar-Mater usuar-mater.cod-usuario '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

    /**  Verifica relacionamentos com o usu†rio
    **/
    run cdp/cdapi175.p (input input frame {&frame-name} usuar-mater.cod-usuario ,
                        input 1 ,
                        output table tt-erro).
    find first tt-erro
        no-lock no-error.
    if available tt-erro then do:
        run cdp/cd0669.w (input table tt-erro).        
        return "adm-error".                                
    end.        
    if usuar-mater.usuar-aprovador then do:

        for each tt-erro:
            delete tt-erro.
        end.    
        /**  Verifica relacionamentos com o Aprovador
        **/
        run cdp/cdapi175.p (input input frame {&frame-name} usuar-mater.cod-usuario ,
                            input 2 ,
                            output table tt-erro).
        find first tt-erro
            no-lock no-error.
        if available tt-erro then do:
            run cdp/cd0669.w (input table tt-erro).        
            return "adm-error".                                
        end.        

    end.

    find aprovador where 
        aprovador.cod-aprov = input frame {&frame-name} usuar-mater.cod-usuario 
        exclusive-lock no-error. 
    if avail aprovador then do:
        /* Elimina Relacionamentos */
        run cdp/cd1701a.p(usuar-mater.cod-usuario).
        delete aprovador.
    end.
    if "adm-error" = "yes" then
        return "adm-error".

    find comprador where 
        comprador.cod-comprado = usuar-mater.cod-usuario 
        exclusive-lock no-error. 
    if avail comprador then do:
        if can-find (first familia use-index comprador where
                           familia.cod-comprado = comprador.cod-comprado) or
           can-find (first item use-index comprador where
                           item.cod-comprado = comprador.cod-comprado) or 
           can-find (first ordem-compra use-index comprador where
                           ordem-compra.cod-comprado = comprador.cod-comprado) or 
           can-find (first cotacao-item use-index comprador where
                           cotacao-item.cod-comprado = comprador.cod-comprado) OR
           CAN-FIND (FIRST requisicao WHERE
                           requisicao.nome-abrev = comprador.cod-comprado)
           then do:
           run utp/ut-msgs.p (input "show",
                              input 6709,
                              input "").
         
           return "adm-error".
        end.  
        ELSE
            delete comprador.
    end.
        
    find first usuar-ccusto where                    
        usuar-ccusto.cod-usuario = usuar-mater.cod-usuario no-lock 
        no-error.
    if available usuar-ccusto then do:
        run utp/ut-msgs.p (input "show", input 16004, input "").
        if return-value = "yes" then do:
            for each usuar-ccusto where 
                usuar-ccusto.cod-usuario = usuar-mater.cod-usuario exclusive-lock:
                delete usuar-ccusto.
            end.  
        end.   
        if return-value = "no" then do: 
            return "adm-error".
        end.     
    end.

    if usuar-mater.usuar-requis = yes
    or  usuar-mater.usuar-solic  = yes then do:
        find requisitante where 
            requisitante.nome-abrev = usuar-mater.cod-usuario 
            exclusive-lock no-error.
        if avail requisitante then 
            delete requisitante.     
    end.

    /*********** MODULO AQR (Aquisiá∆o Produtos Rurais) *******************/

    IF substring(param-global.char-2,101,1) = "S" THEN DO:

        IF CAN-FIND(FIRST regiao-abrangen WHERE regiao-abrangen.cod-respons = usuar-mater.cod-usuario) THEN DO:

            {utp/ut-table.i mgind usuar-mater 1}
            assign texto-1 = return-value.
            {utp/ut-table.i mgind regiao-abrangen 1}
            assign texto-2 = return-value.
            run utp/ut-msgs.p (input "show":U, input 5, input texto-1 + "~~" + texto-2).
            return "adm-error".

        END.

    END.
        
    FOR EACH perm-usuar EXCLUSIVE-LOCK
       WHERE perm-usuar.cod-usuar = usuar-mater.cod-usuario:
        DELETE perm-usuar.
    END.
    /*********** FIM MODULO AQR (Aquisiá∆o Produtos Rurais) **************/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

    release comprador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  IF (valid-handle(h-axssu015) 
      and h-axssu015:type = "PROCEDURE":U 
      and h-axssu015:file-name = "adapters/xml/su2/axssu015.p":U ) then DO:
    
      delete procedure h-axssu015.
      assign h-axssu015 = ?.
  END.

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

  /* Code placed here will execute PRIOR to standard behavior. */

 if available usuar-mater
  then do:
   find first usuar_mestre where
              usuar_mestre.cod_usuario = usuar-mater.cod-usuario no-lock no-error.
    assign c_nom_usuario = if avail usuar_mestre then usuar_mestre.nom_usuario else "":U.
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif.

    if adm-new-record = no then 
     assign usuar-mater.cod-usuario:sensitive in frame {&frame-name} = no.

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

  run adapters/xml/su2/axssu015.p persistent set h-axssu015 (OUTPUT TABLE tt_log_erro).

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

    if  avail usuar-mater then 
      assign gr-usuarmater = rowid(usuar-mater).

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
  {src/adm/template/snd-list.i "usuar-mater"}

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

