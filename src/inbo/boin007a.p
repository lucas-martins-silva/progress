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
{include/i-prgvrs.i BOIN007A 2.00.00.018 } /*** "010018" 17/06/2025 16:40:41 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin007a MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN007A
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName aloca-reserva
&GLOBAL-DEFINE TableLabel 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin007a.i RowObject}

{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

{inbo/boin007a.i1} /* Defini‡Æo das temp-tables   */
{cpp/cpapi013.i14} /* Defini‡Æo da ttAlocaReserva */
DEF TEMP-TABLE ttAlocaReservaAux NO-UNDO LIKE ttAlocaReserva.

{cpp/cpapi013.i} /* Defini‡Æo das temp-tables da api */
{cdp/cd0666.i}   /* Defini‡Æo da tt-erro */
{include/i-epc200.i BOIN007A}

&IF DEFINED (bf_man_per_ppm) &THEN
    {cpp/cpapi020.i}
    {cpp/cpapi020.i1} /* Defini‡Æo das fun‡äes do Fator de Concentra‡Æo */
&ENDIF

def var hCpapi013 as handle no-undo.

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
         HEIGHT             = 21.04
         WIDTH              = 43.57.
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

find first param-global no-lock.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmaAlocacao DBOFunction 
PROCEDURE confirmaAlocacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param table for ttAlocaReserva.

    find first ttAlocaReserva where
               ttAlocaReserva.estado > 0 no-error.
    if avail ttAlocaReserva then do:

        run pi-aloca-manual in hCpapi013 (input        table ttAlocaReserva,
                                          input-output table tt-erro).
        
        if return-value = "nok":U then do:
            
            for each tt-erro:
                create RowErrors.
                assign RowErrors.ErrorNumber      = tt-erro.cd-erro
                       RowErrors.ErrorType        = "EMS":u
                       RowErrors.ErrorSubType     = "ERROR":u
                       RowErrors.ErrorDescription = tt-erro.mensagem
                       RowErrors.ErrorHelp        = tt-erro.mensagem.
                DELETE tt-erro.
            end.
        
            RETURN "NOK":U.
        end.
        
    end.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTAlocaReserva DBOFunction 
