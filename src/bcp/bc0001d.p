/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001D 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0001D MBC}
&ENDIF


/*******************************************************************************
**
**   Programa..: bc0001d.p
**
**   Objetivo..: Programa de Inicializaá∆o do OPC
**
*********************************************************************************/

DEFINE VARIABLE cStopFields AS CHARACTER  NO-UNDO
    INITIAL "tipo-rep,cod-ctrab,cod-parada,num-om-progda,dat-inic-parada,hr-inic-parada,dat-fim-parada,hr-fim-parada,val-refer-inic-parada,val-refer-fim-parada,cod-equipe,cod-operador,erro".

DEFINE VARIABLE cReportFields AS CHARACTER  NO-UNDO
    INITIAL "tipo-rep,nr-ord-produ,num-operac-sfc,num-split-operac,cod-roteiro,op-codigo,cod-ctrab,it-codigo,cod-refer,lote-serie,dat-valid-lote,qtd-produzida,cod-motiv-refugo,qtd-refugada,qtd-retrabalho,conta-refugo,dat-inic-rep,hr-inic-rep,dat-fim-rep,hr-fim-rep,dat-inic-setup,hr-inic-setup,dat-fim-setup,hr-fim-setup,cod-equipe,cod-operador,cod-ferramenta,finaliza,linha,erro".

/* Servidor - bc-servid*/
CREATE bc-servid.
ASSIGN bc-servid.cod-servid = "Servidor OPC"
       bc-servid.des-servid = "Servidor Padr∆o OPC"
       bc-servid.idi-sentido-trans = 3 /* Envio e Recebimento */
       bc-servid.num-interv-monit = 60. /* Segundos */

/* Tipo de Equipamento - bc-tip-eqpto */
CREATE bc-tip-eqpto.
ASSIGN bc-tip-eqpto.cod-tip-eqpto = "CLP"
       bc-tip-eqpto.des-tip-eqpto = "Equipamento CLP".

/* Equipamento - bc-eqpto */
CREATE bc-eqpto.
ASSIGN bc-eqpto.cod-eqpto     = "Equipamento CLP"
       bc-eqpto.cod-tip-eqpto = "CLP"
       bc-eqpto.cod-servid    = "Servidor OPC"
       bc-eqpto.des-eqpto     = "Equipamento Padr∆o CLP"
       bc-eqpto.num-seq-eqpto = 1.

/* Transaá∆o do Equipamento - bc-tip-trans-eqpto */
CREATE bc-tip-trans-eqpto.
ASSIGN bc-tip-trans-eqpto.cd-trans             = "Envio"
       bc-tip-trans-eqpto.cod-eqpto            = "Equipamento CLP"
       bc-tip-trans-eqpto.cod-prog-efetivac    = ""
       bc-tip-trans-eqpto.cod-prog-exec        = "bcp/bc0707.p"
       bc-tip-trans-eqpto.cod-prog-validac     = ""
       bc-tip-trans-eqpto.idi-sentido-trans    = 1 /* Envio */
       bc-tip-trans-eqpto.log-reproces-erro    = NO
       bc-tip-trans-eqpto.num-exec-erro        = 0
       bc-tip-trans-eqpto.num-gera-trans       = 1
       bc-tip-trans-eqpto.num-interv-exec-erro = 60 /* Segundos */
       bc-tip-trans-eqpto.num-seq              = 1.

CREATE bc-tip-trans-eqpto.
ASSIGN bc-tip-trans-eqpto.cd-trans             = "Parada"
       bc-tip-trans-eqpto.cod-eqpto            = "Equipamento CLP"
       bc-tip-trans-eqpto.cod-prog-efetivac    = ""
       bc-tip-trans-eqpto.cod-prog-exec        = "bcp/bc0708.p"
       bc-tip-trans-eqpto.cod-prog-validac     = ""
       bc-tip-trans-eqpto.idi-sentido-trans    = 2 /* Recebimento */
       bc-tip-trans-eqpto.log-reproces-erro    = NO
       bc-tip-trans-eqpto.num-exec-erro        = 0
       bc-tip-trans-eqpto.num-gera-trans       = 1
       bc-tip-trans-eqpto.num-interv-exec-erro = 60 /* Segundos */
       bc-tip-trans-eqpto.num-seq              = 2.

CREATE bc-tip-trans-eqpto.
ASSIGN bc-tip-trans-eqpto.cd-trans             = "Reporte"
       bc-tip-trans-eqpto.cod-eqpto            = "Equipamento CLP"
       bc-tip-trans-eqpto.cod-prog-efetivac    = ""
       bc-tip-trans-eqpto.cod-prog-exec        = "bcp/bc0708.p"
       bc-tip-trans-eqpto.cod-prog-validac     = ""
       bc-tip-trans-eqpto.idi-sentido-trans    = 2 /* Recebimento */
       bc-tip-trans-eqpto.log-reproces-erro    = NO
       bc-tip-trans-eqpto.num-exec-erro        = 0
       bc-tip-trans-eqpto.num-gera-trans       = 1
       bc-tip-trans-eqpto.num-interv-exec-erro = 60 /* Segundos */
       bc-tip-trans-eqpto.num-seq              = 3.

/* Vari†veis da Transaá∆o - bc-tip-trans-eqpto-var */
RUN createTransVars IN THIS-PROCEDURE (INPUT "Parada",
                                       INPUT "Equipamento CLP",
                                       INPUT "datacollection.Equipamento CLP.",
                                       INPUT cStopFields).

RUN createTransVars IN THIS-PROCEDURE (INPUT "Reporte",
                                       INPUT "Equipamento CLP",
                                       INPUT "datacollection.Equipamento CLP.",
                                       INPUT cReportFields).
PROCEDURE createTransVars:

    DEFINE INPUT  PARAMETER ipcCdTrans AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcCodEqpto AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcVarPrefix AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcTransVars AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

    DO iCount = 1 TO NUM-ENTRIES(ipcTransVars):

        CREATE bc-tip-trans-eqpto-var.
        ASSIGN bc-tip-trans-eqpto-var.cd-trans                = ipcCdTrans
               bc-tip-trans-eqpto-var.cod-eqpto               = ipcCodEqpto
               bc-tip-trans-eqpto-var.cod-var-dtsul           = ENTRY(iCount, ipcTransVars)
               bc-tip-trans-eqpto-var.cod-var-eqpto           = ipcVarPrefix + ENTRY(iCount, ipcTransVars)
               bc-tip-trans-eqpto-var.ind-val-gerac-trans     = ""
               bc-tip-trans-eqpto-var.ind-val-gerac-trans-ant = ""
               bc-tip-trans-eqpto-var.ind-val-leitura         = ""
               bc-tip-trans-eqpto-var.log-monitora-var        = YES
               bc-tip-trans-eqpto-var.num-seq                 = iCount.
    END.

    RETURN "OK":U.

END PROCEDURE.
