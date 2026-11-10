&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN390A 2.00.00.032 } /*** "010032" 15/10/2025 17:10:41 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin390a MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) Ç um programa 
                 PROGRESS que contÇm a l¢gica de neg¢cio.

    Parameters : 

    Notes      : BO da tabela reservas
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName reservas
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reservas
&GLOBAL-DEFINE TableLabel reservas


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin390.i RowObject}

{inbo/boin390a.i1} /* definiá∆o das temp-tables */

{cdp/cd0666.i}
{cpp/cpapi020.i}
{cpp/cpapi020.i1} /* Funcoes p/ fator de concentracao */
{cpp/cpapi012.i19} /* definicao da ttReqOrdem */
{cdp/cdcfgman.i}

{include/i-epc200.i boin390a}

def temp-table tt-ordem no-undo
    field num-seq      as int
    field nr-ord-produ like ord-prod.nr-ord-produ
    field it-codigo    like ord-prod.it-codigo
    field cod-refer    like ord-prod.cod-refer
    field qt-ordem     like ord-prod.qt-ordem 
    field estado       as int
    field desc-item    like item.desc-item
    field qt-saldo     as dec format ">>>,>>>,>>9.9999" label "Qt Saldo"
    field cod-estabel  like ord-prod.cod-estabel.

DEF TEMP-TABLE tt-valida-req NO-UNDO
    field nr-ord-produ   LIKE reservas.nr-ord-produ
    field item-pai       LIKE reservas.item-pai    
    field cod-roteiro    like reservas.cod-roteiro 
    field op-codigo      like reservas.op-codigo   
    field it-codigo      like reservas.it-codigo   
    field cod-refer      like reservas.cod-refer
    FIELD deQuantTotal   LIKE ttReqOrd.qt-requis
    FIELD deQuantAloc    LIKE ttReqOrd.qt-requis
    FIELD deQuantTotLote LIKE ttReqOrd.qt-requis
    INDEX id-prim IS PRIMARY nr-ord-produ item-pai cod-roteiro op-codigo it-codigo cod-refer.

def buffer bfttSaldoEstoq for ttSaldoEstoq.

DEf VAR lDepFechado     AS LOG    NO-UNDO. 

FIND FIRST param-estoq NO-LOCK NO-ERROR.
IF AVAILABLE param-estoq THEN
    ASSIGN lDepFechado = SUBSTRING(param-estoq.char-2,116,1) = "S" OR
                         SUBSTRING(param-estoq.char-2,115,1) = "S".

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
def var l-retorno       as log    no-undo.
def var h-ceapi030      as handle no-undo.
def var l-lote-avancado as log    no-undo.

{cep/ceapi030.i}

if can-find(first funcao where funcao.cd-funcao = "lote-avancado":u and
                               funcao.ativo) then do:
    assign l-lote-avancado = yes.

    if not valid-handle(h-ceapi030) then
        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                      output table tt-valores,
                                                      output table tt-erro).
end.
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCriaReqOrd DBOFunction 
FUNCTION fCriaReqOrd RETURNS ROWID
  ( pNrOrdProdu   as int,
    pItemPai      as char,
    pCodRoteiro   as char, 
    pOpCodigo     as int,  
    pItCodigo     as char, 
    pCodRefer     as char, 
    pCodEstabel   as char, 
    pCodDepos     as char, 
    pCodLocaliz   as char, 
    pLoteSerie    as char, 
    pQtRequis     as dec,  
    pQtRequisLote AS DEC,
    pQtAloc       as dec,
    pQtAlocLote   AS DEC,
    pPerPpm       as dec,
    pTipoFormula  as int) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-calcula-qt-fisica DBOFunction 
FUNCTION fn-calcula-qt-fisica RETURNS decimal
  ( input de-qt-teorica as dec, 
    input de-item-ppm as dec, 
    input de-saldo-per-ppm as dec)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

find first param-global no-lock no-error.
if param-global.modulo-per-ppm THEN
    run cpp/cpapi020.p persistent set h-cpapi020(input-output table tt-balanceia,
                                                 input-output table tt-erro,
                                                 input        yes,
                                                 input-output table tt-veiculos).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE balanceiaVeiculos DBOFunction 
PROCEDURE balanceiaVeiculos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output param table for ttReservas.
def input-output param table for ttSaldoEstoq.
def input-output param table for ttSaldoEstoqAux.
def input-output param table for ttAlocaReserva.
def input-output param table for ttReqOrd.
def input-output param table for ttReqAltern.

run verificaBalanceio (input-output table ttReservas,
                       input-output table ttSaldoEstoq,
                       input-output table ttAlocaReserva,
                       input-output table ttReqOrd).

for each ttSaldoEstoq:

    find first ttSaldoEstoqAux of ttSaldoEstoq no-error.
    if avail ttSaldoEstoqAux then do:
        buffer-copy ttSaldoEstoq to ttSaldoEstoqAux.
    end.

end.

for each ttAlocaReserva:

    find first ttSaldoEstoqAux where ttSaldoEstoqAux.r-rowid-tt = ttAlocaReserva.rowid no-lock no-error.
    if avail ttSaldoEstoqAux then do:

        find first item where item.it-codigo = ttAlocaReserva.it-codigo no-lock no-error.

        buffer-copy ttSaldoEstoqAux to ttAlocaReserva.
        assign ttSaldoEstoqAux.saldo-disp     = ttAlocaReserva.quant-aloc
               ttSaldoEstoqAux.lote           = ttAlocaReserva.lote-serie
               ttSaldoEstoqAux.dt-vali-lote   = ttAlocaReserva.dt-vali-lote
               ttSaldoEstoqAux.qt-fisica      = round(f-conv-qtde(ttAlocaReserva.quant-aloc,ttSaldoEstoqAux.per-ppm,item.per-ppm),4).

    end.

end.

if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then do:
    undo, return "NOK":U.
end.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOFunction 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle (h-cpapi020) then
        run pi-finalizar in h-cpapi020.

  &if '{&bf_man_versao_ems}' >= '208' &then
    if valid-handle(h-ceapi030) then
        delete procedure h-ceapi030.
  &endif
        
return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

DEFINE VARIABLE tgZerados AS LOGICAL     NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaParametros DBOFunction 
PROCEDURE piAtualizaParametros:
    def input param pTgZerados as log no-undo.

    ASSIGN tgZerados = pTgZerados.

END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CarregaAlocaSaldo DBOFunction 
PROCEDURE CarregaAlocaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pNrOrdProdu       as int  no-undo.
def input param pItemPai          as char no-undo.
def input param pCodRoteiro       as char no-undo.
def input param pOpCodigo         as int  no-undo.
def input param pItCodigo         as char no-undo.
def input param pCodRefer         as char no-undo.
def input param pCodEstabel       as char no-undo.
def input param pTipoFormula      as int  no-undo.
def input param pPerPpm           as dec  no-undo.
def input param pDepositoProcesso as log no-undo.
def input-output param table for ttAlocaReserva.
def input-output param table for ttSaldoEstoq.
def input-output param table for ttSaldoEstoqAux.


find first param-global no-lock no-error.
    
    for each saldo-estoq no-lock USE-INDEX ITEM where
             saldo-estoq.it-codigo   = pItCodigo   and
             saldo-estoq.cod-estabel = pCodEstabel and
             saldo-estoq.cod-refer   = pCodRefer:

        IF NOT tgZerados
        AND (saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped  + saldo-estoq.qt-alocada)) <= 0
        THEN DO:
            NEXT.
        END.

        if can-find(first ttSaldoEstoq where ttSaldoEstoq.it-codigo   = pItCodigo and
                                             ttSaldoEstoq.cod-estabel = pCodEstabel and
                                             ttSaldoEstoq.cod-refer   = pCodRefer and
                                             ttSaldoEstoq.lote        = saldo-estoq.lote and
                                             ttSaldoEstoq.cod-depos   = saldo-estoq.cod-depos and
                                             ttSaldoEstoq.cod-localiz = saldo-estoq.cod-localiz) THEN DO:
            next.
        END.

        find first deposito where deposito.cod-depos = saldo-estoq.cod-depos no-lock no-error.

        IF AVAILABLE deposito THEN DO:
            IF (deposito.ind-processo = no and
               pDepositoProcesso ) OR
                deposito.ind-dep-rej   OR
                deposito.ind-dep-cq    THEN NEXT.

            IF lDepFechado AND deposito.ind-tipo-dep = 2 THEN
                NEXT.
        END.

        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
          if l-lote-avancado then do:
              find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
              if avail item and
                 item.tipo-con-est > 2 then do:
        
                  run pi-identifica-saldo in h-ceapi030 (input 1,
                                                         input saldo-estoq.it-codigo,
                                                         input saldo-estoq.cod-estabel,
                                                         input saldo-estoq.lote, 
                                                         input 0,
                                                         output l-retorno,
                                                         output table tt-valores2,
                                                         output table tt-erro).
        
              end.
              ELSE DO:
                  assign l-retorno = yes.
              END.
          end.
        &endif

        if not (param-global.modulo-per-ppm and
                pTipoFormula >= 2           and
                pTipoFormula <= 3) then do:            

            create ttSaldoEstoq.
            buffer-copy saldo-estoq to ttSaldoEstoq 
            assign ttSaldoEstoq.rowid            = rowid(saldo-estoq)
                   ttSaldoEstoq.log-disp         = (saldo-estoq.qtidade-atu > 0)
                   ttSaldoEstoq.tipo-formula     = pTipoFormula.       

             &if '{&bf_lote_avancado_liberado}' = 'yes' &then
               if l-lote-avancado and
                  not l-retorno THEN DO:
                   assign ttSaldoEstoq.saldo-disp       = 0
                          ttSaldoEstoq.qt-aloc-prod-fis = 0
                          ttSaldoEstoq.qtidade-atu-fis  = 0
                          ttSaldoEstoq.saldo-disp-fis   = 0
                          ttSaldoEstoq.qtidade-atu      = 0
                          ttSaldoEstoq.qt-aloc-prod     = 0
                          ttSaldoEstoq.log-disp         = no.
               END.
               else
            &endif
            assign ttSaldoEstoq.qt-aloc-prod-fis = ttSaldoEstoq.qt-aloc-prod
                   ttSaldoEstoq.qtidade-atu-fis  = ttSaldoEstoq.qtidade-atu 
                   ttSaldoEstoq.saldo-disp       = saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + 
                                                                              saldo-estoq.qt-aloc-ped  + 
                                                                              saldo-estoq.qt-alocada)
                   ttSaldoEstoq.saldo-disp-fis   = ttSaldoEstoq.saldo-disp.
        end.
        else do:
            create ttSaldoEstoq.
            buffer-copy saldo-estoq except saldo-estoq.qt-aloc-prod saldo-estoq.qtidade-atu to ttSaldoEstoq 
            assign ttSaldoEstoq.rowid        = rowid(saldo-estoq)
                   ttSaldoEstoq.log-disp     = (saldo-estoq.qtidade-atu > 0).
            assign ttSaldoEstoq.tipo-formula = pTipoFormula.

            &if '{&bf_lote_avancado_liberado}' = 'yes' &then
              if l-lote-avancado and
                 not l-retorno then
                  assign ttSaldoEstoq.saldo-disp       = 0
                         ttSaldoEstoq.saldo-disp-fis   = 0
                         ttSaldoEstoq.qt-aloc-prod     = 0
                         ttSaldoEstoq.qtidade-atu      = 0
                         ttSaldoEstoq.qt-aloc-prod-fis = 0
                         ttSaldoEstoq.qtidade-atu-fis  = 0
                         ttSaldoEstoq.log-disp         = no.
              else
            &endif

            assign ttSaldoEstoq.qt-aloc-prod     = f-conv-qtde(saldo-estoq.qt-aloc-prod,
                                                               saldo-estoq.per-ppm,
                                                               pPerPpm)
                   ttSaldoEstoq.qtidade-atu      = f-conv-qtde(saldo-estoq.qtidade-atu,
                                                               saldo-estoq.per-ppm,
                                                               pPerPpm)
                   ttSaldoEstoq.saldo-disp       = f-conv-qtde( saldo-estoq.qtidade-atu - 
                                                               (saldo-estoq.qt-aloc-prod + 
                                                                saldo-estoq.qt-aloc-ped  + 
                                                                saldo-estoq.qt-alocada),
                                                                saldo-estoq.per-ppm,
                                                                pPerPpm)
                   ttSaldoEstoq.saldo-disp-fis   = saldo-estoq.qtidade-atu - 
                                                  (saldo-estoq.qt-aloc-prod +
                                                   saldo-estoq.qt-aloc-ped  +
                                                   saldo-estoq.qt-alocada)
                   ttSaldoEstoq.qt-aloc-prod-fis = saldo-estoq.qt-aloc-prod           
                   ttSaldoEstoq.qtidade-atu-fis  = saldo-estoq.qtidade-atu.
        end.

        ASSIGN ttSaldoEstoq.log-dep-processo = deposito.ind-processo WHEN AVAIL deposito.

        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
           if l-lote-avancado and
              not l-retorno then
               assign ttSaldoEstoq.qt-fisica = 0.
           else
        &endif

        if pTipoFormula = 2 or
           pTipoFormula = 3 then do:
            find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
    
            assign ttSaldoEstoq.qt-fisica = fn-calcula-qt-fisica(ttSaldoEstoq.saldo-disp,
                                                                 item.per-ppm,
                                                                 ttSaldoEstoq.per-ppm).
        end.
        else
            assign ttSaldoEstoq.qt-fisica = ttSaldoEstoq.saldo-disp.

        run carregaAlocaSaldoAux(input "SaldoEstoq":U,
                                 input pDepositoProcesso,
                                 input pTipoFormula).        
            
    end.
        
    for  each aloca-reserva use-index aloca no-lock
        WHERE aloca-reserva.nr-ord-produ = pNrOrdProdu
          AND aloca-reserva.item-pai     = pItemPai
          AND aloca-reserva.cod-roteiro  = pCodRoteiro
          AND aloca-reserva.op-codigo    = pOpCodigo
          and aloca-reserva.it-codigo    = pItCodigo
          and aloca-reserva.cod-refer    = pCodRefer: 

        if can-find(first ttAlocaReserva where ttAlocaReserva.nr-ord-produ = pNrOrdProdu and
                                               ttAlocaReserva.item-pai     = pItemPai    and
                                               ttAlocaReserva.cod-roteiro  = pCodRoteiro and
                                               ttAlocaReserva.op-codigo    = pOpCodigo   and
                                               ttAlocaReserva.it-codigo    = pItCodigo   and
                                               ttAlocaReserva.cod-refer    = pCodRefer and
                                               ttAlocaReserva.cod-estabel  = pCodEstabel and
                                               ttAlocaReserva.cod-depos    = aloca-reserva.cod-depos and
                                               ttAlocaReserva.cod-localiz  = aloca-reserva.cod-localiz and
                                               ttAlocaReserva.lote-serie   = aloca-reserva.lote-serie) then
            next.

        find first deposito where deposito.cod-depos = aloca-reserva.cod-depos no-lock no-error.
        if avail deposito and
           deposito.ind-processo = no and
           pDepositoProcesso then
            next.

        find first saldo-estoq where saldo-estoq.it-codigo   = pItCodigo and
                                     saldo-estoq.cod-estabel = pCodEstabel and
                                     saldo-estoq.cod-refer   = pCodRefer  and
                                     saldo-estoq.cod-depos   = aloca-reserva.cod-depos and
                                     saldo-estoq.cod-localiz = aloca-reserva.cod-localiz and
                                     saldo-estoq.lote        = aloca-reserva.lote-serie no-lock no-error.
        IF AVAIL saldo-estoq THEN DO:
            create ttAlocaReserva.
            buffer-copy aloca-reserva to ttAlocaReserva
            assign ttAlocaReserva.rowid        = rowid(aloca-reserva)
                   ttAlocaReserva.per-ppm      = saldo-estoq.per-ppm
                   ttAlocaReserva.dt-vali-lote = saldo-estoq.dt-vali-lote.
    
            IF ttAlocaReserva.qt-aloc-lote = 0 THEN
                ASSIGN ttAlocaReserva.qt-aloc-lote = ttAlocaReserva.quant-aloc.
        
            run carregaAlocaSaldoAux(input "Alocacao":U,
                                     input pDepositoProcesso,
                                     input pTipoFormula).

        END.


    end.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaAlocaSaldoAux DBOFunction 