PROCEDURE criaTTAlocaReserva :
/*------------------------------------------------------------------------------
  Purpose:     cria ttAlocaReserva recebendo os parƒmetros das reservas.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

def input param pNrOrdProdu as int  no-undo.
def input param pItemPai    as char no-undo.
def input param pCodRoteiro as char no-undo.
def input param pOpCodigo   as int  no-undo.
def input param pItCodigo   as char no-undo.
&IF DEFINED (bf_man_sfc_lc) &THEN
    def input param pCodRefer as char no-undo.
&ENDIF
def input-output param table for ttAlocaReserva.

for each ttAlocaReserva where
         ttAlocaReserva.nr-ord-produ = pNrOrdProdu and
         ttAlocaReserva.item-pai     = pItemPai    and
         ttAlocaReserva.cod-roteiro  = pCodRoteiro and
         ttAlocaReserva.op-codigo    = pOpCodigo   and
         ttAlocaReserva.it-codigo    = pItCodigo
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and ttAlocaReserva.cod-refer    = pCodRefer
     &ENDIF
         :
    delete ttAlocaReserva.
end.

for each aloca-reserva NO-LOCK where
         aloca-reserva.nr-ord-produ = pNrOrdProdu and
         aloca-reserva.item-pai     = pItemPai    and
         aloca-reserva.cod-roteiro  = pCodRoteiro and
         aloca-reserva.op-codigo    = pOpCodigo   and
         aloca-reserva.it-codigo    = pItCodigo
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and aloca-reserva.cod-refer = pCodRefer
     &ENDIF 
         :     

    create ttAlocaReserva.
    buffer-copy aloca-reserva to ttAlocaReserva
        assign ttAlocaReserva.rowid  = rowid(aloca-reserva)
               ttAlocaReserva.estado = 0.
    
    FOR FIRST saldo-estoq FIELDS(dt-vali-lote)
                          WHERE saldo-estoq.cod-depos   = aloca-reserva.cod-depos  
                            AND saldo-estoq.cod-estabel = aloca-reserva.cod-estabel
                            AND saldo-estoq.cod-localiz = aloca-reserva.cod-localiz
                            AND saldo-estoq.lote        = aloca-reserva.lote-serie    
                            AND saldo-estoq.it-codigo   = aloca-reserva.it-codigo  
                            AND saldo-estoq.cod-refer   = aloca-reserva.cod-refer NO-LOCK:
        assign ttAlocaReserva.dt-vali-lote = saldo-estoq.dt-vali-lote.
    END.
    
    
    
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTAlocaReserva2 DBOFunction 
PROCEDURE criaTTAlocaReserva2 :
/*------------------------------------------------------------------------------
  Purpose:     Cria ttAlocaReserva recebendo os parƒmetros do saldo-estoq.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

def input param pCodEstabel as char no-undo.
def input param pCodDepos   as char no-undo.
def input param pCodLocaliz as char no-undo.
def input param pLote       as char no-undo.
def input param pItCodigo   as char no-undo.
&IF DEFINED (bf_man_sfc_lc) &THEN
    def input param pCodRefer as char no-undo.
&ENDIF
def input-output param table for ttAlocaReserva.

for each ttAlocaReserva where
         ttAlocaReserva.cod-estabel = pCodEstabel and
         ttAlocaReserva.cod-depos   = pCodDepos   and
         ttAlocaReserva.cod-localiz = pCodLocaliz and
         ttAlocaReserva.lote-serie        = pLote       and
         ttAlocaReserva.it-codigo   = pItCodigo
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and ttAlocaReserva.cod-refer    = pCodRefer
     &ENDIF
         :
    delete ttAlocaReserva.
end.

for each aloca-reserva NO-LOCK where
         aloca-reserva.cod-estabel = pCodEstabel and
         aloca-reserva.cod-depos   = pCodDepos   and
         aloca-reserva.cod-localiz = pCodLocaliz and
         aloca-reserva.lote-serie        = pLote       and
         aloca-reserva.it-codigo   = pItCodigo
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and aloca-reserva.cod-refer = pCodRefer
     &ENDIF 
         :     

    create ttAlocaReserva.
    buffer-copy aloca-reserva to ttAlocaReserva
        assign ttAlocaReserva.rowid  = rowid(aloca-reserva)
               ttAlocaReserva.estado = 0.
    
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTReservas DBOFunction 
PROCEDURE criaTTReservas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pNrOrdProdu as int no-undo.
def output param table for ttReservas.

&IF integer(entry(1,proversion,".")) >= 9 &THEN
    EMPTY TEMP-TABLE ttReservas.
&ELSE
    for each ttReservas:
        delete ttReservas.
    end.
&ENDIF

for each reservas no-lock where
         reservas.nr-ord-produ = pNrOrdProdu and
         reservas.estado       = 1:
    
    if reservas.quant-orig < 0 then next. /** Somente as reservas positivas **/
    
    for first item fields (item.tipo-con-est desc-item) no-lock where
              item.it-codigo = reservas.it-codigo:
    end.
    
    create ttReservas.
    buffer-copy reservas to ttReservas
        assign ttReservas.rowid        = rowid(reservas)
               ttReservas.modifica     = no
               ttReservas.tipo-con-est = item.tipo-con-est
               ttReservas.quant-falta  = reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc
               ttReservas.desc-item    = item.desc-item.
       
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTSaldoEstoq DBOFunction 
PROCEDURE criaTTSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pItCodigo   as char no-undo.
def input param pCodEstabel as char no-undo.
&IF DEFINED (bf_man_sfc_lc) &THEN
    def input param pCodRefer as char no-undo.
