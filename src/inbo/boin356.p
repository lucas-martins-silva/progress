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
{include/i-prgvrs.i BOIN356 2.00.00.053 } /*** "010053" 30/11/2023 16:03:25  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin356 MUT}
&ENDIF


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
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel prazo-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin356.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER bfPrazo2TT FOR {&TableName}.
def var c-pType as char no-undo.

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

/* Include com prÇ-processadores que diferenciam releases */
{cdp/cdcfgman.i}
{include/i_dbvers.i}

def var iNumOrdem  as int no-undo initial 0.
def var iNumPedido as int no-undo initial 0.
def var rChave     as rowid no-undo .     
def var rChavePai  as rowid no-undo .
def var iParcI as int no-undo initial 0.
def var iParcF as int no-undo initial 99999.
def var lNaoCon as logical no-undo initial yes.
def var lConfir as logical no-undo initial yes.
def var lCotada as logical no-undo initial yes.
def var lElimin as logical no-undo initial yes.
def var lEmCotacao as logical no-undo initial yes.
def var lTermin as logical no-undo initial yes.
def var dDataEntrega as date no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
def var dDataEntregaFim as date no-undo init 12/31/9999.
def var icod-comprado as char no-undo.
def var c-literal as char no-undo.
def new global shared var lg-multiplanta-ordem as logical INIT NO NO-UNDO .

/* Integraá∆o com Investimentos */
def var h-boiv037    as handle  no-undo.

def var l-ordemEmPedido as logical initial no.

{utp/ut-liter.i Parcelada}
assign c-literal = trim(return-value).

def temp-table tt-erro-mp NO-UNDO
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

{include/i-epc200.i boin356}

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
         HEIGHT             = 2
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


find first param-global no-lock no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    /* N∆o executar procedimento na inclus∆o de nova parcela
       atravÇs da alteraá∆o, somente executar quando for inclus∆o de
       ordem e parcela  */       
    def buffer b-prazo for prazo-compra.

    if not can-find(first b-prazo
                    where b-prazo.numero-ordem = prazo-compra.numero-ordem
                      and rowid(b-prazo) <> rowid(prazo-compra)) then do:

        def var r-aux-oracle as rowid no-undo.
        assign  r-aux-oracle = rowid(prazo-compra).

        release prazo-compra.

     &IF "{&ems_dbtype}":U <> "progress":U &THEN 
        ROWID(prazo-compra).
     &ENDIF

        run repositionRecord in this-procedure (input r-aux-oracle).
   end.

   return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var h-boin356ca       as handle no-undo.
def var de-tot-quant-parc as dec    no-undo.
/*
  Atualiza automaticamente a qtde solicitada da 
  Ordem de Compra quando necess†rio.
  ParÉmetros:
*/

RUN inbo/boin356ca.p PERSISTENT SET h-boin356ca.
RUN totalizaQuantidadeParcelasOrdem in h-boin356ca (input ordem-compra.numero-ordem,
                                                    output de-tot-quant-parc).
DELETE PROCEDURE h-boin356ca.

find current ordem-compra exclusive-lock no-error .
assign ordem-compra.qt-solic = de-tot-quant-parc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aloca-ordem-cc DBOProgram 
PROCEDURE aloca-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose: Alocaá∆o de parcela de ordem de compra
  Parameters: pi-ordem-compra: N£mero da ordem de compra
              pi-parcela.....: Parcela    
              pd-quant-cc....: Quantidade a ser alocada 
  
  Notes: Se o n£mero da parcela for 0 o programa retorna a parcela que foi alocada.
