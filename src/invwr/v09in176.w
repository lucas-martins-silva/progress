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
{include/i-prgvrs.i V09IN176 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v09in176 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---    */
def var r-docum-est as rowid no-undo.

def buffer b-estru for estrutura.
def buffer b-natur for natur-oper.
def buffer b-it-doc for item-doc-est.
def buffer b-componente for componente.
def buffer b-item-doc-est for item-doc-est.

def temp-table tt-terc
    field registro as rowid
    field quantidade like saldo-terc.quantidade.
    
def var l-entrada   as logical no-undo.
def var l-transf    as logical no-undo. 
def var l-modulo-ge as logical no-undo.
def var l-remessa   as logical no-undo.
def var l-retorno   as logical no-undo.
def var l-ent-cons  as logical no-undo.
def var l-sai-cons  as logical no-undo.

def var i-seq             as integer no-undo.
def var da-aux            as date    no-undo.
def var i-aux             as integer no-undo.
def var de-qtd-aux        as decimal no-undo.
def var i-fator           as decimal extent 22.
def var r-end-ret         as rowid   extent 22.
def var i-retorno         as integer no-undo.
def var c-item            as char    no-undo.
def var de-tot-peso       as decimal no-undo.
def var i-nr-itens        as integer no-undo.
def var i-aux-1           as integer no-undo.
def var l-erro-x          as logical no-undo.
def var l-ordens          as logical no-undo.
def var i-seq-item        as integer no-undo.
def var de-saldo          as decimal no-undo.
def var de-tot-quant-aloc as decimal no-undo.
def var de-disponivel     as decimal no-undo.
def var r-registro        as rowid   no-undo.
def var l-resposta        as logical no-undo.
def var l-compras         as logical no-undo.
def var de-qtd-tot-ordem  as decimal no-undo.
def var de-indice         as decimal no-undo.
def var c-un              as char    no-undo.
def var de-qtd-estrut     as decimal no-undo.
def var de-valor-unit     as decimal no-undo.
def var de-valor          as decimal no-undo.
def var de-quant-item     as decimal no-undo.
def var de-tot-item       as decimal no-undo.

{cdp/cdcfgman.i}

def temp-table tt-estr-tmp
    field cod-estabel like estabelec.cod-estabel
    field data        as date
    field descricao   as char
    field dt-inicio   as date
    field de-termino  as date
    field endereco    as decimal
    field fantasma    as logical
    field it-codigo   as char
    field nivel       as integer
    field proporcao   as decimal
    field quant-uso   as decimal
    field quantidade  as decimal
    field referencia  as char
    field sequencia   as integer
    field tempo       as integer
    field un          as char
    field row-tmp     as rowid.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold c-pai i-ord-prod de-qtd da-data 
&Scoped-Define DISPLAYED-OBJECTS c-pai i-ord-prod de-qtd da-data 

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
DEFINE VARIABLE c-pai AS CHARACTER FORMAT "x(16)" 
     LABEL "Item Pai":R10 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE da-data AS DATE FORMAT "99/99/9999" INITIAL 07/30/97 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE de-qtd AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Nossa Qtde":R12 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE i-ord-prod AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Ordem Produ‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-pai AT ROW 2.75 COL 25 COLON-ALIGNED HELP
          "Item pai do item desta reserva na estrutura"
     i-ord-prod AT ROW 3.75 COL 25 COLON-ALIGNED HELP
          "Informe o numero da ordem de produ‡Æo"
     de-qtd AT ROW 4.75 COL 25 COLON-ALIGNED HELP
          "Quantidade na nossa unidade de medida"
     da-data AT ROW 5.75 COL 25 COLON-ALIGNED HELP
          "Data movimento"
     rt-mold AT ROW 1 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.54
         WIDTH              = 57.14.
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

&Scoped-define SELF-NAME c-pai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-pai V-table-Win
ON F5 OF c-pai IN FRAME f-main /* Item Pai */
DO:

        {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                             &campo=c-pai
                           &campozoom=it-codigo}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-pai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-pai IN FRAME f-main /* Item Pai */
DO:
  
        apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON F5 OF i-ord-prod IN FRAME f-main /* Ordem Produ‡Æo */
DO:

        {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                             &campo=i-ord-prod
                           &campozoom=nr-ord-prod}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON LEAVE OF i-ord-prod IN FRAME f-main /* Ordem Produ‡Æo */
DO:

    if input frame {&frame-name} i-ord-prod <> 0 then do:  
        find ord-prod where 
            ord-prod.nr-ord-prod = input frame {&frame-name} i-ord-prod
            no-lock no-error.  
        if available ord-prod then
            display ord-prod.it-codigo @ c-pai with frame {&frame-name}.
        else do:
            display 0 @ i-ord-prod with frame {&frame-name}.
            apply "entry" to i-ord-prod in frame {&frame-name}.
            return no-apply.
        end.
            
        display ord-prod.qt-ordem - ord-prod.qt-produzida @ de-qtd with frame {&frame-name}.
                            
    end.            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ord-prod IN FRAME f-main /* Ordem Produ‡Æo */
DO:

        apply "F5" to self.
  
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

    if c-pai:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if i-ord-prod:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    {utp/ut-liter.i Data_de_corte * R}
    assign da-data:label in frame {&frame-name} = trim(return-value).    

    find first param-global
        no-lock no-error.

    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao V-table-Win 
PROCEDURE pi-geracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find item where 
        item.it-codigo = input frame {&frame-name} c-pai
        no-lock no-error.
    if not available item then do:
        {utp/ut-field.i mgind item-doc-est it-codigo 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to c-pai in frame {&frame-name}.
        return error.
    end.
    
    if input frame {&frame-name} i-ord-prod = 0 then do:
        find first estrutura where
            estrutura.it-codigo = input frame {&frame-name} c-pai
            no-lock no-error.
        if not available estrutura then do:
            run utp/ut-msgs.p (input "show", input 7227, input "").
            apply "entry" to c-pai in frame {&frame-name}.
            return error.
        end.
    end.
    else do:
        if l-remessa then do:
            find first reservas where
                reservas.nr-ord-prod = input frame {&frame-name} i-ord-prod and
                (reservas.quant-orig - (reservas.quant-terc + reservas.quant-atend)) > 0
                no-lock no-error.
            if not available reservas then do:
                run utp/ut-msgs.p (input "show", input 5300, input "").
                apply "entry" to i-ord-prod in frame {&frame-name}.
                return error.
            end.
        end.
    end.
    
    if input frame {&frame-name} de-qtd <= 0 then do:
        run utp/ut-msgs.p (input "show", input 7228, input "").
        apply "entry" to de-qtd in frame {&frame-name}.
        return error.
    end.
    
    if input frame {&frame-name} i-ord-prod > 0 then do:
        if input frame {&frame-name} de-qtd > (ord-prod.qt-ordem - ord-prod.qt-produzida) then do:
            run utp/ut-msgs.p (input "show", input 7229, input "").
            apply "entry" to de-qtd in frame {&frame-name}.
            return error.
        end.
    end.

    assign i-seq = 1
           da-aux = 01/01/02
           i-aux = random(1,100000).

    repeat:
        find first tt-estr-tmp where
            tt-estr-tmp.data = da-aux and
            tt-estr-tmp.tempo = i-aux
            no-lock no-error.
        if not available tt-estr-tmp then 
            leave.
        i-aux = random(1,100000).
    end.
    
    if input frame {&frame-name} i-ord-prod > 0 then do:
        for each reservas where reservas.nr-ord-prod = input frame {&frame-name} i-ord-prod no-lock:
            if reservas.quant-orig <= 0 then
                next.
            if l-remessa and (reservas.quant-orig - (reservas.quant-atend +
                reservas.quant-terc)) <= 0 then do:
                next.
            end.
            create tt-estr-tmp.
            assign tt-estr-tmp.data = da-aux
                   tt-estr-tmp.tempo = i-aux
                   tt-estr-tmp.sequencia = i-seq
                   tt-estr-tmp.it-codigo = reservas.it-codigo
                   tt-estr-tmp.nivel = input frame {&frame-name} i-ord-prod
                   tt-estr-tmp.row-tmp = rowid(reservas)
                   de-qtd-aux     = ((input frame {&frame-name} de-qtd * reservas.quant-orig)
                                         / ord-prod.qt-ordem).
            if  l-remessa then do:
                if  de-qtd-aux < reservas.quant-orig -
                    (reservas.quant-atend + reservas.quant-terc) then
                    assign tt-estr-tmp.quantidade = de-qtd-aux.
                else
                    assign tt-estr-tmp.quantidade = reservas.quant-orig -
                              (reservas.quant-atend + reservas.quant-terc).
            end.
            else
            if  l-retorno then do:
                if  de-qtd-aux < (reservas.quant-orig -
                                  reservas.quant-atend) then
                    assign tt-estr-tmp.quantidade = de-qtd-aux.
                else
                    assign tt-estr-tmp.quantidade = (reservas.quant-orig -
                                                  reservas.quant-atend).
            end.
            else
                assign tt-estr-tmp.quantidade = de-qtd-aux.
            i-seq = i-seq + 1.
        end.
    end.
    else do:
        assign i-fator[1] = input frame {&frame-name} de-qtd
               i-retorno = 1
               c-item = item.it-codigo.
        comeco:
        repeat:
            find first estrutura where
                 estrutura.it-codigo = c-item and
                 estrutura.data-inicio <= input frame {&frame-name} da-data and
                 estrutura.data-termino > input frame {&frame-name} da-data and
                 estrutura.quant-usada > 0 no-lock no-error.
                 
            if not available estrutura and i-retorno < 3 then
                leave.

            if i-retorno = 1 then do:
                assign i-retorno = i-retorno + 1
                       r-end-ret[i-retorno] = rowid(estrutura).
            end.

            repeat:
                if available estrutura then do:
                    find item where item.it-codigo = estrutura.es-codigo
                         no-lock no-error.
                         
                    &IF DEFINED (bf_man_sfc_lc) &THEN     
                    assign i-fator[i-retorno] = i-fator[i-retorno - 1]
                                                * estrutura.qtd-compon / estrutura.qtd-item
                                                * estrutura.proporcao / 100.
                    &ELSE
                    assign i-fator[i-retorno] = i-fator[i-retorno - 1]
                                                * estrutura.quant-usada
                                                * estrutura.proporcao / 100.                    
                    &ENDIF
                                         
                    if estrutura.fantasma = yes then do:
                        find first b-estru where
                             b-estru.it-codigo = estrutura.es-codigo  and
                             b-estru.data-inicio <= input frame {&frame-name} da-data and
                             b-estru.data-termino > input frame {&frame-name} da-data no-lock no-error.
                        if not avail b-estru and item.it-codigo <> '' and
                           item.tipo-contr <> 4 then do:
                            find first tt-estr-tmp where
                                 tt-estr-tmp.data = da-aux and
                                 tt-estr-tmp.tempo = i-aux and
                                 tt-estr-tmp.it-codigo = item.it-codigo no-error.
                            if not available tt-estr-tmp then do:
                                create tt-estr-tmp.
                                assign tt-estr-tmp.data = da-aux
                                       tt-estr-tmp.tempo = i-aux
                                       tt-estr-tmp.sequencia = i-seq
                                       tt-estr-tmp.it-codigo = item.it-codigo
                                       i-seq = i-seq + 1.
                            end.
                            tt-estr-tmp.quantidade = tt-estr-tmp.quantidade +
                                                  i-fator[i-retorno].
                        end.
                        assign c-item = estrutura.es-codigo
                               i-retorno = i-retorno + 1
                               r-end-ret[i-retorno] = rowid(estrutura).
                        next comeco.
                    end.
                    else if item.tipo-contr <> 4 and
                         item.it-codigo <> '' then do:
                        find first tt-estr-tmp where
                             tt-estr-tmp.data = da-aux and
                             tt-estr-tmp.tempo = i-aux and
                             tt-estr-tmp.it-codigo = item.it-codigo no-error.
                        if not available tt-estr-tmp then do:
                            create tt-estr-tmp.
                            assign tt-estr-tmp.data = da-aux
                                   tt-estr-tmp.tempo = i-aux
                                   tt-estr-tmp.sequencia = i-seq
                                   tt-estr-tmp.it-codigo = item.it-codigo
                                   i-seq = i-seq + 1.
                        end.
                        tt-estr-tmp.quantidade = tt-estr-tmp.quantidade +
                                              i-fator[i-retorno].
                    end.
                end.
                else do:
                    if i-retorno = 2 then
                        leave comeco.
                    else do:
                        find estrutura where
                             rowid(estrutura) = r-end-ret[i-retorno]
                             no-lock no-error.
                        assign c-item = estrutura.it-codigo
                               i-retorno = i-retorno - 1.
                    end.
                end.
                find next estrutura where
                     c-item = estrutura.it-codigo and
                     input frame {&frame-name} da-data >= estrutura.data-inicio and
                     input frame {&frame-name} da-data < estrutura.data-termino
                     no-lock no-error.
            end.
        end.
    end.
    
    run pi-geracao-II.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao-II V-table-Win 
PROCEDURE pi-geracao-II :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first para-fat 
        no-lock no-error.
        
    assign l-implanta  = no
           de-tot-peso = 0
           i-nr-itens  = 0.
           
    for each tt-estr-tmp where tt-estr-tmp.data = da-aux and
             tt-estr-tmp.tempo = i-aux transaction with frame f-item:
             
        find last item-doc-est {cep/ce9030.i item-doc-est docum-est}
             no-lock no-error.
        if avail item-doc-est then
            i-aux-1 = item-doc-est.sequencia + param-re.inc-seq.
        else
            i-aux-1 = param-re.seq-item-um.
        assign l-erro-x      = no
               l-ordens      = no.
        display tt-estr-tmp.nivel @ i-ord-prod with frame {&frame-name}.
        if  l-remessa then do:
            /*
            ** CE0201L2.I1
            */
            run pi-geracao-IIa.
        end.
        else do:
            /*
            ** CE0201L2.I5
            */
            run pi-geracao-IIb.
        end.
        delete tt-estr-tmp validate(true,'').
    end.
    if  docum-est.tot-peso = 0 then do trans:
        assign docum-est.tot-peso = de-tot-peso.
    end.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao-IIa V-table-Win 
PROCEDURE pi-geracao-IIa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find item where item.it-codigo = tt-estr-tmp.it-codigo 
        no-lock no-error.
    find last item-doc-est {cep/ce9030.i item-doc-est docum-est} 
        no-lock no-error.
    if available item-doc-est then
       assign i-seq-item = item-doc-est.sequencia + param-re.inc-seq.
    else

    assign i-seq-item = param-re.seq-item-um.

    if input frame {&frame-name} i-ord-prod > 0 then do:
        for each reservas where rowid(reserva) = tt-estr-tmp.row-tmp no-lock:
            assign de-saldo = tt-estr-tmp.quantidade
                   de-tot-quant-aloc = 0.
            if  reservas.quant-aloc > 0 then do:
                bloco1:
                for each aloca-reserva where
                         aloca-reserva.nr-ord-prod = reservas.nr-ord-prod and  
                         aloca-reserva.item-pai    = reservas.item-pai and  
                         aloca-reserva.cod-roteiro = reservas.cod-roteiro and  
                         aloca-reserva.op-codigo   = reservas.op-codigo and  
                         aloca-reserva.cod-estabel = docum-est.cod-estabel and  
                         aloca-reserva.it-codigo   = reservas.it-codigo no-lock:
                    if  aloca-reserva.quant-aloc > 0 then do:
                        assign de-disponivel = aloca-reserva.quant-aloc.

                        if  de-disponivel >= de-saldo then
                            assign de-disponivel = de-saldo.

                        if truncate(de-disponivel,0) <> de-disponivel and
                            not item.fraciona then
                            assign de-disponivel = truncate(de-disponivel,0) + 1.

                        assign de-tot-quant-aloc = de-tot-quant-aloc +
                                                   de-disponivel.
                        find first saldo-estoq where
                                   saldo-estoq.cod-estabel = docum-est.cod-estabel and 
                                   saldo-estoq.cod-depos   = aloca-reserva.cod-depos and 
                                   saldo-estoq.cod-localiz = aloca-reserva.cod-localiz and 
                                   saldo-estoq.lote        = aloca-reserva.lote and 
                                   saldo-estoq.it-codigo   = aloca-reserva.it-codigo
                                   no-lock no-error.
                        create item-doc-est.
                        assign item-doc-est.it-codigo    = aloca-reserva.it-codigo
                               item-doc-est.cod-depos    = aloca-reserva.cod-depos
                               item-doc-est.cod-locali   = aloca-reserva.cod-localiz
                               item-doc-est.lote         = aloca-reserva.lote-serie
                               item-doc-est.cod-emitente = docum-est.cod-emitente
                               item-doc-est.nat-oper     = docum-est.nat-oper
                               item-doc-est.nro-docto    = docum-est.nro-docto
                               item-doc-est.serie-docto  = docum-est.serie-docto
                               item-doc-est.nr-ord-prod  = input frame {&frame-name} i-ord-prod
                               item-doc-est.sequencia    = i-seq-item
                               item-doc-est.it-codigo    = tt-estr-tmp.it-codigo
                               item-doc-est.cod-refer    = if  avail saldo-estoq then
                                                            saldo-estoq.cod-refer
                                                            else ''
                               item-doc-est.quantidade   = de-disponivel
                               item-doc-est.peso-liquido = item.peso-liquido
                                                          * item-doc-est.quantidade
                               i-seq-item = i-seq-item + param-re.inc-seq
                               i-nr-itens = i-nr-itens + 1
                               de-tot-peso = de-tot-peso + item-doc-est.peso-liquido
                               r-registro  = rowid(item-doc-est).

                        /*
                        ** CE0201L3.P
                        */
                        run pi-geracao-III.

                        de-saldo = de-saldo - de-disponivel.
                        if  de-saldo <= 0 then
                            leave bloco1.
                    end.
                end.
            end.
            if  tt-estr-tmp.quantidade > de-tot-quant-aloc then do:
                assign de-saldo = tt-estr-tmp.quantidade -
                                  de-tot-quant-aloc.
                       /*                                  
                       de-chave = string(reservas.nr-ord-prod,'999999') +
                                  string(reservas.item-pai,'x(16)')     +
                                  string(reservas.cod-roteiro,'x(16)')  +
                                  string(reservas.op-codigo,'99999')    + 'R'.*/
                                  
                                  
                bloco2:
                for each saldo-estoq where
                         saldo-estoq.cod-estab = docum-est.cod-estab and  
                         saldo-estoq.it-codigo = tt-estr-tmp.it-codigo  no-lock:
                    find estabelec where estabelec.cod-estabel = docum-est.cod-estabel
                         no-lock no-error.
                    find deposito where deposito.cod-depos = saldo-estoq.cod-depos
                         no-lock no-error.
                    if  avail estabelec             and
                        avail deposito              and
                        (deposito.ind-dep-cq        or
                         deposito.ind-dep-rej) then
                            next.

                    assign de-disponivel = saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod  -
                                            saldo-estoq.qt-alocada  - saldo-estoq.qt-aloc-ped.
                    if  de-disponivel > 0 then do:
                        if  de-disponivel >= de-saldo then
                            assign de-disponivel = de-saldo.
                        create item-doc-est.
                        assign item-doc-est.cod-emitente = docum-est.cod-emitente
                               item-doc-est.nat-oper     = docum-est.nat-oper
                               item-doc-est.nro-docto    = docum-est.nro-docto
                               item-doc-est.serie-docto  = docum-est.serie-docto
                               item-doc-est.cod-depos    = saldo-estoq.cod-depos
                               item-doc-est.cod-localiz  = saldo-estoq.cod-localiz
                               item-doc-est.lote         = saldo-estoq.lote
                               item-doc-est.cod-refer    = saldo-estoq.cod-refer
                               item-doc-est.nr-ord-prod  = input frame {&frame-name} i-ord-prod
                               item-doc-est.sequencia    = i-seq-item
                               item-doc-est.it-codigo    = tt-estr-tmp.it-codigo
                               item-doc-est.quantidade   = de-disponivel
                               item-doc-est.peso-liquido = item.peso-liquido
                                                           * item-doc-est.quantidade
                               i-seq-item  = i-seq-item + param-re.inc-seq
                               i-nr-itens  = i-nr-itens + 1
                               de-saldo    = de-saldo - de-disponivel
                               de-tot-peso = de-tot-peso + item-doc-est.peso-liquido
                               r-registro  = rowid(item-doc-est).

                        /* definicao de unidade de medida, quantidade do fornecedor
                           preco unitario, preco total, contas de aplicacao */

                        /*
                        ** CE0201L3.P
                        */
                        run pi-geracao-III.

                        if de-saldo <= 0 then
                            leave bloco2.
                    end.
                end.
                                  
            end.
        end.
    end.
    else do:
        assign de-saldo = tt-estr-tmp.quantidade.
               /*de-chave = "".*/
        bloco2:
        for each saldo-estoq where
                 saldo-estoq.cod-estab = docum-est.cod-estab and  
                 saldo-estoq.it-codigo = tt-estr-tmp.it-codigo  no-lock:
            find estabelec where estabelec.cod-estabel = docum-est.cod-estabel
                 no-lock no-error.
            find deposito where deposito.cod-depos = saldo-estoq.cod-depos
                 no-lock no-error.
            if  avail estabelec             and
                avail deposito              and
                (deposito.ind-dep-cq        or
                 deposito.ind-dep-rej) then
                    next.

            assign de-disponivel = saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod. /* -
                                   saldo-estoq.qt-alocada  - saldo-estoq.qt-aloc-venda.*/
            if  de-disponivel > 0 then do:
                if  de-disponivel >= de-saldo then
                    assign de-disponivel = de-saldo.
                create item-doc-est.
                assign item-doc-est.cod-emitente = docum-est.cod-emitente
                       item-doc-est.nat-oper     = docum-est.nat-oper
                       item-doc-est.nro-docto    = docum-est.nro-docto
                       item-doc-est.serie-docto  = docum-est.serie-docto
                       item-doc-est.cod-depos    = saldo-estoq.cod-depos
                       item-doc-est.cod-localiz  = saldo-estoq.cod-localiz
                       item-doc-est.lote         = saldo-estoq.lote
                       item-doc-est.cod-refer    = saldo-estoq.cod-refer
                       item-doc-est.nr-ord-prod  = input frame {&frame-name} i-ord-prod
                       item-doc-est.sequencia    = i-seq-item
                       item-doc-est.it-codigo    = tt-estr-tmp.it-codigo
                       item-doc-est.quantidade   = de-disponivel
                       item-doc-est.peso-liquido = item.peso-liquido
                                                   * item-doc-est.quantidade
                       i-seq-item  = i-seq-item + param-re.inc-seq
                       i-nr-itens  = i-nr-itens + 1
                       de-saldo    = de-saldo - de-disponivel
                       de-tot-peso = de-tot-peso + item-doc-est.peso-liquido
                       r-registro  = rowid(item-doc-est).

                /* definicao de unidade de medida, quantidade do fornecedor
                   preco unitario, preco total, contas de aplicacao */

                /*
                ** CE0201L3.P
                */
                
                run pi-geracao-III.

                if de-saldo <= 0 then
                    leave bloco2.
            end.
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao-IIb V-table-Win 
PROCEDURE pi-geracao-IIb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find item where item.it-codigo = tt-estr-tmp.it-codigo no-lock no-error.
    find last item-doc-est {cep/ce9030.i item-doc-est docum-est} no-lock no-error.
    if available item-doc-est then
       assign i-seq-item = item-doc-est.sequencia + param-re.inc-seq.
    else
       assign i-seq-item = param-re.seq-item-um.

    assign de-saldo = tt-estr-tmp.quantidade.

    for each saldo-terc use-index retorno where
             saldo-terc.it-codigo    = tt-estr-tmp.it-codigo and  
             saldo-terc.cod-emitente = docum-est.cod-emitente and  
             saldo-terc.quantidade   > 0 no-lock:
        find componente of saldo-terc no-lock no-error.
        if  not avail componente
        or  componente.componente = 2 then
            next.
        find first tt-terc where tt-terc.registro = rowid(saldo-terc)
             no-error.
        if  not avail tt-terc then do:
            create tt-terc.
            assign tt-terc.registro = rowid(saldo-terc).
        end.
        else do:
            if  saldo-terc.quantidade = tt-terc.quantidade then
                next.
        end.

        assign de-disponivel = saldo-terc.quantidade - tt-terc.quantidade.
        if  (saldo-terc.quantidade - tt-terc.quantidade) >= de-saldo then
            assign de-disponivel = de-saldo.

        if truncate(de-disponivel,0) <> de-disponivel and
            not item.fraciona then
            assign de-disponivel = truncate(de-disponivel,0) + 1.

        assign tt-terc.quantidade = tt-terc.quantidade + de-disponivel.
        create item-doc-est.
        assign item-doc-est.cod-emitente = docum-est.cod-emitente
               item-doc-est.nat-oper     = docum-est.nat-oper
               item-doc-est.nro-docto    = docum-est.nro-docto
               item-doc-est.serie-docto  = docum-est.serie-docto
               item-doc-est.cod-depos    = componente.cod-depos
               item-doc-est.cod-localiz  = componente.cod-localiz
               item-doc-est.lote         = componente.lote
               item-doc-est.cod-refer    = componente.cod-refer
               item-doc-est.nro-comp     = componente.nro-docto
               item-doc-est.serie-comp   = componente.serie-docto
               item-doc-est.nat-comp     = componente.nat-operacao
               item-doc-est.seq-comp     = componente.sequencia
               item-doc-est.nr-ord-prod  = input frame {&frame-name} i-ord-prod
               item-doc-est.sequencia    = i-seq-item
               item-doc-est.it-codigo    = tt-estr-tmp.it-codigo
               item-doc-est.quantidade   = de-disponivel
               item-doc-est.peso-liquido = item.peso-liquido
                                           * item-doc-est.quantidade
               i-seq-item  = i-seq-item + param-re.inc-seq
               de-saldo    = de-saldo - de-disponivel
               de-tot-peso = de-tot-peso + item-doc-est.peso-liquido
               r-registro  = rowid(item-doc-est).

        /*
        ** CE0201L3.P
        */
        run pi-geracao-III.
        
        if de-saldo <= 0 then
           leave.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao-III V-table-Win 
PROCEDURE pi-geracao-III :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    do trans:
        assign l-resposta = yes
               l-compras  = no
               de-qtd-tot-ordem = 0
               de-indice        = 1.
        if  item.tipo-contr <> 4 then do:
            find item-fornec where
                 item-fornec.it-codigo = item-doc-est.it-codigo and
                 item-fornec.cod-emite = item-doc-est.cod-emite 
                 no-lock no-error.
            if available item-fornec then do:
               assign de-indice = item-fornec.fator-conver /
                                  exp(10,item-fornec.num-casa-dec)
                      c-un      = item-fornec.unid-med-for.
            end.
            else
               assign c-un      = item.un.
        end.

        assign de-qtd-estrut   = item-doc-est.quantidade * de-indice
               item-doc-est.un = c-un.
        find saldo-terc where
             saldo-terc.cod-emitente = item-doc-est.cod-emitente and
             saldo-terc.serie        = item-doc-est.serie-comp and
             saldo-terc.nro-docto    = item-doc-est.nro-comp and
             saldo-terc.nat-operacao = item-doc-est.nat-comp and
             saldo-terc.it-codigo    = item-doc-est.it-codigo and
             saldo-terc.cod-refer    = item-doc-est.cod-refer and
             saldo-terc.sequencia    = item-doc-est.seq-comp
             no-lock no-error.
        if  l-retorno or l-sai-cons then
            find componente {cdp/cd8900.i componente saldo-terc} and
                 componente.it-codigo = saldo-terc.it-codigo and
                 componente.cod-refer = saldo-terc.cod-refer and
                 componente.sequencia = saldo-terc.sequencia
                 no-lock no-error.
                 
        if item.tipo-con-est = 2 then
            assign item-doc-est.qt-do-forn = 1.
        else
            assign item-doc-est.qt-do-forn = de-qtd-estrut.
            
        find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
        assign l-resposta = yes.
        if item-doc-est.qt-do-forn <> ? then
           assign item-doc-est.quantidade = item-doc-est.qt-do-forn / de-indice.
        assign item-doc-est.qt-do-forn = item-doc-est.quantidade
               item-doc-est.un         = item.un
               c-un                    = item-doc-est.un.
               
        if item-doc-est.qt-do-forn <> 0 and
            not l-retorno and not l-sai-cons then do:
            find item-estab where
                item-estab.cod-estabel = docum-est.cod-estabel and
                item-estab.it-codigo = item-doc-est.it-codigo no-lock no-error.
            find estab-mat where estabel.cod-estab = docum-est.cod-estabel
                 no-lock no-error.
            if available item-estab then do:
                if estab-mat.custo-contab = 2 then do:                                                        
                    assign item-doc-est.preco-unit[1] = (item-estab.val-unit-mat-o[1] +
                                                         item-estab.val-unit-mob-o[1] +
                                                         item-estab.val-unit-ggf-o[1]).
                end.
                else do:
                    assign item-doc-est.preco-unit[1] = (item-estab.val-unit-mat-m[1] +
                                                         item-estab.val-unit-mob-m[1] +
                                                         item-estab.val-unit-ggf-m[1]).
                end.
            end.
            else                                                          
                assign item-doc-est.preco-unit[1] = 0.


            assign de-valor-unit = item-doc-est.preco-unit[1]
                   item-doc-est.preco-unit[1]   = if item-doc-est.preco-unit[1] > 0 then
                                                      item-doc-est.preco-unit[1]
                                                  else if item.preco-ul-ent > 0 then
                                                      item.preco-ul-ent
                                                  else if item.preco-repos > 0 then
                                                      item.preco-repos
                                                  else if item.preco-base > 0 then
                                                      item.preco-base
                                                  else 1
                   item-doc-est.preco-total[1]  = item-doc-est.preco-unit[1] *
                                                  item-doc-est.qt-do-forn.
        end.
        else if l-retorno or l-sai-cons then do:
            assign item-doc-est.preco-total[1] = item-doc-est.quantidade *
                                                 (componente.preco-total[1] /
                                                  componente.quantidade)
                   de-valor = componente.preco-total[1].

            for each b-componente where 
                b-componente.cod-emitente = saldo-terc.cod-emitente and 
                b-componente.serie-comp   = saldo-terc.serie-docto and 
                b-componente.nro-comp     = saldo-terc.nro-docto and 
                b-componente.nat-comp     = saldo-terc.nat-operacao and 
                b-componente.it-codigo    = saldo-terc.it-codigo and 
                b-componente.cod-refer    = saldo-terc.cod-refer
                use-index comp no-lock:

                assign de-valor = de-valor + if b-componente.componente = 1 then
                                           b-componente.preco-total[1]
                                        else (b-componente.preco-total[1] * -1).

            end.
            assign de-quant-item = 0
                   de-tot-item = 0.
            for each b-item-doc-est where
                b-item-doc-est.cod-emitente = docum-est.cod-emitente and 
                b-item-doc-est.serie-docto  = docum-est.serie-docto and 
                b-item-doc-est.nro-docto    = docum-est.nro-docto and 
                b-item-doc-est.nat-operacao = docum-est.nat-operacao and 
                b-item-doc-est.serie-comp   = saldo-terc.serie and 
                b-item-doc-est.nro-comp     = saldo-terc.nro-docto and 
                b-item-doc-est.nat-comp     = saldo-terc.nat-operacao and 
                b-item-doc-est.it-codigo    = saldo-terc.it-codigo and 
                b-item-doc-est.cod-refer    = saldo-terc.cod-refer and 
                b-item-doc-est.seq-comp     = saldo-terc.sequencia no-lock:
                
               assign de-quant-item = de-quant-item + b-item-doc-est.quantidade
                      de-tot-item = de-tot-item + b-item-doc-est.preco-total[1].
            end.

            if  saldo-terc.quantidade = de-quant-item then
                assign item-doc-est.preco-total[1] = de-valor - de-tot-item +
                                                  item-doc-est.preco-total[1].

            assign item-doc-est.serie-comp = saldo-terc.serie
                   item-doc-est.nro-comp   = saldo-terc.nro-docto
                   item-doc-est.nat-comp   = saldo-terc.nat-operacao.
        end.

        assign item-doc-est.preco-unit[1] = item-doc-est.preco-total[1]
                                          / if item-doc-est.qt-do-forn <> 0 then
                                               item-doc-est.qt-do-forn
                                            else 1.
        
        assign l-compras = item-doc-est.num-pedido > 0
               item-doc-est.peso-liquido = item.peso-liquido
                                         * item-doc-est.quantidade
               item-doc-est.codigo-rejei = 0
               l-implanta = no.
               
        if  item-doc-est.nr-ord-prod > 0 then do:
            find ord-prod  where ord-prod.nr-ord-prod = item-doc-est.nr-ord-prod
                no-lock no-error.
            if  avail ord-prod then
                assign item-doc-est.ct-codigo = ord-prod.ct-codigo
                       item-doc-est.sc-codigo = ord-prod.sc-codigo.
        end.
        else do:
            if (item.tipo-contr = 1 or item.tipo-contr = 4) and 
                (item-doc-est.nr-ord-prod = 0
                or  (l-remessa and item-doc-est.nr-ord-prod = 0)) then
                assign item-doc-est.ct-codigo = item.ct-codigo
                       item-doc-est.sc-codigo = item.sc-codigo.
        end.
        assign l-implanta = yes.
        
        if item.tipo-con-est > 2 then
            assign item-doc-est.dt-vali-lote = 12/31/9999.
        if not(l-transf and item.tipo-con-est <> 1) then do on error undo,retry:

            find first saldo-estoq where
                 saldo-estoq.it-codigo = item-doc-est.it-codigo and
                 saldo-estoq.lote      = item-doc-est.lote
                 no-lock no-error.
            if avail saldo-estoq then
                 assign item-doc-est.dt-vali-lote = saldo-estoq.dt-vali-lote.
            find deposito where
                 deposito.cod-depos = item-doc-est.cod-depos
                 no-lock no-error.
        end.

        assign l-resposta = yes.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-chave V-table-Win 
PROCEDURE pi-passa-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-docum-est as rowid no-undo.
    assign r-docum-est = p-docum-est.

    find docum-est where 
        rowid(docum-est) = r-docum-est 
        EXCLUSIVE-LOCK NO-ERROR.

    find natur-oper where 
        natur-oper.nat-operacao = docum-est.nat-operacao 
        no-lock no-error.
    if available natur-oper then do:
        assign l-entrada   = if natur-oper.tipo = 1 then yes else no
               l-transf    = natur-oper.transf
               l-modulo-ge = param-global.modulo-ge
               l-remessa   = if  natur-oper.tipo = 2
                             and natur-oper.terceiros
                             and natur-oper.transf = no
                             and natur-oper.oper-terc = 2 then yes
                             else no
               l-retorno   = if  natur-oper.tipo = 1
                             and natur-oper.terceiros
                             and natur-oper.transf = no
                             and natur-oper.oper-terc = 2 then yes
                             else no
               l-ent-cons  = if  natur-oper.tipo = 1
                             and natur-oper.terceiros
                             and natur-oper.oper-terc = 1 then yes
                             else no
               l-sai-cons  = if  natur-oper.tipo = 2
                             and natur-oper.terceiros
                             and natur-oper.oper-terc = 1 then yes
                             else no.
    end.                                     

    disable i-ord-prod with frame {&frame-name}.
    if param-global.modulo-cp then
        enable i-ord-prod with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


