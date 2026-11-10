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
{include/i-prgvrs.i BOIN404EB 2.00.00.002} /*** "010002" 13/11/2023 11:45:49 ***/
/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN404
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName saldo-terc
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin404eb.i RowObject}
{inbo/boin404eb.i tt-saldo-terc-aux1}
{inbo/boin404eb.i tt-saldo-terc-aux2}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def var iemitente as int no-undo.
def var c-it-codigo as char no-undo.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaSaldoTercAux DBOProgram 
PROCEDURE criaSaldoTercAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output param table for tt-saldo-terc-aux1.
def input-output param table for tt-saldo-terc-aux2.
def input param r-row as rowid no-undo.

find tt-saldo-terc-aux1 where tt-saldo-terc-aux1.r-rowid = r-row no-error.
if avail tt-saldo-terc-aux1 then do:
   find tt-saldo-terc-aux2 where tt-saldo-terc-aux2.serie-docto = tt-saldo-terc-aux1.serie-docto and
                                 tt-saldo-terc-aux2.nro-docto = tt-saldo-terc-aux1.nro-docto and
                                 tt-saldo-terc-aux2.cod-emitente = tt-saldo-terc-aux1.cod-emitente and
                                 tt-saldo-terc-aux2.nat-operacao = tt-saldo-terc-aux1.nat-operacao and
                                 tt-saldo-terc-aux2.it-codigo = tt-saldo-terc-aux1.it-codigo and
                                 tt-saldo-terc-aux2.cod-refer = tt-saldo-terc-aux1.cod-refer no-error.
   if not avail tt-saldo-terc-aux2 then do:
    create tt-saldo-terc-aux2.
    buffer-copy tt-saldo-terc-aux1 to tt-saldo-terc-aux2.
    assign tt-saldo-terc-aux1.quantidade = 0.
   end. 
end.