PROCEDURE carregaAlocaSaldoAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pTipo as char no-undo.
def input param pDepositoProcesso as log no-undo.
def input param pTipoFormula as int no-undo.

if pTipo = "SaldoEstoq":U then do:

    create ttSaldoEstoqAux.
    buffer-copy ttSaldoEstoq to ttSaldoEstoqAux.
    assign ttSaldoEstoqAux.log-aloca      = no
           ttSaldoEstoqAux.r-rowid-tt     = ttSaldoEstoq.rowid
           ttSaldoEstoqAux.tipo-formula   = pTipoFormula.


end.
else do:

    create ttSaldoEstoqAux.
    buffer-copy ttAlocaReserva to ttSaldoEstoqAux.
    assign ttSaldoEstoqAux.log-aloca      = yes
           ttSaldoEstoqAux.r-rowid-tt     = ttAlocaReserva.rowid
           ttSaldoEstoqAux.saldo-disp     = ttAlocaReserva.quant-aloc
           ttSaldoEstoqAux.lote           = ttAlocaReserva.lote-serie
           ttSaldoEstoqAux.tipo-formula   = pTipoFormula
           ttSaldoEstoqAux.qt-fisica      = ttAlocaReserva.qt-aloc-lote.


    ASSIGN ttSaldoEstoqAux.log-dep-processo = NO
           ttSaldoEstoqAux.log-dep-processo = deposito.ind-processo WHEN AVAIL deposito.

end.

ASSIGN ttSaldoEstoqAux.saldo-inicial  = ttSaldoEstoqAux.qt-fisica.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaAlternativos DBOFunction 
PROCEDURE carregaAlternativos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param rRowid            as rowid no-undo.
def input param cCodEstabel       as char  no-undo.
def input param pDepositoProcesso as log   no-undo.
def input-output param table for ttSaldoEstoq.
def input-output param table for ttSaldoEstoqAux.
def input        param table for ttReservas.

find first ttReservas where ttReservas.rowid = rRowid no-lock no-error.

for each alternativo where alternativo.it-codigo = ttReservas.item-pai and
                           alternativo.es-codigo = ttReservas.it-codigo no-lock,
    first estrutura where estrutura.it-codigo   = ttReservas.item-pai and
                          estrutura.es-codigo   = ttReservas.it-codigo and
                          estrutura.sequencia   = alternativo.sequencia and
                          estrutura.op-codigo   = ttReservas.op-codigo and
                          estrutura.cod-roteiro = ttReservas.cod-roteiro no-lock:

    RUN carregaAlternativosAux(input alternativo.al-codigo,
                               input 1,
                               INPUT cCodEstabel,
                               INPUT pDepositoProcesso).
end.
                                                                                             
for each alternativo where alternativo.it-codigo = ttReservas.item-pai and                   
                           alternativo.al-codigo = ttReservas.it-codigo no-lock,             
    first estrutura where estrutura.it-codigo   = ttReservas.item-pai and                    
                          estrutura.es-codigo   = alternativo.es-codigo and                  
                          estrutura.sequencia   = alternativo.sequencia and                  
                          estrutura.cod-roteiro = ttReservas.cod-roteiro and                 
                          estrutura.op-codigo   = ttReservas.op-codigo no-lock:                                                              
                                                                                             
    RUN carregaAlternativosAux(input alternativo.es-codigo,
                               input 2,
                               INPUT cCodEstabel,
                               INPUT pDepositoProcesso).
end.                                                                                         
                                                                                             
END PROCEDURE.                                                                               
                                                                                             
/* _UIB-CODE-BLOCK-END */                                                                    
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaAlternativosAux DBOFunction 
PROCEDURE carregaAlternativosAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-item-alt        as char  no-undo.
def input param p-tipo            as int   no-undo.
def input param cCodEstabel       as char  no-undo.
def input param pDepositoProcesso as log   no-undo.
DEF VAR d-saldo-aux AS DECIMAL NO-UNDO.

    IF NOT AVAIL ttReservas OR
       NOT AVAIL alternativo OR
       NOT AVAIL estrutura THEN
        RETURN "NOK":U.

    for each saldo-estoq where saldo-estoq.it-codigo   = p-item-alt and
                               saldo-estoq.cod-estabel = cCodEstabel no-lock:

        ASSIGN d-saldo-aux = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped  + saldo-estoq.qt-alocada)).

        IF NOT tgZerados AND d-saldo-aux  <= 0 THEN 
            NEXT.

        find first deposito where deposito.cod-depos = saldo-estoq.cod-depos no-lock no-error.
        if avail deposito and
           deposito.ind-processo = no and
           pDepositoProcesso then do:
            if can-find(first ttSaldoEstoq where ttSaldoEstoq.cod-depos = saldo-estoq.cod-depos) then do:
                for each ttSaldoEstoq where ttSaldoEstoq.cod-depos = saldo-estoq.cod-depos:
                    delete ttSaldoEstoq.
                end.
                next.
            end.
            else
                next.
        end.
        IF AVAIL deposito and deposito.ind-dep-rej THEN
            NEXT.

		IF AVAIL deposito and lDepFechado and deposito.ind-tipo-dep = 2 THEN
            NEXT.

        if can-find(first ttSaldoEstoq where ttSaldoEstoq.cod-estabel = saldo-estoq.cod-estabel and
                                             ttSaldoEstoq.it-codigo   = saldo-estoq.it-codigo and
                                             ttSaldoEstoq.lote        = saldo-estoq.lote and
                                             ttSaldoEstoq.cod-refer   = saldo-estoq.cod-refer and
                                             ttSaldoEstoq.cod-depos   = saldo-estoq.cod-depos and
                                             ttSaldoEstoq.cod-localiz = saldo-estoq.cod-localiz) then
            next.

        find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        if l-lote-avancado and
           item.tipo-con-est > 2 then do:

                run pi-identifica-saldo in h-ceapi030 (input 1,
                                                       input saldo-estoq.it-codigo,
                                                       input saldo-estoq.cod-estabel,
                                                       input saldo-estoq.lote, 
                                                       input 0,
                                                       output l-retorno,
                                                       output table tt-valores2,
                                                       output table tt-erro).

        end.
        else
            assign l-retorno = yes.
        
      &endif

        if not (param-global.modulo-per-ppm and
                item.tipo-formula >= 2      and
                item.tipo-formula <= 3) then do:            

            create ttSaldoEstoq.
            buffer-copy saldo-estoq to ttSaldoEstoq .
            assign ttSaldoEstoq.rowid            = rowid(saldo-estoq)
                   ttSaldoEstoq.log-disp         = (saldo-estoq.qtidade-atu > 0)
                   ttSaldoEstoq.tipo-formula     = item.tipo-formula
                   ttSaldoEstoq.log-alternativo  = yes
                   ttSaldoEstoq.item-pai         = ttReservas.it-codigo                                      
                   ttSaldoEstoq.alternativo-de      = ttReservas.it-codigo
                   ttSaldoEstoq.cod-refer-it-orig   = ttReservas.cod-refer
                   ttSaldoEstoq.alt-quant-usada     = if p-tipo = 1 then alternativo.quant-usada else estrutura.quant-usada
                   ttSaldoEstoq.alt-quant-origem    = if p-tipo = 1 then estrutura.quant-usada else alternativo.quant-usada
                   ttSaldoEstoq.alt-qtd-item-estrut = estrutura.qtd-item
                   ttSaldoEstoq.alt-qtd-compon-estrut = estrutura.qtd-compon.    

          &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            if l-lote-avancado and
               not l-retorno then do:
                assign ttSaldoEstoq.saldo-disp       = 0
                       ttSaldoEstoq.qt-aloc-prod-fis = 0
                       ttSaldoEstoq.qtidade-atu-fis  = 0
                       ttSaldoEstoq.saldo-disp-fis   = 0
                       ttSaldoEstoq.qt-aloc-prod     = 0
                       ttSaldoEstoq.qtidade-atu      = 0
                       ttSaldoEstoq.log-disp         = no.
            end.
            else
          &endif

                assign ttSaldoEstoq.saldo-disp       = saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + 
                                                                                  saldo-estoq.qt-aloc-ped  + 
                                                                                  saldo-estoq.qt-alocada)
                       ttSaldoEstoq.qt-aloc-prod-fis = ttSaldoEstoq.qt-aloc-prod         
                       ttSaldoEstoq.qtidade-atu-fis  = ttSaldoEstoq.qtidade-atu         
                       ttSaldoEstoq.saldo-disp-fis   = ttSaldoEstoq.saldo-disp.
        end.                                           
        else do:                                       
            create ttSaldoEstoq.
            buffer-copy saldo-estoq except saldo-estoq.qt-aloc-prod saldo-estoq.qtidade-atu to ttSaldoEstoq .
            assign ttSaldoEstoq.rowid           = rowid(saldo-estoq)
                   ttSaldoEstoq.log-disp        = (saldo-estoq.qtidade-atu > 0).
            assign ttSaldoEstoq.tipo-formula    = item.tipo-formula
                   ttSaldoEstoq.log-alternativo = yes
                   ttSaldoEstoq.item-pai        = ttReservas.it-codigo
                   /*Projeto 346 - Controle de Potància - Campos em quantidade F°sica,
                     para exibiá∆o em tela.*/                                         
                   ttSaldoEstoq.alternativo-de      = ttReservas.it-codigo             
                   ttSaldoEstoq.cod-refer-it-orig   = ttReservas.cod-refer
                   ttSaldoEstoq.alt-quant-usada     = if p-tipo = 1 then alternativo.quant-usada else estrutura.quant-usada
                   ttSaldoEstoq.alt-quant-origem    = if p-tipo = 1 then estrutura.quant-usada else alternativo.quant-usada
                   ttSaldoEstoq.alt-qtd-item-estrut = estrutura.qtd-item
                   ttSaldoEstoq.alt-qtd-compon-estrut = estrutura.qtd-compon.

          &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            if l-lote-avancado and
               not l-retorno then do:
                assign ttSaldoEstoq.qt-aloc-prod     = 0
                       ttSaldoEstoq.qtidade-atu      = 0
                       ttSaldoEstoq.saldo-disp       = 0
                       ttSaldoEstoq.qt-aloc-prod-fis = 0
                       ttSaldoEstoq.qtidade-atu-fis  = 0
                       ttSaldoEstoq.saldo-disp-fis   = 0
                       ttSaldoEstoq.log-disp         = no.
            end.
            else
          &endif

                assign ttSaldoEstoq.qt-aloc-prod     = f-conv-qtde(saldo-estoq.qt-aloc-prod,
                                                                   saldo-estoq.per-ppm,
                                                                   item.per-ppm)
                       ttSaldoEstoq.qtidade-atu      = f-conv-qtde(saldo-estoq.qtidade-atu,
                                                                   saldo-estoq.per-ppm,
                                                                   item.per-ppm)
                       ttSaldoEstoq.saldo-disp       = f-conv-qtde(saldo-estoq.qtidade-atu - 
                                                                  (saldo-estoq.qt-aloc-prod + 
                                                                   saldo-estoq.qt-aloc-ped  + 
                                                                   saldo-estoq.qt-alocada),
                                                                   saldo-estoq.per-ppm,
                                                                   item.per-ppm)
                       ttSaldoEstoq.qt-aloc-prod-fis = saldo-estoq.qt-aloc-prod           
                       ttSaldoEstoq.qtidade-atu-fis  = saldo-estoq.qtidade-atu            
                       ttSaldoEstoq.saldo-disp-fis   = saldo-estoq.qtidade-atu -          
                                                      (saldo-estoq.qt-aloc-prod +         
                                                       saldo-estoq.qt-aloc-ped  +         
                                                       saldo-estoq.qt-alocada).         
        end.

        ASSIGN ttSaldoEstoq.log-dep-processo = deposito.ind-processo WHEN AVAIL deposito.

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        if l-lote-avancado and
           not l-retorno then do:
            assign ttSaldoEstoq.qt-fisica = 0.
        end.
        else
      &endif

        if item.tipo-formula = 2 or
           item.tipo-formula = 3 then
            assign ttSaldoEstoq.qt-fisica = fn-calcula-qt-fisica(ttSaldoEstoq.saldo-disp,
                                                                 item.per-ppm,
                                                                 ttSaldoEstoq.per-ppm).
        else
            assign ttSaldoEstoq.qt-fisica = ttSaldoEstoq.saldo-disp.

        run carregaAlocaSaldoAux(input "SaldoEstoq":U,
                                 input pDepositoProcesso,
                                 input item.tipo-formula).

    end. /*for each saldo-estoq*/

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaReqOrd DBOFunction 
PROCEDURE carregaReqOrd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pNrOrdProdu    as int  no-undo.
def input param pItemPai       as char no-undo.
def input param pCodRoteiro    as char no-undo.
def input param pOpCodigo      as int  no-undo.
def input param pItCodigo      as char no-undo.
def input param pCodRefer      as char no-undo.
def input param pPerPpm        as dec  no-undo.
def input param pTipoFormula   as int  no-undo.
def input-output param table for ttReqOrd.
    
    for each ttReqOrd where
             ttReqOrd.nr-ord-produ = pNrOrdProdu and
             ttReqOrd.item-pai     = pItemPai    and
             ttReqOrd.cod-roteiro  = pCodRoteiro and
             ttReqOrd.op-codigo    = pOpCodigo   and
             ttReqOrd.it-codigo    = pItCodigo   and
             ttReqOrd.cod-refer    = pCodRefer:
             
        delete ttReqOrd.
    end.
    
    for each req-ord no-lock where
             req-ord.nr-ord-produ = pNrOrdProdu and
             req-ord.item-pai     = pItemPai    and
             req-ord.cod-roteiro  = pCodRoteiro and
             req-ord.op-codigo    = pOpCodigo   and
             req-ord.it-codigo    = pItCodigo   and
             req-ord.cod-refer    = pCodRefer:

        find first saldo-estoq where saldo-estoq.it-codigo   = pItCodigo and
                                     saldo-estoq.cod-estabel = req-ord.cod-estabel and
                                     saldo-estoq.cod-refer   = pCodRefer  and
                                     saldo-estoq.cod-depos   = req-ord.cod-depos and
                                     saldo-estoq.cod-localiz = req-ord.cod-localiz and
                                     saldo-estoq.lote        = req-ord.lote-serie no-lock no-error.

        create ttReqOrd.
        buffer-copy req-ord to ttReqOrd
        assign ttReqOrd.per-ppm            = saldo-estoq.per-ppm
               ttReqOrd.dt-saida           = ?
               ttReqOrd.tipo-trans         = 0
               ttReqOrd.dt-vali-lote       = saldo-estoq.dt-vali-lote
               ttReqOrd.tipo-formula       = pTipoFormula.

            if ttReqOrd.qtd-requisitd-lote = 0 then
                assign ttReqOrd.qtd-requisitd-lote = ttReqOrd.qt-requis.

    end.

    for each req-altern where req-altern.nr-ord-produ = pNrOrdProdu and
                              req-altern.item-pai    = pItemPai and
                              req-altern.cod-roteiro = pCodRoteiro and
                              req-altern.op-codigo   = pOpCodigo and
                              req-altern.it-codigo   = pItCodigo and
                              req-altern.cod-refer   = pCodRefer no-lock:

        for each ttReqOrd where ttReqOrd.nr-ord-produ = pNrOrdProdu and
                                ttReqOrd.item-pai     = pItemPai    and
                                ttReqOrd.cod-roteiro  = pCodRoteiro and
                                ttReqOrd.op-codigo    = pOpCodigo   and
                                ttReqOrd.it-codigo    = req-altern.al-codigo:

            delete ttReqOrd.
        end.

        for each req-ord no-lock
           where req-ord.nr-ord-produ = pNrOrdProdu and
                 req-ord.item-pai     = pItemPai    and
                 req-ord.cod-roteiro  = pCodRoteiro and
                 req-ord.op-codigo    = pOpCodigo   and
                 req-ord.it-codigo    = req-altern.al-codigo :

            find first saldo-estoq where saldo-estoq.it-codigo   = req-ord.it-codigo and
                                         saldo-estoq.cod-estabel = req-ord.cod-estabel and
                                         saldo-estoq.cod-refer   = req-ord.cod-refer  and
                                         saldo-estoq.cod-depos   = req-ord.cod-depos and
                                         saldo-estoq.cod-localiz = req-ord.cod-localiz and
                                         saldo-estoq.lote        = req-ord.lote-serie no-lock no-error.

            find first movto-estoq where movto-estoq.nr-trans = req-altern.nr-trans no-lock no-error.

            create ttReqOrd.
            buffer-copy req-ord to ttReqOrd.
            assign ttReqOrd.per-ppm               = saldo-estoq.per-ppm
                   ttReqOrd.dt-saida              = ?
                   ttReqOrd.tipo-trans            = 0
                   ttReqOrd.dt-vali-lote          = saldo-estoq.dt-vali-lote
                   ttReqOrd.tipo-formula          = pTipoFormula
                   ttReqOrd.alternativo-de        = req-altern.it-codigo
                   ttReqOrd.cod-refer-it-original = req-altern.cod-refer.

            if ttReqOrd.qtd-requisitd-lote = 0 then
                assign ttReqOrd.qtd-requisitd-lote = ttReqOrd.qt-requis.

        end.

    end.


