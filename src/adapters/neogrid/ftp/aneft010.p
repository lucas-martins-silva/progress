/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT010 2.00.00.025 } /*** "010025" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft010 MAN}
&ENDIF

/*------------------------------------------------------------------------

  File: ANEFT010.P

  Description: Sender de informa‡äes de cr‚dito para o CRM

  Input Parameters:  rw-emitente : Rowid : Rowid do emitente cujo cr‚dito 
                                           deseja-se levantar informa‡äes

  Output Parameters: <none>

  Author: Jean Renato Kormann / Odil B. Neto (log13165)

  Created: 04/03/2003 

------------------------------------------------------------------------*/
/*           This .W file was NOT created with AppBuilder.              */
/*----------------------------------------------------------------------*/

{cdp/cdcfgdis.i}
{include/i-epc200.i}

DEF INPUT PARAM rw-emitente AS ROWID NO-UNDO.

DEF VAR i-empresa      LIKE param-global.empresa-prin         NO-UNDO.
DEF VAR i-ind-aval     LIKE emitente.ind-aval                 NO-UNDO.
DEF VAR cMsgCredito    AS CHAR                                NO-UNDO.
DEF VAR deSaldoCredito AS DEC                                 NO-UNDO.
DEF VAR de-lim-credito AS DEC FORMAT "zzz,zzz,zzz,zzz,zz9.99" NO-UNDO.
def var l-considera-replica-pd as log no-undo.  /*usado na cdapi013.i*/


{pdp/pd9999.i2} /* verifica‡Æo de cr‚dito do cliente */
{cdp/cdapi013.i}  /* definicÆo de TTs para cr‚dito     */
{cdp/cdapi013.i1} /* verifica‡Æo de cr‚dito do cliente */


FIND FIRST para-ped     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.

FIND emitente WHERE ROWID(emitente) = rw-emitente NO-ERROR.

IF  AVAIL emitente THEN DO:
    /*atualiza TT de emitente que ‚ usada para calcular o cr‚dito do cliente corrente*/
    FIND FIRST tt-emitente NO-ERROR.

    IF  AVAIL tt-emitente THEN
        DELETE tt-emitente.

    CREATE tt-emitente.
    ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente
           tt-emitente.nome-abrev   = emitente.nome-abrev
           i-ind-aval               = if  emitente.ind-aval = 2
                                      then 1
                                      else 3.
    RUN  pi-zera-valores.

    /* Seta empresa e estabelecimento */
    ASSIGN i-empresa = param-global.empresa-prin.
    FIND estabelec WHERE estabelec.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.

    &IF DEFINED (bf_dis_consiste_conta) &THEN

        RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                          OUTPUT i-empresa).
    &ENDIF

    RUN pi-seta-empresa-estabel (INPUT i-empresa,
                                 INPUT para-ped.estab-padrao).
    RUN pi-determina-limite (OUTPUT de-lim-credito).
    RUN pi-verifica-pd.  /*daqui retornar  a vari vel de-totvlap, que ‚ o total de pedidos
                           em aberto cuja situa‡Æo de cr‚dito seja Aprovado ou Avaliado*/
    RUN pi-verifica-ft.  /*daqui retornar  a vari vel de-vl-nota, que ‚ o total de notas nÆo
                           atualizadas no CR*/
    RUN pi-saldo-cr (INPUT i-ind-aval).  /*daqui retornar  a vari vel de-saldo-cr, que ‚ o total de
                                           t¡tulos nÆo baixados do cliente no CR*/
    RUN pi-saldo-ap. /*daqui retornar  a vari vel de-saldo-ap, que ‚ o total de t¡tulos nÆo
                       baixados para o fornecedor (no caso, ambos, cliente e fornecedor) no AP*/

    IF  param-global.modulo-mp THEN DO:
        RUN pi-verifica-mp. /*daqui retornarÆo as vari veis mp-vl-ap-abe e mp-vl-cr-abe, que sÆo o
                              total de t¡tulos do cliente no CR e no AP nas demais plantas do grupo
                              empresarial*/
    END.

    ASSIGN deSaldoCredito = de-lim-credito + (de-saldo-ap + mp-vl-ap-abe)
                          - (de-saldo-cr + mp-vl-cr-abe + de-vl-nota + de-totvlap).
    RUN adapters/neogrid/ftp/aneft10a.p (INPUT ROWID(estabelec),
                                         INPUT rowid(emitente), 
                                         INPUT (de-saldo-ap + mp-vl-ap-abe), 
                                         INPUT (de-saldo-cr + mp-vl-cr-abe), 
                                         INPUT de-vl-nota, 
                                         INPUT de-totvlap, 
                                         INPUT deSaldoCredito).
END.

PROCEDURE pi-zera-valores :
    ASSIGN de-saldo-ap  = 0
           de-totvlap   = 0
           de-totvlre   = 0
           de-totvlaa   = 0
           de-vl-nota   = 0
           de-saldo-cr  = 0
           de-saldo-ap  = 0
           de-saldo     = 0
           i-tot-pdap   = 0
           i-tot-pdre   = 0
           i-tot-pdaa   = 0
           i-tot-tit-cr = 0
           mp-vl-cr-abe = 0
           mp-vl-ap-abe = 0.
END PROCEDURE.

procedure pi-executa-upc.

        /************************************************** 
         EPC para determinar o n£mero m ximo de dias em atraso 
         Usado no pi-verifica-pd , da cdapi013.i1   

         **************************************************/

        for each tt-epc
            where tt-epc.cod-event = "replicaPD":
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "replicaPD"
               tt-epc.cod-parameter = "setaReplicaPD"
               tt-epc.val-parameter = "nao".

        {include/i-epc201.i "replicaPD"}

        if can-find (first tt-epc where
                           tt-epc.cod-event     = "replicaPD" and
                           tt-epc.cod-parameter = "setaReplicaPD" and
                           tt-epc.val-parameter = "sim") then
           assign l-considera-replica-pd = yes. 

end procedure.