&ENDIF
&IF DEFINED (bf_man_per_ppm) &THEN
    def input param pTipoFormula as int no-undo.
    def input param pPerPpm      as dec no-undo.
&ENDIF
def input-output param table for ttSaldoEstoq.

DEFINE  VARIABLE    lDepFechado AS  LOGICAL NO-UNDO INITIAL NO.

for each ttSaldoEstoq where
         ttSaldoEstoq.it-codigo   = pItCodigo and
         ttSaldoEstoq.cod-estabel = pCodEstabel
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and ttSaldoEstoq.cod-refer = pCodRefer
     &ENDIF
         :
    delete ttSaldoEstoq.
end.
find first item where item.it-codigo = pItCodigo no-lock no-error.

//Validacao Deposito Fechado.
FIND    FIRST   param-estoq NO-LOCK NO-ERROR.
IF  AVAIL   param-estoq THEN
    ASSIGN  lDepFechado =   SUBSTRING(param-estoq.char-2,116,1) = "S" OR
                            SUBSTRING(param-estoq.char-2,115,1) = "S".

DEFINE VARIABLE cCodDeposito AS CHARACTER   NO-UNDO.
ASSIGN cCodDeposito = ?.
for each saldo-estoq no-lock where
         saldo-estoq.it-codigo   = pItCodigo and
         saldo-estoq.cod-estabel = pCodEstabel
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and saldo-estoq.cod-refer = pCodRefer
     &ENDIF 
         :

    IF (cCodDeposito <> saldo-estoq.cod-depos)
    THEN DO:
        FOR FIRST deposito fields (deposito.alocado deposito.ind-dep-cq 
                                   deposito.ind-dep-rej deposito.ind-tipo-dep
                                   &IF "{&mgscm_version}" >= "2.05" &THEN
                                    deposito.log-gera-wms
                                   &ELSE
                                    deposito.log-2
                                   &ENDIF
                                   ) NO-LOCK 
                WHERE deposito.cod-depos = saldo-estoq.cod-depos:
            ASSIGN cCodDeposito = saldo-estoq.cod-depos.
        END.
    END.

    if deposito.alocado
    AND (deposito.ind-tipo-dep = 1 OR NOT (deposito.ind-tipo-dep = 2 AND lDepFechado))
    AND NOT deposito.ind-dep-cq
    AND NOT deposito.ind-dep-rej
    THEN DO:

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        assign l-retorno = yes.

        if l-lote-avancado and
           avail item and
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
      &endif

        &IF DEFINED (bf_man_per_ppm) &THEN /*205*/
            if not (param-global.modulo-per-ppm and
                    pTipoFormula >= 2           and
                    pTipoFormula <= 3) then do:
                create ttSaldoEstoq.
                buffer-copy saldo-estoq to ttSaldoEstoq 
                    assign ttSaldoEstoq.rowid      = rowid(saldo-estoq)
                           ttSaldoEstoq.modifica   = no.

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                if l-lote-avancado and
                   not l-retorno then
                    assign ttSaldoEstoq.saldo-disp       = 0
                           ttSaldoEstoq.qt-aloc-prod-fis = 0
                           ttSaldoEstoq.qtidade-atu-fis  = 0
                           ttSaldoEstoq.saldo-disp-fis   = 0
                           ttSaldoEstoq.qtidade-atu      = 0
                           ttSaldoEstoq.qt-aloc-prod     = 0.
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
                    assign ttSaldoEstoq.modifica     = no
                           ttSaldoEstoq.rowid        = rowid(saldo-estoq).

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                if l-lote-avancado and
                   not l-retorno then
                    assign ttSaldoEstoq.saldo-disp       = 0
                           ttSaldoEstoq.saldo-disp-fis   = 0
                           ttSaldoEstoq.qt-aloc-prod     = 0
                           ttSaldoEstoq.qt-aloc-prod-fis = 0
                           ttSaldoEstoq.qtidade-atu      = 0
                           ttSaldoEstoq.qtidade-atu-fis  = 0.
                else
              &endif

                assign ttSaldoEstoq.saldo-disp       = f-conv-qtde(saldo-estoq.qtidade-atu - 
                                                                  (saldo-estoq.qt-aloc-prod + 
                                                                   saldo-estoq.qt-aloc-ped  + 
                                                                   saldo-estoq.qt-alocada),
                                                                   saldo-estoq.per-ppm,
                                                                   pPerPpm)
                       ttSaldoEstoq.saldo-disp-fis   = saldo-estoq.qtidade-atu - 
                                                      (saldo-estoq.qt-aloc-prod + 
                                                       saldo-estoq.qt-aloc-ped  + 
                                                       saldo-estoq.qt-alocada)
                       ttSaldoEstoq.qt-aloc-prod     = f-conv-qtde(saldo-estoq.qt-aloc-prod,
                                                                   saldo-estoq.per-ppm,
                                                                   pPerPpm)
                       ttSaldoEstoq.qtidade-atu      = f-conv-qtde(saldo-estoq.qtidade-atu,
                                                                   saldo-estoq.per-ppm,
                                                                   pPerPpm)                           
                       ttSaldoEstoq.qt-aloc-prod-fis = saldo-estoq.qt-aloc-prod
                       ttSaldoEstoq.qtidade-atu-fis  = saldo-estoq.qtidade-atu.
            end.
        &ELSE
            create ttSaldoEstoq.
            buffer-copy saldo-estoq to ttSaldoEstoq 
                assign ttSaldoEstoq.rowid      = rowid(saldo-estoq)
                       ttSaldoEstoq.modifica   = no
                       ttSaldoEstoq.saldo-disp = saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + 
                                                                            saldo-estoq.qt-aloc-ped  + 
                                                                            saldo-estoq.qt-alocada).        
        &ENDIF
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTSaldoEstoqAll DBOFunction 
PROCEDURE criaTTSaldoEstoqAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pItCodigo as char no-undo.
def input-output param table for ttSaldoEstoq.