return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CarregaReservas DBOFunction 
PROCEDURE CarregaReservas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pOrdProd as int no-undo.
def input param pReservasSemSaldoARequisitar as log no-undo.
def input-output param table for ttReservas.

def var c-texto as char no-undo.
DEF VAR l-valida-transf AS LOGICAL INIT NO NO-UNDO.
    
    for first ord-prod fields (cod-estabel) no-lock where
              ord-prod.nr-ord-produ = pOrdProd: end.
    
    for each reservas use-index codigo no-lock where
             reservas.nr-ord-produ  = pOrdProd  and
             reservas.estado        = 1         and
             reservas.quant-orig > 0 :
                                                                                                                            
        for first item-uni-estab fields (perm-saldo-neg tipo-requis) no-lock where                                              
                  item-uni-estab.it-codigo   = reservas.it-codigo and                                                        
                  item-uni-estab.cod-estabel = ord-prod.cod-estabel: end.                                                      
        IF AVAIL item-uni-estab THEN DO: 

            IF  c-nom-prog-upc-mg97  <> '':U THEN DO: 

                for each tt-epc where tt-epc.cod-event = "validaTransf":
                    delete tt-epc.
                end.
                
                {include/i-epc200.i2 &CodEvent='"validaTransf"'
                                    &CodParameter='"rowidtable"'
                                    &ValueParameter="string(rowid(item-uni-estab))"}
                                    
                {include/i-epc201.i "validaTransf"}
                
                FOR FIRST tt-epc
                    WHERE tt-epc.cod-event     = "validaTransf"
                    AND   tt-epc.cod-parameter = "RetornoUPC" NO-LOCK:
                    
                    ASSIGN l-valida-transf = IF tt-epc.val-parameter = "YES" THEN YES ELSE NO.

                END.
                
            END.

            IF NOT l-valida-transf THEN                                                                                     
                if item-uni-estab.tipo-requis = 2 then next. /* Transferància */

            if can-find(ttReservas where ttReservas.nr-ord-produ = reservas.nr-ord-produ and
                                         ttReservas.item-pai     = reservas.item-pai and
                                         ttReservas.cod-roteiro  = reservas.cod-roteiro and
                                         ttReservas.op-codigo    = reservas.op-codigo and       
                                         ttReservas.it-codigo    = reservas.it-codigo and
                                         ttReservas.cod-refer    = reservas.cod-refer) then
                next.
    
            create ttReservas.
            buffer-copy reservas to ttReservas
                assign ttReservas.rowid          = rowid(reservas)
                       ttReservas.perm-saldo-neg = item-uni-estab.perm-saldo-neg
                       ttReservas.quant-a-req    = if reservas.quant-orig - reservas.quant-atend > 0 then
                                                       reservas.quant-orig - reservas.quant-atend
                                                   else
                                                       0.
            find first item where item.it-codigo = ttReservas.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL item THEN DO:
                ASSIGN ttReservas.desc-item = item.desc-item.
            END.
			
            if not pReservasSemSaldoARequisitar and
               ttReservas.quant-a-req <= 0 then
                delete ttReservas.

      END.
      else do:
            assign c-texto = reservas.it-codigo + "~~" + ord-prod.cod-estabel.
            {method/svc/errors/inserr.i
                 &ErrorNumber="25904"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="c-texto"}
      end.
 
    end.

return 'ok':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRequisicao DBOFunction 
PROCEDURE criaRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param pNrOrdProdu   as int   no-undo.
def input  param pItemPai      as char  no-undo.
def input  param pCodRoteiro   as char  no-undo. 
def input  param pOpCodigo     as int   no-undo. 
def input  param pItCodigo     as char  no-undo. 
def input  param pCodRefer     as char  no-undo. 
def input  param pCodEstabel   as char  no-undo. 
def input  param pCodDepos     as char  no-undo. 
def input  param pCodLocaliz   as char  no-undo. 
def input  param pLoteSerie    as char  no-undo. 
def input  param pQtRequis     as dec   no-undo. 
def input  param pQtAloc       as dec   no-undo. 
def input  param pPerPpm       as dec   no-undo. 
def input  param pTipoFormula  as int   no-undo. 
def input  param pDataValiLote as date  no-undo.

def buffer bttReqOrd  for ttReqOrd.

find first bttReqOrd where bttReqOrd.nr-ord-produ = pNrOrdProdu  and 
                           bttReqOrd.item-pai     = pItemPai     and 
                           bttReqOrd.cod-roteiro  = pCodRoteiro  and 
                           bttReqOrd.op-codigo    = pOpCodigo    and 
                           bttReqOrd.it-codigo    = pItCodigo    and 
                           bttReqOrd.cod-refer    = pCodRefer    and 
                           bttReqOrd.cod-estabel  = pCodEstabel  and
                           bttReqOrd.cod-depos    = pCodDepos    and
                           bttReqOrd.cod-localiz  = pCodLocaliz  and
                           bttReqOrd.lote-serie   = pLoteSerie   no-error.
if not avail bttReqOrd then do:

    create bttReqOrd.
    assign bttReqOrd.nr-ord-produ = pNrOrdProdu
           bttReqOrd.item-pai     = pItemPai
           bttReqOrd.cod-roteiro  = pCodRoteiro
           bttReqOrd.op-codigo    = pOpCodigo
           bttReqOrd.it-codigo    = pItCodigo
           bttReqOrd.cod-refer    = pCodRefer
           bttReqOrd.cod-estabel  = pCodEstabel
           bttReqOrd.cod-depos    = pCodDepos
           bttReqOrd.cod-localiz  = pCodLocaliz
           bttReqOrd.lote-serie   = pLoteSerie
           bttReqOrd.qt-requis    = pQtRequis
           bttReqOrd.per-ppm      = pPerPpm
           bttReqOrd.tipo-formula = pTipoFormula
           bttReqOrd.tipo-trans   = 0 /* Display */
           bttReqOrd.dt-saida     = ?
           bttReqOrd.dt-vali-lote = pDataValiLote.

    create bttReqOrd.
    assign bttReqOrd.nr-ord-produ = pNrOrdProdu
           bttReqOrd.item-pai     = pItemPai
           bttReqOrd.cod-roteiro  = pCodRoteiro
           bttReqOrd.op-codigo    = pOpCodigo
           bttReqOrd.it-codigo    = pItCodigo
           bttReqOrd.cod-refer    = pCodRefer
           bttReqOrd.cod-estabel  = pCodEstabel
           bttReqOrd.cod-depos    = pCodDepos
           bttReqOrd.cod-localiz  = pCodLocaliz
           bttReqOrd.lote-serie   = pLoteSerie
           bttReqOrd.qt-requis    = pQtRequis
           bttReqOrd.qt-aloc      = pQtAloc
           bttReqOrd.per-ppm      = pPerPpm
           bttReqOrd.tipo-formula = pTipoFormula
           bttReqOrd.tipo-trans   = 1 /* Adiciona */
           bttReqOrd.dt-saida     = ?
           bttReqOrd.dt-vali-lote = pDataValiLote.  

