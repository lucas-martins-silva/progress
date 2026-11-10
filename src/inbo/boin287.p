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
{include/i-prgvrs.i BOIN287 2.00.00.025 } /*** "010025" 01/12/2023 10:51:01  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin287 MUT}
&ENDIF

{cdp/cdcfgmat.i}
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
{cdp/cdcfgdis.i}
/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName param-estoq
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName param-estoq
&GLOBAL-DEFINE TableLabel param-estoq
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin287.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE creturn  AS CHARACTER NO-UNDO.

{utp/ut-glob.i}
&IF "{&mguni_version}" >= "2.071" &THEN
DEF VAR c-cod-estabel-usuar AS CHAR format "x(05)".
&ELSE
DEF VAR c-cod-estabel-usuar AS CHAR FORMAT "x(03)".
&ENDIF

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
         HEIGHT             = 10.21
         WIDTH              = 47.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParam_ce DBOProgram 
PROCEDURE findParam_ce :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
   
    def input parameter pcfm-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
    
    RUN openQueryStatic (input "main":U).
    run goToKey (input pcfm-codigo).

        if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign creturn = return-value.
    end.
    
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        &if defined(bf-mat-comex) &then
            WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
        &else
            WHEN "ct-tr-dev-cli":U THEN ASSIGN pFieldValue = string(RowObject.ct-tr-dev-cli).
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
            WHEN "conta-terceiros":U THEN ASSIGN pFieldValue = RowObject.conta-terceiros.
            WHEN "conta-transf":U THEN ASSIGN pFieldValue = RowObject.conta-transf.
            WHEN "conta-acerto":U THEN ASSIGN pFieldValue = RowObject.conta-acerto.
            WHEN "conta-ativo":U THEN ASSIGN pFieldValue = RowObject.conta-ativo.
            WHEN "conta-aux[01]":U THEN ASSIGN pFieldValue = RowObject.conta-aux[01].
            WHEN "conta-aux[02]":U THEN ASSIGN pFieldValue = RowObject.conta-aux[02].
            WHEN "conta-aux[03]":U THEN ASSIGN pFieldValue = RowObject.conta-aux[03].
            WHEN "conta-aux[04]":U THEN ASSIGN pFieldValue = RowObject.conta-aux[04].
            WHEN "conta-aux[05]":U THEN ASSIGN pFieldValue = RowObject.conta-aux[05].
            WHEN "conta-consig":U THEN ASSIGN pFieldValue = RowObject.conta-consig.
            WHEN "conta-dev-cli":U THEN ASSIGN pFieldValue = RowObject.conta-dev-cli.   
            WHEN "conta-devol":U THEN ASSIGN pFieldValue = RowObject.conta-devol.
            WHEN "conta-fornec":U THEN ASSIGN pFieldValue = RowObject.conta-fornec.
            WHEN "conta-icm-comp":U THEN ASSIGN pFieldValue = RowObject.conta-icm-comp.
            WHEN "conta-inven-ent":U THEN ASSIGN pFieldValue = RowObject.conta-inven-ent.
            WHEN "conta-inven-sai":U THEN ASSIGN pFieldValue = RowObject.conta-inven-sai.
            WHEN "conta-mob":U THEN ASSIGN pFieldValue = RowObject.conta-mob.
            WHEN "conta-outros":U THEN ASSIGN pFieldValue = RowObject.conta-outros.                
            WHEN "ct-tr-devol":U THEN ASSIGN pFieldValue = RowObject.ct-tr-devol.
            WHEN "ct-tr-fornec":U THEN ASSIGN pFieldValue = RowObject.ct-tr-fornec.
            WHEN "ct-tr-mob":U THEN ASSIGN pFieldValue = RowObject.ct-tr-mob.
            WHEN "ct-tr-outros":U THEN ASSIGN pFieldValue = RowObject.ct-tr-outros.
            WHEN "ct-tr-transf":U THEN ASSIGN pFieldValue = RowObject.ct-tr-transf.
            WHEN "sc-acerto":U THEN ASSIGN pFieldValue = RowObject.sc-acerto.
            WHEN "sc-aux[01]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[01].
            WHEN "sc-aux[02]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[02].
            WHEN "sc-aux[03]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[03].
            WHEN "sc-aux[04]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[04].
            WHEN "sc-aux[05]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[05].            
            WHEN "sc-icms-comp":U THEN ASSIGN pFieldValue = RowObject.sc-icms-comp.
            WHEN "sc-inven-ent":U THEN ASSIGN pFieldValue = RowObject.sc-inven-ent.
            WHEN "sc-inven-sai":U THEN ASSIGN pFieldValue = RowObject.sc-inven-sai.
            WHEN "sc-terceiros":U THEN ASSIGN pFieldValue = RowObject.sc-terceiros.
            WHEN "sc-tr-ativo":U THEN ASSIGN pFieldValue = RowObject.sc-tr-ativo.
            WHEN "sc-tr-consig":U THEN ASSIGN pFieldValue = RowObject.sc-tr-consig.
            WHEN "sc-tr-dev-cli":U THEN ASSIGN pFieldValue = RowObject.sc-tr-dev-cli.
            WHEN "sc-tr-devol":U THEN ASSIGN pFieldValue = RowObject.sc-tr-devol.
            WHEN "sc-tr-fornec":U THEN ASSIGN pFieldValue = RowObject.sc-tr-fornec.
            WHEN "sc-tr-mob":U THEN ASSIGN pFieldValue = RowObject.sc-tr-mob.
            WHEN "sc-tr-outros":U THEN ASSIGN pFieldValue = RowObject.sc-tr-outros.
            WHEN "sc-tr-transf":U THEN ASSIGN pFieldValue = RowObject.sc-tr-transf.
            WHEN "ct-acerto":U THEN ASSIGN pFieldValue = RowObject.ct-acerto.
            WHEN "ct-aux[01]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[01].
            WHEN "ct-aux[02]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[02].
            WHEN "ct-aux[03]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[03].
            WHEN "ct-aux[04]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[04].
            WHEN "ct-aux[05]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[05].
            WHEN "ct-icms-comp":U THEN ASSIGN pFieldValue = RowObject.ct-icms-comp.
            WHEN "ct-inven-ent":U THEN ASSIGN pFieldValue = RowObject.ct-inven-ent.
            WHEN "ct-inven-sai":U THEN ASSIGN pFieldValue = RowObject.ct-inven-sai.
            WHEN "ct-terceiros":U THEN ASSIGN pFieldValue = RowObject.ct-terceiros.
            WHEN "ct-tr-ativo":U THEN ASSIGN pFieldValue = RowObject.ct-tr-ativo.
            WHEN "ct-tr-consig":U THEN ASSIGN pFieldValue = RowObject.ct-tr-consig.            
        &endif            
        WHEN "atual-cr":U THEN ASSIGN pFieldValue = RowObject.atual-cr.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "depos-pad":U THEN ASSIGN pFieldValue = RowObject.depos-pad.
        WHEN "estabel-pad":U THEN ASSIGN pFieldValue = RowObject.estabel-pad.
        WHEN "ult-per-fech":U THEN ASSIGN pFieldValue = RowObject.ult-per-fech.
        WHEN "contabilizou":U THEN ASSIGN pFieldValue = RowObject.contabilizou.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        &if defined(bf-mat-comex)
        &then
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
            WHEN "dia-fechado":U THEN ASSIGN pFieldValue = RowObject.dia-fechado.
            WHEN "mensal-ate":U THEN ASSIGN pFieldValue = RowObject.mensal-ate.
        &endif            
        WHEN "dt-ult-lcto":U THEN ASSIGN pFieldValue = RowObject.dt-ult-lcto.
        WHEN "ult-fech-dia":U THEN ASSIGN pFieldValue = RowObject.ult-fech-dia.
        WHEN "contab-ate":U THEN ASSIGN pFieldValue = RowObject.contab-ate.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-acum-a":U THEN ASSIGN pFieldValue = RowObject.perc-acum-a.
        WHEN "perc-acum-b":U THEN ASSIGN pFieldValue = RowObject.perc-acum-b.
        WHEN "perc-acum-c":U THEN ASSIGN pFieldValue = RowObject.perc-acum-c.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescMoedasAlternativasParamEstoq DBOProgram 
PROCEDURE getDescMoedasAlternativasParamEstoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* Retorna as descri‡äes da moeda corrente e das moedas 1 e 2 da param-estoq
      Parƒmetros:
      opar1  : p-c-desc-moeda1 : descri‡Æo da moeda corrente
      opar2  : p-c-desc-moeda1 : descri‡Æo da moeda 1
      opar3  : p-c-desc-moeda1 : descri‡Æo da moeda 2
      */
      define output parameter p-c-desc-mo-atu as char no-undo.
      define output parameter p-c-desc-moeda1 as char no-undo.
      define output parameter p-c-desc-moeda2 as char no-undo.

      find moeda where moeda.mo-codigo = 0 NO-LOCK no-error.
      if  avail moeda then assign p-c-desc-mo-atu = moeda.descricao. 

      find first param-estoq  no-lock no-error.
      if  param-estoq.tem-moeda1 then do:
          find moeda where moeda.mo-codigo = param-estoq.moeda1 NO-LOCK no-error.
          if  avail moeda then assign p-c-desc-moeda1 = moeda.descricao. 
      end.
      if  param-estoq.tem-moeda2 then do:
          find moeda where moeda.mo-codigo = param-estoq.moeda2 NO-LOCK no-error.
          if  avail moeda then assign p-c-desc-moeda2 = moeda.descricao.
      end.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        &if defined(bf-mat-comex)
        &then
            WHEN "ct-tr-dev-cli":U THEN ASSIGN pFieldValue = RowObject.ct-tr-dev-cli.            
            WHEN "ct-tr-devol":U THEN ASSIGN pFieldValue = RowObject.ct-tr-devol.
            WHEN "ct-tr-fornec":U THEN ASSIGN pFieldValue = RowObject.ct-tr-fornec.
            WHEN "ct-tr-mob":U THEN ASSIGN pFieldValue = RowObject.ct-tr-mob. 
            WHEN "ct-tr-outros":U THEN ASSIGN pFieldValue = RowObject.ct-tr-outros.
            WHEN "ct-tr-transf":U THEN ASSIGN pFieldValue = RowObject.ct-tr-transf.
            WHEN "sc-acerto":U THEN ASSIGN pFieldValue = RowObject.sc-acerto.
            WHEN "sc-aux[01]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[01].
            WHEN "sc-aux[02]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[02].
            WHEN "sc-aux[03]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[03].
            WHEN "sc-aux[04]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[04].
            WHEN "sc-aux[05]":U THEN ASSIGN pFieldValue = RowObject.sc-aux[05].    
            WHEN "sc-icms-comp":U THEN ASSIGN pFieldValue = RowObject.sc-icms-comp.
            WHEN "sc-inven-ent":U THEN ASSIGN pFieldValue = RowObject.sc-inven-ent.
            WHEN "sc-inven-sai":U THEN ASSIGN pFieldValue = RowObject.sc-inven-sai.                   
            WHEN "sc-terceiros":U THEN ASSIGN pFieldValue = RowObject.sc-terceiros.
            WHEN "sc-tr-ativo":U THEN ASSIGN pFieldValue = RowObject.sc-tr-ativo.
            WHEN "sc-tr-consig":U THEN ASSIGN pFieldValue = RowObject.sc-tr-consig.
            WHEN "sc-tr-dev-cli":U THEN ASSIGN pFieldValue = RowObject.sc-tr-dev-cli.
            WHEN "sc-tr-devol":U THEN ASSIGN pFieldValue = RowObject.sc-tr-devol.
            WHEN "sc-tr-fornec":U THEN ASSIGN pFieldValue = RowObject.sc-tr-fornec.
            WHEN "sc-tr-mob":U THEN ASSIGN pFieldValue = RowObject.sc-tr-mob.
            WHEN "sc-tr-outros":U THEN ASSIGN pFieldValue = RowObject.sc-tr-outros.
            WHEN "sc-tr-transf":U THEN ASSIGN pFieldValue = RowObject.sc-tr-transf.            
            WHEN "ct-acerto":U THEN ASSIGN pFieldValue = RowObject.ct-acerto.
            WHEN "ct-aux[01]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[01].
            WHEN "ct-aux[02]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[02].
            WHEN "ct-aux[03]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[03].
            WHEN "ct-aux[04]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[04].
            WHEN "ct-aux[05]":U THEN ASSIGN pFieldValue = RowObject.ct-aux[05].
            WHEN "ct-icms-comp":U THEN ASSIGN pFieldValue = RowObject.ct-icms-comp.
            WHEN "ct-inven-ent":U THEN ASSIGN pFieldValue = RowObject.ct-inven-ent.
            WHEN "ct-inven-sai":U THEN ASSIGN pFieldValue = RowObject.ct-inven-sai.
            WHEN "ct-terceiros":U THEN ASSIGN pFieldValue = RowObject.ct-terceiros.
            WHEN "ct-tr-ativo":U THEN ASSIGN pFieldValue = RowObject.ct-tr-ativo.
        &else
            WHEN "acerto-aut":U THEN ASSIGN pFieldValue = RowObject.acerto-aut.
            WHEN "cons-invent":U THEN ASSIGN pFieldValue = RowObject.cons-invent.
            WHEN "fase-contab":U THEN ASSIGN pFieldValue = RowObject.fase-contab.
            WHEN "nr-ult-peca":U THEN ASSIGN pFieldValue = RowObject.nr-ult-peca.
            WHEN "num-dec":U THEN ASSIGN pFieldValue = RowObject.num-dec.
            WHEN "seq-param-ce":U THEN ASSIGN pFieldValue = RowObject.seq-param-ce.
            WHEN "tip-calc-med":U THEN ASSIGN pFieldValue = RowObject.tip-calc-med.
            WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
            WHEN "tipo-pr-med":U THEN ASSIGN pFieldValue = RowObject.tipo-pr-med.
            WHEN "tp-fech":U THEN ASSIGN pFieldValue = RowObject.tp-fech.
            WHEN "conv-imposto":U THEN ASSIGN pFieldValue = RowObject.conv-imposto.
        &endif    
        WHEN "com-an-lote":U THEN ASSIGN pFieldValue = RowObject.com-an-lote.
        WHEN "com-an-reje":U THEN ASSIGN pFieldValue = RowObject.com-an-reje.
        WHEN "com-na-lote":U THEN ASSIGN pFieldValue = RowObject.com-na-lote.
        WHEN "com-na-reje":U THEN ASSIGN pFieldValue = RowObject.com-na-reje.
        WHEN "com-ns-lote":U THEN ASSIGN pFieldValue = RowObject.com-ns-lote.
        WHEN "com-ns-reje":U THEN ASSIGN pFieldValue = RowObject.com-ns-reje.
        WHEN "com-sn-lote":U THEN ASSIGN pFieldValue = RowObject.com-sn-lote.
        WHEN "com-sn-reje":U THEN ASSIGN pFieldValue = RowObject.com-sn-reje.
        WHEN "dias-max-a":U THEN ASSIGN pFieldValue = RowObject.dias-max-a.
        WHEN "dias-max-b":U THEN ASSIGN pFieldValue = RowObject.dias-max-b.
        WHEN "dias-max-c":U THEN ASSIGN pFieldValue = RowObject.dias-max-c.
        WHEN "dias-min-a":U THEN ASSIGN pFieldValue = RowObject.dias-min-a.
        WHEN "dias-min-b":U THEN ASSIGN pFieldValue = RowObject.dias-min-b.
        WHEN "dias-min-c":U THEN ASSIGN pFieldValue = RowObject.dias-min-c.
        WHEN "fator-ponder[01]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[01].
        WHEN "fator-ponder[02]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[02].
        WHEN "fator-ponder[03]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[03].
        WHEN "fator-ponder[04]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[04].
        WHEN "fator-ponder[05]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[05].
        WHEN "fator-ponder[06]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[06].
        WHEN "ins-pref-x[01]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-x[01].
        WHEN "ins-pref-x[02]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-x[02].
        WHEN "ins-pref-x[03]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-x[03].
        WHEN "ins-pref-y[01]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-y[01].
        WHEN "ins-pref-y[02]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-y[02].
        WHEN "ins-pref-y[03]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-y[03].
        WHEN "ins-pref-z[01]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-z[01].
        WHEN "ins-pref-z[02]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-z[02].
        WHEN "ins-pref-z[03]":U THEN ASSIGN pFieldValue = RowObject.ins-pref-z[03].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "moeda1":U THEN ASSIGN pFieldValue = RowObject.moeda1.
        WHEN "moeda2":U THEN ASSIGN pFieldValue = RowObject.moeda2.
        WHEN "nr-ord-per":U THEN ASSIGN pFieldValue = RowObject.nr-ord-per.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "pg-diario":U THEN ASSIGN pFieldValue = RowObject.pg-diario.
        WHEN "termo-abe":U THEN ASSIGN pFieldValue = RowObject.termo-abe.
        WHEN "termo-enc":U THEN ASSIGN pFieldValue = RowObject.termo-enc.
        WHEN "tipo-cq":U THEN ASSIGN pFieldValue = RowObject.tipo-cq.
        WHEN "tp-ct-moeda1":U THEN ASSIGN pFieldValue = RowObject.tp-ct-moeda1.
        WHEN "tp-ct-moeda2":U THEN ASSIGN pFieldValue = RowObject.tp-ct-moeda2.
        WHEN "ult-num-seq":U THEN ASSIGN pFieldValue = RowObject.ult-num-seq.
        WHEN "ult-pg-diario":U THEN ASSIGN pFieldValue = RowObject.ult-pg-diario.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice PARAM-CE
  Parameters:
               retorna valor dos campos do ­ndice PARAM-CE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex)
    &then
    &else
         DEFINE OUTPUT PARAMETER pseq-param-ce LIKE param-estoq.seq-param-ce NO-UNDO.
     
         /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
               retornada flag "NOK":U ---*/
         IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.
     
         ASSIGN pseq-param-ce = RowObject.seq-param-ce.
    &endif
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        &if defined(bf-mat-comex)
        &then
            WHEN "cons-invent":U THEN ASSIGN pFieldValue = RowObject.cons-invent.
            WHEN "gera-ap":U THEN ASSIGN pFieldValue = RowObject.gera-ap.
            WHEN "gera-contab":U THEN ASSIGN pFieldValue = RowObject.gera-contab.
            WHEN "tip-calc-med":U THEN ASSIGN pFieldValue = RowObject.tip-calc-med.
            WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
            WHEN "tipo-pr-med":U THEN ASSIGN pFieldValue = RowObject.tipo-pr-med.
            WHEN "conv-imposto":U THEN ASSIGN pFieldValue = RowObject.conv-imposto.
        &else
            WHEN "medio-global":U THEN ASSIGN pFieldValue = RowObject.medio-global.
            WHEN "pm-ja-ini":U THEN ASSIGN pFieldValue = RowObject.pm-ja-ini.
        &endif            
        
        WHEN "atualizado":U THEN ASSIGN pFieldValue = RowObject.atualizado.
        WHEN "bxa-con":U THEN ASSIGN pFieldValue = RowObject.bxa-con.
        WHEN "estab-uni":U THEN ASSIGN pFieldValue = RowObject.estab-uni.
        WHEN "extorna-cr":U THEN ASSIGN pFieldValue = RowObject.extorna-cr.
        WHEN "fec-ja-ini":U THEN ASSIGN pFieldValue = RowObject.fec-ja-ini.
        WHEN "gera-act":U THEN ASSIGN pFieldValue = RowObject.gera-act.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "rec-fisico":U THEN ASSIGN pFieldValue = RowObject.rec-fisico.
        WHEN "tem-moeda1":U THEN ASSIGN pFieldValue = RowObject.tem-moeda1.
        WHEN "tem-moeda2":U THEN ASSIGN pFieldValue = RowObject.tem-moeda2.
        WHEN "utiliza-aprov":U THEN ASSIGN pFieldValue = RowObject.utiliza-aprov.
        WHEN "contr-valid-lote":U THEN ASSIGN pFieldValue = RowObject.contr-valid-lote.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice PARAM-CE
  Parameters:
               recebe valor dos campos do ­ndice PARAM-CE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex)
    &then
    &else
        DEFINE INPUT PARAMETER pseq-param-ce LIKE param-estoq.seq-param-ce NO-UNDO.
    
        FIND FIRST bfparam-estoq WHERE
            bfparam-estoq.seq-param-ce = pseq-param-ce
            NO-LOCK NO-ERROR.
    
        /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
        IF NOT AVAILABLE bfparam-estoq THEN
            RETURN "NOK":U.
    
        /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
              existam erros serÿ retornada flag "NOK":U ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-estoq)).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    &endif
    RETURN "OK":U.
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
           run openQueryMain.
    end. /*end case*/
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
    OPEN QUERY {&QueryName} FOR EACH param-estoq NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDataFechto DBOProgram 
