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
{include/i-prgvrs.i BOIN385SDFX 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin385sdfx MUT}
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
&GLOBAL-DEFINE DBOName requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName requisicao
&GLOBAL-DEFINE TableLabel requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin385.i RowObject}
{inbo/boin385.i RowObjectDefault}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */

{utp/ut-glob.i}

def new global shared var l-especial as logical no-undo. /* indica que o n£mero da requisiá∆o deve ser sugerido pela faixa de Solic. Especial */

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
         HEIGHT             = 10.71
         WIDTH              = 38.29.
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


{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Habilitar os campos de interface segundo a regra de neg¢cio.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete") 
               pFieldName: Atributo da tabela.
               pFieldEnable: Habilita ou n∆o o atributo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pType        as char               no-undo.
    def input  param pFieldName   as char               no-undo.
    def output param pFieldEnable as log    init yes    no-undo.
        
    {cdp/findparamestoq.i}
    if  not avail param-estoq then
        return "NOK".

    {cdp/findparamcompra.i}
    if  not avail param-compra then
        return "NOK".

    if  pType = "update" then do:
        {cdp/findrequisicao.i RowObject.nr-requisicao}
        if  not avail requisicao then
            return "NOK".
    end.

    case pFieldName:
        when "nr-requisicao" then
            assign pFieldEnable =     pType = "create"
                                  and substr(param-compra.char-2,15,1) = "Y".

        when "cod-estabel" then
            assign pFieldEnable =     (not param-estoq.estab-uni)
                                  and (   pType = "create"
                                       or (    pType = "update"
                                           and not can-find(first it-requisicao
                                                            where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                                              and it-requisicao.qt-atendida   > 0))).

        when "tp-requis" then
            assign pFieldEnable =    pType = "create"
                                  or (    pType = "update"
                                      and not can-find(first it-requisicao
                                                       where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                                         and it-requisicao.qt-atendida   > 0)).
            
    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Executar o leave dos campos para sugest∆o de valores default.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete")
               pFieldName: Atributo da tabela
               RowObject: temp-table com os dados da tela
               RowObjectDefault: temp-table com os dados default
  Notes:       O mÇtodo SetDefaults deve ser executado apenas quando tratar-se
               de uma inclus∆o ou da modificaá∆o de algum campo.
------------------------------------------------------------------------------*/

    def input  param pType        as char no-undo.
    def input  param pFieldName   as char no-undo.
    DEF INPUT  PARAM pConsideraRequisEstoque AS LOG NO-UNDO.
    def input  param table for RowObject.
    def output param table for RowObjectDefault.

    empty temp-table RowObjectDefault.

    find first RowObject no-error.
    
    /* Defaults na inicializaá∆o da tela */
    if  pType      = "create"
    and pFieldName = "" then do:
    
        create RowObjectDefault.

        run setRequestNumber    (output RowObjectDefault.nr-requisicao).
        run setSite             (output RowObjectDefault.cod-estabel).
        run setRequester        (output RowObjectDefault.nome-abrev).
        run setRequestDate      (output RowObjectDefault.dt-requisicao).
        run setRequestType      (input  pConsideraRequisEstoque,
                                 output RowObjectDefault.tp-requis).
        run setState            (output RowObjectDefault.estado).
        run setStatus           (output RowObjectDefault.situacao).

    end.
    /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
    else do:

        if  avail RowObject then do:
            create RowObjectDefault.
            buffer-copy RowObject to RowObjectDefault.
        end.
    end.

    /* Regras de neg¢cio para sugest∆o de valores defaults decorrente do Leave do campo */
    /*case pFieldName:
        when "<nome_do_campo>"    then run leave<nome_do_campo>  (output table RowObjectDefault).       
    end case.*/

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequestDate DBOProgram 
PROCEDURE setRequestDate :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a data de criaá∆o da requisiá∆o
  Parameters:  pDtRequisicao: retornar como data inicial TODAY
  Notes:       
------------------------------------------------------------------------------*/

    def output param pDtRequisicao like requisicao.dt-requisicao no-undo.
               
    assign pDtRequisicao = today.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequester DBOProgram 
PROCEDURE setRequester :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o usu†rio requisitante
  Parameters:  pNomeAbrev: retorna usu†rio respons†vel pela requisiá∆o.
  Notes:       Sugere o usu†rio logado no sistema como requisitante.
------------------------------------------------------------------------------*/

    def output param pNomeAbrev like requisicao.nome-abrev no-undo.

    assign pNomeAbrev = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequestNumber DBOProgram 
PROCEDURE setRequestNumber :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o pr¢ximo n£mero da ordem de compra.
  Parameters:  pNrRequisicao: retorna n£mero da nova requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNrRequisicao  like requisicao.nr-requisicao no-undo.

    def var i-cont                  as int no-undo.

    {cdp/findparamcompra.i}
    if  return-value = "ok" then do:
    
        if l-especial = no then do: /* Solicitaá∆o Manual */
    
            find last requisicao use-index requisicao
                where requisicao.nr-requisicao >= param-compra.prim-solic-man
                  and requisicao.nr-requisicao <= param-compra.ult-solic-man no-lock no-error.
            if  avail requisicao then do:
    
                if  requisicao.nr-requisicao = param-compra.ult-solic-man then do:
    
                    /* procura um n£mero livre na faixa de Solicitaá∆o Manual */
                    assign i-cont = param-compra.prim-solic-man.
                    do while pNrRequisicao  = 0
                         and i-cont <= param-compra.ult-solic-man:
                        if  can-find(first requisicao
                                     where requisicao.nr-requisicao = i-cont) then do:
                             assign i-cont = i-cont + 1.
                             next.
                        end.
                        assign pNrRequisicao = i-cont.
                    end.
                end.
                else
                    assign pNrRequisicao = requisicao.nr-requisicao + 1.
            end.
            else
                assign pNrRequisicao = param-compra.prim-solic-man.
        end.
        else do: /* Solicitaá∆o Especial */
    
            find last requisicao use-index requisicao
                where requisicao.nr-requisicao >= param-compra.prim-solic-esp
                  and requisicao.nr-requisicao <= param-compra.ult-solic-esp no-lock no-error.
    
            if  avail requisicao then do:
    
                if  requisicao.nr-requisicao = param-compra.ult-solic-esp then do:
    
                    /* procura um n£mero livre na faixa de Solicitaá∆o Especial */
                    assign i-cont = param-compra.prim-solic-esp.
                    do while pNrRequisicao  = 0
                         and i-cont <= param-compra.ult-solic-esp:
                        if  can-find(first requisicao
                                     where requisicao.nr-requisicao = i-cont) then do:
                             assign i-cont = i-cont + 1.
                             next.
                        end.
                        assign pNrRequisicao = i-cont.
                    end.
                end.
                else
                    assign pNrRequisicao = requisicao.nr-requisicao + 1.
            end.
            else
                assign pNrRequisicao = param-compra.prim-solic-esp.
        end.
    end.

    /* Verifica numeraá∆o no BH */
    {cdp/findparamglobal.i}
    if  return-value = "ok" then do:

        if  param-global.modulo-bh then do:
            
            find last his-requisicao no-lock no-error.
            if  avail his-requisicao
            and his-requisicao.nr-requisicao >= pNrRequisicao then
                assign pNrRequisicao = his-requisicao.nr-requisicao + 1.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequestType DBOProgram 
PROCEDURE setRequestType :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir como default a inclus∆o de uma Solicitaá∆o de Compra.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF input  PARAM pConsideraRequisEstoque AS LOG NO-UNDO.
    def output param pTpRequis like requisicao.tp-requis no-undo.

    If  pConsideraRequisEstoque then
        assign pTpRequis = 1. /* Requisiá∆o de Estoque */
    else 
        assign pTpRequis = 2. /* Requisiá∆o de Compras */

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSite DBOProgram 
PROCEDURE setSite :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir estabelecimento.
  Parameters:  pCodEstabel: retorna o estabelecimento da requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodEstabel like requisicao.cod-estabel no-undo.

    {cdp/findparamestoq.i}
    if  avail param-estoq then
        assign pCodEstabel = param-estoq.estabel-pad.

    if  can-find(first funcao
                 where funcao.cd-funcao = "fn-estab-usuario"
                   and funcao.ativo) then
        run cdp/cd8702.p (input c-seg-usuario,
                          input-output pCodEstabel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setState DBOProgram 
PROCEDURE setState :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir estado.
  Parameters:  pEstado: retorna o estado da requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pEstado like requisicao.estado no-undo.

    assign pEstado = 2. /* N∆o Aprovado */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setStatus DBOProgram 
PROCEDURE setStatus :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir situaá∆o.
  Parameters:  pSituacao: retorna a situaá∆o da requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pSituacao like requisicao.situacao no-undo.

    assign pSituacao = 1. /* Aberta */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