------------------------------------------------------------------------------*/
    
    DEFINE INPUT        PARAMETER pi-ordem-compra  AS INTEGER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pi-parcela       AS INTEGER NO-UNDO.
    DEFINE INPUT        PARAMETER pd-quant-cc      AS DECIMAL NO-UNDO.

    FOR FIRST prazo-compra EXCLUSIVE-LOCK
        WHERE prazo-compra.numero-ordem = pi-ordem-compra
        AND   prazo-compra.parcela      = pi-parcela
        AND   prazo-compra.situacao     = 2: /* Confirmada */
    END.
         
    IF  NOT AVAIL prazo-compra AND pi-parcela = 0 THEN DO:
        /* Aloca na primeira parcela em aberto (Confirmada) e que ainda tenha saldo. */
        FOR FIRST prazo-compra EXCLUSIVE-LOCK
            WHERE prazo-compra.numero-ordem = pi-ordem-compra
            AND   prazo-compra.situacao     = 2 
            AND   (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0
            BY prazo-compra.data-entrega
            BY prazo-compra.numero-ordem:
        END.
    END.

    IF  AVAIL prazo-compra THEN DO:
        ASSIGN prazo-compra.dec-1 = prazo-compra.dec-1 + pd-quant-cc
               pi-parcela         = prazo-compra.parcela.
    END.
    ELSE
        RETURN "NOK":U. 
    
    RELEASE prazo-compra.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.
   ELSE 
       RETURN "OK":U.

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

    /* ---------- Moduto Investimento -----------*/
    if param-global.modulo-in and
       ordem-compra.num-ord-inv <> 0 then do:
       run ivbo/boiv037.p persistent set h-boiv037.
       run DeleteProgEntr in h-boiv037 (input rowid(prazo-compra), 
                                        input-output table RowErrors).
       delete procedure h-boiv037.                         
    end.
    /*------------------------------------------ */    
    &if  "{&mgadm_version}" >= "2.04" &then
         /*API de Execucao Orcamentaria*/

         RUN cdp/cdapi183.p (INPUT ROWID(prazo-compra), /*rowid prazo-compra*/
                             INPUT TABLE rowobject,     /*rowid do registro alterado*/
                             INPUT 5,                   /*funcao: 1-BeforeDeleteRecord da Prazo-Compra*/
                             OUTPUT TABLE Rowerrors APPEND).   /*tt que retorna erro*/
    &endif 

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    /* Multiplanta */
    IF NOT lg-multiplanta-ordem THEN
    run IntegraParcelasMultiplanta (input ROWID(prazo-compra), input 3).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  &if  "{&mgadm_version}" >= "2.04" &then
          /*API de Execucao Orcamentaria*/
          RUN cdp/cdapi183.p (INPUT ROWID(prazo-compra), /*rowid prazo-compra*/
                              INPUT TABLE rowobject,     /*registro alterado*/
                              INPUT 5,                   /*funcao: 5-BeforeUpdateRecord da Prazo-Compra*/
                           OUTPUT TABLE Rowerrors APPEND).   /*tt que retorna erro*/
  &endif

  IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
      RETURN "NOK":U.
  ELSE 
      RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE before_copyBuffer2TT DBOProgram 
PROCEDURE before_copyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        IF c-pType = "Create":U then DO:
           if can-find(bfPrazo2TT where 
                       bfPrazo2TT.numero-ordem = rowObject.numero-ordem and
                       bfPrazo2TT.parcela      = rowObject.parcela) then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-parcela AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Parcela" *}
               ASSIGN c-lbl-liter-parcela = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                  &ErrorNumber="24"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="c-lbl-liter-parcela + ' ' + string(rowObject.parcela)"}
           end.
        END.

        /*--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaParcelasDaOrdem DBOProgram 
PROCEDURE eliminaParcelasDaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Elimina as parcelas da Ordem de Compra
  Parameters:  
               ipar1 : rOrdem        : Rowid da Ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER rOrdem        AS ROWID   NO-UNDO. 

      for first ordem-compra fields(numero-ordem num-ord-inv) where 
          rowid(ordem-compra) = rOrdem no-lock: end.
      if param-global.modulo-in and
         ordem-compra.num-ord-inv <> 0 then
           run ivbo/boiv037.p persistent set h-boiv037.
      for each prazo-compra where 
          prazo-compra.numero-ordem = ordem-compra.numero-ordem exclusive-lock:
          if param-global.modulo-in and
               ordem-compra.num-ord-inv <> 0 then 
               run DeleteProgEntr in h-boiv037 (input rowid(prazo-compra), 
                                                input-output table RowErrors).

          delete prazo-compra.
      end.
      if param-global.modulo-in and
         ordem-compra.num-ord-inv <> 0 then
          delete procedure h-boiv037.

    RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findClientePedido DBOProgram 
PROCEDURE findClientePedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then            
    &else 
        DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo LIKE prazo-compra.it-codigo NO-UNDO.
        DEFINE INPUT PARAMETER pdata-entrega LIKE prazo-compra.data-entrega NO-UNDO.
        DEFINE INPUT PARAMETER pnr-sequencia LIKE prazo-compra.nr-sequencia NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn       as char no-undo.

        RUN openQueryStatic (input "main":U).
        run goToKeyClientePedido (input pnumero-ordem, 
                                        pparcela,
                                        pit-codigo,
                                        pdata-entrega,
                                        pnr-sequencia).
        if return-value = "OK" then assign pcreturn = "".  
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value. 
        end. 
    &endif       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then            
    &else 
        DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo LIKE prazo-compra.it-codigo NO-UNDO.
        DEFINE INPUT PARAMETER pdata-entrega LIKE prazo-compra.data-entrega NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn       as char no-undo.

        RUN openQueryStatic (input "main":U).
        run goToKeyItem (input pnumero-ordem, 
                               pparcela,
                               pit-codigo,
                               pdata-entrega).
        if return-value = "OK" then assign pcreturn = "".  
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value. 
        end. 
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdem DBOProgram 
PROCEDURE findOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then            
    &else 
        DEFINE INPUT PARAMETER pnum-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.
        DEFINE OUTPUT PARAMETER pcreturn       as char no-undo.
        RUN openQueryStatic (input "main":U).
        run goToKey (input pnum-ordem, 
                           pparcela).
        if return-value = "OK" then assign pcreturn = "".  
        if return-value = "NOK" then do:
            {utp/ut-table.i mgind {&TABLENAME} 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign pcreturn =  return-value. 
        end. 
    &endif        
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
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "pedido-clien":U THEN ASSIGN pFieldValue = RowObject.pedido-clien.        
        &if defined(bf_mat_contratos) &then
        &else 
            WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato. 
        &endif      
        &if defined(bf-mat-comex) &then            
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.        
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.        
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.
            WHEN "u-char-2":U THEN ASSIGN pFieldValue = RowObject.u-char-2.        
        &else 
            WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo. 
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.     
            WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
            WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        &endif        
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
        WHEN "data-alter":U THEN ASSIGN pFieldValue = RowObject.data-alter.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-orig":U THEN ASSIGN pFieldValue = RowObject.data-orig.
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
        &endif        
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
        WHEN "qtd-a-ped-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-a-ped-forn.
        WHEN "qtd-do-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-do-forn.
        WHEN "qtd-rec-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rec-forn.
        WHEN "qtd-rej-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rej-forn.
        WHEN "qtd-sal-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-sal-forn.
        WHEN "quant-a-ped":U THEN ASSIGN pFieldValue = RowObject.quant-a-ped.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.
        WHEN "quant-rejeit":U THEN ASSIGN pFieldValue = RowObject.quant-rejeit.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo.
        WHEN "quantid-orig":U THEN ASSIGN pFieldValue = RowObject.quantid-orig.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "MRP":U THEN ASSIGN pFieldValue = RowObject.MRP.
        WHEN "nr-alt-data":U THEN ASSIGN pFieldValue = RowObject.nr-alt-data.
        WHEN "nr-alt-quant":U THEN ASSIGN pFieldValue = RowObject.nr-alt-quant.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif                
        &if defined(bf-mat-comex) &then    
            WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.                
        &else
            WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.        
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.  
            WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.   
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.   
            WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
            WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.                                        
        &endif                
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ORDEM
  Parameters:
               retorna valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE OUTPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

        /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.

        ASSIGN pnumero-ordem = RowObject.numero-ordem.
        ASSIGN pparcela = RowObject.parcela.

        RETURN "OK":U.
    &endif
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
        WHEN "cod-alter":U THEN ASSIGN pFieldValue = RowObject.cod-alter.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        &if defined(bf-mat-comex) &then    
        &else
            WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.        
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
            WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.            
        &endif        
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
    &if defined(bf-mat-comex) &then    
    &else
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
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ORDEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    For FIRST bfprazo-compra fields(numero-ordem parcela) WHERE
        bfprazo-compra.numero-ordem = pnumero-ordem AND
        bfprazo-compra.parcela = pparcela
        NO-LOCK: end.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprazo-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyClientePedido DBOProgram 
PROCEDURE goToKeyClientePedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo LIKE prazo-compra.it-codigo NO-UNDO.
        DEFINE INPUT PARAMETER pdata-entrega LIKE prazo-compra.data-entrega NO-UNDO.
        DEFINE INPUT PARAMETER pnr-sequencia LIKE prazo-compra.nr-sequencia NO-UNDO.

        for FIRST bfprazo-compra fields(numero-ordem parcela      it-codigo 
                                        data-entrega nr-sequencia           ) WHERE
            bfprazo-compra.numero-ordem = pnumero-ordem AND
            bfprazo-compra.parcela = pparcela AND
            bfprazo-compra.it-codigo = pit-codigo AND
            bfprazo-compra.data-entrega = pdata-entrega AND
            bfprazo-compra.nr-sequencia = pnr-sequencia
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfprazo-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.
        DEFINE INPUT PARAMETER pit-codigo LIKE prazo-compra.it-codigo NO-UNDO.
        DEFINE INPUT PARAMETER pdata-entrega LIKE prazo-compra.data-entrega NO-UNDO.

        For FIRST bfprazo-compra fields(numero-ordem parcela it-codigo data-entrega) WHERE
            bfprazo-compra.numero-ordem = pnumero-ordem AND
            bfprazo-compra.parcela = pparcela AND
            bfprazo-compra.it-codigo = pit-codigo AND
            bfprazo-compra.data-entrega = pdata-entrega
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfprazo-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyOrdemCompra DBOProgram 
PROCEDURE goToKeyOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ORDEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.

    for FIRST bfprazo-compra fields(numero-ordem) WHERE
        bfprazo-compra.numero-ordem = pnumero-ordem
        NO-LOCK: end.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprazo-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToNumOrdem DBOProgram 
PROCEDURE goToNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.

        For FIRST bfprazo-compra fields(numero-ordem) WHERE
            bfprazo-compra.numero-ordem = pnumero-ordem
            NO-LOCK: end.

        /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfprazo-compra THEN
            RETURN "NOK":U.

        /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
              existam erros ser† retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE informaTipoValidacaoDelete DBOProgram 
PROCEDURE informaTipoValidacaoDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAM p-l-ordemEmPedido AS LOG NO-UNDO.

  assign l-ordemEmPedido = p-l-ordemEmPedido.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IntegraParcelasMultiplanta DBOProgram 
PROCEDURE IntegraParcelasMultiplanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-parcela    as rowid .
define input parameter p-tipo-movto as integer.

run ccp/ccapi200.p(input "Prazo-compra":U, 
                   input p-parcela, 
                   input p-tipo-movto, 
                   input-output table tt-erro-mp).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isTransfDrb DBOProgram 
PROCEDURE isTransfDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-numero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEF INPUT  PARAM p-parcela      LIKE prazo-compra.parcela      NO-UNDO.
    DEF OUTPUT PARAM p-transf-drb   AS LOGICAL                     NO-UNDO.

    FIND FIRST ordens-embarque NO-LOCK
         WHERE ordens-embarque.numero-ordem = p-numero-ordem
         AND   ordens-embarque.parcela      = p-parcela NO-ERROR.
    IF AVAIL ordens-embarque THEN DO:
        IF CAN-FIND(FIRST embarque-imp
                      where embarque-imp.cod-estabel = ordens-embarque.cod-estabel    
                      and embarque-imp.embarque    = ordens-embarque.embarque       
                      AND embarque-imp.log-embarq-transf-draw ) THEN 
            ASSIGN p-transf-drb = YES.
        ELSE
            ASSIGN p-transf-drb = NO.
    END.
    ELSE
        ASSIGN p-transf-drb = NO.  
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdem DBOProgram 
PROCEDURE linkToOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAM ph-ordem AS HANDLE NO-UNDO.

        RUN getKey IN ph-ordem (OUTPUT icod-comprado,
                                OUTPUT iNumOrdem).
        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido DBOProgram 
PROCEDURE linkToPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAM ph-pedido-compr AS HANDLE NO-UNDO.

        RUN getKey IN ph-pedido-compr (OUTPUT inumpedido).

        RETURN "OK":U.
    &endif
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
        when 1 then do:
           run openQueryStatic (input "main":U).
        end.   
        &if defined(bf-mat-comex) &then    
        &else        
            when 2 then do:
               run openQueryStatic (input "byNumOrdembyParcela":U).
            end.
            when 3 then do:
               run openQueryStatic (input "byNumeroOrdem":U).
            end.
            when 4 then do:
               run openQueryStatic (input "byNumOrdembyParcela":U).
            end.
            when 5 then do:
               run openQueryStatic (input "byItCodigo":U).
            end.
            when 6 then do:
               run openQueryStatic (input "byNumOrdembyParcela":U).
            end.
            when 7 then do:
               run openQueryStatic (input "byNumOrdembyParcela":U).
            end.
            when 8 then do:
               run openQueryStatic (input "byNumOrdembyParcela":U).
            end.
        &endif
    end. /*end case*/
   RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyItCodigo DBOProgram 
