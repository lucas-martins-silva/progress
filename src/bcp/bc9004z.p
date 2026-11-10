/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9004Z 2.00.00.004} /*** "010004" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9004z MBC}
&ENDIF

/********************************************************************************************
**   Programa..: bc9004z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: ConversÆo das transacoes MGReqMcp para novo formato                       **
**                                                                                         **
**   Includes..: bc9004.i, bc9004z.i, bc9004z.i1                                           **
**                                                                                         **
********************************************************************************************/

{include/i_dbtype.i}
/* End Preprocessor Definitions ---                                                        */

/* Temp-Table Definitions ---                                                              */
{cpp/cp9072.i}
{bcp/bc9004.i}
/* End Temp-Table Definitions ---                                                          */

/* Variable Definitions ---                                                                */
Define Variable h-Ut-Acomp      As Handle       No-Undo.
Define Variable i-Contador      As Integer      No-Undo.
Define Variable i-Cont          As Integer      No-Undo.
Define Variable rw-Transacao    As Raw          No-Undo.
Define Variable c-Transacao     As Character    No-Undo Initial "Req-MCP".
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

    Create  tt-requis-mat-bc.
    Raw-Transfer rw-Transacao To tt-requis-mat-bc No-Error.

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
        Create tt-requis.
        Raw-Transfer rw-Transacao To tt-requis No-Error.
        
        For Each tt-requis-mat-bc:
            Delete tt-requis-mat-bc.
        End.

        Create  tt-requis-mat-bc.
        Assign  tt-requis-mat-bc.cod-estabel            = tt-requis.cod-estabel
                tt-requis-mat-bc.nro-docto              = tt-requis.nro-docto
                tt-requis-mat-bc.data-transacao         = tt-requis.dt-trans
                tt-requis-mat-bc.it-codigo              = tt-requis.it-codigo
                tt-requis-mat-bc.cod-unico              = tt-requis.cod-unico
                tt-requis-mat-bc.cod-refer              = tt-requis.cod-refer
                tt-requis-mat-bc.cod-depos              = tt-requis.cod-depos
                tt-requis-mat-bc.cod-localiz            = tt-requis.cod-localiz
                tt-requis-mat-bc.lote                   = tt-requis.lote
                tt-requis-mat-bc.dt-vali-lote           = tt-requis.dt-lote
                tt-requis-mat-bc.quantidade             = tt-requis.quantidade
                tt-requis-mat-bc.nr-ord-produ            = Integer(tt-requis.nro-docto)
                tt-requis-mat-bc.tipo-trans             = 1       /* 1 Requisicao, 2-Devolucao    */
                tt-requis-mat-bc.data-transacao                   = tt-requis.dt-trans
                tt-requis-mat-bc.cod-versao-integracao  = 001
                tt-requis-mat-bc.cod-prog-orig          = "CP-BC9004d".

        Raw-Transfer tt-requis-mat-bc To rw-Transacao.
        
        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
            Assign bc-trans.conteudo-trans = rw-Transacao.
        &Else
            Assign bc-trans.conteudo-trans = String(rw-Transacao).
        &EndIf
        For Each tt-requis:
            Delete tt-requis.
        End.

        For Each tt-requis-mat-bc:
            Delete tt-requis-mat-bc.
        End.
    End.
    Else Do:
        For Each tt-requis-mat-bc:
            Delete tt-requis-mat-bc.
        End.
    End.
End.
Run pi-finalizar In h-Ut-Acomp.
/* End Main Block ---                                                                      */