end.
else do:

    for each bttReqOrd where bttReqOrd.nr-ord-produ = pNrOrdProdu  and
                             bttReqOrd.item-pai     = pItemPai     and
                             bttReqOrd.cod-roteiro  = pCodRoteiro  and
                             bttReqOrd.op-codigo    = pOpCodigo    and
                             bttReqOrd.it-codigo    = pItCodigo    and
                             bttReqOrd.cod-refer    = pCodRefer    and
                             bttReqOrd.cod-estabel  = pCodEstabel  and
                             bttReqOrd.cod-depos    = pCodDepos    and
                             bttReqOrd.cod-localiz  = pCodLocaliz  and
                             bttReqOrd.lote-serie   = pLoteSerie:

        find first bfttSaldoEstoq where bfttSaldoEstoq.cod-estabel = bttReqOrd.cod-estabel and
                                        bfttSaldoEstoq.cod-depos   = bttReqOrd.cod-depos and
                                        bfttSaldoEstoq.cod-localiz = bttReqOrd.cod-localiz and
                                        bfttSaldoEstoq.lote        = bttReqOrd.lote-serie and
                                        bfttSaldoEstoq.it-codigo   = bttReqOrd.it-codigo and
                                        bfttSaldoEstoq.cod-refer   = bttReqOrd.cod-refer no-error.

        find first ttSaldoEstoqAux where ttSaldoEstoqAux.r-rowid-tt = bfttSaldoEstoq.rowid no-lock no-error.

        assign bfttSaldoEstoq.saldo-disp  = bfttSaldoEstoq.saldo-disp - (bttReqOrd.qt-requis - pQtRequis)
               ttSaldoEstoqAux.saldo-disp = bfttSaldoEstoq.saldo-disp
               bttReqOrd.qt-requis        = pQtRequis.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCampos DBOFunction 
PROCEDURE retornaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input  param pItCodigo as char no-undo.
def output param pDescItem as char no-undo.
def output param pCodRefer as char no-undo.
def output param pUn       as char no-undo.

    for first item fields (item.desc-item item.cod-refer item.un) no-lock where
              item.it-codigo = pItCodigo:
    
        assign pDescItem = item.desc-item
               pCodRefer = item.cod-refer
               pUn       = item.un.
    end.
    
return 'ok':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaParamCpLote DBOFunction 
PROCEDURE retornaParamCpLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param pLoteCp as char no-undo.

    for first param-cp fields (param-cp.lote) no-lock:
        assign pLoteCp = param-cp.lote.
    end.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTipoConEst DBOFunction 
PROCEDURE retornaTipoConEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input  param pItCodigo   as char no-undo.
def output param pTipoConEst as int  no-undo.
    
    for first item fields (tipo-con-est) no-lock where
              item.it-codigo = pItCodigo:
        assign pTipoConEst = item.tipo-con-est.
    end.
    
return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaPerPpm DBOFunction 
PROCEDURE setaPerPpm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param pPerPpm as log no-undo.

    for first param-global fields (modulo-per-ppm) no-lock:
        assign pPerPpm = param-global.modulo-per-ppm.
    end.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaBalanceio DBOFunction 
PROCEDURE verificaBalanceio :
/*------------------------------------------------------------------------------
  Purpose:     Usada pelo CP0309 - Bot∆o Balancear.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output param table for ttReservas.
def input-output param table for ttSaldoEstoq.
def input-output param table for ttAlocaReserva.
def input-output param table for ttReqOrd.

DEFINE VARIABLE de-total-quant-orig        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-soma-qt-requis          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-total              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-modif              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-quant-a-req-teorica     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-quant-a-req-fisica      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-quant-a-req-fis-orig    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deQtRequis                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deQtRequisFis              AS DECIMAL     NO-UNDO. 
DEFINE VARIABLE c-retorno                  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE deQuantAux                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-devolver                 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE r-rowid                    AS ROWID       NO-UNDO.

DEFINE VARIABLE c-deposito-balanc AS CHARACTER   NO-UNDO.

DEFINE VARIABLE l-veiculo-neg AS LOGICAL     NO-UNDO.

DEF BUFFER bTTReqOrd      FOR ttReqOrd.
DEF BUFFER b-tt-balanceia FOR tt-balanceia.

EMPTY TEMP-TABLE tt-balanceia.
EMPTY TEMP-TABLE tt-valida-req.
EMPTY TEMP-TABLE rowErrors.

{cpp/cpapi029.i}


/*Acumula as qtds originais de todas as reservas concentracao e ppm da ordem.*/
FIND FIRST ttReservas NO-ERROR.
IF AVAIL ttReservas THEN DO:

    FIND FIRST ord-prod NO-LOCK
         WHERE ord-prod.nr-ord-produ = ttReservas.nr-ord-produ NO-ERROR.

    for each reservas no-lock                                                                                  
       where reservas.nr-ord-produ = ttReservas.nr-ord-produ                                               
         and reservas.tipo-formula >= 2                                                                        
         and reservas.tipo-formula <= 3:                                                                       
         assign de-total-quant-orig = de-total-quant-orig + reservas.quant-orig. 
    end. 
END.

IF de-total-quant-orig = 0 THEN
    RETURN "OK":U.


IF NOT VALID-HANDLE(h-cpapi029) THEN
    RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.


RUN pi-execute IN h-cpapi029 (INPUT 2,
                              INPUT ord-prod.cod-estabel,
                              INPUT ord-prod.nr-linha,
                              OUTPUT c-dep-fabrica,
                              OUTPUT d-var-rep       ,
                              OUTPUT d-var-req-menor ,
                              OUTPUT d-var-requis    ,
                              OUTPUT d-var-transf   ,
                              OUTPUT TABLE tt-erro append). 



/*Gera as ttReqOrd que ainda nao tiverem sido criadas.*/
FOR EACH ttReservas:
    if not can-find (first ttReqOrd where
                           ttReqOrd.nr-ord-produ = ttReservas.nr-ord-produ and
                           ttReqOrd.item-pai     = ttReservas.item-pai     and
                           ttReqOrd.cod-roteiro  = ttReservas.cod-roteiro  and
                           ttReqOrd.op-codigo    = ttReservas.op-codigo    and
                         ((ttReqOrd.it-codigo         = ttReservas.it-codigo    and
                           ttReqOrd.cod-refer         = ttReservas.cod-refer) or
                          (ttReqOrd.alternativo-de    <> "" and
                           ttReqOrd.alternativo-de    = ttReservas.it-codigo and
                           ttReqOrd.cod-refer-it-original = ttReservas.cod-refer))) THEN 
        run carregaReqOrd (input ttReservas.nr-ord-produ,
                           input ttReservas.item-pai,
                           input ttReservas.cod-roteiro,
                           input ttReservas.op-codigo,
                           input ttReservas.it-codigo,
                           input ttReservas.cod-refer,
                           input ttReservas.per-ppm,
                           input ttReservas.tipo-formula,
                           input-output table ttReqOrd).
END.

/*Soma quanto est† sendo requisitado e devolvido de todas as reservas per-ppm.*/

DEFINE VARIABLE de-soma-qt-requis-fis AS DECIMAL     NO-UNDO.
FOR EACH ttReqOrd
   WHERE ttReqOrd.tipo-trans > 0
     AND ttReqOrd.tipo-formula >= 2 
     AND ttReqOrd.tipo-formula <= 3:

    IF ttReqOrd.tipo-trans = 1 /*Inclui*/ then do:

        find first ttReqAltern where ttReqAltern.nr-ord-produ = ttReqOrd.nr-ord-produ and 
                                     ttReqAltern.item-pai    = ttReqOrd.item-pai and
                                     ttReqAltern.it-codigo   = ttReqOrd.alternativo-de and
                                     ttReqAltern.cod-roteiro = ttReqOrd.cod-roteiro and
                                     ttReqAltern.op-codigo   = ttReqOrd.op-codigo and
                                     ttReqAltern.cod-refer   = ttReqOrd.cod-refer-it-original and
                                     ttReqAltern.al-codigo   = ttReqOrd.it-codigo and
                                     ttReqAltern.tipo-trans  = 1 and
                                     ttReqAltern.lote-serie        = ttReqOrd.lote-serie and
                                     ttReqAltern.cod-depos   = ttReqOrd.cod-depos and
                                     ttReqAltern.cod-localiz = ttReqOrd.cod-localiz no-lock no-error.
        if avail ttReqAltern then
            assign de-soma-qt-requis = de-soma-qt-requis + ttReqAltern.qt-atend
                   de-soma-qt-requis-fis = de-soma-qt-requis-fis + ttReqAltern.qt-atend-lote.
        else
            assign de-soma-qt-requis = de-soma-qt-requis + ttReqOrd.qt-requis
                   de-soma-qt-requis-fis = de-soma-qt-requis-fis + ttReqOrd.qtd-requisitd-lote.
    end.
    else do:

        find first ttReqAltern where ttReqAltern.nr-ord-produ = ttReqOrd.nr-ord-produ and 
                                     ttReqAltern.item-pai    = ttReqOrd.item-pai and
                                     ttReqAltern.it-codigo   = ttReqOrd.alternativo-de and
                                     ttReqAltern.cod-roteiro = ttReqOrd.cod-roteiro and
                                     ttReqAltern.op-codigo   = ttReqOrd.op-codigo and
                                     ttReqAltern.cod-refer   = ttReqOrd.cod-refer-it-original and
                                     ttReqAltern.al-codigo   = ttReqOrd.it-codigo and
                                     ttReqAltern.tipo-trans  = 2 and
                                     ttReqAltern.lote-serie        = ttReqOrd.lote-serie and
                                     ttReqAltern.cod-depos   = ttReqOrd.cod-depos and
                                     ttReqAltern.cod-localiz = ttReqOrd.cod-localiz no-lock no-error.
        if avail ttReqAltern then
            assign de-soma-qt-requis = de-soma-qt-requis - ttReqAltern.qt-atend
                   de-soma-qt-requis-fis = de-soma-qt-requis-fis - ttReqAltern.qt-atend-lote.
        else
            assign de-soma-qt-requis = de-soma-qt-requis - ttReqOrd.qt-requis
                   de-soma-qt-requis-fis = de-soma-qt-requis-fis - ttReqOrd.qtd-requisitd-lote.
    end.
                                
    create tt-balanceia.
    assign tt-balanceia.nr-ord-produ          = ttReqOrd.nr-ord-produ
           tt-balanceia.it-codigo             = if avail ttReqAltern then ttReqAltern.it-codigo else ttReqOrd.it-codigo
           tt-balanceia.quant-requis          = ttReqOrd.qt-requis
           tt-balanceia.quant-movto           = ttReqOrd.qtd-requisitd-lote
           tt-balanceia.cod-versao-integracao = 001.

    IF ttReqOrd.tipo-trans = 2 /*Elimina*/ THEN
        ASSIGN tt-balanceia.quant-requis = tt-balanceia.quant-requis * -1
               tt-balanceia.quant-movto  = tt-balanceia.quant-movto  * -1.

    /****Gera temp-table com dados necess†rios para pre-validar as requisicoes de itens per-ppm***/
    FIND FIRST tt-valida-req
         WHERE tt-valida-req.nr-ord-produ = ttReqOrd.nr-ord-produ
           AND tt-valida-req.item-pai     = ttReqOrd.item-pai    
           AND tt-valida-req.cod-roteiro  = ttReqOrd.cod-roteiro 
           AND tt-valida-req.op-codigo    = ttReqOrd.op-codigo   
           and ((tt-valida-req.it-codigo    = ttReqOrd.it-codigo   
           AND  tt-valida-req.cod-refer    = ttReqOrd.cod-refer)
           or  (ttReqOrd.alternativo-de    <> ""
           and  tt-valida-req.it-codigo    = ttReqOrd.alternativo-de   
           AND  tt-valida-req.cod-refer    = ttReqOrd.cod-refer-it-original)) NO-ERROR.
    IF NOT AVAIL tt-valida-req THEN DO:
        CREATE tt-valida-req.
        ASSIGN tt-valida-req.nr-ord-produ = ttReqOrd.nr-ord-produ
               tt-valida-req.item-pai     = ttReqOrd.item-pai    
               tt-valida-req.cod-roteiro  = ttReqOrd.cod-roteiro 
               tt-valida-req.op-codigo    = ttReqOrd.op-codigo   
               tt-valida-req.it-codigo    = ttReqOrd.it-codigo   
               tt-valida-req.cod-refer    = ttReqOrd.cod-refer.
        if ttReqOrd.alternativo-de    <> "" then
            assign tt-valida-req.it-codigo    = ttReqOrd.alternativo-de   
                   tt-valida-req.cod-refer    = ttReqOrd.cod-refer-it-original.
    END.
    case ttReqOrd.tipo-trans:                                                 
        when 1 then                                                           
            assign tt-valida-req.deQuantTotal   = tt-valida-req.deQuantTotal + (if avail ttReqAltern then 
                                                                                    ttReqAltern.qt-atend 
                                                                                else    
                                                                                    ttReqOrd.qt-requis)         
                   tt-valida-req.deQuantAloc    = tt-valida-req.deQuantAloc  + ttReqOrd.qt-aloc           
                   tt-valida-req.deQuantTotLote = tt-valida-req.deQuantTotLote + if avail ttReqAltern then 
                                                                                     ttReqAltern.qt-atend-lote
                                                                                 else
                                                                                     ttReqOrd.qtd-requisitd-lote. 
        when 2 then                                                                    
            assign tt-valida-req.deQuantTotal   = tt-valida-req.deQuantTotal - if avail ttReqAltern then
                                                                                   ttReqAltern.qt-atend
                                                                               else
                                                                                   ttReqOrd.qt-requis         
                   tt-valida-req.deQuantTotLote = tt-valida-req.deQuantTotLote - if avail ttReqAltern then
                                                                                     ttReqAltern.qt-atend-lote
                                                                                 else
                                                                                     ttReqOrd.qtd-requisitd-lote. 
    end case.

    FIND FIRST deposito WHERE deposito.cod-depos = ttReqOrd.cod-depos NO-LOCK NO-ERROR.
    IF AVAIL deposito AND deposito.ind-dep-cq then do:

        {method/svc/errors/inserr.i
                           &ErrorNumber="1210"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters=" "} 
        IF AVAIL rowErrors THEN DO:
            {utp/ut-liter.i Erro_Comp._Concentr/PPM *}
            ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ": ":U + RowErrors.ErrorDescription.
            {utp/ut-liter.i Item *}
            ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " - ":U + RETURN-VALUE + ": ":U + ttReqOrd.it-codigo + " ".
            {utp/ut-liter.i Dep¢sito *}
            ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + RETURN-VALUE + ": ":U + ttReqOrd.cod-depos + ". ".
            {utp/ut-liter.i Corrija_o_erro_antes_de_tentar_balancear_novamente. *}
            ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " ":U + RETURN-VALUE.
        END.
    end.

    FIND FIRST ITEM WHERE ITEM.it-codigo = ttReqOrd.it-codigo
                      AND ITEM.cod-refer = ttReqOrd.cod-refer NO-LOCK NO-ERROR.
    IF AVAIL ITEM AND item.tipo-con-est <> 1 AND item.tipo-con-est <> 2 THEN do:

        find first saldo-estoq where
                   saldo-estoq.it-codigo = ttReqOrd.it-codigo  and
                   saldo-estoq.lote      = ttReqOrd.lote-serie
                   no-lock no-error.
    
        if avail saldo-estoq and
           saldo-estoq.dt-vali-lote < today then do:
            /* Lote com data vencida */
            {method/svc/errors/inserr.i
                               &ErrorNumber="3007"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters=" "} 
            IF AVAIL rowErrors THEN DO:
                {utp/ut-liter.i Erro_Comp._Concentr/PPM *}
                ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ": ":U + RowErrors.ErrorDescription.
                {utp/ut-liter.i Item *}
                ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " - ":U + RETURN-VALUE + ": ":U + ttReqOrd.it-codigo + " ".
                {utp/ut-liter.i Lote *}
                ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + RETURN-VALUE + ": ":U + ttReqOrd.lote-serie + ". ".
                {utp/ut-liter.i Corrija_o_erro_antes_de_tentar_balancear_novamente. *}
                ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " ":U + RETURN-VALUE.
            END.
        end.
    END.
