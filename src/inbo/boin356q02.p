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
{include/i-prgvrs.i BOIN356Q02 2.00.00.018} /*** "010018" 17/06/2025 16:40:48 ***/
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName prazo-compra
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-item-fornec
&GLOBAL-DEFINE TableLabel tt-item-fornec
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin356.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*&GLOBAL-DEFINE EXCLUDE-getRowid*/

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
      
{inbo/boin356q02.i  tt-item-fornec}

{inbo/boin356q02.i  RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}


{inbo/boin356q02.i2 tt-item-fornec-split}  /* Temp-table necess†ria para manter a compatibilidade com a 
                                            temp-table da API CD9400.P */
{inbo/boin356q02.i2 tt-item-fornec-ret}    /* Temp-table aparentemente sem funcionalidade, mas que Ç
                                            necess†ria para preencher a lista de parÉmetros da API
                                            CD9400.P */                                            
{inbo/boin356q02.i3 tt-quant}              /* Tabela contendo os rowids e quantidades dos registros que
                                            sofreram alteraá∆o em tela */
{inbo/boin356q02.i4 tt-erro-api}           /* Temp-table de erros no padr∆o da API CD9400.P */

def var iParcela  as inte no-undo.
def var l-ligado  as log no-undo.
def var i-parcela as int no-undo.
def var de-qtidade        as dec no-undo.
def var de-nr-lotes       as dec no-undo.
def var i-sequencia       as int no-undo.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 19.78
         WIDTH              = 56.86.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign rowobject.r-rowid = {&TableName}.r-rowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 3: Tabela {&TableLabel} nío dispon≠vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSetRecord DBOProgram 
