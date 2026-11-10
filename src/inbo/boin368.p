&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN368 2.00.00.052 } /*** "010052" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin368 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN368
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-ordem
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE excludeFrameDefinition YES

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin368.i RowObject}

{cdp/cd4329.i2} /* Aloca/Desaloca parcela de Compra */
{cdp/cd9701.i} /* Múltiplas naturezas no recebimento */

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def buffer b-rat-ordem       for rat-ordem.

def var i-cod-emitente   as int                           no-undo.
def var c-serie-docto    as char                          no-undo.
def var c-nro-docto      as char                          no-undo.
def var c-nat-operacao   as char                          no-undo.
def var i-sequencia      as int                           no-undo.

def var de-preco-total   like item-doc-est.preco-total[1] no-undo.
def var de-desconto      like item-doc-est.desconto[1]    no-undo.
def var de-qt-do-forn    like item-doc-est.qt-do-forn     no-undo.
def var de-qt-ori        like item-doc-est.quantidade     no-undo.
DEF VAR de-qt-ori-aux    LIKE item-doc-est.quantidade     NO-UNDO.
def var de-qt-alt        like item-doc-est.quantidade     no-undo.
def var de-limite-vl     as decimal                       no-undo.
def var de-percentual-vl as decimal                       no-undo.
def var de-percentual-qt as decimal                       no-undo.
def var de-limite-qt     as decimal                       no-undo.
def var de-var-max-perc  as decimal                       no-undo.
def var de-var-max-lim   as decimal                       no-undo.
def var de-indice-aux    as decimal                       no-undo.
def var l-erro           as logical                       no-undo.
def var h-boin060        as handle                        no-undo.
def var de-val-med-ori   as decimal                       no-undo.

{cdp/cd0666.i}
def var l-contrato as logical                   no-undo.
def var l-erro-co  as logical                   no-undo.
def var de-qtd-max like item-doc-est.quantidade no-undo.
def var i-total    as integer                   no-undo.

{cdp/cd9700.i} /* define variaveis para cd9700.i1 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

    for first param-compra 
        fields ( pend-aprov )
        no-lock.
    end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:   Aloca‡Æo Ordem de Compra na InclusÆo      
------------------------------------------------------------------------------*/

    find prazo-compra
        where prazo-compra.numero-ordem = RowObject.numero-ordem
          and prazo-compra.parcela      = RowObject.parcela
          exclusive-lock no-error.
 
    if  avail prazo-compra then do:
        if not (l-fatura-fat-antecip) then
            run pi-aloca-ordem-cc (input yes,
                                   input RowObject.quantidade,
                                   input rowid(prazo-compra)).
    end.        

    assign l-contrato    = no
           i-total       = 0.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        
        run verificaContrato (input RowObject.numero-ordem).

        if  l-contrato THEN
            run rep/re1001p2.p (input rCurrent,
                                input 0,
                                input yes).
        
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first prazo-compra
         where prazo-compra.numero-ordem = RowObject.numero-ordem
           and prazo-compra.parcela      = RowObject.parcela exclusive-lock no-error.
    if  avail prazo-compra then do:
        if not (l-fatura-fat-antecip OR l-fatura-ent-futura) then
            if  not can-find(docum-est where docum-est.cod-emitente = RowObject.cod-emitente 
                                         and docum-est.serie-docto  = RowObject.serie-docto 
                                         and docum-est.nro-docto    = RowObject.nro-docto
                                         and docum-est.nat-operacao = RowObject.nat-operacao 
                                         and docum-est.rec-fisico   = yes ) then do:
    
                assign prazo-compra.dec-1 = prazo-compra.dec-1 
                                          - RowObject.quantidade.
                if prazo-compra.dec-1 < 0 then
                    assign prazo-compra.dec-1 = 0.                              
            end.            
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Aloca‡Æo Ordem Compra na Modifica‡Æo
------------------------------------------------------------------------------*/

    find prazo-compra
        where prazo-compra.numero-ordem = RowObject.numero-ordem 
          and prazo-compra.parcela      = RowObject.parcela exclusive-lock no-error.
              
    if  avail prazo-compra then do:   
        /*Desaloca*/
        run pi-aloca-ordem-cc (input no,
                               input de-qt-ori-aux,
                               input rowid(prazo-compra)).

        /*Aloca*/   
        run pi-aloca-ordem-cc (input yes,
                               input RowObject.quantidade,
                               input rowid(prazo-compra)).
    end.

    assign l-contrato    = no
           i-total       = 0.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        run verificaContrato (input RowObject.numero-ordem).

        if  l-contrato then do:
            /* Desaloca */
            run rep/re1001p2.p (input RowObject.r-rowid,
                                input de-val-med-ori,
                                input no).
            /* Aloca */
            run rep/re1001p2.p (input RowObject.r-rowid,
                                input 0,
                                input yes).
        end.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizaRatOrdensFifo DBOProgram 
