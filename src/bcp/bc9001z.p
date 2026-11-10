/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9001Z 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9001z MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9001z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: ConversÆo das transacoes MGTransf para novo formato                       **
**                                                                                         **
**   Includes..: bc9001.i, bc9001z.i, bc9001z.i1                                           **
**                                                                                         **
********************************************************************************************/

{include/i_dbtype.i}
/* End Preprocessor Definitions ---                                                        */

/* Ini Temp-Table Definitions ---                                                          */
{cep/ce9025.i}
{bcp/bc9001.i}
/* End Temp-Table Definitions ---                                                          */

/* Variable Definitions ---                                                                */
Define Variable h-Ut-Acomp      As Handle       No-Undo.
Define Variable i-Contador      As Integer      No-Undo.
Define Variable i-Cont          As Integer      No-Undo.
Define Variable rw-Transacao    As Raw          No-Undo.
Define Variable c-Transacao     As Character    No-Undo Initial "Transf".
Define Variable l-Erro          As Logical      No-Undo.
/* End Variable Definitions ---                                                            */

/* Main Block ---                                                                          */
Run utp/ut-acomp.p Persistent Set h-Ut-Acomp.
Run pi-inicializar In h-Ut-Acomp (Input "Processando Transa‡Æo: " + c-Transacao ).
Run pi-desabilita-cancela In h-Ut-Acomp.

For Each bc-trans Exclusive-Lock
    Where bc-trans.cd-trans = c-Transacao
    On Error Undo, Leave
    On Stop Undo, Leave:

    Assign i-Contador = i-Contador + 1.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Nr.Transa‡Æo" *}
    Run pi-acompanhar In h-Ut-Acomp (Input RETURN-VALUE + ": " + String(Bc-Trans.Nr-Trans)
                                                            + "   " + String(i-Contador)).

    &If "{&mgcld_dbtype}" = "PROGRESS" &Then
        Assign rw-Transacao = bc-trans.conteudo-trans.
    &Else
        Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                            Output rw-Transacao) No-Error.

        If Error-Status:Error Then Next.
    &EndIf

    Create  tt-transfere-bc.
    Raw-Transfer rw-Transacao To tt-transfere-bc No-Error.

    If  Error-Status:Error
    And Error-Status:Num-Messages > 0
    Then do:

        Do i-Cont = 1 To Error-Status:Num-Messages:

            If Error-Status:Get-Number(i-Cont) = 4955
            Then
                Assign l-Erro = yes.
            Else
                Assign l-Erro = no.

        End.
    End.

    If  l-Erro
    Then do:
        Create tt-transfere.
        Raw-Transfer rw-Transacao To tt-transfere No-Error.

        For Each tt-transfere-bc:
            Delete tt-transfere-bc.
        End.

        Create  tt-transfere-bc.
        Assign  tt-transfere-bc.cod-estabel            = tt-transfere.cod-estabel
                tt-transfere-bc.num-documento          = String(tt-transfere.nro-docto)
                tt-transfere-bc.cod-serie-documento    = ""
                tt-transfere-bc.num-especie-documento  = 0
                tt-transfere-bc.data-transacao         = tt-transfere.dt-trans
                tt-transfere-bc.cod-item               = tt-transfere.it-codigo
                tt-transfere-bc.cod-unico              = tt-transfere.cod-unico
                tt-transfere-bc.cod-refer-origem       = ""
                tt-transfere-bc.cod-refer-destino      = ""
                tt-transfere-bc.cod-depos-origem       = tt-transfere.cod-depos-o
                tt-transfere-bc.cod-depos-destino      = tt-transfere.cod-depos-d
                tt-transfere-bc.cod-local-origem       = tt-transfere.cod-localiz-o
                tt-transfere-bc.cod-local-destino      = tt-transfere.cod-localiz-d
                tt-transfere-bc.cod-lote-origem        = tt-transfere.lote-o
                tt-transfere-bc.cod-lote-destino       = ""
                tt-transfere-bc.dat-valid-lote-origem  = ?
                tt-transfere-bc.dat-valid-lote-destino = ?
                tt-transfere-bc.cod-usuario            = ""
                tt-transfere-bc.qtd-movimento          = tt-transfere.quantidade
                tt-transfere-bc.ct-codigo              = ""
                tt-transfere-bc.sc-codigo              = ""
                tt-transfere-bc.num-sequencia          = 0
                tt-transfere-bc.un                     = "".


        Raw-Transfer tt-transfere-bc To rw-Transacao No-Error.

        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
            Assign bc-trans.conteudo-trans = rw-Transacao.
        &Else
            Assign bc-trans.conteudo-trans = String(rw-Transacao).
        &EndIf

        For Each tt-transfere:
            Delete tt-transfere.
        End.

        For Each tt-transfere-bc:
            Delete tt-transfere-bc.
        End.
    End.
    Else Do:
        For Each tt-transfere-bc:
            Delete tt-transfere-bc.
        End.
    End.
End.

Run pi-finalizar In h-Ut-Acomp.
/* End Main Block ---                                                                      */
