/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9002Z 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9002Z MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9002z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: ConversÆo das transacoes MGContag para novo formato                       **
**                                                                                         **
**   Includes..: bc9002.i, bc9002z.i, bc9002z.i1                                           **
**                                                                                         **
********************************************************************************************/

/* Preprocessor Definitions ---                                                            */
&Global-Define TTNew TT-Contagem-BC

{include/i_dbtype.i}
/* End Preprocessor Definitions ---                                                        */

/* Temp-Table Definitions ---                                                              */
{cep/ce9020.i}
{bcp/bc9002.i}
/* End Temp-Table Definitions ---                                                          */

/* Variable Definitions ---                                                                */
Define Variable h-Ut-Acomp      As Handle       No-Undo.
Define Variable i-Contador      As Integer      No-Undo.
Define Variable i-Cont          As Integer      No-Undo.
Define Variable rw-Transacao    As Raw          No-Undo.
Define Variable c-Transacao     As Character    No-Undo Initial "Contagem".
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
{utp/ut-liter.i Nr.Transa‡Æo:_ *}

    Run pi-acompanhar In h-Ut-Acomp (Input  Return-value  + String(Bc-Trans.Nr-Trans)
                                                            + "   " + String(i-Contador)).

    &If "{&mgcld_dbtype}" = "PROGRESS" &Then
        Assign rw-Transacao = bc-trans.conteudo-trans.
    &Else
        Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                            Output rw-Transacao) No-Error.

        If Error-Status:Error Then Next.
    &EndIf

    Create  tt-contagem-bc.
    Raw-Transfer rw-Transacao To tt-contagem-bc No-Error.

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
        Create tt-contagem.
        Raw-Transfer rw-Transacao To tt-contagem No-Error.

        if  l-erro
        then do:

            For Each tt-contagem-bc:
                Delete tt-contagem-bc.
            End.

            Create  tt-contagem-bc.
            Assign  tt-contagem-bc.cod-estabel            = tt-contagem.cod-estabel
                    tt-contagem-bc.num-ficha-inventario   = tt-contagem.nr-ficha
                    tt-contagem-bc.data-transacao         = bc-trans.data
                    tt-contagem-bc.dat-contagem           = tt-contagem.dt-corte
                    tt-contagem-bc.cod-item               = tt-contagem.it-codigo
                    tt-contagem-bc.cod-unico              = tt-contagem.cod-unico
                    tt-contagem-bc.cod-refer              = tt-contagem.cod-refer
                    tt-contagem-bc.cod-depos              = tt-contagem.cod-depos
                    tt-contagem-bc.cod-local              = tt-contagem.cod-localiz
                    tt-contagem-bc.cod-lote               = tt-contagem.lote
                    tt-contagem-bc.dat-valid-lote         = tt-contagem.dt-vali-lote
                    tt-contagem-bc.cod-usuario            = ""
                    tt-contagem-bc.qtd-apontada           = tt-contagem.quantidade
                    tt-contagem-bc.valor-mat-m            = tt-contagem.valor-mat-m[1]
                    tt-contagem-bc.valor-mob-m            = tt-contagem.valor-mob-m[1]
                    tt-contagem-bc.num-contagem           = tt-contagem.num-contagem
                    tt-contagem-bc.valor-mat-o            = tt-contagem.valor-mat-o[1]
                    tt-contagem-bc.valor-mat-p            = tt-contagem.valor-mat-p[1]
                    tt-contagem-bc.valor-mob-o            = tt-contagem.valor-mob-o[1]
                    tt-contagem-bc.valor-mob-p            = tt-contagem.valor-mob-p[1]
                    tt-contagem-bc.valor-ggf-m            = tt-contagem.valor-ggf-m[1]
                    tt-contagem-bc.valor-ggf-o            = tt-contagem.valor-ggf-o[1]
                    tt-contagem-bc.valor-ggf-p            = tt-contagem.valor-ggf-p[1].

            Raw-Transfer tt-contagem-bc To rw-Transacao.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign bc-trans.conteudo-trans = rw-Transacao.
            &Else
                Assign bc-trans.conteudo-trans = String(rw-Transacao).
            &EndIf
        end.
        For Each tt-contagem:
            Delete tt-contagem.
        End.

        For Each tt-contagem-bc:
            Delete tt-contagem-bc.
        End.
    End.
    Else Do:
        For Each tt-contagem-bc:
            Delete tt-contagem-bc.
        End.
    End.
End.

Run pi-finalizar In h-Ut-Acomp.
/* End Main Block ---                                                                      */
