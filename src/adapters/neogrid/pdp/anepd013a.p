/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD013A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd013a MAN}
&ENDIF


/*************************************************************************
**    Programa.:                                                        **
**    Objetivo.:  Este programa tem como objetivo validar o campo       **
**                endereáo exportado do CRM, para que o mesmo seja      **
**                enviado corretamente ao SPED, e se o mesmo n∆o        **
**                estiver correto, retornar† uma mensagem informando    **
**                os poss°veis formatos para o campo.                   **
**    Data.....:  Maráo/2009                                            **
*************************************************************************/

/*** Definicao de Parametros ***/
define input    param pc-Endereco       as character    no-undo.
define input    param pc-Pais           as character    no-undo.
define output   param pc-Mensagem       as character    no-undo.
define output   param pl-ErroEndereco   as logical      no-undo.

/*** Definicao de Variaveis ***/
define variable c-Rua       as character    no-undo.
define variable c-Nro       as character    no-undo.
define variable c-Comp      as character    no-undo.

/*** Definicao de Handles ***/
define variable h-cdapi704  as handle       no-undo.

/****************************** Validaá∆o do Endereáo *******************************/
/************************************************************************************/
/************************************* ATENÄ«O **************************************/
/************************************************************************************/
/*** Esta validaá∆o Ç a mesma encontrada no programa cd0704, para tanto se houver ***/
/*** alguma alteraá∆o no mesmo que altere alguma condiá∆o da validaá∆o, esta      ***/
/*** tambÇm dever† ser atualizada para este programa (anepd013a.p), n∆o deixando  ***/
/*** de lado o foco principal deste programa.                                     ***/
/************************************************************************************/

if can-find(first pais where
                  pais.nome-pais = pc-Pais and
                  pais.int-2     = 3) then do: /* Com Bloqueio */

    if not valid-handle(h-cdapi704) then
        run cdp/cdapi704.p persistent set h-cdapi704.
    run pi-trata-endereco in h-cdapi704 (input pc-Endereco, output c-rua, output c-nro, output c-comp).
    delete procedure h-cdapi704.
    assign h-cdapi704 = ?.

    if c-nro = "" then do:
        assign pc-Mensagem = "Formato do endereáo do cliente inv†lido." + "~~" +
                            "N∆o foi poss°vel identificar no endereáo informado os componentes Logradouro e N£mero do Endereáo. Veja abaixo exemplo de formatos v†lidos:" + chr(13) + 
                            "AV. PRESIDENTE COSTA E SILVA, 1178 - SALA 5" + chr(13) + 
                            "AV. GETÈLIO VARGAS 1178 TêRREO"              + chr(13) + 
                            "MARGINAL DA VIA ANCHIETA, KM 23"             + chr(13) + 
                            "RUA MARECHAL DEODORO NR. 251"                + chr(13) + 
                            "RUA VISCONDE DE MAUA N.1890 ED. SENTRA"      + chr(13) + 
                            "AV ANTONIO DE CARVALHO 2600/3108"            + chr(13) + 
                            "AV. TEODOMIRO DA FONSECA, 2173 BL1"          + chr(13) + 
                            "RODOVIA BR 101 - KM29 - IGARASSU"            + chr(13) + 
                            "RUA XV DE NOVEMBRO AP. 121 Nr 415"           + chr(13) + 
                            "AV. BANDEIRA GOMES S/N - ED.MEDSERV"         + chr(13) + 
                            "RUA 1650, NR 900, BLOCO 2".

        assign pl-ErroEndereco = yes.
    end.
    else do:
        assign pl-ErroEndereco = no.
    end.
end. /* if can-find(first pais */