END.

FIND FIRST param-cp NO-LOCK NO-ERROR.

FOR EACH tt-valida-req:

    FIND FIRST reservas NO-LOCK
         WHERE reservas.nr-ord-produ = tt-valida-req.nr-ord-produ
           AND reservas.item-pai     = tt-valida-req.item-pai    
           AND reservas.cod-roteiro  = tt-valida-req.cod-roteiro 
           AND reservas.op-codigo    = tt-valida-req.op-codigo   
           AND reservas.it-codigo    = tt-valida-req.it-codigo   
           AND reservas.cod-refer    = tt-valida-req.cod-refer NO-ERROR.
    IF NOT AVAIL reservas THEN
        NEXT.

    if tt-valida-req.deQuantAloc < reservas.quant-aloc and                                                               
       tt-valida-req.deQuantAloc < tt-valida-req.deQuantTotal then do:                                                                 
         /*** Alocacao nao esta totalmente requisitada e esta tentando requistar direto do saldo ***/       
         {method/svc/errors/inserr.i
                            &ErrorNumber="27713"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="reservas.it-codigo"} 
         IF AVAIL rowErrors THEN DO:
             {utp/ut-liter.i Erro_Comp._Concentr/PPM *}
             ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ": ":U + RowErrors.ErrorDescription.
             {utp/ut-liter.i Corrija_o_erro_antes_de_tentar_balancear_novamente. *}
             ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " ":U + RETURN-VALUE.
         END.
    end.                                                                                                   
                                                                                                           
    if param-cp.ver-req and                                                                                
       reservas.log-quant-fix = NO AND
       d-var-requis  < 999 then do:                                                                  
                                                                                                           
        /*Caso a reserva seja ve°culo, e a quantidade te¢rica esteja diferente da qtd f°sica, significa que
          a quantidade est† balanceada. Neste caso, n∆o ir† validar variaá∆o de requisiá∆o.*/              
        if not(reservas.tipo-formula = 4 and                                                               
               reservas.veiculo and                                                                        
               tt-valida-req.deQuantTotal  <> tt-valida-req.deQuantTotLote) then do:                                                   
            assign deQuantAux = reservas.quant-orig + (reservas.quant-orig * d-var-requis  / 100)   
                   deQuantAux = if not item.fraciona then truncate(deQuantAux,0)                           
                                                     else deQuantAux.                                      
            if reservas.quant-atend + tt-valida-req.deQuantTotal > deQuantAux then do:                                   
                 /*** Quantidade excede a variacao para requisicao ***/   
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="27712"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="reservas.it-codigo"} 
                 IF AVAIL rowErrors THEN DO:
                     {utp/ut-liter.i Erro_Comp._Concentr/PPM *}
                     ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ": ":U + RowErrors.ErrorDescription.
                     {utp/ut-liter.i Corrija_o_erro_antes_de_tentar_balancear_novamente. *}
                     ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " ":U + RETURN-VALUE.
                 END.
            end.                                                                                           
        end.                                                                                               
    end.
END. /*FOR EACH tt-valida-req*/

IF VALID-HANDLE(h-cpapi029) THEN
    DELETE PROCEDURE h-cpapi029.


IF CAN-FIND(FIRST rowErrors) THEN
    RETURN "NOK":U.

/*Calcula quantos % da qtd original se est† requisitando, para posteriormente recalcular as quantidades te¢ricas dos ve°culos.*/
ASSIGN de-perc-modif = de-soma-qt-requis * 100 / de-total-quant-orig .

if not can-find(first tt-balanceia) then
   return "OK":U.
   
for each tt-veiculos: delete tt-veiculos. end.
FOR EACH tt-erro: DELETE tt-erro. END.

for each tt-balanceia:
    for each b-tt-balanceia where
             b-tt-balanceia.nr-ord-produ  = tt-balanceia.nr-ord-produ and
             b-tt-balanceia.it-codigo     = tt-balanceia.it-codigo    and
             rowid(b-tt-balanceia)       <> rowid(tt-balanceia):
        assign tt-balanceia.quant-requis      = tt-balanceia.quant-requis      + b-tt-balanceia.quant-requis
               tt-balanceia.quant-movto       = tt-balanceia.quant-movto       + b-tt-balanceia.quant-movto.
        delete b-tt-balanceia.
    end.

    if tt-balanceia.quant-requis < 0 then
        assign tt-balanceia.quant-requis      = tt-balanceia.quant-requis      * -1
               tt-balanceia.quant-movto       = tt-balanceia.quant-movto       * -1.
end.

run pi-balanceia-veiculo in h-cpapi020(input-output table tt-balanceia,
                                       input-output table tt-erro,
                                       input        yes,
                                       input-output table tt-veiculos).
IF CAN-FIND(FIRST tt-erro) THEN
    for each tt-erro:
        create RowErrors.
        assign RowErrors.ErrorNumber      = tt-erro.cd-erro
               RowErrors.ErrorType        = "EMS":u
               RowErrors.ErrorSubType     = "ERROR":u
               RowErrors.ErrorDescription = tt-erro.mensagem
               RowErrors.ErrorHelp        = tt-erro.mensagem.
    end.
IF CAN-FIND(FIRST rowErrors) THEN
    RETURN "NOK":U.

/*Efetua a carga dos saldos que ainda n∆o tiverem sido carregados.*/
FOR EACH ttReservas:
    IF NOT AVAIL ord-prod OR ord-prod.nr-ord-produ <> ttReservas.nr-ord-produ THEN
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-ord-produ = ttReservas.nr-ord-produ NO-ERROR.

    run carregaAlocaSaldo(input ttReservas.nr-ord-produ,
                          input ttReservas.item-pai,
                          input ttReservas.cod-roteiro,
                          input ttReservas.op-codigo,
                          input ttReservas.it-codigo,
                          input ttReservas.cod-refer,
                          input ord-prod.cod-estabel,
                          input ttReservas.tipo-formula,
                          input ttReservas.per-ppm,
                          input no,
                          input-output table ttAlocaReserva,
                          input-output table ttSaldoEstoq,
                          input-output table ttSaldoEstoqAux).
END.