PROCEDURE openQuerybyItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        open query {&QueryName} for each {&TableName} where
                                {&TableName}.numero-ordem = iNumOrdem     and 
                                {&TableName}.quant-saldo > 0              and 
                              (({&TableName}.situacao = 1 and lNaoCon)    OR 
                               ({&TableName}.situacao = 2 and lConfir)    OR 
                               ({&TableName}.situacao = 3 and lCotada)    OR 
                               ({&TableName}.situacao = 4 and lElimin)    OR 
                               ({&TableName}.situacao = 5 and lEmCotacao) OR 
                               ({&TableName}.situacao = 6 and lTermin)) no-lock
                               /*by {&tablename}.it-codigo*/ INDEXED-REPOSITION.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyNumeroOrdem DBOProgram 
PROCEDURE openQuerybyNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        open query {&QueryName} for each {&TableName} where
                                 {&TableName}.numero-ordem = iNumOrdem     and 
                                 {&TableName}.quant-saldo > 0              and 
                               (({&TableName}.situacao = 1 and lNaoCon)    OR 
                                ({&TableName}.situacao = 2 and lConfir)    OR 
                                ({&TableName}.situacao = 3 and lCotada)    OR 
                                ({&TableName}.situacao = 4 and lElimin)    OR 
                                ({&TableName}.situacao = 5 and lEmCotacao) OR 
                                ({&TableName}.situacao = 6 and lTermin)) no-lock
                                by {&TableName}.numero-ordem INDEXED-REPOSITION.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyNumOrdembyParcela DBOProgram 
