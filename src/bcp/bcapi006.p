/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI006 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI006 MUT}
&ENDIF


/*************************************************************************
**
**   Programa: BCAPI006     - API de Verifica‡Æo do uso do Coletor
**                                                                       
**   Parametros: tt-coletor - Verifica o Codigo do Coletor
**
**               tt-erro    - Apos a execucao da API contera os possiveis
**                                erros na verifica‡Æo do uso do Coletor
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (05/98)
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}  /* Definicao da temp-table de erros */
{bcp/bcapi006.i} /* Definicao da temp-table de coletor */

def var l-erro as logical init no.

def input-output param table for tt-coletor.
def input-output param table for tt-erro.

def temp-table tt-erro-aux NO-UNDO like tt-erro.

find first tt-coletor no-lock no-error.
if  avail tt-coletor then do:
    /*** Teste da versao de integracao ***/
    if  tt-coletor.cod-versao-integracao <> {&Versao-Integracao} then do:
        run utp/ut-msgs.p (input "msg",
                           input 3941,
                           input "").
        create tt-erro.
        assign tt-erro.i-sequen = 1
               tt-erro.cd-erro  = 3941
               tt-erro.mensagem = return-value
               l-erro = yes.
    end.
    if  tt-coletor.opcao = 1 then do:   /* procura por coletor */
        find first bc-coletor
             where bc-coletor.id-coletor = tt-coletor.coletor
             exclusive-lock no-error.
        if  not available(bc-coletor) then do:
            {utp/ut-liter.i Coletor * r}
            run utp/ut-msgs.p (input "msg",
                               input 56,
                               input trim(return-value)).
            create tt-erro.
            assign tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = trim(return-value)
                   l-erro = yes.
        end.
        else do:
            assign  tt-coletor.ativo            = bc-coletor.ativo
                    tt-coletor.diretorio        = bc-coletor.diretorio
                    tt-coletor.nome-arq         = bc-coletor.nome-arq
                    tt-coletor.tp-coletor       = bc-coletor.tp-coletor
                    tt-coletor.usuario          = bc-coletor.usuario
                    tt-coletor.rowid-coletor    = rowid(bc-coletor).
        end.
    end.
    if  tt-coletor.opcao = 2 then do:    /* procura por rowid */
        find first bc-coletor
             where rowid(bc-coletor) = tt-coletor.rowid-coletor
             no-lock no-error.
        if avail bc-coletor then do:
            assign  tt-coletor.ativo        = bc-coletor.ativo
                    tt-coletor.diretorio    = bc-coletor.diretorio
                    tt-coletor.nome-arq     = bc-coletor.nome-arq
                    tt-coletor.tp-coletor   = bc-coletor.tp-coletor
                    tt-coletor.usuario      = bc-coletor.usuario
                    tt-coletor.coletor      = bc-coletor.id-coletor.
        end.
        else return "NOK".
    end.
end.

find first tt-erro no-error.
if  available(tt-erro) then
    return "NOK".
else
    return "OK".