for each ttSaldoEstoq where
         ttSaldoEstoq.it-codigo = pItCodigo:
    delete ttSaldoEstoq.
end.

for each saldo-estoq no-lock where
         saldo-estoq.it-codigo = pItCodigo:
         
    for first deposito fields (deposito.alocado deposito.ind-dep-cq deposito.ind-dep-rej
                               &IF "{&mgscm_version}" >= "2.05" &THEN
                                deposito.log-gera-wms
                               &ELSE
                                deposito.log-2
                               &ENDIF
                               ) where
              deposito.cod-depos = saldo-estoq.cod-depos:
        if deposito.alocado = no or
           deposito.ind-dep-cq   or
           deposito.ind-dep-rej then next.
    end.
    
    create ttSaldoEstoq.
    buffer-copy saldo-estoq to ttSaldoEstoq
        assign ttSaldoEstoq.rowid      = rowid(saldo-estoq)
               ttSaldoEstoq.modifica   = no.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    assign l-retorno = yes.

    find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
    if l-lote-avancado and
       avail item and
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

    if not l-retorno then
        assign ttSaldoEstoq.saldo-disp = 0.
    else
  &endif

    assign ttSaldoEstoq.saldo-disp = saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-prod + 
                                                                saldo-estoq.qt-aloc-ped  + 
                                                                saldo-estoq.qt-alocada).
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyAPI DBOFunction 
PROCEDURE destroyAPI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if valid-handle (hCpapi013) then
    run pi-finalizar in hCpapi013.

&IF DEFINED (bf_man_per_ppm) &THEN
    if valid-handle (h-cpapi020) then
        run pi-finalizar in h-cpapi020.