PROCEDURE openQuerybyNumOrdembyParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        open query {&QueryName} for each {&TableName} where
                                         {&TableName}.numero-ordem = iNumOrdem and 
                                         {&TableName}.data-entrega >= dDataEntrega and 
                                         {&TableName}.data-entrega <= dDataEntregaFim and
                                         {&TableName}.parcela >= iParcI  and 
                                         {&TableName}.parcela <= iParcF  and 
                                         (({&TableName}.situacao   = 1 and lNaoCon) OR 
                                         ({&TableName}.situacao    = 2 and lConfir) OR 
                                         ({&TableName}.situacao    = 3 and lCotada) OR 
                                         ({&TableName}.situacao    = 4 and lElimin) OR 
                                         ({&TableName}.situacao    = 5 and lEmCotacao) OR 
                                         ({&TableName}.situacao    = 6 and lTermin)) 
                                          no-lock INDEXED-REPOSITION.
    &endif                                         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByOrdem DBOProgram 
PROCEDURE openQueryByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName} for each {&TableName} where
                             {&TableName}.numero-ordem = iNumOrdem 
                             NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.                                
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
    OPEN QUERY {&QueryName} FOR EACH prazo-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desaloca-ordem-cc DBOProgram 
PROCEDURE pi-desaloca-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose: Desalocaá∆o de parcela de ordem de compra
  Parameters: pi-ordem-compra: N£mero da ordem de compra
              pi-parcela: Parcela    
              pd-quant-cc: Quantidade a ser desalocada   
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pi-ordem-compra  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-parcela       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pd-quant-cc      AS DECIMAL NO-UNDO.

    FOR FIRST prazo-compra EXCLUSIVE-LOCK
            WHERE prazo-compra.numero-ordem = pi-ordem-compra
            AND   prazo-compra.parcela      = pi-parcela
            AND   prazo-compra.situacao     = 2: /* Confirmada */
    END.

    IF  AVAIL prazo-compra THEN DO:
        ASSIGN prazo-compra.dec-1 = prazo-compra.dec-1 - pd-quant-cc.
        
        IF  prazo-compra.dec-1 < 0 THEN
            ASSIGN prazo-compra.dec-1 = 0.               
    END.
    ELSE
        RETURN "NOK":U. 
    
    RELEASE prazo-compra.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE QuantCC0509A DBOProgram 