/*find first tt-saldo-terc-aux where tt-saldo-terc-aux.r-rowid = r-row-saldo-terc no-error.
 * if avail tt-saldo-terc-aux then do:
 *    find first tt-item-estrut where tt-item-estrut.it-codigo = tt-saldo-terc-aux.it-codigo no-error. 
 *     if avail tt-item-estrut then do:
 *        find first item where item.it-codigo = tt-item-estrut.it-codigo no-error.
 *         find last tt-componente-aux no-error.
 *             if not avail tt-componente-aux then do:
 *                ASSIGN cont = 1.
 *              end.  
 *             else do:
 *                assign cont = tt-componente-aux.sequencia + 1.
 *             end.
 *          find  tt-componente-aux where 
 *                tt-componente-aux.serie-docto  = tt-saldo-terc-aux.serie-docto and
 *                tt-componente-aux.nro-docto    = tt-saldo-terc-aux.nro-docto and                     
 *                tt-componente-aux.cod-emitente = tt-saldo-terc-aux.cod-emitente and
 *                tt-componente-aux.nat-operacao = tt-saldo-terc-aux.nat-operacao and
 *                tt-componente-aux.it-codigo    = tt-saldo-terc-aux.it-codigo and
 *                tt-componente-aux.cod-refer    = tt-saldo-terc-aux.cod-refer and 
 *                tt-componente-aux.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio and
 *                tt-componente-aux.int-1              = i-it-docto-seq no-error.
 *          if not avail tt-componente-aux then do:
 *             create tt-componente-aux.
 *             assign tt-componente-aux.int-1              = i-it-docto-seq
 *                    tt-componente-aux.it-codigo          = tt-saldo-terc-aux.it-codigo
 *                    tt-componente-aux.un                 = if avail item then item.un else ""
 *                    tt-componente-aux.r-row-saldo-terc   = r-row-saldo-terc
 *                    tt-componente-aux.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio
 *                    tt-componente-aux.cod-emitente       = tt-saldo-terc-aux.cod-emitente
 *                    tt-componente-aux.nro-docto           = tt-saldo-terc-aux.nro-docto
 *                    tt-componente-aux.serie-docto        = tt-saldo-terc-aux.serie-docto
 *                    tt-componente-aux.nat-operacao       = tt-saldo-terc-aux.nat-operacao
 *                    tt-componente-aux.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio
 *                    tt-componente-aux.cod-refer          = tt-saldo-terc-aux.cod-refer
 *                    tt-componente-aux.sequencia          = cont
 *                    tt-componente-aux.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio.
 *             if tt-saldo-terc-aux.quantidade < qtfaturar then
 *                assign tt-componente-aux.quantidade = tt-saldo-terc-aux.quantidade
 *                       tt-saldo-terc-aux.quantidade = (tt-saldo-terc-aux.quantidade - tt-componente-aux.quantidade).
 *             else assign tt-componente-aux.quantidade = if avail tt-item-estrut then (tt-item-estrut.quantidade * d-qt-pedida) else 0
 *                         tt-saldo-terc-aux.quantidade = (tt-saldo-terc-aux.quantidade - tt-componente-aux.quantidade).
 *             assign tt-componente-aux.log-1 = yes.           
 *          end. 
 *  end.                     
 * end.         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaSaldoTercAux DBOProgram 
PROCEDURE eliminaSaldoTercAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output param table for tt-saldo-terc-aux1.
def input-output param table for tt-saldo-terc-aux2.
def input param r-row as rowid no-undo.

find tt-saldo-terc-aux1 where tt-saldo-terc-aux1.r-rowid = r-row no-error.
if avail tt-saldo-terc-aux1 then do:
   find tt-saldo-terc-aux2 where tt-saldo-terc-aux2.serie-docto = tt-saldo-terc-aux1.serie-docto and
                                 tt-saldo-terc-aux2.nro-docto = tt-saldo-terc-aux1.nro-docto and
                                 tt-saldo-terc-aux2.cod-emitente = tt-saldo-terc-aux1.cod-emitente and
                                 tt-saldo-terc-aux2.nat-operacao = tt-saldo-terc-aux1.nat-operacao and
                                 tt-saldo-terc-aux2.it-codigo = tt-saldo-terc-aux1.it-codigo and
                                 tt-saldo-terc-aux2.cod-refer = tt-saldo-terc-aux1.cod-refer no-error.
   if avail tt-saldo-terc-aux2 then
      assign tt-saldo-terc-aux2.quantidade = tt-saldo-terc-aux2.quantidade + tt-saldo-terc-aux1.quantidade.
   delete tt-saldo-terc-aux1.
end.



/*def input param c-item as char no-undo.
 * def input param c-ato  as char no-undo.
 * def input param i-seq as int no-undo.
 * def input-output param table for tt-componente-aux.
 * def input-output param table for tt-saldo-terc-aux.
 * def input param r-row-componente as rowid no-undo.
 * 
 * find first tt-componente-aux where tt-componente-aux.it-codigo = c-item and
 *                                    tt-componente-aux.nr-ato-concessorio = c-ato and
 *                                    tt-componente-aux.sequencia = i-seq no-error.
 * if avail tt-componente-aux then do:
 *      find first tt-saldo-terc-aux where 
 *                 tt-saldo-terc-aux.serie-docto   = tt-componente-aux.serie-docto and
 *                 tt-saldo-terc-aux.nro-docto     = tt-componente-aux.nro-docto and
 *                 tt-saldo-terc-aux.cod-emitente  = tt-componente-aux.cod-emitente and
 *                 tt-saldo-terc-aux.nat-operacao  = tt-componente-aux.nat-operacao and 
 *                 tt-saldo-terc-aux.it-codigo     = tt-componente-aux.it-codigo and
 *                 tt-saldo-terc-aux.cod-refer     = tt-componente-aux.cod-refer and
 *                 tt-saldo-terc-aux.nr-ato-concessorio = tt-componente-aux.nr-ato-concessorio no-error.
 *      if avail tt-saldo-terc-aux then 
 *         assign tt-saldo-terc-aux.quantidade = (tt-saldo-terc-aux.quantidade + tt-componente-aux.quantidade).
 *    assign tt-componente-aux.log-1 = no.     
 *    delete tt-componente-aux.
 *    run openQuery (input 1).
 * end.         */


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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desp-cons":U THEN ASSIGN pFieldValue = RowObject.desp-cons.
        WHEN "qt-aloca-trans":U THEN ASSIGN pFieldValue = RowObject.qt-aloca-trans.
        WHEN "qtd-ini":U THEN ASSIGN pFieldValue = RowObject.qtd-ini.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "sald-ini-mat":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat.
        WHEN "sald-ini-mob":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob.
        WHEN "valor[1]":U THEN ASSIGN pFieldValue = RowObject.valor[1].
        WHEN "valor[2]":U THEN ASSIGN pFieldValue = RowObject.valor[2].
        WHEN "valor[3]":U THEN ASSIGN pFieldValue = RowObject.valor[3].
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-icm[1]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[1].
        WHEN "valor-icm[2]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[2].
        WHEN "valor-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[1].
        WHEN "valor-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[2].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[1].
        WHEN "valor-mob[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[2].
        WHEN "valor-mob[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "vl-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-icm-cmi.
        WHEN "vl-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-cmi.
        WHEN "vl-saldo-mat":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-mat.
        WHEN "vl-saldo-mob":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-mob.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo-sal-terc":U THEN ASSIGN pFieldValue = RowObject.tipo-sal-terc.
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
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE saldo-terc.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE saldo-terc.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.

    FIND FIRST bfsaldo-terc WHERE 
        bfsaldo-terc.serie-docto = pserie-docto AND 
        bfsaldo-terc.nro-docto = pnro-docto AND 
        bfsaldo-terc.cod-emitente = pcod-emitente AND 
        bfsaldo-terc.nat-operacao = pnat-operacao AND 
        bfsaldo-terc.it-codigo = pit-codigo AND 
        bfsaldo-terc.cod-refer = pcod-refer AND 
        bfsaldo-terc.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsaldo-terc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsaldo-terc)).
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

  open query qr{&tableName} for each {&tableName} no-lock indexed-reposition.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySaldoNotas DBOProgram 
PROCEDURE openQuerySaldoNotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} where {&tableName}.it-codigo = c-it-codigo and
                                                        {&tableName}.cod-emitente = iEmitente and
                                                        {&tableName}.quantidade <> 0 indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSaldoNotas DBOProgram 
PROCEDURE setConstraintSaldoNotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: chamada pelo eb0107.w       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pitem          AS char      NO-UNDO.
    DEFINE INPUT PARAMETER pEmitente      AS INTEGER   NO-UNDO.
    
    assign iEmitente     =  pEmitente
           c-it-codigo   =  pitem.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


