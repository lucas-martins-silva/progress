/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9046RP 2.00.00.001 } /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9046rp MIM}
&ENDIF

{include/boerrtab.i} /*Definicao tt-bo-erro*/
{utp/ut-glob.i} /*Variaveis Globais*/

DEFINE TEMP-TABLE tt-itens-ac NO-UNDO
       FIELD it-codigo          LIKE pedido-drb-item.it-codigo
       FIELD nr-ato-concessorio LIKE pedido-drb.nr-ato-concessorio
       FIELD l-item-ato         AS   LOGICAL
       FIELD r-rowid-item       AS   ROWID.

DEFINE TEMP-TABLE tt-param NO-UNDO
       FIELD destino            AS INTEGER
       FIELD arquivo            AS CHARACTER
       FIELD usuario            AS CHARACTER
       FIELD data-exec          AS DATE
       FIELD hora-exec          AS INTEGER.

{include/tt-edit.i} /*Definicao tt-editor*/

{rep/re1005.i01}

{include/i-rpvar.i}
{include/i-rpcab.i}

DEFINE INPUT PARAMETER c-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
DEFINE INPUT PARAMETER c-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
DEFINE INPUT PARAMETER i-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
DEFINE INPUT PARAMETER c-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
DEFINE INPUT PARAMETER ph-bocx312     AS   HANDLE                 NO-UNDO.

DEFINE VARIABLE c-mensagem AS CHARACTER  NO-UNDO.

    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 3
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.arquivo         = SESSION:TEMP-DIRECTORY
                                    + "IM9046RP":U
                                    + ".tmp":U.

    FIND FIRST tt-param NO-ERROR.

    {include/i-rptrm.i}

    {utp/ut-liter.i Itens_com_Saldo_Indispon¡vel_para_Ato_Concess¢rio * R}
    ASSIGN c-titulo-relat = trim(RETURN-VALUE).

    {utp/ut-liter.i Com‚rcio_Exterior * R}
    ASSIGN c-sistema      = TRIM(RETURN-VALUE)
           c-programa     = "im9046RP":U
           c-versao       = "1.00"
           c-revisao      = "000".

    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN PiRetornaTTItensAC IN ph-bocx312 (OUTPUT TABLE tt-itens-ac).

    FIND FIRST docum-est
         WHERE docum-est.serie-docto  = c-serie-docto
           AND docum-est.nro-docto    = c-nro-docto
           AND docum-est.cod-emitente = i-cod-emitente
           AND docum-est.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.

    FOR EACH tt-itens-ac
        WHERE tt-itens-ac.l-item-ato = NO:
        FOR FIRST pedido-drb-item FIELDS(nr-pedido-drb it-codigo)
            WHERE ROWID(pedido-drb-item) = tt-itens-ac.r-rowid-item NO-LOCK:

            FOR FIRST pedido-drb FIELDS(nr-pedido-drb nr-ato-concessorio)
                WHERE pedido-drb.nr-pedido-drb = pedido-drb-item.nr-pedido-drb NO-LOCK:
            END.

            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.parametros = pedido-drb.nr-ato-concessorio + "~~" + pedido-drb-item.it-codigo.
            run utp/ut-msgs.p ( input "help",
                                input 34094,
                                input tt-bo-erro.parametros).  
            
            ASSIGN c-mensagem = RETURN-VALUE.
        
            if  line-counter <= 5 then do:
                put c-cabec1 at 0 skip.
                put c-cabec2 at 0 skip.
            end.
        
            if line-counter > 62 then
               page.
    
            put docum-est.serie-docto at 1.
            put docum-est.nro-docto   at 7.
            put string(docum-est.cod-emitente) at 24 format "x(9)".
            put docum-est.nat-operacao at 35.
            put string(34094,">>>>>9") at 43.
            
            run pi-print-editor (input c-mensagem, input 78).
            for each tt-editor:
                put tt-editor.conteudo at 53 format "X(78)" skip.
            end.
        end.

END.

{include/i-rpclo.i}

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
     DEF INPUT PARAM prg_name      AS CHARACTER.
     DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

{include/pi-edit.i} /*pi-prin-editor*/