PROCEDURE QuantCC0509A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        def input  parameter piNumOrdem     as int     no-undo.
        def output parameter de-quant       as decimal no-undo.
        def output parameter de-quant-saldo as decimal no-undo.
        def output parameter de-quant-aloc  as decimal no-undo.
        def output parameter de-quant-receb as decimal no-undo.
        def output parameter c-data-entrega as char    no-undo.        

        assign c-data-entrega = ?
               de-quant       = 0
               de-quant-saldo = 0
               de-quant-aloc  = 0
               de-quant-receb = 0.

        for each prazo-compra fields(numero-ordem data-entrega quantidade dec-1 
                                     quant-receb  situacao     quant-saldo) where 
            prazo-compra.numero-ordem = piNumOrdem no-lock:

            if  c-data-entrega <> ? and
                date(c-data-entrega) <> prazo-compra.data-entrega then do:
                assign c-data-entrega = c-literal.
            end.
            else
                assign c-data-entrega = string(prazo-compra.data-entrega,"99/99/9999") when c-data-entrega <> c-literal.

            assign de-quant       = de-quant       + prazo-compra.quantidade
                   de-quant-aloc  = de-quant-aloc  + prazo-compra.dec-1
                   de-quant-receb = de-quant-receb + prazo-compra.quant-receb.
            if  prazo-compra.situacao <> 4 then
                assign de-quant-saldo = de-quant-saldo + prazo-compra.quant-saldo.
        end.

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
    &if defined(bf-mat-comex) &then    
    &else
        def input parameter p-i-num-ordem    as int   no-undo.
        def input parameter p-chave          as rowid no-undo.
        def input parameter p-chave-pai      as char  no-undo.
        def input parameter p-i-parc-i       as char  no-undo.
        def input parameter p-i-parc-f       as char  no-undo.
        def input parameter p-c-naocon       as char  no-undo.
        def input parameter p-c-confir       as char  no-undo.
        def input parameter p-c-cotada       as char  no-undo.
        def input parameter p-c-elimin       as char  no-undo.
        def input parameter p-c-em-cotacao   as char  no-undo.
        def input parameter p-c-termin       as char  no-undo.

        assign  lNaoCon    = if p-c-naocon      = "yes" then YES else NO
                lConfir    = if p-c-confir      = "yes" then YES else NO
                lCotada    = if p-c-cotada      = "yes" then YES else NO
                lElimin    = if p-c-elimin      = "yes" then YES else NO
                lEmCotacao = if p-c-em-cotacao  = "yes" then YES else NO
                lTermin    = if p-c-termin      = "yes" then YES else NO.  


         run setConstraintParametros (input p-i-num-ordem,              
                                            p-chave,      
                                            to-rowid(p-chave-pai),   
                                            int(p-i-parc-i),    
                                            int(p-i-parc-f),
                                            lNaoCon,   
                                            lConfir,    
                                            lCotada,    
                                            lElimin,    
                                            lEmCotacao,
                                            lTermin,
                                            &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,
                                            12/31/9999).    
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        def input parameter p-i-num-ordem as int no-undo.
        def input parameter p-c-naocon    as char no-undo.
        def input parameter p-c-confir    as char no-undo.
        def input parameter p-c-cotada     as char no-undo.
        def input parameter p-c-elimin    as char no-undo.
        def input parameter p-c-em-cotacao as char no-undo.
        def input parameter p-c-termin    as char no-undo.

        assign  lNaoCon    = if p-c-naocon      = "yes" then YES else NO
                lConfir    = if p-c-confir      = "yes" then YES else NO
                lCotada    = if p-c-cotada      = "yes" then YES else NO
                lElimin    = if p-c-elimin      = "yes" then YES else NO
                lEmCotacao = if p-c-em-cotacao  = "yes" then YES else NO
                lTermin    = if p-c-termin      = "yes" then YES else NO.

        run setConstraintParametros  (input p-i-num-ordem,
                                            ?,
                                            ?,
                                            0, 
                                            99999,
                                            lNaoCon,   
                                            lConfir,    
                                            lCotada,    
                                            lElimin,    
                                            lEmCotacao,
                                            lTermin,
                                            &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,
                                            12/31/9999).    
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        def input parameter p-i-num-ordem    as int   no-undo.
        def input parameter p-chave          as rowid no-undo.
        def input parameter p-chave-pai      as char  no-undo.
        def input parameter p-d-data-entrega as char  no-undo.
        def input parameter p-d-data-entrega-fim as char no-undo.
        def input parameter p-c-naocon       as char  no-undo.
        def input parameter p-c-confir       as char  no-undo.
        def input parameter p-c-cotada       as char  no-undo.
        def input parameter p-c-elimin       as char  no-undo.
        def input parameter p-c-em-cotacao   as char  no-undo.
        def input parameter p-c-termin       as char  no-undo.

        assign  lNaoCon    = if p-c-naocon      = "yes" then YES else NO
                lConfir    = if p-c-confir      = "yes" then YES else NO
                lCotada    = if p-c-cotada      = "yes" then YES else NO
                lElimin    = if p-c-elimin      = "yes" then YES else NO
                lEmCotacao = if p-c-em-cotacao  = "yes" then YES else NO
                lTermin    = if p-c-termin      = "yes" then YES else NO.

        run setConstraintParametros  (input p-i-num-ordem,              
                                            p-chave,      
                                            to-rowid(p-chave-pai),   
                                            0, 
                                            99999,   
                                            lNaoCon,   
                                            lConfir,    
                                            lCotada,    
                                            lElimin,    
                                            lEmCotacao,
                                            lTermin,
                                            date(p-d-data-entrega),
                                            date(p-d-data-entrega-fim)).   
    &endif                                            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint6 DBOProgram 