&ENDIF

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if valid-handle(h-ceapi030) then
        delete procedure h-ceapi030.
&endif

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaAPI DBOFunction 
PROCEDURE inicializaAPI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if not avail param-global then
    find first param-global no-lock no-error.

run cpp/cpapi013.p persistent set hCpapi013 (input        table tt-alocacao,
                                             input        table tt-deposito,
                                             input-output table tt-erro,
                                             input        yes).

&IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm THEN
        run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                     input-output table tt-erro,
                                                     INPUT        yes,
                                                     INPUT-OUTPUT TABLE tt-veiculos).
&ENDIF


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conv-qtd-ppm DBOFunction 
PROCEDURE pi-conv-qtd-ppm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-qtd-orig AS DEC NO-UNDO.
    DEF INPUT  PARAM p-ppm-orig AS DEC NO-UNDO.
    DEF INPUT  PARAM p-ppm-dest AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-qtd-dest AS DEC NO-UNDO.
    
    &IF DEFINED(bf_man_205) &THEN
        ASSIGN p-qtd-dest =  if p-ppm-orig = 0 or
                                p-ppm-dest = 0 then 
                                 p-qtd-orig
                             else
                                 round( (p-ppm-orig / p-ppm-dest) * p-qtd-orig,4).
    &ENDIF
    
RETURN "OK":U.
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

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaModuloPerPpm DBOFunction 
PROCEDURE retornaModuloPerPpm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (bf_man_per_ppm) &THEN

    def output param pModuloPerPpm as log no-undo.

    find first param-global no-lock.
    
    assign pModuloPerPpm = param-global.modulo-per-ppm.
    