FOR EACH tt-veiculos: 

    FIND FIRST ttReservas
         WHERE ttReservas.ROWID = tt-veiculos.rw-reservas NO-ERROR.

    /*Zera todas as ttReqOrd referentes a este veiculo com tipo-trans <> 0, j† ajustando todas as tt auxiliares.*/
    FOR EACH ttReqOrd 
       WHERE ttReqOrd.nr-ord-produ  = tt-veiculos.nr-ord-produ 
         and ttReqOrd.item-pai      = tt-veiculos.item-pai     
         AND ttReqOrd.cod-roteiro   = tt-veiculos.cod-roteiro  
         AND ttReqOrd.op-codigo     = tt-veiculos.op-codigo    
         AND ttReqOrd.it-codigo     = tt-veiculos.it-codigo    
         AND ttReqOrd.cod-refer     = tt-veiculos.cod-refer
         AND ttReqOrd.tipo-trans    <> 0:

            find bTTReqOrd where
                 bTTReqOrd.nr-ord-produ  = ttReqOrd.nr-ord-produ and
                 bTTReqOrd.item-pai      = ttReqOrd.item-pai     and
                 bTTReqOrd.cod-roteiro   = ttReqOrd.cod-roteiro  and
                 bTTReqOrd.op-codigo     = ttReqOrd.op-codigo    and
                 bTTReqOrd.it-codigo     = ttReqOrd.it-codigo    and
                 bTTReqOrd.cod-refer     = ttReqOrd.cod-refer    and
                 bTTReqOrd.cod-estabel   = ttReqOrd.cod-estabel  and
                 bTTReqOrd.cod-depos     = ttReqOrd.cod-depos    and
                 bTTReqOrd.cod-localiz   = ttReqOrd.cod-localiz  and
                 bTTReqOrd.lote-serie    = ttReqOrd.lote-serie   and
                 bTTReqOrd.tipo-trans    = 0 no-error.

            find ttAlocaReserva where
                 ttAlocaReserva.nr-ord-produ = ttReqOrd.nr-ord-produ and
                 ttAlocaReserva.item-pai     = ttReqOrd.item-pai     and
                 ttAlocaReserva.cod-roteiro  = ttReqOrd.cod-roteiro  and
                 ttAlocaReserva.op-codigo    = ttReqOrd.op-codigo    and
                 ttAlocaReserva.it-codigo    = ttReqOrd.it-codigo    and
                 ttAlocaReserva.cod-refer    = ttReqOrd.cod-refer    and
                 ttAlocaReserva.cod-estabel  = ttReqOrd.cod-estabel  and
                 ttAlocaReserva.cod-depos    = ttReqOrd.cod-depos    and
                 ttAlocaReserva.cod-localiz  = ttReqOrd.cod-localiz  and
                 ttAlocaReserva.lote-serie   = ttReqOrd.lote-serie no-error.

            find ttSaldoEstoq where
                 ttSaldoEstoq.cod-estabel = ttReqOrd.cod-estabel and
                 ttSaldoEstoq.cod-depos   = ttReqOrd.cod-depos   and
                 ttSaldoEstoq.cod-localiz = ttReqOrd.cod-localiz and
                 ttSaldoEstoq.lote        = ttReqOrd.lote-serie  and
                 ttSaldoEstoq.it-codigo   = ttReqOrd.it-codigo   and
                 ttSaldoEstoq.cod-refer   = ttReqOrd.cod-refer NO-ERROR.

            IF ttReqOrd.tipo-trans = 1 THEN DO: /*Inclus∆o*/
                
                IF AVAIL ttAlocaReserva AND ttReqOrd.qt-aloc-lote <> 0 THEN DO:
                    /*Subtrai a quantidade alocada das requisiá‰es*/
                    assign TTReqOrd.qt-requis           = TTReqOrd.qt-requis - ttReqOrd.qt-aloc
                           TTReqOrd.qtd-requisitd-lote  = TTReqOrd.qtd-requisitd-lote - ttReqOrd.qt-aloc-lote
                           bTTReqOrd.qt-requis          = bTTReqOrd.qt-requis - ttReqOrd.qt-aloc
                           bTTReqOrd.qtd-requisitd-lote = bTTReqOrd.qtd-requisitd-lote - ttReqOrd.qt-aloc-lote
                           bTTReqOrd.qt-aloc            = bTTReqOrd.qt-aloc - ttReqOrd.qt-aloc    
                           bTTReqOrd.qt-aloc-lote       = bTTReqOrd.qt-aloc-lote - ttReqOrd.qt-aloc-lote
                    /*Devolve as quantidades alocadas*/
                           ttReservas.quant-aloc        = ttReservas.quant-aloc + ttReqOrd.qt-aloc 
                           ttReservas.qt-aloc-lote      = ttReservas.qt-aloc-lote + ttReqOrd.qt-aloc-lote
                           ttAlocaReserva.quant-aloc    = ttAlocaReserva.quant-aloc + ttReqOrd.qt-aloc 
                           ttAlocaReserva.qt-aloc-lote  = ttAlocaReserva.qt-aloc-lote + ttReqOrd.qt-aloc-lote
                    /*Atualiza qt a req e quant-atend*/
                           ttReservas.quant-a-req       = ttReservas.quant-a-req + ttReqOrd.qt-aloc 
                           ttReservas.quant-atend       = ttReservas.quant-atend - ttReqOrd.qt-aloc
                           ttReservas.qt-atend-lote     = ttReservas.qt-atend-lote - ttReqOrd.qt-aloc-lote
                    /*Zera as qt aloc da tt de requisiá∆o*/
                           TTReqOrd.qt-aloc             = 0
                           TTReqOrd.qt-aloc-lote        = 0.
                END.

                /*Se tiver mais quantidade de saldo, sem ser da alocaá∆o, subtrai neste ponto.*/
                IF TTReqOrd.qtd-requisitd-lote <> 0 THEN DO:
                    /*Subtrai a quant-requis do registro de display*/
                    ASSIGN bTTReqOrd.qt-requis          = bTTReqOrd.qt-requis - TTReqOrd.qt-requis         
                           bTTReqOrd.qtd-requisitd-lote = bTTReqOrd.qtd-requisitd-lote - TTReqOrd.qtd-requisitd-lote
                    /*Devolve a quantidade para o saldo estoq*/
                           ttSaldoEstoq.saldo-disp      = ttSaldoEstoq.saldo-disp + TTReqOrd.qt-requis         
                           ttSaldoEstoq.saldo-disp-fis  = ttSaldoEstoq.saldo-disp-fis + TTReqOrd.qtd-requisitd-lote
                           ttSaldoEstoq.qt-fisica       = ttSaldoEstoq.qt-fisica + TTReqOrd.qtd-requisitd-lote
                    /*Atualiza qt a req e quant-atend*/
                           ttReservas.quant-a-req       = ttReservas.quant-a-req + TTReqOrd.qt-requis 
                           ttReservas.quant-atend       = ttReservas.quant-atend - TTReqOrd.qt-requis 
                           ttReservas.qt-atend-lote     = ttReservas.qt-atend-lote - TTReqOrd.qtd-requisitd-lote
                    /*Zera a quant-requis.*/
                           TTReqOrd.qt-requis           = 0
                           TTReqOrd.qtd-requisitd-lote  = 0.
                END.
            END. /*IF ttReqOrd.tipo-trans = 1*/
            ELSE DO:  /*Exclus∆o*/
                IF NOT AVAIL bTTReqOrd THEN DO:
                    CREATE bTTReqOrd.
                    ASSIGN bTTReqOrd.nr-ord-produ  = ttReqOrd.nr-ord-produ
                           bTTReqOrd.item-pai      = ttReqOrd.item-pai    
                           bTTReqOrd.cod-roteiro   = ttReqOrd.cod-roteiro 
                           bTTReqOrd.op-codigo     = ttReqOrd.op-codigo   
                           bTTReqOrd.it-codigo     = ttReqOrd.it-codigo   
                           bTTReqOrd.cod-refer     = ttReqOrd.cod-refer   
                           bTTReqOrd.cod-estabel   = ttReqOrd.cod-estabel 
                           bTTReqOrd.cod-depos     = ttReqOrd.cod-depos   
                           bTTReqOrd.cod-localiz   = ttReqOrd.cod-localiz 
                           bTTReqOrd.lote-serie    = ttReqOrd.lote-serie  
                           bTTReqOrd.tipo-trans    = 0.         
                END.
                /*Subtrai a quant-requis do registro de display*/
                ASSIGN bTTReqOrd.qt-requis          = bTTReqOrd.qt-requis + TTReqOrd.qt-requis    
                       bTTReqOrd.qtd-requisitd-lote = bTTReqOrd.qtd-requisitd-lote + TTReqOrd.qtd-requisitd-lote 
                      
                /*Devolve a quantidade para o saldo estoq*/
                       ttSaldoEstoq.saldo-disp      = ttSaldoEstoq.saldo-disp - TTReqOrd.qt-requis         
                       ttSaldoEstoq.saldo-disp-fis  = ttSaldoEstoq.saldo-disp-fis - TTReqOrd.qtd-requisitd-lote
                       ttSaldoEstoq.qt-fisica       = ttSaldoEstoq.qt-fisica - TTReqOrd.qtd-requisitd-lote
                /*Atualiza qt a req e quant-atend*/
                       ttReservas.quant-a-req       = ttReservas.quant-a-req - TTReqOrd.qt-requis 
                       ttReservas.quant-atend       = ttReservas.quant-atend + TTReqOrd.qt-requis 
                       ttReservas.qt-atend-lote     = ttReservas.qt-atend-lote + TTReqOrd.qtd-requisitd-lote.

            END.
            IF ttReservas.quant-a-req > ttReservas.quant-orig THEN
                ASSIGN ttReservas.quant-a-req = ttReservas.quant-orig.

            IF ttReservas.qt-atend-lote <= 0 THEN
                ASSIGN ttReservas.qt-atend-lote = 0
                       ttReservas.quant-atend   = 0.

    END.
    /*Calcula as quantidades te¢rica e f°sica.*/
    ASSIGN de-quant-a-req-teorica  = ttReservas.quant-orig * de-perc-modif / 100.


    IF de-quant-a-req-teorica < 0 THEN
        ASSIGN de-quant-a-req-teorica = de-quant-a-req-teorica * -1
               l-devolver             = YES.
    ELSE
        ASSIGN l-devolver             = NO.

    ASSIGN de-quant-a-req-fisica   = de-quant-a-req-teorica + tt-veiculos.quant-veiculo
           de-quant-a-req-fis-orig = de-quant-a-req-fisica.

    if de-perc-modif = 0 and de-soma-qt-requis-fis <> 0 then do:

        if de-soma-qt-requis-fis < 0 then
            assign l-devolver = no.
        else
            assign l-devolver = yes.

        assign de-quant-a-req-fisica  = (if tt-veiculos.quant-veiculo < 0 then tt-veiculos.quant-veiculo * -1 else tt-veiculos.quant-veiculo)
               de-quant-a-req-teorica = 0.

    end.                    

    IF l-devolver = NO THEN DO:
        /*Requisitar*/
        /*Com base nas novas quantidades calculadas, efetua a re-criaá∆o das ttReqOrd, buscando primeiro as quantidades alocadas 
          por data vencimento / lote, em seguida as quantidades de saldo, tambÇm por data vencimento / lote.
          Nessa recriaáao, as quantidades das tts auxiliares tambÇm j† ser∆o todas atualizadas devidamente.*/
        for each ttAlocaReserva where                                      
                 ttAlocaReserva.nr-ord-produ = ttReservas.nr-ord-produ and 
                 ttAlocaReserva.item-pai     = ttReservas.item-pai     and 
                 ttAlocaReserva.cod-roteiro  = ttReservas.cod-roteiro  and 
                 ttAlocaReserva.op-codigo    = ttReservas.op-codigo    and 
                 ttAlocaReserva.it-codigo    = ttReservas.it-codigo    and 
                 ttAlocaReserva.cod-refer    = ttReservas.cod-refer    and 
                 ttAlocaReserva.quant-aloc   > 0
            BREAK BY ttAlocaReserva.dt-vali-lote:
            
            if ttAlocaReserva.qt-aloc-lote > de-quant-a-req-fisica then
                assign deQtRequisFis               = de-quant-a-req-fisica
                       deQtRequis                  = de-quant-a-req-teorica
                       de-quant-a-req-fisica       = 0 
                       de-quant-a-req-teorica      = 0.
            ELSE DO:
                ASSIGN deQtRequisFis               = ttAlocaReserva.qt-aloc-lote
                       deQtRequis                  = ttAlocaReserva.quant-aloc
                       de-quant-a-req-fisica       = de-quant-a-req-fisica  - ttAlocaReserva.qt-aloc-lote  
                       de-quant-a-req-teorica      = de-quant-a-req-teorica - ttAlocaReserva.quant-aloc.
                if de-quant-a-req-fisica <= 0.00009 then
                     assign deQtRequis             = deQtRequis + de-quant-a-req-teorica
                            de-quant-a-req-teorica = 0
                            de-quant-a-req-fisica  = 0.
            END.

            IF deQtRequisFis < 0 THEN
                ASSIGN l-veiculo-neg = YES.
    
            /*Cria a ttReqOrd oficial e atualiza a ttReqOrd de display.*/
            ASSIGN r-rowid = fCriaReqOrd (ttAlocaReserva.nr-ord-produ, ttAlocaReserva.item-pai, ttAlocaReserva.cod-roteiro,    
                                          ttAlocaReserva.op-codigo, ttAlocaReserva.it-codigo, ttAlocaReserva.cod-refer,        
                                          ttAlocaReserva.cod-estabel, ttAlocaReserva.cod-depos, ttAlocaReserva.cod-localiz,    
                                          ttAlocaReserva.lote-serie, deQtRequis, deQtRequisFis, deQtRequis, deQtRequisFis,     
                                          ttReservas.per-ppm, ttReservas.tipo-formula).
    
            /*Atualiza as quantidades Alocadas*/
            ASSIGN ttReservas.quant-aloc       = ttReservas.quant-aloc       - deQtRequis
                   ttReservas.qt-aloc-lote     = ttReservas.qt-aloc-lote     - deQtRequisFis
                   ttAlocaReserva.qt-aloc-lote = ttAlocaReserva.qt-aloc-lote - deQtRequisFis   
                   ttAlocaReserva.quant-aloc   = ttAlocaReserva.quant-aloc   - deQtRequis   
            /*Atualiza qt a req e quant-atend*/                                                     
                   ttReservas.quant-a-req       = ttReservas.quant-a-req     - deQtRequis      
                   ttReservas.quant-atend       = ttReservas.quant-atend     + deQtRequis       
                   ttReservas.qt-atend-lote     = ttReservas.qt-atend-lote   + deQtRequisFis.
    
            IF de-quant-a-req-fisica <= 0.00009 then leave. 
    
        END. /*for each ttAlocaReserva where*/

/*         MESSAGE "1 de-quant-a-req-fisica: " de-quant-a-req-fisica */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                    */
    
        IF de-quant-a-req-fisica > 0.00009 THEN DO:
    

            FIND FIRST ttReqOrd
                WHERE ttReqOrd.it-codigo = ttReservas.it-codigo
                AND   ttReqOrd.cod-refer = ttReservas.cod-refer
                AND   ttReqOrd.qt-requis = 0
                NO-LOCK NO-ERROR.
            IF AVAIL ttReqOrd THEN DO:
                ASSIGN c-deposito-balanc = ttReqOrd.cod-depos.
            END.
            ELSE DO:
                FIND FIRST ttSaldoEstoq WHERE
                    ttSaldoEstoq.it-codigo  = ttReservas.it-codigo and
                    ttSaldoEstoq.cod-refer  = ttReservas.cod-refer and
                    ttSaldoEstoq.saldo-disp > 0 no-lock NO-ERROR.
                //ASSIGN c-deposito-balanc = ttSaldoEstoq.cod-depos.
                ASSIGN c-deposito-balanc = IF AVAIL ttSaldoEstoq THEN ttSaldoEstoq.cod-depos ELSE "".
            END.

            for each ttSaldoEstoq where                                                                                                   
                     ttSaldoEstoq.it-codigo  = ttReservas.it-codigo and
                     ttSaldoEstoq.cod-refer  = ttReservas.cod-refer and
                     ttSaldoEstoq.saldo-disp > 0                    AND
                     ttSaldoEstoq.cod-depos  = c-deposito-balanc
                     break by ttSaldoEstoq.dt-vali-lote:  
                                                                                                                                          
                if ttSaldoEstoq.saldo-disp-fis >= de-quant-a-req-fisica THEN DO:                                                             
                    ASSIGN deQtRequisFis               = de-quant-a-req-fisica                                                                  
                           deQtRequis                  = de-quant-a-req-teorica                                                         
                           ttSaldoEstoq.saldo-disp     = ttSaldoEstoq.saldo-disp - deQtRequisFis                                             
                           ttSaldoEstoq.saldo-disp-fis = ttSaldoEstoq.saldo-disp-fis - deQtRequisFis                                      
                           ttSaldoEstoq.qt-fisica      = ttSaldoEstoq.qt-fisica - deQtRequisFis
                           de-quant-a-req-fisica       = 0
                           de-quant-a-req-teorica      = 0.
                END. 
                ELSE DO:                                                                                                                  
                    assign deQtRequis                  = ttSaldoEstoq.saldo-disp-fis                                                         
                           deQtRequisFis               = ttSaldoEstoq.saldo-disp-fis                                                      
                           ttSaldoEstoq.saldo-disp     = 0                                                                                
                           ttSaldoEstoq.saldo-disp-fis = 0   
                           ttSaldoEstoq.qt-fisica      = 0
                           de-quant-a-req-teorica      = de-quant-a-req-teorica - deQtRequis
                           de-quant-a-req-fisica       = de-quant-a-req-fisica  - deQtRequisFis.
                    if de-quant-a-req-fisica <= 0.00009 then
                         assign deQtRequis             = deQtRequis + de-quant-a-req-teorica
                                de-quant-a-req-teorica = 0
                                de-quant-a-req-fisica  = 0.
                END.      
    
                /*Atualiza qt a req e quant-atend*/
                ASSIGN ttReservas.quant-a-req   = ttReservas.quant-a-req     - deQtRequis      
                       ttReservas.quant-atend   = ttReservas.quant-atend     + deQtRequis       
                       ttReservas.qt-atend-lote = ttReservas.qt-atend-lote   + deQtRequisFis.

                IF deQtRequisFis < 0 THEN
                    ASSIGN l-veiculo-neg = YES.
                                                                                                                                          
                ASSIGN r-rowid = fCriaReqOrd (ttReservas.nr-ord-produ, ttReservas.item-pai, ttReservas.cod-roteiro,                                        
                                              ttReservas.op-codigo, ttReservas.it-codigo, ttReservas.cod-refer,                                            
                                              ttSaldoEstoq.cod-estabel, ttSaldoEstoq.cod-depos, ttSaldoEstoq.cod-localiz,                                  
                                              ttSaldoEstoq.lote, deQtRequis, deQtRequisFis, dec(0), dec(0),                                                
                                              ttReservas.per-ppm, ttReservas.tipo-formula).                                                                