PROCEDURE setConstraint6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then    
    &else
        def input parameter p-i-num-ordem    as int   no-undo.
        def input parameter p-chave          as rowid no-undo.
        def input parameter p-chave-pai      as char  no-undo.
        def input parameter p-c-naocon       as char  no-undo.
        def input parameter p-c-confir       as char  no-undo.
        def input parameter p-c-cotada       as char  no-undo.
        def input parameter p-c-elimin       as char  no-undo.
        def input parameter p-c-em-cotacao   as char  no-undo.
        def input parameter p-c-termin       as char  no-undo.

        assign  lNaoCon    = if p-c-naocon      = "yes" then YES else NO
                lConfir    = if p-c-confir      = "yes" then YES else NO
                lCotada    = if p-c-cotada      = "yes" then YES else NO
                lElimin    = if p-c-elimin      = "yes" then YES else NO
                lEmCotacao = if p-c-em-cotacao  = "yes" then YES else NO
                lTermin    = if p-c-termin      = "yes" then YES else NO.

        run setConstraintParametros  (input p-i-num-ordem,
                                            p-chave,      
                                            to-rowid(p-chave-pai),   
                                            0,    
                                            99999,
                                            lNaoCon,   
                                            lConfir,    
                                            lCotada,    
                                            lElimin,    
                                            lEmCotacao,
                                            lTermin,
                                            &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,
                                            12/31/9999).  
    &endif                                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint7 DBOProgram 