&ENDIF
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaBalanceio DBOFunction 
PROCEDURE verificaBalanceio :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
def INPUT-OUTPUT param table for ttAlocaReserva.
def INPUT-OUTPUT param table for ttSaldoEstoq.
def INPUT-OUTPUT param table for ttReservas.

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-qt-aloc-lote AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-quant-aloc   AS DECIMAL     NO-UNDO.

    &IF DEFINED(bf_man_205) &THEN

        find first ttAlocaReserva where
                   ttAlocaReserva.estado > 0 no-error.
        if avail ttAlocaReserva then do:

            EMPTY TEMP-TABLE ttAlocaReservaAux.

            FOR EACH ttAlocaReserva:
                CREATE ttAlocaReservaAux.
                BUFFER-COPY ttAlocaReserva TO ttAlocaReservaAux.
            END.
    
            run pi-verifica-balanceio in hCpapi013 (INPUT-OUTPUT table ttAlocaReserva,
                                                    input-output table tt-erro).
            ASSIGN c-retorno = RETURN-VALUE.
            if c-retorno = "nok":U then do:
                
                for each tt-erro:
                    create RowErrors.
                    assign RowErrors.ErrorNumber      = tt-erro.cd-erro
                           RowErrors.ErrorType        = "EMS":u
                           RowErrors.ErrorSubType     = "ERROR":u
                           RowErrors.ErrorDescription = tt-erro.mensagem
                           RowErrors.ErrorHelp        = tt-erro.mensagem.
                end.

                EMPTY TEMP-TABLE ttAlocaReserva.
                FOR EACH ttAlocaReservaAux:
                    CREATE ttAlocaReserva.
                    BUFFER-COPY ttAlocaReservaAux TO ttAlocaReserva.
                    DELETE ttAlocaReservaAux.
                END.
            
                RETURN "NOK":U.
            end.
            ELSE DO: 
                
                if c-nom-prog-upc-mg97 <> "" then do:

                    for each tt-epc
                        where tt-epc.cod-event = "after-verifica-balanceio":
                        delete tt-epc.
                    end.

                    create tt-epc.
                    assign tt-epc.cod-event = "after-verifica-balanceio"
                           tt-epc.cod-parameter = "handle-ttAlocaReserva"
                           tt-epc.val-parameter = string(temp-table ttAlocaReserva:handle).

                    create tt-epc.
                    assign tt-epc.cod-event = "after-verifica-balanceio"
                           tt-epc.cod-parameter = "handle-ttReservas"
                           tt-epc.val-parameter = string(temp-table ttReservas:handle).

                    create tt-epc.
                    assign tt-epc.cod-event = "after-verifica-balanceio"
                           tt-epc.cod-parameter = "handle-ttSaldoEstoq"
                           tt-epc.val-parameter = string(temp-table ttSaldoEstoq:handle).                           

                    create tt-epc.
                    assign tt-epc.cod-event = "after-verifica-balanceio"
                           tt-epc.cod-parameter = "handle-cpapi013"
                           tt-epc.val-parameter = string(hCpapi013).

                    {include/i-epc201.i "after-verifica-balanceio"}
                end.
                
                /*Recalcula os valores das temp-tables da tela com os novos dados dos ve¡culos recalculados
                  no momento do balanceio.*/
                  
                FOR EACH ttAlocaReservaAux
                    WHERE NOT CAN-FIND(FIRST ttAlocaReserva
                        WHERE ttAlocaReserva.nr-ord-produ   = ttAlocaReservaAux.nr-ord-produ
                           AND ttAlocaReserva.item-pai      = ttAlocaReservaAux.item-pai
                           AND ttAlocaReserva.cod-roteiro   = ttAlocaReservaAux.cod-roteiro
                           AND ttAlocaReserva.op-codigo     = ttAlocaReservaAux.op-codigo
                           AND ttAlocaReserva.it-codigo     = ttAlocaReservaAux.it-codigo
                           AND ttAlocaReserva.cod-refer     = ttAlocaReservaAux.cod-refer
                           AND ttAlocaReserva.qt-aloc-lote  = ttAlocaReservaAux.qt-aloc-lote):
                    
                    FOR EACH ttReservas
                       WHERE ttReservas.tipo-formula = 4
                         AND ttReservas.veiculo
                         AND ttReservas.nr-ord-produ = ttAlocaReservaAux.nr-ord-produ
                         AND ttReservas.item-pai     = ttAlocaReservaAux.item-pai
                         AND ttReservas.cod-roteiro  = ttAlocaReservaAux.cod-roteiro
                         AND ttReservas.op-codigo    = ttAlocaReservaAux.op-codigo
                         AND ttReservas.it-codigo    = ttAlocaReservaAux.it-codigo
                         AND ttReservas.cod-refer    = ttAlocaReservaAux.cod-refer:
                         
                         
                         ASSIGN ttReservas.quant-falta  = ttReservas.quant-orig - ttReservas.quant-atend
                                ttReservas.quant-aloc   = 0
                                ttReservas.qt-aloc-lote = 0.
                                
                         FOR FIRST ord-prod FIELDS(nr-ord-produ cod-estabel) NO-LOCK
                             WHERE ord-prod.nr-ord-produ = ttReservas.nr-ord-produ:
                         END.
                         
                         run criaTTSaldoEstoq  (input ttReservas.it-codigo,
                                                input ord-prod.cod-estabel,
                                                input ttReservas.cod-refer,
                                                input ttReservas.tipo-formula,
                                                input ttReservas.per-ppm,
                                                input-output table ttSaldoEstoq).
                    END.
                END.
                
                FOR EACH ttAlocaReserva:
                    FIND FIRST ttReservas
                         WHERE ttReservas.nr-ord-produ = ttAlocaReserva.nr-ord-produ
                           AND ttReservas.item-pai     = ttAlocaReserva.item-pai
                           AND ttReservas.cod-roteiro  = ttAlocaReserva.cod-roteiro
                           AND ttReservas.op-codigo    = ttAlocaReserva.op-codigo
                           AND ttReservas.it-codigo    = ttAlocaReserva.it-codigo
                           AND ttReservas.cod-refer    = ttAlocaReserva.cod-refer NO-ERROR.

                    IF AVAIL ttReservas and
                       ttReservas.tipo-formula = 4 AND 
                       ttReservas.veiculo THEN DO:

                        /*Encontra o registro que estava em tela anteriormente, para efetuar a compara‡Æo.*/
                        FIND FIRST ttAlocaReservaAux
                             WHERE ttAlocaReservaAux.nr-ord-produ = ttAlocaReserva.nr-ord-produ
                               AND ttAlocaReservaAux.item-pai     = ttAlocaReserva.item-pai
                               AND ttAlocaReservaAux.cod-roteiro  = ttAlocaReserva.cod-roteiro
                               AND ttAlocaReservaAux.op-codigo    = ttAlocaReserva.op-codigo
                               AND ttAlocaReservaAux.it-codigo    = ttAlocaReserva.it-codigo
                               AND ttAlocaReservaAux.cod-refer    = ttAlocaReserva.cod-refer
                               AND ttAlocaReservaAux.cod-estabel  = ttAlocaReserva.cod-estabel
                               AND ttAlocaReservaAux.cod-depos    = ttAlocaReserva.cod-depos
                               AND ttAlocaReservaAux.cod-localiz  = ttAlocaReserva.cod-localiz
                               AND ttAlocaReservaAux.lote-serie   = ttAlocaReserva.lote-serie
                               AND ttAlocaReservaAux.qt-aloc-lote = ttAlocaReserva.qt-aloc-lote NO-ERROR.
                               
                        IF NOT AVAIL ttAlocaReservaAux THEN DO:
                            IF ttAlocaReserva.estado = 1 THEN DO: /*InclusÆo*/
                                ASSIGN de-qt-aloc-lote = ttAlocaReserva.qt-aloc-lote
                                       de-quant-aloc   = ttAlocaReserva.quant-aloc.
                            END.
                            ELSE DO: /*Modifica‡Æo ou exclusÆo*/
                                FIND FIRST aloca-reserva NO-LOCK
                                     WHERE ROWID(aloca-reserva) = ttAlocaReserva.ROWID NO-ERROR.
                                IF AVAIL aloca-reserva THEN DO:
                                
                                    IF ttAlocaReserva.estado = 2 THEN /*Modificacao*/
                                        ASSIGN de-qt-aloc-lote = ttAlocaReserva.qt-aloc-lote - aloca-reserva.qt-aloc-lote
                                               de-quant-aloc   = ttAlocaReserva.quant-aloc   - aloca-reserva.quant-aloc.
                                    ELSE /*Exclusao*/
                                        ASSIGN de-qt-aloc-lote = aloca-reserva.qt-aloc-lote * -1
                                               de-quant-aloc   = aloca-reserva.quant-aloc   * -1.
                                END.
                            END.
                        END.
                        ELSE DO:
                        
                            IF ttAlocaReserva.estado = 1 OR ttAlocaReserva.estado = 2 THEN
                                ASSIGN de-qt-aloc-lote = ttAlocaReserva.qt-aloc-lote - (IF ttAlocaReservaAux.estado = 3 
                                                                                          THEN 0 ELSE ttAlocaReservaAux.qt-aloc-lote)
                                       de-quant-aloc   = ttAlocaReserva.quant-aloc   - (IF ttAlocaReservaAux.estado = 3 
                                                                                          THEN 0 ELSE ttAlocaReservaAux.quant-aloc).
                            ELSE DO:
                                IF ttAlocaReserva.estado = 0 /*Display*/ THEN DO:
                                    IF ttAlocaReservaAux.estado = 3 THEN
                                        ASSIGN de-qt-aloc-lote = ttAlocaReserva.qt-aloc-lote
                                               de-quant-aloc   = ttAlocaReserva.quant-aloc.
                                    ELSE DO:
                                        IF ttAlocaReservaAux.estado <> 0 THEN DO:
                                            /*Modifica‡Æo*/
                                            ASSIGN de-qt-aloc-lote = ttAlocaReserva.qt-aloc-lote - ttAlocaReservaAux.qt-aloc-lote
                                                   de-quant-aloc   = ttAlocaReserva.quant-aloc   - ttAlocaReservaAux.quant-aloc.
                                        END.
                                    END.
                                END.
                                ELSE DO:
                                    /*ExclusÆo*/
                                    IF ttAlocaReservaAux.estado <> 3 THEN
                                        ASSIGN de-qt-aloc-lote = ttAlocaReservaAux.qt-aloc-lote * -1
                                               de-quant-aloc   = ttAlocaReservaAux.quant-aloc   * -1.
                                    ELSE
                                        ASSIGN de-qt-aloc-lote = 0
                                               de-quant-aloc   = 0.
                                END.
                            END.
                        END.

                        FOR FIRST ord-prod FIELDS(nr-ord-produ cod-estabel) NO-LOCK
                            WHERE ord-prod.nr-ord-produ = ttAlocaReserva.nr-ord-produ:
                        END.

                        IF NOT CAN-FIND(FIRST ttSaldoEstoq 
                                        WHERE ttSaldoEstoq.it-codigo   = ttAlocaReserva.it-codigo
                                          AND ttSaldoEstoq.cod-estabel = ord-prod.cod-estabel
                                          AND ttSaldoEstoq.cod-refer   = ttAlocaReserva.cod-refer) THEN 
                            run criaTTSaldoEstoq  (input ttReservas.it-codigo,
                                                   input ord-prod.cod-estabel,
                                                   input ttReservas.cod-refer,
                                                   input ttReservas.tipo-formula,
                                                   input ttReservas.per-ppm,
                                                   input-output table ttSaldoEstoq).

                        find first ttSaldoEstoq where
                                   ttSaldoEstoq.cod-estabel = ttAlocaReserva.cod-estabel and
                                   ttSaldoEstoq.cod-depos   = ttAlocaReserva.cod-depos   and
                                   ttSaldoEstoq.cod-localiz = ttAlocaReserva.cod-localiz and
                                   ttSaldoEstoq.lote        = ttAlocaReserva.lote-serie  and
                                   ttSaldoEstoq.it-codigo   = ttAlocaReserva.it-codigo   and
                                   ttSaldoEstoq.cod-refer   = ttAlocaReserva.cod-refer NO-ERROR.

                        ASSIGN ttSaldoEstoq.saldo-disp-fis   = ttSaldoEstoq.saldo-disp-fis - de-qt-aloc-lote
                               ttSaldoEstoq.qt-aloc-prod-fis = ttSaldoEstoq.qt-aloc-prod-fis + de-qt-aloc-lote
                               ttSaldoEstoq.saldo-disp       = ttSaldoEstoq.saldo-disp - de-quant-aloc
                               ttSaldoEstoq.qt-aloc-prod     = ttSaldoEstoq.qt-aloc-prod + de-quant-aloc
                               ttSaldoEstoq.qtidade-atu      = ttSaldoEstoq.qtidade-atu - de-qt-aloc-lote
                               ttReservas.quant-falta        = ttReservas.quant-falta - de-quant-aloc
                               ttReservas.quant-aloc         = ttReservas.quant-aloc + de-quant-aloc 
                               ttReservas.qt-aloc-lote       = ttReservas.qt-aloc-lote + de-qt-aloc-lote.
                               
                    END. /*IF ttReservas.tipo-formula = 4=*/
                END. /*FOR EACH ttAlocaReserva*/

                /*H  casos em que essa procedure retornar  via return-value um c¢digo de mensagem de pergunta, 
                 que dever  ser emitido em tela.*/                                                             
                RETURN c-retorno.
            END.
        END.

    &ENDIF

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
