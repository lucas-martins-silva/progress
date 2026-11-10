/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN280 2.00.00.012 } /*** "010012" 23/11/2023 16:19:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin280 MUT}
&ENDIF


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName param-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName param-compra
&GLOBAL-DEFINE TableLabel param-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

{cdp/cdcfgmat.i} /* prÇ-processadores */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin280.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
        WHEN "nome-ass[1]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[1].
        WHEN "nome-ass[2]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[2].
        WHEN "nome-ass[3]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[3].
        WHEN "cargo-ass[1]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[1].
        WHEN "cargo-ass[2]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[2].
        WHEN "end-cobr-pad":U THEN ASSIGN pFieldValue = RowObject.end-cobr-pad.
        WHEN "end-entr-pad":U THEN ASSIGN pFieldValue = RowObject.end-entr-pad.
        WHEN "cargo-ass[3]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[3].
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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
        WHEN "lim-aprovacao":U THEN ASSIGN pFieldValue = RowObject.lim-aprovacao.
        WHEN "limite[1]":U THEN ASSIGN pFieldValue = RowObject.limite[1].
        WHEN "limite[2]":U THEN ASSIGN pFieldValue = RowObject.limite[2].
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "var-pre-perm":U THEN ASSIGN pFieldValue = RowObject.var-pre-perm.
        WHEN "var-qtd-perm":U THEN ASSIGN pFieldValue = RowObject.var-qtd-perm.
        WHEN "aliq-icm-pad":U THEN ASSIGN pFieldValue = RowObject.aliq-icm-pad.
        WHEN "aliq-iss-pad":U THEN ASSIGN pFieldValue = RowObject.aliq-iss-pad.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "ipi-sobre-preco":U THEN ASSIGN pFieldValue = RowObject.ipi-sobre-preco.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "num-dias-valid-cotac" THEN ASSIGN pFieldValue = RowObject.num-dias-valid-cotac.
        WHEN "num-minimo-cotac" THEN ASSIGN pFieldValue = RowObject.num-minimo-cotac.   
        WHEN "num-pedido-fim":U THEN ASSIGN pFieldValue = RowObject.num-pedido-fim.
        WHEN "num-pedido-ini":U THEN ASSIGN pFieldValue = RowObject.num-pedido-ini.
        WHEN "num-ult-compra":U THEN ASSIGN pFieldValue = RowObject.num-ult-compra.
        WHEN "pend-aprov":U THEN ASSIGN pFieldValue = RowObject.pend-aprov.
        WHEN "prim-ord-man":U THEN ASSIGN pFieldValue = RowObject.prim-ord-man.
        WHEN "prim-solic-aut":U THEN ASSIGN pFieldValue = RowObject.prim-solic-aut.
        WHEN "prim-solic-esp":U THEN ASSIGN pFieldValue = RowObject.prim-solic-esp.
        WHEN "prim-solic-man":U THEN ASSIGN pFieldValue = RowObject.prim-solic-man.
        WHEN "prox-nr-prog":U THEN ASSIGN pFieldValue = RowObject.prox-nr-prog.
        WHEN "prox-ord-aut":U THEN ASSIGN pFieldValue = RowObject.prox-ord-aut.
        WHEN "prox-ord-man":U THEN ASSIGN pFieldValue = RowObject.prox-ord-man.
        WHEN "seq-param-cc":U THEN ASSIGN pFieldValue = RowObject.seq-param-cc.
        WHEN "seq-param-cp":U THEN ASSIGN pFieldValue = RowObject.seq-param-cp.
        WHEN "ult-ord-man":U THEN ASSIGN pFieldValue = RowObject.ult-ord-man.
        WHEN "ult-solic-aut":U THEN ASSIGN pFieldValue = RowObject.ult-solic-aut.
        WHEN "ult-solic-esp":U THEN ASSIGN pFieldValue = RowObject.ult-solic-esp.
        WHEN "ult-solic-man":U THEN ASSIGN pFieldValue = RowObject.ult-solic-man.
        WHEN "var-preco":U THEN ASSIGN pFieldValue = RowObject.var-preco.
        WHEN "var-quantid":U THEN ASSIGN pFieldValue = RowObject.var-quantid.
        WHEN "Docto-aprov":U THEN ASSIGN pFieldValue = RowObject.Docto-aprov.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cdn-format-edital":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                                INT(SUBSTRING(rowObject.char-2,23,5)).
                                                             &ELSE
                                                                rowObject.cdn-format-edital.
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
  Purpose:     Retorna valores dos campos do °ndice PARAM-CC
  Parameters:
               retorna valor dos campos do °ndice PARAM-CC
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pseq-param-cc LIKE param-compra.seq-param-cc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pseq-param-cc = RowObject.seq-param-cc.

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
        WHEN "gera-item-for":U THEN ASSIGN pFieldValue = RowObject.gera-item-for.
        WHEN "imprime-fich":U THEN ASSIGN pFieldValue = RowObject.imprime-fich.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "num-aut-ordem":U THEN ASSIGN pFieldValue = RowObject.num-aut-ordem.
        WHEN "num-aut-pedido":U THEN ASSIGN pFieldValue = RowObject.num-aut-pedido.
        WHEN "perm-aprov-for":U THEN ASSIGN pFieldValue = RowObject.perm-aprov-for.
        WHEN "perm-cot-for":U THEN ASSIGN pFieldValue = RowObject.perm-cot-for.
        WHEN "reaj-preco":U THEN ASSIGN pFieldValue = RowObject.reaj-preco.
        WHEN "trata-pend-aprov":U THEN ASSIGN pFieldValue = RowObject.trata-pend-aprov.
        WHEN "usa-proc":U THEN ASSIGN pFieldValue = RowObject.usa-proc.
        WHEN "utiliza-icm":U THEN ASSIGN pFieldValue = RowObject.utiliza-icm.
        WHEN "utiliza-iss":U THEN ASSIGN pFieldValue = RowObject.utiliza-iss.
        WHEN "utiliza-taxa":U THEN ASSIGN pFieldValue = RowObject.utiliza-taxa.
        WHEN "cria-eve-ped":U THEN ASSIGN pFieldValue = RowObject.cria-eve-ped.
        WHEN "compra-centr":U THEN ASSIGN pFieldValue = RowObject.compra-centr.
        WHEN "cota-aprov":U THEN ASSIGN pFieldValue = RowObject.cota-aprov.
        WHEN "cria-cot-pen":U THEN ASSIGN pFieldValue = RowObject.cria-cot-pen.
        WHEN "cria-eve-cot":U THEN ASSIGN pFieldValue = RowObject.cria-eve-cot.
        WHEN "log-despesa":U THEN ASSIGN pFieldValue = RowObject.log-despesa.
        WHEN "log-multi-unid-medid":U THEN ASSIGN pFieldValue = RowObject.log-multi-unid-medid.
        WHEN "log-param-pregao-eletron":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                                        IF INT(SUBSTRING(rowObject.char-2,22,1)) = 1 THEN YES
                                                                                                                     ELSE NO.
                                                                    &ELSE
                                                                        rowObject.log-param-pregao-eletron.
                                                                    &ENDIF
        &if "{&bf_mat_versao_ems}" >= "2.09" &then
            when "log-integr-portal":U then assign pFieldValue = rowObject.log-integr-portal.
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
  Purpose:     Reposiciona registro com base no °ndice PARAM-CC
  Parameters:
               recebe valor dos campos do °ndice PARAM-CC
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pseq-param-cc LIKE param-compra.seq-param-cc NO-UNDO.

    FIND FIRST bfparam-compra WHERE
        bfparam-compra.seq-param-cc = pseq-param-cc
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QueryName} FOR EACH param-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
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