/*             MESSAGE "2 de-quant-a-req-fisica: " de-quant-a-req-fisica */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                    */
                                                                                                                                          
                if de-quant-a-req-fisica <= 0.00009 then leave.                                                                          
                                                                                                                                          
            end. /* For each ttSaldoEstoq */  

            FOR EACH ttReqOrd
                WHERE ttReqOrd.qt-requis <= 0.
                DELETE ttReqOrd.
            END.
    
        END. /*IF de-quant-a-req-fisica > 0.00009 */

/*             MESSAGE "3 de-quant-a-req-fisica: " de-quant-a-req-fisica */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                    */
    
        IF de-quant-a-req-fisica > 0.00009 THEN DO:
            assign c-retorno = "34088":U.
            if c-mensagem <> "":U then
                assign c-mensagem = c-mensagem + chr(13).
            assign c-mensagem = c-mensagem 
                                + tt-veiculos.it-codigo + " / ":U 
                                + string(de-quant-a-req-fis-orig,"->>>>>,>>9.9999":U) + " / ":U 
                                + string((de-quant-a-req-fis-orig - de-quant-a-req-fisica),"->>>>>,>>9.9999":U).
        END.
    END. /*requisitar*/
    ELSE DO:
        /*Devolver*/

        /*Como neste ponto poss°veis manipulaá‰es em tela pelo usu†rio j† ter∆o sido estornadas, ent∆o precisar† simplesmente
          criar ttReqOrd com tipo-trans = 2 para a quantidade que se precisa devolver.*/

        for each ttReqOrd where
                 ttReqOrd.nr-ord-produ = ttReservas.nr-ord-produ and
                 ttReqOrd.item-pai     = ttReservas.item-pai     and
                 ttReqOrd.cod-roteiro  = ttReservas.cod-roteiro  and
                 ttReqOrd.op-codigo    = ttReservas.op-codigo    and
               ((ttReqOrd.it-codigo         = ttReservas.it-codigo    and
                 ttReqOrd.cod-refer         = ttReservas.cod-refer) or
                (ttReqOrd.alternativo-de   <> "" and
                 ttReqOrd.alternativo-de    = ttReservas.it-codigo and
                 ttReqOrd.cod-refer-it-original = ttReservas.cod-refer))  and
                 ttReqOrd.tipo-trans        = 0:

            find ttSaldoEstoq where
                 ttSaldoEstoq.cod-estabel = ttReqOrd.cod-estabel and
                 ttSaldoEstoq.cod-depos   = ttReqOrd.cod-depos   and
                 ttSaldoEstoq.cod-localiz = ttReqOrd.cod-localiz and
                 ttSaldoEstoq.lote        = ttReqOrd.lote-serie  and
                 ttSaldoEstoq.it-codigo   = ttReqOrd.it-codigo   and
                 ttSaldoEstoq.cod-refer   = ttReqOrd.cod-refer NO-ERROR.

            if ttReqOrd.qtd-requisitd-lote > 0 then do:

                IF ttReqOrd.qtd-requisitd-lote <= de-quant-a-req-fisica THEN DO:

                    find bTTReqOrd where
                         bTTReqOrd.nr-ord-produ  = ttReqOrd.nr-ord-produ and
                         bTTReqOrd.item-pai      = ttReqOrd.item-pai     and
                         bTTReqOrd.cod-roteiro   = ttReqOrd.cod-roteiro  and
                         bTTReqOrd.op-codigo     = ttReqOrd.op-codigo    and
                         bTTReqOrd.it-codigo     = ttReqOrd.it-codigo    and
                         bTTReqOrd.cod-refer     = ttReqOrd.cod-refer    and
                         bTTReqOrd.cod-estabel   = ttReqOrd.cod-estabel  and
                         bTTReqOrd.cod-depos     = ttReqOrd.cod-depos    and
                         bTTReqOrd.cod-localiz   = ttReqOrd.cod-localiz  and
                         bTTReqOrd.lote-serie    = ttReqOrd.lote-serie   and
                         bTTReqOrd.tipo-trans    = 2 no-error.
                    IF AVAIL bTTReqOrd THEN DELETE bTTReqOrd.


                    assign ttReqOrd.tipo-trans         = 2 /* Devolve */
                           ttReqOrd.per-ppm            = ttReservas.per-ppm
                           ttReqOrd.tipo-formula       = ttReservas.tipo-formula
                    /*subtrai esta requisicao da qtd a devolver*/
                           de-quant-a-req-fisica       = de-quant-a-req-fisica  - ttReqOrd.qtd-requisitd-lote
                           de-quant-a-req-teorica      = de-quant-a-req-teorica - ttReqOrd.qt-requis
                    /*atualiza dos dados da ttReservas*/
                           ttReservas.quant-a-req      = ttReservas.quant-a-req + ttReqOrd.qt-requis
                           ttReservas.quant-atend      = ttReservas.quant-atend - ttReqOrd.qt-requis
                           ttReservas.qt-atend-lote    = ttReservas.qt-atend-lote - ttReqOrd.qtd-requisitd-lote.
                    /*atualiza o saldo*/
                    IF AVAIL ttSaldoEstoq
                    THEN DO:
                        ASSIGN
                           ttSaldoEstoq.saldo-disp     = ttSaldoEstoq.saldo-disp + ttReqOrd.qtd-requisitd-lote 
                           ttSaldoEstoq.saldo-disp-fis = ttSaldoEstoq.saldo-disp-fis + ttReqOrd.qtd-requisitd-lote
                           ttSaldoEstoq.qt-fisica      = ttSaldoEstoq.qt-fisica + ttReqOrd.qtd-requisitd-lote.
                    END.
                    if de-quant-a-req-fisica <= 0.00009 then                                
                         assign ttReservas.quant-a-req = ttReservas.quant-a-req + de-quant-a-req-teorica
                                ttReservas.quant-atend = ttReservas.quant-atend - de-quant-a-req-teorica
                                de-quant-a-req-teorica = 0                                  
                                de-quant-a-req-fisica  = 0.

                END.
                ELSE DO:

                    find bTTReqOrd where
                         bTTReqOrd.nr-ord-produ  = ttReqOrd.nr-ord-produ and
                         bTTReqOrd.item-pai      = ttReqOrd.item-pai     and
                         bTTReqOrd.cod-roteiro   = ttReqOrd.cod-roteiro  and
                         bTTReqOrd.op-codigo     = ttReqOrd.op-codigo    and
                         bTTReqOrd.it-codigo     = ttReqOrd.it-codigo    and
                         bTTReqOrd.cod-refer     = ttReqOrd.cod-refer    and
                         bTTReqOrd.cod-estabel   = ttReqOrd.cod-estabel  and
                         bTTReqOrd.cod-depos     = ttReqOrd.cod-depos    and
                         bTTReqOrd.cod-localiz   = ttReqOrd.cod-localiz  and
                         bTTReqOrd.lote-serie    = ttReqOrd.lote-serie   and
                         bTTReqOrd.tipo-trans    = 2 no-error.
                    IF AVAIL bTTReqOrd THEN DELETE bTTReqOrd.

                    CREATE bTTReqOrd.
                    BUFFER-COPY ttReqOrd EXCEPT tipo-trans log-requisitado TO bTTReqOrd
                        ASSIGN bTTReqOrd.tipo-trans         = 2 /* Devolve */
                               bTTReqOrd.per-ppm            = ttReservas.per-ppm        
                               bTTReqOrd.tipo-formula       = ttReservas.tipo-formula   
                        /*Est† devolvendo o restante que est† nas vari†veis.*/
                               bTTReqOrd.qtd-requisitd-lote = de-quant-a-req-fisica
                               bTTReqOrd.qt-requis          = de-quant-a-req-teorica
                        /*subtrai o que est† devolvendo da tt de display*/
                               TTReqOrd.qtd-requisitd-lote   = TTReqOrd.qtd-requisitd-lote - de-quant-a-req-fisica
                               TTReqOrd.qt-requis            = TTReqOrd.qt-requis          - de-quant-a-req-teorica.
                        /*soma ao saldo as quantidades*/
                        IF AVAIL ttSaldoEstoq
                        THEN DO:
                            ASSIGN
                               ttSaldoEstoq.saldo-disp       = ttSaldoEstoq.saldo-disp + de-quant-a-req-fisica  
                               ttSaldoEstoq.saldo-disp-fis   = ttSaldoEstoq.saldo-disp-fis + de-quant-a-req-fisica
                               ttSaldoEstoq.qt-fisica        = ttSaldoEstoq.qt-fisica + de-quant-a-req-fisica.
                        END.
                        /*Atualiza o registro da ttReservas*/
                        ASSIGN ttReservas.quant-a-req        = ttReservas.quant-a-req + de-quant-a-req-teorica
                               ttReservas.quant-atend        = ttReservas.quant-atend - de-quant-a-req-teorica
                               ttReservas.qt-atend-lote      = ttReservas.qt-atend-lote - de-quant-a-req-fisica
                        /*zera as quantidades a requisitar*/
                               de-quant-a-req-fisica         = 0
                               de-quant-a-req-teorica        = 0.
                END.
            end. /*if ttReqOrd.qtd-requisitd-lote > 0*/

            IF de-quant-a-req-fisica <= 0.00009 THEN
                LEAVE.
        end. /*for each ttReqOrd where*/
    END. /*devolver*/
END. /*FOR EACH tt-veiculos*/

assign l-veiculo-neg = no.
for each ttReqOrd:

    if ttReqOrd.qtd-requisitd-lote < 0 and
       ttReqOrd.tipo-trans = 0 then do:
        {method/svc/errors/inserr.i  &ErrorNumber="34166"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="ttReqOrd.it-codigo"} 
                        
             assign l-veiculo-neg = yes.
    end.

end.
if l-veiculo-neg then
     return "NOK":U.

if c-retorno = "34088":U THEN DO:
    assign c-retorno = c-retorno + "|":U + c-mensagem.
    RETURN c-retorno.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaReqAltern DBOFunction 
PROCEDURE carregaReqAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pNrOrdProd as int no-undo.
def input-output param table for ttReqAltern.

for each req-altern where req-altern.nr-ord-produ = pNrOrdProd no-lock:

    if can-find(first ttReqAltern where ttReqAltern.nr-ord-produ = req-altern.nr-ord-produ and
                                        ttReqAltern.item-pai    = req-altern.item-pai and
                                        ttReqAltern.it-codigo   = req-altern.it-codigo and
                                        ttReqAltern.cod-refer   = req-altern.cod-refer and
                                        ttReqAltern.cod-roteiro = req-altern.cod-roteiro and
                                        ttReqAltern.op-codigo   = req-altern.op-codigo and
                                        ttReqAltern.al-codigo   = req-altern.al-codigo and
                                        ttReqAltern.nr-trans    = req-altern.nr-trans) then
        next.

    find first movto-estoq where movto-estoq.nr-trans = req-altern.nr-trans no-lock no-error.

    create ttReqAltern.
    buffer-copy req-altern to ttReqAltern.
    assign ttReqAltern.tipo-trans = 0
           ttReqAltern.qt-movto-teorico = ttReqAltern.qt-atend * ttReqAltern.qt-movto / ttReqAltern.qt-atend-lote
           ttReqAltern.lote-serie             = movto-estoq.lote
           ttReqAltern.cod-depos        = movto-estoq.cod-depos
           ttReqAltern.cod-localiz      = movto-estoq.cod-localiz
           ttReqAltern.per-ppm-alt      = movto-estoq.per-ppm.

end.

return 'ok':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaSaldoReqAltern DBOFunction 
PROCEDURE carregaSaldoReqAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output param table for ttReqAltern.
def input-output param table for ttAlocaReserva.
def input-output param table for ttSaldoEstoq.
def input-output param table for ttSaldoEstoqAux.

find first param-global no-lock no-error.