PROCEDURE afterSetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign rowobject.r-rowid = {&TableName}.r-rowid.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord DBOProgram 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.
    
    assign pRowid = rowid({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: N∆o foi poss°vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- ê necess†rio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaDadosFornecedoresItens DBOProgram 
PROCEDURE carregaDadosFornecedoresItens :
/*------------------------------------------------------------------------------
  Purpose:    Gera uma temp-table contendo dados de fornecedores de itens X parcelas para 
              ser exibida em tela e permitir a alteraá∆o das quantidades de itens em cada
              fornecedor. (wcc0301d)    
  Parameters: ipar1  : r-ordem-compra : Ordem de compra Atual
  Notes:       
------------------------------------------------------------------------------*/

    def input param r-ordem-compra as rowid no-undo.
    
    def var de-qtidade        as dec no-undo.
    def var de-nr-lotes       as dec no-undo.
    def var i-sequencia       as int no-undo.

    assign i-sequencia  = 1.
    
    find first param-compra no-lock no-error.
    for first ordem-compra fields(numero-ordem it-codigo cod-estabel) where 
        rowid(ordem-compra) = r-ordem-compra no-lock: end.

    if not can-find(first item-fornec where
                          item-fornec.it-codigo = ordem-compra.it-codigo and
                          item-fornec.ativo     <> (if param-compra.perm-cot-for = yes then ? else no)) then 
        return.
    
    for each prazo-compra fields(numero-ordem parcela data-entrega quantidade) where 
        prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
        assign de-qtidade =  0.
        
        /** Desenvolvimento release 2.04 - item-fornec-estab **/      
        if can-find(first item-fornec-estab where
                          item-fornec-estab.it-codigo   = ordem-compra.it-codigo   and
                          item-fornec-estab.cod-estabel = ordem-compra.cod-estabel and
                          item-fornec-estab.ativo       <> 
                          (if param-compra.perm-cot-for = yes then ? else no)) then do:
            for each item-fornec-estab fields(it-codigo    cod-estabel  ativo  
                                              contr-forn   horiz-fixo   lote-minimo 
                                              lote-mul-for cod-emitente perc-compra) no-lock where 
                item-fornec-estab.it-codigo   = ordem-compra.it-codigo and
                item-fornec-estab.cod-estabel = ordem-compra.cod-estabel and
                item-fornec-estab.ativo      <> (if param-compra.perm-cot-for = yes then ? else no) 
                by item-fornec-estab.perc-compra descending :

                for first emitente fields(cod-emitente nome-abrev) where 
                     emitente.cod-emitente = item-fornec-estab.cod-emitente no-lock: end.            
                create tt-item-fornec.
                assign tt-item-fornec.sequencia     = i-sequencia
                       tt-item-fornec.numero-ordem  = prazo-compra.numero-ordem
                       tt-item-fornec.parcela       = prazo-compra.parcela
                       tt-item-fornec.fornec        = item-fornec-estab.cod-emitente
                       tt-item-fornec.nome-fornec   = emitente.nome-abrev
                       tt-item-fornec.quantidade    = 0
                       tt-item-fornec.data-entrega  = prazo-compra.data-entrega
                       tt-item-fornec.contr-forn    = item-fornec-estab.contr-forn
                       tt-item-fornec.r-rowid       = rowid(item-fornec-estab).
                       
                if  item-fornec-estab.contr-forn = yes then do:
                    assign l-ligado = no.
                    for each item-contrat fields(it-codigo   log-libera nr-contrato 
                                                 val-total   qtd-total) where 
                             item-contrat.it-codigo = item-fornec-estab.it-codigo and
                             item-contrat.log-libera = yes no-lock:
                        
                        for first contrato-for fields(nr-contrato cod-emitente dt-ini-validade 
                                                      dt-ter-validade log-libera) where 
                            contrato-for.nr-contrato = item-contrat.nr-contrato and
                            contrato-for.cod-emitente   = item-fornec-estab.cod-emitente no-lock: end.
                        if  available contrato-for then do:
                            if (contrato-for.dt-ini-validade <= prazo-compra.data-entrega 
                            and contrato-for.dt-ter-validade >= prazo-compra.data-entrega) 
                            and contrato-for.log-libera = yes then do:
                                
/*                               if (item-contrat.val-total <> 0 or        */
/*                                   item-contrat.qtd-total <> 0) then do: */
/*                                                                         */
/*                                   /**** pi-valida-saldo ****/           */
/*                                   /*run validaSaldoItemContrato.*/      */
/*                                   /**** pi-valida-saldo ****/           */
/*                                                                         */
/*                               end.                                      */
/*                               else                                      */
                                  
                                  assign l-ligado = yes.
                            end.
                        end.
                    end.
                    assign tt-item-fornec.contr-forn = l-ligado.
                    if item-fornec-estab.horiz-fixo <> 0 then do:
                        if (today + item-fornec-estab.horiz-fixo - 1) >= prazo-compra.data-entrega
                            then next.
                    end.
                    
                    /* cdp/cd9400.i2 */
                    /***************************************************************************
                    **
                    **  Include.: cd9400.i2
                    **
                    ***************************************************************************
                    **/
                    if item-fornec-estab.perc-compra > 0 then do:   
                        if de-qtidade < prazo-compra.quantidade then do:
                            assign tt-item-fornec.quantidade = prazo-compra.quantidade * item-fornec-estab.perc-compra / 100.
                            if item-fornec-estab.lote-minimo > tt-item-fornec.quantidade then
                                assign tt-item-fornec.quantidade = item-fornec-estab.lote-minimo.
                            if item-fornec-estab.lote-mul-for <> 0 then do:
                                if tt-item-fornec.quantidade = 0 then
                                    assign tt-item-fornec.quantidade = item-fornec-estab.lote-mul-for.
                                assign de-nr-lotes = tt-item-fornec.quantidade /
                                                     item-fornec-estab.lote-mul-for.
                                if de-nr-lotes - truncate(de-nr-lotes,0) <> 0 then
                                    assign           de-nr-lotes = truncate(de-nr-lotes,0) + 1.
                                assign tt-item-fornec.quantidade = de-nr-lotes *
                                               item-fornec-estab.lote-mul-for.
                           end.
                           assign de-qtidade = de-qtidade + tt-item-fornec.quantidade.
                        end.
                    end.
    
                    /* cdp/cd9400.i2 */
    
                end.
                else do:
                    if item-fornec-estab.horiz-fixo <> 0 then do:
                        if (today + item-fornec-estab.horiz-fixo - 1) >= prazo-compra.data-entrega
                            then next.
                    end.
                    /* cdp/cd9400.i2 */
                    /***************************************************************************
                    **
                    **  Include.: cd9400.i2
                    **
                    ***************************************************************************
                    **/
                    if item-fornec-estab.perc-compra > 0 then do:   
                        if de-qtidade < prazo-compra.quantidade then do:
                            assign tt-item-fornec.quantidade = prazo-compra.quantidade * item-fornec-estab.perc-compra / 100.
                            if item-fornec-estab.lote-minimo > tt-item-fornec.quantidade then
                                assign tt-item-fornec.quantidade = item-fornec-estab.lote-minimo.
                            if item-fornec-estab.lote-mul-for <> 0 then do:
                                if tt-item-fornec.quantidade = 0 then
                                    assign tt-item-fornec.quantidade = item-fornec-estab.lote-mul-for.
                                assign de-nr-lotes = tt-item-fornec.quantidade /
                                                     item-fornec-estab.lote-mul-for.
                                if de-nr-lotes - truncate(de-nr-lotes,0) <> 0 then
                                    assign de-nr-lotes = truncate(de-nr-lotes,0) + 1.
                                assign tt-item-fornec.quantidade = de-nr-lotes *
                                                                   item-fornec-estab.lote-mul-for.
                            end.
                            assign de-qtidade = de-qtidade + tt-item-fornec.quantidade.
                        end.
                    end.
    
                    /* cdp/cd9400.i2 */
    
                end.          
                assign i-sequencia = i-sequencia + 1.
            end.
        end.            
        
        for each item-fornec fields(it-codigo    ativo  
                                    contr-forn   horiz-fixo   lote-minimo 
                                    lote-mul-for cod-emitente perc-compra)
                 no-lock use-index onde-compra where 
                 item-fornec.it-codigo   = ordem-compra.it-codigo and
                 item-fornec.ativo      <> (if param-compra.perm-cot-for = yes then ? else no) 
                 by item-fornec.perc-compra descending:

            for first emitente fields(cod-emitente nome-abrev) where 
                emitente.cod-emitente = item-fornec.cod-emitente no-lock: end.            
            find first tt-item-fornec where 
                       tt-item-fornec.fornec    = item-fornec.cod-emitente and
                       tt-item-fornec.parcela   = prazo-compra.parcela  no-lock no-error.
            if not avail tt-item-fornec then do:            
                create tt-item-fornec.
                assign tt-item-fornec.sequencia     = i-sequencia
                       tt-item-fornec.numero-ordem  = prazo-compra.numero-ordem
                       tt-item-fornec.parcela       = prazo-compra.parcela
                       tt-item-fornec.fornec        = item-fornec.cod-emitente
                       tt-item-fornec.nome-fornec   = emitente.nome-abrev
                       tt-item-fornec.quantidade    = 0
                       tt-item-fornec.data-entrega  = prazo-compra.data-entrega
                       tt-item-fornec.contr-forn    = item-fornec.contr-forn
                       tt-item-fornec.r-rowid       = rowid(item-fornec).
                       
                if  item-fornec.contr-forn = yes then do:
                    assign l-ligado = no.
                    for each item-contrat fields(it-codigo   log-libera nr-contrato 
                                                 val-total   qtd-total) where 
                             item-contrat.it-codigo = item-fornec.it-codigo and
                             item-contrat.log-libera = yes no-lock:
                        
                        for first contrato-for fields(nr-contrato cod-emitente dt-ini-validade 
                                                      dt-ter-validade log-libera) where 
                            contrato-for.nr-contrato = item-contrat.nr-contrato and
                            contrato-for.cod-emitente   = item-fornec.cod-emitente no-lock: end.
                        if  available contrato-for then do:
                            if (contrato-for.dt-ini-validade <= prazo-compra.data-entrega 
                            and contrato-for.dt-ter-validade >= prazo-compra.data-entrega) 
                            and contrato-for.log-libera = yes then do:
                                
/*                               if (item-contrat.val-total <> 0 or        */
/*                                   item-contrat.qtd-total <> 0) then do: */
/*                                                                         */
/*                                   /**** pi-valida-saldo ****/           */
/*                                   /*run validaSaldoItemContrato.*/      */
/*                                   /**** pi-valida-saldo ****/           */
/*                                                                         */
/*                               end.                                      */
/*                               else                                      */
                                  
                                  assign l-ligado = yes.
                            end.
                        end.
                    end.
                    assign tt-item-fornec.contr-forn = l-ligado.
                    if item-fornec.horiz-fixo <> 0 then do:
                        if (today + item-fornec.horiz-fixo - 1) >= prazo-compra.data-entrega
                            then next.
                    end.
                    
                    /* cdp/cd9400.i2 */
                    /***************************************************************************
                    **
                    **  Include.: cd9400.i2
                    **
                    ***************************************************************************
                    **/
                    if item-fornec.perc-compra > 0 then do:   
                        if de-qtidade < prazo-compra.quantidade then do:
                            assign tt-item-fornec.quantidade = prazo-compra.quantidade * item-fornec.perc-compra / 100.
                            if item-fornec.lote-minimo > tt-item-fornec.quantidade then
                                assign tt-item-fornec.quantidade = item-fornec.lote-minimo.
                            if item-fornec.lote-mul-for <> 0 then do:
                                if tt-item-fornec.quantidade = 0 then
                                    assign tt-item-fornec.quantidade = item-fornec.lote-mul-for.
                                assign de-nr-lotes = tt-item-fornec.quantidade /
                                                     item-fornec.lote-mul-for.
                                if de-nr-lotes - truncate(de-nr-lotes,0) <> 0 then
                                    assign de-nr-lotes = truncate(de-nr-lotes,0) + 1.
                                assign tt-item-fornec.quantidade = de-nr-lotes *
                                                                   item-fornec.lote-mul-for.
                            end.
                            assign de-qtidade = de-qtidade + tt-item-fornec.quantidade.
                        end.
                    end.
    
                    /* cdp/cd9400.i2 */
    
                end.
                else do:
                    if item-fornec.horiz-fixo <> 0 then do:
                        if (today + item-fornec.horiz-fixo - 1) >= prazo-compra.data-entrega
                            then next.
                    end.
                    /* cdp/cd9400.i2 */
                    /***************************************************************************
                    **
                    **  Include.: cd9400.i2
                    **
                    ***************************************************************************
                    **/
                    if item-fornec.perc-compra > 0 then do:   
                        if de-qtidade < prazo-compra.quantidade then do:
                            assign tt-item-fornec.quantidade = prazo-compra.quantidade * item-fornec.perc-compra / 100.
                            if item-fornec.lote-minimo > tt-item-fornec.quantidade then
                                assign tt-item-fornec.quantidade = item-fornec.lote-minimo.
                            if item-fornec.lote-mul-for <> 0 then do:
                                if tt-item-fornec.quantidade = 0 then
                                   tt-item-fornec.quantidade = item-fornec.lote-mul-for.
                                assign de-nr-lotes = tt-item-fornec.quantidade /
                                                     item-fornec.lote-mul-for.
                                if de-nr-lotes - truncate(de-nr-lotes,0) <> 0 then
                                    assign de-nr-lotes = truncate(de-nr-lotes,0) + 1.
                                assign tt-item-fornec.quantidade = de-nr-lotes *
                                                                   item-fornec.lote-mul-for.
                            end.
                            assign de-qtidade = de-qtidade + tt-item-fornec.quantidade.
                        end.
                    end.
    
                    /* cdp/cd9400.i2 */
                end.    
                assign i-sequencia = i-sequencia + 1.
            end.     

        end.
        
        find first tt-item-fornec where tt-item-fornec.parcela = prazo-compra.parcela no-error.
        if not avail tt-item-fornec then do:
            create tt-item-fornec.
            assign tt-item-fornec.sequencia    = i-sequencia
                   tt-item-fornec.numero-ordem = prazo-compra.numero-ordem
                   tt-item-fornec.parcela      = prazo-compra.parcela
                   tt-item-fornec.fornec       = 0
                   tt-item-fornec.nome-fornec  = "Outros"
                   tt-item-fornec.quantidade   = 0
                   tt-item-fornec.data-entrega = prazo-compra.data-entrega
                   tt-item-fornec.contr-forn    = no
                   tt-item-fornec.r-rowid      = rowid(prazo-compra).
            if prazo-compra.quantidade > de-qtidade then
                 assign tt-item-fornec.quantidade = prazo-compra.quantidade - de-qtidade.
        end.

        assign i-sequencia = i-sequencia + 1.
    end.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaDadosQuantidadeFornecedoresItens DBOProgram 
PROCEDURE criaDadosQuantidadeFornecedoresItens :
/*------------------------------------------------------------------------------
  Purpose:  Gera novamente os dados sobre parcelas X fornecedores e anexa as alteraá‰es
            de quantidade efetuadas em tela pelo usu†rio.   
  Parameters:    
            ipar1 : r-ordem-compra           : Ordem de compra Atual
            ipar2 : table for tt-quant       : Tabela contendo as informaá‰es de quantidade alteradas
                                               em tela pelo usu†rio
            opar3 : table for tt-item-fornec : Tabela contendo os dados gerados   
  Notes:       
------------------------------------------------------------------------------*/

    def input  param r-ordem-compra as  rowid no-undo.
    def input  param table          for tt-quant.
    def output param table          for tt-item-fornec.

    for each tt-quant:
                       
            /** Desenvolvimento release 2.04 - item-fornec-estab **/
            
            for first item-fornec-estab fields(it-codigo    cod-estabel  ativo  
                                               contr-forn   horiz-fixo   lote-minimo 
                                               lote-mul-for cod-emitente perc-compra) where 
                 rowid(item-fornec-estab) = tt-quant.r-rowid no-lock: end.
            if avail item-fornec-estab then
                for first item-fornec fields(it-codigo    ativo  
                                             contr-forn   horiz-fixo   lote-minimo 
                                             lote-mul-for cod-emitente perc-compra) where 
                     item-fornec.it-codigo = item-fornec-estab.it-codigo and
                     item-fornec.cod-emitente = item-fornec-estab.cod-emitente no-lock: end.
            if not avail item-fornec-estab then
                for first item-fornec fields(it-codigo    ativo  
                                             contr-forn   horiz-fixo   lote-minimo 
                                             lote-mul-for cod-emitente perc-compra) where 
                    rowid(item-fornec) = tt-quant.r-rowid no-lock: end.
            /**/
           
            
            for first ordem-compra fields(numero-ordem it-codigo cod-estabel) where 
                rowid(ordem-compra) = r-ordem-compra no-lock: end.
            
            for first prazo-compra fields(numero-ordem parcela 
                                          data-entrega quantidade) where 
                 rowid(prazo-compra) = tt-quant.r-prazo-compra no-lock: end.
            
            if avail item-fornec then do:
                for first emitente fields(cod-emitente nome-abrev) where 
                    emitente.cod-emitente = item-fornec.cod-emitente no-lock: end.
                create tt-item-fornec.
                assign i-sequencia                  = i-sequencia + 1
                       tt-item-fornec.sequencia     = i-sequencia
                       tt-item-fornec.numero-ordem  = prazo-compra.numero-ordem
                       tt-item-fornec.parcela       = prazo-compra.parcela
                       tt-item-fornec.fornec        = item-fornec.cod-emitente
                       tt-item-fornec.nome-fornec   = if avail emitente then emitente.nome-abrev else ""
                       tt-item-fornec.quantidade    = tt-quant.de-quant
                       tt-item-fornec.data-entrega  = prazo-compra.data-entrega
                       tt-item-fornec.contr-forn    = item-fornec.contr-forn
                       tt-item-fornec.r-rowid       = rowid(item-fornec).
                                                                          
                /** Desenvolvimento release 2.04 - item-fornec-estab **/
                if avail item-fornec-estab then            
                    assign tt-item-fornec.contr-forn    = item-fornec-estab.contr-forn
                           tt-item-fornec.r-rowid       = rowid(item-fornec-estab).
                if  (avail item-fornec-estab and item-fornec-estab.contr-forn) or
                    (not avail item-fornec-estab and item-fornec.contr-forn) then do:
                    assign l-ligado = no.
                    for each item-contrat fields(it-codigo   log-libera nr-contrato 
                                                 val-total   qtd-total) where 
                             item-contrat.it-codigo = item-fornec.it-codigo and
                             item-contrat.log-libera = yes no-lock:

                        for first contrato-for fields(nr-contrato cod-emitente dt-ini-validade 
                                                      dt-ter-validade log-libera) where 
                            contrato-for.nr-contrato = item-contrat.nr-contrato and
                            contrato-for.cod-emitente   = item-fornec.cod-emitente no-lock: end.
                        if  available contrato-for then do:
                            if (contrato-for.dt-ini-validade <= prazo-compra.data-entrega  and
                                contrato-for.dt-ter-validade >= prazo-compra.data-entrega) and 
                                contrato-for.log-libera = yes then do:

/*                                 if (item-contrat.val-total <> 0 or        */
/*                                     item-contrat.qtd-total <> 0) then do: */
/*                                                                           */
/*                                       /**** pi-valida-saldo ****/         */
/*                                       /*run validaSaldoItemContrato.*/    */
/*                                       /**** pi-valida-saldo ****/         */
/*                                                                           */
/*                                 end.                                      */
/*                                 else                                      */
                                    
                                    assign l-ligado = yes.
                            end.
                        end.
                    end.

                    assign tt-item-fornec.contr-forn = l-ligado.
                end.
            end.
            else do:
                create tt-item-fornec.
                assign i-sequencia                 = i-sequencia + 1
                       tt-item-fornec.sequencia    = i-sequencia
                       tt-item-fornec.numero-ordem = prazo-compra.numero-ordem
                       tt-item-fornec.parcela      = prazo-compra.parcela
                       tt-item-fornec.fornec       = 0
                       tt-item-fornec.nome-fornec  = "Outros"
                       tt-item-fornec.quantidade   = tt-quant.de-quant
                       tt-item-fornec.data-entrega = prazo-compra.data-entrega
                       tt-item-fornec.contr-forn    = no
                       tt-item-fornec.r-rowid      = rowid(prazo-compra).
            end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executaSplitOrdemCompra DBOProgram 
PROCEDURE executaSplitOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Executa a API CD9400.P (Split de OC) utilizando dados gerados pela 
           procedure: carregaDadosFornecedoresItens.
  Parameters:  
            ipar1 : r-ordem-compra       : Ordem de Compra atual
            ipar2 : table for tt-quant   : Tabela de quantidades alteradas em tela
            opar3 : r-ordem-ret          : Rowid da Nova Ordem criada pelo Split
            opar4 : table for RowErrors  : Temp-table de erro  
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param r-ordem-compra as  rowid no-undo.
    def input  param table          for tt-quant.
    
    def output param r-ordem-ret    as  rowid no-undo.
    def output param table          for RowErrors.
    
    def var l-erro-ret as log no-undo.

    FOR EACH tt-item-fornec:
        DELETE tt-item-fornec.
    END.

    /* Gera a Temp-Table novamente */
    run criaDadosQuantidadeFornecedoresItens (input  r-ordem-compra,
                                              input  table tt-quant,
                                              output table tt-item-fornec).

    for each tt-item-fornec:
        create tt-item-fornec-split.
        assign tt-item-fornec-split.sequencia    = tt-item-fornec.sequencia
               tt-item-fornec-split.numero-ordem = tt-item-fornec.numero-ordem
               tt-item-fornec-split.parcela      = tt-item-fornec.parcela
               tt-item-fornec-split.fornec       = tt-item-fornec.fornec
               tt-item-fornec-split.nome-fornec  = tt-item-fornec.nome-fornec
               tt-item-fornec-split.quantidade   = tt-item-fornec.quantidade
               tt-item-fornec-split.contr-forn   = tt-item-fornec.contr-forn
               tt-item-fornec-split.data-entrega = tt-item-fornec.data-entrega.
    end.               
    for first ordem-compra fields(numero-ordem) where 
         rowid (ordem-compra) = r-ordem-compra no-lock: end.
        RUN cdp/cd9400.p (input  ordem-compra.numero-ordem, 
                          input  yes, 
                          input  "M", 
                          input  yes,
                          input  table tt-item-fornec-split,
                          output l-erro-ret, 
                          output r-ordem-ret, 
                          output table tt-item-fornec-ret,
                          input-output table tt-erro-api, 
                          input  yes).       
   FOR EACH tt-erro-api:
            {method/svc/errors/inserr.i &ErrorNumber="tt-erro-api.cd-erro"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}   
   END.
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRowid2 DBOProgram 
PROCEDURE findRowid2 :
/*
    **  Localiza registro pelo rowid e nao retorna o registro.
    */
    def input parameter r-chave as rowid no-undo.
    find first {&TableName} where  {&TableName}.r-rowid = r-chave no-lock no-error.
    if avail {&TableName} then RUN setCurrent.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nome-fornec":U THEN ASSIGN pFieldValue = RowObject.nome-fornec.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "fornec":U THEN ASSIGN pFieldValue = RowObject.fornec.
        OTHERWISE RETURN "NOK":U.
    END CASE.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE naoExecutaSplitOrdemCompra DBOProgram 
PROCEDURE naoExecutaSplitOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:    Executada caso o usu†rio n∆o deseje executar o Split de Ordem Compra
              ap¢s a criaá∆o de uma nova ordem.
  Parameters: ipar1 : r-ordem-compra : Rowid da Ordem de compra corrente
  Notes:       
------------------------------------------------------------------------------*/
    def input param prOrdemCompra as rowid no-undo.
    
    RUN cdp/cd9400a.p (input prOrdemCompra).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            run openQueryStatic ("Main":U).
        when 2 then 
            run openQueryStatic ("ByParcela":U).
    end case.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByParcela DBOProgram 
PROCEDURE openQueryByParcela :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query da DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
            open query {&QUERYNAME} for each {&TABLENAME} where 
                                             {&TABLENAME}.parcela = iParcela no-lock INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH tt-item-fornec NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcParcela as char no-undo.
    
    run setConstraintByParcela (inte(pcParcela)).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByParcela DBOProgram 
PROCEDURE setConstraintByParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piParcela  as inte no-undo.
    
    
    assign iParcela = piParcela.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