PROCEDURE returnDataFechto :
/*------------------------------------------------------------------------------
  Purpose: Retornar a data do ultimo periodo fechado.
  Notes: Centralizar a l¢gica da procedure pi-verifica-ult-fech-dia
------------------------------------------------------------------------------*/

  def input  param c-cod-estabel   like saldo-terc.cod-estabel   no-undo.
  def output param da-ult-fech-dia like param-estoq.ult-fech-dia no-undo.

  FIND FIRST param-estoq NO-LOCK NO-ERROR.

  if avail param-estoq and param-estoq.tp-fech = 2 then do:
     if not avail estab-mat then 
       find estab-mat
          where estab-mat.cod-estabel = c-cod-estabel no-lock no-error.
     else
       if estab-mat.cod-estabel <> c-cod-estabel then
          find estab-mat where estab-mat.cod-estabel = c-cod-estabel no-lock no-error.

     assign da-ult-fech-dia = estab-mat.ult-fech-dia.
  end.
  else
  if avail param-estoq and param-estoq.tp-fech = 1 then
    assign da-ult-fech-dia = param-estoq.ult-fech-dia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnEnableWMS DBOProgram 
PROCEDURE returnEnableWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pl-enable-wms as log no-undo.

    FIND FIRST param-estoq NO-LOCK NO-ERROR.

    IF AVAIL param-estoq THEN DO:
        ASSIGN pl-enable-wms = if int(substr(param-estoq.char-2,6,1)) = 1 then yes else no.
    END.
    ELSE ASSIGN pl-enable-wms = no. 

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnEstabPadr DBOProgram 
PROCEDURE returnEstabPadr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-estabelec LIKE param-estoq.estabel-pad.
    
    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

    /* Funcao Super/minas */
    &IF DEFINED(Bf_dis_usuario_estab) &THEN
        IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                             AND funcao.ativo     = YES) THEN DO:
           RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                  INPUT-OUTPUT c-cod-estabel-usuar).
        END.
    &ENDIF
    IF AVAIL param-estoq 
    THEN DO:
        ASSIGN p-estabelec = c-cod-estabel-usuar.
    END.
    ELSE ASSIGN p-estabelec = ?. 
   /* Funcao Super/minas */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaMoedas DBOProgram 
PROCEDURE validaMoedas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER tem-moeda1 LIKE param-estoq.tem-moeda1 NO-UNDO.
DEFINE OUTPUT PARAMETER tem-moeda2 LIKE param-estoq.tem-moeda2 NO-UNDO.

FIND FIRST param-estoq NO-LOCK NO-ERROR.
    
IF AVAIL param-estoq  THEN DO:
   ASSIGN tem-moeda1 = IF param-estoq.tem-moeda1 THEN YES ELSE NO
          tem-moeda2 = IF param-estoq.tem-moeda2 THEN YES ELSE NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