PROCEDURE setConstraint7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        def input param p-numero-ordem as int no-undo.
        run setConstraintNumOrdem (input p-numero-ordem).
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint8 DBOProgram 
PROCEDURE setConstraint8 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        def input param p-chave-ordem as rowid no-undo.
        for first ordem-compra fields(numero-ordem) where 
            rowid(ordem-compra) = p-chave-ordem no-lock: end.
        if avail ordem-compra then
           run setConstraintNumOrdem (input ordem-compra.numero-ordem).
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintmain DBOProgram 
PROCEDURE setconstraintmain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumOrdem DBOProgram 
PROCEDURE setConstraintNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Par∆metros:
           ipar1  : piNumOrdem : Numero da ordem corrente da interface.
*/

    &if defined(bf-mat-comex) &then    
    &else
        def input param piNumOrdem as int no-undo.

        assign iNumOrdem = piNumOrdem.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParametros DBOProgram 
PROCEDURE setConstraintParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*Par∆metros:
           ipar1  : piNumOrdem    : Numero da ordem corrente da interface.
           ipar2  : pChave        : Chave da tabela filho (prazo-compra).
           ipar3  : pChavePai     : Chave da tabela pai (Ordem-compra).
           ipar4  : piParcI       : N£mero da parcela inicial.
           ipar5  : plNaoCon      : Parcela n∆o confirmada.
           ipar6  : plConfir      : Parcela  confirmada.
           ipar7  : plCotada      : Parcela cotada.
           ipar8  : plElimin      : Parcela eliminada.
           ipar8  : plEmCotacao   : Parcela em cotaá∆o.
           ipar10 : plTermin      : Parcela recebida.
           ipar11 : pdDataEntrega : Data de entrega Inicial.