for each ttReqAltern:

    find first movto-estoq where movto-estoq.nr-trans = ttReqAltern.nr-trans no-lock no-error.
    if avail movto-estoq then do:

        find first saldo-estoq no-lock where saldo-estoq.cod-depos   = movto-estoq.cod-depos and
                                             saldo-estoq.cod-estabel = movto-estoq.cod-estabel and
                                             saldo-estoq.cod-localiz = movto-estoq.cod-localiz and
                                             saldo-estoq.lote        = movto-estoq.lote and
                                             saldo-estoq.it-codigo   = movto-estoq.it-codigo and
                                             saldo-estoq.cod-refer   = movto-estoq.cod-refer no-error.
        if avail saldo-estoq then do:
            if can-find(first ttSaldoEstoq where ttSaldoEstoq.it-codigo   = saldo-estoq.it-codigo and
                                                 ttSaldoEstoq.cod-estabel = saldo-estoq.cod-estabel and
                                                 ttSaldoEstoq.cod-refer   = saldo-estoq.cod-refer and
                                                 ttSaldoEstoq.lote        = saldo-estoq.lote and
                                                 ttSaldoEstoq.cod-depos   = saldo-estoq.cod-depos and
                                                 ttSaldoEstoq.cod-localiz = saldo-estoq.cod-localiz) then
                next.  
        end.

        find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.

        if not (param-global.modulo-per-ppm and
                item.tipo-formula >= 2      and
                item.tipo-formula <= 3) then do:   
    
            create ttSaldoEstoq.
            buffer-copy saldo-estoq to ttSaldoEstoq 
            assign ttSaldoEstoq.rowid               = rowid(saldo-estoq)
                   ttSaldoEstoq.log-disp            = (saldo-estoq.qtidade-atu > 0)
                   ttSaldoEstoq.saldo-disp          = saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + 
                                                                                 saldo-estoq.qt-aloc-ped  + 
                                                                                 saldo-estoq.qt-alocada)
                   ttSaldoEstoq.tipo-formula        = item.tipo-formula
                   ttSaldoEstoq.qt-aloc-prod-fis    = ttSaldoEstoq.qt-aloc-prod
                   ttSaldoEstoq.qtidade-atu-fis     = ttSaldoEstoq.qtidade-atu 
                   ttSaldoEstoq.saldo-disp-fis      = ttSaldoEstoq.saldo-disp
                   ttSaldoEstoq.log-alternativo     = yes
                   ttSaldoEstoq.alternativo-de      = ttReqAltern.it-codigo
                   ttSaldoEstoq.cod-refer-it-orig   = ttReqAltern.cod-refer. 
    
        end.
        else do:

            find first alternativo where alternativo.it-codigo = ttReservas.item-pai and
                                         alternativo.al-codigo = ttReqAltern.al-codigo no-lock no-error.
            find first estrutura where estrutura.it-codigo   = ttReservas.item-pai and
                                  estrutura.es-codigo   = ttReqAltern.it-codigo and
                                  estrutura.sequencia   = alternativo.sequencia and
                                  estrutura.op-codigo   = ttReservas.op-codigo and
                                  estrutura.cod-roteiro = ttReservas.cod-roteiro no-lock no-error.

            create ttSaldoEstoq.
            buffer-copy saldo-estoq except saldo-estoq.qt-aloc-prod saldo-estoq.qtidade-atu to ttSaldoEstoq 
            assign ttSaldoEstoq.rowid               = rowid(saldo-estoq)
                   ttSaldoEstoq.log-disp            = (saldo-estoq.qtidade-atu > 0).
            assign ttSaldoEstoq.qt-aloc-prod        = f-conv-qtde(saldo-estoq.qt-aloc-prod,
                                                                  saldo-estoq.per-ppm,
                                                                  item.per-ppm)
                   ttSaldoEstoq.qtidade-atu         = f-conv-qtde(saldo-estoq.qtidade-atu,
                                                                  saldo-estoq.per-ppm,
                                                                  item.per-ppm)
                   ttSaldoEstoq.saldo-disp          = f-conv-qtde(saldo-estoq.qtidade-atu - 
                                                                 (saldo-estoq.qt-aloc-prod + 
                                                                  saldo-estoq.qt-aloc-ped  + 
                                                                  saldo-estoq.qt-alocada),
                                                                  saldo-estoq.per-ppm,
                                                                  item.per-ppm)
                   ttSaldoEstoq.tipo-formula        = item.tipo-formula
                   /*Projeto 346 - Controle de Potºncia - Campos em quantidade F≠sica, 
                     para exibiªío em tela.*/                                          
                   ttSaldoEstoq.qt-aloc-prod-fis    = saldo-estoq.qt-aloc-prod           
                   ttSaldoEstoq.qtidade-atu-fis     = saldo-estoq.qtidade-atu            
                   ttSaldoEstoq.saldo-disp-fis      = saldo-estoq.qtidade-atu -          
                                                     (saldo-estoq.qt-aloc-prod +         
                                                      saldo-estoq.qt-aloc-ped  +         
                                                      saldo-estoq.qt-alocada)
                   ttSaldoEstoq.log-alternativo     = yes
                   ttSaldoEstoq.alternativo-de      = ttReqAltern.it-codigo
                   ttSaldoEstoq.cod-refer-it-orig   = ttReqAltern.cod-refer
                   ttSaldoEstoq.alt-quant-usada     = if avail alternativo then alternativo.quant-usada else 0
                   ttSaldoEstoq.alt-quant-origem    = if avail estrutura then estrutura.quant-usada else 0
                   ttSaldoEstoq.alt-qtd-item-estrut = if avail estrutura then estrutura.qtd-item else 0.

        end.

        if item.tipo-formula = 2 or
           item.tipo-formula = 3 then do:
            find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
    
            assign ttSaldoEstoq.qt-fisica = fn-calcula-qt-fisica(ttSaldoEstoq.saldo-disp,
                                                                 item.per-ppm,
                                                                 ttSaldoEstoq.per-ppm).
        end.
        else
            assign ttSaldoEstoq.qt-fisica = ttSaldoEstoq.saldo-disp.

        run carregaAlocaSaldoAux(input "SaldoEstoq":U,
                                 input yes,
                                 input item.tipo-formula).
    
        
    end.
        
end.

return 'ok':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCriaReqOrd DBOFunction 
FUNCTION fCriaReqOrd RETURNS ROWID
  ( pNrOrdProdu   as int,
    pItemPai      as char,
    pCodRoteiro   as char, 
    pOpCodigo     as int,  
    pItCodigo     as char, 
    pCodRefer     as char, 
    pCodEstabel   as char, 
    pCodDepos     as char, 
    pCodLocaliz   as char, 
    pLoteSerie    as char, 
    pQtRequis     as dec,  
    pQtRequisLote AS DEC,
    pQtAloc       as dec,
    pQtAlocLote   AS DEC,
    pPerPpm       as dec,
    pTipoFormula  as int):

    def buffer bTTReqOrd  for ttReqOrd.
    def buffer b2TTReqOrd for ttReqOrd.

    /*** Atualiza o Display em tela (Sumariado) ***/
    find b2TTReqOrd where 
         b2TTReqOrd.nr-ord-produ = pNrOrdProdu  and
         b2TTReqOrd.item-pai     = pItemPai     and
         b2TTReqOrd.cod-roteiro  = pCodRoteiro  and
         b2TTReqOrd.op-codigo    = pOpCodigo    and
         b2TTReqOrd.it-codigo    = pItCodigo    and
         b2TTReqOrd.cod-refer    = pCodRefer    and
         b2TTReqOrd.cod-estabel  = pCodEstabel  and
         b2TTReqOrd.cod-depos    = pCodDepos    and
         b2TTReqOrd.cod-localiz  = pCodLocaliz  and
         b2TTReqOrd.lote-serie   = pLoteSerie   and
         b2TTReqOrd.tipo-trans   = 0 no-error.

    if avail b2TTReqOrd then
        assign b2TTReqOrd.qt-requis          = b2TTReqOrd.qt-requis + pQtRequis
               b2TTReqOrd.qtd-requisitd-lote = b2TTReqOrd.qtd-requisitd-lote + pQtRequisLote.
    else do:

        create b2TTReqOrd.
        assign b2TTReqOrd.nr-ord-produ       = pNrOrdProdu
               b2TTReqOrd.item-pai           = pItemPai
               b2TTReqOrd.cod-roteiro        = pCodRoteiro
               b2TTReqOrd.op-codigo          = pOpCodigo
               b2TTReqOrd.it-codigo          = pItCodigo
               b2TTReqOrd.cod-refer          = pCodRefer
               b2TTReqOrd.cod-estabel        = pCodEstabel
               b2TTReqOrd.cod-depos          = pCodDepos
               b2TTReqOrd.cod-localiz        = pCodLocaliz
               b2TTReqOrd.lote-serie         = pLoteSerie
               b2TTReqOrd.qt-requis          = pQtRequis
               b2TTReqOrd.qtd-requisitd-lote = pQtRequisLote
               b2TTReqOrd.per-ppm            = pPerPpm
               b2TTReqOrd.tipo-formula       = pTipoFormula
               b2TTReqOrd.tipo-trans         = 0 /* Display */
               b2TTReqOrd.dt-saida           = ?.
    end.

    /*** Atualiza por Tipo ***/
    find bTTReqOrd where 
         bTTReqOrd.nr-ord-produ = pNrOrdProdu  and
         bTTReqOrd.item-pai     = pItemPai     and
         bTTReqOrd.cod-roteiro  = pCodRoteiro  and
         bTTReqOrd.op-codigo    = pOpCodigo    and
         bTTReqOrd.it-codigo    = pItCodigo    and
         bTTReqOrd.cod-refer    = pCodRefer    and
         bTTReqOrd.cod-estabel  = pCodEstabel  and
         bTTReqOrd.cod-depos    = pCodDepos    and
         bTTReqOrd.cod-localiz  = pCodLocaliz  and
         bTTReqOrd.lote-serie   = pLoteSerie   and
         bTTReqOrd.tipo-trans   <> 0 no-error.

    if avail bTTReqOrd then do:

        if bTTReqOrd.tipo-trans = 1 THEN /*Requisita  = 1*/
            assign bTTReqOrd.qt-requis          = bTTReqOrd.qt-requis + pQtRequis
                   bTTReqOrd.qtd-requisitd-lote = bTTReqOrd.qtd-requisitd-lote + pQtRequisLote
                   bTTReqOrd.qt-aloc            = bTTReqOrd.qt-aloc   + pQtAloc
                   bTTReqOrd.qt-aloc-lote       = bTTReqOrd.qt-aloc-lote   + pQtAlocLote.
        else do:                        
                                        /*Devolve  = 2*/
            if pQtRequis = bTTReqOrd.qt-requis then
                delete bTTReqOrd.
            else 
                if pQtRequis > bTTReqOrd.qt-requis then
                    assign bTTReqOrd.qt-requis          = pQtRequis - bTTReqOrd.qt-requis
                           bTTReqOrd.qtd-requisitd-lote = pQtRequisLote - bTTReqOrd.qtd-requisitd-lote
                           bTTReqOrd.qt-aloc            = if (pQtAloc - bTTReqOrd.qt-requis) > 0 then (pQtAloc - bTTReqOrd.qt-requis)
                                                                                                 else 0
                           bTTReqOrd.qt-aloc-lote       = if (pQtAlocLote - bTTReqOrd.qtd-requisitd-lote) > 0
                                                            then (pQtAlocLote - bTTReqOrd.qtd-requisitd-lote) else 0 
                           bTTReqOrd.tipo-trans         = 1. /*Muda para Requisita*/
                else
                    assign bTTReqOrd.qt-requis          = bTTReqOrd.qt-requis - pQtRequis
                           bTTReqOrd.qtd-requisitd-lote = bTTReqOrd.qtd-requisitd-lote - pQtRequisLote.
        end.
    end.
    else do:

        create bTTReqOrd.
        assign bTTReqOrd.nr-ord-produ       = pNrOrdProdu 
               bTTReqOrd.item-pai           = pItemPai
               bTTReqOrd.cod-roteiro        = pCodRoteiro
               bTTReqOrd.op-codigo          = pOpCodigo
               bTTReqOrd.it-codigo          = pItCodigo
               bTTReqOrd.cod-refer          = pCodRefer
               bTTReqOrd.cod-estabel        = pCodEstabel
               bTTReqOrd.cod-depos          = pCodDepos
               bTTReqOrd.cod-localiz        = pCodLocaliz
               bTTReqOrd.lote-serie         = pLoteSerie
               bTTReqOrd.qt-requis          = pQtRequis
               bTTReqOrd.qtd-requisitd-lote = pQtRequisLote
               bTTReqOrd.qt-aloc            = pQtAloc
               bTTReqOrd.qt-aloc-lote       = pQtAlocLote
               bTTReqOrd.per-ppm            = pPerPpm
               bTTReqOrd.tipo-formula       = pTipoFormula
               bTTReqOrd.tipo-trans         = 1 /* Adiciona */
               bTTReqOrd.dt-saida           = b2TTReqOrd.dt-saida.
    end.

    return rowid(bTTReqOrd).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-calcula-qt-fisica DBOFunction 
FUNCTION fn-calcula-qt-fisica RETURNS decimal
  ( input de-qt-teorica as dec, 
    input de-item-ppm as dec, 
    input de-saldo-per-ppm as dec) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    return round(((de-qt-teorica * de-item-ppm) / de-saldo-per-ppm),4).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

