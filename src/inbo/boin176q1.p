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
{include/i-prgvrs.i BOIN176Q1 2.00.00.007} /*** "010007" 17/06/2025 16:40:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin176q1 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN176
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-doc-est
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE Change-query-to-find TRUE
&GLOBAL-DEFINE Change-query-to-find-procs OfDocumEst,Main 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin176.i RowObject}
{inbo/boin176.i RowObject-aux}
{cdp/cdcfgdis.i}
{cdp/cdapi600.i &Item-doc-est="YES"}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-cod-emitente    as int      no-undo.
def var c-serie-docto     as char     no-undo.
def var c-nro-docto       as char     no-undo.
def var c-nat-operacao    as char     no-undo.
DEF VAR r-varRowid        AS ROWID    NO-UNDO.

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
   Other Settings: CODE-ONLY COMPILE
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


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsTMS DBOProgram 
PROCEDURE getBatchRecordsTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-doc-est.

    DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.

    FOR EACH tt-item-doc-est EXCLUSIVE-LOCK:
        DELETE tt-item-doc-est.
    END.

    RUN getBatchRecords IN THIS-PROCEDURE (INPUT ?,
                                           INPUT NO,
                                           INPUT 999999,
                                           OUTPUT iCont,
                                           OUTPUT TABLE RowObject-aux).

    FOR EACH RowObject-aux NO-LOCK:
        CREATE tt-item-doc-est.
        BUFFER-COPY RowObject-aux TO tt-item-doc-est.
    END.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "c-nr-invoice":U THEN ASSIGN pFieldValue = RowObject.c-nr-invoice.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "est-cob":U THEN ASSIGN pFieldValue = RowObject.est-cob.
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-of":U THEN ASSIGN pFieldValue = RowObject.nat-of.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nivel-restituicao":U THEN ASSIGN pFieldValue = RowObject.nivel-restituicao.
        WHEN "nr-docto-ap":U THEN ASSIGN pFieldValue = RowObject.nr-docto-ap.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nro-comp":U THEN ASSIGN pFieldValue = RowObject.nro-comp.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "serie-comp":U THEN ASSIGN pFieldValue = RowObject.serie-comp.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data":U THEN ASSIGN pFieldValue = RowObject.data.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-comp":U THEN ASSIGN pFieldValue = RowObject.data-comp.
        WHEN "dt-ent-prev":U THEN ASSIGN pFieldValue = RowObject.dt-ent-prev.
        WHEN "dt-nota-comp":U THEN ASSIGN pFieldValue = RowObject.dt-nota-comp.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "base-icm[1]":U THEN ASSIGN pFieldValue = RowObject.base-icm[1].
        WHEN "base-icm[2]":U THEN ASSIGN pFieldValue = RowObject.base-icm[2].
        WHEN "base-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.base-icm-cmi.
        WHEN "base-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.base-ipi[1].
        WHEN "base-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.base-ipi[2].
        WHEN "base-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.base-ipi-cmi.
        WHEN "base-iss[1]":U THEN ASSIGN pFieldValue = RowObject.base-iss[1].
        WHEN "base-iss[2]":U THEN ASSIGN pFieldValue = RowObject.base-iss[2].
        WHEN "base-iss-cmi":U THEN ASSIGN pFieldValue = RowObject.base-iss-cmi.
        WHEN "base-subs[1]":U THEN ASSIGN pFieldValue = RowObject.base-subs[1].
        WHEN "base-subs[2]":U THEN ASSIGN pFieldValue = RowObject.base-subs[2].
        WHEN "base-subs-cmi":U THEN ASSIGN pFieldValue = RowObject.base-subs-cmi.
        WHEN "cota-moeda[1]":U THEN ASSIGN pFieldValue = RowObject.cota-moeda[1].
        WHEN "cota-moeda[2]":U THEN ASSIGN pFieldValue = RowObject.cota-moeda[2].
        WHEN "cotacao-alt[1]":U THEN ASSIGN pFieldValue = RowObject.cotacao-alt[1].
        WHEN "cotacao-alt[2]":U THEN ASSIGN pFieldValue = RowObject.cotacao-alt[2].
        WHEN "cotacao-cmi":U THEN ASSIGN pFieldValue = RowObject.cotacao-cmi.
        WHEN "cotacao-fasb":U THEN ASSIGN pFieldValue = RowObject.cotacao-fasb.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desconto[1]":U THEN ASSIGN pFieldValue = RowObject.desconto[1].
        WHEN "desconto[2]":U THEN ASSIGN pFieldValue = RowObject.desconto[2].
        WHEN "desconto-cmi":U THEN ASSIGN pFieldValue = RowObject.desconto-cmi.
        WHEN "desconto-me":U THEN ASSIGN pFieldValue = RowObject.desconto-me.
        WHEN "despesas[1]":U THEN ASSIGN pFieldValue = RowObject.despesas[1].
        WHEN "despesas[2]":U THEN ASSIGN pFieldValue = RowObject.despesas[2].
        WHEN "despesas-cmi":U THEN ASSIGN pFieldValue = RowObject.despesas-cmi.
        WHEN "icm-comp-cmi":U THEN ASSIGN pFieldValue = RowObject.icm-comp-cmi.
        WHEN "icm-complem[1]":U THEN ASSIGN pFieldValue = RowObject.icm-complem[1].
        WHEN "icm-complem[2]":U THEN ASSIGN pFieldValue = RowObject.icm-complem[2].
        WHEN "icm-ntr-cmi":U THEN ASSIGN pFieldValue = RowObject.icm-ntr-cmi.
        WHEN "icm-ntrib[1]":U THEN ASSIGN pFieldValue = RowObject.icm-ntrib[1].
        WHEN "icm-ntrib[2]":U THEN ASSIGN pFieldValue = RowObject.icm-ntrib[2].
        WHEN "icm-out-cmi":U THEN ASSIGN pFieldValue = RowObject.icm-out-cmi.
        WHEN "icm-outras[1]":U THEN ASSIGN pFieldValue = RowObject.icm-outras[1].
        WHEN "icm-outras[2]":U THEN ASSIGN pFieldValue = RowObject.icm-outras[2].
        WHEN "ipi-ntr-cmi":U THEN ASSIGN pFieldValue = RowObject.ipi-ntr-cmi.
        WHEN "ipi-ntrib[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-ntrib[1].
        WHEN "ipi-ntrib[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-ntrib[2].
        WHEN "ipi-out-cmi":U THEN ASSIGN pFieldValue = RowObject.ipi-out-cmi.
        WHEN "ipi-outras[1]":U THEN ASSIGN pFieldValue = RowObject.ipi-outras[1].
        WHEN "ipi-outras[2]":U THEN ASSIGN pFieldValue = RowObject.ipi-outras[2].
        WHEN "iss-ntr-cmi":U THEN ASSIGN pFieldValue = RowObject.iss-ntr-cmi.
        WHEN "iss-ntrib[1]":U THEN ASSIGN pFieldValue = RowObject.iss-ntrib[1].
        WHEN "iss-ntrib[2]":U THEN ASSIGN pFieldValue = RowObject.iss-ntrib[2].
        WHEN "iss-out-cmi":U THEN ASSIGN pFieldValue = RowObject.iss-out-cmi.
        WHEN "iss-outras[1]":U THEN ASSIGN pFieldValue = RowObject.iss-outras[1].
        WHEN "iss-outras[2]":U THEN ASSIGN pFieldValue = RowObject.iss-outras[2].
        WHEN "pc-restituicao":U THEN ASSIGN pFieldValue = RowObject.pc-restituicao.
        WHEN "perc-isr":U THEN ASSIGN pFieldValue = RowObject.perc-isr.
        WHEN "perc-sales-tax":U THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
        WHEN "perc-vat":U THEN ASSIGN pFieldValue = RowObject.perc-vat.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "pr-mob-cmi":U THEN ASSIGN pFieldValue = RowObject.pr-mob-cmi.
        WHEN "pr-total[1]":U THEN ASSIGN pFieldValue = RowObject.pr-total[1].
        WHEN "pr-total[2]":U THEN ASSIGN pFieldValue = RowObject.pr-total[2].
        WHEN "pr-total[3]":U THEN ASSIGN pFieldValue = RowObject.pr-total[3].
        WHEN "pr-total-cmi":U THEN ASSIGN pFieldValue = RowObject.pr-total-cmi.
        WHEN "pr-unit-cmi":U THEN ASSIGN pFieldValue = RowObject.pr-unit-cmi.
        WHEN "pre-unit-mob[1]":U THEN ASSIGN pFieldValue = RowObject.pre-unit-mob[1].
        WHEN "pre-unit-mob[2]":U THEN ASSIGN pFieldValue = RowObject.pre-unit-mob[2].
        WHEN "preco-fatura":U THEN ASSIGN pFieldValue = RowObject.preco-fatura.
        WHEN "preco-total[1]":U THEN ASSIGN pFieldValue = RowObject.preco-total[1].
        WHEN "preco-total[2]":U THEN ASSIGN pFieldValue = RowObject.preco-total[2].
        WHEN "preco-total-alt[1]":U THEN ASSIGN pFieldValue = RowObject.preco-total-alt[1].
        WHEN "preco-total-alt[2]":U THEN ASSIGN pFieldValue = RowObject.preco-total-alt[2].
        WHEN "preco-total-me":U THEN ASSIGN pFieldValue = RowObject.preco-total-me.
        WHEN "preco-unit[1]":U THEN ASSIGN pFieldValue = RowObject.preco-unit[1].
        WHEN "preco-unit[2]":U THEN ASSIGN pFieldValue = RowObject.preco-unit[2].
        WHEN "preco-unit-me":U THEN ASSIGN pFieldValue = RowObject.preco-unit-me.
        WHEN "qt-do-forn":U THEN ASSIGN pFieldValue = RowObject.qt-do-forn.
        WHEN "qt-real":U THEN ASSIGN pFieldValue = RowObject.qt-real.
        WHEN "qt-saldo":U THEN ASSIGN pFieldValue = RowObject.qt-saldo.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "valor-icm[1]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[1].
        WHEN "valor-icm[2]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[2].
        WHEN "valor-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[1].
        WHEN "valor-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[2].
        WHEN "valor-iss[1]":U THEN ASSIGN pFieldValue = RowObject.valor-iss[1].
        WHEN "valor-iss[2]":U THEN ASSIGN pFieldValue = RowObject.valor-iss[2].
        WHEN "vl-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-icm-cmi.
        WHEN "vl-imp-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-imp-cmi.
        WHEN "vl-imp-impor[1]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[1].
        WHEN "vl-imp-impor[2]":U THEN ASSIGN pFieldValue = RowObject.vl-imp-impor[2].
        WHEN "vl-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-cmi.
        WHEN "vl-isr":U THEN ASSIGN pFieldValue = RowObject.vl-isr.
        WHEN "vl-iss-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-iss-cmi.
        WHEN "vl-subs[1]":U THEN ASSIGN pFieldValue = RowObject.vl-subs[1].
        WHEN "vl-subs[2]":U THEN ASSIGN pFieldValue = RowObject.vl-subs[2].
        WHEN "vl-subs-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-subs-cmi.
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
        WHEN "vl-taxa-me":U THEN ASSIGN pFieldValue = RowObject.vl-taxa-me.
        WHEN "vl-unit-mob":U THEN ASSIGN pFieldValue = RowObject.vl-unit-mob.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
        WHEN "cod-emit-benef":U THEN ASSIGN pFieldValue = RowObject.cod-emit-benef.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-isr":U THEN ASSIGN pFieldValue = RowObject.cod-tax-isr.
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        WHEN "emite-comp":U THEN ASSIGN pFieldValue = RowObject.emite-comp.
        WHEN "etiquetas":U THEN ASSIGN pFieldValue = RowObject.etiquetas.
        WHEN "flag-atu":U THEN ASSIGN pFieldValue = RowObject.flag-atu.
        WHEN "fn-docto-ap":U THEN ASSIGN pFieldValue = RowObject.fn-docto-ap.
        WHEN "i-nr-gi":U THEN ASSIGN pFieldValue = RowObject.i-nr-gi.
        WHEN "i-seq-inv":U THEN ASSIGN pFieldValue = RowObject.i-seq-inv.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-ord-prod":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-pd-ent":U THEN ASSIGN pFieldValue = RowObject.nr-pd-ent.
        WHEN "nr-pd-seq":U THEN ASSIGN pFieldValue = RowObject.nr-pd-seq.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "qt-etiquetas":U THEN ASSIGN pFieldValue = RowObject.qt-etiquetas.
        WHEN "seq-comp":U THEN ASSIGN pFieldValue = RowObject.seq-comp.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-item":U THEN ASSIGN pFieldValue = RowObject.sit-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE item-doc-est.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE item-doc-est.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE item-doc-est.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "atualiza-pa":U THEN ASSIGN pFieldValue = RowObject.atualiza-pa.
        WHEN "baixa-ce":U THEN ASSIGN pFieldValue = RowObject.baixa-ce.
        WHEN "componente":U THEN ASSIGN pFieldValue = RowObject.componente.
        WHEN "encerra-pa":U THEN ASSIGN pFieldValue = RowObject.encerra-pa.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "reabre-pa":U THEN ASSIGN pFieldValue = RowObject.reabre-pa.
        WHEN "reabre-pd":U THEN ASSIGN pFieldValue = RowObject.reabre-pd.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordTMS DBOProgram 
PROCEDURE getRecordTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-doc-est.

    FOR EACH tt-item-doc-est:
        DELETE tt-item-doc-est.
    END.

    CREATE tt-item-doc-est.
    BUFFER-COPY RowObject TO tt-item-doc-est.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE item-doc-est.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE item-doc-est.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE item-doc-est.sequencia NO-UNDO.

    FIND FIRST bfitem-doc-est WHERE 
        bfitem-doc-est.serie-docto = pserie-docto AND 
        bfitem-doc-est.nro-docto = pnro-docto AND 
        bfitem-doc-est.cod-emitente = pcod-emitente AND 
        bfitem-doc-est.nat-operacao = pnat-operacao AND 
        bfitem-doc-est.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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

    OPEN QUERY {&QueryName}
        FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH {&TableName} NO-LOCK 
            WHERE ROWID({&TableName}) = r-varRowid INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE FindFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE FindNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE FindPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE FindLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
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
           no-lock 
           indexed-reposition.
       

       

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE FindFirstOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName}
        where {&tableName}.cod-emitente = i-cod-emitente
        and   {&tableName}.serie-docto  = c-serie-docto
        and   {&tableName}.nro-docto    = c-nro-docto
        and   {&tableName}.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE FindNextOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&tableName}
        where {&tableName}.cod-emitente = i-cod-emitente
        and   {&tableName}.serie-docto  = c-serie-docto
        and   {&tableName}.nro-docto    = c-nro-docto
        and   {&tableName}.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE FindPrevOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&tableName}
        where {&tableName}.cod-emitente = i-cod-emitente
        and   {&tableName}.serie-docto  = c-serie-docto
        and   {&tableName}.nro-docto    = c-nro-docto
        and   {&tableName}.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE FindLastOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&tableName}
        where {&tableName}.cod-emitente = i-cod-emitente
        and   {&tableName}.serie-docto  = c-serie-docto
        and   {&tableName}.nro-docto    = c-nro-docto
        and   {&tableName}.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.

        assign i-cod-emitente = i-cod-emit
               c-serie-docto  = c-ser-docto
               c-nro-docto    = c-nr-docto
               c-nat-operacao = c-nat-oper.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rowid  as ROWID  NO-UNDO.
    
    ASSIGN r-varRowid = p-rowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocumEst DBOProgram 
PROCEDURE linkToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pHandle as handle no-undo.

    if valid-handle(pHandle) then
        run getKey in pHandle ( output c-serie-docto,
                                output c-nro-docto,
                                output i-cod-emitente,
                                output c-nat-operacao ).

    RETURN "OK":U.                              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRecordTMS DBOProgram 
PROCEDURE setRecordTMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-item-doc-est.

        FOR EACH RowObject:
            DELETE ROwObject.
        END.

        FOR EACH tt-item-doc-est:
            CREATE RowObject.
            BUFFER-COPY tt-item-doc-est TO RowObject.
        END.
        
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