*/
    &if defined(bf-mat-comex) &then    
    &else

        def input parameter piNumOrdem    as int   no-undo.
        def input parameter pChave        as rowid no-undo.
        def input parameter pChavePai     as rowid  no-undo.
        def input parameter piParcI       as int  no-undo.
        def input parameter piParcF       as int  no-undo.
        def input parameter plNaoCon      as logical  no-undo.
        def input parameter plConfir      as logical  no-undo.
        def input parameter plCotada      as logical  no-undo.
        def input parameter plElimin      as logical  no-undo.
        def input parameter plEmCotacao   as logical  no-undo.
        def input parameter plTermin      as logical  no-undo.
        def input parameter pdDataEntrega as date  no-undo.
        def input parameter pdDataEntregaFim as date no-undo.

        assign  iNumOrdem  = piNumOrdem
                rChave     = pChave
                rChavePai  = pChavePai 
                iParcI     = piParcI  
                iParcF     = piParcF   
                lNaoCon    = plNaoCon
                lConfir    = plConfir
                lCotada    = plCotada
                lElimin    = plElimin
                lEmCotacao = plEmCotacao
                lTermin    = plTermin
                dDataEntrega = pdDataEntrega
                dDataEntregaFim = pdDataEntregaFim.
    &endif                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

        assign c-pType = pType.

        /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
              executadas ---*/
        /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as validaá‰es ---*/

        IF pType = "Create":U then DO:
           if can-find(prazo-compra where 
                       prazo-compra.numero-ordem = rowObject.numero-ordem and
                       prazo-compra.parcela      = rowObject.parcela) then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-parcela-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Parcela" *}
               ASSIGN c-lbl-liter-parcela-2 = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                  &ErrorNumber="24"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="c-lbl-liter-parcela-2 + ' ' + string(rowObject.parcela)"}
           end.
        END.

        if pType = "Delete":U then do:
            for first ordem-compra fields(numero-ordem situacao nr-contrato num-ord-inv)  where 
                 ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock: end.
            if avail ordem-compra then do:
               if (not l-ordemEmPedido) then do:
                    if  ordem-compra.situacao <> 1 and ordem-compra.situacao <> 5 and 
                    &if defined(bf_mat_contratos) &then
                        ordem-compra.nr-contrato = 0
                    &else
                        ordem-compra.nr-contrato = "" 
                    &endif
                     then do:
                        /* mensagem: Situacao da ordem nao permite eliminacao */
                            {method/svc/errors/inserr.i &ErrorNumber="5987"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U}
                    end.
               end.
               else do:
                    if  ordem-compra.situacao = 6 and 
                    &if defined(bf_mat_contratos) &then
                        ordem-compra.nr-contrato = 0
                    &else
                        ordem-compra.nr-contrato = "" 
                    &endif
                     then do:
                        /* mensagem: Situacao da ordem nao permite eliminacao */
                            {method/svc/errors/inserr.i &ErrorNumber="5987"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U}
                    end.
               end.
            end.
            /*************************** In°cio chamada EPC ****************************/
            {include/i-epc200.i2 &CodEvent='"afterValidateDeleteRecord"'
                                 &CodParameter='"OBJECT-HANDLE"'
                                 &ValueParameter="string(this-procedure)"} 
            {include/i-epc201.i "afterValidateDeleteRecord"}
            /**************************** Fim chamada EPC ******************************/
        END.

        /*--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

