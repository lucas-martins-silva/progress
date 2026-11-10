/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9003Z 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9003Z MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9003z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: ConversÆo das transacoes MGRepOrd para novo formato                       **
**                                                                                         **
**   Includes..: bc9003.i, bc9003z.i, bc9003z.i1                                           **
**                                                                                         **
********************************************************************************************/

{include/i_dbtype.i}
/* End Preprocessor Definitions ---                                                        */

/* Temp-Table Definitions ---                                                              */
{cpp/cp9070.i}
{bcp/bc9003.i}
/* End Temp-Table Definitions ---                                                          */

/* Variable Definitions ---                                                                */
Define Variable h-Ut-Acomp      As Handle       No-Undo.
Define Variable i-Contador      As Integer      No-Undo.
Define Variable i-Cont          As Integer      No-Undo.
Define Variable rw-Transacao    As Raw          No-Undo.
Define Variable c-Transacao     As Character    No-Undo Initial "Reporte".
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

    Create  tt-reporte-ordem-bc.
    Raw-Transfer rw-Transacao To tt-reporte-ordem-bc No-Error.

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
        Create tt-reporte.
        Raw-Transfer rw-Transacao To tt-reporte No-Error.

        For Each tt-reporte-ordem-bc:
            Delete tt-reporte-ordem-bc.
        End.

        Create  tt-reporte-ordem-bc.
        Assign  tt-reporte-ordem-bc.tipo                    = 1
                tt-reporte-ordem-bc.qt-reporte              = tt-reporte.quantidade
                tt-reporte-ordem-bc.it-codigo               = tt-reporte.it-codigo
                tt-reporte-ordem-bc.nro-docto               = tt-reporte.nro-docto
                tt-reporte-ordem-bc.cod-depos               = tt-reporte.cod-depos-d
                tt-reporte-ordem-bc.cod-localiz             = tt-reporte.cod-localiz-d
                tt-reporte-ordem-bc.lote-serie              = tt-reporte.lote
                tt-reporte-ordem-bc.cod-refer               = tt-reporte.cod-refer
                tt-reporte-ordem-bc.dt-vali-lote            = tt-reporte.dt-lote
                tt-reporte-ordem-bc.cod-depos-sai           = tt-reporte.cod-depos-o
                tt-reporte-ordem-bc.cod-local-sai           = tt-reporte.cod-localiz-o
                tt-reporte-ordem-bc.data-transacao          = tt-reporte.dt-trans
                tt-reporte-ordem-bc.cod-unico               = tt-reporte.cod-unico
                tt-reporte-ordem-bc.data                    = tt-reporte.dt-trans
                tt-reporte-ordem-bc.nr-ord-produ            = Integer(tt-reporte.nro-docto).

        Raw-Transfer tt-reporte-ordem-bc To rw-Transacao.

        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
            Assign bc-trans.conteudo-trans = rw-Transacao.
        &Else
            Assign bc-trans.conteudo-trans = String(rw-Transacao).
        &EndIf

        For Each tt-reporte:
            Delete tt-reporte.
        End.

        For Each tt-reporte-ordem-bc:
            Delete tt-reporte-ordem-bc.
        End.

    End.
    Else do:
        For Each tt-reporte-ordem-bc:
            Delete tt-reporte-ordem-bc.
        End.
    End.
End.

Run pi-finalizar In h-Ut-Acomp.
/* End Main Block ---                                                                      */