PROCEDURE AtualizaRatOrdensFifo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM i-qt-devol LIKE {&TableName}.quantidade NO-UNDO.

    DEFINE VARIABLE d-qtd-ant  AS DECIMAL     NO-UNDO.

    FOR EACH {&TableName}
       where {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.sequencia    = i-sequencia,
       FIRST prazo-compra OF {&tableName}
        BREAK BY prazo-compra.data-entrega DESC:

        IF i-qt-devol = 0 THEN 
            LEAVE.

        &if "{&bf_mat_versao_ems}" < "2.08" &THEN
            ASSIGN {&TableName}.dec-1 = i-qt-devol.
    
            IF ({&TableName}.dec-2 + {&TableName}.dec-1) > {&TableName}.quantidade THEN DO:
                ASSIGN d-qtd-ant = {&TableName}.dec-1.
                ASSIGN {&TableName}.dec-1 = {&TableName}.quantidade - {&TableName}.dec-2.
                ASSIGN i-qt-devol = d-qtd-ant - {&TableName}.dec-1.
            END.
            ELSE
                ASSIGN i-qt-devol = 0.
        &ELSE
            ASSIGN {&TableName}.qtd-devol = i-qt-devol.
    
            IF ({&TableName}.qtd-devolver + {&TableName}.qtd-devol) > {&TableName}.quantidade THEN DO:
                ASSIGN d-qtd-ant = {&TableName}.qtd-devol.
                ASSIGN {&TableName}.qtd-devol = {&TableName}.quantidade - {&TableName}.qtd-devolver.
                ASSIGN i-qt-devol = d-qtd-ant - {&TableName}.qtd-devol.
            END.
            ELSE
                ASSIGN i-qt-devol = 0.
        &ENDIF

    END.

    RETURN "OK".
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign l-contrato    = no
           i-total       = 0.
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        run verificaContrato (input RowObject.numero-ordem).

        if  l-contrato then
            run rep/re1001p2.p (input RowObject.r-rowid,
                                input 0,
                                input no). /* Desaloca */
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    if  valid-handle(h-boin060) then do:
        delete procedure h-boin060.
        assign h-boin060 = ?.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculateTotalOrdens DBOProgram 
PROCEDURE CalculateTotalOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param piQtdTotal like rat-ordem.quantidade no-undo.

    assign piQtdTotal = 0.


    /***** Leitura Item-docum-est *****/
    
    run findItemDocumento ( i-cod-emitente,
                            c-serie-docto,
                            c-nro-docto,
                            c-nat-operacao,
                            i-sequencia ).

    if  return-value = "NOK":U then
        return "NOK":U.
        
    for each b-rat-ordem fields(b-rat-ordem.quantidade)
       where b-rat-ordem.nro-docto    = item-doc-est.nro-docto 
         and b-rat-ordem.serie-docto  = item-doc-est.serie-docto 
         and b-rat-ordem.nat-operacao = item-doc-est.nat-operacao 
         and b-rat-ordem.cod-emitente = item-doc-est.cod-emitente 
         and b-rat-ordem.sequencia    = item-doc-est.sequencia no-lock:
      
        assign piQtdTotal = piQtdTotal +  b-rat-ordem.quantidade.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CriaRatOrdemManual DBOProgram 
PROCEDURE CriaRatOrdemManual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT-OUTPUT PARAMETER TABLE FOR RowObject.
DEF BUFFER b-rat-ordem FOR rat-ordem.

FOR EACH RowObject:
    CREATE b-rat-ordem.
    BUFFER-COPY RowObject TO b-rat-ordem.
    ASSIGN RowObject.r-rowid = ROWID(b-rat-ordem).
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EmptyQtdADevolver DBOProgram 
PROCEDURE EmptyQtdADevolver :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH {&TableName}
       where {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.sequencia    = i-sequencia:

        &if "{&bf_mat_versao_ems}" < "2.08" &THEN
            ASSIGN {&TableName}.dec-1 = 0.
        &ELSE
            ASSIGN {&TableName}.qtd-devol = 0.
        &ENDIF
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
        1. Input pType          -> Tipo de Transa‡Æo ( "Create" ou "Update" ) 
        2. Input pFieldName     -> Atributo da Tabela Item-Doc-Est
        3. Output pFieldEnable  -> Habilita ou NÆo o Atributo 
  Notes:       
        Pr‚-requisitos: Docum-est deve estar dispon¡vel.
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  pType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldEnable AS LOGICAL   NO-UNDO.

    if  not avail docum-est then    
        return "NOK":U.
        
    run findUsuario.
    
    CASE pFieldName:
        WHEN "encerrada":U  THEN ASSIGN pFieldEnable =     avail param-re
                                                       and param-re.encerra-cc.

        OTHERWISE ASSIGN pFieldEnable = yes.
        
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumento DBOProgram 
PROCEDURE findDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCod-emit   like item-doc-est.cod-emitente no-undo.
    def input param piSerie      like item-doc-est.serie-docto  no-undo.
    def input param piNro-docto  like item-doc-est.nro-docto    no-undo.
    def input param piNat-oper   like item-doc-est.nat-operacao no-undo.
    
    DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
    
    if  not avail docum-est 
    or  docum-est.serie-docto  <> piSerie
    or  docum-est.nro-docto    <> piNro-docto
    or  docum-est.nat-operacao <> piNat-oper
    or  docum-est.cod-emitente <> piCod-emit then 
    
        for first docum-est
            where docum-est.serie-docto  = piSerie
              and docum-est.nro-docto    = piNro-docto
              and docum-est.nat-operacao = piNat-oper
              and docum-est.cod-emitente = piCod-emit no-lock.
        end.

    if  not avail docum-est then do:

        IF l-mult-natur-receb = YES THEN DO:
            FIND FIRST item-doc-est
                 WHERE item-doc-est.serie-docto  <> piSerie    
                   AND item-doc-est.nro-docto    <> piNro-docto
                   AND item-doc-est.nat-operacao <> piNat-oper 
                   AND item-doc-est.cod-emitente <> piCod-emit NO-LOCK NO-ERROR.
            IF NOT AVAIL item-doc-est THEN DO:
                   {utp/ut-liter.i "Documento" *}
                   ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
                   {method/svc/errors/inserr.i
                                       &ErrorNumber="2"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters="c-lbl-liter-documento"}
                   RETURN "NOK":U.
            END.
            ELSE DO:
                for first docum-est
                    where docum-est.serie-docto  = piSerie
                      and docum-est.nro-docto    = piNro-docto
                      and docum-est.cod-emitente = piCod-emit no-lock.
                end.
            END.
        END.
        ELSE DO:
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Documento" *}
             ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-documento"}
             RETURN "NOK":U.

        END.
    end.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemDocumento DBOProgram 
PROCEDURE findItemDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCod-emit   like item-doc-est.cod-emitente no-undo.
    def input param piSerie      like item-doc-est.serie-docto  no-undo.
    def input param piNro-docto  like item-doc-est.nro-docto    no-undo.
    def input param piNat-oper   like item-doc-est.nat-operacao no-undo.
    def input param piSequencia  like item-doc-est.sequencia    no-undo.

    DEFINE VARIABLE c-lbl-liter-item-do-documento AS CHARACTER NO-UNDO.
    
    if  not avail item-doc-est 
    or  item-doc-est.serie-docto  <> piSerie
    or  item-doc-est.nro-docto    <> piNro-docto
    or  item-doc-est.nat-operacao <> piNat-oper
    or  item-doc-est.cod-emitente <> piCod-emit
    or  item-doc-est.sequencia    <> piSequencia then 
    
        for first item-doc-est
            fields ( serie-docto   nro-docto     nat-operacao
                     cod-emitente  sequencia     it-codigo 
                     quantidade    qt-do-forn    preco-total[1]
                     desconto[1]                                )
                     
            where item-doc-est.serie-docto  = piSerie
              and item-doc-est.nro-docto    = piNro-docto
              and item-doc-est.nat-operacao = piNat-oper
              and item-doc-est.cod-emitente = piCod-emit 
              and item-doc-est.sequencia    = piSequencia no-lock.
        end.

    if  not avail item-doc-est then do:
        IF l-mult-natur-receb = YES THEN DO:
            for first item-doc-est
                fields ( serie-docto   nro-docto     nat-operacao
                         cod-emitente  sequencia     it-codigo 
                         quantidade    qt-do-forn    preco-total[1]
                         desconto[1]                                )
                         
                where item-doc-est.serie-docto  = piSerie
                  and item-doc-est.nro-docto    = piNro-docto
                  and item-doc-est.cod-emitente = piCod-emit 
                  and item-doc-est.sequencia    = piSequencia no-lock.
            end.
            IF NOT AVAIL item-doc-est THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Item_do_Documento" *}
                ASSIGN c-lbl-liter-item-do-documento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-item-do-documento"}
                RETURN "NOK":U.

            END.
            ELSE 
             RETURN "OK":U.        

        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item_do_Documento" *}
            ASSIGN c-lbl-liter-item-do-documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-item-do-documento"}
            RETURN "NOK":U.
        END.
    end.
    else 
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemFornec DBOProgram 
PROCEDURE findItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem     like item-doc-est.it-codigo    no-undo.
    def input param piEmitente like item-doc-est.cod-emitente no-undo.    
        
    if  piEmitente = 0 then
        assign piEmitente = RowObject.cod-emitente.
            
    if  not avail item-fornec
    or  item-fornec.it-codigo <> piItem
    or  item-fornec.cod-emitente  <> piEmitente  then 
    
        for first item-fornec
            fields ( it-codigo      cod-emitente
                     item-do-forn   unid-med-for
                     tp-inspecao    niv-inspecao
                     fator-conver   num-casa-dec )
                     
            where item-fornec.it-codigo = piItem
              and item-fornec.cod-emitente  = piEmitente no-lock.
        end.
        
    if  not avail item-fornec then 
        RETURN "NOK":U.
    else         
        RETURN "OK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdemCompra DBOProgram 
PROCEDURE findOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNumeroOrdem   like rat-ordem.numero-ordem no-undo.
    
    if  not avail ordem-compra
    or  ordem-compra.numero-ordem <> piNumeroOrdem then 
    
        for first ordem-compra
            fields ( numero-ordem     num-pedido      it-codigo      
                     situacao         nr-contrato     pend-aprov )
                     
            where ordem-compra.numero-ordem   = piNumeroOrdem no-lock.
        end.
        
    if  not avail ordem-compra then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind ordem-compra 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPedidoCompra DBOProgram 
PROCEDURE findPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNumPedido   like rat-ordem.num-pedido no-undo.
    
    if  not avail pedido-compr
    or  pedido-compr.num-pedido <> piNumPedido then 
    
        for first pedido-compr
            fields ( num-pedido   cod-emitente   end-entrega
                     situacao     cod-estabel  )
                     
            where pedido-compr.num-pedido = piNumPedido no-lock.
        end.
        
    if  not avail pedido-compr then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind pedido-compr 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrazoCompra DBOProgram 
PROCEDURE findPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNumeroOrdem   like rat-ordem.numero-ordem no-undo.
    def input param piParcela       like rat-ordem.parcela      no-undo.


    if  not avail prazo-compra
    or  prazo-compra.numero-ordem <> piNumeroOrdem
    or  prazo-compra.parcela      <> piParcela then 
    
        for first prazo-compra
            fields ( numero-ordem    parcela         quant-saldo
                     situacao        data-entrega    dec-1    
                     quantidade      quant-rejeit     quant-receb )
                     
            where prazo-compra.numero-ordem = piNumeroOrdem 
              and prazo-compra.parcela      = piParcela no-lock.
        end.
        
    if  not avail prazo-compra then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i movind prazo-compra 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findUsuario DBOProgram 
PROCEDURE findUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    if  avail docum-est then do:
        if  not avail param-re
        or  param-re.usuario <> docum-est.usuario then 
    
            for first param-re
                fields ( usuario   variacao   aceita-var )
                where param-re.usuario = docum-est.usuario no-lock.
            end.
    end.
        
    if  not avail param-re
    or  not avail docum-est then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario-recebimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu rio_Recebimento" *}
        ASSIGN c-lbl-liter-usuario-recebimento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-usuario-recebimento"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetContratoMed DBOProgram 
PROCEDURE GetContratoMed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    
        DEFINE INPUT  PARAMETER pRowid        AS rowid                    NO-UNDO.
        DEFINE INPUT  PARAMETER piNumPedido   like rat-ordem.num-pedido   NO-UNDO.
        DEFINE INPUT  PARAMETER piNumeroOrdem like rat-ordem.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER piNrContrato  like rat-ordem.nr-contrato  NO-UNDO.
        DEFINE OUTPUT PARAMETER piNumSeqItem  like rat-ordem.num-seq-item NO-UNDO.
        DEFINE OUTPUT PARAMETER plContrato    AS logical                  NO-UNDO.
        DEFINE OUTPUT PARAMETER plTotal       AS logical                  NO-UNDO.
    
        assign plContrato = no.
        find first item-doc-est no-lock
              where rowid(item-doc-est) = pRowid no-error.
    
        IF  NOT AVAILABLE item-doc-est THEN 
            RETURN.
    
        if  not avail param-global then
            find first param-global no-lock no-error.
    
        assign l-contrato = no
               i-total    = 0.

        RUN verificaContrato (input piNumeroOrdem).

        assign piNrContrato = 0.
        if  piNumeroOrdem <> 0 then
            for first ordem-compra fields(numero-ordem num-pedido  it-codigo 
                                          situacao     nr-contrato pend-aprov num-seq-item)
                where ordem-compra.numero-ordem = piNumeroOrdem no-lock:
                assign piNrContrato = ordem-compra.nr-contrato
                       piNumSeqItem = ordem-compra.num-seq-item.
            end.                                                

        assign plContrato = l-contrato
               plTotal    = i-total = 1.
    
    &ENDIF
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataEntrega DBOProgram 
PROCEDURE getDataEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param rParent     as rowid                       no-undo.
    def output param da-data-ent like prazo-compra.data-entrega no-undo.
    
    for first rat-ordem
        where rowid(rat-ordem) = rParent no-lock.
    end.
        
    if  avail rat-ordem then do:    
    
        run findPrazoCompra ( input rat-ordem.numero-ordem,
                          input rat-ordem.parcela ).
        
        if  return-value = "NOK":U then
            return "NOK":U.
            
        assign da-data-ent = prazo-compra.data-entrega.
                      
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtidade-forn":U THEN ASSIGN pFieldValue = RowObject.qtidade-forn.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        WHEN "val-medicao" THEN ASSIGN pFieldValue = RowObject.val-medicao.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIndice DBOProgram 
PROCEDURE getIndice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piEmitente  like item-doc-est.cod-emitente  no-undo.
    def output param de-indice   as decimal                      no-undo.

    def var c-un-aux             like item-doc-est.un            no-undo.
    def var c-un                 like item-doc-est.un            no-undo.

    run findOrdemCompra ( Rowobject.numero-ordem ).
    run findItemFornec  ( ordem-compra.it-codigo,
                          piEmitente ).

    if not avail item then 
       find first item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.


    assign c-un = /*if  avail item-fornec then
                      item-fornec.unid-med-for
                  else */
                      if  avail item then 
                          item.un 
                      else 
                          " ".
    assign c-un-aux = c-un.

    if  /*avail item
    and item.tipo-contr = 4 
    and*/ RowObject.numero-ordem <> 0 then do:
        /* TRANSCRITO ACIMA: run findOrdemCompra ( Rowobject.numero-ordem ). */
        if  avail ordem-compra then do:
            find first cotacao-item
                where cotacao-item.cod-emitente = ordem-compra.cod-emitente
                  and cotacao-item.numero-ordem = ordem-compra.numero-ordem
                  and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                  no-lock no-error.
 
            if  avail cotacao-item then 
                assign c-un-aux = cotacao-item.un.
        end.
    end.

    /* c-un      - unid medida interna
       c-un-aux  - unid medida forn
    */
       {cdp/cd9950.i c-un 
                     c-un-aux
                     ordem-compra.cod-emitente}

    if  de-indice = 0 or de-indice = ? then 
        assign de-indice = 1.                  

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
        &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        WHEN "nr-contrato" THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "num-seq-item" THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "num-seq-event" THEN ASSIGN pFieldValue = RowObject.num-seq-event.
        WHEN "num-seq-medicao" THEN ASSIGN pFieldValue = RowObject.num-seq-event.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-ordem.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-ordem.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-ordem.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-ordem.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-ordem.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia = RowObject.sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "encerrada":U THEN ASSIGN pFieldValue = RowObject.encerrada.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuantSaldo DBOProgram 
PROCEDURE getQuantSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piNumeroOrdem like rat-ordem.numero-ordem no-undo.
    def input  param piParcela     like rat-ordem.parcela      no-undo.
    def output param piQuantSaldo  like rat-ordem.quantidade   no-undo.

    assign piQuantSaldo = 0.
        
                            
    run findPrazoCompra ( piNumeroOrdem,
                          piParcela ).
                          
    if  return-value = "NOK":U then
        return "NOK":U.

    if  prazo-compra.situacao = 2 then
        assign piQuantSaldo = prazo-compra.quant-saldo - prazo-compra.dec-1.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetRowidOrdemCompra DBOProgram 
PROCEDURE GetRowidOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM r-ordem-compra AS ROWID NO-UNDO.

    IF AVAIL ordem-compra THEN
        ASSIGN r-ordem-compra = rowid(ordem-compra).        
    ELSE 
        RETURN "nok".

    RETURN "OK".

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuantOriginal DBOProgram 
PROCEDURE getQuantOriginal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Aloca»’o Ordem Compra na Modifica»’o
------------------------------------------------------------------------------*/
    
    ASSIGN de-qt-ori-aux = 0.
    FOR FIRST bfrat-ordem NO-LOCK
        WHERE bfrat-ordem.serie-docto   = RowObject.serie-docto 
          AND bfrat-ordem.nro-docto     = RowObject.nro-docto 
          AND bfrat-ordem.cod-emitente  = RowObject.cod-emitente 
          AND bfrat-ordem.nat-operacao  = RowObject.nat-operacao 
          AND bfrat-ordem.sequencia     = RowObject.sequencia
          AND bfrat-ordem.numero-ordem  = RowObject.numero-ordem
          AND bfrat-ordem.parcela       = RowObject.parcela:
          ASSIGN de-qt-ori-aux = bfrat-ordem.quantidade.
    END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesItemMatEstab DBOProgram 
PROCEDURE getValuesItemMatEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna percentual e limite de varia‡Æo cadastrado para o item. 
------------------------------------------------------------------------------*/

    def output param de-var-perc-vl   as decimal no-undo.
    def output param de-var-lim-vl    as decimal no-undo.
    def output param de-var-perc-qt   as decimal no-undo.
    def output param de-var-lim-qt    as decimal no-undo.
    

    for first item-uni-estab
        fields ( it-codigo   var-val-re-maior
                 var-qtd-re  lim-var-valor
                 cod-estabel lim-var-qtd    )
        where item-uni-estab.it-codigo   = item-doc-est.it-codigo
          and item-uni-estab.cod-estabel = docum-est.cod-estabel no-lock.
        
    end.
    
    if  not avail item-uni-estab
    or (     avail item-uni-estab 
        and (   item-uni-estab.var-val-re-maior = 0
             or item-uni-estab.lim-var-valor    = 0
             or item-uni-estab.var-qtd-re       = 0
             or item-uni-estab.lim-var-qtd      = 0 ) ) then do:
        for first item-mat
            fields ( it-codigo      var-val-re-maior
                     lim-var-valor  var-qtd-re     
                     lim-var-qtd                     ) 
            where item-mat.it-codigo = item-doc-est.it-codigo no-lock.
        end.
    end.
    
    assign de-var-perc-vl  = if  avail item-uni-estab
                             and item-uni-estab.var-val-re-maior > 0 
                             then item-uni-estab.var-val-re-maior
                             else item-mat.var-val-re-maior

           de-var-lim-vl   = if  avail item-uni-estab
                             and item-uni-estab.lim-var-valor > 0 
                             then item-uni-estab.lim-var-valor
                             else item-mat.lim-var-valor

           de-var-perc-qt  = if  avail item-uni-estab
                             and item-uni-estab.var-qtd-re > 0 
                             then item-uni-estab.var-qtd-re
                             else item-mat.var-qtd-re
                                 
           de-var-lim-qt   = if  avail item-uni-estab
                             and item-uni-estab.lim-var-qtd > 0 
                             then item-uni-estab.lim-var-qtd
                             else item-mat.lim-var-qtd.
                                             


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesMed DBOProgram 
PROCEDURE getValuesMed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Recebe os valores do tt-item-doc-est (tela) para que seja poss¡vel fazer 
         as valida‡äes de valor e quantidade e aloca‡Æo/desaloca‡Æo.      
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        def input param piValMed like rat-ordem.val-medicao no-undo.

        assign de-val-med-ori  = piValMed.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesTtItemDocEst DBOProgram 
PROCEDURE getValuesTtItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Recebe os valores do tt-item-doc-est (tela) para que seja poss¡vel fazer 
         as valida‡äes de valor e quantidade e aloca‡Æo/desaloca‡Æo.      
------------------------------------------------------------------------------*/
    
    def input param piPrecoTotal  like item-doc-est.preco-total[1] no-undo.
    def input param piDesconto    like item-doc-est.desconto[1]    no-undo.
    def input param piQtdForn     like item-doc-est.qt-do-forn     no-undo. 
    def input param piQtdItem     like item-doc-est.quantidade     no-undo.
    def input param piQtdRatOrdem like item-doc-est.quantidade     no-undo.
    
    assign de-preco-total = piPrecoTotal
           de-desconto    = piDesconto
           de-qt-do-forn  = piQtdForn
           de-qt-alt      = piQtdItem
           de-qt-ori      = piQtdRatOrdem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-ordem.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-ordem.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-ordem.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-ordem.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-ordem.sequencia NO-UNDO.

    FIND FIRST bfrat-ordem WHERE 
        bfrat-ordem.serie-docto = pserie-docto AND 
        bfrat-ordem.nro-docto = pnro-docto AND 
        bfrat-ordem.cod-emitente = pcod-emitente AND 
        bfrat-ordem.nat-operacao = pnat-operacao AND 
        bfrat-ordem.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-ordem THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-ordem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFinds DBOProgram 
PROCEDURE initializeFinds :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /***** Leitura Docum-est *****/
    
    run findDocumento ( i-cod-emitente,
                        c-serie-docto,
                        c-nro-docto,
                        c-nat-operacao ).

    /***** Leitura Item-docum-est *****/
    
    run findItemDocumento ( i-cod-emitente,
                            c-serie-docto,
                            c-nro-docto,
                            c-nat-operacao,
                            i-sequencia ).

    /***** Leitura Parƒmetros Usu rio Recebimento *****/
    
    run findUsuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem-Doc-Est DBOProgram 
PROCEDURE linkToItem-Doc-Est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pHandle as handle no-undo.


   run getKey in pHandle (output i-cod-emitente,
                          output c-serie-docto,
                          output c-nro-docto,
                          output c-nat-operacao,
                          output i-sequencia).

   
   return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         no-lock 
         indexed-reposition.


    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain-1 DBOProgram 
PROCEDURE openQueryMain-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       no-lock 
       indexed-reposition.


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemDocEst DBOProgram 
PROCEDURE openQueryOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.sequencia    = i-sequencia
         no-lock
         indexed-reposition.
         
         
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfItemDocEst DBOProgram 
PROCEDURE setConstraintOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.
    def input param i-seq       as int  no-undo.

        assign i-cod-emitente = i-cod-emit
               c-serie-docto  = c-ser-docto
               c-nro-docto    = c-nr-docto
               c-nat-operacao = c-nat-oper
               i-sequencia    = i-seq.

    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
        
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    def var de-quantidade-total  like item-doc-est.quantidade no-undo.
    def var de-sdo-vl-med        as   decimal                 no-undo.
    def var de-sdo-med-contrat   as   decimal                 no-undo.
    DEF VAR l-contrato-novo      AS   LOGICAL                 NO-UNDO.
    DEF BUFFER bf-natur-oper-fut   FOR natur-oper.
    DEF BUFFER bf-prazo-compra-fut FOR prazo-compra.
    DEF BUFFER bf-item-doc-est-fut FOR item-doc-est.
    DEF BUFFER bf-ordem-compra-fut FOR ordem-compra.
    DEF BUFFER bf-docum-est-fut    FOR docum-est.
    DEF VAR de-total-ordens   AS DEC NO-UNDO.
    DEF VAR de-tot-recbda-fut AS DEC NO-UNDO.

	DEFINE VARIABLE h-re1008    AS HANDLE   NO-UNDO.
	define variable c-liter     as character no-undo.
	
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    
    find first param-compra no-lock no-error.
    
    find first param-global no-lock no-error.
    
    /***** Leitura Docum-est *****/

    run findDocumento ( RowObject.cod-emitente,
                        RowObject.serie-docto,
                        RowObject.nro-docto,
                        RowObject.nat-operacao ).

    if  return-value <> "OK" then
        return "NOK":U.                            

    if  docum-est.ce-atual then do:
    {method/svc/errors/inserr.i
                        &ErrorNumber="19515" /*Nota fiscal j  atualizada*/
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" }
    end.        


    /***** Leitura Item-docum-est *****/

    run findItemDocumento ( RowObject.cod-emitente,
                            RowObject.serie-docto,
                            RowObject.nro-docto,
                            RowObject.nat-operacao,
                            RowObject.sequencia ).

    if  return-value <> "OK" then
        return "NOK":U.

    assign l-contrato    = no
           i-total       = 0
           de-sdo-vl-med = 0.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        {cdp/cd9731.i2}  /*l-rat-med e  l-rat-contr-tot*/
        run verificaContrato (input RowObject.numero-ordem).
        ASSIGN l-contrato-novo = l-contrato.
    
        if  l-contrato-novo then
            run cnp/cn9175.p (input 1,
                              input rowid(item-doc-est),
                              input RowObject.numero-ordem,
                              input RowObject.num-seq-item,
                              input RowObject.num-seq-event,  
                              input RowObject.num-seq-medicao,
                              output l-erro,
                              output de-sdo-vl-med,
                              output table tt-erro).
        
    &ENDIF

    if  pType <> "DELETE":U then do:

        /*--- quando a nota eh fatura entrega futura, a quantidade recebida nao pode ser maior do que
              a quantidade da ordem de compra. Essa validacao eh necessaria porque na atualizacao da 
              nota de fatura a ordem de compra nao eh baixada, fazendo com que as validacoes padroes 
              em relacao ao saldo da ordem de compra nao sejam feitas ---*/

        find bf-natur-oper-fut where
             bf-natur-oper-fut.nat-operacao = rowObject.nat-operacao no-lock no-error.

        /*--- verifica se docum-est eh de nota de fatura faturamento ou fatura entrega futura ---*/
        {cdp/cd9700.i1 bf-natur-oper-fut}

        IF  l-fatura-fat-antecip
        OR  l-fatura-ent-futura THEN DO:

            ASSIGN de-total-ordens   = 0  /*---> armazena a quantidade da ordem ---*/
                   de-tot-recbda-fut = 0. /*---> armazena a quantidade ja recebida em notas atualizadas ou apenas digitadas ---*/

            /*--- verifica outros itens para a mesma ordem de compra, cuja NF ainda nao atualizada ---*/
            FOR EACH bf-item-doc-est-fut FIELDS(nro-docto serie-docto nat-operacao cod-emitente
                                                numero-ordem num-pedido parcela quantidade)
                WHERE bf-item-doc-est-fut.numero-ordem = RowObject.numero-ordem
                  AND bf-item-doc-est-fut.num-pedido   = RowObject.num-pedido
                  AND bf-item-doc-est-fut.parcela      = RowObject.parcela NO-LOCK,
                  FIRST bf-docum-est-fut FIELDS(ce-atual) OF bf-item-doc-est-fut
                  WHERE bf-docum-est-fut.ce-atual = NO NO-LOCK:
                ASSIGN de-tot-recbda-fut = de-tot-recbda-fut + bf-item-doc-est-fut.quantidade.
            END.

            /*--- verifica a quantidade ja recebida em faturas de entrega futuras ja atualizadas ---*/
            FOR FIRST bf-prazo-compra-fut FIELDS(qtd-recbda-fut)
                WHERE bf-prazo-compra-fut.numero-ordem = rowObject.numero-ordem 
                  AND bf-prazo-compra-fut.parcela      = rowObject.parcela NO-LOCK:
                ASSIGN de-tot-recbda-fut = de-tot-recbda-fut + bf-prazo-compra-fut.qtd-recbda-fut.
            END. 


            /*--- verifica qtde recebidas em outras notas de fifo, cuja nfe ainda nao foi atualizada ---*/
            FOR EACH  b-rat-ordem
                WHERE b-rat-ordem.num-pedido   = rowObject.num-pedido 
                  AND b-rat-ordem.numero-ordem = rowObject.numero-ordem 
                  AND b-rat-ordem.parcela      = rowObject.parcela
                  AND ROWID(b-rat-ordem) <> rowObject.r-rowid NO-LOCK,
                FIRST bf-docum-est-fut {cdp/cd8900.i bf-docum-est-fut b-rat-ordem}
                  AND bf-docum-est-fut.ce-atual = NO NO-LOCK:
                ASSIGN de-tot-recbda-fut = de-tot-recbda-fut + b-rat-ordem.quantidade.
            END.

            /*--- verifica qual ‚ a quantidade da parcela ---*/
            FIND bf-prazo-compra-fut WHERE
                 bf-prazo-compra-fut.numero-ordem = rowObject.numero-ordem AND
                 bf-prazo-compra-fut.parcela      = rowObject.parcela NO-LOCK NO-ERROR.

            IF  AVAIL bf-prazo-compra-fut THEN
                ASSIGN de-total-ordens = de-total-ordens + bf-prazo-compra-fut.quantidade. 

            /*--- se a qtde q esta sendo recebida + qtde jah recebida for maior
                  que q qtde da ordem, entao emite msg de erro ---*/
            if  rowObject.quantidade + de-tot-recbda-fut > de-total-ordens then do:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-ordem-de-compra-sem-saldo-para AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Ordem_de_compra_sem_saldo_para_Fatura_Entreg_Futura" *}
                ASSIGN c-lbl-liter-ordem-de-compra-sem-saldo-para = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-nao-ha-saldo-suficiente-na-ord AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_h _saldo_suficiente_na_ordem_de_compra_para_receber_a_Fatura_de_Entrega_Futura._Verifique_se_existem_outras_NFEs_para_a_mesma_ordem_de_compra" *}
                ASSIGN c-lbl-liter-nao-ha-saldo-suficiente-na-ord = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-ordem-de-compra-sem-saldo-para + '~~~~~' +
                                                      c-lbl-liter-nao-ha-saldo-suficiente-na-ord" }

            end.
        END.

        if  not valid-handle(h-boin060) then 
            run inbo/boin060.p persistent set h-boin060.

        /***** Leitura Usu rio Recebimento *****/
        
        run findUsuario.

        if  return-value <> "OK" then
            return "NOK":U.
                    
        if  RowObject.numero-ordem <> 0 
        and RowObject.num-pedido   =  0 then do:
            run findOrdemCompra ( RowObject.numero-ordem ).
        
            if  avail ordem-compra then do:
                if ordem-compra.num-pedido = 0 then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15185" /*Ordem de compra nÆo possui pedido*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
                end.
                else 
                    assign RowObject.num-pedido = ordem-compra.num-pedido.
            end.
        end.


        /* Valida Pedido */
        if  RowObject.num-pedido <> 0 then do:
            run findPedidoCompra ( RowObject.num-pedido ) .
        
            if  return-value = "NOK":U then
                return "NOK":U.
            
            if  pedido-compr.situacao = 3 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="7169" /*Pedido de compra eliminado*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }

            end.

			/*
			Valida bloqueio quando estabelecimento de entrega do pedido for diferente do estabelecimento do documento
			*/
			{utp/ut-liter.i "Seq:_" *}
			c-liter	= return-value  + string(rowObject.sequencia).
			run rep/re1008.p persistent set h-re1008.
			run pi-execute in h-re1008 (input RowObject.num-pedido,
										input docum-est.cod-estabel,
										input c-liter,
										OUTPUT TABLE RowErrors APPEND).
			delete procedure h-re1008.
			h-re1008 = ?.				
			if not can-find(first RowErrors where RowErrors.ErrorNumber = 57853) then
				if pedido-compr.end-entrega <> docum-est.cod-estabel then do:
					{method/svc/errors/inserr.i
										&ErrorNumber="6814" /*Estabelecimento de entrega do pedido ý diferente do estabelecimento do documento.*/
										&ErrorType="EMS"
										&ErrorSubType="WARNING" }
				end.
            
            run rep/re1007.p (input pedido-compr.cod-emitente,
                              input docum-est.cod-emitente,
                              input-output table RowErrors).
			       
            run findOrdemCompra ( RowObject.numero-ordem ).
            
            if  return-value = "NOK":U then
                return "NOK":U.
            
            if  RowObject.num-pedido <> ordem-compra.num-pedido then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="7342" /*Ordem de compra nÊo pertence ao pedido*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.
            if  ordem-compra.nr-contrato = 0 or
                (ordem-compra.nr-contrato <> 0 and i-total <> 1) then
                if  item-doc-est.it-codigo <> ordem-compra.it-codigo then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15187" /*Item da ordem nÊo confere com item da nota fiscal*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
                end.
            if  ordem-compra.situacao <> 2 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="15188" /*Situa‡Æo da ordem nÊo permite movimenta‡Æo*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.
            if  ordem-compra.situacao = 2 and
                param-compra.pend-aprov = 2 and
                ordem-compra.pend-aprov = 2 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="8813" /*Ordem de compra pendente de aprova¯Êo. NÊo pode ser recebida*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.

            for first prazo-compra 
        
                fields ( numero-ordem    parcela         quant-saldo
                         situacao        data-entrega    dec-1    
                         quantidade      quant-rejeit     quant-receb )

                where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                  and prazo-compra.situacao     = 2 no-lock.
            end.
              
            if  not available prazo-compra and not l-contrato-novo then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="7343" /*Ordem de compra nÊo possui parcelas confirmadas*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.
 
 
/*            if  pType = "CREATE":U  then do:
 *             
 *                 find b-rat-ordem 
 *                     where b-rat-ordem.nro-docto    = item-doc-est.nro-docto 
 *                       and b-rat-ordem.serie-docto  = item-doc-est.serie-docto 
 *                       and b-rat-ordem.nat-operacao = item-doc-est.nat-operacao 
 *                       and b-rat-ordem.cod-emitente = item-doc-est.cod-emitente 
 *                       and b-rat-ordem.sequencia    = item-doc-est.sequencia 
 *                       and b-rat-ordem.num-pedido   = Rowobject.num-pedido   
 *                       and b-rat-ordem.numero-ordem = Rowobject.numero-ordem 
 *                       and b-rat-ordem.parcela      = Rowobject.parcela
 *                     no-lock no-error.
 *                 if  avail b-rat-ordem then do:
 *                     {method/svc/errors/inserr.i
 *                                 &ErrorNumber="1"
 *                                 &ErrorType="EMS"
 *                                 &ErrorSubType="ERROR" 
 *                                 &ErrorParameters="'Parcela'"}
 *                 end.
 *  
 *                 run CalculateTotalOrdens ( output de-quantidade-total ).
 *                  
 *                 if  (de-quantidade-total + RowObject.quantidade) > de-qt-alt then do:
 *                     {method/svc/errors/inserr.i
 *                                         &ErrorNumber="18816"
 *                                         &ErrorType="EMS"
 *                                         &ErrorSubType="ERROR" 
 *                                         &ErrorParameters="STRING(de-qt-alt - de-quantidade-total)"}
 *                 end.
 *             end.
 *             else do:  /* Modifica‡Æo */
 * 
 *                 run CalculateTotalOrdens ( output de-quantidade-total ).
 * 
 *                 /* de-qt-ori = quantidade original do rat-ordem
 *                    de-qt-alt = quantidade atual do item-doc-est    */
 *                     
 *                 if (de-quantidade-total + RowObject.quantidade - de-qt-ori) > de-qt-alt then do:
 *                     {method/svc/errors/inserr.i
 *                                         &ErrorNumber="18816"
 *                                         &ErrorType="EMS"
 *                                         &ErrorSubType="ERROR" 
 *                                         &ErrorParameters="STRING(de-qt-alt - de-quantidade-total)"}
 *                 end.
 *             end.*/
 
            run findPrazoCompra ( input RowObject.numero-ordem,
                                  input RowObject.parcela ).

            if  avail prazo-compra
            and prazo-compra.situacao <> 2 
            and not l-contrato-novo then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="6897" /*Situa‡Æo da parcela nÊo permite movimenta‡Æo*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            end.
            if  avail prazo-compra
            and avail param-re
            and not l-contrato-novo
            and (   prazo-compra.data-entrega > docum-est.dt-emissao + param-re.variacao 
                 or prazo-compra.data-entrega < docum-est.dt-emissao - param-re.variacao) then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="18817" /*Data de entrega da parcela esta fora da varia‡Æo.*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="WARNING" }
            end.

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                FOR FIRST bfrat-ordem 
                    WHERE bfrat-ordem.serie-docto   = RowObject.serie-docto 
                    AND   bfrat-ordem.nro-docto     = RowObject.nro-docto 
                    AND   bfrat-ordem.cod-emitente  = RowObject.cod-emitente 
                    AND   bfrat-ordem.nat-operacao  = RowObject.nat-operacao 
                    AND   bfrat-ordem.sequencia     = RowObject.sequencia NO-LOCK:
                    run verificaContrato (input bfrat-ordem.numero-ordem).
                END.

                IF  (l-contrato AND NOT l-contrato-novo) OR
                    (NOT l-contrato AND l-contrato-novo) THEN DO:
                    IF  l-contrato AND NOT l-contrato-novo THEN DO:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="31429" /*Dever  ser informado somente ordens com contrato por medi‡Æo.*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}

                    END.

                    IF NOT l-contrato AND l-contrato-novo THEN DO:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="31430" /*NÆo ‚ permitido informar ordem com contrato por medi‡Æo.*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
                    END.

                END.
                ELSE DO:
                    if  l-contrato-novo then do:
                        IF  AVAIL bfrat-ordem AND bfrat-ordem.numero-ordem <> RowObject.numero-ordem THEN DO:
                            {method/svc/errors/inserr.i
                                                &ErrorNumber="31428" /*Todas as medi‡äes informadas deverÆo pertencer a ordem &1.*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="bfrat-ordem.numero-ordem"}
                        END.

                        IF  pType = "ADD":U THEN
                            IF  CAN-FIND(FIRST bfrat-ordem 
                                         WHERE bfrat-ordem.serie-docto     = RowObject.serie-docto 
                                         AND   bfrat-ordem.nro-docto       = RowObject.nro-docto 
                                         AND   bfrat-ordem.cod-emitente    = RowObject.cod-emitente 
                                         AND   bfrat-ordem.nat-operacao    = RowObject.nat-operacao
                                         AND   bfrat-ordem.num-pedido      = RowObject.num-pedido
                                         AND   bfrat-ordem.numero-ordem    = RowObject.numero-ordem
                                         AND   bfrat-ordem.nr-contrato     = RowObject.nr-contrato
                                         AND   bfrat-ordem.num-seq-item    = RowObject.num-seq-item
                                         AND   bfrat-ordem.num-seq-medicao = RowObject.num-seq-medicao
                                         AND   bfrat-ordem.num-seq-event   = RowObject.num-seq-event ) THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-medicao AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Medi‡Æo" *}
                                ASSIGN c-lbl-liter-medicao = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="1" /*J  existe ocorrˆncia &1 informada.*/
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-lbl-liter-medicao" }
                            END.

                        for first  item-contrat fields(ind-tipo-control ind-caract-item ind-tipo-control-val nr-contrato num-seq-item) 
                             where item-contrat.nr-contrato  = RowObject.nr-contrato 
                             and   item-contrat.num-seq-item = RowObject.num-seq-item no-lock: end.

                        /* Verifica se nÆo foi informada conta de aplica‡Æo no recebimento, em caso afirmativo todas as 
                           medi‡äes selecionadas deverÆo possuir matriz de rateio */
                        if (l-rat-med and l-rat-contr-tot)
                        OR (l-rat-med and avail item-contrat and item-contrat.ind-tipo-control = 1) then do:
                            IF  item-doc-est.ct-codigo = " " THEN DO:
                                IF  NOT CAN-FIND(FIRST matriz-rat-med
                                         WHERE matriz-rat-med.nr-contrato     = RowObject.nr-contrato
                                           AND matriz-rat-med.num-seq-item    = RowObject.num-seq-item
                                           AND matriz-rat-med.numero-ordem    = RowObject.numero-ordem
                                           AND matriz-rat-med.num-seq-event   = RowObject.num-seq-event
                                           AND matriz-rat-med.num-seq-medicao = RowObject.num-seq-medicao) THEN DO:
                                    {method/svc/errors/inserr.i
                                                        &ErrorNumber="31427" /*Medi‡Æo informada dever  possuir matriz de rateio.*/
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"}
                                END.                                          
                            END.
                        end.

                        IF  pType = "UPDATE":U THEN DO:

                            FIND FIRST bfrat-ordem NO-LOCK
                                 WHERE bfrat-ordem.serie-docto     = RowObject.serie-docto 
                                 AND   bfrat-ordem.nro-docto       = RowObject.nro-docto 
                                 AND   bfrat-ordem.cod-emitente    = RowObject.cod-emitente 
                                 AND   bfrat-ordem.nat-operacao    = RowObject.nat-operacao
                                 AND   bfrat-ordem.sequencia       = RowObject.sequencia
                                 AND   bfrat-ordem.num-pedido      = RowObject.num-pedido
                                 AND   bfrat-ordem.numero-ordem    = RowObject.numero-ordem
                                 AND   bfrat-ordem.nr-contrato     = RowObject.nr-contrato
                                 AND   bfrat-ordem.num-seq-item    = RowObject.num-seq-item
                                 AND   bfrat-ordem.num-seq-medicao = RowObject.num-seq-medicao
                                 AND   bfrat-ordem.num-seq-event   = RowObject.num-seq-event NO-ERROR.
                            
                            IF  AVAIL bfrat-ordem THEN
                                ASSIGN de-sdo-vl-med = de-sdo-vl-med + bfrat-ordem.val-medicao.

                        END.

                        if  de-sdo-vl-med = 0 then do:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-medicao-liberada AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Medi‡Æo_liberada" *}
                            ASSIGN c-lbl-liter-medicao-liberada = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                                &ErrorNumber="2" /*Valor informado maior que o saldo liberado para medi‡Æo.*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-medicao-liberada" }
                        end.
                        ELSE if  RowObject.val-medicao > de-sdo-vl-med then do:
                                {method/svc/errors/inserr.i
                                                    &ErrorNumber="30833" /*Valor informado maior que o saldo liberado para medi‡Æo.*/
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR" }
                        end.
                        ELSE do:
                            assign de-sdo-med-contrat = 0.
                            for each  medicao-contrat fields(num-seq-event numero-ordem sld-val-medicao val-sdo-aloc-med)  
                                where medicao-contrat.nr-contrato       = ordem-compra.nr-contrato
                                and   medicao-contrat.numero-ordem      = ordem-compra.numero-ordem
                                and   medicao-contrat.ind-sit-medicao   = 2
                                and   medicao-contrat.log-rec-medicao   = NO
                                and   medicao-contrat.dat-prev-medicao <= docum-est.dt-emissao
                                and  (medicao-contrat.sld-val-medicao - medicao-contrat.val-sdo-aloc-med  > 0)
                                and  (if RowObject.num-seq-event <> 0 
                                      then medicao-contrat.num-seq-event = RowObject.num-seq-event  /* Evento */
                                      else yes) no-lock:
                                
                                if  medicao-contrat.num-seq-event <> 0 then do:
                                    
                                    for first evento-ped fields(ind-sit-event)
                                        where evento-ped.numero-ordem = medicao-contrat.numero-ordem
                                        and   evento-ped.seq-evento   = medicao-contrat.num-seq-event no-lock: end.
    
                                    IF  avail evento-ped 
                                          and evento-ped.ind-sit-event <> 2 
                                          and evento-ped.ind-sit-event <> 4 then next.
    
                                end.
    
                                assign de-sdo-med-contrat = de-sdo-med-contrat + (medicao-contrat.sld-val-medicao - medicao-contrat.val-sdo-aloc-med).
    
                            end.
    
                            if  RowObject.val-medicao > de-sdo-vl-med 
                            and RowObject.val-medicao > de-sdo-med-contrat THEN DO:
                                 {method/svc/errors/inserr.i
                                                    &ErrorNumber="30833" /*Valor informado maior que o saldo liberado para medi‡Æo.*/
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR" }
                            END.
                        END.
                    end.
                END.
            &ENDIF

        end.
        else do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-pedidoordem AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Pedido/Ordem" *}
           ASSIGN c-lbl-liter-pedidoordem = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                               &ErrorNumber="54" /*Deve ser informado Pedido/Ordem de compra*/
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="c-lbl-liter-pedidoordem" } 
        end.

        if  not l-contrato-novo and
            not l-remessa-ent-futura and
            not l-remessa-fat-antecip then
            run validateVariationValue.
        
        if  RowObject.quantidade = 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-quantidade AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Quantidade" *}
            ASSIGN c-lbl-liter-quantidade = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="1491" /*Quantidade deve ser diferente de zero*/
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="c-lbl-liter-quantidade"}
        end.        

        &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            IF  l-contrato-novo THEN
                if  RowObject.val-medicao = 0 then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-valor-medicao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Valor_Medi‡Æo" *}
                    ASSIGN c-lbl-liter-valor-medicao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="1491" /*Quantidade deve ser diferente de zero*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="c-lbl-liter-valor-medicao"}
                end.        
        &ENDIF
        
        IF docum-est.origem <> "I"   AND
           docum-est.origem <> "XML" THEN DO:
           if  (pType = "create") or 
               (pType = "update" and rowObject.quantidade <> rat-ordem.quantidade) or 
               (pType = "update" and rowObject.qtidade-forn = 0) then do:
               /* achar de-indice-aux */
               run findPedidoCompra ( input RowObject.num-pedido ).
          
               IF  RETURN-VALUE = "OK":U THEN
                   run getIndice ( input pedido-compr.cod-emitente,
                                   output de-indice-aux ).
               assign rowObject.qtidade-forn = rowObject.quantidade * de-indice-aux.
           end.
        END.

        if  not l-contrato-novo and
            not l-remessa-ent-futura and
            not l-remessa-fat-antecip then
            run validateVariationQuantity ( input pType ).    

    end.
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateVariationQuantity DBOProgram 
PROCEDURE validateVariationQuantity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pType as char      no-undo.

    def var de-qtd-tot-ordem  as decimal   no-undo.
    def var de-qtd-aux        as decimal   no-undo.
    def var de-qtd-var        as decimal   no-undo.
    def var de-qtd-max        as decimal   no-undo.

    run findPrazoCompra ( RowObject.numero-ordem,
                          RowObject.parcela ).
               
    IF  return-value = "NOK":U then
        return "NOK":U.


    if  pType = "CREATE":U then 
        assign de-qtd-aux = 0.
    else 
        assign de-qtd-aux = de-qt-ori.
                
    
    assign de-qtd-max = (prazo-compra.quant-saldo - prazo-compra.dec-1) 
                        + de-qtd-aux.

    run getValuesItemMatEstab ( output de-percentual-vl,
                                output de-limite-vl,
                                output de-percentual-qt,
                                output de-limite-qt ).                  

    for each prazo-compra 
        fields ( numero-ordem     quantidade
                 quant-saldo      dec-1
                 quant-receb      quant-rejeit )
        use-index ordem
        where prazo-compra.numero-ordem = RowObject.numero-ordem
        no-lock:
        
        assign de-qtd-tot-ordem = de-qtd-tot-ordem + prazo-compra.quantidade.

        if (prazo-compra.quant-receb + prazo-compra.dec-1 - quant-rejeit) >       
                                             prazo-compra.quantidade then
            assign de-qtd-var = de-qtd-var
                              + (prazo-compra.quant-receb
                              +  prazo-compra.dec-1
                              -  prazo-compra.quant-rejeit)
                              -  prazo-compra.quantidade.
    end.
    
    
    assign de-qtd-aux = round(de-qtd-tot-ordem * de-percentual-qt / 100 , 4).
    assign de-qtd-aux = de-qtd-aux - de-qtd-var.
    assign de-qtd-aux = if   de-qtd-aux < 0 then 0 
                        else de-qtd-aux.
    
    assign de-var-max-perc = de-qtd-max + de-qtd-aux
           de-var-max-lim  = de-limite-qt + de-qtd-max.

         
    assign l-erro = no.
            
    if  de-percentual-qt = 0
    and de-limite-qt = 0 then do:
        if  RowObject.quantidade > de-var-max-perc
        or  RowObject.quantidade > de-var-max-lim then
            assign l-erro = yes.    
    end.        
    else 
        if  RowObject.quantidade <=  de-var-max-perc 
        or  de-percentual-qt = 0 then 
            if  RowObject.quantidade > de-var-max-lim  
            and de-limite-qt <> 0 then  
                 assign l-erro = yes. 
            else  
                 assign l-erro = no. 
        else 
            assign l-erro = yes. 
            
    if  l-erro then do:

        if  param-re.aceita-var = no then do:                               
                
            {method/svc/errors/inserr.i
                                &ErrorNumber="5928" /*mensagem: Quantidade fora da variacao permitida */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }

        end.
        else do:        
            {method/svc/errors/inserr.i
                                &ErrorNumber="18799" /*mensagem: Quantidade fora da variacao permitida.*/
                                &ErrorType="EMS"
                                &ErrorSubType="WARNING" }
        end.    
    end.

    run updateConsistNota in h-boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         RowObject.sequencia,
                                         not (l-erro),
                                        ( if de-var-max-perc < de-var-max-lim  
                                          then de-var-max-perc 
                                          else de-var-max-lim),
                                          RowObject.quantidade,
                                          5698,
                                         1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateVariationValue DBOProgram 
PROCEDURE validateVariationValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-preuni        as decimal no-undo.
    def var de-preco-unit    as decimal no-undo.
    def var de-desconto-ord  as decimal no-undo.
    def var de-taxa          as decimal no-undo.
    DEF VAR de-vl-tot        AS DECIMAL NO-UNDO.
    DEF VAR de-preco-unit-ordem AS DECIMAL NO-UNDO.
    
    run findOrdemCompra ( RowObject.numero-ordem ).
    
    if  return-value = "NOK":U then
        return "NOK":U.

    RUN getQuantOriginal.

    IF  AVAIL item-doc-est THEN 
        RUN getValuesTtItemDocEst(INPUT item-doc-est.preco-total[1],
                                  INPUT item-doc-est.desconto[1],
                                  INPUT item-doc-est.qt-do-forn,
                                  INPUT item-doc-est.quantidade,
                                  INPUT de-qt-ori-aux).

    IF AVAIL item-doc-est THEN
        ASSIGN de-preuni = item-doc-est.preco-unit[1].
    ELSE
        ASSIGN de-preuni = ROUND((de-preco-total - de-desconto) / de-qt-do-forn, 5).

    ASSIGN de-preuni = if de-preuni = ? then 1 else de-preuni.

    run rep/re1908.p (input rowid(ordem-compra),
                      input docum-est.dt-emissao,
                      output de-preco-unit,
                      output de-desconto-ord,
                      output de-taxa).
    
    ASSIGN de-preco-unit = ROUND(de-preco-unit,5)
           de-preco-unit-ordem = de-preco-unit - de-desconto-ord
		   de-preco-unit-ordem = ROUND(de-preco-unit-ordem, 5).
    
    run getValuesItemMatEstab ( output de-percentual-vl,
                                output de-limite-vl,
                                output de-percentual-qt,
                                output de-limite-qt ).       
    IF param-re.aceita-var THEN
        ASSIGN de-var-max-perc = round(de-preco-unit-ordem +
                                   (de-preco-unit-ordem * de-percentual-vl / 100), 5)
               de-var-max-lim = round((de-preco-unit-ordem + de-limite-vl), 5).
    ELSE 
        ASSIGN de-var-max-perc = round(de-preco-unit-ordem, 5)
               de-var-max-lim = round(de-preco-unit-ordem , 5).
    
    
    ASSIGN l-erro = no.          
    if  de-percentual-vl = 0
    and de-limite-vl = 0 then do:
        if  de-preuni > de-var-max-perc
        or  de-preuni > de-var-max-lim then
            assign l-erro = yes.    
    end.        
    else 
        if  de-preuni <=  de-var-max-perc 
        or  de-percentual-vl = 0 then 
            if  de-preuni > de-var-max-lim  
            and de-limite-vl <> 0 then  
                assign l-erro = yes. 
            else  
                assign l-erro = no. 
        else 
            assign l-erro = yes. 
            
    if  l-erro then do:
        if  param-re.aceita-var = no then do: 
            IF param-re.atu-erro THEN DO:
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="57420"  /*	Varia‡Æo de valor nÆo permitida. &1 .Help: Usu rio do recebimento com permissÆo para atualizar com erro e varia‡Æo de valor nÆo permitida.*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="WARNING"}

            END.
            ELSE DO:
            
                {method/svc/errors/inserr.i
                                    &ErrorNumber="15241"  /*Pre‡o da ordem de compra excede varia‡Æo permitida.*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            END.
    
        end.
        else do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="15242"  /*Pre‡o da ordem de compra excede varia‡Æo permitida*/
                                &ErrorType="EMS"
                                &ErrorSubType="WARNING"}
    
        end.
    end.     
    /*15082 - Alterado para criar a tabela consist-nota*/
    IF NOT VALID-HANDLE(h-boin060) THEN  
        RUN inbo/boin060.p PERSISTENT SET h-boin060.

    run updateConsistNota in h-boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         RowObject.sequencia,
                                         (not (l-erro)),
                                         ( if de-var-max-perc < de-var-max-lim  
                                           then de-var-max-perc 
                                           else de-var-max-lim),
                                          de-preuni,
                                          (IF param-re.aceita-var THEN 15242
                                           ELSE 15241),
                                          1).

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaContrato DBOProgram 
PROCEDURE verificaContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNumeroOrdem like rat-ordem.numero-ordem no-undo.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    
        if  not avail param-global then
            find first param-global no-lock no-error.
    
        if  pNumeroOrdem <> 0 
        and avail param-global
        and param-global.modulo-cn then do:
            run cnp/cn9174.p ( pNumeroOrdem,
                               1,
                               0,
                               0,
                               ?,
                               output de-qtd-max,
                               output l-erro-co,
                               output l-contrato,
                               output i-total,
                               input-output table tt-erro).
        end.
    &ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

